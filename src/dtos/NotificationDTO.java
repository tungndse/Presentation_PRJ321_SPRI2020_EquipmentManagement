package dtos;

import java.io.Serializable;
import java.util.Date;

public class NotificationDTO implements Serializable {

    private int id;
    private String message;
    private Date date;
    private String type;

    public NotificationDTO(int id, String message, Date date, String type) {
        this.id = id;
        this.message = message;
        this.date = date;
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

}
