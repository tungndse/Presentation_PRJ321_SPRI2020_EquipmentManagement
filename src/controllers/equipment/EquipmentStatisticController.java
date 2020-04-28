package controllers.equipment;

import managers.EquipmentManager;
import models.StatisticUnit;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/*
    For admin only
 */

@WebServlet("/EquipmentStatisticController")
public class EquipmentStatisticController extends HttpServlet {
    private static final String ERROR = "error.jsp";
    private static final String SUCCESS = "admin-mng-stats.jsp";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            String action = request.getParameter("action");

            EquipmentManager equipmentManager = new EquipmentManager();
            List<StatisticUnit> result = null;
            switch (action) {
                case "GetRepairTimeStats":
                    result = equipmentManager.getRepairStats();
                    request.setAttribute("STATSR", result);
                    break;
                case "GetStatusAndDateBoughtStats":
                    String dateFrom = request.getParameter("dateFrom");
                    String dateTo = request.getParameter("dateTo");
                    result = equipmentManager.getStatusOnDBStats(dateFrom, dateTo);
                    request.setAttribute("STATSDB", result);
                    break;
                case "GetStatusAndWarrantyStats":
                    String warrantyFrom = request.getParameter("warrantyFrom");
                    String warrantyTo = request.getParameter("warrantyTo");
                    result = equipmentManager.getStatusOnWarrantyStats(warrantyFrom, warrantyTo);
                    request.setAttribute("STATSW", result); break;
                case "GetSpecialStats":
                    result = equipmentManager.getWarrantyGroupOrderedByStatusGroup();
                    request.setAttribute("STATSPECIAL", result); break;
            }

            url = SUCCESS;

        } catch (Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
