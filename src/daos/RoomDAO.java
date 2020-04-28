package daos;

import db.DBConnector;
import dtos.AccountDTO;
import dtos.EquipmentDTO;
import dtos.RoomDTO;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class RoomDAO extends PrimitiveDAO implements Serializable {
    public List<RoomDTO> getList() throws Exception {
        List<RoomDTO> list = null;
        try {
            String sql = "SELECT Id, Name FROM Room WHERE Status = 1";
            cnn = DBConnector.getConnection();
            psm = cnn.prepareStatement(sql);
            rs = psm.executeQuery();
            list = new ArrayList<>();
            while (rs.next()) {
                String id = rs.getString("Id");
                String name = rs.getString("Name");
                RoomDTO room = new RoomDTO.Builder(id).label(name).build();
                list.add(room);
            }
        } finally {
            closeConnection(cnn, psm, rs);
        }

        return list;
    }

    public RoomDTO get(String id) throws Exception {
        RoomDTO room = null;
        List<AccountDTO> accountList = null;
        List<EquipmentDTO> equipmentList = null;

        try {
            String sql = "{call spGetRoom (?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            csm.setString(1, id);

            int equipmentCount = 0;
            int peopleCount = 0;

            rs = csm.executeQuery();
            if (rs.next()) {
                String roomName = rs.getString("Name");
                equipmentCount = rs.getInt("EquipmentCount");
                peopleCount = rs.getInt("PeopleCount");
                room = new RoomDTO.Builder(id).label(roomName)
                        .equipmentCount(equipmentCount)
                        .peopleCount(peopleCount)
                        .build();
            }

            if (peopleCount != 0) {
                csm.getMoreResults();
                rs2 = csm.getResultSet();
                if (rs2.next()) {
                    accountList = new ArrayList<>();
                    do {
                        String username = rs2.getString("Username");
                        String givenName = rs2.getString("GivenName");
                        String lastName = rs2.getString("LastName");
                        int role = rs2.getInt("Role");

                        AccountDTO account = new AccountDTO.Builder(username).fullName(givenName, lastName).role(role)
                                .build();

                        accountList.add(account);
                    } while (rs2.next());
                }
            }

            if (equipmentCount != 0) {
                csm.getMoreResults();
                rs3 = csm.getResultSet();
                if (rs3.next()) {
                    equipmentList = new ArrayList<>();
                    do {
                        String eId = rs3.getString("EquipmentId");
                        String name = rs3.getString("EquipmentName");
                        Date dateBought = new Date(rs3.getDate("DateBought").getTime());
                        int warranty = rs3.getInt("Warranty");
                        int timeRepaired = rs3.getInt("TimeRepaired");
                        int status = rs3.getInt("Status");
                        String typeName = rs3.getString("TypeName");
                        String description = rs3.getString("Description");

                        EquipmentDTO equipment = new EquipmentDTO.Builder(eId).name(name).dateBought(dateBought)
                                .warranty(warranty).timeRepaired(timeRepaired).status(status)
                                .type(EquipmentDTO.Type.buildSoftType(typeName))
                                .description(description).build();
                        equipmentList.add(equipment);
                    } while (rs3.next());
                }
            }

            if (room != null) {
                room.setEquipmentList(equipmentList);
                room.setUserList(accountList);
            }

        } finally {
            closeConnection(cnn, csm, rs, rs2, rs3);
        }

        return room;
    }


    public List<RoomDTO> getExpandedList() throws Exception {
        //R.Id, R.Name, ECountTbl.EquipmentCount, PCountTbl.PeopleCount
        List<RoomDTO> list;
        try {
            String sql = "{call spGetRoomsListWithStats (?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            csm.setString(1, null);

            rs = csm.executeQuery();

            list = new ArrayList<>();
            while (rs.next()) {
                String id = rs.getString("Id");
                String name = rs.getString("Name");

                int equipmentCount = rs.getInt("EquipmentCount");
                int peopleCount = rs.getInt("PeopleCount");

                RoomDTO room = new RoomDTO.Builder(id)
                        .label(name)
                        .equipmentCount(equipmentCount)
                        .peopleCount(peopleCount)
                        .build();

                list.add(room);
            }
        } finally {
            closeConnection(cnn, csm, rs);
        }

        return list;
    }

    public void update(String roomId, String newName, String byUser) throws Exception {
        try {
            String sql = "{call spUpdateRoomName (?,?, ?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            csm.setString(1, roomId);
            csm.setString(2, newName);
            csm.setString(3, byUser);
            csm.execute();
        } finally {
            closeConnection(cnn, csm);
        }
    }

    public void delete(String roomId, String username) throws Exception {
        try {
            String sql = "{call spDeleteRoom (?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setString(1, roomId);
            csm.setString(2, username);

            csm.execute();
        } finally {
            closeConnection(cnn, csm);
        }
    }

    public void insert(String roomId, String roomName, String byUser) throws Exception {
        try {
            String sql = "{call spCreateRoom (?,?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setString(1, roomId);
            csm.setString(2, roomName);
            csm.setString(3, byUser);

            csm.execute();

        } finally {
            closeConnection(cnn, csm, rs);
        }
    }
}
