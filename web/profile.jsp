<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tài khoản — Fashion Shop</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container section">
  <div class="section-header">
    <h2 class="section-title">Tài khoản của tôi</h2>
  </div>

  <c:if test="${param.msg == 'updated'}">
    <div class="alert alert-success"><i class="fas fa-check-circle"></i> Cập nhật thông tin thành công!</div>
  </c:if>
  <c:if test="${param.msg == 'pwd_changed'}">
    <div class="alert alert-success"><i class="fas fa-check-circle"></i> Đổi mật khẩu thành công!</div>
  </c:if>

  <div style="display:grid;grid-template-columns:240px 1fr;gap:32px;">

    <!-- Sidebar menu -->
    <div>
      <div style="background:var(--c-surface);border-radius:12px;border:1px solid var(--c-border);overflow:hidden;">
        <div style="padding:20px;border-bottom:1px solid var(--c-border);text-align:center;">
          <div style="width:60px;height:60px;background:linear-gradient(135deg,var(--c-accent),var(--c-accent-dk));border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 10px;font-size:24px;color:#fff;">
            ${LOGIN_USER.fullName.charAt(0).toUpperCase()}
          </div>
          <div style="font-weight:600;">${LOGIN_USER.fullName}</div>
          <div style="font-size:12px;color:var(--c-muted);">${LOGIN_USER.email}</div>
        </div>
        <div>
          <a href="MainController?action=UserProfile" style="display:block;padding:12px 20px;font-size:14px;border-bottom:1px solid var(--c-border);background:rgba(200,149,108,.08);color:var(--c-accent);">
            <i class="fas fa-user fa-fw"></i> Thông tin cá nhân
          </a>
          <a href="MainController?action=OrderHistory" style="display:block;padding:12px 20px;font-size:14px;border-bottom:1px solid var(--c-border);color:var(--c-text);">
            <i class="fas fa-box fa-fw"></i> Đơn hàng của tôi
          </a>
          <a href="MainController?action=Logout" style="display:block;padding:12px 20px;font-size:14px;color:var(--c-danger);">
            <i class="fas fa-sign-out-alt fa-fw"></i> Đăng xuất
          </a>
        </div>
      </div>
    </div>

    <!-- Main content -->
    <div style="display:flex;flex-direction:column;gap:24px;">

      <!-- Thông tin cá nhân -->
      <div class="form-card">
        <h3><i class="fas fa-user-edit" style="color:var(--c-accent);margin-right:8px;"></i>Thông tin cá nhân</h3>
        <form action="MainController" method="post" style="margin-top:16px;">
          <input type="hidden" name="action" value="UpdateProfile">
          <div class="form-group">
            <label class="form-label">Họ và tên</label>
            <input type="text" name="fullName" class="form-control" value="${LOGIN_USER.fullName}" required>
          </div>
          <div class="form-group">
            <label class="form-label">Email (không thể thay đổi)</label>
            <input type="email" class="form-control" value="${LOGIN_USER.email}" disabled style="background:var(--c-bg);color:var(--c-muted);">
          </div>
          <div class="form-group">
            <label class="form-label">Số điện thoại</label>
            <input type="tel" name="phone" class="form-control" value="${LOGIN_USER.phone}" placeholder="0901234567">
          </div>
          <div class="form-group">
            <label class="form-label">Địa chỉ mặc định</label>
            <textarea name="address" class="form-control" rows="2">${LOGIN_USER.address}</textarea>
          </div>
          <button type="submit" class="btn btn-primary">
            <i class="fas fa-save"></i> Lưu thay đổi
          </button>
        </form>
      </div>

      <!-- Đổi mật khẩu -->
      <div class="form-card">
        <h3><i class="fas fa-lock" style="color:var(--c-accent);margin-right:8px;"></i>Đổi mật khẩu</h3>

        <c:if test="${not empty PWD_ERROR}">
          <div class="alert alert-danger" style="margin-top:12px;">
            <i class="fas fa-exclamation-circle"></i> ${PWD_ERROR}
          </div>
        </c:if>

        <form action="MainController" method="post" style="margin-top:16px;" onsubmit="return validatePwd(this)">
          <input type="hidden" name="action" value="ChangePassword">
          <div class="form-group">
            <label class="form-label">Mật khẩu hiện tại</label>
            <input type="password" name="oldPassword" class="form-control" placeholder="••••••••" required>
          </div>
          <div class="form-group">
            <label class="form-label">Mật khẩu mới</label>
            <input type="password" name="newPassword" id="newPwd" class="form-control" placeholder="Ít nhất 6 ký tự" required minlength="6">
          </div>
          <div class="form-group">
            <label class="form-label">Xác nhận mật khẩu mới</label>
            <input type="password" name="newPassword2" id="newPwd2" class="form-control" placeholder="••••••••" required>
          </div>
          <div id="pwdMatchErr" style="color:var(--c-danger);font-size:13px;margin-top:-8px;margin-bottom:12px;display:none;">
            Mật khẩu xác nhận không khớp
          </div>
          <button type="submit" class="btn btn-primary">
            <i class="fas fa-key"></i> Đổi mật khẩu
          </button>
        </form>
      </div>

    </div>
  </div>
</div>

<div class="footer"><div class="container"><div class="footer-bottom">© 2026 Fashion Shop.</div></div></div>
<script>
function validatePwd(form) {
  const p1 = form.newPassword.value;
  const p2 = form.newPassword2.value;
  const err = document.getElementById('pwdMatchErr');
  if (p1 !== p2) { err.style.display = 'block'; return false; }
  err.style.display = 'none';
  return true;
}
</script>
</body>
</html>
