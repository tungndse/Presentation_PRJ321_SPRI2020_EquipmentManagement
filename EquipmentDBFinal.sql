CREATE DATABASE EquipmentDB
USE EquipmentDB

-- EQUIPMENT --------------------------------------------------------------------------------------------------

CREATE TABLE Equipment
(
    Id           NVARCHAR(10)  NOT NULL,
    Name         NVARCHAR(30)  NOT NULL,
    DateBought   DATE          NOT NULL DEFAULT GETDATE(),
    Warranty     INT           NOT NULL,
    TimeRepaired INT           NOT NULL DEFAULT 0,
    Status       INT           NOT NULL DEFAULT 1,
    TypeId       INT           NOT NULL,
    Description  NVARCHAR(200) NOT NULL,

    CONSTRAINT PkEquipment_Id PRIMARY KEY (Id),
    CONSTRAINT FkEquipment_TypeId FOREIGN KEY (TypeId) REFERENCES EquipmentType (Id),
    CONSTRAINT CkEquipment_DateBought CHECK (DateBought <= GETDATE()),
    CONSTRAINT CkEquipment_Warranty CHECK (Warranty >= 0),
    CONSTRAINT CkEquipment_TimeRepaired CHECK (TimeRepaired >= 0),
    CONSTRAINT CkEquipment_Status CHECK (Status IN (-1, 0, 1)),

) --- Status: 1=fine; 0=broken; -1=retired

CREATE TABLE EquipmentType
(
    Id   INT          NOT NULL IDENTITY (1,1),
    Name NVARCHAR(30) NOT NULL,

    CONSTRAINT PkEquipmentType_Id PRIMARY KEY (Id),
    CONSTRAINT UqEquipmentType_Name UNIQUE (Name)
) -- Types Limiter

CREATE TABLE EquipmentImage
(
    EquipmentId NVARCHAR(10) NOT NULL,
    Path        NVARCHAR(260), -- THIS ONE IS ACTUALLY INTERESTING

    CONSTRAINT PkEquipmentImage_EquipmentId PRIMARY KEY (EquipmentId),
    CONSTRAINT FkEquipmentImage_EquipmentId FOREIGN KEY (EquipmentId) REFERENCES Equipment (Id),
)
-- Omits null fields in Equipment

-- ROOM --------------------------------------------------------------------------------------------------

CREATE TABLE Room
(
    Id     NVARCHAR(10) NOT NULL,
    Name   NVARCHAR(30) NOT NULL,
    Status BIT          NOT NULL DEFAULT 1,

    CONSTRAINT PkRoom_Id PRIMARY KEY (Id),
    CONSTRAINT UqRoom_Name UNIQUE (Name),
)
-- Has Status

-- USER ACCOUNT --------------------------------------------------------------------------------------------------

CREATE TABLE UserReg
(
    Username  NVARCHAR(30) NOT NULL,
    GivenName NVARCHAR(30) NOT NULL,
    LastName  NVARCHAR(30) NOT NULL,
    Password  NVARCHAR(30) NOT NULL,
    Role      INT          NOT NULL DEFAULT 0,
    Status    BIT          NOT NULL DEFAULT 1,

    CONSTRAINT PkUserReg_Username PRIMARY KEY (Username),
    CONSTRAINT CkUserReg_Role CHECK (Role IN (0, 1, 2)),
)
-- Role : 0=user; 1=tech; 2=admin | Status : 1=active; 0=banned

-- Current Location Table ----------------- Used for better performance when checking

CREATE TABLE UserCurrentLocation
(
    UserId   NVARCHAR(30) NOT NULL,
    RoomId   NVARCHAR(10) NOT NULL,
    FromDate DATETIME     NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PkUserCurrentLocation_UserId PRIMARY KEY (UserId),
    CONSTRAINT FkUserCurrentLocation_UserId FOREIGN KEY (UserId) REFERENCES UserReg (Username),
    CONSTRAINT FKUSerCurrentLocation_RoomId FOREIGN KEY (RoomId) REFERENCES Room (Id),
)


CREATE TABLE EquipmentLocationEntry
(
    Id           INT           NOT NULL IDENTITY (1,1),
    EquipmentId  NVARCHAR(10)  NOT NULL,
    RoomId       NVARCHAR(10)  NOT NULL,
    FromDateTime DATETIME      NOT NULL DEFAULT GETDATE(),
    ByUser       NVARCHAR(30)  NOT NULL,
    ReasonMoving NVARCHAR(100) NOT NULL,

    CONSTRAINT PkEquipmentLocationEntry_Id PRIMARY KEY (Id),
    CONSTRAINT FkEquipmentLocationEntry_EquipmentId FOREIGN KEY (EquipmentId) REFERENCES Equipment (Id),
    CONSTRAINT FkEquipmentLocationEntry_RoomId FOREIGN KEY (RoomId) REFERENCES Room (Id),
    CONSTRAINT CkEquipmentLocationEntry_FromDateTime CHECK (FromDateTime <= GETDATE()),
    CONSTRAINT UqEquipmentLocationEntry_EquipmentId_FromDateTime UNIQUE (EquipmentId, FromDateTime), -- One Equipment can't be moved to two places at the exact same time
    CONSTRAINT FkEquipmentLocationEntry_ByUser FOREIGN KEY (ByUser) REFERENCES UserReg (Username),
)

CREATE TABLE EquipmentCurrentLocation
(
    ELocEntryId INT NOT NULL,
    CONSTRAINT PkEquipmentCurrentLocation_EquipmentId PRIMARY KEY (ELocEntryId),
    CONSTRAINT FkEquipmentCurrentLocation_ELocEntryId FOREIGN KEY (ELocEntryId) REFERENCES EquipmentLocationEntry (Id),
)


----------------- EVENT HANDLING -----------------------------------------------------------------------------

-- EVENT ----------------------------------------------------------

-- Event Types for User (code: 1)
-- 1. UINS
-- 2. UUPD
-- 3. UDEL
-- 4. ULOG
-- 5. UREG
-- 6. UMOVE
-- Event Types For Room (code:2)
-- 7. RINS
-- 8. RUPD
-- 9. RDEL
-- Event Types For Equipment (code:3)
-- 10. EINS
-- 11. EUPD
-- 12. EDEL
-- 13. EMOVE
-- Event Types For Request (code:4)
-- 14. REQMAKE
-- 15. REQPROC
-- 16. REQFINISH
-- 17. REQCANCEL
-- 18. REQDENY

CREATE TABLE NotificationType
(
    Id   NVARCHAR(10) NOT NULL,
    Name NVARCHAR(30) NOT NULL,

    CONSTRAINT PkEventType_Id PRIMARY KEY (Id),
    CONSTRAINT UqEventType_Id UNIQUE (Name),
)

-- Notification ------------------------------------------------------------

CREATE TABLE Notification
(
    Id          INT            NOT NULL IDENTITY (1,1),
    TypeId      NVARCHAR(10)   NOT NULL,
    TimeCreated DATETIME       NOT NULL,
    ForUser     NVARCHAR(30)   NOT NULL,
    Message     NVARCHAR(1000) NOT NULL,

    CONSTRAINT PkNotification_Id PRIMARY KEY (Id),
    CONSTRAINT FkNotification_TypeId FOREIGN KEY (TypeId) REFERENCES NotificationType (Id),
    CONSTRAINT FkNotification_ForUser FOREIGN KEY (ForUser) REFERENCES UserReg (Username)
)


-- EQUIPMENT REQUEST ------------------------------------------------------------------------------------------------------

CREATE TABLE Request
( --- Equipment-User ----
    Id          INT           NOT NULL IDENTITY (1,1),
    EquipmentId NVARCHAR(10)  NOT NULL,
    CreatedBy   NVARCHAR(30)  NOT NULL,
    Status      INT           NOT NULL DEFAULT 0,
    TimeCreated DATETIME      NOT NULL DEFAULT GETDATE(),
    Description NVARCHAR(200) NOT NULL,

    CONSTRAINT PkRequest_Id PRIMARY KEY (Id),
    CONSTRAINT FkRequest_EquipmentId FOREIGN KEY (EquipmentId) REFERENCES Equipment (Id),
    CONSTRAINT FkRequest_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES UserReg (Username),

) -- Status: -1=canceled; 0=sent; 1=proceeded; 2=done

