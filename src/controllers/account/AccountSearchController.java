package controllers.account;

import dtos.AccountDTO;
import managers.AccountManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/AccountSearchController")
public class AccountSearchController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String SUCCESS = "admin-mng-user.jsp";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            String givenNameSearch = request.getParameter("givenNameSearch");
            String lastNameSearch = request.getParameter("lastNameSearch");
            String pickedRoomId = request.getParameter("roomIdSelected");

            AccountManager accountManager = new AccountManager();
            List<AccountDTO> resultList = accountManager.searchAccounts(givenNameSearch, lastNameSearch,
                    pickedRoomId, false);

            request.setAttribute("USER_LIST", resultList);
            url = SUCCESS;
        } catch (Exception e) {
            log("Error at AccountSearchController: " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
