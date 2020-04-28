package daos;

import db.DBConnector;
import dtos.AccountDTO;
import dtos.RequestDTO;
import dtos.RoomDTO;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class AccountDAO extends PrimitiveDAO implements Serializable {

    public AccountDTO login(AccountDTO loginUser) throws Exception {
        AccountDTO validatedUser = null;
        String username, givenName, lastName;
        int role;
        Date timeLogin;

        try {
            String sql = "{call spValidateLogin(?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            csm.setString(1, loginUser.getUsername());
            csm.setString(2, loginUser.getPassword());
            rs = csm.executeQuery();

            if (rs.next()) {
                username = rs.getString("Username");
                givenName = rs.getString("GivenName");
                lastName = rs.getString("LastName");
                role = rs.getInt("Role");
                timeLogin = new Date(rs.getTimestamp("TimeLogin").getTime());

                //validatedUser = AccountBuilder.buildAccountStd(username, givenName, lastName, role, timeLogin);
                validatedUser = new AccountDTO.Builder(username)
                        .fullName(givenName, lastName)
                        .role(role)
                        .loginTime(timeLogin)
                        .build();
            }

        } finally {
            closeConnection(cnn, csm, rs);
        }

        return validatedUser;
    }

    public void save(AccountDTO regUser, String byUser) throws Exception {
        try {
            String sql = "{call spSaveAccount(?,?,?,?,?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setString(1, regUser.getUsername());
            csm.setString(2, regUser.getGivenName());
            csm.setString(3, regUser.getLastName());
            csm.setString(4, regUser.getPassword());
            csm.setInt(5, regUser.getRole());
            csm.setString(6, byUser);
            csm.execute();
        } finally {
            closeConnection(cnn, csm);
        }

    }

    public void update(AccountDTO updUser, String byUser) throws Exception {
        try {
            String sql = "{call spUpdateAccount (?,?,?,?,?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setString(1, updUser.getUsername());
            csm.setString(2, updUser.getGivenName());
            csm.setString(3, updUser.getLastName());
            csm.setString(4, updUser.getPassword());
            csm.setInt(5, updUser.getRole());
            csm.setString(6, byUser);
            csm.execute();

        } finally {
            closeConnection(cnn, csm);
        }
    }

    public void delete(String usernameOfDeleted, String byUser) throws Exception {
        try {
            String sql = "{call spDeleteAccount (?, ?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setString(1, usernameOfDeleted);
            csm.setString(2, byUser);
            csm.execute();

        } finally {
            closeConnection(cnn, csm);
        }
    }

    public AccountDTO get(String username) throws Exception {
        AccountDTO dto = null;

        System.out.println(username);

        try {
            String sql = "{call spGetAccount(?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);

            csm.setString(1, username);
            rs = csm.executeQuery();

            if (rs.next()) {
                String givenName = rs.getString("GivenName");
                String lastName = rs.getString("LastName");
                boolean status = rs.getBoolean("Status");
                int role = rs.getInt("Role");

                String roomId = rs.getString("RoomId");
                String roomName = rs.getString("RoomName");

                RoomDTO room = new RoomDTO.Builder(roomId)
                        .label(roomName)
                        .build();

                dto = new AccountDTO.Builder(username)
                        .fullName(givenName, lastName).status(status)
                        .role(role).room(room).build();
            }

        } finally {
            closeConnection(cnn, csm, rs);
        }

        return dto;
    }

    public List<AccountDTO> search(String givenNameSearch, String lastNameSearch,
                                   String filteredRoomId, boolean banIncluded) throws Exception {
        List<AccountDTO> list;
        try {
            String sql = "{call spGetAccountList (?,?,?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            csm.setString(1, givenNameSearch);
            csm.setString(2, lastNameSearch);
            csm.setString(3, filteredRoomId);
            csm.setBoolean(4, banIncluded);

            rs = csm.executeQuery();
            list = new ArrayList<>();

            while (rs.next()) {
                String username = rs.getString("Username");
                String givenName = rs.getString("GivenName");
                String lastName = rs.getString("LastName");
                boolean status = rs.getBoolean("Status");
                int role = rs.getInt("Role");

                String roomId = rs.getString("RoomId");
                String roomName = rs.getString("RoomName");

                RoomDTO room = new RoomDTO.Builder(roomId)
                        .label(roomName)
                        .build();

                AccountDTO dto = new AccountDTO.Builder(username)
                        .fullName(givenName, lastName)
                        .status(status)
                        .role(role)
                        .room(room)
                        .build();

                list.add(dto);
            }

        } finally {
            closeConnection(cnn, csm, rs);
        }

        return list;
    }



}
