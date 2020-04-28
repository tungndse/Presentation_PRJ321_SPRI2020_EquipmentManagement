package daos;

import com.sun.prism.es2.ES2Graphics;
import db.DBConnector;
import dtos.AccountDTO;
import dtos.EquipmentDTO;
import dtos.RequestDTO;
import dtos.RoomDTO;
import models.LocationEntry;
import models.StatisticUnit;

import java.io.Serializable;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


public class EquipmentDAO extends PrimitiveDAO implements Serializable {

    public void delete(String equipmentId, String byUser) throws Exception {
        try {
            String sql = "{call spDeleteEquipment (?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setString(1, equipmentId);
            csm.setString(2, byUser);
            csm.execute();

        } finally {
            closeConnection(cnn, csm);
        }
    }

    public void save(EquipmentDTO equipment, String byUser) throws Exception {
        try {
            //id, name, dateB, warranty, description, typename, imgpath, bywho
            String sql = "{call spSaveEquipment (?, ?, ?, ?, ?, ?, ?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            csm.setString(1, equipment.getId());
            csm.setString(2, equipment.getName());
            // this may has some error
            if (equipment.getDateBought() != null) {
                csm.setDate(3, new java.sql.Date(equipment.getDateBought().getTime()));
            } else {
                csm.setDate(3, null);
            }
            csm.setInt(4, equipment.getWarranty());
            csm.setString(5, equipment.getDescription());
            csm.setString(6, equipment.getType().getName());
            csm.setString(7, byUser);

            csm.execute();

        } finally {
            closeConnection(cnn, csm, rs);
        }
    }

    public EquipmentDTO get(String equipmentId) throws Exception {
        EquipmentDTO equipment = null;
        RequestDTO activeRequest = null;
        List<LocationEntry> locationEntries = null;
        List<RequestDTO> reportList = null;

        System.out.println("BEGIN");

        try {
            String sql = "{call spGetEquipmentFullDetails (?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setString(1, equipmentId);

            // Get current active request
            //SELECT Id, Status, CreatedBy, ProceededBy
            rs = csm.executeQuery();
            if (rs.next()) {
                int id = rs.getInt("Id");
                int status = rs.getInt("Status");

                String requesterId = rs.getString("CreatedBy");
                String executorId = rs.getString("ProceededBy");

                activeRequest = new RequestDTO.Builder(id)
                        .requestStatus(status)
                        .requester(new AccountDTO.Builder(requesterId).build())
                        .executor(new AccountDTO.Builder(executorId).build())
                        .build();
            }

            // Get Location History Entries
            csm.getMoreResults();
            rs2 = csm.getResultSet();
            if (rs2.next()) {
                locationEntries = new ArrayList<>();
                do {
                    String roomId = rs2.getString("RoomId");
                    String roomName = rs2.getString("RoomName");
                    Date fromDT =
                            new Date(rs2.getTimestamp("FromDateTime").getTime());
                    String byUserId = rs2.getString("ByUser");
                    String reason = rs2.getString("ReasonMoving");

                    RoomDTO room = new RoomDTO.Builder(roomId).label(roomName).build();

                    LocationEntry entry = new LocationEntry(room, fromDT, byUserId, reason);
                    locationEntries.add(entry);

                } while (rs2.next());
            }

            // Get repair results list
            csm.getMoreResults();
            rs3 = csm.getResultSet();
            if (rs3.next()) {
                reportList = new ArrayList<>();
                do {
                    int requestId = rs3.getInt("Id");
                    String requesterId = rs3.getString("CreatedBy");
                    String requesterGivenName = rs3.getString("RequesterGivenName");
                    String requesterLastName = rs3.getString("RequesterLastName");
                    String description = rs3.getString("Description");
                    Date timeRequest =
                            new Date(rs3.getTimestamp("TimeCreated").getTime());
                    String repairDescription = rs3.getString("RepairDescription");
                    String executorId = rs3.getString("ProceededBy");
                    String executorGivenName = rs3.getString("ExecutorGivenName");
                    String executorLastName = rs3.getString("ExecutorLastName");
                    Date timeBegin =
                            new Date(rs3.getTimestamp("TimeStart").getTime());
                    Date timeFinish =
                            new Date(rs3.getTimestamp("TimeDone").getTime());
                    boolean result = rs3.getBoolean("Result");

                    AccountDTO requester = new AccountDTO.Builder(requesterId)
                            .fullName(requesterGivenName, requesterLastName).build();

                    AccountDTO executor = new AccountDTO.Builder(executorId)
                            .fullName(executorGivenName, executorLastName).build();

                    RequestDTO report = new RequestDTO.Builder(requestId)
                            .requester(requester).executor(executor)
                            .requestDescription(description)
                            .repairDiary(repairDescription)
                            .timeRequest(timeRequest)
                            .timeBegin(timeBegin)
                            .timeDone(timeFinish)
                            .success(result)
                            .build();

                    reportList.add(report);
                } while (rs3.next());
            }

            // get equipment details
            csm.getMoreResults();
            rs4 = csm.getResultSet();
            if (rs4.next()) {
                String name = rs4.getString("Name");
                Date dateBought = new Date(rs4.getDate("DateBought").getTime());
                int warranty = rs4.getInt("Warranty");
                int timeRepaired = rs4.getInt("TimeRepaired");
                int status = rs4.getInt("Status");
                String description = rs4.getString("Description");
                String typeName = rs4.getString("TypeName");
                String imgPath = rs4.getString("ImagePath");

                String roomId = rs4.getString("RoomId");
                String roomName = rs4.getString("RoomName");

                RoomDTO currentRoom = new RoomDTO.Builder(roomId).label(roomName).build();

                System.out.println(imgPath);

                equipment = new EquipmentDTO.Builder(equipmentId)
                        .name(name).dateBought(dateBought)
                        .warranty(warranty).timeRepaired(timeRepaired)
                        .status(status).description(description)
                        .type(EquipmentDTO.Type.buildSoftType(typeName))
                        .imagePath(imgPath)
                        .currentRoom(currentRoom)
                        .currentRequest(activeRequest)
                        .locationEntries(locationEntries)
                        .reportList(reportList)
                        .build();

            }

        } finally {
            closeConnection(cnn, csm, rs, rs2, rs3, rs4);
        }

        return equipment;
    }

