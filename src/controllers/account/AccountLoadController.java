package controllers.account;

import dtos.AccountDTO;
import managers.AccountManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AccountLoadController")
public class AccountLoadController extends HttpServlet {
    private static final String ERROR = "error.jsp";
    private static final String SUCCESS_LOAD_PROFILE = "user-profile.jsp";
    private static final String FAILED_LOAD_PROFILE = "LogoutController";
    private static final String SUCCESS_LOAD_DETAILS = "admin-mng-user-details.jsp";
    private static final String FAILED_LOAD_DETAILS = "AccountSearchController";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            HttpSession session = request.getSession();
            AccountDTO sessionUser = (AccountDTO) session.getAttribute("SESSION_USER");
            String username;

            String action = request.getParameter("action");
            if (action.equals("LoadProfile")) {
                username = sessionUser.getUsername();
            } else {
                if (sessionUser.getRole() == 2) {
                    username = request.getParameter("username");
                } else {
                    throw new Exception("Attempt to get info from other user using non-admin account");
                }
            }

            AccountManager accountManager = new AccountManager();
            AccountDTO account = accountManager.getAccount(username);

            //acc is null

            if (account != null) {
                url = action.equals("LoadProfile") ? SUCCESS_LOAD_PROFILE : SUCCESS_LOAD_DETAILS;
                request.setAttribute("USER", account);
            } else {
                url = action.equals("LoadProfile") ? FAILED_LOAD_PROFILE : FAILED_LOAD_DETAILS;
            }


        } catch (Exception e) {
            log("Error at AccountLoadController: " + e.getMessage());
            request.setAttribute("UNCAUGHT_ERROR", e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
