package managers;

import daos.EquipmentDAO;
import daos.LocatorDAO;
import dtos.AccountDTO;
import dtos.EquipmentDTO;
import dtos.RoomDTO;
import models.StatisticUnit;

import java.io.Serializable;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class EquipmentManager implements Serializable {

    private static final String ID_REGEX = "^E[0-9]*$";
    private static final String DATE_FORMAT_STD = "yyyy-MM-dd";

    private EquipmentDTO processInputs(String equipmentId, String equipmentName, String dateBought,
                                       String warranty, String description,
                                       String typeName) {
        String idError = null;
        String nameError = null;
        String dateBoughtError = null;
        String warrantyError = null;
        String descriptionError = null;
        String typeError = null;

        // java.util.Date
        Date convertedDateBought = null;
        int warrantyInt = -1;

        if (equipmentId == null || equipmentId.isEmpty()) {
            idError = "Id cannot be left blank";
        } else if (!equipmentId.matches(ID_REGEX)) {
            idError = "ID must start with letter 'E' and end with string of numbers";
        }

        if (equipmentName == null || equipmentName.isEmpty()) {
            nameError = "Name cannot be left blank";
        }

        System.out.println(nameError);

        System.out.println(dateBought);

        if (dateBought == null || dateBought.trim().isEmpty()) {
            dateBought = null;
        } else {
            try {
                convertedDateBought = new SimpleDateFormat(DATE_FORMAT_STD).parse(dateBought);
                if (convertedDateBought.after(new Date())) {
                    dateBoughtError = "Date bought must be equal or before today";
                }
            } catch (
                    ParseException pe) {
                dateBoughtError = "Invalid Date Input";
            }
        }

        System.out.println(dateBoughtError);

        if (warranty == null || warranty.isEmpty()) {
            warrantyError = "Warranty cannot be left blank";
        } else {
            try {
                warrantyInt = Integer.parseInt(warranty);
                if (warrantyInt < 0) {
                    warrantyError = "Warranty cannot be a negative number";
                }
            } catch (NumberFormatException nfe) {
                warrantyError = "Invalid number input";
            }
        }
        System.out.println(warrantyError);

        if (description == null || description.isEmpty()) {
            descriptionError = "Description must not be blank";
        }
        System.out.println(descriptionError);

        if (typeName == null || typeName.isEmpty()) {
            typeError = "Equipment Type must be given";
        }
        System.out.println(typeError);

        EquipmentDTO checkedEquipment = new EquipmentDTO.Builder(equipmentId)
                .name(equipmentName)
                .dateBought(convertedDateBought)
                .warranty(warrantyInt)
                .description(description)
                .type(EquipmentDTO.Type.buildSoftType(typeName))
                .build();

        EquipmentDTO.ErrorInformant errorInformant = checkedEquipment.getErrorInformant();

        errorInformant.setIdError(idError);
        errorInformant.setNameError(nameError);
        errorInformant.setDateBroughtError(dateBoughtError);
        errorInformant.setDescriptionError(descriptionError);
        errorInformant.setWarrantyError(warrantyError);
        errorInformant.setTypeError(typeError);

        if (idError != null || nameError != null || dateBoughtError != null ||
                descriptionError != null || warrantyError != null || typeError != null) {
            errorInformant.setClean(false);
        }

        System.out.println(errorInformant.isClean());

        return checkedEquipment;
    }

    public String transferEquipment(String byUserId, String equipmentId, String roomId, String reasonMoved) throws Exception {
        String resultMsg = "OK";

        if (reasonMoved == null || reasonMoved.isEmpty()) {
            return "Reason must be given";
        }
        AccountDTO userMove = new AccountDTO.Builder(byUserId).build();
        EquipmentDTO movedEquipment = new EquipmentDTO.Builder(equipmentId).build();
        RoomDTO targetLocation = new RoomDTO.Builder(roomId).build();

        try {
            new LocatorDAO().transfer(userMove, movedEquipment, targetLocation, reasonMoved);
        } catch (SQLException sqe) {
            if (sqe.getMessage().contains("EMOVE-")) {
                resultMsg = sqe.getMessage().replace("EMOVE-", "");
            } else {
                throw new Exception(sqe.getMessage());
            }
        }

        return resultMsg;
    }

    public String deleteEquipment(String equipmentId, String byUser) throws Exception {
        String deleteError = null;

        if (equipmentId == null || equipmentId.isEmpty() || byUser == null || byUser.isEmpty()) {
            deleteError = "Not able to get username of admin or id of the deleted equipment";
        }

        try {
            new EquipmentDAO().delete(equipmentId, byUser);
        } catch (SQLException sqe) {
            if (sqe.getMessage().contains("EDEL-")) {
                deleteError = sqe.getMessage().replace("EDEL-", "");
            } else {
                throw new Exception(sqe.getMessage());
            }
        }

        return deleteError;
    }

    public EquipmentDTO registerEquipment(String equipmentId, String equipmentName, String dateBought,
                                          String warranty, String description,
                                          String typeName, String byUser) throws Exception {

        EquipmentDTO processedEquipment = this.processInputs(equipmentId, equipmentName, dateBought,
                warranty, description, typeName);

        EquipmentDTO.ErrorInformant inputError = processedEquipment.getErrorInformant();

        if (inputError.isClean()) {
            EquipmentDAO equipmentDAO = new EquipmentDAO();
            try {
                equipmentDAO.save(processedEquipment, byUser);
            } catch (SQLException sqle) {
                String sqlErrorMsg = sqle.getMessage();

                if (sqlErrorMsg.contains("PkEquipment")) {
                    inputError.setIdError("Duplicated equipment ids");
                } else if (sqlErrorMsg.contains("FkEquipment")) {
                    inputError.setTypeError("Error determining existing type");
                } else {
                    throw new Exception(sqle.getMessage());
                }

                inputError.setClean(false);
            }
        }

        return processedEquipment;
    }

    public EquipmentDTO getEquipment(String equipmentId) throws Exception {
        return new EquipmentDAO().get(equipmentId);
    }

    public EquipmentDTO updateEquipment(String equipmentId, String equipmentName, String dateBought,
                                        String warranty, String description,
                                        String typeName, String byUser) throws Exception {
        EquipmentDTO processedEquipment = this.processInputs(equipmentId, equipmentName, dateBought,
                warranty, description, typeName);

        EquipmentDTO.ErrorInformant inputError = processedEquipment.getErrorInformant();

        if (inputError.isClean()) {
            EquipmentDAO equipmentDAO = new EquipmentDAO();
            try {
                equipmentDAO.update(processedEquipment, byUser);
            } catch (SQLException sqle) {
                String sqlErrorMsg = sqle.getMessage();

                if (sqlErrorMsg.contains("FkEquipment_TypeId")) {
                    inputError.setTypeError("Error determining existing type");
                } else {
                    throw new Exception(sqle.getMessage());
                }

                inputError.setClean(false);
            }
        }

        return processedEquipment;
    }


    public List<EquipmentDTO> getEquipmentList(String forRoomMember, String equipmentStatusStr, String warrantyOrderStr,
                                               String dateBoughtOrderStr, String repairTimeOrderStr, boolean underWarranty) throws Exception {
        int equipmentStatus;
        switch (equipmentStatusStr) {
            case "fine":
                equipmentStatus = 1;
                break;
            case "broken":
                equipmentStatus = 0;
                break;
            default: //retired
                return null;
        }

        boolean sortByWarrantyOrder = warrantyOrderStr != null && !warrantyOrderStr.isEmpty();
        boolean sortByDateBoughtOrder = dateBoughtOrderStr != null && !dateBoughtOrderStr.isEmpty();
        boolean sortByRepairTimeOrder = repairTimeOrderStr != null && !repairTimeOrderStr.isEmpty();

        return new EquipmentDAO().getList(forRoomMember, equipmentStatus, sortByWarrantyOrder,
                sortByDateBoughtOrder, sortByRepairTimeOrder, underWarranty);

    }

    public List<EquipmentDTO> getEquipmentList(String equipmentStatus, String warrantyOrderStr, String dateBoughtOrderStr,
                                               String repairTimeOrderStr, boolean underWarranty) throws Exception {
        return getEquipmentList(null, equipmentStatus, warrantyOrderStr, dateBoughtOrderStr, repairTimeOrderStr, underWarranty);
    }


    public boolean updateEquipmentImage(String equipmentId, String imgPath) throws Exception {
        boolean success;
        try {
            new EquipmentDAO().updateImagePath(equipmentId, imgPath);
            success = true;
        } catch (SQLException sqe) {
            System.out.println(sqe.getMessage());
            success = false;
        }

        return success;
    }

    public List<StatisticUnit> getRepairStats() throws Exception{
        return new EquipmentDAO().getRepairStats();
    }

    public List<StatisticUnit> getStatusOnDBStats(String dateFromStr, String dateToStr) throws Exception {
        if (dateFromStr == null || dateFromStr.isEmpty() || dateToStr == null || dateToStr.isEmpty()) {
            return null;
        }

        Date dateFrom;
        Date dateTo;

        try {
            dateFrom = new SimpleDateFormat(DATE_FORMAT_STD).parse(dateFromStr);
            dateTo = new SimpleDateFormat(DATE_FORMAT_STD).parse(dateToStr);

            if (dateFrom.after(dateTo))
                return null;

            return new EquipmentDAO().getStatusDBStats(dateFrom, dateTo);
        } catch (ParseException pe) {
            return null;
        }

    }

    public List<StatisticUnit> getStatusOnWarrantyStats(String warrantyFromStr, String warrantyToStr) throws Exception {
        if (warrantyFromStr == null || warrantyToStr == null ||
                warrantyFromStr.isEmpty() || warrantyToStr.isEmpty()) {
            return null;
        }

        int warrantyFrom;
        int warrantyTo;

        try {
            warrantyFrom = Integer.parseInt(warrantyFromStr);
            warrantyTo = Integer.parseInt(warrantyToStr);
            return new EquipmentDAO().getStatusWarrantyStats(warrantyFrom, warrantyTo);
        } catch (NumberFormatException nfe) {
            return null;
        }
    }

    public List<StatisticUnit> getWarrantyGroupOrderedByStatusGroup() throws Exception {
        return new EquipmentDAO().getSpecialStats();
    }

    public List<EquipmentDTO> getEquipmentList(String statusStr, String dateExpiredFromStr, String dateExpiredToStr) throws Exception {
        List<EquipmentDTO> list = null;
        int status;
        switch (statusStr) {
            case "fine":
                status = 1;
                break;
            case "broken":
                status = 0;
                break;
            default: //retired
                return null;
        }

        try {
            Date dateExpiredFrom = new SimpleDateFormat(DATE_FORMAT_STD).parse(dateExpiredFromStr);
            Date dateExpiredTo = new SimpleDateFormat(DATE_FORMAT_STD).parse(dateExpiredToStr);

            if (dateExpiredFrom.after(dateExpiredTo))
                return null;

            list = new EquipmentDAO().getList(status, dateExpiredFrom, dateExpiredTo);

        } catch (ParseException pe) {
            return null;
        }

        return list;
    }

    public List<EquipmentDTO> getEquipmentList(String repairCountStr) throws Exception {
        List<EquipmentDTO> list = null;

        try {
            int repairCount = Integer.parseInt(repairCountStr);

            if (repairCount < 0)
                return null;

            list = new EquipmentDAO().getList(repairCount);

        } catch (NumberFormatException nfe) {
            return null;
        }

        return list;
    }
}
