package managers;

import daos.NotificationDAO;
import models.NotificationCarrier;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class NotificationManager implements Serializable {

    //TODO on home page, top number of notification loaded is limited by select 10, 20, 30, 50, 100 (most recent)

    private static final String DATE_FORMAT_STD = "yyyy-MM-dd";
    private static final String TIMESTAMP_FORMAT_STD = "yyyy-MM-dd HH:mm:ss";

    public NotificationCarrier loadNotification(String forUserId) throws Exception {
        return new NotificationDAO().search(forUserId);
    }

    public NotificationCarrier loadNotification(String forUserId, String topSelectNumberStr) throws Exception {

        int topSelectNumber;

        try {
            if (topSelectNumberStr == null) {
                topSelectNumber = 100;
            } else {
                topSelectNumber = Integer.parseInt(topSelectNumberStr);
            }

            if (topSelectNumber < 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException nfe) {
            throw new Exception("NOTIFLOAD-Invalid top select input (must be positive integer)");
        }

        return new NotificationDAO().search(forUserId, topSelectNumber);
    }


    public NotificationCarrier loadNotification(String forUserId, String typeGroup,
                                                String fromDateStr, String topSelectNumberStr) throws Exception {
        Date date;
        Timestamp sqlTimeStamp;
        int topSelectNumber;

        if (!typeGroup.equals("user") && !typeGroup.equals("equipment")
                && !typeGroup.equals("room") && !typeGroup.equals("request")
                && !typeGroup.equals("all")) {
            throw new Exception("NOTIFLOAD-Invalid type group string");
        }

        try {

            if ((fromDateStr == null) || fromDateStr.isEmpty()) {
                sqlTimeStamp = null;
            } else {
                date = new SimpleDateFormat(DATE_FORMAT_STD).parse(fromDateStr);
                sqlTimeStamp = new Timestamp(date.getTime());
            }

            if (topSelectNumberStr == null) {
                topSelectNumber = 100;
            } else {
                topSelectNumber = Integer.parseInt(topSelectNumberStr);
            }

        } catch (ParseException pe) {
            throw new Exception("NOTIFLOAD-Invalid date input");
        } catch (NumberFormatException nfe) {
            throw new Exception("NOTIFLOAD-Invalid top select input (must be positive integer)");
        }

        return new NotificationDAO().search(forUserId, typeGroup, sqlTimeStamp, topSelectNumber);
    }

    public int getCount(String username) throws Exception {
        return new NotificationDAO().count(username);
    }

    public int deleteNotificationList(String[] listIds) throws Exception {
        if (listIds.length == 0) {
            return 0;
        }

        return new NotificationDAO().delete(listIds);
    }

    public int deleteAllNotification(String username) throws Exception{
        return new NotificationDAO().deleteAll(username);
    }
}
