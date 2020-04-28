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

@WebServlet("/NotificationInitController")
public class NotificationInitController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request);
    }

    private void processRequest(HttpServletRequest request) {
        try {
            HttpSession session = request.getSession();
            AccountDTO sessionUser = (AccountDTO) session.getAttribute("SESSION_USER");
            String username = sessionUser.getUsername();

            NotificationManager notificationManager = new NotificationManager();

            if (request.getAttribute("NOTIFICATION") == null) {
                NotificationCarrier notificationCarrier = notificationManager
                        .loadNotification(username, "10");

                request.setAttribute("NOTIFICATION", notificationCarrier.getNotificationList());
                request.setAttribute("NOTIFICATION_COUNT", notificationCarrier.getCount());
            } else {
                int notificationNum = notificationManager.getCount(username);
                request.setAttribute("NOTIFICATION_COUNT", notificationNum);
            }

        } catch (Exception e) {
            log("Error at NotifyInitiatorController:" + e.getMessage());
        }
    }
}
