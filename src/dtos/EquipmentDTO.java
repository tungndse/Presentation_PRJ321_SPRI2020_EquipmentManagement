package dtos;

import models.LocationEntry;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class EquipmentDTO implements Serializable {

    private String id;
    private String name;
    private Date dateBought;
    private int warranty;

    private Date dateExpired;

    private int timeRepaired;
    private int status;
    private String description;

    private String imagePath;

    private Type type;
    private RoomDTO currentRoom;
    private RequestDTO currentRequest;

    ErrorInformant errorInformant;

    private List<LocationEntry> locationEntries;
    private List<RequestDTO> reportList;

    private EquipmentDTO(Builder builder) {
        this.id = builder.id;
        this.name = builder.name;
        this.dateBought = builder.dateBought;
        this.warranty = builder.warranty;

        this.dateExpired = builder.dateExpired;

        this.timeRepaired = builder.timeRepaired;
        this.status = builder.status;
        this.description = builder.description;
        this.imagePath = builder.imagePath;

        this.type = builder.type;
        this.currentRoom = builder.currentRoom;
        this.currentRequest = builder.currentRequest;

        this.locationEntries = builder.locationEntries;
        this.reportList = builder.reportList;

        this.errorInformant = builder.errorInformant == null ? new ErrorInformant() : builder.errorInformant;
    }

    public static class ErrorInformant implements Serializable {
        private String idError, nameError, dateBroughtError, warrantyError, descriptionError;
        private String typeError;
        private String otherError;
        private String uncaughtError;
        private boolean isClean;

        public ErrorInformant() {
            this.isClean = true;
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

        public String getDateBroughtError() {
            return dateBroughtError;
        }

        public void setDateBroughtError(String dateBroughtError) {
            this.dateBroughtError = dateBroughtError;
        }

        public String getWarrantyError() {
            return warrantyError;
        }

        public void setWarrantyError(String warrantyError) {
            this.warrantyError = warrantyError;
        }

        public String getDescriptionError() {
            return descriptionError;
        }

        public void setDescriptionError(String descriptionError) {
            this.descriptionError = descriptionError;
        }

        public String getOtherError() {
            return otherError;
        }

        public void setOtherError(String otherError) {
            this.otherError = otherError;
        }

        public String getUncaughtError() {
            return uncaughtError;
        }

        public void setUncaughtError(String uncaughtError) {
            this.uncaughtError = uncaughtError;
        }

        public String getTypeError() {
            return typeError;
        }

        public void setTypeError(String typeError) {
            this.typeError = typeError;
        }

        public boolean isClean() {
            return isClean;
        }

        public void setClean(boolean clean) {
            isClean = clean;
        }
    }

    public static class Builder implements Serializable {
        private String id;
        private String name;
        private Date dateBought;
        private int warranty;

        private Date dateExpired;

        private int timeRepaired;
        private int status;
        private Type type;
        private String description;

        private String imagePath;
        private RoomDTO currentRoom;
        private RequestDTO currentRequest;

        private ErrorInformant errorInformant;

        private List<LocationEntry> locationEntries;
        private List<RequestDTO> reportList;

        public EquipmentDTO build() {
            return new EquipmentDTO(this);
        }

        public Builder(String id) {
            this.id = id;
        }

        public Builder name(String name) {
            this.name = name;
            return this;
        }

        public Builder dateBought(Date dateBought) {
            this.dateBought = dateBought;
            return this;

        }

        public Builder warranty(int warranty) {
            this.warranty = warranty;
            return this;
        }

        public Builder timeRepaired(int timeRepaired) {
            this.timeRepaired = timeRepaired;
            return this;
        }

        public Builder status(int status) {
            this.status = status;
            return this;
        }

        public Builder type(Type type) {
            this.type = type;
            return this;
        }

        public Builder description(String description) {
            this.description = description;
            return this;
        }

        public Builder imagePath(String imagePath) {
            this.imagePath = imagePath;
            return this;
        }

        public Builder currentRoom(RoomDTO currentRoom) {
            this.currentRoom = currentRoom;
            return this;
        }

        public Builder currentRequest(RequestDTO currentRequestDTO) {
            this.currentRequest = currentRequestDTO;
            return this;
        }

        public Builder error(ErrorInformant errorInformant) {
            this.errorInformant = errorInformant;
            return this;
        }

        public Builder locationEntries(List<LocationEntry> locationEntries) {
            this.locationEntries = locationEntries;
            return this;
        }

        public Builder reportList(List<RequestDTO> reportList) {
            this.reportList = reportList;
            return this;
        }

        public Builder dateExpired(Date dateExpired) {
            this.dateExpired = dateExpired;
            return this;
        }

    }

    public static class Type implements Serializable {
        private int id;
        private String name;

        private Type(int id, String name) {
            this.id = id;
            this.name = name;
        }

        private Type(String name) {
            this.name = name;
        }

        public static Type buildValidType(int id, String name) {
            return new Type(id, name);
        }

        public static Type buildSoftType(String name) {
            return new Type(name);
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
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

    public Date getDateBought() {
        return dateBought;
    }

    public void setDateBought(Date dateBought) {
        this.dateBought = dateBought;
    }

    public int getWarranty() {
        return warranty;
    }

    public void setWarranty(int warranty) {
        this.warranty = warranty;
    }

    public int getTimeRepaired() {
        return timeRepaired;
    }

    public void setTimeRepaired(int timeRepaired) {
        this.timeRepaired = timeRepaired;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public RoomDTO getCurrentRoom() {
        return currentRoom;
    }

    public void setCurrentRoom(RoomDTO currentRoom) {
        this.currentRoom = currentRoom;
    }

    public RequestDTO getCurrentRequest() {
        return currentRequest;
    }

    public void setCurrentRequest(RequestDTO currentRequest) {
        this.currentRequest = currentRequest;
    }

    public ErrorInformant getErrorInformant() {
        return errorInformant;
    }

    public void setErrorInformant(ErrorInformant errorInformant) {
        this.errorInformant = errorInformant;
    }

    public List<LocationEntry> getLocationEntries() {
        return locationEntries;
    }

    public void setLocationEntries(List<LocationEntry> locationEntries) {
        this.locationEntries = locationEntries;
    }

    public List<RequestDTO> getReportList() {
        return reportList;
    }

    public void setReportList(List<RequestDTO> reportList) {
        this.reportList = reportList;
    }

    public Date getDateExpired() {
        return dateExpired;
    }

    public void setDateExpired(Date dateExpired) {
        this.dateExpired = dateExpired;
    }
}
