package managers;

import daos.AccountDAO;
import daos.LocatorDAO;
import dtos.AccountDTO;
import dtos.RoomDTO;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.List;

public class AccountManager implements Serializable {

    //TODO [DTO] rewrite AccountDTO that takes role as integer, timeloggin as Date
    // In order to display date with custom format with jstl we use
    // <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    // <fmt:formatDate value="${now}" pattern="yy-MMM-dd"/>
    // More info: https://stackoverflow.com/questions/22824190/how-to-use-format-date-as-yyyy-mm-dd-with-jstl

    private static final String NAME_REGEX = "^[a-zA-Z]*$";
    private static final String USERNAME_REGEX = "^[a-zA-Z0-9]*$";

    private AccountDTO validateInputs(String username, String givenName, String lastName,
                                      String password, String confirm, String role) throws Exception {

        AccountDTO validatedAccount = validateInputs(username, lastName, givenName, role);
        AccountDTO.ErrorInformant errorInformant = validatedAccount.getErrorInformant();

        String passwordError = null;
        String confirmError = null;

        if (password == null || password.isEmpty()) {
            passwordError = "Password cannot be left blank";
        }

        if (passwordError == null && (confirm == null || !confirm.equals(password))) {
            confirmError = "Confirm password doesn't match password";
        }

        validatedAccount = new AccountDTO.Builder(username)
                .fullName(givenName, lastName)
                .password(password)
                .confirm(confirm)
                .role(role)
                .error(errorInformant)
                .build();

        errorInformant.setPasswordError(passwordError);
        errorInformant.setConfirmError(confirmError);

        if (errorInformant.isClean() && (passwordError != null || confirmError != null)) {
            errorInformant.setClean(false);
        }

        return validatedAccount;
    }

    private AccountDTO validateInputs(String username, String givenName,
                                      String lastName, String role) throws Exception {

        String usernameError = null;
        String givenNameError = null;
        String lastNameError = null;
        String roleError = null;

        if (username == null || username.isEmpty()) {
            usernameError = "Username cannot be left blank";
        } else if (!username.matches(USERNAME_REGEX)) {
            usernameError = "Username only contains letters or number";
        }

        if (givenName == null || givenName.isEmpty()) {
            givenNameError = "Given name cannot be left blank";
        } else if (!givenName.matches(NAME_REGEX)) {
            givenNameError = "Given Name only contains letters";
        }

        if (lastName == null || lastName.isEmpty()) {
            lastNameError = "Last name cannot be left blank";
        } else if (!lastName.matches(NAME_REGEX)) {
            lastNameError = "Last Name only contains letters";
        }

        if (!(role.equals("user") || role.equals("admin") || role.equals("tech"))) { // 1, 2, 3
            roleError = "Invalid role";
        }

        AccountDTO validatedAccount = new AccountDTO.Builder(username)
                .fullName(givenName, lastName)
                .role(role)
                .build();

        AccountDTO.ErrorInformant errorInformant = validatedAccount.getErrorInformant();

        errorInformant.setUsernameError(usernameError);
        errorInformant.setGivenNameError(givenNameError);
        errorInformant.setLastNameError(lastNameError);
        errorInformant.setRoleError(roleError);

        if (usernameError != null || givenNameError != null ||
                lastNameError != null || roleError != null) {
            errorInformant.setClean(false);
        }

        return validatedAccount;
    }

    public AccountDTO validateLogin(String username, String password) throws Exception {
        //AccountDTO dto = AccountBuilder.buildAccountLogin(username, password);

        AccountDTO dto = new AccountDTO.Builder(username)
                .password(password)
                .build();

        AccountDAO loginDao = new AccountDAO();
        try {
            return loginDao.login(dto);
        } catch (SQLException sqle) {
            if (sqle.getMessage().contains("ULOG-")) {  //confirmed invalid login token
                return null;
            } else {                                    //unknown sql error
                throw new Exception(sqle.getMessage());
            }
        }
    }

    public AccountDTO registerAccount(String username, String givenName, String lastName,
                                      String password, String confirm, String role, String regByUser) throws Exception {
        AccountDTO validatedAccount = this.validateInputs(username, givenName, lastName, password, confirm, role);
        AccountDTO.ErrorInformant inputError = validatedAccount.getErrorInformant();

        if (inputError.isClean()) {
            AccountDAO accountDAO = new AccountDAO();
            try {
                accountDAO.save(validatedAccount, regByUser);
            } catch (SQLException sqe) {
                // Catch sql error, user-defined error
                String sqlErrorMessage = sqe.getMessage();

                if (sqlErrorMessage.contains("PkUserReg_Username")) {
                    inputError.setUsernameError("Username not available, duplicated username");
                } else if (sqlErrorMessage.contains("CkUserReg_Role")) {
                    inputError.setRoleError("Invalid Role");
                } else if (sqlErrorMessage.contains("UINS") || sqlErrorMessage.contains("UREG")) {
                    inputError.setOtherError
                            (sqlErrorMessage
                                    .replace("UINS-", "")
                                    .replace("UREG-", ""));
                } else {
                    inputError.setUncaughtError("Error at AccountManager : registrateAccount() : " + sqlErrorMessage);
                }

                inputError.setClean(false);
            }
        }

        return validatedAccount;
    }

