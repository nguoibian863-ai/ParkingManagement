<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="model.User"%>
<%
    if (session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    model.User acc = (model.User) session.getAttribute("account");
    if (!"ADMIN".equalsIgnoreCase(acc.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<User> userList = (List<User>) request.getAttribute("userList");
    if (userList == null) userList = java.util.Collections.emptyList();
    Map<String,String> lotMap = (Map<String,String>) request.getAttribute("lotMap");
    if (lotMap == null) lotMap = java.util.Collections.emptyMap();
    String ctx = request.getContextPath();
    String message = (String) session.getAttribute("message");
    if (message != null) session.removeAttribute("message");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Qu&#7843;n l&#253; t&#224;i kho&#7843;n - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/admin/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/admin/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">Danh s&#225;ch t&#224;i kho&#7843;n</h2>
            <% if (message != null) { %><p class="pm-error" style="max-width:600px;"><%= message %></p><% } %>
            <p><a href="<%= ctx %>/admin/user?action=add" class="pm-btn pm-btn-primary" style="width:auto;display:inline-block;padding:10px 20px;">+ Th&#234;m t&#224;i kho&#7843;n</a></p>
            <div class="pm-dash-table-wrap">
                <table class="pm-dash-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>User ID</th>
                            <th>Username</th>
                            <th>H&#7885; t&#234;n</th>
                            <th>Vai tr&#242;</th>
                            <th>B&#227;i l&#224;m vi&#7879;c</th>
                            <th>Tr&#7841;ng th&#225;i</th>
                            <th>Thao t&#225;c</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; i < userList.size(); i++) {
                            User u = userList.get(i);
                        %>
                        <tr>
                            <td><%= i + 1 %></td>
                            <td><%= u.getUserId() %></td>
                            <td><%= u.getUsername() %></td>
                            <td><%= u.getFullname() != null ? u.getFullname() : "" %></td>
                            <td><%= u.getRole() %></td>
                            <td><%= "STAFF".equalsIgnoreCase(u.getRole()) && u.getLotId() != null ? (lotMap.get(u.getLotId()) != null ? lotMap.get(u.getLotId()) : u.getLotId()) : "—" %></td>
                            <td><%= u.isStatus() ? "Ho&#7841;t &#273;&#7897;ng" : "Kh&#243;a" %></td>
                            <td>
                                <a href="<%= ctx %>/admin/user?action=edit&id=<%= u.getUserId() %>" style="margin-right:8px;">S&#7917;a</a>
                                <a href="<%= ctx %>/admin/user?action=reset&id=<%= u.getUserId() %>" onclick="return confirm('Reset m&#7853;t kh&#7849;u th&#224;nh 123?');">Reset MK</a>
                                <a href="<%= ctx %>/admin/user?action=toggle&id=<%= u.getUserId() %>"><%= u.isStatus() ? "Kh&#243;a" : "M&#7903;" %></a>
                                <a href="<%= ctx %>/admin/user?action=delete&id=<%= u.getUserId() %>" onclick="return confirm('X&#243;a t&#224;i kho&#7843;n n&#224;y?');" style="color:var(--pm-danger);">X&#243;a</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
        </main>
    </div>
</body>
</html>
