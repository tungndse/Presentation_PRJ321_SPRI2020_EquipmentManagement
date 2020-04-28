package controllers.main;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/MainController")
public class MainController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String LOGIN = "LoginController";
    private static final String LOGOUT = "LogoutController";

    private static final String ACCOUNT_INSERT = "AccountInsertController";
    private static final String ACCOUNT_UPDATE = "AccountUpdateController";
    private static final String ACCOUNT_DELETE = "AccountDeleteController";
    private static final String ACCOUNT_DETAILS = "AccountLoadController";
    private static final String ACCOUNT_SEARCH = "AccountSearchController";
    private static final String ACCOUNT_FORWARD_UPDATE = "admin-mng-user-update.jsp";
    private static final String ACCOUNT_FORWARD_INSERT = "admin-mng-user-insert.jsp";

    private static final String EQUIPMENT_DELETE = "EquipmentDeleteController";
    private static final String EQUIPMENT_INSERT = "EquipmentInsertController";
    private static final String EQUIPMENT_LOAD = "EquipmentLoadController";
    private static final String EQUIPMENT_SEARCH = "EquipmentSearchController";
    private static final String EQUIPMENT_STATISTIC = "EquipmentStatisticController";
    private static final String EQUIPMENT_UPDATE = "EquipmentUpdateController";
    private static final String EQUIPMENT_FORWARD_UPDATE = "admin-mng-equipment-update.jsp";
    private static final String EQUIPMENT_FORWARD_INSERT = "admin-mng-equipment-insert.jsp";
    private static final String EQUIPMENT_UPDATE_IMAGE = "EquipmentUpdateImage";

    private static final String USER_LOCATE = "UserLocateController";
    private static final String EQUIPMENT_PREP_LOCATE = "equipment-locate-reason.jsp";
    private static final String EQUIPMENT_LOCATE = "EquipmentLocateController";

    private static final String ROOM_LIST = "RoomListController";
    private static final String ROOM_LOAD = "RoomLoadController";
    private static final String ROOM_UPDATE = "RoomUpdateController";
    private static final String ROOM_UPDATE_PREPARE = "admin-mng-room-update.jsp";
    private static final String ROOM_INSERT = "RoomInsertController";
    private static final String ROOM_DELETE = "RoomDeleteController";
    private static final String ROOM_INSERT_PREPARE = "admin-mng-room-insert.jsp";

    private static final String REQUEST_VIEW = "RequestLoadController"; //
    private static final String REPORT_VIEW = "report.jsp"; // Only view a finished request (report)
    private static final String REQUEST_MAKE = "RequestMakingController";
    private static final String REQUEST_UPDATE = "RequestUpdateController";
    private static final String REQUEST_ACCEPT = "RequestAcceptController";
    private static final String REQUEST_CANCEL = "RequestCancelController";
    private static final String REQUEST_DENY = "RequestDenyController";
    private static final String REQUEST_FINISH = "RequestFinishController";
    private static final String REQUEST_CONTAINER = "RequestContainerController";
    private static final String REQUEST_INSERT_PREPARE = "request-insert.jsp";

    private static final String NOTIFICATION_INIT = "NotificationInitController";
    private static final String NOTIFICATION_DELETE = "NotificationDeleteController";
    private static final String NOTIFICATION_LIST = "NotificationListController";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processReq(request, response);
    }

    private void processReq(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = ERROR;
        try {
            String action = request.getParameter("action");
            switch (action) {
                // ACCOUNT ACTIONS:
                case "Login":
                    url = LOGIN;
                    break;
                case "Logout":
                    url = LOGOUT;
                    break;
                case "Registration":
                case "InsertAccount":
                    url = ACCOUNT_INSERT;
                    break;
                case "ForwardUserInsert":
                    url = ACCOUNT_FORWARD_INSERT;
                    break;
                case "ForwardUserUpdate":
                    url = ACCOUNT_FORWARD_UPDATE;
                    break;
                case "LoadProfile":
                case "LoadUser":
                    url = ACCOUNT_DETAILS;
                    break;
                case "UpdateProfile":
                case "UpdateUser":
                    url = ACCOUNT_UPDATE;
                    break;
                case "DeleteUser":
                    url = ACCOUNT_DELETE;
                    break;
                case "SearchUsers":
                    url = ACCOUNT_SEARCH;
                    break;

                //TRANSFER ACTIONS:
                case "MoveUserFromManagement":
                case "MoveUserFromDetails":
                    url = USER_LOCATE;
                    break;
                case "ForwardEquipmentTransfer":
                    url = EQUIPMENT_PREP_LOCATE;
                    break;
                case "MoveEquipmentFromManagement":
                case "MoveEquipmentFromDetails":
                    url = EQUIPMENT_LOCATE;
                    break;

                //EQUIPMENT ACTIONS:
                case "InsertEquipment":
                    url = EQUIPMENT_INSERT;
                    break;
                case "DeleteEquipment":
                    url = EQUIPMENT_DELETE;
                    break;
                case "UpdateEquipment":
                    url = EQUIPMENT_UPDATE;
                    break;
                case "SearchEquipments":
                case "SearchEquipmentsOnExpired":
                case "SearchEquipmentsOnRepairCount":
                    url = EQUIPMENT_SEARCH;
                    break;
                case "LoadEquipment":
                    url = EQUIPMENT_LOAD;
                    break;
                case "StatisticEquipment":
                    url = EQUIPMENT_STATISTIC;
                    break;
                case "ForwardEquipmentInsert":
                    url = EQUIPMENT_FORWARD_INSERT;
                    break;
                case "ForwardEquipmentUpdate":
                    url = EQUIPMENT_FORWARD_UPDATE;
                    break;
                case "UploadEquipmentImage":
                    url = EQUIPMENT_UPDATE_IMAGE;
                    break;

                // ROOM ACTIONS:
                case "ListRoomsExpanded":
                case "ListRooms":
                    url = ROOM_LIST;
                    break;
                    /*url = ROOM_LIST_EXPANDED;
                    break;*/
                case "LoadRoom":
                    url = ROOM_LOAD;
                    break;
                case "ForwardRoomInsert":
                    url = ROOM_INSERT_PREPARE;
                    break;
                case "ForwardRoomUpdate":
                    url = ROOM_UPDATE_PREPARE;
                    break;
                case "UpdateRoom":
                    url = ROOM_UPDATE;
                    break;
                case "InsertRoom":
                    url = ROOM_INSERT;
                    break;
                case "DeleteRoom":
                    url = ROOM_DELETE;
                    break;

                // REQUEST ACTIONS:
                case "ViewReport": //admin, tech, user
                    url = REPORT_VIEW;
                    break;
                case "ViewRequestAsAdmin": //admin: view, deny;
                case "ViewRequestAsTech": //tech: view, accept;
                case "ViewRequestAsUser": //user:view
                    url = REQUEST_VIEW;
                    break;
                case "ForwardRequestInsert":
                    url = REQUEST_INSERT_PREPARE;
                    break;
                case "MakeRequest":
                    url = REQUEST_MAKE;
                    break;
                case "DenyRequest":
                    url = REQUEST_DENY;
                    break;
                case "CancelRequestFromEquipment": //ESCAPE
                case "CancelRequestFromContainer": //ESCAPE
                    url = REQUEST_CANCEL;
                    break;
                case "AcceptRequestFromEquipment": //ESCAPE ? NOT SURE
                    url = REQUEST_ACCEPT;
                    break;
                case "FinishRequestFromEquipment": //ESCAPE
                case "FinishRequestFromContainer":// ESCAPE
                    url = REQUEST_FINISH;
                    break;
                case "UpdateRequest":
                    url = REQUEST_UPDATE;
                    break;
                case "GetContainer":
                    url = REQUEST_CONTAINER;
                    break;

                // NOTIFICATION ACTIONS:
                case "InitNotification":
                    url = NOTIFICATION_INIT;
                    break;
                case "SearchNotification":
                    url = NOTIFICATION_LIST;
                    break;
                case "DeleteNotification":
                case "DeleteAllNotification":
                    url = NOTIFICATION_DELETE;
                    break;

                    //STATS
                case "GetRepairTimeStats":
                case "GetStatusAndDateBoughtStats":
                case "GetStatusAndWarrantyStats":
                case "GetSpecialStats":
                    url = EQUIPMENT_STATISTIC;
                    break;
            }
            System.out.println(url);

        } catch (Exception e) {
            log("Error at MainController " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processReq(request, response);
    }
}
