package controllers.entry;

import dtos.AccountDTO;
import managers.AccountManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginController")
public class LoginController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String SUCCESS_USER = "user-home.jsp";
    private static final String SUCCESS_ADMIN = "admin-home.jsp";
    private static final String FAILED = "login.jsp";
    private static final String SUCCESS_TECH = "tech-home.jsp";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processReq(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    private void processReq(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            AccountManager accountManager = new AccountManager();
            AccountDTO loginUser = accountManager.validateLogin(username, password);

            if (loginUser != null) {
                HttpSession session = request.getSession();
                session.setAttribute("SESSION_USER", loginUser);
                int role = loginUser.getRole();
                switch (role) {
                    case 0:
                        url = SUCCESS_USER;
                        break;
                    case 1:
                        url = SUCCESS_TECH;
                        break;
                    case 2:
                        url = SUCCESS_ADMIN;
                        break;

                    default:
                }
            } else {
                request.setAttribute("LOGIN_FAILURE", "Invalid Username or Password");
                url = FAILED;
            }

        } catch (Exception ex) {
            request.setAttribute("UNCAUGHT_ERROR", ex.getMessage());
            log("ERROR at LoginController:" + ex.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }
}
