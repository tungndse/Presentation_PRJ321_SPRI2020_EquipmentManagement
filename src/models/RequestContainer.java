package models;

import dtos.AccountDTO;
import dtos.RequestDTO;

import java.io.Serializable;
import java.util.List;

public class RequestContainer implements Serializable {

    private AccountDTO owner;
    protected List<RequestDTO> pushedRequestList;
    private List<RequestDTO> ownedRequestList;

    public RequestContainer() {
    }

    public RequestContainer(AccountDTO owner, List<RequestDTO> pushedRequestList,
                            List<RequestDTO> ownedRequestList) {
        this.owner = owner;
        this.pushedRequestList = pushedRequestList;
        this.ownedRequestList = ownedRequestList;
    }

    public AccountDTO getOwner() {
        return owner;
    }

    public void setOwner(AccountDTO owner) {
        this.owner = owner;
    }

    public List<RequestDTO> getPushedRequestList() {
        return pushedRequestList;
    }

    public void setPushedRequestList(List<RequestDTO> pushedRequestList) {
        this.pushedRequestList = pushedRequestList;
    }

    public List<RequestDTO> getOwnedRequestList() {
        return ownedRequestList;
    }

    public void setOwnedRequestList(List<RequestDTO> ownedRequestList) {
        this.ownedRequestList = ownedRequestList;
    }
}
