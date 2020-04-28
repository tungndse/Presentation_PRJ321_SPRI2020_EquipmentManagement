<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/14/20
  Time: 11:30 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Update User</title>
</head>
<body>
<c:set var="updUser" value="${requestScope.USER}"/>
<c:if test="${not empty updUser}">
    <c:set var="errorUpd" value="${updUser.errorInformant}"/>
</c:if>

<h1>Update User</h1>
<hr>
<form id="updateForm" action="MainController" method="post" style="margin-bottom: 0">
    <table>
        <tr>
            <th>Username</th>
            <td>${param.username}</td>
            <input type="hidden" name="username" value="${param.username}"/>
            <td>
                <span style="color: red">
                <c:out value="${errorUpd.usernameError}"/>
                </span>
            </td>
        </tr>
        <tr>
            <th>Given Name</th>
            <td><input type="text" name="givenName" value="${param.givenName}"/></td>
            <td>
                <span style="color: red">
                    <c:out value="${errorUpd.givenNameError}"/>
            </span>
            </td>
        </tr>
        <tr>
            <th>Last Name</th>
            <td><input type="text" name="lastName" value="${param.lastName}"/></td>
            <td>
                <span style="color: red">
                    <c:out value="${errorUpd.lastNameError}"/>
                </span>
            </td>
        </tr>
        <tr>
            <th>Role</th>
            <td>
                <select name="role">
                    <option value="user" ${param.role eq 'user' ? 'selected' : ''}>User</option>
                    <option value="tech" ${param.role eq 'tech' ? 'selected' : ''}>Tech</option>
                    <option value="admin" ${param.role eq 'admin'? 'selected' : ''}>Admin</option>
                </select>
            </td>
        </tr>
        <input type="hidden" name="givenNameSearch" value="${param.givenNameSearch}"/>
        <input type="hidden" name="lastNameSearch" value="${param.lastNameSearch}"/>
        <input type="hidden" name="roomIdSelected" value="${param.roomIdSelected}"/>
    </table>
</form>
<table>
    <tr>
        <td width="50%">
            <button form="updateForm" type="submit" name="action" value="UpdateUser" style="width: 100%">
                Update User
            </button>
        </td>
        <td width="50%">
            <c:url var="backToDetailsLink" value="MainController">
                <c:param name="action" value="LoadUser"/>
                <c:param name="username" value="${param.username}"/>
                <c:param name="givenNameSearch" value="${param.givenNameSearch}"/>
                <c:param name="lastNameSearch" value="${param.lastNameSearch}"/>
                <c:param name="roomIdSelected" value="${param.roomIdSelected}"/>
            </c:url>

            <a href="${backToDetailsLink}">
                <button style="width: 100%;">Cancel</button>
            </a>
        </td>
    </tr>

    <tr>
        <td colspan="2">
            <c:if test="${not empty errorUpd && errorUpd.clean eq false}">
                <span style="color: red"> Unable to update: <c:if
                        test="${empty errorUpd.otherError}">Invalid inputs</c:if>
                    <c:out value="${errorUpd.otherError}"/></span>
            </c:if>
        </td>
    </tr>
</table>
<c:if test="${not empty requestScope.ERROR_TRANSFER}">
    <span style="color: red"><c:out value="${requestScope.ERROR_TRANSFER}"/></span>
</c:if>
</body>
</html>