CREATE TABLE Report
(
    RequestId   INT           NOT NULL,
    ProceededBy NVARCHAR(30)  NOT NULL,
    TimeStart   DATETIME      NOT NULL DEFAULT GETDATE(),
    Description NVARCHAR(300) NOT NULL,

    CONSTRAINT PkReport_RequestId PRIMARY KEY (RequestId),
    CONSTRAINT FkReport_RequestId FOREIGN KEY (RequestId) REFERENCES Request (Id),
    CONSTRAINT FkReport_ProceededBy FOREIGN KEY (ProceededBy) REFERENCES UserReg (Username),
)

CREATE TABLE ReportResult
(
    RequestId INT      NOT NULL,
    TimeDone  DATETIME NOT NULL DEFAULT GETDATE(),
    Result    BIT      NOT NULL,

    CONSTRAINT PkReportResult_RequestId PRIMARY KEY (RequestId),
    CONSTRAINT FkReportResult_RequestId FOREIGN KEY (RequestId) REFERENCES Request (Id),

)
--0=failed;1=success

-- MISC ------------------

CREATE TABLE LoginEntry
(
    Id        INT          NOT NULL IDENTITY (1,1),
    UserId    NVARCHAR(30) NOT NULL,
    TimeLogin DATETIME     NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PkLoginEntry_Id PRIMARY KEY (Id),
    CONSTRAINT FkLoginEntry_UserId FOREIGN KEY (UserId) REFERENCES UserReg (Username),

)

-- PROCEDURES --------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- ACTIONS ON USERS -------------------------------

DROP PROCEDURE spSaveAccount;
GO;

CREATE PROCEDURE spSaveAccount(@username NVARCHAR(30), @givenName NVARCHAR(30), @lastName NVARCHAR(30),
                               @password NVARCHAR(30), @role INT, @byUser NVARCHAR(30))
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @timeDone DATETIME,
            @notifTypeId NVARCHAR(10);

        SELECT @notifTypeId = IIF(@username = @byUser, 'UREG', 'UINS');

        IF ((@notifTypeId = 'UINS') AND
            NOT EXISTS(SELECT 1 FROM UserReg WHERE Username = @byUser AND Role = 2 AND Status = 1))
            RAISERROR ('UINS-User doesn''t exist or not in Admin role to create a new account with such authority or banned', 16, 1);

        IF ((@notifTypeId = 'UREG') AND @role <> 0)
            RAISERROR ('UINS-Cannot register as any other role than standard user', 16, 1);

        INSERT INTO UserReg (Username, GivenName, LastName, Password, Role)
        VALUES (@username, @givenName, @lastName, @password, @role);

        SELECT @timeDone = GETDATE();

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT @notifTypeId,
               @timeDone,
               Username,
               'User ' + @username + ' has been registered by admin ' + @byUser
                   + ' as ' + (CASE
                                   WHEN @role = 0
                                       THEN 'User'
                                   WHEN @role = 1
                                       THEN 'Tech'
                                   WHEN @role = 2
                                       THEN 'Admin' END) + ' Role'
        FROM UserReg
        WHERE Status = 1
          AND (@notifTypeId = 'UINS' AND (Role = 2 OR Username = @username));

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
            );

    END CATCH;

    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END; -- CREATE/REGISTRATION
GO;

DROP PROCEDURE spUpdateAccount;
GO;
CREATE PROCEDURE spUpdateAccount(@username NVARCHAR(30), @givenName NVARCHAR(30), @lastName NVARCHAR(30),
                                 @password NVARCHAR(30), @role INT, @byUser NVARCHAR(30)) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @timeDone DATETIME, @oldRole INT;

        SET @oldRole = (SELECT Role FROM UserReg WHERE Username = @username);

        IF (@username = @byUser AND @oldRole <> @role)
            RAISERROR ('UUPD-User cannot change their own role', 16, 1);

        IF (@username <> @byUser AND NOT EXISTS(SELECT 1 FROM UserReg WHERE Username = @byUser AND Role = 2))
            RAISERROR ('UUPD-User doesn''t exist or is not in Admin role to update other users'' accounts', 16, 1);

        IF NOT EXISTS(SELECT 1 FROM UserReg WHERE Username = @username AND Status = 1)
            RAISERROR ('UUPD-User to be updated not found or banned', 16, 1);

        IF NOT EXISTS(SELECT 1 FROM UserReg WHERE Username = @byUser AND Status = 1)
            RAISERROR ('UUPD-Updater not found or banned', 16 ,1);

        IF (@username = @byUser)
            UPDATE UserReg
            SET GivenName = @givenName,
                LastName  = @lastName,
                Password  = @password,
                Role      = @role
            WHERE Username = @username;
        ELSE
            UPDATE UserReg
            SET GivenName = @givenName,
                LastName  = @lastName,
                Role      = @role
            WHERE Username = @username;

        SET @timeDone = GETDATE();

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'UUPD',
               @timeDone,
               Username,
               'User ' + @username + ' profile has been updated by admin ' + @byUser
                   + IIF(@oldRole <> @role, ' with new role ' + (CASE
                                                                     WHEN @role = 0 THEN 'Standard User'
                                                                     WHEN @role = 1 THEN 'Tech'
                                                                     WHEN @role = 2 THEN 'Admin' END), '')
        FROM UserReg
        WHERE Status = 1
          AND (@username <> @byUser AND (Role = 2 OR Username = @username));

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
            );
    END CATCH
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION
    SET NOCOUNT OFF;
END; -- UPDATE
GO;

CREATE PROCEDURE spDeleteAccount(@username NVARCHAR(30), @byUser NVARCHAR(30))
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @timeDone DATETIME;

        IF (@username = @byUser)
            RAISERROR ('UDEL-Cannot ban self', 16, 1);

        IF NOT EXISTS(SELECT 1 FROM UserReg WHERE Username = @username)
            RAISERROR ('UDEL-User to be banned not found', 16, 1);

        IF NOT EXISTS(SELECT 1 FROM UserReg WHERE Username = @byUser AND Role = 2)
            RAISERROR ('UDEL-User doesn''t exist or is not in Admin role to ban accounts', 16, 1);

        IF EXISTS(SELECT Status FROM UserReg WHERE Username = @username AND Status = 0)
            RAISERROR ('UDEL-Cannot delete already banned user', 16, 1);

        IF EXISTS(SELECT 1
                  FROM Request Req
                           INNER JOIN Report Rep ON Req.Id = Rep.RequestId
                  WHERE Req.Status = 1
                    AND ProceededBy = @username)
            RAISERROR ('UDEL-Cannot ban tech who is currently working on repairing an equipment', 16, 1);

        UPDATE UserReg
        SET Status = 0
        WHERE Username = @username;

        DELETE
        FROM UserCurrentLocation
        WHERE UserId = @username;

        SET @timeDone = GETDATE();

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'UDEL',
               @timeDone,
               Username,
               'User ' + @username + ' has been banned by admin ' + @byUser
        FROM UserReg
        WHERE Role = 2;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
            );
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END; -- DELETE
GO;

CREATE PROCEDURE spValidateLogin(@username NVARCHAR(30), @password NVARCHAR(30)) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE
            @timeDone DATETIME,
            @givenName NVARCHAR(30),
            @lastName NVARCHAR(30),
            @role INT,
            @userStatus BIT;

        SELECT @givenName = GivenName, @lastName = LastName, @userStatus = Status, @role = Role
        FROM UserReg
        WHERE Username = @username
          AND Password = @password;

        IF (@userStatus IS NULL)
            RAISERROR ('ULOG-Invalid username or password', 16, 1);
        ELSE
            IF (@userStatus = 0)
                RAISERROR ('ULOG-User was banned', 16, 1);

        SET @timeDone = GETDATE();

        SELECT @username  AS Username,
               @givenName AS GivenName,
               @lastName  AS LastName,
               @role      AS Role,
               @timeDone  AS TimeLogin

        INSERT INTO LoginEntry (UserId, TimeLogin) VALUES (@username, @timeDone);

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
            );
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END; -- LOGIN
GO;