    public void update(EquipmentDTO equipment, String byUser) throws Exception {

        try {
            //id, name, dateB, warranty, description, typename, bywho
            String sql = "{call spUpdateEquipment (?, ?, ?, ?, ?, ?, ?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            csm.setString(1, equipment.getId());
            csm.setString(2, equipment.getName());
            // this may has some error
            if (equipment.getDateBought() != null) {
                csm.setDate(3, new java.sql.Date(equipment.getDateBought().getTime()));
            } else {
                csm.setDate(3, null);
            }
            csm.setInt(4, equipment.getWarranty());
            csm.setString(5, equipment.getDescription());
            csm.setString(6, equipment.getType().getName());
            csm.setString(7, byUser);

            csm.execute();

        } finally {
            closeConnection(cnn, csm, rs);
        }
    }

    public List<EquipmentDTO> getList(String forRoomMember, int equipmentStatus, boolean warrantyOrderSort,
                                      boolean dateBoughtOrderSort, boolean repairTimeOrderSort, boolean underWarranty) throws Exception {
        List<EquipmentDTO> list = null;
        try {
            String sql = "{call spGetEquipmentList (?,?,?,?,?, ?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setString(1, forRoomMember);
            csm.setInt(2, equipmentStatus);
            csm.setBoolean(3, warrantyOrderSort);
            csm.setBoolean(4, dateBoughtOrderSort);
            csm.setBoolean(5, repairTimeOrderSort);
            csm.setBoolean(6, underWarranty);

            rs = csm.executeQuery();
            if (rs.next()) {
                list = new ArrayList<>();
                do {
                    String id = rs.getString("Id");
                    String name = rs.getString("Name");
                    Date dateBought = new Date(rs.getDate("DateBought").getTime());
                    int warranty = rs.getInt("Warranty");
                    Date dateExpired = new Date((rs.getDate("DateExpired").getTime()));
                    int timeRepaired = rs.getInt("TimeRepaired");
                    int status = rs.getInt("Status");

                    String typeName = rs.getString("TypeName");
                    EquipmentDTO.Type type = EquipmentDTO.Type.buildSoftType(typeName);

                    String roomId = rs.getString("RoomId");
                    String roomName = rs.getString("RoomName");
                    RoomDTO currentRoom = new RoomDTO.Builder(roomId).label(roomName).build();

                    RequestDTO request = null;
                    int requestId = rs.getInt("RequestId");
                    int requestStatus = rs.getInt("RequestStatus");
                    if (requestId != 0) { //default value of result set get int if null
                        request = new RequestDTO.Builder(requestId)
                                .requestStatus(requestStatus)
                                .build();
                    }


                    EquipmentDTO equipment = new EquipmentDTO.Builder(id)
                            .name(name)
                            .dateBought(dateBought)
                            .warranty(warranty)
                            .dateExpired(dateExpired)
                            .timeRepaired(timeRepaired)
                            .status(status)
                            .type(type)
                            .currentRoom(currentRoom)
                            .currentRequest(request)
                            .build();

                    list.add(equipment);
                } while (rs.next());
            }
        } finally {
            closeConnection(cnn, csm, rs);
        }

        return list;
    }


