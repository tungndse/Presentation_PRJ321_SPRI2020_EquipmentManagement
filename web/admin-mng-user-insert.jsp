<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/14/20
  Time: 10:15 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create New Account</title>
</head>
<body>
<c:set var="newUser" value="${requestScope.USER}"/>
<c:if test="${not empty newUser}">
    <c:set var="errorIns" value="${newUser.errorInformant}"/>
</c:if>

<h1>Create new account</h1>

<form id="insertForm" action="MainController" method="post" style="margin-bottom: 0">
    <table>
        <tr>
            <th>Username</th>
            <td><input type="text" name="username" value="${param.username}"/></td>
            <td>
                <span style="color: red">
                <c:out value="${errorIns.usernameError}"/>
                </span>
            </td>
        </tr>
        <tr>
            <th>Given Name</th>
            <td><input type="text" name="givenName" value="${param.givenName}"/></td>
            <td>
                <span style="color: red">
                    <c:out value="${errorIns.givenNameError}"/>
            </span>
            </td>
        </tr>
        <tr>
            <th>Last Name</th>
            <td><input type="text" name="lastName" value="${param.lastName}"/></td>
            <td>
                <span style="color: red">
                    <c:out value="${errorIns.lastNameError}"/>
                </span>
            </td>
        </tr>
        <tr>
            <th>Password</th>
            <td><input type="password" name="password"/></td>
            <td>
                <span style="color: red">
                    <c:out value="${errorIns.passwordError}"/>
                </span>
            </td>
        </tr>
        <tr>
            <th>Confirm</th>
            <td><input type="password" name="confirm"/></td>
            <td>
                <span style="color: red">
                    <c:out value="${errorIns.confirmError}"/>
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
        <td colspan="2">
            <button form="insertForm" type="submit" name="action" value="InsertAccount" style="width: 100%">
                Create This Account
            </button>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <c:url var="homeLink" value="MainController">
                <c:param name="action" value="SearchUsers"/>
                <c:param name="givenNameSearch" value="${param.givenNameSearch}"/>
                <c:param name="lastNameSearch" value="${param.lastNameSearch}"/>
                <c:param name="roomIdSelected" value="${param.roomIdSelected}"/>
            </c:url>
            <a href="${homeLink}"><button>Cancel</button></a>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <c:if test="${not empty errorIns && errorIns.clean eq false}">
                <span style="color: red"> Unable to create: <c:if
                        test="${empty errorIns.otherError}">Invalid inputs</c:if>
                    <c:out value="${errorIns.otherError}"/></span>
            </c:if>
        </td>
    </tr>
</table>
</body>
</html>
