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

@WebServlet("/AccountDeleteController")
public class AccountDeleteController extends HttpServlet {
    private static final String ERROR = "error.jsp";
    private static final String SUCCESS = "AccountSearchController";
    private static final String FAILED = "AccountLoadController"; //return back to userdetail and load user from db

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
                throw new Exception("UDEL-Attempt to delete user using non-admin account");
            }

            String adminUsername = admin.getUsername();
            String username = request.getParameter("username");

            AccountManager accountManager = new AccountManager();
            String deleteError = accountManager.deleteAccount(username, adminUsername);

            if (deleteError == null) {
                url = SUCCESS;
            } else {
                request.setAttribute("DELETE_ERROR" , deleteError);
                url = FAILED;
            }

        } catch (Exception e) {
            log("Error at AccountDeleteController: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }
}
