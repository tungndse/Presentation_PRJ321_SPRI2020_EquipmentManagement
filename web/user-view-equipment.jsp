<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/18/20
  Time: 3:01 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
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
<c:url var="profileLink" value="MainController">
    <c:param name="action" value="LoadProfile"/>
</c:url>
<c:set var="sessionUser" value="${sessionScope.SESSION_USER}"/>
<c:set var="equipmentList" value="${requestScope.EQUIPMENT_LIST}"/>
<c:set var="equipmentListError" value="${requestScope.EQUIPMENT_LIST_ERROR}"/>

<!-- MAIN --------->
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
                <li><a href="user-home.jsp">Home</a></li>
                <li class="selected"><a href="user-view-equipment.jsp">Equipment</a></li>
                <li><a href="user-view-request.jsp">Requests</a></li>
                <li><a href="${profileLink}">Profile</a></li>
            </ul>
        </div>
    </div>

    <div id="site_content">
        <div id="content">
            <h3>User</h3>
            <h4><c:out value="${sessionUser.givenName}"/> <c:out value="${sessionUser.lastName}"/></h4>
            <h5>Logged in at <fmt:formatDate value="${sessionUser.timeLogin}" pattern="HH:mm EEE, dd/MM/yyyy"/> as
                <c:out value="${sessionUser.username}"/></h5>
            <hr>
            <c:if test="${not empty equipmentListError}">
                <span style="color: red"><c:out value="${equipmentListError}"/></span>
            </c:if>

            <form id="defaultSearchForm" action="MainController" method="post" style="margin-bottom: 0">
                <table>
                    <tr>
                        <th colspan="2" style="color: #207cff">Search</th>
                    </tr>
                    <tr>
                        <th style="text-align: left">Filter by Status</th>
                        <td><select name="equipmentStatusSelect">
                            <option value="fine" ${param.equipmentStatusSelect == 'fine' ? 'selected' : ''}>
                                Good
                            </option>
                            <option value="broken" ${param.equipmentStatusSelect == 'broken' ? 'selected' : ''}>
                                Broken
                            </option>
                        </select></td>
                    </tr>
                    <tr>
                        <th style="text-align: left">Sort by Warranty</th>
                        <td><input type="checkbox" name="warrantySort"
                                   checked="${not empty param.warrantySort ? 'checked': ''}"/></td>
                    </tr>
                    <tr>
                        <th style="text-align: left">Sort by DateBought</th>
                        <td><input type="checkbox" name="dateBoughtSort"
                                   checked="${not empty param.dateBoughtSort ? 'checked': ''}"/></td>
                    </tr>
                    <tr>
                        <th style="text-align: left">Sort by Time Repaired</th>
                        <td><input type="checkbox" name="timeRepairedSort"
                                   checked="${not empty param.timeRepairedSort ? 'checked': ''}"/></td>
                    </tr>
                    <tr>
                        <td>
                            <button type="submit" name="action" value="SearchEquipments" style="width: 100%">
                                Begin Search
                            </button>
                        </td>
                    </tr>

                </table>
            </form>

            <c:if test="${not empty equipmentList}">
                <table>
                    <tr>
                        <th>No</th>
                        <th>Id</th>
                        <th>Name</th>
                        <th>Date Bought</th>
                        <th>Warranty</th>
                        <th>Date Expired</th>
                        <th>Time Repaired</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Currently At</th>
                        <th>Action</th>
                    </tr>
                    <c:forEach var="equipment" items="${equipmentList}" varStatus="counter">
                        <tr>
                            <td>${counter.count}</td>
                            <td>
                                <c:url var="detailsLink" value="MainController">
                                    <c:param name="action" value="LoadEquipment"/>
                                    <c:param name="equipmentId" value="${equipment.id}"/>
                                    <!--- SEARCH PARAMS HERE -->
                                    <c:param name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
                                    <c:param name="warrantySort" value="${param.warrantySort}"/>
                                    <c:param name="dateBoughtSort" value="${param.dateBoughtSort}"/>
                                    <c:param name="timeRepairedSort" value="${param.timeRepairedSort}"/>
                                </c:url>
                                <a href="${detailsLink}">${equipment.id}</a>
                            </td>
                            <td>${equipment.name}</td>
                            <td><fmt:formatDate value="${equipment.dateBought}" pattern="dd/MM/yyyy"/></td>
                            <td>${equipment.warranty}</td>
                            <td><fmt:formatDate value="${equipment.dateExpired}" pattern="dd/MM/yyyy"/></td>
                            <td>${equipment.timeRepaired}</td>
                            <td>${equipment.type.name}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${equipment.status == -1}">
                                        Retired
                                    </c:when>
                                    <c:when test="${equipment.status == 0}">
                                        Broken
                                    </c:when>
                                    <c:when test="${equipment.status == 1}">
                                        Good
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>${equipment.currentRoom.name}</td>
                            <td>
                                <c:if test="${not empty equipment.currentRequest}">
                                    <c:if test="${equipment.currentRequest.requestStatus == 0}">
                                        <span style="color:red;">Requested</span>
                                    </c:if>
                                    <c:if test="${equipment.currentRequest.requestStatus == 1}">
                                        <span style="color:limegreen;">Being repaired</span>
                                    </c:if>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>

            <hr>
            <!-- ESCAPE ----------------->
            <c:url var="logoutLink" value="MainController">
                <c:param name="action" value="Logout"/>
            </c:url>
            <a href="${logoutLink}">Log out</a>
        </div>
    </div>

</div>


</body>
</html>
