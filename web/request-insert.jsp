<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/20/20
  Time: 5:22 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Make Request</title>
</head>
<body>
<h1>Repair Request</h1>
<hr>
<table>
    <tr>
        <th>Equipment</th>
        <td>${param.equipmentId}</td>
    </tr>
    <tr>
        <th>Equipment Name</th>
        <td>${param.equipmentName}</td>
    </tr>
    <tr>
        <th>Type</th>
        <td>${param.equipmentType}</td>
    </tr>
    <tr>
        <th style="text-align: left">Time Repaired</th>
        <td>${param.timeRepaired} time(s)</td>
    </tr>
    <tr>
        <th>Warranty</th>
        <td>${param.warranty}</td>
    </tr>
</table>
<hr>
<label for="requestDescription" style="font-style: oblique">
    <strong>Request Description</strong></label>
<form id="commitForm" action="MainController" method="post" style="margin-bottom: 0">
    <textarea id="requestDescription" name="description" style="width: 50%; height: 20%; text-align: left">${param.description}</textarea>

    <input type="hidden" name="equipmentId" value="${param.equipmentId}"/>
    <input type="hidden" name="equipmentName" value="${param.equipmentName}"/>
    <input type="hidden" name="equipmentType" value="${param.equipmentType}"/>
    <input type="hidden"name="dateBought" value="${param.dateBought}"/>
    <input type="hidden" name="warranty" value="${param.warranty}"/>
    <input type="hidden" name="timeRepaired" value="${param.timeRepaired}"/>
    <!-- SEARCH PARAMS -->
    <input type="hidden" name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
    <input type="hidden" name="warrantySort" value="${param.warrantySort}"/>
    <input type="hidden" name="dateBoughtSort" value="${param.dateBoughtSort}"/>
    <input type="hidden" name="timeRepairedSort" value="${param.timeRepairedSort}"/>
</form>
<form id="cancelForm" action="MainController" method="post" style="margin-bottom: 0">

    <input type="hidden" name="equipmentId" value="${param.equipmentId}">
    <!-- SEARCH PARAMS -->
    <input type="hidden" name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
    <input type="hidden" name="warrantySort" value="${param.warrantySort}"/>
    <input type="hidden" name="dateBoughtSort" value="${param.dateBoughtSort}"/>
    <input type="hidden" name="timeRepairedSort" value="${param.timeRepairedSort}"/>
</form>
<hr>
<td><span style="color: red">${requestScope.REQUEST_INSERT_ERROR}</span></td>

<button form="commitForm" type="submit" name="action" value="MakeRequest">
    Submit
</button>
<button form="cancelForm" type="submit" name="action" value="LoadEquipment">
    Cancel
</button>
</body>
</html>
