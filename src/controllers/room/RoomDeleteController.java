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

@WebServlet("/RoomDeleteController")
public class RoomDeleteController extends HttpServlet {
    private static final String ERROR = "error.jsp";
    private static final String SUCCESS = "admin-mng-room.jsp";
    private static final String FAILED = "RoomLoadController";

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
                throw new Exception("Attempt to remove room using non-admin account");
            }

            String roomId = request.getParameter("roomId");

            RoomManager roomManager = new RoomManager();

            String info = roomManager.deleteRoom(roomId, admin.getUsername());

            if (info.equals("OK")) {
                url = SUCCESS;
            } else {
                url = FAILED;
                request.setAttribute("DELETE_ERROR" , info);
            }


        } catch (Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
            System.out.println("Error at " + this.getServletName() + ": " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

}
