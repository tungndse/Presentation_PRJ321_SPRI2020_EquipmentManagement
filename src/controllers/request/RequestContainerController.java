package controllers.request;

import dtos.AccountDTO;
import dtos.RequestDTO;
import managers.RequestManager;
import models.RequestContainer;
import models.RequestContainerAdmin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/RequestContainerController")
public class RequestContainerController extends HttpServlet {

    private static final String ERROR = "error.jsp";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            AccountDTO sessionUser = (AccountDTO) session.getAttribute("SESSION_USER");

            String username = sessionUser.getUsername();
            RequestManager requestManager = new RequestManager();

            int role = sessionUser.getRole();
            if (role == 0) {
                List<RequestDTO> list = requestManager.getUserRequestContainer(username);
                request.setAttribute("REQUEST_LIST", list);
            } else if (role == 1){ // == 1
                RequestContainer container = requestManager.getTechRequestContainer(username);
                request.setAttribute("REQUEST_CONTAINER", container);
            } else {
                RequestContainerAdmin adminContainer = requestManager.getAdminRequestContainer();
                request.setAttribute("REQUEST_CONTAINER", adminContainer);
            }

        } catch (Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
            request.getRequestDispatcher(ERROR).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
