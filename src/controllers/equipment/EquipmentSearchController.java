package controllers.equipment;

import dtos.AccountDTO;
import dtos.EquipmentDTO;
import managers.EquipmentManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/EquipmentSearchController")
public class EquipmentSearchController extends HttpServlet {
    private static final String ERROR = "error.jsp";

    private static final String SUCCESS_USER = "user-view-equipment.jsp";
    private static final String SUCCESS_TECH = "tech-mng-equipment.jsp";
    private static final String SUCCESS_ADMIN = "admin-mng-equipment.jsp";

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
            AccountDTO sessionUser = (AccountDTO) session.getAttribute("SESSION_USER");
            String sessionUsername = sessionUser.getUsername();
            int role = sessionUser.getRole();

            String action = request.getParameter("action");

            //STANDARD SEARCH: TECH/ADMIN/USER
            String equipmentStatus = request.getParameter("equipmentStatusSelect"); //broken / fine / retired
            String warrantySort = request.getParameter("warrantySort");
            String dateBoughtSort = request.getParameter("dateBoughtSort");
            String timeRepairedSort = request.getParameter("timeRepairedSort");

            //SPECIAL SEARCH: ADMIN
            String dateExpiredFrom = request.getParameter("dateExpiredFrom");
            String dateExpiredTo = request.getParameter("dateExpiredTo");

            //SPECIAL SEARCH: ADMIN
            String repairCount = request.getParameter("repairCount");

            List<EquipmentDTO> equipmentList = null;
            EquipmentManager equipmentManager = new EquipmentManager();

            try {
                if (role == 0) {
                    //standard user: only search equipments in their room, can happen when user in no room
                    equipmentList = equipmentManager.getEquipmentList(sessionUsername, equipmentStatus,
                            warrantySort, dateBoughtSort, timeRepairedSort, true);
                } else {
                    //admin or tech: search equipments with no params

                    if (role == 1) {
                        equipmentList = equipmentManager.getEquipmentList(equipmentStatus,
                                warrantySort, dateBoughtSort, timeRepairedSort, true);
                    } else {
                        switch (action) {
                            case "SearchEquipments":
                                equipmentList = equipmentManager.getEquipmentList(equipmentStatus,
                                        warrantySort, dateBoughtSort, timeRepairedSort, false);
                                break;
                            case "SearchEquipmentsOnExpired":
                                equipmentList = equipmentManager.getEquipmentList(equipmentStatus, dateExpiredFrom, dateExpiredTo);
                                break;
                            case "SearchEquipmentsOnRepairCount":
                                equipmentList = equipmentManager.getEquipmentList(repairCount);
                                break;
                        }
                    }

                }
            } catch (SQLException notInRoomException) {
                // This is for when user is not in any room trying to search equipment and receive null
                //  different from when there's no equipment in the room as an error msg will be returned
                String errorMsg = notInRoomException.getMessage();

                if (errorMsg.contains("GetEquipmentsQuery-")) {
                    request.setAttribute("EQUIPMENT_LIST_ERROR",
                            errorMsg.replace("GetEquipmentsQuery-", ""));
                } else {
                    throw new Exception(errorMsg);
                }
            }

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
            }

            request.setAttribute("EQUIPMENT_LIST", equipmentList);

        } catch (
                Exception e) {
            log("Error at " + this.getServletName() + ": " + e.getMessage());
            System.out.println("Error at " + this.getServletName() + ": " + e.getMessage());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

}
