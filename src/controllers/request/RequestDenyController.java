package controllers.request;

import daos.RequestDAO;
import dtos.AccountDTO;
import managers.RequestManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/RequestDenyController")
public class RequestDenyController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String SUCCESS_FROM_EQUIPMENT_DETAILS = "EquipmentLoadController";
    private static final String SUCCESS_FROM_CONTAINER = "admin-mng-request.jsp";
    private static final String FAILED = "RequestLoadController";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            HttpSession session = request.getSession();
            AccountDTO admin = (AccountDTO) session.getAttribute("SESSION_USER");

            String fromContainer = request.getParameter("fromContainer");
            String requestId = request.getParameter("requestId");
            String denyReason = request.getParameter("denyReason");

            RequestManager requestManager = new RequestManager();
            String denyResult = requestManager.denyRequest(requestId, admin.getUsername(), denyReason);

            if (denyResult.equals("OK")) {
                url = fromContainer.isEmpty() ?  SUCCESS_FROM_EQUIPMENT_DETAILS : SUCCESS_FROM_CONTAINER;
            } else {
                url = FAILED;
                request.setAttribute("DENY_ERROR", denyResult);
            }

        } catch (Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
            System.out.println(e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
