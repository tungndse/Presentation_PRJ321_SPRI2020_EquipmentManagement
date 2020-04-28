package controllers.equipment;

import dtos.AccountDTO;
import managers.EquipmentManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/EquipmentDeleteController")
public class EquipmentDeleteController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String SUCCESS = "EquipmentSearchController";
    private static final String FAILED = "EquipmentLoadController";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            HttpSession session = request.getSession();
            AccountDTO admin = (AccountDTO) session.getAttribute("SESSION_USER");
            if (admin.getRole() != 2) {
                throw new Exception("EDEL-Attempt to delete equipment using non-admin account");
            }

            String adminUsername = admin.getUsername();
            String equipmentId = request.getParameter("equipmentId");

            EquipmentManager equipmentManager = new EquipmentManager();
            String deleteError = equipmentManager.deleteEquipment(equipmentId, adminUsername);

            if (deleteError == null) {
                url = SUCCESS;
            } else {
                request.setAttribute("DELETE_ERROR" , deleteError);
                url = FAILED;
            }
        } catch (Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
            System.out.println("Error at " + this.getServletName() + ": " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }


}