    public AccountDTO updateAccount(String username, String givenName, String lastName,
                                    String password, String confirm, String role, String updByUser) throws Exception {
        AccountDTO validatedAccount = this.validateInputs(username, givenName, lastName,
                password, confirm, role);
        AccountDTO.ErrorInformant inputError = validatedAccount.getErrorInformant();

        if (inputError.isClean()) {
            AccountDAO accountDAO = new AccountDAO();
            try {
                accountDAO.update(validatedAccount, updByUser);
            } catch (SQLException sqe) {
                String sqlErrorMessage = sqe.getMessage();
                inputError.setClean(false);
                if (sqlErrorMessage.contains("UUPD-")) {
                    inputError.setOtherError(sqlErrorMessage
                            .replace("UUPD-", ""));
                } else {
                    inputError.setUncaughtError(sqe.getMessage());
                }
            }
        }

        return validatedAccount;
    }

    //OVERLOAD
    public AccountDTO updateAccount(String username, String givenName, String lastName,
                                    String password, String confirm, int role, String updByUser) throws Exception {
        String roleStr = "invalidated";
        switch (role) {
            case 0:
                roleStr = "user";
                break;
            case 1:
                roleStr = "tech";
                break;
            case 2:
                roleStr = "admin";
                break;
        }
        return this.updateAccount(username, givenName, lastName, password, confirm, roleStr, updByUser);
    }

    public AccountDTO updateAccount(String username, String givenName, String lastName,
                                    String role, String updByUser) throws Exception {
        AccountDTO validatedAccount = this.validateInputs
                (username, givenName, lastName, role);
        AccountDTO.ErrorInformant inputError = validatedAccount.getErrorInformant();

        if (inputError.isClean()) {
            AccountDAO accountDAO = new AccountDAO();
            try {
                accountDAO.update(validatedAccount, updByUser);
            } catch (SQLException sqe) {
                String sqlErrorMessage = sqe.getMessage();
                if (sqlErrorMessage.contains("UUPD-")) {
                    inputError.setOtherError(sqlErrorMessage
                            .replace("UUPD-", ""));
                } else {
                    inputError.setUncaughtError(sqe.getMessage());
                }
            }
        }

        return validatedAccount;

    }

    public String deleteAccount(String username, String byUser) throws Exception {
        String deleteError = null;

        if (username == null || username.isEmpty() || byUser == null || byUser.isEmpty()) {
            deleteError = "UDEL-Not able to get username of admin or the deleted account";
        }

        try {
            new AccountDAO().delete(username, byUser);
        } catch (SQLException sqe) {
            if (sqe.getMessage().contains("UDEL-")) {
                deleteError = sqe.getMessage().replace("UDEL-", "");
            } else {
                throw new Exception(sqe.getMessage());
            }
        }

        return deleteError;
    }

    public AccountDTO getAccount(String username) throws Exception {
        return new AccountDAO().get(username);
    }

    public List<AccountDTO> searchAccounts(String givenNameSearch, String lastNameSearch,
                                           String filteredRoomId, boolean banIncluded) throws Exception {
        return new AccountDAO().search(givenNameSearch, lastNameSearch, filteredRoomId, banIncluded);
    }


    public String transferUser(String byUserId, String userId, String roomId) throws Exception {
        String resultMsg = "OK";

        AccountDTO userMove = new AccountDTO.Builder(byUserId).build();
        AccountDTO movedUser = new AccountDTO.Builder(userId).build();
        RoomDTO targetLocation = new RoomDTO.Builder(roomId).build();
        try {
            new LocatorDAO().transfer(userMove, movedUser, targetLocation);
        } catch (SQLException sqe) {
            if (sqe.getMessage().contains("UMOVE-")) {
                resultMsg = sqe.getMessage().replace("UMOVE-", "");
            } else {
                throw new Exception(sqe.getMessage());
            }
        }

        return resultMsg;
    }

    /*private AccountDTO validateAccountInputs(String username, String givenName, String lastName,
                                             String password, String confirm, String role) throws Exception {

        String usernameError = null;
        String givenNameError = null;
        String lastNameError = null;
        String passwordError = null;
        String confirmError = null;
        String roleError = null;

        if (username == null || username.isEmpty()) {
            usernameError = "Username cannot be left blank";
        } else if (!username.matches(USERNAME_REGEX)) {
            usernameError = "Username only contains letters or number";
        }

        if (givenName == null || givenName.isEmpty()) {
            givenNameError = "Given name cannot be left blank";
        } else if (!givenName.matches(NAME_REGEX)) {
            givenNameError = "Given Name only contains letters";
        }

        if (lastName == null || lastName.isEmpty()) {
            lastNameError = "Last name cannot be left blank";
        } else if (!lastName.matches(NAME_REGEX)) {
            lastNameError = "Last Name only contains letters";
        }

        if (password == null || password.isEmpty()) {
            passwordError = "Password cannot be left blank";
        }

        if (passwordError == null && (confirm == null || !confirm.equals(password))) {
            confirmError = "Confirm password doesn't match password";
        }

        if (!(role.equals("user") || role.equals("admin") || role.equals("tech"))) { // 1, 2, 3
            roleError = "Invalid role";
        }

        AccountDTO validatedAccount = new AccountDTO.Builder(username)
                .fullName(givenName, lastName)
                .password(password)
                .confirm(confirm)
                .role(role)
                .build();

        AccountDTO.ErrorInformant errorInformant = validatedAccount.getErrorInformant();

        errorInformant.setUsernameError(usernameError);
        errorInformant.setGivenNameError(givenNameError);
        errorInformant.setLastNameError(lastNameError);
        errorInformant.setPasswordError(passwordError);
        errorInformant.setConfirmError(confirmError);
        errorInformant.setRoleError(roleError);

        if (usernameError != null || givenNameError != null || lastNameError != null ||
                passwordError != null || confirmError != null || roleError != null) {
            errorInformant.setClean(false);
        }

        return validatedAccount;
    }*/
}
