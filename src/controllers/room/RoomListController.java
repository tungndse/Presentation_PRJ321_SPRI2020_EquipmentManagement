package controllers.room;

import dtos.RoomDTO;
import managers.RoomManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/RoomListController")
public class RoomListController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            RoomManager roomManager = new RoomManager();
            List<RoomDTO> roomList;

            if (action.equals("ListRooms")) {
                roomList = roomManager.getAllAvailableRooms();
            } else {
                roomList = roomManager.getAllAvailableRoomsWithStatistics();
            }

            request.setAttribute("ROOM_LIST", roomList);
        } catch (Exception e) {
            log("Error at RoomOptionListController: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
