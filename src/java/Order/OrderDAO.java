package Order;
/**
 *
 * @author hoang
 */

import Cart.CartItem;
import Utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class OrderDAO {
    
    public double getTodayRevenue() {
        String sql = "SELECT ISNULL(SUM(totalAmount),0) FROM tblOrders "
                   + "WHERE status = 'delivered' AND CAST(createdAt AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public double getMonthRevenue() {
        String sql = "SELECT ISNULL(SUM(totalAmount),0) FROM tblOrders "
                   + "WHERE status = 'delivered' "
                   + "AND MONTH(createdAt) = MONTH(GETDATE()) AND YEAR(createdAt) = YEAR(GETDATE())";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getNewOrdersCount() {
        String sql = "SELECT COUNT(*) FROM tblOrders WHERE status = 'pending'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public String placeOrder(OrderDTO order, Map<String, CartItem> cart) {
        String orderID = java.util.UUID.randomUUID().toString();

        String insertOrder =
            "INSERT INTO tblOrders (orderID, userID, totalAmount, fullName, phone, address, note, paymentMethod, status) "
          + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pending')"; 
          
        String insertDetail =
            "INSERT INTO tblOrderDetails (orderID, productID, productName, size, quantity, price) "
          + "VALUES (?, ?, ?, ?, ?, ?)";

        String updateStock = "UPDATE tblProductSizes SET stock = stock - ? WHERE productID = ? AND size = ?";
        Connection conn = null;
        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false); 
            try (PreparedStatement ps = conn.prepareStatement(insertOrder)) {
                ps.setString(1, orderID);
                ps.setString(2, order.getUserID());
                ps.setDouble(3, order.getTotalAmount());
                ps.setString(4, order.getFullName());
                ps.setString(5, order.getPhone());
                ps.setString(6, order.getAddress());
                ps.setString(7, order.getNote());
                ps.setString(8, order.getPaymentMethod());
                ps.executeUpdate();
            }

            try (PreparedStatement psD = conn.prepareStatement(insertDetail);
                 PreparedStatement psStock = conn.prepareStatement(updateStock)) {
                 
                for (CartItem item : cart.values()) {
                    psD.setString(1, orderID);
                    psD.setString(2, item.getProductID());
                    psD.setString(3, item.getProductName());
                    psD.setString(4, item.getSize());
                    psD.setInt(5, item.getQuantity());
                    psD.setDouble(6, item.getPrice());
                    psD.addBatch();

                    psStock.setInt(1, item.getQuantity());
                    psStock.setString(2, item.getProductID());
                    psStock.setString(3, item.getSize());
                    psStock.addBatch();
                }
                psD.executeBatch();
                psStock.executeBatch(); 
            }

            conn.commit(); 
            return orderID; 
            
        } catch(Exception e) {
            e.printStackTrace();
            try { 
                if (conn != null) conn.rollback();
            }catch(Exception ex){}
        } finally {
            try { if (conn != null) conn.close(); 
            }catch(Exception ex){}
        }
        return null;
    }

    public List<OrderDTO> getOrdersByUser(String userID) {
        String sql = "SELECT * FROM tblOrders WHERE userID = ? ORDER BY createdAt DESC";
        List<OrderDTO> list = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace(); 
        }
        return list;
    }

    public List<OrderDTO> getOrdersByStatus(String status) {
        String sql = "SELECT o.*, u.fullName AS userFullName "
                   + "FROM tblOrders o JOIN tblUsers u ON o.userID = u.userID "
                   + "WHERE o.status = ? "
                   + "ORDER BY o.createdAt DESC";
        List<OrderDTO> list = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDTO o = mapRow(rs);
                    o.setUserFullName(rs.getString("userFullName"));
                    list.add(o);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<OrderDTO> getAllOrders() {
        String sql = "SELECT o.*, u.fullName AS userFullName "
                   + "FROM tblOrders o JOIN tblUsers u ON o.userID = u.userID "
                   + "ORDER BY o.createdAt DESC";
        List<OrderDTO> list = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OrderDTO o = mapRow(rs);
                o.setUserFullName(rs.getString("userFullName"));
                list.add(o);
            }
        }catch(Exception e){ 
            e.printStackTrace();
        }
        return list;
    }

    public OrderDTO getOrderDetail(String orderID) {
        String sql = "SELECT o.*, u.fullName AS userFullName "
                   + "FROM tblOrders o JOIN tblUsers u ON o.userID = u.userID "
                   + "WHERE o.orderID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    OrderDTO o = mapRow(rs);
                    o.setUserFullName(rs.getString("userFullName"));
                    o.setDetails(getDetailsByOrder(orderID));
                    return o;
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return null;
    }

    public boolean cancelOrder(String orderID, String userID) {
        String checkSql = "SELECT status FROM tblOrders WHERE orderID = ? AND userID = ?";
        String cancelSql = "UPDATE tblOrders SET status = 'cancelled' WHERE orderID = ? AND userID = ? AND status = 'pending'";
        String restoreStock = "UPDATE tblProductSizes SET stock = stock + ? WHERE productID = ? AND size = ?";
        Connection conn = null;
        try {
            conn = DBUtils.getConnection();
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setString(1, orderID);
                ps.setString(2, userID);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) return false;
                    String status = rs.getString("status");
                    if (!"pending".equals(status)) return false;
                }
            }
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(cancelSql)) {
                ps.setString(1, orderID);
                ps.setString(2, userID);
                if (ps.executeUpdate() == 0) { conn.rollback(); return false; }
            }
            List<OrderDetailDTO> details = getDetailsByOrder(orderID);
            try (PreparedStatement ps = conn.prepareStatement(restoreStock)) {
                for (OrderDetailDTO d : details) {
                    ps.setInt(1, d.getQuantity());
                    ps.setString(2, d.getProductID());
                    ps.setString(3, d.getSize());
                    ps.addBatch();
                }
                ps.executeBatch();
            }
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception ex) {}
        }
        return false;
    }

    public boolean updateStatus(String orderID, String status) {
        String sql = "UPDATE tblOrders SET status = ? WHERE orderID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, orderID);
            return ps.executeUpdate() > 0;
        }catch(Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private List<OrderDetailDTO> getDetailsByOrder(String orderID) {
        List<OrderDetailDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM tblOrderDetails WHERE orderID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetailDTO d = new OrderDetailDTO();
                    d.setDetailID(rs.getInt("detailID"));
                    d.setOrderID(rs.getString("orderID"));
                    d.setProductID(rs.getString("productID"));
                    d.setProductName(rs.getString("productName"));
                    d.setSize(rs.getString("size"));
                    d.setQuantity(rs.getInt("quantity"));
                    d.setPrice(rs.getDouble("price"));
                    list.add(d);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private OrderDTO mapRow(ResultSet rs) throws SQLException {
        OrderDTO o = new OrderDTO();
        o.setOrderID(rs.getString("orderID"));
        o.setUserID(rs.getString("userID"));
        o.setTotalAmount(rs.getDouble("totalAmount"));
        o.setFullName(rs.getString("fullName"));
        o.setPhone(rs.getString("phone"));
        o.setAddress(rs.getString("address"));
        o.setNote(rs.getString("note"));
        o.setPaymentMethod(rs.getString("paymentMethod"));
        o.setStatus(rs.getString("status"));
        Timestamp ca = rs.getTimestamp("createdAt");
        if (ca != null) o.setCreatedAt(ca.toLocalDateTime());
        return o;
    }
}