    public void updateImagePath(String equipmentId, String imgPath) throws Exception {
        try {
            String sql = "{call spUpdateEquipmentImage (?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setString(1, equipmentId);
            csm.setString(2, imgPath);

            csm.execute();
        } finally {
            closeConnection(cnn, csm);
        }
    }

    public List<StatisticUnit> getRepairStats() throws Exception {
        List<StatisticUnit> stats;
        try {
            String sql = "SELECT TimeRepaired, COUNT(Id) AS Num FROM Equipment " +
                    "WHERE Status IN (0,1) " +
                    "GROUP BY TimeRepaired";
            cnn = DBConnector.getConnection();
            psm = cnn.prepareStatement(sql);

            rs = psm.executeQuery();
            stats = new ArrayList<>();
            while (rs.next()) {
                String repairTimeLb = rs.getString("TimeRepaired");
                int count = rs.getInt("Num");

                StatisticUnit unit = new StatisticUnit.Builder()
                        .repairTimeLabel(repairTimeLb)
                        .count(count)
                        .build();

                stats.add(unit);
            }

        } finally {
            closeConnection(cnn, psm, rs);
        }

        return stats;
    }

    //csm.setDate(3, new java.sql.Date(equipment.getDateBought().getTime()));

    public List<StatisticUnit> getStatusDBStats(Date dateFrom, Date dateTo) throws Exception {
        List<StatisticUnit> stats;
        try {
            String sql =
                    "SELECT IIF(Status = 0, 'Broken', 'Good') AS EquipmentStatus, " +
                            "COUNT(Id) AS Num " +
                            "FROM Equipment " +
                            "WHERE DateBought >= ? " +
                            "AND DateBought <= ? " +
                            "AND Status IN (0,1) " +
                            "GROUP BY Status";
            cnn = DBConnector.getConnection();
            psm = cnn.prepareStatement(sql);
            psm.setDate(1, new java.sql.Date(dateFrom.getTime()));
            psm.setDate(2, new java.sql.Date(dateTo.getTime()));
            rs = psm.executeQuery();
            stats = new ArrayList<>();
            while (rs.next()) {
                String statusLabel = rs.getString("EquipmentStatus");
                int count = rs.getInt("Num");

                StatisticUnit unit = new StatisticUnit.Builder()
                        .statusLabel(statusLabel)
                        .count(count)
                        .build();

                stats.add(unit);
            }

        } finally {
            closeConnection(cnn, psm, rs);
        }

        return stats;

    }


    public List<StatisticUnit> getStatusWarrantyStats(int warrantyFrom, int warrantyTo) throws Exception {
        List<StatisticUnit> stats;
        try {
            String sql =
                    "SELECT IIF(Status = 0, 'Broken', 'Good') AS EquipmentStatus, COUNT(Id) AS Num " +
                            "FROM Equipment " +
                            "WHERE Warranty >= ? " +
                            "AND Warranty <= ? " +
                            "AND Status IN (0,1) " +
                            "GROUP BY Status";
            cnn = DBConnector.getConnection();
            psm = cnn.prepareStatement(sql);
            psm.setInt(1, warrantyFrom);
            psm.setInt(2, warrantyTo);
            rs = psm.executeQuery();
            stats = new ArrayList<>();
            while (rs.next()) {
                String statusLabel = rs.getString("EquipmentStatus");
                int count = rs.getInt("Num");

                StatisticUnit unit = new StatisticUnit.Builder()
                        .statusLabel(statusLabel)
                        .count(count)
                        .build();


                stats.add(unit);
            }

        } finally {
            closeConnection(cnn, psm, rs);
        }

        return stats;
    }


