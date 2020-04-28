<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/14/20
  Time: 11:56 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>User Details</title>
    <style>
        html {
            height: 100%;
        }

        * {
            margin: 0;
            padding: 0;
        }

        body {
            font: normal .80em 'trebuchet ms', arial, sans-serif;
            background: #F0EFE2;
            color: #777;
        }

        p {
            padding: 0 0 20px 0;
            line-height: 1.7em;
        }

        img {
            border: 0;
        }

        h1, h2, h3, h4, h5, h6 {
            font: normal 175% 'century gothic', arial, sans-serif;
            color: #43423F;
            margin: 0 0 15px 0;
            padding: 15px 0 5px 0;
        }

        h2 {
            font: normal 175% 'century gothic', arial, sans-serif;
            color: #A4AA04;
        }

        h4, h5, h6 {
            margin: 0;
            padding: 0 0 5px 0;
            font: normal 120% arial, sans-serif;
            color: #A4AA04;
        }

        h5, h6 {
            font: italic 95% arial, sans-serif;
            padding: 0 0 15px 0;
            color: #000;
        }

        h6 {
            color: #362C20;
        }

        a, a:hover {
            outline: none;
            text-decoration: underline;
            color: #1293EE;
        }

        a:hover {
            text-decoration: none;
        }

        .left {
            float: left;
            width: auto;
            margin-right: 10px;
        }

        .right {
            float: right;
            width: auto;
            margin-left: 10px;
        }

        .center {
            display: block;
            text-align: center;
            margin: 20px auto;
        }

        blockquote {
            margin: 20px 0;
            padding: 10px 20px 0 20px;
            border: 1px solid #E5E5DB;
            background: #FFF;
        }

        ul {
            margin: 2px 0 22px 17px;
        }

        ul li {
            list-style-type: circle;
            margin: 0 0 6px 0;
            padding: 0 0 4px 5px;
        }

        ol {
            margin: 8px 0 22px 20px;
        }

        ol li {
            margin: 0 0 11px 0;
        }

        #main, #logo, #menubar, #site_content, #footer {
            margin-left: auto;
            margin-right: auto;
        }

        #header {
            background: #025587;
            height: 240px;
        }

        #logo {
            width: 825px;
            position: relative;
            height: 168px;
            background: #025587 url(style/logo.png) no-repeat;
        }

        #logo #logo_text {
            position: absolute;
            top: 20px;
            left: 0;
        }

        #logo h1, #logo h2 {
            font: normal 300% 'century gothic', arial, sans-serif;
            border-bottom: 0;
            text-transform: none;
            margin: 0;
        }

        #logo_text h1, #logo_text h1 a, #logo_text h1 a:hover {
            padding: 22px 0 0 0;
            color: #FFF;
            letter-spacing: 0.1em;
            text-decoration: none;
        }

        #logo_text h1 a .logo_colour {
            color: #80FFFF;
        }

        #logo_text h2 {
            font-size: 100%;
            padding: 4px 0 0 0;
            color: #DDD;
        }

        #menubar {
            width: 877px;
            height: 72px;
            padding: 0;
            background: #29415D url(style/menu.png) repeat-x;
        }

        ul#menu, ul#menu li {
            float: left;
            margin: 0;
            padding: 0;
        }

        ul#menu li {
            list-style: none;
        }

        ul#menu li a {
            letter-spacing: 0.1em;
            font: normal 100% 'lucida sans unicode', arial, sans-serif;
            display: block;
            float: left;
            height: 37px;
            padding: 29px 26px 6px 26px;
            text-align: center;
            color: #FFF;
            text-transform: uppercase;
            text-decoration: none;
            background: transparent;
        }

        ul#menu li a:hover, ul#menu li.selected a, ul#menu li.selected a:hover {
            color: #FFF;
            background: #1C2C3E url(style/menu_select.png) repeat-x;
        }

        #site_content {
            width: 837px;
            overflow: hidden;
            margin: 0 auto 0 auto;
            padding: 20px 24px 20px 37px;
            background: #FFF url(style/content.png) repeat-y;
        }

        .sidebar {
            float: right;
            width: 190px;
            padding: 0 15px 20px 15px;
        }

        .sidebar ul {
            width: 178px;
            padding: 4px 0 0 0;
            margin: 4px 0 30px 0;
        }

        .sidebar li {
            list-style: none;
            padding: 0 0 7px 0;
        }

        .sidebar li a, .sidebar li a:hover {
            padding: 0 0 0 40px;
            display: block;
            background: transparent url(style/link.png) no-repeat left center;
        }

        .sidebar li a.selected {
            color: #444;
            text-decoration: none;
        }

        #content {
            text-align: left;
            width: 595px;
            padding: 0;
        }

        #content ul {
            margin: 2px 0 22px 0px;
        }

        #content ul li {
            list-style-type: none;
            background: url(style/bullet.png) no-repeat;
            margin: 0 0 6px 0;
            padding: 0 0 4px 25px;
            line-height: 1.5em;
        }

        #footer {
            width: 878px;
            font: normal 100% 'lucida sans unicode', arial, sans-serif;
            height: 33px;
            padding: 24px 0 5px 0;
            text-align: center;
            background: #29425E url(style/footer.png) repeat-x;
            color: #FFF;
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }

        #footer a {
            color: #FFF;
            text-decoration: none;
        }

        #footer a:hover {
            color: #FFF;
            text-decoration: underline;
        }

        .search {
            color: #5D5D5D;
            border: 1px solid #BBB;
            width: 134px;
            padding: 4px;
            font: 100% arial, sans-serif;
        }

        .form_settings {
            margin: 15px 0 0 0;
        }

        .form_settings p {
            padding: 0 0 4px 0;
        }

        .form_settings span {
            float: left;
            width: 200px;
            text-align: left;
        }

        .form_settings input, .form_settings textarea {
            padding: 5px;
            width: 299px;
            font: 100% arial;
            border: 1px solid #E5E5DB;
            background: #FFF;
            color: #47433F;
        }

        .form_settings .submit {
            font: 100% arial;
            border: 1px solid;
            width: 99px;
            margin: 0 0 0 212px;
            height: 33px;
            padding: 2px 0 3px 0;
            cursor: pointer;
            background: #263C56;
            color: #FFF;
        }

        .form_settings textarea, .form_settings select {
            font: 100% arial;
            width: 299px;
        }

        .form_settings select {
            width: 310px;
        }

        .form_settings .checkbox {
            margin: 4px 0;
            padding: 0;
            width: 14px;
            border: 0;
            background: none;
        }

        .separator {
            width: 100%;
            height: 0;
            border-top: 1px solid #D9D5CF;
            border-bottom: 1px solid #FFF;
            margin: 0 0 20px 0;
        }

        table {
            margin: 10px 0 30px 0;
        }

        table tr th, table tr td {
            background: #3B3B3B;
            color: #FFF;
            padding: 7px 4px;
            text-align: left;
        }

        table tr td {
            background: #F0EFE2;
            color: #47433F;
            border-top: 1px solid #FFF;
        }
    </style>