CREATE PROCEDURE spTransferUser(@byUser NVARCHAR(30), @userMoved NVARCHAR(30), @roomId NVARCHAR(10)) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE
            @timeDone DATETIME,
            @oldRoomId NVARCHAR(10) = NULL;

        IF NOT EXISTS(SELECT 1 FROM UserReg WHERE Username = @userMoved)
            RAISERROR ('UMOVE-User to be moved is not found', 16, 1);

        IF NOT EXISTS(SELECT 1 FROM UserReg WHERE Username = @byUser AND Role = 2)
            RAISERROR ('UMOVE-User doesn''t exist or is not in Admin role to move other users', 16, 1);

        IF NOT EXISTS((SELECT 1 FROM Room WHERE Id = @roomId))
            RAISERROR ('UMOVE-Invalid Location: location does not exist', 16, 1);

        IF ((SELECT Status FROM Room WHERE Id = @roomId) = 0)
            RAISERROR ('UMOVE-Invalid Location: location was unregistered', 16, 1);

        SELECT @oldRoomId = RoomId FROM UserCurrentLocation WHERE UserId = @userMoved;

        IF (@oldRoomId IS NOT NULL AND @roomId = @oldRoomId)
            RAISERROR ('UMOVE-Not possible to move user to where they are now', 16, 1);

        SET @timeDone = GETDATE();

        IF (@oldRoomId IS NULL)
            INSERT INTO UserCurrentLocation (UserId, RoomId, FromDate)
            VALUES (@userMoved, @RoomId, @timeDone);
        ELSE
            UPDATE UserCurrentLocation
            SET RoomId   = @roomId,
                FromDate = @timeDone
            WHERE UserId = @userMoved;

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'UMOVE',
               @timeDone,
               Username,
               IIF(@oldRoomId IS NOT NULL
                   ,
                   'User ' + @userMoved + ' has been moved from ' +
                   'room ' + @oldRoomId + ' (' + (SELECT Name FROM Room WHERE Id = @oldRoomId) +
                   ') ' +
                   'to room ' + @roomId + ' (' + (SELECT Name FROM Room WHERE Id = @roomId) + ') '
                   ,
                   'User ' + @userMoved + ' has been moved to room ' + @roomId +
                   ' (' + (SELECT Name FROM Room WHERE Id = @roomId) + ') '
                   )
                   + 'by admin ' + @byUser
        FROM UserReg
        WHERE Status = 1
          AND (Username IN (SELECT UserId
                            FROM UserCurrentLocation
                            WHERE RoomId IN (@oldRoomId, @roomId)));

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
            );
    END CATCH
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;

END -- MOVE
GO;

-- ACTIONS ON ROOMS ---------------------------------------------------------------------------

CREATE PROCEDURE spCreateRoom(@roomId NVARCHAR(10), @roomName NVARCHAR(30),
                              @byUser NVARCHAR(30)) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @timeDone DATETIME;

        INSERT INTO Room (Id, Name) VALUES (@roomId, @roomName);

        SET @timeDone = GETDATE();

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'RINS',
               @timeDone,
               Username,
               'New room ' + @roomId + ' (' + @roomName + ') ' + 'has been registered by admin ' + @byUser
        FROM UserReg
        WHERE Status = 1
          AND Role = 2;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END;
GO;

CREATE PROCEDURE spUpdateRoomName(@roomId NVARCHAR(10), @roomName NVARCHAR(30),
                                  @byUser NVARCHAR(30)) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;;
    BEGIN TRY
        IF EXISTS(SELECT 1 FROM Room WHERE Id = @roomId AND Status = 0)
            RAISERROR ('RUPD-Cannot update an already deleted location', 16, 1);

        DECLARE @timeDone DATETIME, @oldName NVARCHAR(30);

        SET @oldName = (SELECT Name FROM Room WHERE Id = @roomId);

        UPDATE Room SET Name = @roomName WHERE Id = @roomId;

        SET @timeDone = GETDATE();

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'RUPD',
               @timeDone,
               Username,
               'Room ' + @roomId + ' name has been changed to ' + @roomName + ' (was ' + @oldName + ') by admin ' +
               @byUser
        FROM UserReg
        WHERE Status = 1
          AND (Username IN (SELECT UserId FROM UserCurrentLocation WHERE RoomId = @roomId)
            OR Role = 2);

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END;
GO;

CREATE PROCEDURE spDeleteRoom(@roomId NVARCHAR(10), @byUser NVARCHAR(30))
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        IF EXISTS(SELECT 1 FROM Room WHERE Id = @roomId AND Status = 0)
            RAISERROR ('RDEL-Cannot delete an already deleted room', 16, 1);

        IF (
                EXISTS(SELECT 1 FROM UserCurrentLocation WHERE RoomId = @roomId)
                OR
                EXISTS(SELECT 1
                       FROM EquipmentCurrentLocation ECL
                                INNER JOIN EquipmentLocationEntry ELE
                                           ON ECL.ELocEntryId = ELE.Id
                       WHERE ELE.RoomId = @roomId)
            )
            RAISERROR ('RDEL-Personel or asset still remains in the target location', 16, 1);

        DECLARE @timeDone DATETIME;

        UPDATE Room SET Status = 0 WHERE Id = @roomId;

        SET @timeDone = GETDATE();

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'RDEL',
               @timeDone,
               Username,
               'Room ' + @roomId + ' has been unregistered by admin ' + @byUser
        FROM UserReg
        WHERE Status = 1
          AND Role = 2;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END;
GO;

-- ACTIONS ON DEVICES ---------------------------------------------------------------------------------------------------
DROP PROC spSaveEquipment;
CREATE PROCEDURE spSaveEquipment(@id NVARCHAR(10), @name NVARCHAR(30), @dateBought DATETIME, @warranty INT,
                                 @description NVARCHAR(200),
                                 @typeName NVARCHAR(30),
                                 @byUser NVARCHAR(30)) AS
BEGIN
    -- COMBO BOX & Text INPUT, USING CHECKBOX TO DECIDE
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @timeDone DATETIME, @newTypeId INT;

        SET @dateBought = IIF(@dateBought IS NULL, GETDATE(), @dateBought);

        SET @newTypeId = (SELECT Id FROM EquipmentType WHERE Name = @TypeName);

        IF (@newTypeId IS NULL)
            BEGIN
                INSERT INTO EquipmentType (Name) VALUES (@TypeName);

                SET @newTypeId = SCOPE_IDENTITY();
            END;

        INSERT INTO Equipment (Id, Name, DateBought, Warranty, TypeId, DESCRIPTION)
        VALUES (@id, @name, @dateBought, @warranty, @newTypeId, @description);

        SET @timeDone = GETDATE();

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'EINS',
               @timeDone,
               Username,
               'New equipment ' + @id + ' (' + @name + ') has been registered by admin ' + @byUser
        FROM UserReg
        WHERE Status = 1
          AND Role = 2;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END;
GO;

