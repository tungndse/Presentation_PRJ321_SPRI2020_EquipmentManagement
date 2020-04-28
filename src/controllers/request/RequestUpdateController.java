package controllers.request;

import managers.RequestManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RequestUpdateController")
public class RequestUpdateController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String FINISH = "RequestLoadController";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            String requestId = request.getParameter("requestId");
            String repairDiary = request.getParameter("repairDiary");

            RequestManager requestManager = new RequestManager();
            String info = requestManager.updateRequest(requestId, repairDiary);

            if (!info.equals("OK")){
                request.setAttribute("REQUEST_UPDATE_ERROR", info);
            }

            url = FINISH;

        } catch (Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
