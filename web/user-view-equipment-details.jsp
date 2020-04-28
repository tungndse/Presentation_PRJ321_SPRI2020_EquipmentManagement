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

        /*.sidebar {
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
        }*/

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
<c:set var="equipment" value="${requestScope.EQUIPMENT}"/>
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
                <li><a href="user-home.jsp">Home</a></li>
                <li class="selected"><a href="user-view-equipment.jsp">Equipment</a></li>
                <li><a href="user-view-request.jsp">Requests</a></li>
                <li><a href="${profileLink}">Profile</a></li>
            </ul>
        </div>
    </div>

    <div id="site_content">
        <table>
            <tr>
                <!-- Details Panel ----------------------------->
                <td style="width: 50%">
                    <table>
                        <tr>
                            <td colspan="2"><h2>Details</h2></td>
                        </tr>
                        <tr>
                            <th style="text-align: left">Id</th>
                            <td>${equipment.id}</td>
                        </tr>
                        <tr>
                            <th style="text-align: left">Name</th>
                            <td>${equipment.name}</td>
                        </tr>
                        <tr>
                            <th style="text-align: left">Type</th>
                            <td>${equipment.type.name}</td>
                        </tr>
                        <tr>
                            <th style="text-align: left">Warranty</th>
                            <td>${equipment.warranty}</td>
                        </tr>
                        <tr>
                            <th style="text-align: left">Repaired</th>
                            <td>${equipment.timeRepaired} time(s)</td>
                        </tr>
                        <tr>
                            <th style="text-align: left">Date Bought</th>
                            <td><fmt:formatDate value="${equipment.dateBought}" pattern="dd/MM/yyyy"/></td>
                        </tr>
                        <tr>
                            <th style="text-align: left">Status</th>
                            <td>
                                <c:if test="${equipment.status == 0}">
                                    <span style="color: red">Broken</span>
                                </c:if>
                                <c:if test="${equipment.status == 1}">
                                    <span style="color: chartreuse;">Good</span>
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th colspan="2" style="text-align: left">Description</th>
                        </tr>
                        <tr>
                            <td colspan="2">${equipment.description}</td>
                        </tr>
                        <tr>
                            <!-- Active Request cell -->
                            <td colspan="4" style="text-align: left">
                                <c:set var="request" value="${equipment.currentRequest}"/>
                                <c:if test="${not empty request}">
                                    <c:url var="viewRequestLink" value="MainController">
                                        <c:param name="action" value="ViewRequestAsUser"/>
                                        <c:param name="requestId" value="${request.id}"/>
                                        <c:param name="equipmentId" value="${equipment.id}"/>

                                        <!-- SEARCH PARAM ON EQUIPMENT MNG PAGE --->
                                        <c:param name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
                                        <c:param name="warrantySort" value="${param.warrantySort}"/>
                                        <c:param name="dateBoughtSort" value="${param.dateBoughtSort}"/>
                                        <c:param name="timeRepairedSort" value="${param.timeRepairedSort}"/>
                                    </c:url>
                                    <span style="color: darkcyan;">
                                <c:if test="${request.requestStatus == 0}">
                                    Equipment requested for repairing by ${request.requester.username}
                                </c:if>
                                <c:if test="${request.requestStatus == 1}">
                                    Equipment is being worked on by ${request.executor.username}
                                </c:if>
                                <hr>
                            </span>
                                    <a href="${viewRequestLink}">View Request</a>
                                </c:if>
                                <c:if test="${empty request}">
                                    <c:url var="makeRequestLink" value="MainController">
                                        <c:param name="action" value="ForwardRequestInsert"/>
                                        <c:param name="equipmentId" value="${equipment.id}"/>
                                        <c:param name="equipmentName" value="${equipment.name}"/>
                                        <c:param name="equipmentType" value="${equipment.type.name}"/>
                                        <c:param name="dateBought" value="${equipment.dateBought}"/>
                                        <c:param name="warranty" value="${equipment.warranty}"/>
                                        <c:param name="timeRepaired" value="${equipment.timeRepaired}"/>

                                        <!-- SEARCH PARAM ON EQUIPMENT MNG PAGE --->
                                        <c:param name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
                                        <c:param name="warrantySort" value="${param.warrantySort}"/>
                                        <c:param name="dateBoughtSort" value="${param.dateBoughtSort}"/>
                                        <c:param name="timeRepairedSort" value="${param.timeRepairedSort}"/>
                                    </c:url>
                                    <a href="${makeRequestLink}">Request for repairing</a>
                                </c:if>
                            </td>
                        </tr>
                    </table>
                </td>

                <td><!-- $pageContext.request.contextPath -->
                    <img src="<c:url value='${equipment.imagePath}'/>" alt="No image yet" width="500" height="333"/>
                </td>

            </tr>
        </table>

        <hr>

        <c:set var="locationEntries" value="${equipment.locationEntries}"/>
        <table>
            <c:if test="${not empty equipment.locationEntries}">
                <h2>Location History</h2>
                <tr>
                    <th>Time Transferred</th>
                    <th>To Room</th>
                    <th>Transferred By</th>
                    <th>Reason</th>
                </tr>

                <c:forEach var="entry" items="${locationEntries}">
                    <tr>
                        <td><fmt:formatDate value="${entry.fromDate}" pattern="HH:mm EEE, dd/MM/yyyy"/></td>
                        <td>${entry.room.name}</td>
                        <td>${entry.byUserId}</td>
                        <td>${entry.reason}</td>
                    </tr>
                </c:forEach>
            </c:if>
            <tr>
                <td colspan="4">
                    <hr>
                </td>
            </tr>
            <tr>
                <c:if test="${not empty equipment.currentRoom}">
                    <th style="text-align: left">Current Location</th>
                    <td colspan="2">${equipment.currentRoom.name}</td>
                </c:if>
                <c:if test="${empty equipment.currentRoom}">
                    <td colspan="2">Not assigned</td>
                </c:if>
            </tr>
        </table>

        <hr>
        <!-- REPAIR HISTORY ----------->
        <c:if test="${not empty equipment.reportList}">
            <h2>Repair History</h2>
            <table>
                <tr>
                    <td>No</td>
                    <th>Requester</th>
                    <th>Time Requested</th>
                    <th>Handled By</th>
                    <th>Time Began</th>
                    <th>Time Done</th>
                    <th>Result</th>
                    <th>More</th>
                </tr>
                <c:forEach var="report" items="${equipment.reportList}" varStatus="counter">
                    <tr>
                        <td>${counter.count}</td>
                        <td>${report.requester.username}</td>
                        <td><fmt:formatDate value="${report.timeRequested}" pattern="HH:mm dd-MM-yyyy"/></td>
                        <td>${report.executor.username}</td>
                        <td><fmt:formatDate value="${report.timeBegin}" pattern="HH:mm dd-MM-yyyy"/></td>
                        <td><fmt:formatDate value="${report.timeDone}" pattern="HH:mm dd-MM-yyyy"/></td>
                        <td>
                            <c:if test="${report.success eq true}">
                                <span style="color: limegreen">Success</span>
                            </c:if>
                            <c:if test="${report.success eq false}">
                                <span style="color: red">Fail</span>
                            </c:if>
                        </td>
                        <td>
                            <c:url var="reportDetailsLink" value="MainController">
                                <c:param name="action" value="ViewReport"/>
                                <!-- DETAILS PARAMS --------------->
                                <c:param name="equipmentId" value="${equipment.id}"/>
                                <c:param name="equipmentName" value="${equipment.name}"/>
                                <c:param name="equipmentTypeName" value="${equipment.type.name}"/>

                                <c:param name="requesterId" value="${report.requester.username}"/>
                                <c:param name="requesterGivenName" value="${report.requester.givenName}"/>
                                <c:param name="requesterLastName" value="${report.requester.lastName}"/>

                                <c:param name="executorUsername" value="${report.executor.username}"/>
                                <c:param name="executorGivenName" value="${report.executor.givenName}"/>
                                <c:param name="executorLastName" value="${report.executor.lastName}"/>

                                <c:param name="requestDescription" value="${report.requestDescription}"/>
                                <c:param name="repairDiary" value="${report.repairDiary}"/>
                                <c:param name="timeRequest" value="${report.timeRequested}"/>
                                <c:param name="timeBegin" value="${report.timeBegin}"/>
                                <c:param name="timeDone" value="${report.timeDone}"/>
                                <c:param name="reportResult" value="${report.success}"/>

                                <!-- SEARCH PARAM ON EQUIPMENT MNG PAGE --->
                                <c:param name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
                                <c:param name="warrantySort" value="${param.warrantySort}"/>
                                <c:param name="dateBoughtSort" value="${param.dateBoughtSort}"/>
                                <c:param name="timeRepairedSort" value="${param.timeRepairedSort}"/>
                            </c:url>
                            <a href="${reportDetailsLink}">
                                Read
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>
        <hr>

        <c:url var="equipmentMngLink" value="MainController">
            <c:param name="action" value="SearchEquipments"/>
            <!-- SEARCH PARAM ON EQUIPMENT MNG PAGE --->
            <c:param name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
            <c:param name="warrantySort" value="${param.warrantySort}"/>
            <c:param name="dateBoughtSort" value="${param.dateBoughtSort}"/>
            <c:param name="timeRepairedSort" value="${param.timeRepairedSort}"/>
        </c:url>
        <a href="${equipmentMngLink}">Back to equipments view</a>
    </div>
