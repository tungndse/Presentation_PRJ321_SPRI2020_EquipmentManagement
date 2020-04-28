package daos;

import db.DBConnector;
import dtos.NotificationDTO;
import models.NotificationCarrier;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class NotificationDAO extends PrimitiveDAO implements Serializable {

    public NotificationCarrier search(String forUserId) throws Exception {
        return this.search(forUserId, "all", null, 100);
    }

    public NotificationCarrier search(String forUserId, int topSelectNumber) throws Exception {
        return this.search(forUserId, "all", null, topSelectNumber);
    }

    public NotificationCarrier search(String forUserId, String typeGroup,
                                      Timestamp fromDate, int topSelectNumber) throws Exception {
        NotificationCarrier carrier;
        List<NotificationDTO> list;
        int countUnread = 0;

        try {
            String sql = "{call spLoadNotification (?, ?, ?, ?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            csm.setString(1, forUserId);
            csm.setString(2, typeGroup);
            csm.setTimestamp(3, fromDate);
            csm.setInt(4, topSelectNumber);

            rs = csm.executeQuery();
            list = new ArrayList<>();
            while (rs.next()) {
                int id = rs.getInt("Id");
                String message = rs.getString("Message");
                String typeId = rs.getString("TypeId");
                Date timeCreated = new Date(rs.getTimestamp("TimeCreated").getTime());
                NotificationDTO notification = new NotificationDTO(id, message, timeCreated, typeId);
                list.add(notification);

            }

            csm.getMoreResults();
            rs2 = csm.getResultSet();
            if (rs2.next()) {
                countUnread = rs2.getInt("CountUnread");
            }

            carrier = new NotificationCarrier(list, countUnread);
        } finally {
            closeConnection(cnn, csm, rs, rs2);
        }

        return carrier;
    }

    public int count(String username) throws Exception {
        int count = 0;

        try {
            String sql = "SELECT COUNT(Id) as Count FROM Notification " +
                    "WHERE ForUser=?";
            cnn = DBConnector.getConnection();
            psm = cnn.prepareStatement(sql);
            psm.setString(1, username);

            rs = psm.executeQuery();
            if (rs.next()) {
                count = rs.getInt("Count");
            }
        } finally {
            closeConnection(cnn, psm, rs);
        }

        return count;
    }

    public int delete(String[] listIds) throws Exception {
        int deletedCount;

        try {
            StringBuilder builder = new StringBuilder();

            builder.append('(');

            for (String id : listIds) {
                builder.append(id).append(",");
            }

            if (builder.length() > 0) {
                builder.setLength(builder.length() - 1);
            }

            builder.append(')');

            String sql = "DELETE FROM Notification WHERE Id IN " + builder;
            cnn = DBConnector.getConnection();
            psm = cnn.prepareStatement(sql);
            deletedCount = psm.executeUpdate();

        } finally {
            closeConnection(cnn, psm);
        }

        return deletedCount;
    }

    public int deleteAll(String username) throws Exception {
        int deleteCount = 0;

        try {
            String sql = "DELETE FROM Notification WHERE ForUser=?";
            cnn = DBConnector.getConnection();
            psm = cnn.prepareStatement(sql);
            psm.setString(1, username);
            deleteCount = psm.executeUpdate();
        } finally {
            closeConnection(cnn, psm);
        }

        return deleteCount;
    }
}
