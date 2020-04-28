<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 2/25/20
  Time: 6:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Registration</title>
    <style>
        form {
            margin-bottom: 0;
        }

    </style>
</head>
<body>
<c:set var="regUser" value="${requestScope.USER}"/>
<c:if test="${not empty regUser}">
    <c:set var="errorReg" value="${regUser.errorInformant}"/>
</c:if>

<h1>Account Registration</h1>
<hr>
<form id="registrationForm" action="MainController" method="post">
    <table>
        <tr>
            <th>Username</th>
            <td><input type="text" name="username" value="${regUser.username}"/></td>
            <td>
                <span style="color: red">
                <c:out value="${errorReg.usernameError}"/>
                </span>
            </td>
        </tr>
        <tr>
            <th>Given Name</th>
            <td><input type="text" name="givenName" value="${regUser.givenName}"/></td>
            <td>
                <span style="color: red">
                    <c:out value="${errorReg.givenNameError}"/>
            </span>
            </td>
        </tr>
        <tr>
            <th>Last Name</th>
            <td><input type="text" name="lastName" value="${regUser.lastName}"/></td>
            <td>
                <span style="color: red">
                    <c:out value="${errorReg.lastNameError}"/>
                </span>
            </td>
        </tr>
        <tr>
            <th>Password</th>
            <td><input type="password" name="password"/></td>
            <td>
                <span style="color: red">
                    <c:out value="${errorReg.passwordError}"/>
                </span>
            </td>
        </tr>
        <tr>
            <th>Confirm</th>
            <td><input type="password" name="confirm"/></td>
            <td>
                <span style="color: red">
                    <c:out value="${errorReg.confirmError}"/>
                </span>
            </td>
        </tr>
    </table>
</form>

<table>
    <tr>
        <td width="50%">
            <button form="registrationForm" type="submit" name="action" value="Registration" style="width: 100%">
                Register Account
            </button>
        </td>
        <td width="50%">
            <a href="login.jsp">
                <button style="width: 100%;">Cancel</button>
            </a>
        </td>
    </tr>

    <tr>
        <td colspan="2">
            <c:if test="${not empty errorReg && errorReg.clean eq false}">
                <span style="color: red"> Unable to register: <c:if
                        test="${empty errorReg.otherError}">Invalid inputs</c:if>
                    <c:out value="${errorReg.otherError}"/></span>
            </c:if>
        </td>
    </tr>
</table>


</body>
</html>
