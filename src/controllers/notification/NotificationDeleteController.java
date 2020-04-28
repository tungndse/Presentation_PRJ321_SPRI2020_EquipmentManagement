package controllers.notification;

import dtos.AccountDTO;
import managers.NotificationManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/NotificationDeleteController")
public class NotificationDeleteController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String DONE = "NotificationListController";
    private static final String LOGOUT = "LogoutController";

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
            AccountDTO sessionUser = (AccountDTO) session.getAttribute("SESSION_USER");
            String sessionUsername = sessionUser.getUsername();

            switch (sessionUser.getRole()) {
                case 0:
                case 1:
                case 2:
                    url = DONE;
                    break;
                default:
                    url = LOGOUT;
                    throw new Exception("Undetected role or session timed out");
            }

            String action = request.getParameter("action");

            NotificationManager notificationManager = new NotificationManager();
            int deletedCount;

            if (action.equals("DeleteAllNotification")) {
                deletedCount = notificationManager.deleteAllNotification(sessionUsername);
            } else {
                String[] listIds = request.getParameterValues("checkedNotifIds");
                deletedCount = notificationManager.deleteNotificationList(listIds);
            }

            request.setAttribute("DELETED_COUNT", deletedCount);

        } catch (Exception e) {
            log("Error at NotificationDeleteController: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

}
