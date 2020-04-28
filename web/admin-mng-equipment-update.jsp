<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/17/20
  Time: 10:57 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Equipment Update</title>
</head>
<body>
<c:set var="error" value="${requestScope.EQUIPMENT_ERROR}"/>

<h1>Update equipment</h1>
<form>
    <table>
        <tr>
            <th style="text-align: left">Id</th>
            <td>
                ${param.equipmentId}
                <input type="hidden" name="equipmentId" value="${param.equipmentId}"/>
            </td>
        </tr>
        <tr>
            <th style="text-align: left">Name</th>
            <td><input type="text" name="equipmentName" value="${param.equipmentName}"/></td>
            <td style="color: red">${error.nameError}</td>
        </tr>
        <tr>
            <th style="text-align: left">Type</th>
            <td>
                <input type="text" name="typeName" value="${param.typeName}"/></td>
            <td style="color: red">${error.typeError}</td>
        <tr>
            <th style="text-align: left">Warranty</th>
            <td>
                <input type="text" name="warranty" value="${param.warranty}"/></td>
            <td style="color: red">${error.warrantyError}</td>
        </tr>
        <tr>
            <th style="text-align: left">Date Bought</th>
            <td><input type="date" name="dateBought" value="${param.dateBought}"/></td>
            <td style="font-style: oblique">Leave it alone if not changed</td>
            <td style="color: red;">${error.dateBroughtError}</td>
        </tr>
        <tr>
            <th style="text-align: left">Description</th>
        </tr>
        <tr>
            <td colspan="4" style="width: 200px; height: 100px">
                <textarea name="description" style="width: 100%;height: 100%; text-align: left">
                    ${param.description}</textarea>
            </td>
        </tr>
        <tr>
            <td style="color:red;">${error.descriptionError}</td>
        </tr>
        <tr>
            <input type="hidden" name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
            <input type="hidden" name="warrantySort" value="${param.warrantySort}"/>
            <input type="hidden" name="dateBoughtSort" value="${param.dateBoughtSort}"/>
            <input type="hidden" name="timeRepairedSort" value="${param.timeRepairedSort}"/>
            <td colspan="2">
                <button type="submit" name="action" value="UpdateEquipment" style="width: 100%">Commit</button>
            </td>
        </tr>
    </table>
</form>
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