</div>

<%--
<hr>
<h1 style="text-align: center">Equipment Details</h1>
<hr>

<!--- DETAILS OF EQUIPMENTS ---->
<table>
    <tr>
        <!-- Details Panel ----------------------------->
        <td>
            <table>
                <tr>
                    <td colspan="4"><h2>Details</h2></td>
                </tr>
                <tr>
                    <th style="text-align: left">Id</th>
                    <td>${equipment.id}</td>
                    <th style="text-align: left">Name</th>
                    <td>${equipment.name}</td>
                </tr>
                <tr>
                    <th style="text-align: left">Type</th>
                    <td>${equipment.type.name}</td>
                    <th style="text-align: left">Warranty</th>
                    <td>${equipment.warranty}</td>
                </tr>
                <tr>
                    <th style="text-align: left">Time Repaired</th>
                    <td>${equipment.timeRepaired} time(s)</td>
                    <th style="text-align: left">Date Bought</th>
                    <td><fmt:formatDate value="${equipment.dateBought}" pattern="dd/MM/yyyy"/></td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td>
                        <c:if test="${equipment.status == 0}">
                            <span style="color: red">Broken</span>
                        </c:if>
                        <c:if test="${equipment.status == 1}">
                            <span style="color: chartreuse;">Good</span>
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <th colspan="4" style="text-align: left">Description</th>
                </tr>
                <tr>
                    <td colspan="4">${equipment.description}</td>
                </tr>

                <tr>
                    <!-- Active Request cell -->
                    <td colspan="4" style="text-align: left">
                        <c:set var="request" value="${equipment.currentRequest}"/>
                        <c:if test="${not empty request}">
                            <c:url var="viewRequestLink" value="MainController">
                                <c:param name="action" value="ViewRequestAsUser"/>
                                <c:param name="requestId" value="${request.id}"/>
                                <c:param name="equipmentId" value="${equipment.id}"/>

                                <!-- SEARCH PARAM ON EQUIPMENT MNG PAGE --->
                                <c:param name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
                                <c:param name="warrantySort" value="${param.warrantySort}"/>
                                <c:param name="dateBoughtSort" value="${param.dateBoughtSort}"/>
                                <c:param name="timeRepairedSort" value="${param.timeRepairedSort}"/>
                            </c:url>
                            <span style="color: darkcyan;">
                                <c:if test="${request.requestStatus == 0}">
                                    Equipment requested for repairing by ${request.requester.username}
                                </c:if>
                                <c:if test="${request.requestStatus == 1}">
                                    Equipment is being worked on by ${request.executor.username}
                                </c:if>
                                <hr>
                            </span>
                            <a href="${viewRequestLink}">View Request</a>
                        </c:if>
                        <c:if test="${empty request}">
                            <c:url var="makeRequestLink" value="MainController">
                                <c:param name="action" value="ForwardRequestInsert"/>
                                <c:param name="equipmentId" value="${equipment.id}"/>
                                <c:param name="equipmentName" value="${equipment.name}"/>
                                <c:param name="equipmentType" value="${equipment.type.name}"/>
                                <c:param name="dateBought" value="${equipment.dateBought}"/>
                                <c:param name="warranty" value="${equipment.warranty}"/>
                                <c:param name="timeRepaired" value="${equipment.timeRepaired}"/>

                                <!-- SEARCH PARAM ON EQUIPMENT MNG PAGE --->
                                <c:param name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
                                <c:param name="warrantySort" value="${param.warrantySort}"/>
                                <c:param name="dateBoughtSort" value="${param.dateBoughtSort}"/>
                                <c:param name="timeRepairedSort" value="${param.timeRepairedSort}"/>
                            </c:url>
                            <a href="${makeRequestLink}">Request for repairing</a>
                        </c:if>
                    </td>
                </tr>
            </table>
        </td>
        <!-- Image Panel ----------------------------->
        <td><!-- $pageContext.request.contextPath -->
            <img src="<c:url value='${equipment.imagePath}'/>" alt="No image yet" width="500" height="333"/>
        </td>
    </tr>