    public List<StatisticUnit> getSpecialStats() throws Exception {

        List<StatisticUnit> list = null;

        try {
            String sql = "SELECT IIF(Status = 0, 'Broken', 'Good') AS EquipmentStatus, " +
                    "Warranty, count(Id) AS Num " +
                    "FROM Equipment " +
                    "WHERE Status IN (0, 1) " +
                    "GROUP BY Status, Warranty " +
                    "ORDER BY Status";
            cnn = DBConnector.getConnection();
            psm = cnn.prepareStatement(sql);

            rs = psm.executeQuery();

            list = new ArrayList<>();
            while (rs.next()) {
                String statusLabel = rs.getString("EquipmentStatus");
                String warrantyLabel = rs.getString("Warranty");
                int count = rs.getInt("Num");

                StatisticUnit unit = new StatisticUnit.Builder()
                        .statusLabel(statusLabel)
                        .warrantyLabel(warrantyLabel)
                        .count(count)
                        .build();

                list.add(unit);
            }

        } finally {
            closeConnection(cnn, psm, rs);
        }

        return list;
    }


    public List<EquipmentDTO> getList(int status, Date dateExpiredFrom, Date dateExpiredTo) throws Exception {
        List<EquipmentDTO> list = null;
        try {
            String sql = "{call spGetEquipmentListType1 (?,?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setInt(1, status);
            csm.setDate(2, new java.sql.Date(dateExpiredFrom.getTime()));
            csm.setDate(3, new java.sql.Date(dateExpiredTo.getTime()));

            rs = csm.executeQuery();

            list = getEquipmentListFromResultSet(rs);

        } finally {
            closeConnection(cnn, csm, rs);
        }

        return list;
    }

    public List<EquipmentDTO> getList(int repairCount) throws Exception {
        List<EquipmentDTO> list = null;
        try {
            String sql = "{call spGetEquipmentListType2 (?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setInt(1, repairCount);

            rs = csm.executeQuery();

            list = getEquipmentListFromResultSet(rs);

        } finally {
            closeConnection(cnn, csm, rs);
        }

        return list;
    }

    private List<EquipmentDTO> getEquipmentListFromResultSet(ResultSet rs) throws Exception {
        List<EquipmentDTO> list = null;
        if (rs.next()) {
            list = new ArrayList<>();
            do {
                String id = rs.getString("Id");
                String name = rs.getString("Name");
                Date dateBought = new Date(rs.getDate("DateBought").getTime());
                int warranty = rs.getInt("Warranty");
                Date dateExpired = new Date((rs.getDate("DateExpired").getTime()));
                int timeRepaired = rs.getInt("TimeRepaired");
                int status = rs.getInt("Status");

                String typeName = rs.getString("TypeName");
                EquipmentDTO.Type type = EquipmentDTO.Type.buildSoftType(typeName);

                String roomId = rs.getString("RoomId");
                String roomName = rs.getString("RoomName");
                RoomDTO currentRoom = new RoomDTO.Builder(roomId).label(roomName).build();

                RequestDTO request = null;
                int requestId = rs.getInt("RequestId");
                int requestStatus = rs.getInt("RequestStatus");
                if (requestId != 0) { //default value of result set get int if null
                    request = new RequestDTO.Builder(requestId)
                            .requestStatus(requestStatus)
                            .build();
                }


                EquipmentDTO equipment = new EquipmentDTO.Builder(id)
                        .name(name)
                        .dateBought(dateBought)
                        .warranty(warranty)
                        .dateExpired(dateExpired)
                        .timeRepaired(timeRepaired)
                        .status(status)
                        .type(type)
                        .currentRoom(currentRoom)
                        .currentRequest(request)
                        .build();

                list.add(equipment);
            } while (rs.next());
        }
        return list;
    }
}
