<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/19/20
  Time: 1:46 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Update Room</title>
</head>
<body>
<c:set var="updateError" value="${requestScope.UPDATE_ERROR}"/>
<h1>Update Room</h1>
<h2>Name: ${param.roomName}</h2>
<hr>
<form action="MainController" method="post">
    New name: <input type="text" name="newName" value="${param.newName}"/>
    <span style="color:red;">${updateError}</span>
    <input type="hidden" name="roomId" value="${param.roomId}">
    <button type="submit" name="action" value="UpdateRoom">
        Summit Change
    </button>
</form>
<hr>

<c:url var="backToDetailsLink" value="MainController">
    <c:param name="action" value="LoadRoom"/>
    <c:param name="roomId" value="${param.roomId}"/>
</c:url>
<a href="${backToDetailsLink}">Cancel</a>
</body>
</html>
