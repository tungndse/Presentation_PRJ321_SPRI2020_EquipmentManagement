package managers;

import daos.RequestDAO;
import dtos.RequestDTO;
import models.RequestContainer;
import models.RequestContainerAdmin;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.List;

public class RequestManager implements Serializable {


    public static RequestDTO getActiveRequest(String requestIdStr) throws Exception {
        RequestDTO request = null;

        try {
            int requestId = Integer.parseInt(requestIdStr);
            request = new RequestDAO().get(requestId);
        } catch (NumberFormatException nfe) {
            throw new Exception(nfe);
        } catch (SQLException sqe) {
            System.out.println(sqe.getMessage());
        }

        return request;
    }

    public String denyRequest(String requestIdStr, String username, String denyReason) throws Exception {
        String info = "OK";

        try {
            System.out.println("Manager");
            int requestId = Integer.parseInt(requestIdStr);
            new RequestDAO().deny(requestId, username, denyReason);
        } catch (SQLException sqe) {
            info = sqe.getMessage();
        } catch (NumberFormatException nfe) {
            info = "Could not find request ID in DB";
        }

        return info;
    }

    public String cancelRequest(String requestIdStr, String cancelReason) throws Exception {
        String info = "OK";

        if (cancelReason == null || cancelReason.trim().isEmpty()) {
            info = "A reason for cancelling the request must be given";
        } else {
            try {
                int requestId = Integer.parseInt(requestIdStr);
                new RequestDAO().cancel(requestId, cancelReason);
            } catch (SQLException sqe) {
                String errorMsg = sqe.getMessage();
                if (errorMsg.contains("REQCANCEL-")) {
                    info = errorMsg.replace("REQCANCEL-", "");
                } else {
                    throw new Exception(errorMsg);
                }
            } catch (NumberFormatException nfe) {
                info = "Request ID failed to processed";
            }
        }

        return info;
    }

    public String acceptRequest(String requestIdStr, String username) throws Exception {
        String info = "OK";
        try {
            int requestId = Integer.parseInt(requestIdStr);
            new RequestDAO().accept(requestId, username);

        } catch (SQLException sqe) {
            String errorMsg = sqe.getMessage();
            if (errorMsg.contains("REQACCEPT-")) {
                info = errorMsg.replace("REQACCEPT-", "");
            } else {
                throw new Exception(sqe.getMessage());
            }
        }
        return info;
    }

    public String updateRequest(String requestIdStr, String repairDiary) throws Exception {
        String info = "OK";

        if (repairDiary == null || repairDiary.trim().isEmpty()) {
            info = "Repair diary must not be left blank";
        } else {
            try {
                int requestId = Integer.parseInt(requestIdStr);
                new RequestDAO().update(requestId, repairDiary);
            } catch (SQLException sqe) {
                String errorMsg = sqe.getMessage();
                if (errorMsg.contains("REQUPD-")) {
                    info = errorMsg.replace("REQUPD-", "");
                } else {
                    throw new Exception(sqe.getMessage());
                }
            }
        }

        return info;
    }

    public String finishRequest(String requestIdStr, String requestResult) throws Exception {
        String info = "OK";

        int requestId;
        try {
            requestId = Integer.parseInt(requestIdStr);

            if (requestResult != null && !requestResult.trim().isEmpty()) {
                switch (requestResult) {
                    case "success":
                        new RequestDAO().finish(requestId, true);
                        break;
                    case "failed":
                        new RequestDAO().finish(requestId, false);
                        break;
                    default:
                        info = "Error getting result of report";
                }
            }

        } catch (NumberFormatException nfe) {
            info = "Error processing request Id";
        } catch (SQLException sqe) {
            String errorMsg = sqe.getMessage();
            if (errorMsg.contains("REQFINISH-")) {
                info = errorMsg.replace("REQFINISH-", "");
            } else {
                throw new Exception(sqe.getMessage());
            }
        }

        return info;

    }

    public String makeRequest(String equipmentId, String username, String description) throws Exception {
        String info = "OK";
        if (description == null || description.trim().isEmpty()) {
            info = "Description cannot be blank";
        } else {
            try {
                new RequestDAO().make(equipmentId, username, description);
            } catch (SQLException sqe) {
                String errorMsg = sqe.getMessage();
                if (errorMsg.contains("REQMAKE-")) {
                    info = errorMsg.replace("REQMAKE-", "");
                } else {
                    throw new Exception(sqe.getMessage());
                }
            }
        }

        return info;
    }

    public RequestContainer getTechRequestContainer(String techUsername) throws Exception {
        return new RequestDAO().getTechContainer(techUsername);
    }

    public List<RequestDTO> getUserRequestContainer(String username) throws Exception {
        return new RequestDAO().getUserRequestList(username);
    }

    public RequestContainerAdmin getAdminRequestContainer() throws Exception {
        return new RequestDAO().getAdminContainer();
    }
}
