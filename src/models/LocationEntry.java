package models;

import dtos.RoomDTO;

import java.io.Serializable;
import java.util.Date;

public class LocationEntry implements Serializable {

    private RoomDTO room;
    private Date fromDate;
    private String byUserId;
    private String reason;

    public LocationEntry() {
    }

    public LocationEntry(RoomDTO room, Date fromDate, String byUserId, String reason) {
        this.room = room;
        this.fromDate = fromDate;
        this.byUserId = byUserId;
        this.reason = reason;
    }

    public RoomDTO getRoom() {
        return room;
    }

    public void setRoom(RoomDTO room) {
        this.room = room;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public String getByUserId() {
        return byUserId;
    }

    public void setByUserId(String byUserId) {
        this.byUserId = byUserId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
}
