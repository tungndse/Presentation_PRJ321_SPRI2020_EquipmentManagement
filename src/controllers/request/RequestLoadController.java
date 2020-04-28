package controllers.request;

import dtos.AccountDTO;
import dtos.RequestDTO;
import managers.RequestManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/RequestLoadController")
public class RequestLoadController extends HttpServlet {
    private static final String ERROR = "error.jsp";

    private static final String SUCCESS_ADMIN = "admin-mng-request-details.jsp";
    private static final String SUCCESS_TECH = "tech-mng-request-details.jsp";
    private static final String SUCCESS_USER = "user-view-request-details.jsp";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            HttpSession session = request.getSession();
            AccountDTO sessionUser = (AccountDTO) session.getAttribute("SESSION_USER");
            int role = sessionUser.getRole();

            String requestId = request.getParameter("requestId");

            RequestDTO requestDTO = RequestManager.getActiveRequest(requestId);

            switch (role) {
                case 0:
                    url = SUCCESS_USER;
                    break;
                case 1:
                    url = SUCCESS_TECH;
                    break;
                case 2:
                    url = SUCCESS_ADMIN;
                    break;
            }

            request.setAttribute("REQUEST", requestDTO);
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
