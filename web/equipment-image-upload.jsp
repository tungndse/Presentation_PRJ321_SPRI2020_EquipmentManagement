<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/19/20
  Time: 1:23 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h3>File Upload:</h3>
Select a file to upload: <br>
<form action="EquipmentImageController" method="post" enctype="multipart/form-data">
    <input type="hidden" name="equipmentId" value="${param.equipmentId}"/>
    <input type="file" name="file" size="50"/>
    <input type="submit" value=""/>
</form>
</body>
</html>
