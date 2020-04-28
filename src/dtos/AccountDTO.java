package dtos;

import java.io.Serializable;
import java.util.Date;

public class AccountDTO implements Serializable {

    private String username;
    private String givenName;
    private String lastName;
    private String password;
    private String confirm;
    private int role;
    private Date timeLogin;
    private boolean isActive;

    private RoomDTO currentRoom;
    private ErrorInformant errorInformant;

    private AccountDTO(Builder builder) {
        this.username = builder.username;
        this.givenName = builder.givenName;
        this.lastName = builder.lastName;
        this.password = builder.password;
        this.confirm = builder.confirm;
        this.role = builder.role;
        this.timeLogin = builder.timeLogin;
        this.isActive = builder.isActive;

        currentRoom = builder.room;
        errorInformant = builder.errorInformant == null ?
                new ErrorInformant() : builder.errorInformant;
    }

    public static class ErrorInformant implements Serializable {

        private String usernameError, givenNameError, lastNameError, passwordError, confirmError, roleError;
        private String otherError, uncaughtError;
        boolean clean;

        public ErrorInformant() {
            clean = true;
        }

        public String getUsernameError() {
            return usernameError;
        }

        public void setUsernameError(String usernameError) {
            this.usernameError = usernameError;
        }

        public String getGivenNameError() {
            return givenNameError;
        }

        public void setGivenNameError(String givenNameError) {
            this.givenNameError = givenNameError;
        }

        public String getLastNameError() {
            return lastNameError;
        }

        public void setLastNameError(String lastNameError) {
            this.lastNameError = lastNameError;
        }

        public String getPasswordError() {
            return passwordError;
        }

        public void setPasswordError(String passwordError) {
            this.passwordError = passwordError;
        }

        public String getConfirmError() {
            return confirmError;
        }

        public void setConfirmError(String confirmError) {
            this.confirmError = confirmError;
        }

        public boolean isClean() {
            return clean;
        }

        public void setClean(boolean clean) {
            this.clean = clean;
        }

        public String getOtherError() {
            return otherError;
        }

        public void setOtherError(String otherError) {
            this.otherError = otherError;
        }

        public String getRoleError() {
            return roleError;
        }

        public void setRoleError(String roleError) {
            this.roleError = roleError;
        }

        public String getUncaughtError() {
            return uncaughtError;
        }

        public void setUncaughtError(String uncaughtError) {
            this.uncaughtError = uncaughtError;
        }
    }

    public static class Builder implements Serializable {

        // Required
        private String username;

        // Optional
        private String givenName;
        private String lastName;
        private String password;
        private int role;
        private String confirm;
        private Date timeLogin;
        private boolean isActive;
        private RoomDTO room;
        private ErrorInformant errorInformant;

        public Builder(String username) {
            this.username = username;
        }

        public AccountDTO build() {
            return new AccountDTO(this);
        }

        public Builder password(String password) {
            this.password = password;
            return this;
        }

        public Builder confirm(String confirm) {
            this.confirm = confirm;
            return this;
        }

        public Builder fullName(String givenName, String lastName) {
            this.givenName = givenName;
            this.lastName = lastName;
            return this;
        }

        public Builder loginTime(Date timeLogin) {
            this.timeLogin = timeLogin;
            return this;
        }

        public Builder role(int role) {
            this.role = role;
            return this;
        }

        public Builder role(String role) {
            switch (role) {
                case "user":
                    this.role = 0;
                    break;
                case "tech":
                    this.role = 1;
                    break;
                case "admin":
                    this.role = 2;
                    break;
                default:
                    this.role = -1;
            }

            return this;
        }

        public Builder room(RoomDTO room) {
            this.room = room;
            return this;
        }

        public Builder status(boolean isActive) {
            this.isActive = isActive;
            return this;
        }

        public Builder error(AccountDTO.ErrorInformant errorInformant) {
            this.errorInformant = errorInformant;
            return this;
        }

    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getGivenName() {
        return givenName;
    }

    public void setGivenName(String givenName) {
        this.givenName = givenName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    public ErrorInformant getErrorInformant() {
        return errorInformant;
    }

    public void setErrorInformant(ErrorInformant errorInformant) {
        this.errorInformant = errorInformant;
    }

    public String getConfirm() {
        return confirm;
    }

    public void setConfirm(String confirm) {
        this.confirm = confirm;
    }

    public Date getTimeLogin() {
        return timeLogin;
    }

    public void setTimeLogin(Date timeLogin) {
        this.timeLogin = timeLogin;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public RoomDTO getCurrentRoom() {
        return currentRoom;
    }

    public void setCurrentRoom(RoomDTO currentRoom) {
        this.currentRoom = currentRoom;
    }
}
