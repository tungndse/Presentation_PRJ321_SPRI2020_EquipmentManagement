package controllers.notification;

import dtos.AccountDTO;
import managers.NotificationManager;
import models.NotificationCarrier;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/NotificationListController")
public class NotificationListController extends HttpServlet {

    private static final String ERROR = "error.jsp";

    private static final String ADMIN = "admin-home.jsp";
    private static final String USER = "user-home.jsp";
    private static final String TECH = "tech-home.jsp";
    private static final String LOGOUT = "LogoutController";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            HttpSession session = request.getSession();
            AccountDTO sessionUser = (AccountDTO) session.getAttribute("SESSION_USER");
            String username = sessionUser.getUsername();
            int role = sessionUser.getRole();

            switch (role) {
                case 0:
                    url = USER;
                    break;
                case 1:
                    url = TECH;
                    break;
                case 2:
                    url = ADMIN;
                    break;
                default:
                    url = LOGOUT;
                    throw new Exception("Undetected role or session timed out");
            }

            // Filter parameters
            String groupSelect = request.getParameter("groupSelect");
            String topSelectStr = request.getParameter("topSelect");
            String fromDateStr = request.getParameter("fromDate");

            NotificationManager notificationManager = new NotificationManager();
            NotificationCarrier carrier = notificationManager.loadNotification(username, groupSelect,
                    fromDateStr, topSelectStr);

            request.setAttribute("NOTIFICATION", carrier.getNotificationList());

        } catch (Exception e) {
            log("Error at NotifyController: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
