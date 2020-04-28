package models;

import dtos.RequestDTO;

import java.io.Serializable;
import java.util.List;

public class RequestContainerAdmin extends RequestContainer implements Serializable {

    List<RequestDTO> acceptedRequestList;

    public RequestContainerAdmin() {
    }

    public RequestContainerAdmin(List<RequestDTO> pushedRequestList, List<RequestDTO> acceptedRequestList) {
        this.acceptedRequestList = acceptedRequestList;
        this.pushedRequestList = pushedRequestList;
    }

    public List<RequestDTO> getAcceptedRequestList() {
        return acceptedRequestList;
    }

    public void setAcceptedRequestList(List<RequestDTO> acceptedRequestList) {
        this.acceptedRequestList = acceptedRequestList;
    }
}