DROP PROCEDURE spUpdateEquipment;
CREATE PROCEDURE spUpdateEquipment(@id NVARCHAR(10), @name NVARCHAR(30),
                                   @dateBought DATETIME, @warranty INT,
                                   @description NVARCHAR(200),
                                   @TypeName NVARCHAR(30),
                                   @byUser NVARCHAR(30)) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY

        DECLARE @timeDone DATETIME,
            @typeId INT = NULL,
            @currentRoomId NVARCHAR(10) = NULL,
            @currentTechId NVARCHAR(30) = NULL;

        SET @typeId = (SELECT Id FROM EquipmentType WHERE Name = @TypeName);

        IF (@typeId IS NULL)
            BEGIN
                INSERT INTO EquipmentType (Name) VALUES (@TypeName);

                SET @typeId = SCOPE_IDENTITY();
            END;


        UPDATE Equipment
        SET Name        = @name,
            DateBought  = IIF(@dateBought IS NOT NULL, @dateBought, DateBought),
            Warranty    = @warranty,
            Description = @description,
            TypeId      = @typeId
        WHERE Id = @id;

        SET @timeDone = GETDATE();

        IF ((SELECT Status FROM Equipment WHERE Id = @id) = 0)
            SET @currentTechId = (SELECT Rep.ProceededBy
                                  FROM Request Req
                                           INNER JOIN Report Rep ON Req.Id = Rep.RequestId
                                  WHERE EquipmentId = @id
                                    AND Req.Status = 1);

        SET @currentRoomId = (SELECT RoomId
                              FROM EquipmentCurrentLocation ECL
                                       INNER JOIN EquipmentLocationEntry ELE
                                                  ON ECL.ELocEntryId = ELE.Id
                              WHERE EquipmentId = @id);

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'EUPD',
               @timeDone,
               Username,
               'Equipment ' + @id + ' detail has been updated by admin ' + @byUser
        FROM UserReg UR
                 LEFT JOIN UserCurrentLocation UCL ON UR.Username = UCL.UserId
        WHERE UR.Status = 1
          AND ((UCL.RoomId IS NOT NULL AND UCL.RoomId = @currentRoomId) -- Possibly Null, equipment is not in any room
            OR UR.Role = 2 -- All admins
            OR (UR.Role = 1 AND UR.Username = @currentTechId)); -- Possibly Null, found no tech working on the equipment
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END;
GO;

DROP PROCEDURE spUpdateEquipmentImage;
CREATE PROCEDURE spUpdateEquipmentImage(@id NVARCHAR(10), @imagePath NVARCHAR(260)) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        IF NOT EXISTS(SELECT 1
                      FROM Equipment E
                               INNER JOIN EquipmentImage EI ON E.Id = EI.EquipmentId
                      WHERE E.Id = @id)
            INSERT INTO EquipmentImage (EquipmentId, Path) VALUES (@id, @imagePath);
        ELSE
            UPDATE EquipmentImage SET Path = @imagePath WHERE EquipmentId = @id;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END
GO;

DROP PROCEDURE spDeleteEquipment;
CREATE PROCEDURE spDeleteEquipment(@id NVARCHAR(10),
                                   @byUser NVARCHAR(30)) AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE
            @equipmentStatus INT,
            @attachedRequestId INT ,
            @attachedRequestStatus INT,
            @timeDone DATETIME,
            @currentRoomId NVARCHAR(10);

        SET @equipmentStatus = (SELECT Status FROM Equipment WHERE Id = @id);

        IF (@equipmentStatus = -1)
            RAISERROR ('EDEL-Cannot delete an already deleted equipment', 16, 1);

        IF (@equipmentStatus = 0) -- Equipment is broken
            BEGIN
                -- Check there's any ACTIVE request attached to the BROKEN equipment
                SELECT @attachedRequestId = Id,
                       @attachedRequestStatus = Status
                FROM Request
                WHERE EquipmentId = @id
                  AND Status IN (0, 1);

                IF (@attachedRequestId IS NOT NULL) -- Found a request attached to the equipment
                    BEGIN
                        EXEC spDenyRequest @attachedRequestId, @byUser,
                             'Equipment is removed';
                    END;
            END;

        UPDATE Equipment
        SET Status = -1
        WHERE Id = @id;

        SET @timeDone = GETDATE();

        SET @currentRoomId = (SELECT RoomId
                              FROM EquipmentCurrentLocation ECL
                                       INNER JOIN EquipmentLocationEntry ELE ON ECL.ELocEntryId = ELE.Id
                              WHERE EquipmentId = @id);

        DELETE
        FROM EquipmentCurrentLocation
        WHERE ELocEntryId = (SELECT Id
                             FROM EquipmentLocationEntry ELE
                                      INNER JOIN EquipmentCurrentLocation ECL ON ELE.Id = ECL.ELocEntryId
                             WHERE EquipmentId = @id);

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'EDEL',
               @timeDone,
               Username,
               'Equipment ' + @id + ' has been removed by admin ' + @byUser
        FROM UserReg UR
                 LEFT JOIN UserCurrentLocation UCL ON UR.Username = UCL.UserId
        WHERE UR.Status = 1
          AND ((UCL.RoomId IS NOT NULL AND UCL.RoomId = @currentRoomId) OR UR.Role = 2);


    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END
GO;

DROP PROCEDURE spTransferEquipment;
CREATE PROCEDURE spTransferEquipment(@equipmentId NVARCHAR(10), @roomId NVARCHAR(10), @byUser NVARCHAR(30),
                                     @reasonMoving NVARCHAR(100)) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE
            @timeDone DATETIME,
            @oldRoomId NVARCHAR(10) = NULL,
            @currentTechId NVARCHAR(30) = NULL,
            @currentLocationId INT,
            @newLocationId INT;

        SELECT @oldRoomId = RoomId,
               @currentLocationId = ELocEntryId
        FROM EquipmentCurrentLocation ECL
                 INNER JOIN EquipmentLocationEntry ELE
                            ON ECL.ELocEntryId = ELE.Id
        WHERE EquipmentId = @equipmentId;


        IF (@roomId = @oldRoomId)
            RAISERROR ('EMOVE-Not possible to move equipment to where it currently is', 16, 1);

        IF ((SELECT Status FROM Room WHERE Id = @roomId) = 0)
            RAISERROR ('EMOVE-Invalid Location: Location does not exist', 16, 1);

        SET @timeDone = GETDATE();

        SET @currentTechId = (SELECT ProceededBy
                              FROM Request req
                                       INNER JOIN Report rep ON req.Id = rep.RequestId
                              WHERE req.EquipmentId = @equipmentId
                                AND req.Status = 1);

        INSERT INTO EquipmentLocationEntry (EquipmentId, RoomId, FromDateTime, ByUser, ReasonMoving)
        VALUES (@equipmentId, @roomId, @timeDone, @byUser, @reasonMoving);

        SET @newLocationId = SCOPE_IDENTITY();

        IF (@oldRoomId IS NULL)
            INSERT INTO EquipmentCurrentLocation (ELocEntryId) VALUES (@newLocationId);
        ELSE
            UPDATE EquipmentCurrentLocation
            SET ELocEntryId = @newLocationId
            WHERE ELocEntryId = @currentLocationId;

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'EMOVE',
               @timeDone,
               Username,
               'Equipment ' + @equipmentId + ' has been moved to room ' + @roomId +
               IIF(@oldRoomId IS NOT NULL, ' from room ' + @oldRoomId, '')
        FROM UserReg UR
                 INNER JOIN UserCurrentLocation UCL ON UR.Username = UCL.UserId
        WHERE UR.Status = 1
          AND (RoomId IN (@roomId, @oldRoomId)
            OR Role = 2
            OR (Role = 1 AND UR.Username = @currentTechId));

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;

END
GO;


-- ACTION ON REQUEST -------------------------------------------------- VERY LIKELY PRONE TO ERROR -- PROCEED WITH CARE

CREATE PROCEDURE spMakeRequest(@equipmentId NVARCHAR(10), @makeBy NVARCHAR(30), @description NVARCHAR(200)) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @timeDone DATETIME,
            @requestId INT,
            @equipmentStatus INT,
            @equipmentLocation NVARCHAR(10);

        SELECT @equipmentStatus = Status FROM Equipment WHERE Id = @equipmentId;

        SET @equipmentLocation = ((SELECT RoomId
                                   FROM Equipment E
                                            INNER JOIN EquipmentLocationEntry ELE ON E.Id = ELE.EquipmentId
                                            INNER JOIN EquipmentCurrentLocation ECL ON ELE.Id = ECL.ELocEntryId
                                   WHERE EquipmentId = @equipmentId));

        IF (@equipmentLocation <> (SELECT RoomId
                                   FROM UserReg UR
                                            INNER JOIN UserCurrentLocation UCL ON UR.Username = UCL.UserId
                                   WHERE Username = @makeBy))
            RAISERROR ('REQMAKE-User cannot make request on equipments of other rooms which they are not in', 16, 1);

        IF (@equipmentStatus IS NULL)
            RAISERROR ('REQMAKE-Equipment not found', 16, 1);

        IF (@equipmentStatus = -1)
            RAISERROR ('REQMAKE-Equipment is not for usage anymore', 16, 1);

        -- exist an active request (sent/accepted) attached to the equipment
        IF EXISTS(SELECT 1 FROM Request WHERE EquipmentId = @equipmentId AND Status IN (0, 1))
            RAISERROR ('REQMAKE-Another request on the equipment is currently sent or is proceeded', 16, 1);

        UPDATE Equipment SET Status = 0 WHERE Id = @equipmentId;

        SET @timeDone = GETDATE();

        INSERT INTO Request (EquipmentId, CreatedBy, Description, TimeCreated)
        VALUES (@equipmentId, @makeBy, @description, @timeDone);

        SET @requestId = SCOPE_IDENTITY();

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'REQMAKE',
               @timeDone,
               Username,
               'Equipment ' + @equipmentId + ' has been request for repairing by ' + @makeBy
        FROM UserReg
        WHERE Status = 1
          AND (Username = @makeBy -- requester
            OR Role IN (1, 2)); -- All admins, all techs

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END;
GO;

