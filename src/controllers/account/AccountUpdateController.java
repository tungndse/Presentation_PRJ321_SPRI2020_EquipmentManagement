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

@WebServlet("/AccountUpdateController")
public class AccountUpdateController extends HttpServlet {
    private static final String ERROR = "error.jsp";

    private static final String SUCCESS_UPDATE_PROFILE_ADMIN = "admin-home.jsp";
    private static final String SUCCESS_UPDATE_PROFILE_USER = "user-home.jsp";
    private static final String SUCCESS_UPDATE_PROFILE_TECH = "tech-home.jsp";

    private static final String FAILED_UPDATE_PROFILE = "user-profile.jsp";

    private static final String SUCCESS_UPDATE_USER = "AccountLoadController";
    private static final String FAILED_UPDATE_USER = "admin-mng-user-update.jsp";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            HttpSession session = request.getSession();
            AccountDTO updater = (AccountDTO) session.getAttribute("SESSION_USER");

            String action = request.getParameter("action");
            if (action.equals("UpdateUser") && updater.getRole() != 2) {
                throw new Exception("UINS-Attempt to update user account using non-admin account");
            }

            String username = request.getParameter("username");
            String givenName = request.getParameter("givenName");
            String lastName = request.getParameter("lastName");
            String password = request.getParameter("password");
            String confirm = request.getParameter("confirm");

            String updaterUsername;
            AccountManager accountManager = new AccountManager();
            AccountDTO account;

            updaterUsername = updater.getUsername();

            if (action.equals("UpdateProfile")) {
                int role = updater.getRole();
                switch (updater.getRole()) {
                    case 0:
                        url = SUCCESS_UPDATE_PROFILE_USER;
                        break;
                    case 1:
                        url = SUCCESS_UPDATE_PROFILE_TECH;
                        break;
                    case 2:
                        url = SUCCESS_UPDATE_PROFILE_ADMIN;
                        break;
                    default:
                }

                account = accountManager.updateAccount(updaterUsername, givenName, lastName,
                        password, confirm, role, updaterUsername);
            } else { //UpdateUser
                String role = request.getParameter("role");
                account = accountManager.updateAccount(username, givenName, lastName, role, updaterUsername);
            }

            boolean success = account.getErrorInformant().isClean();

            if (success) {
                if (action.equals("UpdateProfile")) {// UpdateUser
                    AccountDTO updatedSessionUser = new AccountDTO.Builder(updaterUsername)
                            .fullName(givenName, lastName)
                            .role(updater.getRole())
                            .loginTime(updater.getTimeLogin())
                            .build();
                    session.setAttribute("SESSION_USER", updatedSessionUser);
                } else {
                    url = SUCCESS_UPDATE_USER;
                }
            } else {
                url = action.equals("UpdateProfile") ? FAILED_UPDATE_PROFILE : FAILED_UPDATE_USER;
                request.setAttribute("USER", account);
            }

            request.setAttribute("USER", account);

        } catch (Exception e) {
            log("Error at AccountUpdController: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);

    }
}
