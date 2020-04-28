package controllers.request;

import dtos.AccountDTO;
import managers.RequestManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/RequestCancelController")
public class RequestCancelController extends HttpServlet {
    private static final String ERROR = "error.jsp";
    private static final String SUCCESS_FROM_EQUIPMENT_DETAILS = "EquipmentLoadController";
    private static final String SUCCESS_FROM_REQUEST_CONTAINER = "tech-mng-request.jsp";
    private static final String FAILED = "RequestLoadController";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            HttpSession session = request.getSession();
            AccountDTO tech = (AccountDTO) session.getAttribute("SESSION_USER");

            //String action = request.getParameter("action");
            String fromContainer = request.getParameter("fromContainer");

            String requestId = request.getParameter("requestId");
            String cancelReason = request.getParameter("cancelReason");

            RequestManager requestManager = new RequestManager();
            String info = requestManager.cancelRequest(requestId, cancelReason);

            if (info.equals("OK")) {
                 url = fromContainer.equals("fromContainer") ?
                         SUCCESS_FROM_REQUEST_CONTAINER: SUCCESS_FROM_EQUIPMENT_DETAILS ;
            } else {
                url = FAILED;
                request.setAttribute("REQUEST_CANCEL_ERROR", info);
            }

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
