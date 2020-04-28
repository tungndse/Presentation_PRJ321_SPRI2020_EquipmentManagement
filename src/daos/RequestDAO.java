package daos;

import db.DBConnector;
import dtos.AccountDTO;
import dtos.EquipmentDTO;
import dtos.RequestDTO;
import models.RequestContainer;
import models.RequestContainerAdmin;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class RequestDAO extends PrimitiveDAO implements Serializable {
    public void deny(int requestId, String username, String denyReason) throws Exception {
        try {
            System.out.println("DAO");
            String sql = "{call spDenyRequest (?,?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            csm.setInt(1, requestId);
            csm.setString(2, username);
            csm.setString(3, denyReason);

            csm.execute();
        } finally {
            closeConnection(cnn, csm);
        }
    }

    public void cancel(int requestId, String cancelReason) throws Exception {
        try {
            String sql = "{call spCancelRequest (?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setInt(1, requestId);
            csm.setString(2, cancelReason);

            csm.execute();
        } finally {
            closeConnection(cnn, csm);
        }
    }

    public void accept(int requestId, String username) throws Exception {
        try {
            String sql = "{call spAcceptRequest (?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setInt(1, requestId);
            csm.setString(2, username);

            csm.execute();
        } finally {
            closeConnection(cnn, csm);
        }

    }

    public RequestDTO get(int requestId) throws Exception {
        RequestDTO request = null;
        AccountDTO requester = null;
        AccountDTO executor = null;

        try {
            String sql = "{call spGetActiveRequest (?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setInt(1, requestId);

            rs = csm.executeQuery();
            if (rs.next()) {
                int status = rs.getInt("Status");

                String equipmentId = rs.getString("EquipmentId");
                String equipmentName = rs.getString("EquipmentName");
                String equipmentTypeName = rs.getString("EquipmentTypeName");

                EquipmentDTO equipment = new EquipmentDTO.Builder(equipmentId)
                        .name(equipmentName)
                        .type(EquipmentDTO.Type.buildSoftType(equipmentTypeName))
                        .build();

                String requesterId = rs.getString("CreatedBy");
                String requesterGivenName = rs.getString("RequesterGivenName");
                String requesterLastName = rs.getString("RequesterLastName");

                requester = new AccountDTO.Builder(requesterId)
                        .fullName(requesterGivenName, requesterLastName).build();

                String requestDescription = rs.getString("RequestDescription");
                Date timeRequested = new Date(rs.getTimestamp("TimeCreated").getTime());

                String executorId = rs.getString("ProceededBy");
                String executorGivenName = rs.getString("ExecutorGivenName");
                String executorLastName = rs.getString("ExecutorLastName");

                Date timeStarted = null;
                String repairDiary = null;

                if (executorId != null) {
                    executor = new AccountDTO.Builder(executorId)
                            .fullName(executorGivenName, executorLastName).build();
                    timeStarted = new Date(rs.getTimestamp("TimeStart").getTime());
                    repairDiary = rs.getString("RepairDiary");
                }

                request = new RequestDTO.Builder(requestId)
                        .equipment(equipment)
                        .requestStatus(status)
                        .requester(requester)
                        .executor(executor)
                        .timeRequest(timeRequested).timeBegin(timeStarted)
                        .requestDescription(requestDescription).repairDiary(repairDiary)
                        .build();

            }
        } finally {
            closeConnection(cnn, csm, rs);
        }

        return request;
    }

    public void update(int requestId, String repairDiary) throws Exception {
        try {
            String sql = "{call spUpdateReportDescription (?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setInt(1, requestId);
            csm.setString(2, repairDiary);

            csm.execute();
        } finally {
            closeConnection(cnn, csm, rs);
        }
    }

    public void finish(int requestId, boolean success) throws Exception {
        try {
            String sql = "{call spFinishRequest (?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setInt(1, requestId);
            csm.setBoolean(2, success);

            csm.execute();
        } finally {
            closeConnection(cnn, csm, rs);
        }
    }

    public void make(String equipmentId, String username, String description) throws Exception {
        try {
            String sql = "{call spMakeRequest (?,?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setString(1,equipmentId);
            csm.setString(2,username);
            csm.setString(3, description);

            csm.execute();
        } finally {
            closeConnection(cnn, csm, rs);
        }
    }

    public RequestContainer getTechContainer(String techUsername) throws Exception {
        RequestContainer container = null;
        List<RequestDTO> pushedList = null;
        List<RequestDTO> ownedList = null;
        AccountDTO tech = new AccountDTO.Builder(techUsername).build();
        try {
            String sql = "{call spGetDualRequestContainer(?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            csm.setString(1, techUsername);

            rs = csm.executeQuery();
            pushedList = new ArrayList<>();
            while (rs.next()) {
                int id = rs.getInt("Id");

                String equipmentId = rs.getString("EquipmentId");
                String equipmentName = rs.getString("EquipmentName");
                String equipmentTypeName = rs.getString("EquipmentTypeName");

                EquipmentDTO equipment = new EquipmentDTO.Builder(equipmentId)
                        .name(equipmentName).type(EquipmentDTO.Type.buildSoftType(equipmentTypeName))
                        .build();

                String requesterId = rs.getString("CreatedBy");
                AccountDTO requester = new AccountDTO.Builder(requesterId).build();

                Date timeRequest = new Date(rs.getTimestamp("TimeCreated").getTime());

                int dayRequestCount = rs.getInt("DayCountSinceRequest");

                RequestDTO request = new RequestDTO.Builder(id).equipment(equipment)
                        .requester(requester).timeRequest(timeRequest).requestStatus(0)
                        .dateCountSinceRequest(dayRequestCount)
                        .build();

                pushedList.add(request);

            }

            csm.getMoreResults();
            rs2 = csm.getResultSet();
            ownedList = new ArrayList<>();
            while (rs2.next()) {

                int id = rs2.getInt("Id");

                String equipmentId = rs2.getString("EquipmentId");
                String equipmentName = rs2.getString("EquipmentName");
                String equipmentTypeName = rs2.getString("EquipmentTypeName");

                EquipmentDTO equipment = new EquipmentDTO.Builder(equipmentId)
                        .name(equipmentName).type(EquipmentDTO.Type.buildSoftType(equipmentTypeName))
                        .build();

                String requesterId = rs2.getString("CreatedBy");
                AccountDTO requester = new AccountDTO.Builder(requesterId).build();

                Date timeRequest = new Date(rs2.getTimestamp("TimeCreated").getTime());

                String executorId = rs2.getString("ProceededBy");
                AccountDTO executor = new AccountDTO.Builder(executorId).build();

                Date timeStart = new Date(rs2.getTimestamp("TimeStart").getTime());

                int dayRequestCount = rs2.getInt("DayCountSinceRequest");
                int dayBeginCount = rs2.getInt("DayCountSinceBegin");

                RequestDTO request = new RequestDTO.Builder(id).equipment(equipment)
                        .requester(requester).executor(executor)
                        .timeRequest(timeRequest).timeBegin(timeStart)
                        .dateCountSinceRequest(dayRequestCount)
                        .dateCountSinceBegin(dayBeginCount)
                        .build();

                ownedList.add(request);

            }

            container = new RequestContainer(tech, pushedList, ownedList);

        } finally {
            closeConnection(cnn, csm, rs, rs2);
        }

        return container;
    }

    public List<RequestDTO> getUserRequestList(String username) throws Exception {
        List<RequestDTO> list = null;
        try {
            String sql = "{call spGetSingleRequestContainer(?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            csm.setString(1, username);

            rs = csm.executeQuery();
            if (rs.next()) {
                list = new ArrayList<>();
                do {
                    int id = rs.getInt("RequestId");

                    String equipmentId = rs.getString("EquipmentId");
                    String equipmentName = rs.getString("EquipmentName");
                    EquipmentDTO equipment = new EquipmentDTO.Builder(equipmentId).name(equipmentName).build();

                    String requesterId = rs.getString("CreatedBy");
                    AccountDTO requester = new AccountDTO.Builder(requesterId).build();

                    Date timeRequested = new Date(rs.getDate("TimeCreated").getTime());
                    int status = rs.getInt("RequestStatus");

                    int dayCountSinceRequest = rs.getInt("DayCountSinceRequest");
                    int dayCountSinceBegin = 0;

                    AccountDTO executor = null;
                    Date timeBegin = null;
                    if (status == 1) {
                        String executorId = rs.getString("ProceededBy");
                        executor = new AccountDTO.Builder(executorId).build();
                        timeBegin = new Date(rs.getDate("TimeStart").getTime());
                        dayCountSinceBegin = rs.getInt("DayCountSinceBegin");
                    }

                    RequestDTO request = new RequestDTO.Builder(id)
                            .requestStatus(status)
                            .equipment(equipment)
                            .requester(requester)
                            .timeRequest(timeRequested)
                            .executor(executor)
                            .timeBegin(timeBegin)
                            .dateCountSinceRequest(dayCountSinceRequest)
                            .dateCountSinceBegin(dayCountSinceBegin)
                            .build();

                    list.add(request);

                } while (rs.next());

            }
        } finally {
            closeConnection(cnn, csm, rs);
        }

        return list;
    }

    public RequestContainerAdmin getAdminContainer() throws Exception {
        RequestContainerAdmin container = null;
        List<RequestDTO> pushedList = null;
        List<RequestDTO> acceptedList = null;

        try {
            String sql = "{call spGetDualRequestContainerForAdmin()}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            rs = csm.executeQuery();
            pushedList = new ArrayList<>();
            while (rs.next()) {
                int id = rs.getInt("Id");

                String equipmentId = rs.getString("EquipmentId");
                String equipmentName = rs.getString("EquipmentName");
                String equipmentTypeName = rs.getString("EquipmentTypeName");

                EquipmentDTO equipment = new EquipmentDTO.Builder(equipmentId)
                        .name(equipmentName).type(EquipmentDTO.Type.buildSoftType(equipmentTypeName))
                        .build();

                String requesterId = rs.getString("CreatedBy");
                AccountDTO requester = new AccountDTO.Builder(requesterId).build();

                Date timeRequest = new Date(rs.getTimestamp("TimeCreated").getTime());

                int dayRequestCount = rs.getInt("DayCountSinceRequest");

                RequestDTO request = new RequestDTO.Builder(id).equipment(equipment)
                        .requester(requester).timeRequest(timeRequest).requestStatus(0)
                        .dateCountSinceRequest(dayRequestCount)
                        .build();

                pushedList.add(request);

            }

            csm.getMoreResults();
            rs2 = csm.getResultSet();
            acceptedList = new ArrayList<>();
            while (rs2.next()) {

                int id = rs2.getInt("Id");

                String equipmentId = rs2.getString("EquipmentId");
                String equipmentName = rs2.getString("EquipmentName");
                String equipmentTypeName = rs2.getString("EquipmentTypeName");

                EquipmentDTO equipment = new EquipmentDTO.Builder(equipmentId)
                        .name(equipmentName).type(EquipmentDTO.Type.buildSoftType(equipmentTypeName))
                        .build();

                String requesterId = rs2.getString("CreatedBy");
                AccountDTO requester = new AccountDTO.Builder(requesterId).build();

                Date timeRequest = new Date(rs2.getTimestamp("TimeCreated").getTime());

                String executorId = rs2.getString("ProceededBy");
                AccountDTO executor = new AccountDTO.Builder(executorId).build();

                Date timeStart = new Date(rs2.getTimestamp("TimeStart").getTime());

                int dayRequestCount = rs2.getInt("DayCountSinceRequest");
                int dayBeginCount = rs2.getInt("DayCountSinceBegin");

                RequestDTO request = new RequestDTO.Builder(id).equipment(equipment)
                        .requester(requester).executor(executor)
                        .timeRequest(timeRequest).timeBegin(timeStart)
                        .dateCountSinceRequest(dayRequestCount)
                        .dateCountSinceBegin(dayBeginCount)
                        .build();

                acceptedList.add(request);

            }

            container = new RequestContainerAdmin(pushedList, acceptedList);

        } finally {
            closeConnection(cnn, csm, rs, rs2);
        }

        return container;
    }


}
