<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard — Admin</title>
</head>
<body>
<div class="admin-layout">
  <jsp:include page="adminNav.jsp"/>

  <div class="admin-content">
    <div class="admin-header">
      <h1>Dashboard</h1>
      <span style="font-size:13px;color:var(--c-muted);">Xin chào, ${LOGIN_USER.fullName}</span>
    </div>

    <!-- Stats row 1: Tổng quan -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-card__icon">👕</div>
        <div class="stat-card__label">Tổng sản phẩm</div>
        <div class="stat-card__value">${TOTAL_PRODUCTS}</div>
      </div>
      <div class="stat-card">
        <div class="stat-card__icon">📦</div>
        <div class="stat-card__label">Tổng đơn hàng</div>
        <div class="stat-card__value">${TOTAL_ORDERS}</div>
      </div>
      <div class="stat-card" style="border-left:3px solid var(--c-danger);">
        <div class="stat-card__icon">🔔</div>
        <div class="stat-card__label">Đơn chờ xử lý</div>
        <div class="stat-card__value" style="color:var(--c-danger);">${NEW_ORDERS}</div>
      </div>
      <div class="stat-card">
        <div class="stat-card__icon">👥</div>
        <div class="stat-card__label">Người dùng</div>
        <div class="stat-card__value">${TOTAL_USERS}</div>
      </div>
    </div>

    <!-- Stats row 2: Doanh thu -->
    <div class="stats-grid" style="margin-top:16px;">
      <div class="stat-card" style="border-left:3px solid var(--c-accent);">
        <div class="stat-card__icon">💰</div>
        <div class="stat-card__label">Doanh thu hôm nay</div>
        <div class="stat-card__value" style="font-size:18px;color:var(--c-accent);">
          <fmt:formatNumber value="${TODAY_REVENUE}" type="number" groupingUsed="true"/> ₫
        </div>
      </div>
      <div class="stat-card" style="border-left:3px solid var(--c-success);">
        <div class="stat-card__icon">📈</div>
        <div class="stat-card__label">Doanh thu tháng này</div>
        <div class="stat-card__value" style="font-size:18px;color:var(--c-success);">
          <fmt:formatNumber value="${MONTH_REVENUE}" type="number" groupingUsed="true"/> ₫
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-card__icon">🆕</div>
        <div class="stat-card__label">Người dùng mới hôm nay</div>
        <div class="stat-card__value">${NEW_USERS_TODAY}</div>
      </div>
    </div>

    <!-- Quick links -->
    <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-top:28px;">
      <a href="AdminController?action=AddProductForm" class="btn btn-primary" style="justify-content:center;padding:14px;">
        <i class="fas fa-plus"></i> Thêm sản phẩm
      </a>
      <a href="AdminController?action=OrderList&status=pending" class="btn btn-danger" style="justify-content:center;padding:14px;">
        <i class="fas fa-bell"></i> Đơn chờ (${NEW_ORDERS})
      </a>
      <a href="AdminController?action=CategoryList" class="btn btn-outline" style="justify-content:center;padding:14px;">
        <i class="fas fa-tags"></i> Danh mục
      </a>
      <a href="AdminController?action=UserList" class="btn btn-outline" style="justify-content:center;padding:14px;">
        <i class="fas fa-users"></i> Người dùng
      </a>
    </div>
  </div>
</div>
</body>
</html>
