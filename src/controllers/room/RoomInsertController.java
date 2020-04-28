package controllers.room;

import dtos.AccountDTO;
import dtos.RoomDTO;
import managers.RoomManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/RoomInsertController")
public class RoomInsertController extends HttpServlet {
    private static final String ERROR = "error.jsp";
    private static final String SUCCESS = "admin-mng-room.jsp";
    private static final String FAILED = "admin-mng-room-insert.jsp";

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
                throw new Exception("Attempt to insert new room using non-admin account");
            }

            String roomId = request.getParameter("roomId");
            String roomName = request.getParameter("roomName");

            RoomManager roomManager = new RoomManager();
            RoomDTO.ErrorInformant errorInformant = roomManager.registerRoom(roomId, roomName, admin.getUsername());

            if (errorInformant.isClean()) {
                url = SUCCESS;
            } else {
                url = FAILED;
                request.setAttribute("INSERT_ERROR", errorInformant);
            }

        } catch (Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
            System.out.println("Error at " + this.getServletName() + ": " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

}
