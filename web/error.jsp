<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 2/19/20
  Time: 4:59 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Equipment Website Error</title>
</head>
<body>
<h1>Error occurred</h1>

<span style="color: red">${requestScope.UNCAUGHT_ERROR}</span>
<c:url var="logoutLink" value="MainController">
    <c:param name="action" value="Logout"/>
</c:url>
<br>
<a href="${logoutLink}">Logout</a>
</body>
</html>
