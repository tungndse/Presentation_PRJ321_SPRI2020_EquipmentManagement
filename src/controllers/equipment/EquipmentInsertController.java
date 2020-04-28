package controllers.equipment;

import dtos.AccountDTO;
import dtos.EquipmentDTO;
import managers.EquipmentManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/EquipmentInsertController")
public class EquipmentInsertController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String SUCCESS_INSERT = "admin-mng-equipment-insert-imageupload.jsp";
    private static final String FAILED_INSERT = "admin-mng-equipment-insert.jsp";

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
            AccountDTO admin = (AccountDTO) session.getAttribute("SESSION_USER"); //The one who does account creation
            String adminUsername = admin.getUsername();

            if (admin.getRole() != 2) {
                throw new Exception("EINS-Attempt to insert new equipment using non-admin account");
            }

            String equipmentId = request.getParameter("equipmentId");
            String equipmentName = request.getParameter("equipmentName");
            String dateBought = request.getParameter("dateBought");
            String warranty = request.getParameter("warranty");
            String description = request.getParameter("description");

            String typeName = request.getParameter("typeName");

            EquipmentManager equipmentManager = new EquipmentManager();
            EquipmentDTO equipment = equipmentManager
                    .registerEquipment(equipmentId, equipmentName, dateBought, warranty,
                            description, typeName, adminUsername);

            boolean success = equipment.getErrorInformant().isClean();

            if (success) {
                url =  SUCCESS_INSERT;
            } else {
                url = FAILED_INSERT;
                request.setAttribute("EQUIPMENT_ERROR", equipment.getErrorInformant());
            }

        } catch (Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
            System.out.println("Error at " + this.getServletName() + ": " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

}
