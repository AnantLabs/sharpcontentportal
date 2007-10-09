/* Start Views for SharpContent */

/* Message : Created View :CSWS_VW_FOLDERPERMISSIONS */
CREATE OR REPLACE FORCE VIEW {databaseOwner}SCP_VW_FOLDERPERMISSIONS  AS 
SELECT  FP.FolderPermissionID, F.FolderID, F.FolderPath, P.PermissionID, FP.RoleID, CASE FP.RoleID
WHEN -1 THEN 'All Users'
WHEN -2 THEN 'Superuser'
WHEN -3 THEN 'Unauthenticated Users'
ELSE TO_CHAR(R.RoleName)
END AS RoleName, FP.AllowAccess, P.PermissionCode, P.PermissionKey, P.PermissionName, F.PortalID
 FROM {databaseOwner}SCP_FolderPermission FP LEFT JOIN scp_Folders F
ON FP.FolderID = F.FolderID LEFT JOIN scp_Permission P
ON FP.PermissionID = P.PermissionID LEFT JOIN scp_Roles R
ON FP.RoleID = R.RoleID
/

/* Message : Created View :scp_VW_MODULEPERMISSIONS */
CREATE OR REPLACE FORCE VIEW {databaseOwner}SCP_VW_MODULEPERMISSIONS  AS 
SELECT  MP.ModulePermissionID, MP.ModuleID, P.PermissionID, MP.RoleID, CASE MP.RoleID
WHEN -1 THEN 'All Users'
WHEN -2 THEN 'Superuser'
WHEN -3 THEN 'Unauthenticated Users'
ELSE TO_CHAR(R.RoleName)
END AS RoleName, MP.AllowAccess, P.PermissionCode, P.ModuleDefID, P.PermissionKey, P.PermissionName
 FROM {databaseOwner}SCP_ModulePermission MP LEFT JOIN scp_Permission P
ON MP.PermissionID = P.PermissionID LEFT JOIN scp_Roles R
ON MP.RoleID = R.RoleID
/

/* Message : Created View :scp_VW_MODULES */
CREATE OR REPLACE FORCE VIEW {databaseOwner}SCP_VW_MODULES  AS 
SELECT  M.PortalID, TM.TabId, TM.TabModuleId, M.ModuleID, M.ModuleDefID, TM.ModuleOrder, TM.PaneName, M.ModuleTitle, TM.CacheTime, TM.Alignment, TM.Color, TM.Border, CASE 
WHEN SUBSTR(LOWER(TM.IconFile), 1, 6)='fileid' THEN (
		SELECT  Folder || FileName
		 FROM {databaseOwner}SCP_Files 
	WHERE 'FileID=' || TO_CHAR(scp_Files.FileID) = TM.IconFile  )
ELSE TM.IconFile 
END IconFile, M.AllTabs, TM.Visibility, M.IsDeleted, M.Header, M.Footer, M.StartDate, M.EndDate, TM.ContainerSrc, TM.DisplayTitle, TM.DisplayPrint, TM.DisplaySyndicate, M.InheritViewPermissions, DM.*, MC.ModuleControlId, MC.ControlSrc, MC.ControlType, MC.ControlTitle, MC.HelpURL
 FROM {databaseOwner}SCP_ModuleDefinitions MD INNER JOIN scp_Modules M
ON MD.ModuleDefID = M.ModuleDefID INNER JOIN scp_DesktopModules DM
ON MD.DesktopModuleID = DM.DesktopModuleID INNER JOIN scp_ModuleControls MC
ON MD.ModuleDefID = MC.ModuleDefID LEFT JOIN scp_Tabs T INNER JOIN scp_TabModules TM
ON T.TabID = TM.TabID
ON M.ModuleID = TM.ModuleID 
	WHERE 
	(MC.ControlKey IS NULL)
/

/* Message : Created View :scp_VW_PORTALS */
CREATE OR REPLACE FORCE VIEW {databaseOwner}SCP_VW_PORTALS  AS 
SELECT  PortalID, PortalName, CASE 
WHEN SUBSTR(LOWER(LogoFile), 1, 6)='fileid' THEN (
		SELECT  Folder || FileName
		 FROM csws_dbo.SCP_Files 
	WHERE 'FileID=' || TO_CHAR(scp_Files.FileID) = LogoFile  )
ELSE LogoFile 
END LogoFile, FooterText, ExpiryDate, UserRegistration, BannerAdvertising, AdministratorId, Currency, HostFee, HostSpace, PageQuota, UserQuota, AdministratorRoleId, PowerUserRoleId, RegisteredRoleId, Description, KeyWords, CASE 
WHEN SUBSTR(LOWER(BackgroundFile), 1, 6)='fileid' THEN (
		SELECT  Folder || FileName
		 FROM csws_dbo.SCP_Files 
	WHERE 'FileID=' || TO_CHAR(scp_Files.FileID) = BackgroundFile  )