CREATE PROCEDURE spAcceptRequest(@requestId INT, @proceededBy NVARCHAR(30))
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        IF NOT EXISTS(SELECT 1 FROM Request WHERE Id = @requestId)
            RAISERROR ('REQACCEPT-Request not found', 16, 1);

        IF ((SELECT Status FROM Request WHERE Id = @requestId) <> 0)
            RAISERROR ('REQACCEPT-This request is no longer available to accept', 16, 1);

        DECLARE @timeDone DATETIME,
            @requesterId NVARCHAR(30),
            @requestedEquipmentId NVARCHAR(10);

        SET @requestedEquipmentId = (SELECT EquipmentId FROM Request WHERE Id = @requestId);

        SET @timeDone = GETDATE();

        UPDATE Request SET Status = 1 WHERE Id = @requestId;

        INSERT INTO Report (RequestId, ProceededBy, Description, TimeStart)
        VALUES (@requestId, @proceededBy,
                'Began working on the equipment.',
                @timeDone);

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'REQACCEPT',
               @timeDone,
               Username,
               'Request on equipment ' + @requestedEquipmentId + ' has been accepted by ' + @proceededBy
        FROM UserReg
        WHERE Status = 1
          AND (Username = @requesterId -- Requester
            OR Role = 1); -- All tech

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;

END
GO;

CREATE PROCEDURE spUpdateReportDescription(@requestId INT, @reportDescription NVARCHAR(300)) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        IF NOT EXISTS(SELECT 1 FROM Request WHERE Id = @requestId)
            RAISERROR ('REQUPD-Request not found', 16, 1);

        UPDATE Report SET Description = @reportDescription WHERE RequestId = @requestId;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END
GO;

-- ACCEPT first ---------------> CANCEL/FINISH later OR downright DENY

-- only tech calls cancelRequest: when a request is canceled, a report of its is made and the request itself
-- immediately get done with result = failed (0), the request status becomes failed (-1) and archived
-- Keep in mind, request result = 0 while status = -1 means request is canceled by tech
-- request result = 0 while status = 2 means request is done with fail result, thus the equipment is still broken
DROP PROCEDURE spCancelRequest
CREATE PROCEDURE spCancelRequest(@requestId INT, @reasonCancel NVARCHAR(200)) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        IF NOT EXISTS(SELECT 1 FROM Request WHERE Id = @requestId)
            RAISERROR ('REQCANCEL-Request not found', 16, 1);

        IF (@reasonCancel IS NULL)
            RAISERROR ('REQCANCEL-A reason to cancel the request must be given', 16, 1);

        DECLARE
            @timeDone DATETIME,

            @requesterId NVARCHAR(30),
            @requestStatus INT,
            @requestedEquipmentId NVARCHAR(10),
            @requestDescription NVARCHAR(200),

            @techId NVARCHAR(30),
            @newRequestId INT,
            @customErrorMessage NVARCHAR(100);

        SELECT @requestStatus = Status,
               @requesterId = CreatedBy,
               @requestedEquipmentId = EquipmentId,
               @requestDescription = Description
        FROM Request
        WHERE Id = @requestId;

        SET @techId = (SELECT ProceededBy FROM Report WHERE RequestId = @requestId);

        IF (@requestStatus IN (-1, 2))
            BEGIN
                SET @customErrorMessage =
                            'REQCANCEL-Request has already been ' + IIF(@requestStatus = -1, 'canceled', 'finished');

                RAISERROR (@customErrorMessage, 16, 1);
            END

        UPDATE Request SET Status = -1 WHERE Id = @requestId; -- CANCELED

        UPDATE Report SET Description = 'Canceled because: ' + @reasonCancel WHERE RequestId = @requestId;

        SET @timeDone = GETDATE();

        INSERT INTO ReportResult (RequestId, TimeDone, Result) VALUES (@requestId, @timeDone, 0); -- FAILED

        INSERT INTO Request (EquipmentId, CreatedBy, Description, TimeCreated)
        VALUES (@requestedEquipmentId, @requesterId, @requestDescription, @timeDone)

        SET @newRequestId = SCOPE_IDENTITY();

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'REQCANCEL',
               @timeDone,
               Username,
               'Tech ' + @techId + ' canceled ' + @requesterId
                   + '''s request on equipment ' + @requestedEquipmentId + '. '
                   + 'A new request has been created for replacement.'
        FROM UserReg
        WHERE Status = 1
          AND (Username IN (@requesterId, @techId)
            OR Role IN (1, 2));

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END
GO;

-- Only admin calls denyRequest, when a request is denied, it is deleted, the requested equipment is made fine again,
-- no request replacement is made

CREATE PROCEDURE spDenyRequest(@requestId INT, @byUser NVARCHAR(30), @reasonDeny NVARCHAR(200)) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        IF NOT EXISTS(SELECT 1 FROM Request WHERE Id = @requestId)
            RAISERROR ('REQDENY-Request not found', 16, 1);

        DECLARE
            @requesterId NVARCHAR(30),
            @requestStatus INT,
            @requestedEquipmentId NVARCHAR(10),
            @timeDone DATETIME;

        IF NOT EXISTS(SELECT 1 FROM Request WHERE Id = @requestId)
            RAISERROR ('REQDENY-Request not found', 16, 1);

        IF (@reasonDeny IS NULL)
            RAISERROR ('REQDENY-A reason to cancel the request must be given', 16, 1);

        IF ((SELECT Role FROM UserReg WHERE Username = @byUser) <> 2)
            RAISERROR ('REQDENY-Only admin can deny waiting request', 16, 1);

        -- Just to make sure
        SELECT @requestStatus = Status FROM Request WHERE Id = @requestId

        IF (@requestStatus NOT IN (0, 1))
            RAISERROR ('REQDENY-Cannot deny request of which status is currently not active', 16, 1);

        SET @timeDone = GETDATE();

        SELECT @requesterId = CreatedBy,
               @requestedEquipmentId = EquipmentId
        FROM Request
        WHERE Id = @requestId;

        IF (@requestStatus = 1)
            DELETE FROM Report WHERE RequestId = @requestId;

        DELETE FROM Request WHERE Id = @requestId -- Straight delete

        UPDATE Equipment SET Status = 1 WHERE Id = @requestedEquipmentId; -- fine

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'REQDENY',
               @timeDone,
               Username,
               'Admin ' + @byUser + ' denied ' + @requesterId + '''s request on equipment ' +
               @requestedEquipmentId + '. Reason: ' + @reasonDeny
        FROM UserReg
        WHERE Status = 1
          AND (Username = @requesterId OR Role IN (1, 2));

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END
GO;

