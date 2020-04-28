package daos;

import java.io.Serializable;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public abstract class PrimitiveDAO implements Serializable {

    protected Connection cnn;
    protected PreparedStatement psm;
    protected CallableStatement csm;
    protected ResultSet rs;
    protected ResultSet rs2;
    protected ResultSet rs3;
    protected ResultSet rs4;

    protected void closeConnection(Connection cnn, PreparedStatement psm, ResultSet rs) throws Exception {
        if (rs != null) {
            rs.close();
        }
        if (psm != null) {
            psm.close();
        }
        if (cnn != null) {
            cnn.close();
        }
    }

    protected void closeConnection(Connection cnn, CallableStatement csm, ResultSet rs) throws Exception {
        if (rs != null) {
            rs.close();
        }
        if (csm != null) {
            csm.close();
        }
        if (cnn != null) {
            cnn.close();
        }
    }

    protected void closeConnection(Connection cnn, PreparedStatement psm) throws Exception {

        if (psm != null) {
            psm.close();
        }
        if (cnn != null) {
            cnn.close();
        }
    }

    protected void closeConnection(Connection cnn, CallableStatement csm) throws Exception {

        if (csm != null) {
            csm.close();
        }
        if (cnn != null) {
            cnn.close();
        }
    }

    protected void closeConnection (Connection cnn, CallableStatement csm, ResultSet rs1 , ResultSet rs2) throws Exception {
        if (rs2 != null) {
            rs2.close();
        }

        closeConnection(cnn, csm, rs1);
    }

    protected void closeConnection (Connection cnn, CallableStatement csm, ResultSet rs1 , ResultSet rs2, ResultSet rs3) throws Exception {
        if (rs3 != null) {
            rs3.close();
        }

        closeConnection(cnn, csm, rs1, rs2);
    }

    protected void closeConnection (Connection cnn, CallableStatement csm, ResultSet rs1 , ResultSet rs2, ResultSet rs3, ResultSet rs4) throws Exception {
        if (rs4 != null) {
            rs4.close();
        }
        closeConnection(cnn, csm, rs1, rs2, rs3);
    }

}
