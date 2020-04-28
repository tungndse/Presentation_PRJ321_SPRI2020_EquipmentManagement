<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/18/20
  Time: 3:20 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<c:set var="error" value="${requestScope.EQUIPMENT_ERROR}"/>

<h1>Insert equipment</h1>
<hr>
<form>
    Id: <input type="text" name="equipmentId" value="${param.equipmentId}"/>
    <span style="color:red;">${error.idError}</span>
    <br>
    Name: <input type="text" name="equipmentName" value="${param.equipmentName}"/>
    <span style="color:red;">${error.nameError}</span>
    <br>
    Type: <input type="text" name="typeName" value="${param.typeName}"/>
    <span style="color:red;">${error.typeError}</span>
    <br>
    Warranty: <input type="text" name="warranty" value="${param.warranty}"/>
    <span style="color:red;">${error.warrantyError}</span>
    <br>
    Date Bought (Pick a date): <input type="date" name="dateBought" value="${param.dateBought}"/>
    <span style="color:red;">${error.dateBroughtError}</span>
    <br>
    Description:
    <br>
    <textarea name="description" style="width: 50%;height: 10%; text-align: left">${param.description}</textarea>
    <br>
    <span style="color:red;">${error.descriptionError}</span>
    <br>

    <button type="submit" name="action" value="InsertEquipment" style="width: 30%; height: 5%">Submit</button>

    <input type="hidden" name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
    <input type="hidden" name="warrantySort" value="${param.warrantySort}"/>
    <input type="hidden" name="dateBoughtSort" value="${param.dateBoughtSort}"/>
    <input type="hidden" name="timeRepairedSort" value="${param.timeRepairedSort}"/>
</form>
<hr>
<c:url var="equipmentMngLink" value="MainController">
    <c:param name="action" value="SearchEquipments"/>
    <!-- SEARCH PARAM ON EQUIPMENT MNG PAGE --->
    <c:param name="equipmentStatusSelect" value="${param.equipmentStatusSelect}"/>
    <c:param name="warrantySort" value="${param.warrantySort}"/>
    <c:param name="dateBoughtSort" value="${param.dateBoughtSort}"/>
    <c:param name="timeRepairedSort" value="${param.timeRepairedSort}"/>
</c:url>
<a href="${equipmentMngLink}">Back to equipment management page</a>
</body>
</html>