CREATE PROCEDURE spFinishRequest(@requestId INT, @result BIT) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE
            @timeDone DATETIME,
            @requestStatus INT,
            @requestedEquipmentId NVARCHAR(10),
            @requesterId NVARCHAR(30),
            @finisherId NVARCHAR(30);
        SELECT @requestStatus = Status FROM Request WHERE Id = @requestId;

        IF (@requestStatus IS NULL)
            RAISERROR ('REQFINISH-Request not found', 16, 1);

        IF (@requestStatus <> 1)
            RAISERROR ('REQFINISH-Request was already canceled or finished, or is not yet accepted', 16, 1);

        UPDATE Request
        SET Status = 2
        WHERE Id = @requestId;

        SET @timeDone = GETDATE();

        INSERT INTO ReportResult (RequestId, TimeDone, RESULT)
        VALUES (@requestId, @timeDone, @result);

        SELECT @requestedEquipmentId = E.Id
        FROM Equipment E
                 INNER JOIN Request R ON E.Id = R.EquipmentId
        WHERE R.Id = @requestId

        UPDATE Equipment
        SET Status       = IIF(@result = 1, 1, 0),
            TimeRepaired = TimeRepaired + 1
        WHERE Id = @requestedEquipmentId;

        SET @requesterId = (SELECT CreatedBy FROM Request WHERE Id = @requestId);

        SET @finisherId = (SELECT ProceededBy
                           FROM Request req
                                    INNER JOIN Report rep ON req.Id = rep.RequestId
                           WHERE req.Id = @requestId);

        SELECT @requestedEquipmentId = Req.EquipmentId,
               @requesterId = Req.CreatedBy,
               @finisherId = Rep.ProceededBy
        FROM Request Req
                 INNER JOIN Report Rep ON Req.Id = Rep.RequestId;

        INSERT INTO Notification (TypeId, TimeCreated, ForUser, Message)
        SELECT 'REQFINISH',
               @timeDone,
               Username,
               'Tech ' + @finisherId + ' has finished repair request on equipment ' + @requestedEquipmentId
        FROM UserReg
        WHERE Status = 1
          AND (Username IN (@requesterId, @finisherId));

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

    SET NOCOUNT OFF;
END
GO;
DROP PROCEDURE spFinishRequest
GO;

-- QUERIES ------------------------------------------------------

-- Notification queries
DROP PROC spLoadNotification;
GO;

CREATE PROCEDURE spLoadNotification(@userId NVARCHAR(30),
                                    @typeGroup NVARCHAR(30),
                                    @fromDate DATETIME,
                                    @topSelectNumber INT) AS
BEGIN
    -- First query
    SELECT TOP (@topSelectNumber) Id,
                                  TimeCreated,
                                  TypeId,
                                  Message
    FROM Notification
    WHERE ForUser = @userId
      AND TypeId LIKE (CASE
                           WHEN @typeGroup = 'user' THEN 'U%'
                           WHEN @typeGroup = 'room' THEN 'R___'
                           WHEN @typeGroup = 'equipment' THEN 'E%'
                           WHEN @typeGroup = 'request' THEN 'REQ%'
                           WHEN @typeGroup = 'all' THEN '%' END)
      AND TimeCreated >= IIF(@fromDate IS NOT NULL, @fromDate, CONVERT(DATETIME, '1800-05-05'))
    ORDER BY TimeCreated DESC;

    -- Second query
    SELECT COUNT(Id) AS CountUnread FROM Notification WHERE ForUser = @userId;
END
GO;

-- Account queries
DROP PROCEDURE spGetAccountList;
CREATE PROCEDURE spGetAccountList(@givenName NVARCHAR(30), @lastName NVARCHAR(30),
                                  @roomId NVARCHAR(10), @bannedIncluded BIT) AS
BEGIN

    SELECT *
    FROM (SELECT UR.Username,
                 UR.GivenName,
                 UR.LastName,
                 UR.Status,
                 UR.Role,
                 IIF(UCL.RoomId IS NOT NULL, UCL.RoomId, '--') AS RoomId,
                 IIF(R.Name IS NOT NULL, R.Name, 'unassigned') AS RoomName
          FROM UserReg UR
                   LEFT JOIN UserCurrentLocation UCL ON UR.Username = UCL.UserId
                   LEFT JOIN Room R ON UCL.RoomId = R.Id
          WHERE (GivenName LIKE '%' + @givenName + '%' AND LastName LIKE '%' + @lastName + '%')
            AND ((@bannedIncluded = 1) OR (@bannedIncluded = 0 AND UR.Status = 1))) AS resultTbl
    WHERE @roomId = 'all'
       OR (@roomId = 'homeless' AND resultTbl.RoomId = '--')
       OR (@roomId NOT IN ('homeless', 'all') AND resultTbl.RoomId = @roomId)
    ORDER BY resultTbl.RoomId

END
GO;

DROP PROCEDURE spGetAccount;
CREATE PROCEDURE spGetAccount(@username NVARCHAR(30))
AS
BEGIN
    SELECT UR.Username,
           UR.GivenName,
           UR.LastName,
           UR.Status,
           UR.Role,
           IIF(UCL.RoomId IS NOT NULL, UCL.RoomId, '--') AS RoomId,
           IIF(R.Name IS NOT NULL, R.Name, '--')         AS RoomName
    FROM UserReg UR
             LEFT JOIN UserCurrentLocation UCL ON UR.Username = UCL.UserId
             LEFT JOIN Room R ON UCL.RoomId = R.Id
    WHERE Username = @username
      AND UR.Status = 1;
END
GO;

CREATE PROCEDURE spGetRoomMemberList @roomId NVARCHAR(10)
AS
BEGIN
    SELECT Username, GivenName, LastName, Role
    FROM UserReg UR
             INNER JOIN UserCurrentLocation UCL ON UR.Username = UCL.UserId
    WHERE RoomId = @roomId
END
GO;

-- Room queries ------
DROP PROCEDURE spGetRoomsListWithStats;
CREATE PROCEDURE spGetRoomsListWithStats(@roomId NVARCHAR(10)) AS
BEGIN
    SELECT R.Id,
           R.Name,
           IIF(EquipmentCount IS NOT NULL, EquipmentCount, 0) AS EquipmentCount,
           IIF(PeopleCount IS NOT NULL, PeopleCount, 0)       AS PeopleCount
    FROM Room R
             LEFT JOIN (SELECT RoomId, COUNT(EquipmentId) AS EquipmentCount
                        FROM EquipmentLocationEntry ELE
                                 INNER JOIN EquipmentCurrentLocation ECL ON ELE.Id = ECL.ELocEntryId
                        GROUP BY RoomId) AS ECountTbl ON R.Id = ECountTbl.RoomId
             LEFT JOIN (SELECT RoomId, COUNT(UserId) AS PeopleCount
                        FROM UserCurrentLocation
                        GROUP BY RoomId) AS PCountTbl ON R.Id = PCountTbl.RoomId
    WHERE Status = 1
      AND (@roomId IS NULL OR (@roomId IS NOT NULL AND R.Id = @roomId));
END
GO;

DROP PROCEDURE spGetRoom;
CREATE PROCEDURE spGetRoom(@id NVARCHAR(10)) AS
BEGIN
    -- STATS
    EXEC spGetRoomsListWithStats @id;

    -- People List
    SELECT UR.Username, UR.GivenName, UR.LastName, UR.Role
    FROM UserReg UR
             LEFT JOIN UserCurrentLocation UCL ON UR.Username = UCL.UserId
    WHERE UR.Status = 1
      AND UCL.RoomId = @id;

    --Equipment List
    SELECT E.Id    AS EquipmentId,
           ET.Name AS EquipmentName,
           DateBought,
           Warranty,
           TimeRepaired,
           Status,
           ET.Name AS TypeName,
           Description
    FROM Equipment E
             INNER JOIN
         (SELECT EquipmentId, RoomId
          FROM EquipmentLocationEntry ELE
                   INNER JOIN EquipmentCurrentLocation ECL ON ELE.Id = ECL.ELocEntryId)
             AS ECusTbl ON E.Id = ECusTbl.EquipmentId
             INNER JOIN EquipmentType ET ON E.TypeId = ET.Id
    WHERE RoomId = @id;

END
GO;

EXEC spGetEquipmentFullDetails 'E001'

