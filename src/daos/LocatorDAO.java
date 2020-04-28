package daos;

import db.DBConnector;
import dtos.AccountDTO;
import dtos.EquipmentDTO;
import dtos.RoomDTO;

import java.io.Serializable;

public class LocatorDAO extends PrimitiveDAO implements Serializable {

    public void transfer(AccountDTO userMove, AccountDTO movedUser, RoomDTO targetRoom) throws Exception {
        try {
            String sql = "{call spTransferUser (?,?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            csm.setString(1, userMove.getUsername());
            csm.setString(2, movedUser.getUsername());
            csm.setString(3, targetRoom.getId());

            csm.execute();
        } finally {
            closeConnection(cnn, csm);
        }
    }

    public void transfer(AccountDTO userMove, EquipmentDTO movedEquipment, RoomDTO targetRoom, String reason) throws Exception {
       // @equipmentId NVARCHAR(10), @roomId NVARCHAR(10), @byUser NVARCHAR(30),
          //      @reasonMoving NVARCHAR(100)

        try {
            String sql = "{call spTransferEquipment (?,?,?,?)}";
            cnn = DBConnector.getConnection();
            csm = cnn.prepareCall(sql);
            System.out.println(movedEquipment.getId());

            csm.setString(3, userMove.getUsername());
            csm.setString(1, movedEquipment.getId());
            csm.setString(2, targetRoom.getId());
            csm.setString(4, reason);

            csm.execute();
        } finally {
            closeConnection(cnn, csm);
        }
    }
}
