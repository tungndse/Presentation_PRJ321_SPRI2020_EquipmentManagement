package controllers.request;

import managers.RequestManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RequestFinishController")
public class RequestFinishController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String FINISH_FROM_CONTAINER = "tech-mng-request.jsp"; //ESCAPE
    private static final String FINISH_FROM_EQUIPMENT = "EquipmentLoadController"; //ESCAPE
    private static final String FAILED = "RequestLoadController"; //CANT ESCAPE

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
           // String action = request.getParameter("action");
            String fromContainer = request.getParameter("fromContainer");

            String requestId = request.getParameter("requestId");
            String requestResult = request.getParameter("requestResult");

            RequestManager requestManager = new RequestManager();
            String info = requestManager.finishRequest(requestId, requestResult);

            if (info.equals("OK")) {
                url = fromContainer.equals("fromContainer") ?
                        FINISH_FROM_CONTAINER : FINISH_FROM_EQUIPMENT;
            } else {
                url = FAILED;
                request.setAttribute("FINISH_ERROR", info);
            }

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
