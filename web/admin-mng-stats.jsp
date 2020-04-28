<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: tungnd
  Date: 3/22/20
  Time: 2:28 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Equipment Statistic</title>
</head>
<body>
<h1>Equipment Statistic</h1>
<hr>
<a href="admin-mng-user.jsp">Manage User</a>
<a href="admin-mng-equipment.jsp">Manage Equipment</a>
<a href="admin-mng-room.jsp">Manage Room</a>
<hr>
<c:set var="statsListRepair" value="${requestScope.STATSR}"/>
<c:choose>
    <c:when test="${not empty requestScope.STATSDB}">
        <c:set var="statsListStatus" value="${requestScope.STATSDB}"/>
    </c:when>
    <c:when test="${not empty requestScope.STATSW}">
        <c:set var="statsListStatus" value="${requestScope.STATSW}"/>
    </c:when>
    <c:when test="${not empty requestScope.STATSPECIAL}">
        <c:set var="statsSpecial" value="${requestScope.STATSPECIAL}"/>
    </c:when>
</c:choose>
<h2>Repair Stats</h2>
<c:url var="repairTimeStatsLink" value="MainController">
    <c:param name="action" value="GetRepairTimeStats"/>
</c:url>
<a href="${repairTimeStatsLink}">Get RepairTime Statistics</a>
<c:if test="${not empty statsListRepair}">
    <table border="1">
        <tr>
            <th>Time(s) repaired</th>
            <th>Number of equipments</th>
        </tr>
        <c:forEach var="stats" items="${statsListRepair}">
            <tr>
                <td>${stats.repairTimeLabel} time(s)</td>
                <td>${stats.count}</td>
            </tr>
        </c:forEach>
    </table>
    <hr>
</c:if>
<hr>
<h2>Status Stats</h2>
<h3>By Warranty</h3>
<form action="MainController" method="post" style="margin-bottom: 0">
    From : <input type="text" name="warrantyFrom" value="${param.warrantyFrom}"/>
    To : <input type="text" name="warrantyTo" value="${param.warrantyTo}"/>
    <Br>
    <button type="submit" name="action" value="GetStatusAndWarrantyStats">
        Get Statistics By Warranty
    </button>
</form>
<br>
<h3>By Date Bought</h3>
<form action="MainController" method="post">
    From : <input type="date" name="dateFrom" value="${param.dateFrom}"/>
    To : <input type="date" name="dateTo" value="${param.dateTo}"/>
    <br>
    <button type="submit" name="action" value="GetStatusAndDateBoughtStats">
        Get Statistics By Date Bought
    </button>
</form>
<br>
<c:if test="${not empty statsListStatus}">
    <c:if test="${param.action == 'GetStatusAndWarrantyStats'}">
        <strong>Stats based on status ranged by warranty:</strong>
    </c:if>

    <table border="1">
        <tr>
            <th>Status</th>
            <th>Number of equipments</th>
        </tr>
        <c:forEach var="stats" items="${statsListStatus}">
            <tr>
                <td><c:out value="${stats.statusLabel}"/></td>
                <td>${stats.count}</td>
            </tr>
        </c:forEach>
    </table>
    <hr>
</c:if>
<hr>
<h3>By Warranty Grouped By Status</h3>
<form action="MainController" method="post" style="margin-bottom: 0">
    <button type="submit" name="action" value="GetSpecialStats">
        Get Statistics By Warranty Groups In Status Groups
    </button>
</form>
<br>
<c:if test="${not empty statsSpecial}">
    <c:if test="${param.action == 'GetStatusAndDateBoughtStats'}">
        <strong>Stats based on status ranged by date bought:</strong>
    </c:if>
    <table border="1">
        <tr>
            <th>Warranty (month)</th>
            <th>Number of equipments</th>
        </tr>
        <tr>
            <th colspan="2">Good</th>
        </tr>
        <c:forEach var="stats" items="${statsSpecial}">
            <c:if test="${stats.statusLabel == 'Good'}">
                <tr>
                    <td>${stats.warrantyLabel}</td>
                    <td>${stats.count}</td>
                </tr>
            </c:if>
        </c:forEach>
        <tr>
            <th colspan="2">Broken</th>
        </tr>
        <c:forEach var="stats" items="${statsSpecial}">
            <c:if test="${stats.statusLabel == 'Broken'}">
                <tr>
                    <td>${stats.warrantyLabel}</td>
                    <td>${stats.count}</td>
                </tr>
            </c:if>
        </c:forEach>
    </table>
</c:if>

<hr>
<a href="admin-home.jsp">Back to home</a>


</body>
</html>
