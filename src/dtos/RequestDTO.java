package dtos;

import java.io.Serializable;
import java.util.Date;

public class RequestDTO implements Serializable {
    private int id;

    private EquipmentDTO equipment;
    private AccountDTO requester;
    private int requestStatus;
    private Date timeRequested;
    private String requestDescription;

    private AccountDTO executor;
    private Date timeBegin;

    private int dateCountSinceBegin;
    private int dateCountSinceRequest;

    private String repairDiary;

    private Date timeDone;
    private boolean success;

    private RequestDTO(Builder builder) {
        this.id = builder.id;
        this.equipment = builder.equipment;
        this.requester = builder.requester;
        this.requestStatus = builder.requestStatus;
        this.timeRequested = builder.timeRequested;
        this.requestDescription = builder.requestDescription;
        this.executor = builder.executor;
        this.timeBegin = builder.timeBegin;
        this.repairDiary = builder.repairDiary;
        this.timeDone = builder.timeDone;
        this.success = builder.success;
        this.dateCountSinceRequest = builder.dateCountSinceRequest;
        this.dateCountSinceBegin = builder.dateCountSinceBegin;
    }

    public static class Builder {
        private int id;

        private EquipmentDTO equipment;
        private AccountDTO requester;
        private int requestStatus;
        private Date timeRequested;
        private String requestDescription;

        private AccountDTO executor;
        private Date timeBegin;
        private String repairDiary;

        private int dateCountSinceBegin;
        private int dateCountSinceRequest;

        private Date timeDone;
        private boolean success;

        public Builder(int id) {
            this.id = id;
        }

        public RequestDTO build() {
            return new RequestDTO(this);
        }

        public Builder equipment(EquipmentDTO equipment) {
            this.equipment = equipment;
            return this;
        }

        public Builder requester(AccountDTO requester) {
            this.requester = requester;
            return this;

        }

        public Builder requestStatus(int requestStatus) {
            this.requestStatus = requestStatus;
            return this;
        }

        public Builder timeRequest(Date timeRequested) {
            this.timeRequested = timeRequested;
            return this;
        }

        public Builder requestDescription(String requestDescription) {
            this.requestDescription = requestDescription;
            return this;
        }

        public Builder executor(AccountDTO executor) {
            this.executor = executor;
            return this;
        }

        public Builder timeBegin(Date timeBegin) {
            this.timeBegin = timeBegin;
            return this;
        }

        public Builder repairDiary(String repairDiary) {
            this.repairDiary = repairDiary;
            return this;
        }

        public Builder timeDone(Date timeDone) {
            this.timeDone = timeDone;
            return this;
        }

        public Builder success(boolean success) {
            this.success = success;
            return this;
        }

        public Builder dateCountSinceBegin(int dateCountSinceBegin) {
            this.dateCountSinceBegin = dateCountSinceBegin;
            return this;
        }

        public Builder dateCountSinceRequest(int dateCountSinceRequest) {
            this.dateCountSinceRequest = dateCountSinceRequest;
            return this;
        }
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public EquipmentDTO getEquipment() {
        return equipment;
    }

    public void setEquipment(EquipmentDTO equipment) {
        this.equipment = equipment;
    }

    public AccountDTO getRequester() {
        return requester;
    }

    public void setRequester(AccountDTO requester) {
        this.requester = requester;
    }

    public int getRequestStatus() {
        return requestStatus;
    }

    public void setRequestStatus(int requestStatus) {
        this.requestStatus = requestStatus;
    }

    public Date getTimeRequested() {
        return timeRequested;
    }

    public void setTimeRequested(Date timeRequested) {
        this.timeRequested = timeRequested;
    }

    public String getRequestDescription() {
        return requestDescription;
    }

    public void setRequestDescription(String requestDescription) {
        this.requestDescription = requestDescription;
    }

    public AccountDTO getExecutor() {
        return executor;
    }

    public void setExecutor(AccountDTO executor) {
        this.executor = executor;
    }

    public Date getTimeBegin() {
        return timeBegin;
    }

    public void setTimeBegin(Date timeBegin) {
        this.timeBegin = timeBegin;
    }

    public String getRepairDiary() {
        return repairDiary;
    }

    public void setRepairDiary(String repairDiary) {
        this.repairDiary = repairDiary;
    }

    public Date getTimeDone() {
        return timeDone;
    }

    public void setTimeDone(Date timeDone) {
        this.timeDone = timeDone;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public int getDateCountSinceBegin() {
        return dateCountSinceBegin;
    }

    public void setDateCountSinceBegin(int dateCountSinceBegin) {
        this.dateCountSinceBegin = dateCountSinceBegin;
    }

    public int getDateCountSinceRequest() {
        return dateCountSinceRequest;
    }

    public void setDateCountSinceRequest(int dateCountSinceRequest) {
        this.dateCountSinceRequest = dateCountSinceRequest;
    }
}
