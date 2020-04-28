<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/21/20
  Time: 9:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h2>Upload Equipment Image</h2>
<form action="EquipmentImageController" method="post" enctype="multipart/form-data">
    <input type="hidden" name="equipmentId" value="${param.equipmentId}"/>
    <input type="file" name="file" size="50"/>
    <input type="hidden" name="fromInsert" value="fromInsert"/>
    <input type="submit" value="Upload Image"/>
</form>
<a href="admin-mng-equipment.jsp">Upload later</a>
</body>
</html>
