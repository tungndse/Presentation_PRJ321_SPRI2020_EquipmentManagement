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

@WebServlet("/RequestMakingController")
public class RequestMakingController extends HttpServlet {
    private static final String ERROR = "error.jsp";
    private static final String SUCCESS = "EquipmentLoadController";
    private static final String FAILED = "request-insert.jsp";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            HttpSession session = request.getSession();
            AccountDTO user = (AccountDTO) session.getAttribute("SESSION_USER");

            String equipmentId = request.getParameter("equipmentId");
            String username = user.getUsername();
            String description = request.getParameter("description");

            RequestManager requestManager = new RequestManager();
            String info = requestManager.makeRequest(equipmentId, username, description);

            if (info.equals("OK")) {
                url = SUCCESS;
            } else {
                url = FAILED;
                request.setAttribute("REQUEST_INSERT_ERROR", info);
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