</head>
<body>
<c:import url="MainController">
    <c:param name="action" value="ListRooms"/>
</c:import>
<c:set var="roomOptionList" value="${requestScope.ROOM_LIST}"/>
<c:set var="user" value="${requestScope.USER}"/>
<c:url var="profileLink" value="MainController">
    <c:param name="action" value="LoadProfile"/>
</c:url>

<div id="main">
    <div id="header">
        <div id="logo">
            <div id="logo_text">
                <!-- class="logo_colour", allows you to change the colour of the text -->
                <h1>Equipment Website</h1>
                <h2>Simple. Contemporary. Informative.</h2>
            </div>
        </div>
        <div id="menubar">
            <ul id="menu">
                <!-- put class="selected" in the li tag for the selected page - to highlight which page you're on -->
                <li><a href="admin-home.jsp">Home</a></li>
                <li><a href="admin-mng-equipment.jsp">Equipment</a></li>
                <li class="selected"><a href="admin-mng-user.jsp">User</a></li>
                <li><a href="admin-mng-room.jsp">Room</a></li>
                <li><a href="admin-mng-request.jsp">RequestS</a></li>
                <li><a href="admin-mng-stats.jsp">Statistics</a></li>
                <li><a href="${profileLink}">Profile</a></li>
            </ul>
        </div>
    </div>

    <div id="site_content">
        <h1>User Details</h1>

        <table>
            <tr>
                <th>Username</th>
                <td>${user.username}</td>
            </tr>
            <tr>
                <th>Given Name</th>
                <td>${user.givenName}</td>
            </tr>
            <tr>
                <th>Last Name</th>
                <td>${user.lastName}</td>
            </tr>
            <tr>
                <th>Role</th>
                <td>
                    <c:choose>
                        <c:when test="${user.role eq 0}">User Role</c:when>
                        <c:when test="${user.role eq 1}">Tech Role</c:when>
                        <c:when test="${user.role eq 2}">Admin Role</c:when>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th>Currently At</th>
                <td>
            <span style="color:cadetblue;">
                <c:out value="${user.currentRoom.id == '--' ? 'Unassigned' : user.currentRoom.name}"/>
            </span>
                </td>
            </tr>
            <tr>
                <th>Transfer To</th>
                <td>
                    <form id="transferForm" action="MainController" method="post" style="margin-bottom: 0">
                        <select id="roomChange" name="roomIdChanged">
                            <c:forEach var="room" items="${roomOptionList}">
                                <option value="${room.id}"
                                    ${user.currentRoom.id == room.id && user.currentRoom.id != '--'?
                                            'selected' : ''}>
                                        ${room.name}
                                </option>
                            </c:forEach>
                        </select>
                        <input type="hidden" name="username" value="${user.username}"/>
                        <input type="hidden" name="givenNameSearch" value="${param.givenNameSearch}"/>
                        <input type="hidden" name="lastNameSearch" value="${param.lastNameSearch}"/>
                        <input type="hidden" name="roomIdSelected" value="${param.roomIdSelected}"/>
                    </form>
                </td>
            </tr>
            <tr>

                <td colspan="2">
                    <button form="transferForm" type="submit" name="action" value="MoveUserFromDetails"
                            style="width: 100%; height: 1cm">Transfer
                    </button>

                    <form action="MainController" method="post">
                        <input type="hidden" name="username" value="${user.username}"/>
                        <input type="hidden" name="givenNameSearch" value="${param.givenNameSearch}"/>
                        <input type="hidden" name="lastNameSearch" value="${param.lastNameSearch}"/>
                        <input type="hidden" name="roomIdSelected" value="${param.roomIdSelected}"/>
                        <input type="hidden" name="givenName" value="${user.givenName}"/>
                        <input type="hidden" name="lastName" value="${user.lastName}"/>
                        <input type="hidden" name="role" value="${user.role}"/>

                        <button type="submit" name="action" value="ForwardUserUpdate" style="width: 100%; height: 1cm">
                            Update User
                        </button>
                        <button type="submit" name="action" value="DeleteUser"
                                style="background-color: red;width: 100%; height: 1cm">Ban User
                        </button>

                    </form>
                </td>
            </tr>
        </table>
        <c:if test="${not empty requestScope.DELETE_ERROR}">
            <span style="color: red"><c:out value="${requestScope.DELETE_ERROR}"/>
            </span>
        </c:if>
        <hr>
        <c:url var="userMngLink" value="MainController">
            <c:param name="action" value="SearchUsers"/>
            <c:param name="givenNameSearch" value="${param.givenNameSearch}"/>
            <c:param name="lastNameSearch" value="${param.lastNameSearch}"/>
            <c:param name="roomIdSelected" value="${param.roomIdSelected}"/>
        </c:url>
        <a href="${userMngLink}">Back to user management page</a>
    </div>