</table>
<hr>

<c:set var="locationEntries" value="${equipment.locationEntries}"/>
<table>
    <c:if test="${not empty equipment.locationEntries}">
        <h2>Location History</h2>
        <tr>
            <th>Time Transferred</th>
            <th>To Room</th>
            <th>Transferred By</th>
            <th>Reason</th>
        </tr>

        <c:forEach var="entry" items="${locationEntries}">
            <tr>
                <td><fmt:formatDate value="${entry.fromDate}" pattern="HH:mm EEE, dd/MM/yyyy"/></td>
                <td>${entry.room.name}</td>
                <td>${entry.byUserId}</td>
                <td>${entry.reason}</td>
            </tr>
        </c:forEach>
    </c:if>
    <tr>
        <td colspan="4">
            <hr>
        </td>
    </tr>
    <tr>
        <c:if test="${not empty equipment.currentRoom}">
            <th style="text-align: left">Current Location</th>
            <td colspan="2">${equipment.currentRoom.name}</td>
        </c:if>
        <c:if test="${empty equipment.currentRoom}">
            <td colspan="2">Not assigned</td>
        </c:if>
    </tr>
</table>
<hr>

<!-- REPAIR HISTORY ----------->
<c:if test="${not empty equipment.reportList}">
    <h2>Repair History</h2>
    <table>
        <tr>
            <td>No</td>
            <th>Requester</th>
            <th>Time Requested</th>
            <th>Handled By</th>
            <th>Time Began</th>
            <th>Time Done</th>
            <th>Result</th>
        </tr>
        <c:forEach var="report" items="${equipment.reportList}" varStatus="counter">
            <tr>
                <td>${counter.count}</td>
                <td>${report.requester.username}</td>
                <td><fmt:formatDate value="${report.timeRequested}" pattern="HH:mm dd-MM-yyyy"/></td>
                <td>${report.executor.username}</td>
                <td><fmt:formatDate value="${report.timeBegin}" pattern="HH:mm dd-MM-yyyy"/></td>
                <td><fmt:formatDate value="${report.timeDone}" pattern="HH:mm dd-MM-yyyy"/></td>
                <td>${report.success ? 'Successful' : 'Failed'}</td>
                <td>
                    <c:url var="reportDetailsLink" value="MainController">
                        <c:param name="action" value="ViewReport"/>
                        <!-- DETAILS PARAMS --------------->
                        <c:param name="equipmentId" value="${equipment.id}"/>
                        <c:param name="equipmentName" value="${equipment.name}"/>
                        <c:param name="equipmentTypeName" value="${equipment.type.name}"/>

                        <c:param name="requesterId" value="${report.requester.username}"/>
                        <c:param name="requesterGivenName" value="${report.requester.givenName}"/>
                        <c:param name="requesterLastName" value="${report.requester.lastName}"/>

                        <c:param name="executorUsername" value="${report.executor.username}"/>
                        <c:param name="executorGivenName" value="${report.executor.givenName}"/>
                        <c:param name="executorLastName" value="${report.executor.lastName}"/>

                        <c:param name="requestDescription" value="${report.requestDescription}"/>
                        <c:param name="repairDiary" value="${report.repairDiary}"/>
                        <c:param name="timeRequest" value="${report.timeRequested}"/>
                        <c:param name="timeBegin" value="${report.timeBegin}"/>
                        <c:param name="timeDone" value="${report.timeDone}"/>
                        <c:param name="reportResult" value="${report.success}"/>

                        <!-- SEARCH PARAM ON EQUIPMENT MNG PAGE --->
                        <c:param name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
                        <c:param name="warrantySort" value="${param.warrantySort}"/>
                        <c:param name="dateBoughtSort" value="${param.dateBoughtSort}"/>
                        <c:param name="timeRepairedSort" value="${param.timeRepairedSort}"/>
                    </c:url>
                    <a href="${reportDetailsLink}">
                        Read Report
                    </a>
                </td>
            </tr>
        </c:forEach>
    </table>
</c:if>
<hr>

<c:url var="equipmentMngLink" value="MainController">
    <c:param name="action" value="SearchEquipments"/>
    <!-- SEARCH PARAM ON EQUIPMENT MNG PAGE --->
    <c:param name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
    <c:param name="warrantySort" value="${param.warrantySort}"/>
    <c:param name="dateBoughtSort" value="${param.dateBoughtSort}"/>
    <c:param name="timeRepairedSort" value="${param.timeRepairedSort}"/>
</c:url>
<a href="${equipmentMngLink}">Back to equipments view</a>
--%>


</body>
</html>
