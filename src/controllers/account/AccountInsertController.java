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

@WebServlet("/AccountInsertController")
public class AccountInsertController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String SUCCESS_REG = "login.jsp";
    private static final String FAILED_REG = "user-registration.jsp";
    private static final String SUCCESS_INSERT = "AccountSearchController"; //need a search servlet and a search info object
    private static final String FAILED_INSERT = "admin-mng-user-insert.jsp";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;

        try {
            HttpSession session = request.getSession();
            AccountDTO registrant = (AccountDTO) session.getAttribute("SESSION_USER"); //The one who does account creation

            String action = request.getParameter("action");
            if (action.equals("InsertAccount") && registrant.getRole() != 2) {
                throw new Exception("UINS-Attempt to insert new user using non-admin account");
            }

            String username = request.getParameter("username");
            String givenName = request.getParameter("givenName");
            String lastName = request.getParameter("lastName");
            String password = request.getParameter("password");
            String confirm = request.getParameter("confirm");
            String role;
            String registrantUsername; //Name of the registrant

            // Security check
            if (action.equals("Registration")) {
                role = "user";
                registrantUsername = username;
            } else { //InsertAccount
                role = request.getParameter("role");
                registrantUsername = registrant.getUsername();
            }

            AccountManager accountManager = new AccountManager();
            AccountDTO account = accountManager.registerAccount(username, givenName, lastName,
                    password, confirm, role, registrantUsername);

            boolean success = account.getErrorInformant().isClean();

            if (success) {
                url = action.equals("Registration") ? SUCCESS_REG : SUCCESS_INSERT;
            } else {
                url = action.equals("Registration") ? FAILED_REG : FAILED_INSERT;
                request.setAttribute("USER", account);
            }

        } catch (Exception e) {
            log("ERROR at RegistrationController:" + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);

    }
}
