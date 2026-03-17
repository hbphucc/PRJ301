<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><title>Quản lý đơn hàng — Admin</title></head>
<body>
<div class="admin-layout">
  <jsp:include page="adminNav.jsp"/>
  <div class="admin-content">

    <div class="admin-header">
      <h1>Quản lý đơn hàng</h1>
      <span style="color:var(--c-muted);font-size:14px;">${ORDER_LIST.size()} đơn hàng</span>
    </div>

    <!-- Filter tabs -->
    <div class="filter-bar" style="margin-bottom:24px;">
      <a href="AdminController?action=OrderList"                   class="${empty CURRENT_STATUS          ? 'active' : ''}">Tất cả</a>
      <a href="AdminController?action=OrderList&status=pending"    class="${CURRENT_STATUS == 'pending'    ? 'active' : ''}">Chờ xử lý</a>
      <a href="AdminController?action=OrderList&status=processing" class="${CURRENT_STATUS == 'processing' ? 'active' : ''}">Đang xử lý</a>
      <a href="AdminController?action=OrderList&status=shipped"    class="${CURRENT_STATUS == 'shipped'    ? 'active' : ''}">Đang giao</a>
      <a href="AdminController?action=OrderList&status=delivered"  class="${CURRENT_STATUS == 'delivered'  ? 'active' : ''}">Đã giao</a>
      <a href="AdminController?action=OrderList&status=cancelled"  class="${CURRENT_STATUS == 'cancelled'  ? 'active' : ''}">Đã huỷ</a>
    </div>

    <table class="admin-table">
      <thead>
        <tr>
          <th>Mã đơn</th>
          <th>Khách hàng</th>
          <th>Tổng tiền</th>
          <th>Thanh toán</th>
          <th>Trạng thái</th>
          <th>Ngày đặt</th>
          <th>Hành động</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="order" items="${ORDER_LIST}">
          <tr>
            <td style="font-family:monospace;font-size:12px;">#${order.orderID.substring(0,8).toUpperCase()}</td>
            <td>
              <div>${order.userFullName}</div>
              <div style="font-size:12px;color:var(--c-muted);">${order.phone}</div>
            </td>
            <td style="font-weight:600;color:var(--c-accent);">
              <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> ₫
            </td>
            <td>${order.paymentMethod}</td>
            <td><span class="badge badge-${order.status}">${order.statusLabel}</span></td>
            <td style="font-size:13px;color:var(--c-muted);">${order.formattedDate}</td>
            <td>
              <a href="AdminController?action=OrderDetail&id=${order.orderID}" class="btn btn-outline btn-sm">
                <i class="fas fa-eye"></i> Chi tiết
              </a>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

  </div>
</div>
</body>
</html>
