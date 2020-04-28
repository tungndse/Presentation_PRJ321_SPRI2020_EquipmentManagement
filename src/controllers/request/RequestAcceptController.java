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

@WebServlet("/RequestAcceptController")
public class RequestAcceptController extends HttpServlet {
    private static final String ERROR = "error.jsp";
    private static final String FROM_EQUIPMENT = "RequestLoadController";
    private static final String FROM_CONTAINER = "tech-mng-request.jsp";

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

            RequestManager requestManager = new RequestManager();
            String info = requestManager.acceptRequest(requestId, tech.getUsername());

            if (!info.equals("OK")) {
                request.setAttribute("ACCEPT_ERROR", info);
            }

            url = fromContainer.equals("fromContainer") ?
                    FROM_CONTAINER : FROM_EQUIPMENT;

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
