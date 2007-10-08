/****** Object:  View [dbo].[dnn_vw_ModulePermissions]    Script Date: 10/05/2007 20:57:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[dnn_vw_ModulePermissions]
AS
SELECT     
	MP.ModulePermissionID, 
	MP.ModuleID, 
	P.PermissionID, 
	MP.RoleID, 
    CASE MP.RoleID WHEN - 1 THEN 'All Users' WHEN - 2 THEN 'Superuser' WHEN - 3 THEN 'Unauthenticated Users' ELSE R.RoleName END AS 'RoleName',
    MP.AllowAccess, 
    P.PermissionCode, 
    P.ModuleDefID, 
    P.PermissionKey, 
    P.PermissionName 
FROM dnn_ModulePermission AS MP 
	LEFT OUTER JOIN dnn_Permission AS P ON MP.PermissionID = P.PermissionID 
	LEFT OUTER JOIN dnn_Roles AS R ON MP.RoleID = R.RoleID
GO
/****** Object:  View [dbo].[dnn_vw_Portals]    Script Date: 10/05/2007 20:57:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[dnn_vw_Portals]
AS
SELECT     
	PortalID, 
	PortalName, 
	CASE WHEN LEFT(LOWER(LogoFile), 6) = 'fileid' 
		THEN
			(SELECT Folder + FileName  
				FROM dnn_Files 
				WHERE 'fileid=' + convert(varchar,dnn_Files.FileID) = LogoFile
			) 
		ELSE 
			LogoFile  
		END 
	AS LogoFile,
	FooterText, 
	ExpiryDate, 
	UserRegistration, 
	BannerAdvertising, 
	AdministratorId, 
	Currency, 
	HostFee, 
	HostSpace, 
	PageQuota, 
	UserQuota, 
	AdministratorRoleId, 
	RegisteredRoleId, 
	Description, 
	KeyWords, 
	CASE WHEN LEFT(LOWER(BackgroundFile), 6) = 'fileid' 
		THEN
			(SELECT Folder + FileName  
				FROM dnn_Files 
				WHERE 'fileid=' + convert(varchar,dnn_Files.FileID) = BackgroundFile
			) 
		ELSE 
			BackgroundFile  
		END 
	AS BackgroundFile,
    GUID, 
    PaymentProcessor, 
    ProcessorUserId, 
    ProcessorPassword, 
    SiteLogHistory,
    Email, 
    DefaultLanguage, 
    TimezoneOffset, 
    AdminTabId, 
    HomeDirectory, 
    SplashTabId, 
    HomeTabId, 
	LoginTabId, 
	UserTabId,
    (SELECT TabID FROM dnn_Tabs WHERE (PortalID IS NULL) AND (ParentId IS NULL)) AS SuperTabId,
	(SELECT RoleName FROM dnn_Roles WHERE (RoleID = P.AdministratorRoleId)) AS AdministratorRoleName,
	(SELECT RoleName FROM dnn_Roles WHERE (RoleID = P.RegisteredRoleId)) AS RegisteredRoleName
FROM dnn_Portals AS P
LEFT OUTER JOIN dnn_Users AS U ON P.AdministratorId = U.UserID
GO
/****** Object:  View [dbo].[dnn_vw_FolderPermissions]    Script Date: 10/05/2007 20:57:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[dnn_vw_FolderPermissions]
AS
SELECT     
	FP.FolderPermissionID, 
	F.FolderID, 
	F.FolderPath, 
	P.PermissionID, 
	FP.RoleID, 
	CASE FP.RoleID WHEN - 1 THEN 'All Users' WHEN - 2 THEN 'Superuser' WHEN - 3 THEN 'Unauthenticated Users' ELSE R.RoleName END AS 'RoleName',
	FP.AllowAccess, 
	P.PermissionCode, 
	P.PermissionKey, 
	P.PermissionName, 
	F.PortalID
FROM dnn_FolderPermission AS FP 
	LEFT OUTER JOIN dnn_Folders AS F ON FP.FolderID = F.FolderID 
	LEFT OUTER JOIN dnn_Permission AS P ON FP.PermissionID = P.PermissionID 
	LEFT OUTER JOIN dnn_Roles AS R ON FP.RoleID = R.RoleID
GO
/****** Object:  View [dbo].[dnn_vw_TabPermissions]    Script Date: 10/05/2007 20:57:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[dnn_vw_TabPermissions]
AS
SELECT     
	TP.TabPermissionID, 
	TP.TabID, 
	P.PermissionID, 
	TP.RoleID, 
    CASE TP.RoleID WHEN - 1 THEN 'All Users' WHEN - 2 THEN 'Superuser' WHEN - 3 THEN 'Unauthenticated Users' ELSE R.RoleName END AS 'RoleName',
    TP.AllowAccess, 
    P.PermissionCode, 
    P.ModuleDefID, 
    P.PermissionKey, 
    P.PermissionName,
    T.PortalId
FROM dnn_TabPermission AS TP 
	INNER JOIN dnn_Tabs AS T ON TP.TabID = T.TabID	
	LEFT OUTER JOIN dnn_Permission AS P ON TP.PermissionID = P.PermissionID 
	LEFT OUTER JOIN dnn_Roles AS R ON TP.RoleID = R.RoleID
GO
/****** Object:  View [dbo].[dnn_vw_Modules]    Script Date: 10/05/2007 20:57:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[dnn_vw_Modules]
AS
SELECT	
	    M.PortalID,
	    TM.TabId,
        TM.TabModuleId,
	    M.ModuleID,
	    M.ModuleDefID,
        TM.ModuleOrder,
        TM.PaneName,
        M.ModuleTitle,
        TM.CacheTime,
        TM.Alignment,
        TM.Color,
        TM.Border,
		CASE WHEN LEFT(LOWER(TM.IconFile), 6) = 'fileid' 
			THEN
				(SELECT Folder + FileName  
					FROM dnn_Files 
					WHERE 'fileid=' + convert(varchar,dnn_Files.FileID) = TM.IconFile
				) 
			ELSE 
				TM.IconFile  
			END 
		AS IconFile,
       M.AllTabs,
       TM.Visibility,
       M.IsDeleted,
       M.Header,
       M.Footer,
       M.StartDate,
       M.EndDate,
       TM.ContainerSrc,
       TM.DisplayTitle,
       TM.DisplayPrint,
       TM.DisplaySyndicate,
       M.InheritViewPermissions,
       DM.*,
       MC.ModuleControlId,
       MC.ControlSrc,
       MC.ControlType,
       MC.ControlTitle,
       MC.HelpURL
FROM   dnn_ModuleDefinitions AS MD 
	INNER JOIN dnn_Modules AS M ON MD.ModuleDefID = M.ModuleDefID 
	INNER JOIN dnn_DesktopModules AS DM ON MD.DesktopModuleID = DM.DesktopModuleID 
	INNER JOIN dnn_ModuleControls AS MC ON MD.ModuleDefID = MC.ModuleDefID 
	LEFT OUTER JOIN dnn_Tabs AS T 
		INNER JOIN dnn_TabModules AS TM ON T.TabID = TM.TabID 
	ON M.ModuleID = TM.ModuleID
WHERE     (MC.ControlKey IS NULL)
GO
/****** Object:  View [dbo].[dnn_vw_Users]    Script Date: 10/05/2007 20:57:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[dnn_vw_Users]
AS
SELECT 
	U.UserId,
    UP.PortalId,
    U.Username,
    U.FirstName,
    U.LastName,
    U.DisplayName,
	U.IsSuperUser,
	U.Email,
    U.AffiliateId,
    U.UpdatePassword,
    UP.Authorised
FROM dnn_Users U
	LEFT OUTER JOIN dnn_UserPortals UP On U.UserId = UP.UserId
GO
/****** Object:  View [dbo].[dnn_vw_Tabs]    Script Date: 10/05/2007 20:57:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[dnn_vw_Tabs]
AS
SELECT     
	T.TabID, 
	T.TabOrder, 
	T.PortalID, 
	T.TabName, 
	T.IsVisible, 
	T.ParentId, 
	T.[Level],
	CASE WHEN LEFT(LOWER(T.IconFile), 6) = 'fileid' 
		THEN
			(SELECT Folder + FileName  
				FROM dnn_Files 
				WHERE 'fileid=' + convert(varchar,dnn_Files.FileID) = T.IconFile
			) 
		ELSE 
			T.IconFile  
		END 
	AS IconFile,
	T.DisableLink, 
	T.Title, 
	T.Description, 
	T.KeyWords, 
	T.IsDeleted, 
	T.SkinSrc, 
    T.ContainerSrc, 
    T.TabPath, 
    T.StartDate, 
    T.EndDate, 
	T.URL, 
    CASE WHEN EXISTS (SELECT 1 FROM dnn_Tabs T2 WHERE T2.ParentId = T .TabId) THEN 'true' ELSE 'false' END AS 'HasChildren', 
    T.RefreshInterval, 
    T.PageHeadText
FROM dbo.dnn_Tabs AS T
GO