-- Equipment queries ---
DROP PROCEDURE spGetEquipmentFullDetails;
CREATE PROCEDURE spGetEquipmentFullDetails(@id NVARCHAR(10)) AS
BEGIN
    -- Active Request ----
    SELECT Id, Status, CreatedBy, ProceededBy
    FROM Request Req
             LEFT JOIN Report Rep ON Req.Id = Rep.RequestId
    WHERE EquipmentId = @id
      AND Status IN (0, 1);

    -- Location History ----
    SELECT R.Id   AS RoomId,
           R.Name AS RoomName,
           FromDateTime,
           ByUser,
           ReasonMoving
    FROM EquipmentLocationEntry ELE
             INNER JOIN Room R ON ELE.RoomId = R.Id
    WHERE EquipmentId = @id
    ORDER BY FromDateTime;

    -- Repair History ----
    SELECT Req.Id,
           Req.CreatedBy,
           UR.GivenName    AS RequesterGivenName,
           UR.LastName     AS RequesterLastName,
           Req.Description,
           Req.TimeCreated,
           Rep.Description AS RepairDescription,
           Rep.ProceededBy,
           UR2.GivenName   AS ExecutorGivenName,
           UR2.LastName    AS ExecutorLastName,
           Rep.TimeStart,
           RR.TimeDone,
           RR.Result
    FROM Request Req
             INNER JOIN Report Rep ON Req.Id = Rep.RequestId
             INNER JOIN ReportResult RR ON Req.Id = RR.RequestId
             INNER JOIN UserReg UR ON Req.CreatedBy = UR.Username
             INNER JOIN UserReg UR2 ON Rep.ProceededBy = UR2.Username
    WHERE Req.EquipmentId = @id
      AND Req.Status IN (-1, 2);
    -- Equipment Details --
    SELECT E.Id,
           E.Name,
           DateBought,
           Warranty,
           TimeRepaired,
           E.Status,
           Description,
           ET.Name  AS TypeName,
           EI.Path  AS ImagePath,
           tbl.Id   AS RoomId,
           tbl.Name AS RoomName
    FROM Equipment E
             INNER JOIN EquipmentType ET ON E.TypeId = ET.Id
             LEFT JOIN EquipmentImage EI ON E.Id = EI.EquipmentId
             LEFT JOIN (SELECT R.Id, R.Name, ELE.EquipmentId
                        FROM EquipmentLocationEntry ELE
                                 INNER JOIN EquipmentCurrentLocation ECL ON ELE.Id = ECL.ELocEntryId
                                 INNER JOIN Room R ON ELE.RoomId = R.Id) AS tbl
                       ON E.Id = tbl.EquipmentId
    WHERE E.Id = @id;

END
GO;

-- String forRoomMember, int equipmentStatus, boolean warrantyOrderAsc, boolean dateBoughtOrderAsc, boolean repairTimeOrderAsc
DROP PROCEDURE spGetEquipmentList;
CREATE PROCEDURE spGetEquipmentList(@username NVARCHAR(30), @status INT, @warrantySort BIT, @dateBoughtSort BIT,
                                    @repairTimeSort BIT, @warrantyStatus BIT) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @roomId NVARCHAR(10) = NULL;
        IF (@username IS NOT NULL)
            BEGIN
                SET @roomId = (SELECT Id
                               FROM Room
                                        INNER JOIN UserCurrentLocation UCL ON Room.Id = UCL.RoomId
                               WHERE UCL.UserId = @username);

                IF (@roomId IS NULL)
                    RAISERROR ('GetEquipmentsQuery-User is currently not in any room to get results', 16, 1);
            END

        SELECT E.Id,
               E.Name,
               DateBought,
               Warranty,
               DATEADD(MONTH, Warranty, DateBought) AS DateExpired,
               TimeRepaired,
               E.Status,
               ET.Name                              AS TypeName,
               CurLocTbl.RoomId,
               CurLocTbl.RoomName,
               ActiveReqs.Id                        AS RequestId,
               ActiveReqs.Status                    AS RequestStatus
        FROM Equipment E
                 INNER JOIN EquipmentType ET ON E.TypeId = ET.Id
                 LEFT JOIN (SELECT R.Id AS RoomId, R.Name AS RoomName, EquipmentId
                            FROM EquipmentLocationEntry ELE
                                     INNER JOIN EquipmentCurrentLocation ECL ON ELE.Id = ECL.ELocEntryId
                                     INNER JOIN Room R ON ELE.RoomId = R.Id) AS CurLocTbl
                           ON E.Id = CurLocTbl.EquipmentId
                 LEFT JOIN (SELECT Id, Status, EquipmentId FROM Request WHERE Status IN (0, 1)) AS ActiveReqs
                           ON E.Id = ActiveReqs.EquipmentId
        WHERE E.Status = @status
          AND ((@username IS NOT NULL AND RoomId = @roomId) OR @username IS NULL)
          AND ((@warrantyStatus = 1 AND DATEADD(MONTH, Warranty, DateBought) >= GETDATE()) OR @warrantyStatus = 0)
        ORDER BY CASE WHEN @warrantySort = 0 THEN '' END,
                 CASE WHEN @warrantySort = 1 THEN Warranty END,
                 CASE WHEN @dateBoughtSort = 0 THEN '' END,
                 CASE WHEN @dateBoughtSort = 1 THEN DateBought END,
                 CASE WHEN @repairTimeSort = 0 THEN '' END,
                 CASE WHEN @repairTimeSort = 1 THEN TimeRepaired END


    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        SET NOCOUNT OFF;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
    SET NOCOUNT OFF;
END;
GO;

DROP PROCEDURE spGetEquipmentListType1;
CREATE PROCEDURE spGetEquipmentListType1(@status INT, @dateExpiredFrom DATE, @dateExpiredTo DATE) AS
BEGIN
    SELECT E.Id,
           E.Name,
           DateBought,
           Warranty,
           DATEADD(MONTH, Warranty, DateBought) AS DateExpired,
           TimeRepaired,
           E.Status,
           ET.Name                              AS TypeName,
           CurLocTbl.RoomId,
           CurLocTbl.RoomName,
           ActiveReqs.Id                        AS RequestId,
           ActiveReqs.Status                    AS RequestStatus
    FROM Equipment E
             INNER JOIN EquipmentType ET ON E.TypeId = ET.Id
             LEFT JOIN (SELECT R.Id AS RoomId, R.Name AS RoomName, EquipmentId
                        FROM EquipmentLocationEntry ELE
                                 INNER JOIN EquipmentCurrentLocation ECL ON ELE.Id = ECL.ELocEntryId
                                 INNER JOIN Room R ON ELE.RoomId = R.Id) AS CurLocTbl
                       ON E.Id = CurLocTbl.EquipmentId
             LEFT JOIN (SELECT Id, Status, EquipmentId FROM Request WHERE Status IN (0, 1)) AS ActiveReqs
                       ON E.Id = ActiveReqs.EquipmentId
    WHERE (E.Status = @status)
      AND (DATEADD(MONTH, Warranty, DateBought) >= @dateExpiredFrom AND
           DATEADD(MONTH, Warranty, DateBought) <= @dateExpiredTo)
END
GO;

DROP PROCEDURE spGetEquipmentListType2;
CREATE PROCEDURE spGetEquipmentListType2(@repairCount INT) AS
BEGIN
    SELECT E.Id,
           E.Name,
           DateBought,
           Warranty,
           DATEADD(MONTH, Warranty, DateBought) AS DateExpired,
           TimeRepaired,
           E.Status,
           ET.Name                              AS TypeName,
           CurLocTbl.RoomId,
           CurLocTbl.RoomName,
           ActiveReqs.Id                        AS RequestId,
           ActiveReqs.Status                    AS RequestStatus
    FROM Equipment E
             INNER JOIN EquipmentType ET ON E.TypeId = ET.Id
             LEFT JOIN (SELECT R.Id AS RoomId, R.Name AS RoomName, EquipmentId
                        FROM EquipmentLocationEntry ELE
                                 INNER JOIN EquipmentCurrentLocation ECL ON ELE.Id = ECL.ELocEntryId
                                 INNER JOIN Room R ON ELE.RoomId = R.Id) AS CurLocTbl
                       ON E.Id = CurLocTbl.EquipmentId
             LEFT JOIN (SELECT Id, Status, EquipmentId FROM Request WHERE Status IN (0, 1)) AS ActiveReqs
                       ON E.Id = ActiveReqs.EquipmentId
    WHERE TimeRepaired = @repairCount
      AND E.Status IN (0, 1);
