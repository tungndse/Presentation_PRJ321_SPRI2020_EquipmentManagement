<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/18/20
  Time: 9:47 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Transfer Reason</title>
    <style>
        button {
            width: 20%;
        }
    </style>
</head>
<body>
<c:import url="MainController">
    <c:param name="action" value="ListRooms"/>
</c:import>
<c:set var="roomOptionList" value="${requestScope.ROOM_LIST}"/>

<h2>Transferring Equipment</h2>

<table>
    <tr>
        <th style="text-align: left">Equipment</th>
        <td colspan="4">${param.equipmentName} - ${param.equipmentTypeName} (${param.equipmentId})</td>
    </tr>
    <tr>
        <th style="text-align: left">Currently At</th>
        <td>
            <c:out value="${not empty param.equipmentOldRoom ?
            param.equipmentOldRoom : 'Not Assigned'}"/>
        </td>
    </tr>
</table>
<hr>

<form action="MainController" method="post" style="margin-bottom: 0">
    <strong>Transfer To</strong>

    <select name="roomIdChanged">
        <c:forEach var="room" items="${roomOptionList}">
            <option value="${room.id}" ${param.roomIdChanged == room.id ? 'selected' : ''}>
                    ${room.name}
            </option>
        </c:forEach>
    </select>
    <input type="hidden" name="equipmentId" value="${param.equipmentId}"/>
    <input type="hidden" name="equipmentName" value="${param.equipmentName}"/>
    <input type="hidden" name="equipmentTypeName" value="${param.equipmentTypeName}"/>
    <input type="hidden" name="equipmentOldRoom" value="${param.equipmentOldRoom}"/>

    <input type="hidden" name="fromManagement" value="${param.fromManagement}"/>
    <!-- SEARCH PARAMS ----->
    <input type="hidden" name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
    <input type="hidden" name="warrantySort" value="${param.warrantySort}"/>
    <input type="hidden" name="dateBoughtSort" value="${param.dateBoughtSort}"/>
    <br>
    <strong>Reason for transfer (must be given):</strong>
    <br>
    <textarea name="reasonMoved" style="width: 40%; height: 10%; text-align: left"></textarea>
    <br>
    <button type="submit" name="action" value="${not empty param.fromManagement ?
                'MoveEquipmentFromManagement' : 'MoveEquipmentFromDetails'}">Submit</button>

    <button type="submit" name="action" value="${not empty param.fromManagement ?
                    'SearchEquipments' : 'LoadEquipment'}">Cancel</button>
</form>
<span style="color: red">${requestScope.ERROR_TRANSFER}</span>

</body>
</html>
