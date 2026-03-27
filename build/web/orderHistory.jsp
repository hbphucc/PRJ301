<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lịch Sử Mua Hàng — Fashion Shop</title>
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container section">
  <div class="section-header">
    <h2 class="section-title">Lịch sử mua hàng</h2>
    <a href="MainController?action=ShoppingPage" class="btn btn-outline btn-sm">← Tiếp tục mua sắm</a>
  </div>

  <c:choose>
    <c:when test="${empty ORDER_LIST}">
      <div style="text-align:center;padding:64px;color:var(--c-muted);">
        <div style="font-size:48px;margin-bottom:16px;">📦</div>
        <h3>Chưa có đơn hàng nào</h3>
        <a href="MainController?action=ShoppingPage" class="btn btn-primary" style="margin-top:16px;">Mua sắm ngay</a>
      </div>
    </c:when>
    <c:otherwise>
      <table class="order-table">
        <thead>
          <tr>
            <th>Mã đơn hàng</th>
            <th>Ngày đặt</th>
            <th>Tổng tiền</th>
            <th>Thanh toán</th>
            <th>Trạng thái</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="order" items="${ORDER_LIST}">
            <tr>
                <td style="font-family:monospace;font-size:12px;">
                  #${fn:toUpperCase(fn:substring(order.orderID, 0, 8))}
                </td>

                <td>
                  ${order.formattedDate}
                </td>

                <td style="font-weight:600;color:var(--c-accent);">
                  <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> ₫
                </td>

                <td>${order.paymentMethod}</td>

                <td>
                  <span class="badge badge-${empty order.status ? 'default' : order.status}">
                    ${order.statusLabel}
                  </span>
                </td>

                <td style="display:flex;gap:8px;align-items:center;">
                  <a href="MainController?action=OrderDetail&id=${order.orderID}" class="btn btn-outline btn-sm">
                    Xem chi tiết
                  </a>
                  <c:if test="${order.status == 'pending'}">
                    <form action="MainController" method="post" style="margin:0;"
                          onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này không?');">
                      <input type="hidden" name="action" value="CancelOrder"/>
                      <input type="hidden" name="id"     value="${order.orderID}"/>
                      <button type="submit" class="btn btn-sm"
                              style="background:#dc3545;color:#fff;border:none;cursor:pointer;">
                        Hủy
                      </button>
                    </form>
                  </c:if>
                </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</div>

<div class="footer"><div class="container"><div class="footer-bottom">© 2026 Fashion Shop.</div></div></div>
</body>
</html>