END
GO;

EXEC spGetEquipmentListType1 0, '2010-10-01', '2020-10-01'

-- Request queries

CREATE PROCEDURE spGetPersonalRequestList(@username NVARCHAR(30), @onlyActive BIT)
AS
BEGIN
    SELECT R.Id, R.EquipmentId, R.CreatedBy, R.Status, R.TimeCreated, R.CreatedBy
    FROM Request R
             INNER JOIN UserReg UR ON R.CreatedBy = UR.Username
    WHERE Username = @username
      AND ((@onlyActive = 1 AND R.Status IN (0, 1)) OR (@onlyActive = 0))
END
GO;

DROP PROCEDURE spGetActiveRequestsForTech
CREATE PROCEDURE spGetActiveRequestsForTech(@username NVARCHAR(30)) AS
BEGIN
    -- Sent Requests ---
    SELECT Id, EquipmentId, CreatedBy, Status, TimeCreated, Description
    FROM Request
    WHERE Status = 0;

-- Accepted Requests (personal---

    SELECT Id,
           EquipmentId,
           CreatedBy,
           Status,
           TimeCreated,
           Req.Description AS RequestDescription,
           TimeStart,
           Rep.Description AS RepairDiary
    FROM Request Req
             INNER JOIN Report Rep ON Req.Id = Rep.RequestId
    WHERE ProceededBy = @username
      AND Status = 1;

END
GO;

DROP PROCEDURE spGetActiveRequest;
CREATE PROCEDURE spGetActiveRequest(@requestId INT) AS
BEGIN
    SELECT Req.Id,
           Req.EquipmentId,
           E.Name          AS EquipmentName,
           ET.Name         AS EquipmentTypeName,
           CreatedBy,
           UR2.GivenName   AS RequesterGivenName,
           UR2.LastName    AS RequesterLastName,
           Req.Status,
           TimeCreated,
           Req.Description AS RequestDescription,
           Rep.ProceededBy,
           UR.GivenName    AS ExecutorGivenName,
           UR.LastName     AS ExecutorLastName,
           Rep.TimeStart,
           Rep.Description AS RepairDiary
    FROM Request Req
             INNER JOIN Equipment E ON Req.EquipmentId = E.Id
             INNER JOIN EquipmentType ET ON E.TypeId = ET.Id
             LEFT JOIN Report Rep ON Req.Id = Rep.RequestId
             LEFT JOIN UserReg UR ON Rep.ProceededBy = UR.Username
             LEFT JOIN UserReg UR2 ON Req.CreatedBy = UR2.Username
    WHERE Req.Status IN (0, 1)
      AND Req.Id = @requestId;
END
GO;

DROP PROCEDURE spGetDualRequestContainer;
CREATE PROCEDURE spGetDualRequestContainer(@username NVARCHAR(30)) AS
BEGIN
    -- SELECT PUSHED REQUESTS
    SELECT Req.Id,
           Req.EquipmentId,
           E.Name                                AS EquipmentName,
           ET.Name                               AS EquipmentTypeName,
           CreatedBy,
           Req.Status,
           TimeCreated,
           DATEDIFF(DAY, TimeCreated, GETDATE()) AS DayCountSinceRequest
    FROM Request Req
             INNER JOIN Equipment E ON Req.EquipmentId = E.Id
             INNER JOIN EquipmentType ET ON E.TypeId = ET.Id
    WHERE Req.Status = 0
    ORDER BY DayCountSinceRequest DESC;

    -- SELECT ACCEPTED REQUESTS
    SELECT Req.Id,
           Req.EquipmentId,
           E.Name                                                      AS EquipmentName,
           ET.Name                                                     AS EquipmentTypeName,
           CreatedBy,
           Req.Status,
           TimeCreated,
           Rep.ProceededBy,
           Rep.TimeStart,
           DATEDIFF(DAY, TimeCreated, GETDATE())                       AS DayCountSinceRequest,
           IIF(Req.Status = 0, 0, DATEDIFF(DAY, TimeStart, GETDATE())) AS DayCountSinceBegin
    FROM Request Req
             INNER JOIN Equipment E ON Req.EquipmentId = E.Id
             INNER JOIN EquipmentType ET ON E.TypeId = ET.Id
             INNER JOIN Report Rep ON Req.Id = Rep.RequestId
    WHERE Rep.ProceededBy = @username
      AND Req.Status = 1
    ORDER BY DayCountSinceRequest DESC, DayCountSinceBegin;
END
GO;

DROP PROCEDURE spGetSingleRequestContainer;
CREATE PROCEDURE spGetSingleRequestContainer(@username NVARCHAR(30)) AS
BEGIN
    SELECT REQ.ID                                                      AS RequestId,
           EquipmentId,
           E.Name                                                      AS EquipmentName,
           REQ.Status                                                  AS RequestStatus,
           CreatedBy,
           TimeCreated,
           ProceededBy,
           TimeStart,
           DATEDIFF(DAY, TimeCreated, GETDATE())                       AS DayCountSinceRequest,
           IIF(Req.Status = 0, 0, DATEDIFF(DAY, TimeStart, GETDATE())) AS DayCountSinceBegin
    FROM Request REQ
             LEFT JOIN Report REP ON REQ.Id = REP.RequestId
             INNER JOIN Equipment E ON REQ.EquipmentId = E.Id
    WHERE REQ.Status IN (0, 1)
      AND REQ.CreatedBy = @username
    ORDER BY DayCountSinceRequest DESC, DayCountSinceBegin;
END
GO;

DROP PROCEDURE spGetDualRequestContainerForAdmin;
CREATE PROCEDURE spGetDualRequestContainerForAdmin AS
BEGIN
    -- SELECT PUSHED REQUESTS
    SELECT Req.Id,
           Req.EquipmentId,
           E.Name                                AS EquipmentName,
           ET.Name                               AS EquipmentTypeName,
           CreatedBy,
           Req.Status,
           TimeCreated,
           DATEDIFF(DAY, TimeCreated, GETDATE()) AS DayCountSinceRequest
    FROM Request Req
             INNER JOIN Equipment E ON Req.EquipmentId = E.Id
             INNER JOIN EquipmentType ET ON E.TypeId = ET.Id
    WHERE Req.Status = 0
    ORDER BY DayCountSinceRequest DESC

    -- SELECT ACCEPTED REQUESTS
    SELECT Req.Id,
           Req.EquipmentId,
           E.Name                                                      AS EquipmentName,
           ET.Name                                                     AS EquipmentTypeName,
           CreatedBy,
           Req.Status,
           TimeCreated,
           Rep.ProceededBy,
           Rep.TimeStart,
           DATEDIFF(DAY, TimeCreated, GETDATE())                       AS DayCountSinceRequest,
           IIF(Req.Status = 0, 0, DATEDIFF(DAY, TimeStart, GETDATE())) AS DayCountSinceBegin
    FROM Request Req
             INNER JOIN Equipment E ON Req.EquipmentId = E.Id
             INNER JOIN EquipmentType ET ON E.TypeId = ET.Id
             INNER JOIN Report Rep ON Req.Id = Rep.RequestId
    WHERE Req.Status = 1
    ORDER BY DayCountSinceRequest DESC, DayCountSinceBegin;
END
GO;

EXEC spGetEquipmentList NULL, 1, 1, 1, 1, 1

EXEC spMakeRequest 'E002', 'tungnd', 'testing final'
EXEC spMakeRequest 'E88', 'signalz', 'testing final'
EXEC spMakeRequest 'E001', 'mofo', 'testing final'

EXEC spAcceptRequest 36, 'techtud'
EXEC spAcceptRequest 35, 'khanhdaica'

EXEC spGetDualRequestContainer 'techtud'
EXEC spGetDualRequestContainerForAdmin
EXEC spGetSingleRequestContainer 'mofo'


SELECT ABS(DATEDIFF(DAY, GETDATE(), GETDATE()));

EXEC spGetDualRequestContainer 'techtud'

