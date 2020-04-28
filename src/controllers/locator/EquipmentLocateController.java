package controllers.locator;

import dtos.AccountDTO;
import managers.EquipmentManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/EquipmentLocateController")
public class EquipmentLocateController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String FROM_MNG_PAGE = "EquipmentSearchController";
    private static final String FROM_DETAILS_PAGE = "EquipmentLoadController";
    private static final String FAILED = "equipment-locate-reason.jsp";

    //notyet

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            HttpSession session = request.getSession();
            AccountDTO mover = (AccountDTO) session.getAttribute("SESSION_USER");
            if (mover.getRole() != 1 && mover.getRole() != 2) {
                throw new Exception("EMOVE-Attempt to transfer equipments using unauthorized account");
            }

            String roomId = request.getParameter("roomIdChanged");
            String equipmentId = request.getParameter("equipmentId");
            String reasonMoved = request.getParameter("reasonMoved");

            System.out.println(equipmentId);

            EquipmentManager equipmentManager = new EquipmentManager();
            String resultMsg = equipmentManager.transferEquipment(mover.getUsername(), equipmentId, roomId, reasonMoved);

            String action = request.getParameter("action");
            switch (action) {
                case "MoveEquipmentFromManagement":
                    url = FROM_MNG_PAGE;
                    break;
                case "MoveEquipmentFromDetails":
                    url = FROM_DETAILS_PAGE;
                    break;
            }

            if (!resultMsg.equals("OK")) {
                request.setAttribute("ERROR_TRANSFER", resultMsg);
                url = FAILED;
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
            log("Error at EquipmentLocateController : " +e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
