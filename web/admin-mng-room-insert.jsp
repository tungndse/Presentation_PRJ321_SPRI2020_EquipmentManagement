<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/19/20
  Time: 1:11 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Room insert</title>
</head>
<body>

<c:set var="errorInsert" value="${requestScope.INSERT_ERROR}"/>

<h1>Register new room</h1>
<hr>
<form action="MainController" method="post">
    ID: <input type="text" name="roomId" value="${param.roomId}"/> <span style="color:red;">${errorInsert.idError}</span>
    Name: <input type="text" name="roomName" value="${param.roomName}"/> <span style="color:red;">${errorInsert.nameError}</span>
    <button type="submit" name="action" value="InsertRoom">Save Room</button>
</form>
<hr>
<a href="admin-mng-room.jsp">Back to room management page</a>
</body>
</html>