</div>


<%--<h1>User Details</h1>

<table>
    <tr>
        <th>Username</th>
        <td>${user.username}</td>
    </tr>
    <tr>
        <th>Given Name</th>
        <td>${user.givenName}</td>
    </tr>
    <tr>
        <th>Last Name</th>
        <td>${user.lastName}</td>
    </tr>
    <tr>
        <th>Role</th>
        <td>
            <c:choose>
                <c:when test="${user.role eq 0}">User Role</c:when>
                <c:when test="${user.role eq 1}">Tech Role</c:when>
                <c:when test="${user.role eq 2}">Admin Role</c:when>
            </c:choose>
        </td>
    </tr>
    <tr>
        <th>Currently At</th>
        <td>
            <span style="color:cadetblue;">
                <c:out value="${user.currentRoom.id == '--' ? 'Unassigned' : user.currentRoom.name}"/>
            </span>
        </td>
    </tr>
    <tr>
        <th>Transfer To</th>
        <td>
            <form action="MainController" method="post" style="margin-bottom: 0">
                <select id="roomChange" name="roomIdChanged">
                    <c:forEach var="room" items="${roomOptionList}">
                        <option value="${room.id}"
                            ${user.currentRoom.id == room.id && user.currentRoom.id != '--'?
                                    'selected' : ''}>
                                ${room.name}
                        </option>
                    </c:forEach>
                </select>
                <input type="hidden" name="username" value="${user.username}"/>
                <input type="hidden" name="givenNameSearch" value="${param.givenNameSearch}"/>
                <input type="hidden" name="lastNameSearch" value="${param.lastNameSearch}"/>
                <input type="hidden" name="roomIdSelected" value="${param.roomIdSelected}"/>
                <button type="submit" name="action" value="MoveUserFromDetails">Commit Transfer</button>
            </form>
        </td>
        <td style="font-style: oblique">Leave it be if transfer not</td>
    </tr>
</table>
<form action="MainController" method="post">
    <input type="hidden" name="username" value="${user.username}"/>
    <input type="hidden" name="givenNameSearch" value="${param.givenNameSearch}"/>
    <input type="hidden" name="lastNameSearch" value="${param.lastNameSearch}"/>
    <input type="hidden" name="roomIdSelected" value="${param.roomIdSelected}"/>
    <input type="hidden" name="givenName" value="${user.givenName}"/>
    <input type="hidden" name="lastName" value="${user.lastName}"/>
    <input type="hidden" name="role" value="${user.role}"/>

    <button type="submit" name="action" value="DeleteUser">Ban User</button>
    <button type="submit" name="action" value="ForwardUserUpdate">Update User</button>
</form>
<c:url var="userMngLink" value="MainController">
    <c:param name="action" value="SearchUsers"/>
    <c:param name="givenNameSearch" value="${param.givenNameSearch}"/>
    <c:param name="lastNameSearch" value="${param.lastNameSearch}"/>
    <c:param name="roomIdSelected" value="${param.roomIdSelected}"/>
</c:url>
<a href="${userMngLink}">Back to user management page</a>
<c:if test="${not empty requestScope.DELETE_ERROR}">
    <span style="color: red">
        <c:out value="${requestScope.DELETE_ERROR}"/></span>
</c:if>--%>
</body>
</html>
