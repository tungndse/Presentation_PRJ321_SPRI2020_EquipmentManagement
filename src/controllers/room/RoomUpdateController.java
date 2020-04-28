package controllers.room;

import dtos.AccountDTO;
import managers.RoomManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/RoomUpdateController")
public class RoomUpdateController extends HttpServlet {
    private static final String ERROR = "error.jsp";
    private static final String SUCCESS = "RoomLoadController";
    private static final String FAILED = "admin-mng-room-update.jsp";

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
            AccountDTO admin = (AccountDTO) session.getAttribute("SESSION_USER");
            if (admin.getRole() != 2) {
                throw new Exception("Attempt to update room name as non-admin account");
            }

            String roomId = request.getParameter("roomId");
            String newName = request.getParameter("newName");

            RoomManager roomManager = new RoomManager();
            String updateInfo = roomManager.updateRoom(roomId, newName, admin.getUsername());

            if (!updateInfo.equals("OK")) {
                request.setAttribute("UPDATE_ERROR", updateInfo);
                url = FAILED;
            } else {
                url = SUCCESS;
            }

        } catch (Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
            System.out.println("Error at " + this.getServletName() + ": " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

}
