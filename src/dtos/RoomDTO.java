package dtos;

import java.io.Serializable;
import java.util.List;

public class RoomDTO implements Serializable {

    private String id, name;

    private List<AccountDTO> userList;
    private List<EquipmentDTO> equipmentList;

    private int equipmentCount;
    private int peopleCount;

    private  ErrorInformant errorInformant;

    private RoomDTO(Builder builder) {
        this.id = builder.id;
        this.name = builder.name;

        this.userList = builder.userList;
        this.equipmentList = builder.equipmentList;

        this.equipmentCount = builder.equipmentCount;
        this.peopleCount = builder.peopleCount;
        this.errorInformant = new ErrorInformant();
    }

    public static class ErrorInformant implements Serializable {

        private String idError;
        private String nameError;
        boolean clean;

        public ErrorInformant() {
            clean = true;
        }

        public String getIdError() {
            return idError;
        }

        public void setIdError(String idError) {
            this.idError = idError;
        }

        public String getNameError() {
            return nameError;
        }

        public void setNameError(String nameError) {
            this.nameError = nameError;
        }

        public boolean isClean() {
            return clean;
        }

        public void setClean(boolean clean) {
            this.clean = clean;
        }
    }

    public static class Builder implements Serializable {

        // Required
        private String id;

        // Optional
        private String name;
        private List<AccountDTO> userList;
        private List<EquipmentDTO> equipmentList;

        private int equipmentCount;
        private int peopleCount;

        public Builder(String id) {
            this.id = id;
        }

        public Builder label(String name) {
            this.name = name;
            return this;
        }

        public Builder userList(List<AccountDTO> list) {
            this.userList = list;
            return this;
        }

        public Builder equipmentList(List<EquipmentDTO> list) {
            this.equipmentList = list;
            return this;
        }

        public RoomDTO build() {
            return new RoomDTO(this);
        }

        public Builder equipmentCount(int equipmentCount) {
            this.equipmentCount = equipmentCount;
            return this;
        }

        public Builder peopleCount(int peopleCount) {
            this.peopleCount = peopleCount;
            return this;
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<AccountDTO> getUserList() {
        return userList;
    }

    public void setUserList(List<AccountDTO> userList) {
        this.userList = userList;
    }

    public List<EquipmentDTO> getEquipmentList() {
        return equipmentList;
    }

    public void setEquipmentList(List<EquipmentDTO> equipmentList) {
        this.equipmentList = equipmentList;
    }

    public int getEquipmentCount() {
        return equipmentCount;
    }

    public void setEquipmentCount(int equipmentCount) {
        this.equipmentCount = equipmentCount;
    }

    public int getPeopleCount() {
        return peopleCount;
    }

    public void setPeopleCount(int peopleCount) {
        this.peopleCount = peopleCount;
    }

    public ErrorInformant getErrorInformant() {
        return errorInformant;
    }

    public void setErrorInformant(ErrorInformant errorInformant) {
        this.errorInformant = errorInformant;
    }
}
