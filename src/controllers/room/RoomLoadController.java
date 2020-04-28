package controllers.room;

import dtos.RoomDTO;
import managers.RoomManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RoomLoadController")
public class RoomLoadController extends HttpServlet {
    private static final String ERROR = "error.jsp";
    private static final String SUCCESS = "admin-mng-room-details.jsp";
    private static final String FAILED = "admin-mng-room.jsp";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            String roomId = request.getParameter("roomId");
            RoomManager roomManager = new RoomManager();

            RoomDTO room = roomManager.getRoomFullDetails(roomId);

            if (room != null) {
                url = SUCCESS;
                request.setAttribute("ROOM", room);
            } else {
                url = FAILED;
            }

        } catch (Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
            System.out.println("Error at " + this.getServletName() + ": " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }
}