ELSE BackgroundFile 
END BackgroundFile, GUID, PaymentProcessor, ProcessorUserId, ProcessorPassword, SiteLogHistory, Email, DefaultLanguage, TimezoneOffset, AdminTabId, HomeDirectory, SplashTabId, HomeTabId, LoginTabId, UserTabId, (
		SELECT  TabID
		 FROM csws_dbo.SCP_Tabs 
	WHERE 
	(PortalID IS NULL) 
	 AND 
	(ParentId IS NULL)  ) SuperTabId, (
		SELECT  RoleName
		 FROM csws_dbo.SCP_Roles 
	WHERE 
	(RoleID = P.AdministratorRoleId)  ) AdministratorRoleName,  (
		SELECT  RoleName
		 FROM csws_dbo.SCP_Roles 
	WHERE 
	(RoleID = P.PowerUserRoleId)  ) PowerUserRoleName, (
		SELECT  RoleName
		 FROM csws_dbo.SCP_Roles 
	WHERE 
	(RoleID = P.RegisteredRoleId)  ) RegisteredRoleName, P.AdminAccountId,
(SELECT AccountNumber FROM csws_dbo.SCP_AccountNumbers WHERE AccountId = P.AdminAccountId) AdminAccountNumber
 FROM csws_dbo.SCP_Portals P LEFT JOIN scp_Users U
ON P.AdministratorId = U.UserID
/

/* Message : Created View :scp_VW_TABPERMISSIONS */
CREATE OR REPLACE FORCE VIEW {databaseOwner}SCP_VW_TABPERMISSIONS  AS 
SELECT  TP.TabPermissionID, TP.TabID, P.PermissionID, TP.RoleID, CASE TP.RoleID
WHEN -1 THEN 'All Users'
WHEN -2 THEN 'Superuser'
WHEN -3 THEN 'Unauthenticated Users'
ELSE TO_CHAR(R.RoleName)
END RoleName, TP.AllowAccess, P.PermissionCode, P.ModuleDefID, P.PermissionKey, P.PermissionName, T.PortalId
 FROM {databaseOwner}SCP_TabPermission TP INNER JOIN scp_Tabs T
ON TP.TabID = T.TabID LEFT JOIN scp_Permission P
ON TP.PermissionID = P.PermissionID LEFT JOIN scp_Roles R
ON TP.RoleID = R.RoleID
/

/* Message : Created View :scp_VW_TABS */
CREATE OR REPLACE FORCE VIEW {databaseOwner}SCP_VW_TABS  AS 
SELECT  T.TabID, T.TabOrder, T.PortalID, T.TabName, T.IsVisible, T.ParentId, T."Level", CASE 
WHEN SUBSTR(LOWER(T.IconFile), 1, 6)='fileid' THEN (
		SELECT  Folder || FileName
		 FROM {databaseOwner}SCP_Files 
	WHERE 'FileID=' || TO_CHAR(scp_Files.FileID) = T.IconFile  )
ELSE T.IconFile 
END IconFile, T.DisableLink, T.Title, T.Description, T.KeyWords, T.IsDeleted, T.SkinSrc, T.ContainerSrc, T.TabPath, T.StartDate, T.EndDate, T.URL, CASE 
WHEN  EXISTS (
		SELECT  1
		 FROM {databaseOwner}SCP_Tabs T2 
	WHERE T2.ParentId = T.TabId  ) THEN 'true'
ELSE 'false' 
END HasChildren, T.RefreshInterval, T.PageHeadText
 FROM {databaseOwner}SCP_Tabs T
/

/* Message : Created View :scp_VW_USERS */
CREATE OR REPLACE FORCE VIEW {databaseOwner}SCP_VW_USERS  AS 
SELECT U.USERID, UP.PORTALID, U.USERNAME, U.FIRSTNAME, U.LASTNAME, U.DISPLAYNAME, U.ISSUPERUSER, 
	U.EMAIL, U.AFFILIATEID, U.UPDATEPASSWORD, UP.AUTHORISED, AN.ACCOUNTNUMBER 
	FROM (SCP_USERS U LEFT OUTER JOIN SCP_USERPORTALS UP ON U.USERID = UP.USERID) 
	LEFT OUTER JOIN SCP_ACCOUNTNUMBERS AN ON U.ACCOUNTID = AN.ACCOUNTID
/

/* End Views SharpContent */
