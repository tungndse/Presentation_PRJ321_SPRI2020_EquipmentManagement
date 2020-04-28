package controllers.locator;

import dtos.AccountDTO;
import managers.AccountManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UserLocateController")
public class UserLocateController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String FROM_MNG_PAGE = "AccountSearchController";
    private static final String FROM_DETAILS_PAGE = "AccountLoadController";
    private static final String FROM_ROOM_DETAILS_PAGE = "RoomLoadController";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            HttpSession session = request.getSession();
            AccountDTO mover = (AccountDTO) session.getAttribute("SESSION_USER");
            if (mover.getRole() != 2) {
                throw new Exception("UMOVE-Attempt to transfer users using unauthorized account");
            }

            String roomId = request.getParameter("roomIdChanged");
            String username = request.getParameter("username");

            AccountManager accountManager = new AccountManager();
            String resultMsg = accountManager.transferUser(mover.getUsername(), username, roomId);
            String action = request.getParameter("action");
            switch (action) {
                case "MoveUserFromManagement":
                    url = FROM_MNG_PAGE;
                    break;
                case "MoveUserFromDetails":
                    url = FROM_DETAILS_PAGE;
                    break;
                case "MoveUserFromRoom":
                    url = FROM_ROOM_DETAILS_PAGE;
                    break;
            }

            if (!resultMsg.equals("OK")) {
                request.setAttribute("ERROR_TRANSFER", resultMsg);
            }

        } catch (Exception e) {
            log("Error at UserLocateController: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
