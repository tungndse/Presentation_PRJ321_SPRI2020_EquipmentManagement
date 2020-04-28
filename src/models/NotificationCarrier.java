package models;

import dtos.NotificationDTO;

import java.io.Serializable;
import java.util.List;

public class NotificationCarrier implements Serializable {

    List<NotificationDTO> notificationList;
    int count;

    public NotificationCarrier(List<NotificationDTO> notificationList, int count) {
        this.notificationList = notificationList;
        this.count = count;
    }

    public List<NotificationDTO> getNotificationList() {
        return notificationList;
    }

    public void setNotificationList(List<NotificationDTO> notificationList) {
        this.notificationList = notificationList;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }
}
