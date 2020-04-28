package managers;

import daos.RoomDAO;
import dtos.RoomDTO;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.List;

public class RoomManager implements Serializable {

    public List<RoomDTO> getAllAvailableRooms() throws Exception {
        return new RoomDAO().getList();
    }

    public List<RoomDTO> getAllAvailableRoomsWithStatistics() throws Exception {
        return new RoomDAO().getExpandedList();

    }

    public RoomDTO getRoomFullDetails(String roomId) throws Exception {
        return new RoomDAO().get(roomId);
    }

    public String updateRoom(String roomId, String newName, String byUser) throws Exception {
        String info = "OK";
        try {
            new RoomDAO().update(roomId, newName, byUser);
        } catch (SQLException sqe) {
            String errorMsg = sqe.getMessage();
            if (errorMsg.contains("UQRoom_Name")){
                info = "Duplicating room names is not accepted";
            } else {
                throw new Exception(sqe.getMessage());
            }
        }

        return info;

    }

    public String deleteRoom(String roomId, String username) throws Exception {
        String info = "OK";
        try {
            new RoomDAO().delete(roomId, username);
        } catch (SQLException sqe) {
            String errorMsg = sqe.getMessage();
            if (errorMsg.contains("RDEL-")) {
                info = errorMsg.replace("RDEL", "");
            } else {
                throw new Exception(errorMsg);
            }
        }

        return info;
    }

    public RoomDTO.ErrorInformant registerRoom(String roomId, String roomName, String byUser) throws Exception {

        RoomDTO.ErrorInformant errorInformant = new RoomDTO.ErrorInformant();

        String idError = null, nameError = null;

        if (roomId == null || roomId.isEmpty()){
            idError = "Id must not be blank";
        }

        if (roomName == null || roomName.isEmpty()) {
            nameError = "Name must not be blank";
        }

        if (idError != null || nameError != null) {
            errorInformant.setIdError(idError);
            errorInformant.setNameError(nameError);
            errorInformant.setClean(false);
        } else {
            try {
                new RoomDAO().insert(roomId, roomName, byUser);
            } catch (SQLException sqe) {
                String errorMsg = sqe.getMessage();
                if (errorMsg.contains("PkRoom")) {
                    errorInformant.setIdError("Duplicated IDs");
                } else if (errorMsg.contains("UqRoom")) {
                    errorInformant.setNameError("Duplicated Room Names are not allowed");
                } else {
                    throw new Exception(sqe.getMessage());
                }

                errorInformant.setClean(false);
            }
        }

        return errorInformant;
    }
}
