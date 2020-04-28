package controllers.equipment;

import dtos.AccountDTO;
import dtos.EquipmentDTO;
import managers.EquipmentManager;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

@WebServlet("/EquipmentLoadController")
public class EquipmentLoadController extends HttpServlet {
    private static final String ERROR = "error.jsp";

    private static final String SUCCESS_LOAD_DETAILS_ADMIN = "admin-mng-equipment-details.jsp";
    private static final String SUCCESS_LOAD_DETAILS_TECH = "tech-mng-equipment-details.jsp";
    private static final String SUCCESS_LOAD_DETAILS_USER = "user-view-equipment-details.jsp";
    private static final String FAILED_LOAD_DETAILS = "EquipmentSearchController";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            String equipmentId;
            if (request.getAttribute("EID") != null) {
                equipmentId = (String) request.getAttribute("EID");
            } else {
                equipmentId = request.getParameter("equipmentId");
            }

            HttpSession session = request.getSession();
            AccountDTO sessionUser = (AccountDTO) session.getAttribute("SESSION_USER");
            int sessionUserRole = sessionUser.getRole();

            EquipmentManager equipmentManager = new EquipmentManager();
            EquipmentDTO equipment = equipmentManager.getEquipment(equipmentId);

            if (equipment != null) {
                if (sessionUserRole == 0) {
                    url = SUCCESS_LOAD_DETAILS_USER;
                } else if (sessionUserRole == 1) {
                    url = SUCCESS_LOAD_DETAILS_TECH;
                } else {
                    url = SUCCESS_LOAD_DETAILS_ADMIN;
                }

                request.setAttribute("EQUIPMENT", equipment);
            } else {
                url = FAILED_LOAD_DETAILS;
            }

        } catch (Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
            System.out.println("Error at " + this.getServletName() + ": " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

}
