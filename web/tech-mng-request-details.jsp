<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/19/20
  Time: 3:42 PM
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
<c:set var="sessionUsername" value="${sessionScope.SESSION_USER.username}"/>
<c:set var="request" value="${requestScope.REQUEST}"/>
<c:set var="isAccepted" value="${request.requestStatus == 1}"/>
<c:set var="isHandler" value="${isAccepted && sessionUsername == request.executor.username}"/>
<c:set var="fromContainer" value="${not empty param.fromContainer}"/>


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
                <li><a href="tech-home.jsp">Home</a></li>
                <li><a href="tech-mng-equipment.jsp">Equipment</a></li>
                <li class="selected"><a href="tech-mng-request.jsp">Requests</a></li>
                <li><a href="${profileLink}">Profile</a></li>
            </ul>
        </div>
    </div>
    <div id="site_content">
        <h1>Request Details</h1>
        <c:if test="${isHandler}">
            <strong>This is one of your currently handled request</strong>
        </c:if>
        <c:if test="${!isHandler}">
            <strong>You're reading this request as tech</strong>
        </c:if>
        <hr>

        <!-- TABLE OF CONTENTS ----------->
        <table>
            <tr>
                <th>Equipment:</th>
                <td>${request.equipment.name} (${request.equipment.id})</td>
            </tr>
            <tr>
                <th>Equipment Type:</th>
                <td>${request.equipment.type.name}</td>
            </tr>
            <tr>
                <th>Requested By:</th>
                <td>${request.requester.givenName}
                    ${request.requester.lastName} (${request.requester.username})
                </td>
            </tr>
            <tr>
                <th>Requested Time:</th>
                <td><fmt:formatDate value="${request.timeRequested}"
                                    pattern="HH:mm EEE, dd-MM-yyyy"/>
                </td>
            </tr>
            <tr>
                <th>Request Description</th>
                <td>${request.requestDescription}</td>
            </tr>
            <tr>
                <td colspan="2">
                    <hr>
                </td>
            </tr>
            <!--- REQUEST ACCEPTED ---->
            <c:if test="${isAccepted}">
                <tr>
                    <th>Accepted By:</th>
                    <td>${request.executor.givenName}
                            ${request.executor.lastName} (${request.executor.username})
                    </td>
                </tr>
                <tr>
                    <th>Time Accepted</th>
                    <td>
                        <fmt:formatDate value="${request.timeBegin}"
                                        pattern="HH:mm EEE, dd-MM-yyyy"/>
                    </td>
                </tr>
                <tr>
                    <th colspan="2">Repair Diary</th>
                </tr>
                <tr>
                    <td colspan="2">${request.repairDiary}</td>
                </tr>
            </c:if>
            <c:if test="${isHandler}">
                <tr><!-- Success ? EquipmentLoad : requestLoad --->
                    <c:url var="finishRequestSuccessLink" value="MainController">
                        <c:param name="action" value="FinishRequestFromEquipment"/>
                        <c:param name="requestResult" value="success"/>
                        <c:param name="requestId" value="${request.id}"/>
                        <!--- equipmentId param is for returning back to equipment load from edetails -->
                        <c:param name="equipmentId" value="${request.equipment.id}"/>
                        <c:param name="fromContainer" value="${param.fromContainer}"/>
                    </c:url>
                    <td colspan="2">
                        <a href="${finishRequestSuccessLink}">
                            <button style="width: 60%; height: 0.75cm; background-color: lightgreen">Finish - Success
                            </button>
                        </a></td>
                </tr>
                <tr>
                    <c:url var="finishRequestFailedLink" value="MainController">
                        <c:param name="action" value="FinishRequestFromEquipment"/>
                        <c:param name="requestResult" value="failed"/>
                        <c:param name="requestId" value="${request.id}"/>
                        <!--- equipmentId param is for returning back to equipment load from edetails -->
                        <c:param name="equipmentId" value="${request.equipment.id}"/>
                        <c:param name="fromContainer" value="${param.fromContainer}"/>
                    </c:url>
                    <td colspan="2">
                        <a href="${finishRequestFailedLink}">
                            <button style="width: 60%;height: 0.75cm; background-color: orangered">Finish - Failed
                            </button>
                        </a></td>
                </tr>
                <tr>
                    <td colspan="2">${requestScope.FINISH_ERROR}</td>
                </tr>
            </c:if>

            <!--- REQUEST NOT ACCEPTED ----------
                * Any one can accept this request since it's not accepted yet
            ---->
            <c:if test="${!isAccepted}">
                <tr>
                    <th>Accepted By:</th>
                    <td>Not yet accepted by any one</td>
                </tr>
                <tr>
                    <td colspan="2">
                        <c:url var="acceptRequestLink" value="MainController">
                            <c:param name="action" value="AcceptRequestFromEquipment"/>
                            <c:param name="requestId" value="${request.id}"/>
                            <!--- equipmentId param is for returning back to equipment load from edetails -->
                            <c:param name="equipmentId" value="${request.equipment.id}"/>
                            <c:param name="fromContainer" value="${param.fromContainer}"/>
                        </c:url>
                        <a href="${acceptRequestLink}">
                            <button style="width: 60%;">Accept this request</button>
                        </a>
                    </td>
                </tr>
            </c:if>
        </table>
        <hr>
        <c:if test="${isHandler}">
            <strong>You can update your report here:</strong>
            <form action="MainController" method="post" style="margin-bottom: 0">
                <textarea name="repairDiary" style="width: 60%; height: 30%; text-align: left">${request.repairDiary}</textarea>
                <input type="hidden" name="requestId" value="${request.id}"/>
                <input type="hidden" name="equipmentId" value="${request.equipment.id}"/>
                <!-- for the escape link on the bottom -->
                <input type="hidden" name="fromContainer" value="${param.fromContainer}"/>
                <input type="hidden" name="fromEquipmentDetails" value="${param.fromEquipmentDetails}"/>
                <br>
                <button type="submit" name="action" value="UpdateRequest" style="width: 30%; height: 0.75cm">Update Diary</button>
            </form>
            <span style="color:red;">${requestScope.REQUEST_UPDATE_ERROR}</span>
            <hr>
            <!--- REQUEST ACCEPTED + VIEWER IS HANDLER--------------->
            <strong>You can cancel this request should you state your reason below:</strong>
            <form action="MainController" method="post">
                <textarea name="cancelReason"
                          style="width: 60%; height: 20%; text-align: left">${param.cancelReason}</textarea>
                <input type="hidden" name="requestId" value="${request.id}"/>
                <!-- for the escape link on the bottom -->
                <input type="hidden" name="fromContainer" value="${param.fromContainer}"/>
                <input type="hidden" name="fromEquipmentDetails" value="${param.fromEquipmentDetails}"/>
                <!--- equipmentId param is for returning back to equipment load from details -->
                <input type="hidden" name="equipmentId" value="${request.equipment.id}"/>
                <br>
                <button type="submit" name="action" value="CancelRequestFromEquipment"
                        style="width: 30%; height: 0.75cm">Cancel this request
                </button>
            </form>
            <span style="color:red;">${requestScope.REQUEST_CANCEL_ERROR}</span>
        </c:if>
        <hr>
        <c:if test="${!fromContainer}">
            <c:url var="backToEquipmentDetailsLink" value="MainController">
                <c:param name="equipmentId" value="${request.equipment.id}"/>
                <c:param name="action" value="LoadEquipment"/>

                <!-- SEARCH PARAM --->
                <c:param name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
                <c:param name="warrantySort" value="${param.warrantySort}"/>
                <c:param name="dateBoughtSort" value="${param.dateBoughtSort}"/>
                <c:param name="timeRepairedSort" value="${param.timeRepairedSort}"/>
            </c:url>
            <a href="${backToEquipmentDetailsLink}">Back to equipment details</a>
        </c:if>
        <c:if test="${fromContainer}">
            <a href="tech-mng-request.jsp">Back to requests container</a>
        </c:if>
    </div>
</div>
</body>
</html>
