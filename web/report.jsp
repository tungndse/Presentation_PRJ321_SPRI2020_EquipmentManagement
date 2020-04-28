<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/18/20
  Time: 6:04 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Report</title>
    <style>
        tr {
            text-align: left;
        }
    </style>
</head>
<body>
<h1>Repair Report</h1>
<table>
    <tr>
        <th>Equipment</th>
        <td>${param.equipmentName} (${param.equipmentId})</td>
    </tr>
    <tr>
        <th>Equipment Type</th>
        <td>${param.equipmentTypeName}</td>
    </tr>
    <tr><td colspan="2">
        <hr></td></tr>
    <tr>
    <tr>
        <th>Requested By</th>
        <td>${param.requesterGivenName} ${param.requesterLastName} (${param.requesterId})</td>
    </tr>
    <tr>
        <th>Requested On</th>
        <td>${param.timeRequest}</td>
    </tr>
    <tr>
        <th colspan="2" style="text-align: left">Request Description</th>
    </tr>
    <tr>
        <td colspan="2">${param.requestDescription}</td>
    </tr>
    <tr><td colspan="2">
        <hr></td></tr>
    <tr>
        <th>Executed By</th>
        <td>${param.executorGivenName} ${param.executorLastName} (${param.executorUsername})</td>
    </tr>
    <tr>
        <th>Accepted On</th>
        <td>${param.timeBegin}</td>
    </tr>
    <tr>
        <th colspan="2" style="text-align: left">Repair Diary</th>

    </tr>
    <tr>
        <td colspan="2">${param.repairDiary}</td>
    </tr>
    <tr><td colspan="2">
        <hr></td></tr>
    <tr>
    <tr>
        <th>Finished On</th>
        <td>${param.timeDone}</td>
    </tr>
    <tr>
        <th>Result</th>
        <td>
            <c:if test="${param.reportResult == 'true'}">
                <span style="color: limegreen">SUCCESSFUL</span>
            </c:if>
            <c:if test="${param.reportResult == 'false'}">
                <span style="color: red">FAILED</span>
            </c:if>
        </td>
    </tr>
</table>
<br>
<c:url var="backToEquipmentDetailsLink" value="MainController">
    <c:param name="equipmentId" value="${param.equipmentId}"/>
    <c:param name="action" value="LoadEquipment"/>
    <!-- SEARCH PARAM --->
    <c:param name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
    <c:param name="warrantySort" value="${param.warrantySort}"/>
    <c:param name="dateBoughtSort" value="${param.dateBoughtSort}"/>
    <c:param name="timeRepairedSort" value="${param.timeRepairedSort}"/>
</c:url>
<a href="${backToEquipmentDetailsLink}">Back to equipment details</a>
</body>
</html>
