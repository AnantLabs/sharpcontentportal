/****** Object:  StoredProcedure [dbo].[dnn_GetPasswordQuestions]    Script Date: 10/07/2007 08:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPasswordQuestions] 
	@locale nvarchar(10)
AS

DECLARE @count int

SELECT @count = COUNT(*) FROM dnn_Questions WHERE LOWER([Locale]) = LOWER(@locale)
  
IF (@count = 0)
	BEGIN
		SELECT * FROM dnn_Questions WHERE LOWER([Locale]) = 'en-us' OR [locale] IS NULL
	END
ELSE
	BEGIN
		SELECT * FROM dnn_Questions WHERE LOWER([Locale]) = LOWER(@locale)
	END
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetVendorsByEmail]    Script Date: 10/05/2007 21:22:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetVendorsByEmail]
	@Filter nvarchar(50),
	@PortalID int,
	@PageSize int,
	@PageIndex int
AS

	DECLARE @PageLowerBound int
	DECLARE @PageUpperBound int
	-- Set the page bounds
	SET @PageLowerBound = @PageSize * @PageIndex
	SET @PageUpperBound = @PageLowerBound + @PageSize + 1

	CREATE TABLE #PageIndex 
	(
		IndexID		int IDENTITY (1, 1) NOT NULL,
		VendorId	int
	)

	INSERT INTO #PageIndex (VendorId)
	SELECT VendorId
	FROM dnn_Vendors
	WHERE ( (Email = @Filter) AND ((PortalId = @PortalId) or (@PortalId is null and PortalId is null)) )
	ORDER BY VendorId DESC


	SELECT COUNT(*) as TotalRecords
	FROM #PageIndex


	SELECT dnn_Vendors.*,
       		'Banners' = ( select count(*) from dnn_Banners where dnn_Banners.VendorId = dnn_Vendors.VendorId )
	FROM dnn_Vendors
	INNER JOIN #PageIndex PageIndex
		ON dnn_Vendors.VendorId = PageIndex.VendorId
	WHERE ( (PageIndex.IndexID > @PageLowerBound) OR @PageLowerBound is null )	
		AND ( (PageIndex.IndexID < @PageUpperBound) OR @PageUpperBound is null )	
	ORDER BY
		PageIndex.IndexID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetVendorsByName]    Script Date: 10/05/2007 21:22:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetVendorsByName]
	@Filter nvarchar(50),
	@PortalID int,
	@PageSize int,
	@PageIndex int
AS

	DECLARE @PageLowerBound int
	DECLARE @PageUpperBound int
	-- Set the page bounds
	SET @PageLowerBound = @PageSize * @PageIndex
	SET @PageUpperBound = @PageLowerBound + @PageSize + 1

	CREATE TABLE #PageIndex 
	(
		IndexID		int IDENTITY (1, 1) NOT NULL,
		VendorId	int
	)

	INSERT INTO #PageIndex (VendorId)
	SELECT VendorId
	FROM dnn_Vendors
	WHERE ( (VendorName like @Filter + '%') AND ((PortalId = @PortalId) or (@PortalId is null and PortalId is null)) )
	ORDER BY VendorId DESC


	SELECT COUNT(*) as TotalRecords
	FROM #PageIndex


	SELECT dnn_Vendors.*,
       		'Banners' = ( select count(*) from dnn_Banners where dnn_Banners.VendorId = dnn_Vendors.VendorId )
	FROM dnn_Vendors
	INNER JOIN #PageIndex PageIndex
		ON dnn_Vendors.VendorId = PageIndex.VendorId
	WHERE ( (PageIndex.IndexID > @PageLowerBound) OR @PageLowerBound is null )	
		AND ( (PageIndex.IndexID < @PageUpperBound) OR @PageUpperBound is null )	
	ORDER BY
		PageIndex.IndexID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetVendors]    Script Date: 10/05/2007 21:22:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetVendors]
	@PortalID int,
	@UnAuthorized bit,
	@PageSize int,
	@PageIndex int
AS

	DECLARE @PageLowerBound int
	DECLARE @PageUpperBound int
	-- Set the page bounds
	SET @PageLowerBound = @PageSize * @PageIndex
	SET @PageUpperBound = @PageLowerBound + @PageSize + 1

	CREATE TABLE #PageIndex 
	(
		IndexID		int IDENTITY (1, 1) NOT NULL,
		VendorId	int
	)

	INSERT INTO #PageIndex (VendorId)
	SELECT VendorId
	FROM dnn_Vendors
	WHERE ( ((Authorized = 0 AND @UnAuthorized = 1) OR @UnAuthorized = 0 ) AND ((PortalId = @PortalId) or (@PortalId is null and PortalId is null)) )
	ORDER BY VendorId DESC


	SELECT COUNT(*) as TotalRecords
	FROM #PageIndex


	SELECT dnn_Vendors.*,
       		'Banners' = ( select count(*) from dnn_Banners where dnn_Banners.VendorId = dnn_Vendors.VendorId )
	FROM dnn_Vendors
	INNER JOIN #PageIndex PageIndex
		ON dnn_Vendors.VendorId = PageIndex.VendorId
	WHERE ( (PageIndex.IndexID > @PageLowerBound) OR @PageLowerBound is null )	
		AND ( (PageIndex.IndexID < @PageUpperBound) OR @PageUpperBound is null )	
	ORDER BY
		PageIndex.IndexID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetEventLog]    Script Date: 10/05/2007 21:21:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetEventLog]
	@PortalID int,
	@LogTypeKey nvarchar(35),
	@PageSize int,
	@PageIndex int
AS

	DECLARE @PageLowerBound int
	DECLARE @PageUpperBound int
	-- Set the page bounds
	SET @PageLowerBound = @PageSize * @PageIndex
	SET @PageUpperBound = @PageLowerBound + @PageSize + 1

	CREATE TABLE #PageIndex 
	(
		IndexID		int IDENTITY (1, 1) NOT NULL,
		LogGUID	varchar(36) COLLATE database_default
	)

	INSERT INTO #PageIndex (LogGUID)
	SELECT dnn_EventLog.LogGUID
	FROM dnn_EventLog
	INNER JOIN dnn_EventLogConfig
		ON dnn_EventLog.LogConfigID = dnn_EventLogConfig.ID
	WHERE (LogPortalID = @PortalID or @PortalID IS NULL)
		AND (dnn_EventLog.LogTypeKey = @LogTypeKey or @LogTypeKey IS NULL)
	ORDER BY LogCreateDate DESC


	SELECT dnn_EventLog.*
	FROM dnn_EventLog
	INNER JOIN dnn_EventLogConfig
		ON dnn_EventLog.LogConfigID = dnn_EventLogConfig.ID
	INNER JOIN #PageIndex PageIndex
		ON dnn_EventLog.LogGUID = PageIndex.LogGUID
	WHERE PageIndex.IndexID			> @PageLowerBound	
		AND	PageIndex.IndexID			< @PageUpperBound	
	ORDER BY
		PageIndex.IndexID	

	SELECT COUNT(*) as TotalRecords
	FROM #PageIndex
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUsersByUserName]    Script Date: 10/05/2007 21:22:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetUsersByUserName]
    @PortalId			int,
    @UserNameToMatch	nvarchar(256),
    @PageIndex			int,
    @PageSize			int
AS
BEGIN
    -- Set the page bounds
    DECLARE @PageLowerBound INT
    DECLARE @PageUpperBound INT
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId int
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
        SELECT UserId FROM	dnn_vw_Users 
        WHERE  Username LIKE @UserNameToMatch
			AND ( PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
	    ORDER BY UserName

    SELECT  *
    FROM	dnn_vw_Users u, 
			#PageIndexForUsers p
    WHERE  u.UserId = p.UserId
			AND ( PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
			AND p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY u.UserName

    SELECT  TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers
END
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUsersByProfileProperty]    Script Date: 10/05/2007 21:22:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetUsersByProfileProperty]
    @PortalId		int,
    @PropertyName   nvarchar(256),
    @PropertyValue  nvarchar(256),
    @PageIndex      int,
    @PageSize       int
AS
BEGIN
    -- Set the page bounds
    DECLARE @PageLowerBound INT
    DECLARE @PageUpperBound INT
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId int
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
        SELECT U.UserId 
		FROM   dnn_ProfilePropertyDefinition P
			INNER JOIN dnn_UserProfile UP ON P.PropertyDefinitionID = UP.PropertyDefinitionID 
			INNER JOIN dnn_Users U ON UP.UserID = U.UserID
		WHERE (PropertyName = @PropertyName) AND (PropertyValue LIKE @PropertyValue OR PropertyText LIKE @PropertyValue )
			AND (P.Portalid = @PortalId OR (P.PortalId Is Null AND @PortalId is null ))
		ORDER BY U.DisplayName

    SELECT  *
    FROM	dnn_vw_Users u, 
			#PageIndexForUsers p
    WHERE  u.UserId = p.UserId
			AND ( PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
			AND p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
		ORDER BY U.DisplayName

    SELECT  TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers

END
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUsersByEmail]    Script Date: 10/05/2007 21:22:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetUsersByEmail]
    @PortalId		int,
    @EmailToMatch   nvarchar(256),
    @PageIndex      int,
    @PageSize       int
AS
BEGIN
    -- Set the page bounds
    DECLARE @PageLowerBound INT
    DECLARE @PageUpperBound INT
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId int
    )

    -- Insert into our temp table
    IF( @EmailToMatch IS NULL )
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT UserId FROM	dnn_vw_Users 
            WHERE  Email IS NULL
				AND ( PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
            ORDER BY Email
    ELSE
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT UserId FROM	dnn_vw_Users 
            WHERE  LOWER(Email) LIKE LOWER(@EmailToMatch)
				AND ( PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
            ORDER BY Email

    SELECT  *
    FROM	dnn_vw_Users u, 
			#PageIndexForUsers p
    WHERE  u.UserId = p.UserId
			AND ( PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
			AND p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY LOWER(u.Email)

    SELECT  TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers

END
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetAllUsers]    Script Date: 10/05/2007 21:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetAllUsers]

    @PortalId		int,
    @PageIndex      int,
    @PageSize       int
AS
BEGIN
    -- Set the page bounds
    DECLARE @PageLowerBound INT
    DECLARE @PageUpperBound INT
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId int
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
        SELECT UserId FROM	dnn_vw_Users 
		WHERE (PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
		ORDER BY FirstName + ' ' + LastName

    SELECT  *
    FROM	dnn_vw_Users u, 
			#PageIndexForUsers p
    WHERE  u.UserId = p.UserId 
		AND (PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
        AND p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
	ORDER BY FirstName + ' ' + LastName

    SELECT  TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers

END
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortalsByName]    Script Date: 10/05/2007 21:22:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPortalsByName]
    @NameToMatch	nvarchar(256),
    @PageIndex			int,
    @PageSize			int
AS
BEGIN
    -- Set the page bounds
    DECLARE @PageLowerBound INT
    DECLARE @PageUpperBound INT
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForPortals
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        PortalId int
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForPortals (PortalId)
        SELECT PortalId FROM	dnn_vw_Portals
        WHERE  PortalName LIKE @NameToMatch
	    ORDER BY PortalName

    SELECT  *
    FROM	dnn_vw_Portals p, 
			#PageIndexForPortals i
    WHERE  p.PortalId = i.PortalId
			AND i.IndexId >= @PageLowerBound AND i.IndexId <= @PageUpperBound
    ORDER BY p.PortalName

    SELECT  TotalRecords = COUNT(*)
    FROM    #PageIndexForPortals
END
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetCurrencies]    Script Date: 10/05/2007 21:21:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetCurrencies]

as

select Code,
       Description
from dnn_CodeCurrency
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTables]    Script Date: 10/05/2007 21:22:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetTables]

as

/* Be carefull when changing this procedure as the GetSearchTables() function 
   in SearchDB.vb is only looking at the first column (to support databases that cannot return 
   a TableName column name (like MySQL))
*/

select 'TableName' = [name]
from   sysobjects 
where  xtype = 'U'
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUsersByRolename]    Script Date: 10/05/2007 21:22:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetUsersByRolename]

	@PortalId	int,
	@Rolename	nvarchar(50)

AS

SELECT     
		U.UserID, 
		UP.PortalId, 
		U.Username, 
		U.FirstName, 
		U.LastName, 
		U.DisplayName, 
		U.IsSuperUser, 
		U.Email, 
		U.AffiliateId, 
		U.UpdatePassword
	FROM dnn_UserPortals AS UP 
			RIGHT OUTER JOIN dnn_UserRoles  UR 
			INNER JOIN dnn_Roles R ON UR.RoleID = R.RoleID 
			RIGHT OUTER JOIN dnn_Users AS U ON UR.UserID = U.UserID 
		ON UP.UserId = U.UserID	
	WHERE ( UP.PortalId = @PortalId OR @PortalId IS Null )
		AND (R.RoleName = @Rolename)
		AND (R.PortalId = @PortalId OR @PortalId IS Null )
	ORDER BY U.FirstName + ' ' + U.LastName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetRolesByUser]    Script Date: 10/05/2007 21:22:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetRolesByUser]
    
	@UserId        int,
	@PortalId      int

AS

SELECT dnn_Roles.RoleName,
       dnn_Roles.RoleId
	FROM dnn_UserRoles
		INNER JOIN dnn_Users on dnn_UserRoles.UserId = dnn_Users.UserId
		INNER JOIN dnn_Roles on dnn_UserRoles.RoleId = dnn_Roles.RoleId
	WHERE  dnn_Users.UserId = @UserId
		AND    dnn_Roles.PortalId = @PortalId
		AND    (EffectiveDate <= getdate() or EffectiveDate is null)
		AND    (ExpiryDate >= getdate() or ExpiryDate is null)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetFoldersByUser]    Script Date: 10/05/2007 21:21:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetFoldersByUser]
	@PortalID int,
	@UserID int,
	@IncludeSecure bit,
	@IncludeDatabase bit,
	@AllowAccess bit,
	@PermissionKeys nvarchar(200)

AS
SELECT DISTINCT
	F.FolderID,
	F.PortalID,
	F.FolderPath,
	F.StorageLocation,
	F.IsProtected,
	F.IsCached,
	F.LastUpdated
FROM dbo.dnn_Roles R
	INNER JOIN dbo.dnn_UserRoles UR ON R.RoleID = UR.RoleID 
	RIGHT OUTER JOIN dbo.dnn_Folders F
		INNER JOIN dbo.dnn_FolderPermission FP ON F.FolderID = FP.FolderID 
		INNER JOIN dbo.dnn_Permission P ON FP.PermissionID = P.PermissionID 
	ON R.RoleID = FP.RoleID
WHERE (	UR.UserID = @UserID
			OR (FP.RoleID = - 1 AND @UserID IS NOT Null)
			OR (FP.RoleID = - 3)
			)
		AND CHARINDEX(P.PermissionKey, @PermissionKeys) > 0
		AND FP.AllowAccess = @AllowAccess
	AND F.PortalID = @PortalID
	AND (F.StorageLocation = 0 
		OR (F.StorageLocation = 1 AND @IncludeSecure = 1) 
		OR (F.StorageLocation = 2 AND @IncludeDatabase = 1)
	)
ORDER BY F.FolderPath
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortalRoles]    Script Date: 10/05/2007 21:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPortalRoles]

	@PortalId     int

AS

SELECT R.RoleId,
       R.PortalId,
       R.RoleGroupId,
       R.RoleName,
       R.Description,
       'ServiceFee' = case when convert(int,R.ServiceFee) <> 0 then R.ServiceFee else null end,
       'BillingPeriod' = case when convert(int,R.ServiceFee) <> 0 then R.BillingPeriod else null end,
       'BillingFrequency' = case when convert(int,R.ServiceFee) <> 0 then L1.Text else '' end,
       'TrialFee' = case when R.TrialFrequency <> 'N' then R.TrialFee else null end,
       'TrialPeriod' = case when R.TrialFrequency <> 'N' then R.TrialPeriod else null end,
       'TrialFrequency' = case when R.TrialFrequency <> 'N' then L2.Text else '' end,
       'IsPublic' = case when R.IsPublic = 1 then 'True' else 'False' end,
       'AutoAssignment' = case when R.AutoAssignment = 1 then 'True' else 'False' end,
       RSVPCode,
       IconFile
FROM dbo.dnn_Roles R
	LEFT OUTER JOIN dbo.dnn_Lists L1 on R.BillingFrequency = L1.Value
	LEFT OUTER JOIN dbo.dnn_Lists L2 on R.TrialFrequency = L2.Value
WHERE  PortalId = @PortalId
	OR     PortalId is null
ORDER BY R.RoleName
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddRole]    Script Date: 10/05/2007 21:21:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddRole]

	@PortalId         int,
	@RoleGroupId      int,
	@RoleName         nvarchar(50),
	@Description      nvarchar(1000),
	@ServiceFee       money,
	@BillingPeriod    int,
	@BillingFrequency char(1),
	@TrialFee         money,
	@TrialPeriod      int,
	@TrialFrequency   char(1),
	@IsPublic         bit,
	@AutoAssignment   bit,
	@RSVPCode         nvarchar(50),
	@IconFile         nvarchar(100)

AS

INSERT INTO dbo.dnn_Roles (
  PortalId,
  RoleGroupId,
  RoleName,
  Description,
  ServiceFee,
  BillingPeriod,
  BillingFrequency,
  TrialFee,
  TrialPeriod,
  TrialFrequency,
  IsPublic,
  AutoAssignment,
  RSVPCode,
  IconFile
)
VALUES (
  @PortalId,
  @RoleGroupId,
  @RoleName,
  @Description,
  @ServiceFee,
  @BillingPeriod,
  @BillingFrequency,
  @TrialFee,
  @TrialPeriod,
  @TrialFrequency,
  @IsPublic,
  @AutoAssignment,
  @RSVPCode,
  @IconFile
)

SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetRolesByGroup]    Script Date: 10/05/2007 21:22:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetRolesByGroup]

	@RoleGroupId     int,
	@PortalId		 int

AS

SELECT R.RoleId,
       R.PortalId,
       R.RoleGroupId,
       R.RoleName,
       R.Description,
       'ServiceFee' = case when convert(int,R.ServiceFee) <> 0 then R.ServiceFee else null end,
       'BillingPeriod' = case when convert(int,R.ServiceFee) <> 0 then R.BillingPeriod else null end,
       'BillingFrequency' = case when convert(int,R.ServiceFee) <> 0 then L1.Text else '' end,
       'TrialFee' = case when R.TrialFrequency <> 'N' then R.TrialFee else null end,
       'TrialPeriod' = case when R.TrialFrequency <> 'N' then R.TrialPeriod else null end,
       'TrialFrequency' = case when R.TrialFrequency <> 'N' then L2.Text else '' end,
       'IsPublic' = case when R.IsPublic = 1 then 'True' else 'False' end,
       'AutoAssignment' = case when R.AutoAssignment = 1 then 'True' else 'False' end,
       R.RSVPCode,
       R.IconFile
FROM dbo.dnn_Roles R
	LEFT OUTER JOIN dbo.dnn_Lists L1 on R.BillingFrequency = L1.Value
	LEFT OUTER JOIN dbo.dnn_Lists L2 on R.TrialFrequency = L2.Value
WHERE  (RoleGroupId = @RoleGroupId OR (RoleGroupId IS NULL AND @RoleGroupId IS NULL))
	AND PortalId = @PortalId
ORDER BY R.RoleName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetRoles]    Script Date: 10/05/2007 21:22:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetRoles]

as

select *
from   dbo.dnn_Roles
GO
/****** Object:  StoredProcedure [dbo].[dnn_IsUserInRole]    Script Date: 10/05/2007 21:22:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_IsUserInRole]
    
@UserId        int,
@RoleId        int,
@PortalId      int

as

select dnn_UserRoles.UserId,
       dnn_UserRoles.RoleId
from dnn_UserRoles
inner join dnn_Roles on dnn_UserRoles.RoleId = dnn_Roles.RoleId
where  dnn_UserRoles.UserId = @UserId
and    dnn_UserRoles.RoleId = @RoleId
and    dnn_Roles.PortalId = @PortalId
and    (dnn_UserRoles.ExpiryDate >= getdate() or dnn_UserRoles.ExpiryDate is null)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUserRole]    Script Date: 10/05/2007 21:22:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetUserRole]

	@PortalId int, 
	@UserId int, 
	@RoleId int

AS
SELECT	r.*, 
        ur.UserRoleID, 
        ur.UserID, 
        ur.EffectiveDate, 
        ur.ExpiryDate, 
        ur.IsTrialUsed
	FROM	dnn_UserRoles ur
		INNER JOIN dnn_UserPortals up on ur.UserId = up.UserId
		INNER JOIN dnn_Roles r on r.RoleID = ur.RoleID
	WHERE   up.UserId = @UserId
		AND     up.PortalId = @PortalId
		AND     ur.RoleId = @RoleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetRole]    Script Date: 10/05/2007 21:22:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetRole]

	@RoleId   int,
	@PortalId int

AS

SELECT RoleId,
       PortalId,
       RoleGroupId,
       RoleName,
       Description,
       ServiceFee,
       BillingPeriod,
       BillingFrequency,
       TrialFee,
       TrialPeriod,
       TrialFrequency,
       IsPublic,
       AutoAssignment,
       RSVPCode,
       IconFile
FROM   dnn_Roles
WHERE  RoleId = @RoleId
	AND    PortalId = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetRoleByName]    Script Date: 10/05/2007 21:22:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetRoleByName]

	@PortalId int,
	@RoleName nvarchar(50)

AS

SELECT RoleId,
       PortalId,
       RoleGroupId,
       RoleName,
       Description,
       ServiceFee,
       BillingPeriod,
       BillingFrequency,
       TrialFee,
       TrialPeriod,
       TrialFrequency,
       IsPublic,
       AutoAssignment,
       RSVPCode,
       IconFile
FROM   dnn_Roles
WHERE  PortalId = @PortalId 
	AND RoleName = @RoleName
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteRole]    Script Date: 10/05/2007 21:21:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_DeleteRole]

@RoleId int

as

delete 
from dnn_FolderPermission
where  RoleId = @RoleId

delete 
from dnn_ModulePermission
where  RoleId = @RoleId

delete 
from dnn_TabPermission
where  RoleId = @RoleId

delete 
from dnn_Roles
where  RoleId = @RoleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUserRoles]    Script Date: 10/05/2007 21:22:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetUserRoles]
    
@PortalId  int,
@UserId    int

AS

SELECT     
	UR.UserRoleID, 
	U.UserID, 
	U.DisplayName, 
	U.Email, 
	UR.EffectiveDate, 
    UR.ExpiryDate, 
	UR.IsTrialUsed
FROM dnn_UserRoles UR
	INNER JOIN dnn_Users U ON UR.UserID = U.UserID 
	INNER JOIN dnn_Roles R ON UR.RoleID = R.RoleID 
WHERE
	U.UserID = @UserId AND R.PortalID = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTabPermissionsByTabID]    Script Date: 10/05/2007 21:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetTabPermissionsByTabID]
	@TabID int, 
	@PermissionID int
AS

SELECT
	M.[TabPermissionID],
	M.[TabID],
	P.[PermissionID],
	M.[RoleID],
	case M.RoleID
		when -1 then 'All Users'
		when -2 then 'Superuser'		
		when -3 then 'Unauthenticated Users'
		else 	R.RoleName
	end
	'RoleName',
	M.[AllowAccess],
	P.[PermissionCode],
	P.[PermissionKey],
	P.[PermissionName]
FROM
	dbo.dnn_TabPermission M
LEFT JOIN
	dbo.dnn_Permission P
ON	M.PermissionID = P.PermissionID
LEFT JOIN
	dbo.dnn_Roles R
ON	M.RoleID = R.RoleID
WHERE
	(M.[TabID] = @TabID
	OR (M.TabID IS NULL and P.PermissionCode = 'SYSTEM_TAB'))
AND	(P.[PermissionID] = @PermissionID or @PermissionID = -1)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetServices]    Script Date: 10/05/2007 21:22:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetServices]
    
@PortalId  int,
@UserId    int = null

as

select RoleId,
       R.RoleName,
       R.Description,
       'ServiceFee' = case when convert(int,R.ServiceFee) <> 0 then R.ServiceFee else null end,
       'BillingPeriod' = case when convert(int,R.ServiceFee) <> 0 then R.BillingPeriod else null end,
       'BillingFrequency' = case when convert(int,R.ServiceFee) <> 0 then L1.[Text] else '' end,
       'TrialFee' = case when R.TrialFrequency <> 'N' then R.TrialFee else null end,
       'TrialPeriod' = case when R.TrialFrequency <> 'N' then R.TrialPeriod else null end,
       'TrialFrequency' = case when R.TrialFrequency <> 'N' then L2.[Text] else '' end,
       'ExpiryDate' = ( select ExpiryDate from dbo.dnn_UserRoles where dbo.dnn_UserRoles.RoleId = R.RoleId and dbo.dnn_UserRoles.UserId = @UserId ),
       'Subscribed' = ( select UserRoleId from dbo.dnn_UserRoles where dbo.dnn_UserRoles.RoleId = R.RoleId and dbo.dnn_UserRoles.UserId = @UserId )
from dbo.dnn_Roles R
inner join dbo.dnn_Lists L1 on R.BillingFrequency = L1.Value
left outer join dbo.dnn_Lists L2 on R.TrialFrequency = L2.Value
where  R.PortalId = @PortalId
and    R.IsPublic = 1
and L1.ListName='Frequency'
and L2.ListName='Frequency'
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateRole]    Script Date: 10/05/2007 21:22:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateRole]

	@RoleId           int,
	@RoleGroupId      int,
	@Description      nvarchar(1000),
	@ServiceFee       money,
	@BillingPeriod    int,
	@BillingFrequency char(1),
	@TrialFee         money,
	@TrialPeriod      int,
	@TrialFrequency   char(1),
	@IsPublic         bit,
	@AutoAssignment   bit,
	@RSVPCode         nvarchar(50),
	@IconFile         nvarchar(100)

AS

UPDATE dbo.dnn_Roles
SET    RoleGroupId = @RoleGroupId,
       Description = @Description,
       ServiceFee = @ServiceFee,
       BillingPeriod = @BillingPeriod,
       BillingFrequency = @BillingFrequency,
       TrialFee = @TrialFee,
       TrialPeriod = @TrialPeriod,
       TrialFrequency = @TrialFrequency,
       IsPublic = @IsPublic,
       AutoAssignment = @AutoAssignment,
       RSVPCode = @RSVPCode,
       IconFile = @IconFile
WHERE  RoleId = @RoleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUserRolesByUsername]    Script Date: 10/05/2007 21:22:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetUserRolesByUsername]

@PortalId int, 
@Username nvarchar(100), 
@Rolename nvarchar(50)

AS

IF @UserName Is Null
	BEGIN
		SELECT	R.*,        
				U.DisplayName As FullName,
				UR.UserRoleID,
				UR.UserID,
				UR.EffectiveDate,
				UR.ExpiryDate,
				UR.IsTrialUsed
			FROM	dnn_UserRoles UR
				INNER JOIN dnn_Users U ON UR.UserID = U.UserID
				INNER JOIN dnn_Roles R ON R.RoleID = UR.RoleID
			WHERE  R.PortalId = @PortalId
				AND    (R.Rolename = @Rolename or @RoleName is NULL)
	END
ELSE
	BEGIN
		IF @RoleName Is NULL
			BEGIN
				SELECT	R.*,        
						U.DisplayName As FullName,
						UR.UserRoleID,
						UR.UserID,
						UR.EffectiveDate,
						UR.ExpiryDate,
						UR.IsTrialUsed
					FROM	dnn_UserRoles UR
						INNER JOIN dnn_Users U ON UR.UserID = U.UserID
						INNER JOIN dnn_Roles R ON R.RoleID = UR.RoleID
					WHERE  R.PortalId = @PortalId
						AND    (U.Username = @Username or @Username is NULL)
			END
		ELSE
			BEGIN
				SELECT	R.*,        
						U.DisplayName As FullName,
						UR.UserRoleID,
						UR.UserID,
						UR.EffectiveDate,
						UR.ExpiryDate,
						UR.IsTrialUsed
					FROM	dnn_UserRoles UR
						INNER JOIN dnn_Users U ON UR.UserID = U.UserID
						INNER JOIN dnn_Roles R ON R.RoleID = UR.RoleID
					WHERE  R.PortalId = @PortalId
						AND    (R.Rolename = @Rolename or @RoleName is NULL)
						AND    (U.Username = @Username or @Username is NULL)
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddHtmlText]    Script Date: 10/05/2007 21:21:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/** Create Stored Procedures **/

create procedure [dbo].[dnn_AddHtmlText]

	@ModuleId       int,
	@DesktopHtml    ntext,
	@DesktopSummary ntext,
	@UserID         int

as

insert into dnn_HtmlText (
	ModuleId,
	DesktopHtml,
	DesktopSummary,
	CreatedByUser,
	CreatedDate
) 
values (
	@ModuleId,
	@DesktopHtml,
	@DesktopSummary,
	@UserID,
	getdate()
)
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateHtmlText]    Script Date: 10/05/2007 21:22:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateHtmlText]

	@ModuleId       int,
	@DesktopHtml    ntext,
	@DesktopSummary ntext,
	@UserID         int

as

update dnn_HtmlText
set    DesktopHtml    = @DesktopHtml,
       DesktopSummary = @DesktopSummary,
       CreatedByUser  = @UserID,
       CreatedDate    = getdate()
where  ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetHtmlText]    Script Date: 10/05/2007 21:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetHtmlText]

	@ModuleId int

as

select *
from dnn_HtmlText
where  ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetRoleGroup]    Script Date: 10/05/2007 21:22:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetRoleGroup]

	@PortalId		int,
	@RoleGroupId    int
	
AS

SELECT
	RoleGroupId,
	PortalId,
	RoleGroupName,
	Description
FROM dbo.dnn_RoleGroups
WHERE  (RoleGroupId = @RoleGroupId OR RoleGroupId IS NULL AND @RoleGroupId IS NULL)
	AND    PortalId = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateRoleGroup]    Script Date: 10/05/2007 21:22:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateRoleGroup]

	@RoleGroupId      int,
	@RoleGroupName	  nvarchar(50),
	@Description      nvarchar(1000)

AS

UPDATE dbo.dnn_RoleGroups
SET    RoleGroupName = @RoleGroupName,
	   Description = @Description
WHERE  RoleGroupId = @RoleGroupId
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteRoleGroup]    Script Date: 10/05/2007 21:21:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteRoleGroup]

	@RoleGroupId      int
	
AS

DELETE  
FROM dbo.dnn_RoleGroups
WHERE  RoleGroupId = @RoleGroupId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddRoleGroup]    Script Date: 10/05/2007 21:21:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddRoleGroup]

	@PortalId         int,
	@RoleGroupName    nvarchar(50),
	@Description      nvarchar(1000)

AS

INSERT INTO dbo.dnn_RoleGroups (
  PortalId,
  RoleGroupName,
  Description
)
VALUES (
  @PortalId,
  @RoleGroupName,
  @Description
)

SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetRoleGroups]    Script Date: 10/05/2007 21:22:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetRoleGroups]

	@PortalId		int
	
AS

SELECT
	RoleGroupId,
	PortalId,
	RoleGroupName,
	Description
FROM dbo.dnn_RoleGroups
WHERE  PortalId = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetScheduleByTypeFullName]    Script Date: 10/05/2007 21:22:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetScheduleByTypeFullName]
	@TypeFullName varchar(200),
	@Server varchar(150)
AS

	SELECT S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, S.Servers
	FROM dnn_Schedule S
	WHERE S.TypeFullName = @TypeFullName 
	AND (S.Servers LIKE ',%' + @Server + '%,' or S.Servers IS NULL)
	GROUP BY S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, S.Servers
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetScheduleNextTask]    Script Date: 10/05/2007 21:22:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetScheduleNextTask]
	@Server varchar(150)
AS
SELECT TOP 1 S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, SH.NextStart
FROM dnn_Schedule S
LEFT JOIN dnn_ScheduleHistory SH
ON S.ScheduleID = SH.ScheduleID
WHERE ((SH.ScheduleHistoryID = (SELECT TOP 1 S1.ScheduleHistoryID FROM dnn_ScheduleHistory S1 WHERE S1.ScheduleID = S.ScheduleID ORDER BY S1.NextStart DESC)
OR  SH.ScheduleHistoryID IS NULL) AND S.Enabled = 1)
AND (S.Servers LIKE ',%' + @Server + '%,' or S.Servers IS NULL)
GROUP BY S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, SH.NextStart
ORDER BY SH.NextStart ASC
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetScheduleByEvent]    Script Date: 10/05/2007 21:22:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetScheduleByEvent]
@EventName varchar(50),
@Server varchar(150)
AS
SELECT S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled
FROM dbo.dnn_Schedule S
WHERE S.AttachToEvent = @EventName
AND (S.Servers LIKE ',%' + @Server + '%,' or S.Servers IS NULL)
GROUP BY S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateSchedule]    Script Date: 10/05/2007 21:22:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateSchedule]
@ScheduleID int
,@TypeFullName varchar(200)
,@TimeLapse int
,@TimeLapseMeasurement varchar(2)
,@RetryTimeLapse int
,@RetryTimeLapseMeasurement varchar(2)
,@RetainHistoryNum int
,@AttachToEvent varchar(50)
,@CatchUpEnabled bit
,@Enabled bit
,@ObjectDependencies varchar(300)
,@Servers varchar(150)
AS
UPDATE dbo.dnn_Schedule
SET TypeFullName = @TypeFullName
,TimeLapse = @TimeLapse
,TimeLapseMeasurement = @TimeLapseMeasurement
,RetryTimeLapse = @RetryTimeLapse
,RetryTimeLapseMeasurement = @RetryTimeLapseMeasurement
,RetainHistoryNum = @RetainHistoryNum
,AttachToEvent = @AttachToEvent
,CatchUpEnabled = @CatchUpEnabled
,Enabled = @Enabled
,ObjectDependencies = @ObjectDependencies
,Servers = @Servers
WHERE ScheduleID = @ScheduleID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSchedule]    Script Date: 10/05/2007 21:22:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSchedule]
	@Server varchar(150)
AS
SELECT S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, SH.NextStart, S.Servers
FROM dnn_Schedule S
LEFT JOIN dnn_ScheduleHistory SH
ON S.ScheduleID = SH.ScheduleID
WHERE (SH.ScheduleHistoryID = (SELECT TOP 1 S1.ScheduleHistoryID FROM dnn_ScheduleHistory S1 WHERE S1.ScheduleID = S.ScheduleID ORDER BY S1.NextStart DESC)
OR  SH.ScheduleHistoryID IS NULL)
AND (@Server IS NULL or S.Servers LIKE ',%' + @Server + '%,' or S.Servers IS NULL)
GROUP BY S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, SH.NextStart, S.Servers
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetScheduleByScheduleID]    Script Date: 10/05/2007 21:22:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetScheduleByScheduleID]
@ScheduleID int
AS
SELECT S.*
FROM dbo.dnn_Schedule S
WHERE S.ScheduleID = @ScheduleID
GO
/****** Object:  StoredProcedure [dbo].[dnn_PurgeScheduleHistory]    Script Date: 10/05/2007 21:22:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_PurgeScheduleHistory]
AS
DELETE FROM dbo.dnn_ScheduleHistory
FROM dbo.dnn_Schedule s
WHERE
    (
    SELECT COUNT(*)
    FROM dbo.dnn_ScheduleHistory sh
    WHERE
        sh.ScheduleID = dbo.dnn_ScheduleHistory.ScheduleID AND
        sh.ScheduleID = s.ScheduleID AND
        sh.StartDate >= dbo.dnn_ScheduleHistory.StartDate
    ) > s.RetainHistoryNum
AND RetainHistoryNum<>-1
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddSchedule]    Script Date: 10/05/2007 21:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddSchedule]
@TypeFullName varchar(200)
,@TimeLapse int
,@TimeLapseMeasurement varchar(2)
,@RetryTimeLapse int
,@RetryTimeLapseMeasurement varchar(2)
,@RetainHistoryNum int
,@AttachToEvent varchar(50)
,@CatchUpEnabled bit
,@Enabled bit
,@ObjectDependencies varchar(300)
,@Servers varchar(150)
AS
INSERT INTO dnn_Schedule
(TypeFullName
,TimeLapse
,TimeLapseMeasurement
,RetryTimeLapse
,RetryTimeLapseMeasurement
,RetainHistoryNum
,AttachToEvent
,CatchUpEnabled
,Enabled
,ObjectDependencies
,Servers
)
VALUES
(@TypeFullName
,@TimeLapse
,@TimeLapseMeasurement
,@RetryTimeLapse
,@RetryTimeLapseMeasurement
,@RetainHistoryNum
,@AttachToEvent
,@CatchUpEnabled
,@Enabled
,@ObjectDependencies
,@Servers
)


select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetScheduleHistory]    Script Date: 10/05/2007 21:22:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetScheduleHistory]
@ScheduleID int
AS
SELECT S.ScheduleID, S.TypeFullName, SH.StartDate, SH.EndDate, SH.Succeeded, SH.LogNotes, SH.NextStart, SH.Server
FROM dbo.dnn_Schedule S
INNER JOIN dbo.dnn_ScheduleHistory SH
ON S.ScheduleID = SH.ScheduleID
WHERE S.ScheduleID = @ScheduleID or @ScheduleID = -1
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteSchedule]    Script Date: 10/05/2007 21:21:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteSchedule]
@ScheduleID int
AS
DELETE FROM dbo.dnn_Schedule
WHERE ScheduleID = @ScheduleID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTabPanes]    Script Date: 10/05/2007 21:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetTabPanes]

@TabId    int

as

select distinct(PaneName) as PaneName
from   dnn_TabModules
where  TabId = @TabId
order by PaneName
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateModuleOrder]    Script Date: 10/05/2007 21:22:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateModuleOrder]

@TabId              int,
@ModuleId           int,
@ModuleOrder        int,
@PaneName           nvarchar(50)

as

update dnn_TabModules
set    ModuleOrder = @ModuleOrder,
       PaneName = @PaneName
where  TabId = @TabId
and    ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchModules]    Script Date: 10/05/2007 21:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSearchModules]

@PortalID int

AS

SELECT M.ModuleID,
       M.ModuleDefID,
       M.ModuleTitle,
       M.AllTabs,
       M.IsDeleted,
       M.InheritViewPermissions,
       M.Header,
       M.Footer,
       M.StartDate,
       M.EndDate,
       M.PortalID,
       TM.TabModuleId,
       TM.TabId,
       TM.PaneName,
       TM.ModuleOrder,
       TM.CacheTime,
       TM.Alignment,
       TM.Color,
       TM.Border,
       TM.Visibility,
       TM.ContainerSrc,
       TM.DisplayTitle,
       TM.DisplayPrint,
       TM.DisplaySyndicate,
       'IconFile' = case when F.FileName is null then TM.IconFile else F.Folder + F.FileName end,
       DM.*,
       MC.ModuleControlId,
       MC.ControlSrc,
       MC.ControlType,
       MC.ControlTitle,
       MC.HelpURL
FROM dnn_Modules M
	INNER JOIN dnn_TabModules TM ON M.ModuleId = TM.ModuleId
	INNER JOIN dnn_Tabs T ON TM.TabId = T.TabId
	INNER JOIN dnn_ModuleDefinitions MD ON M.ModuleDefId = MD.ModuleDefId
	INNER JOIN dnn_DesktopModules DM ON MD.DesktopModuleId = DM.DesktopModuleId
	INNER JOIN dnn_ModuleControls MC ON MD.ModuleDefId = MC.ModuleDefId
	LEFT OUTER JOIN dnn_Files F ON TM.IconFile = 'fileid=' + convert(varchar,F.FileID)
WHERE  M.IsDeleted = 0  
	AND T.IsDeleted = 0  
	AND ControlKey is null 
	AND DM.IsAdmin = 0
	AND (DM.SupportedFeatures & 2 = 2)
	AND (T.EndDate > GETDATE() or T.EndDate IS NULL) 
	AND (T.StartDate <= GETDATE() or T.StartDate IS NULL) 
	AND (M.StartDate <= GETDATE() or M.StartDate IS NULL) 
	AND (M.EndDate > GETDATE() or M.EndDate IS NULL) 
	AND (NOT (DM.BusinessControllerClass IS NULL))
	AND (T.PortalID = @PortalID OR (T.PortalID IS NULL AND @PortalID Is NULL))
ORDER BY TM.ModuleOrder
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchSettings]    Script Date: 10/05/2007 21:22:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSearchSettings]

	@ModuleID	int

AS

select     	tm.ModuleID, 
			settings.SettingName, 
			settings.SettingValue
from	dnn_Tabs searchTabs INNER JOIN
		dnn_TabModules searchTabModules ON searchTabs.TabID = searchTabModules.TabID INNER JOIN
        dnn_Portals p ON searchTabs.PortalID = p.PortalID INNER JOIN
        dnn_Tabs t ON p.PortalID = t.PortalID INNER JOIN
        dnn_TabModules tm ON t.TabID = tm.TabID INNER JOIN
        dnn_ModuleSettings settings ON searchTabModules.ModuleID = settings.ModuleID
where   searchTabs.TabName = N'Search Admin'
and		tm.ModuleID = @ModuleID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTabModuleOrder]    Script Date: 10/05/2007 21:22:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetTabModuleOrder]

@TabId    int, 
@PaneName nvarchar(50)

as

select *
from   dnn_TabModules 
where  TabId = @TabId 
and    PaneName = @PaneName
order by ModuleOrder
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchResultModules]    Script Date: 10/05/2007 21:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetSearchResultModules]

@PortalID int

AS

SELECT     
		TM.TabID, 
		T.TabName  AS SearchTabName
FROM	dnn_Modules M
INNER JOIN	dnn_ModuleDefinitions MD ON MD.ModuleDefID = M.ModuleDefID 
INNER JOIN	dnn_TabModules TM ON TM.ModuleID = M.ModuleID 
INNER JOIN	dnn_Tabs T ON T.TabID = TM.TabID
WHERE	MD.FriendlyName = N'Search Results'
	AND T.PortalID = @PortalID
	AND T.IsDeleted = 0
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddTabModule]    Script Date: 10/05/2007 21:21:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddTabModule]
    
@TabId                         int,
@ModuleId                      int,
@ModuleOrder                   int,
@PaneName                      nvarchar(50),
@CacheTime                     int,
@Alignment                     nvarchar(10),
@Color                         nvarchar(20),
@Border                        nvarchar(1),
@IconFile                      nvarchar(100),
@Visibility                    int,
@ContainerSrc                  nvarchar(200),
@DisplayTitle                  bit,
@DisplayPrint                  bit,
@DisplaySyndicate              bit

as

insert into dnn_TabModules ( 
  TabId,
  ModuleId,
  ModuleOrder,
  PaneName,
  CacheTime,
  Alignment,
  Color,
  Border,
  IconFile,
  Visibility,
  ContainerSrc,
  DisplayTitle,
  DisplayPrint,
  DisplaySyndicate
)
values (
  @TabId,
  @ModuleId,
  @ModuleOrder,
  @PaneName,
  @CacheTime,
  @Alignment,
  @Color,
  @Border,
  @IconFile,
  @Visibility,
  @ContainerSrc,
  @DisplayTitle,
  @DisplayPrint,
  @DisplaySyndicate
)
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateTabModule]    Script Date: 10/05/2007 21:23:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateTabModule]

@TabId               int,
@ModuleId            int,
@ModuleOrder         int,
@PaneName            nvarchar(50),
@CacheTime           int,
@Alignment           nvarchar(10),
@Color               nvarchar(20),
@Border              nvarchar(1),
@IconFile            nvarchar(100),
@Visibility          int,
@ContainerSrc        nvarchar(200),
@DisplayTitle        bit,
@DisplayPrint        bit,
@DisplaySyndicate    bit

as

update dnn_TabModules
set    ModuleOrder = @ModuleOrder,
       PaneName = @PaneName,
       CacheTime = @CacheTime,
       Alignment = @Alignment,
       Color = @Color,
       Border = @Border,
       IconFile = @IconFile,
       Visibility = @Visibility,
       ContainerSrc = @ContainerSrc,
       DisplayTitle = @DisplayTitle,
       DisplayPrint = @DisplayPrint,
       DisplaySyndicate = @DisplaySyndicate
where  TabId = @TabId
and    ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteTabModule]    Script Date: 10/05/2007 21:21:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteTabModule]

@TabId      int,
@ModuleId   int

as

delete
from   dnn_TabModules 
where  TabId = @TabId
and    ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchItems]    Script Date: 10/05/2007 21:22:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSearchItems]

@PortalId int,
@TabId int,
@ModuleId int

AS

SELECT si.*,
       'AuthorName' = u.FirstName + ' ' + u.LastName,
       t.TabId
FROM   dbo.dnn_SearchItem si
	LEFT OUTER JOIN dbo.dnn_Users u ON si.Author = u.UserID
	INNER JOIN dbo.dnn_Modules m ON si.ModuleId = m.ModuleID 
	INNER JOIN dbo.dnn_TabModules tm ON m.ModuleId = tm.ModuleID 
	INNER JOIN dbo.dnn_Tabs t ON tm.TabID = t.TabID
	INNER JOIN dbo.dnn_Portals p ON t.PortalID = p.PortalID
WHERE (p.PortalId = @PortalId or @PortalId is null)
	AND   (t.TabId = @TabId or @TabId is null)
	AND   (m.ModuleId = @ModuleId or @ModuleId is null)
ORDER BY PubDate DESC
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchResults]    Script Date: 10/05/2007 21:22:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetSearchResults]
	@PortalID int,
	@Word nVarChar(100)
AS
SELECT si.SearchItemID,
	sw.Word,
	siw.Occurrences,
	siw.Occurrences + 1000 as Relevance,
	m.ModuleID,
	tm.TabID,
	si.Title,
	si.Description,
	si.Author,
	si.PubDate,
	si.SearchKey,
	si.Guid,
	si.ImageFileId,
	u.FirstName + ' ' + u.LastName As AuthorName,
	m.PortalId
FROM    dnn_SearchWord sw
	INNER JOIN dnn_SearchItemWord siw ON sw.SearchWordsID = siw.SearchWordsID
	INNER JOIN dnn_SearchItem si ON siw.SearchItemID = si.SearchItemID
	INNER JOIN dnn_Modules m ON si.ModuleId = m.ModuleID
	LEFT OUTER JOIN dnn_TabModules tm ON si.ModuleId = tm.ModuleID
	INNER JOIN dnn_Tabs t ON tm.TabID = t.TabID
	LEFT OUTER JOIN dnn_Users u ON si.Author = u.UserID
WHERE   (((m.StartDate Is Null) OR (GetDate() > m.StartDate)) AND ((m.EndDate Is Null) OR (GetDate() < m.EndDate)))
	AND (((t.StartDate Is Null) OR (GetDate() > t.StartDate)) AND ((t.EndDate Is Null) OR (GetDate() < t.EndDate)))
	AND (sw.Word = @Word) 
	AND (t.IsDeleted = 0) 
	AND (m.IsDeleted = 0) 
	AND (t.PortalID = @PortalID)
ORDER BY Relevance DESC
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUrlLog]    Script Date: 10/05/2007 21:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetUrlLog]

@URLTrackingID int,
@StartDate     datetime,
@EndDate       datetime

as

select dnn_UrlLog.*,
       'FullName' = dnn_Users.FirstName + ' ' + dnn_Users.LastName
from   dnn_UrlLog
inner join dnn_UrlTracking on dnn_UrlLog.UrlTrackingId = dnn_UrlTracking.UrlTrackingId
left outer join dnn_Users on dnn_UrlLog.UserId = dnn_Users.UserId
where  dnn_UrlLog.UrlTrackingID = @UrlTrackingID
and    ((ClickDate >= @StartDate) or @StartDate is null)
and    ((ClickDate <= @EndDate) or @EndDate is null)
order by ClickDate
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddUrlLog]    Script Date: 10/05/2007 21:21:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddUrlLog]

@UrlTrackingID int,
@UserID        int

as

insert into dnn_UrlLog (
  UrlTrackingID,
  ClickDate,
  UserID
)
values (
  @UrlTrackingID,
  getdate(),
  @UserID
)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSiteLog4]    Script Date: 10/05/2007 21:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSiteLog4]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select Referrer,
 'Requests' = count(*),
 'LastRequest' = max(DateTime)
from dnn_SiteLog
where dnn_SiteLog.PortalId = @PortalId
and dnn_SiteLog.DateTime between @StartDate and @EndDate
and Referrer is not null
and Referrer not like '%' + @PortalAlias + '%'
group by Referrer
order by Requests desc
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSiteLog3]    Script Date: 10/05/2007 21:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSiteLog3]

	@PortalId int,
	@PortalAlias nvarchar(50),
	@StartDate datetime,
	@EndDate datetime

as

select 'Name' = dnn_Users.FirstName + ' ' + dnn_Users.LastName,
	'Requests' = count(*),
	'LastRequest' = max(DateTime)
from dnn_SiteLog
inner join dnn_Users on dnn_SiteLog.UserId = dnn_Users.UserId
where dnn_SiteLog.PortalId = @PortalId
and dnn_SiteLog.DateTime between @StartDate and @EndDate
and dnn_SiteLog.UserId is not null
group by dnn_Users.FirstName + ' ' + dnn_Users.LastName
order by Requests desc
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteSiteLog]    Script Date: 10/05/2007 21:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteSiteLog]

@DateTime                      datetime, 
@PortalId                      int

as

delete
from dnn_SiteLog
where  PortalId = @PortalId
and    DateTime < @DateTime
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSiteLog2]    Script Date: 10/05/2007 21:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSiteLog2]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select dnn_SiteLog.DateTime,
 'Name' = 
 case
when dnn_SiteLog.UserId is null then null
else dnn_Users.FirstName + ' ' + dnn_Users.LastName
end,
 'Referrer' = 
 case 
 when dnn_SiteLog.Referrer like '%' + @PortalAlias + '%' then null 
 else dnn_SiteLog.Referrer
 end,
 'UserAgent' = 
 case 
 when dnn_SiteLog.UserAgent like '%MSIE 1%' then 'Internet Explorer 1'
 when dnn_SiteLog.UserAgent like '%MSIE 2%' then 'Internet Explorer 2'
 when dnn_SiteLog.UserAgent like '%MSIE 3%' then 'Internet Explorer 3'
 when dnn_SiteLog.UserAgent like '%MSIE 4%' then 'Internet Explorer 4'
 when dnn_SiteLog.UserAgent like '%MSIE 5%' then 'Internet Explorer 5'
 when dnn_SiteLog.UserAgent like '%MSIE 6%' then 'Internet Explorer 6'
 when dnn_SiteLog.UserAgent like '%MSIE%' then 'Internet Explorer'
 when dnn_SiteLog.UserAgent like '%Mozilla/1%' then 'Netscape Navigator 1'
 when dnn_SiteLog.UserAgent like '%Mozilla/2%' then 'Netscape Navigator 2'
 when dnn_SiteLog.UserAgent like '%Mozilla/3%' then 'Netscape Navigator 3'
 when dnn_SiteLog.UserAgent like '%Mozilla/4%' then 'Netscape Navigator 4'
 when dnn_SiteLog.UserAgent like '%Mozilla/5%' then 'Netscape Navigator 6+'
 else dnn_SiteLog.UserAgent
 end,
 dnn_SiteLog.UserHostAddress,
 dnn_Tabs.TabName
from dnn_SiteLog
left outer join dnn_Users on dnn_SiteLog.UserId = dnn_Users.UserId 
left outer join dnn_Tabs on dnn_SiteLog.TabId = dnn_Tabs.TabId 
where dnn_SiteLog.PortalId = @PortalId
and dnn_SiteLog.DateTime between @StartDate and @EndDate
order by dnn_SiteLog.DateTime desc
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSiteLog12]    Script Date: 10/05/2007 21:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSiteLog12]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select AffiliateId,
 'Requests' = count(*),
 'LastReferral' = max(DateTime)
from dnn_SiteLog
where dnn_SiteLog.PortalId = @PortalId
and dnn_SiteLog.DateTime between @StartDate and @EndDate
and AffiliateId is not null
group by AffiliateId
order by Requests desc
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSiteLog6]    Script Date: 10/05/2007 21:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSiteLog6]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select 'Hour' = datepart(hour,DateTime),
 'Views' = count(*),
 'Visitors' = count(distinct dnn_SiteLog.UserHostAddress),
 'Users' = count(distinct dnn_SiteLog.UserId)
from dnn_SiteLog
where PortalId = @PortalId
and dnn_SiteLog.DateTime between @StartDate and @EndDate
group by datepart(hour,DateTime)
order by Hour
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddSiteLog]    Script Date: 10/05/2007 21:21:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddSiteLog]

@DateTime                      datetime, 
@PortalId                      int,
@UserId                        int                   = null,
@Referrer                      nvarchar(255)         = null,
@Url                           nvarchar(255)         = null,
@UserAgent                     nvarchar(255)         = null,
@UserHostAddress               nvarchar(255)         = null,
@UserHostName                  nvarchar(255)         = null,
@TabId                         int                   = null,
@AffiliateId                   int                   = null

as
 
declare @SiteLogHistory int

insert into dnn_SiteLog ( 
  DateTime,
  PortalId,
  UserId,
  Referrer,
  Url,
  UserAgent,
  UserHostAddress,
  UserHostName,
  TabId,
  AffiliateId
)
values (
  @DateTime,
  @PortalId,
  @UserId,
  @Referrer,
  @Url,
  @UserAgent,
  @UserHostAddress,
  @UserHostName,
  @TabId,
  @AffiliateId
)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSiteLog7]    Script Date: 10/05/2007 21:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSiteLog7]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select 'WeekDay' = datepart(weekday,DateTime),
 'Views' = count(*),
 'Visitors' = count(distinct dnn_SiteLog.UserHostAddress),
 'Users' = count(distinct dnn_SiteLog.UserId)
from dnn_SiteLog
where PortalId = @PortalId
and dnn_SiteLog.DateTime between @StartDate and @EndDate
group by datepart(weekday,DateTime)
order by WeekDay
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSiteLog1]    Script Date: 10/05/2007 21:22:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSiteLog1]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select 'Date' = convert(varchar,DateTime,102),
 'Views' = count(*),
 'Visitors' = count(distinct dnn_SiteLog.UserHostAddress),
 'Users' = count(distinct dnn_SiteLog.UserId)
from dnn_SiteLog
where PortalId = @PortalId
and dnn_SiteLog.DateTime between @StartDate and @EndDate
group by convert(varchar,DateTime,102)
order by Date desc
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSiteLog8]    Script Date: 10/05/2007 21:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSiteLog8]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select 'Month' = datepart(month,DateTime),
 'Views' = count(*),
 'Visitors' = count(distinct dnn_SiteLog.UserHostAddress),
 'Users' = count(distinct dnn_SiteLog.UserId)
from dnn_SiteLog
where PortalId = @PortalId
and dnn_SiteLog.DateTime between @StartDate and @EndDate
group by datepart(month,DateTime)
order by Month
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSiteLog5]    Script Date: 10/05/2007 21:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSiteLog5]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select'UserAgent' = 
 case 
 when dnn_SiteLog.UserAgent like '%MSIE 1%' then 'Internet Explorer 1'
 when dnn_SiteLog.UserAgent like '%MSIE 2%' then 'Internet Explorer 2'
 when dnn_SiteLog.UserAgent like '%MSIE 3%' then 'Internet Explorer 3'
 when dnn_SiteLog.UserAgent like '%MSIE 4%' then 'Internet Explorer 4'
 when dnn_SiteLog.UserAgent like '%MSIE 5%' then 'Internet Explorer 5'
 when dnn_SiteLog.UserAgent like '%MSIE 6%' then 'Internet Explorer 6'
 when dnn_SiteLog.UserAgent like '%MSIE%' then 'Internet Explorer'
 when dnn_SiteLog.UserAgent like '%Mozilla/1%' then 'Netscape Navigator 1'
 when dnn_SiteLog.UserAgent like '%Mozilla/2%' then 'Netscape Navigator 2'
 when dnn_SiteLog.UserAgent like '%Mozilla/3%' then 'Netscape Navigator 3'
 when dnn_SiteLog.UserAgent like '%Mozilla/4%' then 'Netscape Navigator 4'
 when dnn_SiteLog.UserAgent like '%Mozilla/5%' then 'Netscape Navigator 6+'
 else dnn_SiteLog.UserAgent
 end,
 'Requests' = count(*),
 'LastRequest' = max(DateTime)
from dnn_SiteLog
where PortalId = @PortalId
and dnn_SiteLog.DateTime between @StartDate and @EndDate
group by case 
 when dnn_SiteLog.UserAgent like '%MSIE 1%' then 'Internet Explorer 1'
 when dnn_SiteLog.UserAgent like '%MSIE 2%' then 'Internet Explorer 2'
 when dnn_SiteLog.UserAgent like '%MSIE 3%' then 'Internet Explorer 3'
 when dnn_SiteLog.UserAgent like '%MSIE 4%' then 'Internet Explorer 4'
 when dnn_SiteLog.UserAgent like '%MSIE 5%' then 'Internet Explorer 5'
 when dnn_SiteLog.UserAgent like '%MSIE 6%' then 'Internet Explorer 6'
 when dnn_SiteLog.UserAgent like '%MSIE%' then 'Internet Explorer'
 when dnn_SiteLog.UserAgent like '%Mozilla/1%' then 'Netscape Navigator 1'
 when dnn_SiteLog.UserAgent like '%Mozilla/2%' then 'Netscape Navigator 2'
 when dnn_SiteLog.UserAgent like '%Mozilla/3%' then 'Netscape Navigator 3'
 when dnn_SiteLog.UserAgent like '%Mozilla/4%' then 'Netscape Navigator 4'
 when dnn_SiteLog.UserAgent like '%Mozilla/5%' then 'Netscape Navigator 6+'
 else dnn_SiteLog.UserAgent
 end
order by Requests desc
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSiteLog9]    Script Date: 10/05/2007 21:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSiteLog9]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select 'Page' = dnn_Tabs.TabName,
 'Requests' = count(*),
 'LastRequest' = max(DateTime)
from dnn_SiteLog
inner join dnn_Tabs on dnn_SiteLog.TabId = dnn_Tabs.TabId
where dnn_SiteLog.PortalId = @PortalId
and dnn_SiteLog.DateTime between @StartDate and @EndDate
and dnn_SiteLog.TabId is not null
group by dnn_Tabs.TabName
order by Requests desc
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetLinks]    Script Date: 10/05/2007 21:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetLinks]

@ModuleId int

as

select dnn_Links.ItemId,
       dnn_Links.ModuleId,
       dnn_Links.CreatedByUser,
       dnn_Links.CreatedDate,
       dnn_Links.Title,
       dnn_Links.URL,
       dnn_Links.ViewOrder,
       dnn_Links.Description,
       dnn_UrlTracking.TrackClicks,
       dnn_UrlTracking.NewWindow
from   dnn_Links
left outer join dnn_UrlTracking on dnn_Links.URL = dnn_UrlTracking.Url and dnn_UrlTracking.ModuleId = @ModuleID 
where  dnn_Links.ModuleId = @ModuleId
order by dnn_Links.ViewOrder, dnn_Links.Title
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateLink]    Script Date: 10/05/2007 21:22:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateLink]

	@ItemId      int,
	@UserId      int,
	@Title       nvarchar(100),
	@Url         nvarchar(250),
	@ViewOrder   int,
	@Description nvarchar(2000)

as

update dnn_Links
set    CreatedByUser = @UserId,
       CreatedDate   = GetDate(),
       Title         = @Title,
       Url           = @Url,
       ViewOrder     = @ViewOrder,
       Description   = @Description
where  ItemId = @ItemId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddLink]    Script Date: 10/05/2007 21:21:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/** Create Optimized Stored Procedures **/

create procedure [dbo].[dnn_AddLink]

	@ModuleId    int,
	@UserId      int,
	@Title       nvarchar(100),
	@Url         nvarchar(250),
	@ViewOrder   int,
	@Description nvarchar(2000)

as

insert into dnn_Links (
	ModuleId,
	CreatedByUser,
	CreatedDate,
	Title,
	Url,
	ViewOrder,
	Description
)
values (
	@ModuleId,
	@UserId,
	getdate(),
	@Title,
	@Url,
	@ViewOrder,
	@Description
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetLink]    Script Date: 10/05/2007 21:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetLink]

@ItemId   int,
@ModuleId int

as

select  dnn_Links.ItemId,
	dnn_Links.ModuleId,
	dnn_Links.Title,
	dnn_Links.URL,
        dnn_Links.ViewOrder,
        dnn_Links.Description,
        dnn_Links.CreatedByUser,
        dnn_Links.CreatedDate,
        dnn_UrlTracking.TrackClicks,
        dnn_UrlTracking.NewWindow
from    dnn_Links
left outer join dnn_UrlTracking on dnn_Links.URL = dnn_UrlTracking.Url and dnn_UrlTracking.ModuleId = @ModuleID 
where  dnn_Links.ItemId = @ItemId
and    dnn_Links.ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteLink]    Script Date: 10/05/2007 21:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteLink]

	@ItemId int

as

delete
from dnn_Links
where  ItemId = @ItemId
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateTabPermission]    Script Date: 10/05/2007 21:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateTabPermission]
	@TabPermissionID int, 
	@TabID int, 
	@PermissionID int, 
	@RoleID int ,
	@AllowAccess bit
AS

UPDATE dbo.dnn_TabPermission SET
	[TabID] = @TabID,
	[PermissionID] = @PermissionID,
	[RoleID] = @RoleID,
	[AllowAccess] = @AllowAccess
WHERE
	[TabPermissionID] = @TabPermissionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddTabPermission]    Script Date: 10/05/2007 21:21:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddTabPermission]
	@TabID int,
	@PermissionID int,
	@RoleID int,
	@AllowAccess bit
AS

INSERT INTO dbo.dnn_TabPermission (
	[TabID],
	[PermissionID],
	[RoleID],
	[AllowAccess]
) VALUES (
	@TabID,
	@PermissionID,
	@RoleID,
	@AllowAccess
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteTabPermissionsByTabID]    Script Date: 10/05/2007 21:21:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteTabPermissionsByTabID]
	@TabID int
AS

DELETE FROM dbo.dnn_TabPermission
WHERE
	[TabID] = @TabID
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteTabPermission]    Script Date: 10/05/2007 21:21:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteTabPermission]
	@TabPermissionID int
AS

DELETE FROM dbo.dnn_TabPermission
WHERE
	[TabPermissionID] = @TabPermissionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddUser]    Script Date: 10/05/2007 21:21:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddUser]

	@PortalID		int,
	@Username		nvarchar(100),
	@FirstName		nvarchar(50),
	@LastName		nvarchar(50),
	@AffiliateId    int,
	@IsSuperUser    bit,
	@Email          nvarchar(256),
	@DisplayName    nvarchar(100),
	@UpdatePassword	bit,
	@Authorised		bit

AS

DECLARE @UserID int

SELECT @UserID = UserID
	FROM   dnn_Users
	WHERE  Username = @Username

IF @UserID is null
	BEGIN
		INSERT INTO dnn_Users (
			Username,
			FirstName, 
			LastName, 
			AffiliateId,
			IsSuperUser,
			Email,
			DisplayName,
			UpdatePassword
		  )
		VALUES (
			@Username,
			@FirstName, 
			@LastName, 
			@AffiliateId,
			@IsSuperUser,
			@Email,
			@DisplayName,
			@UpdatePassword
		)

		SELECT @UserID = SCOPE_IDENTITY()
	END

IF @IsSuperUser = 0
	BEGIN
		IF not exists ( SELECT 1 FROM dnn_UserPortals WHERE UserID = @UserID AND PortalID = @PortalID )
			BEGIN
				INSERT INTO dnn_UserPortals (
					UserID,
					PortalID,
					Authorised
				)
				VALUES (
					@UserID,
					@PortalID,
					@Authorised
				)
			END
	END

SELECT @UserID
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteUserPortal]    Script Date: 10/05/2007 21:21:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_DeleteUserPortal]
	@UserId   int,
	@PortalId int
AS

	DELETE FROM dnn_UserPortals
	WHERE Userid = @UserId and PortalId = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateUser]    Script Date: 10/05/2007 21:23:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateUser]

	@UserId         int,
	@PortalId		int,
	@FirstName		nvarchar(50),
	@LastName		nvarchar(50),
	@Email          nvarchar(256),
	@DisplayName    nvarchar(100),
	@UpdatePassword	bit,
	@Authorised		bit

AS
UPDATE dnn_Users
SET
	FirstName = @FirstName,
    LastName = @LastName,
    Email = @Email,
	DisplayName = @DisplayName,
	UpdatePassword = @UpdatePassword
WHERE  UserId = @UserId

UPDATE dnn_UserPortals
SET
	Authorised = @Authorised
WHERE  UserId = @UserId
	AND PortalId = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUsers]    Script Date: 10/05/2007 21:22:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetUsers]

@PortalId int

as

select *
from dnn_Users U
left join dnn_UserPortals UP on U.UserId = UP.UserId
where ( UP.PortalId = @PortalId or @PortalId is null )
order by U.FirstName + ' ' + U.LastName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModuleControl]    Script Date: 10/05/2007 21:21:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetModuleControl]

@ModuleControlId int

as

select *
from   dnn_ModuleControls
where  ModuleControlId = @ModuleControlId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModuleControlByKeyAndSrc]    Script Date: 10/05/2007 21:21:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[dnn_GetModuleControlByKeyAndSrc]

@ModuleDefId int,
@ControlKey nvarchar(50),
@ControlSrc nvarchar(256)

as
SELECT     ModuleControlID, 
	       ModuleDefID, 
           ControlKey, 
           ControlTitle, 
           ControlSrc, 
           IconFile, 
           ControlType, 
           ViewOrder
from       dbo.dnn_ModuleControls
where ((ModuleDefId is null and @ModuleDefId is null) or (ModuleDefID = @ModuleDefID))
and ((ControlKey is null and @ControlKey is null) or (ControlKey = @ControlKey))
and ((ControlSrc is null and @ControlSrc is null) or (ControlSrc = @ControlSrc))
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteModuleControl]    Script Date: 10/05/2007 21:21:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteModuleControl]

@ModuleControlId int

as

delete
from   dnn_ModuleControls
where  ModuleControlId = @ModuleControlId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModuleControls]    Script Date: 10/05/2007 21:21:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetModuleControls]

@ModuleDefId int

as

select *
from   dnn_ModuleControls
where  (ModuleDefId is null and @ModuleDefId is null) or (ModuleDefId = @ModuleDefId)
order  by ControlKey, ViewOrder
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModuleControlsByKey]    Script Date: 10/05/2007 21:21:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetModuleControlsByKey]

@ControlKey        nvarchar(50),
@ModuleDefId       int

as

select dnn_ModuleDefinitions.*,
       ModuleControlID,
       ControlTitle,
       ControlSrc,
       IconFile,
       ControlType,
       HelpUrl
from   dnn_ModuleControls
left outer join dnn_ModuleDefinitions on dnn_ModuleControls.ModuleDefId = dnn_ModuleDefinitions.ModuleDefId
where  ((ControlKey is null and @ControlKey is null) or (ControlKey = @ControlKey))
and    ((dnn_ModuleControls.ModuleDefId is null and @ModuleDefId is null) or (dnn_ModuleControls.ModuleDefId = @ModuleDefId))
and    ControlType >= -1
order by ViewOrder
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddModuleControl]    Script Date: 10/05/2007 21:21:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[dnn_AddModuleControl]
    
@ModuleDefID                   int,
@ControlKey                    nvarchar(50),
@ControlTitle                  nvarchar(50),
@ControlSrc                    nvarchar(256),
@IconFile                      nvarchar(100),
@ControlType                   int,
@ViewOrder                     int,
@HelpUrl                       nvarchar(200)

as

insert into dnn_ModuleControls (
  ModuleDefID,
  ControlKey,
  ControlTitle,
  ControlSrc,
  IconFile,
  ControlType,
  ViewOrder,
  HelpUrl
)
values (
  @ModuleDefID,
  @ControlKey,
  @ControlTitle,
  @ControlSrc,
  @IconFile,
  @ControlType,
  @ViewOrder,
  @HelpUrl
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateModuleControl]    Script Date: 10/05/2007 21:22:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[dnn_UpdateModuleControl]

@ModuleControlId               int,
@ModuleDefID                   int,
@ControlKey                    nvarchar(50),
@ControlTitle                  nvarchar(50),
@ControlSrc                    nvarchar(256),
@IconFile                      nvarchar(100),
@ControlType                   int,
@ViewOrder                     int,
@HelpUrl                       nvarchar(200)

as

update dnn_ModuleControls
set    ModuleDefId       = @ModuleDefId,
       ControlKey        = @ControlKey,
       ControlTitle      = @ControlTitle,
       ControlSrc        = @ControlSrc,
       IconFile          = @IconFile,
       ControlType       = @ControlType,
       ViewOrder         = ViewOrder,
       HelpUrl           = @HelpUrl
where  ModuleControlId = @ModuleControlId
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteFolderPermissionsByFolderPath]    Script Date: 10/05/2007 21:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteFolderPermissionsByFolderPath]
	@PortalID int,
	@FolderPath varchar(300)
AS
DECLARE @FolderID int
SELECT @FolderID = FolderID FROM dbo.dnn_Folders
WHERE FolderPath = @FolderPath
AND ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))

DELETE FROM dbo.dnn_FolderPermission
WHERE
	[FolderID] = @FolderID
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteFolderPermission]    Script Date: 10/05/2007 21:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteFolderPermission]
	@FolderPermissionID int
AS

DELETE FROM dbo.dnn_FolderPermission
WHERE
	[FolderPermissionID] = @FolderPermissionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateFolderPermission]    Script Date: 10/05/2007 21:22:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateFolderPermission]
	@FolderPermissionID int, 
	@FolderID int, 
	@PermissionID int, 
	@RoleID int ,
	@AllowAccess bit
AS

UPDATE dbo.dnn_FolderPermission SET
	[FolderID] = @FolderID,
	[PermissionID] = @PermissionID,
	[RoleID] = @RoleID,
	[AllowAccess] = @AllowAccess
WHERE
	[FolderPermissionID] = @FolderPermissionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddFolderPermission]    Script Date: 10/05/2007 21:21:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddFolderPermission]
	@FolderID int,
	@PermissionID int,
	@RoleID int,
	@AllowAccess bit
AS

INSERT INTO dbo.dnn_FolderPermission (
	[FolderID],
	[PermissionID],
	[RoleID],
	[AllowAccess]
) VALUES (
	@FolderID,
	@PermissionID,
	@RoleID,
	@AllowAccess
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetDefaultLanguageByModule]    Script Date: 10/05/2007 21:21:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetDefaultLanguageByModule]
(
	@ModuleList varchar(1000)
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @TempList table
	(
		ModuleID int
	)

	DECLARE @ModuleID varchar(10), @Pos int

	SET @ModuleList = LTRIM(RTRIM(@ModuleList))+ ','
	SET @Pos = CHARINDEX(',', @ModuleList, 1)

	IF REPLACE(@ModuleList, ',', '') <> ''
	BEGIN
		WHILE @Pos > 0
		BEGIN
			SET @ModuleID = LTRIM(RTRIM(LEFT(@ModuleList, @Pos - 1)))
			IF @ModuleID <> ''
			BEGIN
				INSERT INTO @TempList (ModuleID) VALUES (CAST(@ModuleID AS int)) 
			END
			SET @ModuleList = RIGHT(@ModuleList, LEN(@ModuleList) - @Pos)
			SET @Pos = CHARINDEX(',', @ModuleList, 1)

		END
	END	

SELECT DISTINCT m.ModuleID, p.DefaultLanguage
FROM            dnn_Modules  m
INNER JOIN      dnn_Portals p ON p.PortalID = m.PortalID
WHERE		m.ModuleID in (SELECT ModuleID FROM @TempList)
ORDER BY        m.ModuleID	
		
END
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteModule]    Script Date: 10/05/2007 21:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteModule]

@ModuleId   int

as

delete
from   dnn_Modules 
where  ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddModule]    Script Date: 10/05/2007 21:21:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddModule]
    
	@PortalId                      int,
	@ModuleDefId                   int,
	@ModuleTitle                   nvarchar(256),
	@AllTabs                       bit,
	@Header                        ntext,
	@Footer                        ntext,
	@StartDate                     datetime,
	@EndDate                       datetime,
	@InheritViewPermissions        bit,
	@IsDeleted                     bit

AS

INSERT INTO dnn_Modules ( 
  PortalId,
  ModuleDefId,
  ModuleTitle,
  AllTabs,
  Header,
  Footer, 
  StartDate,
  EndDate,
  InheritViewPermissions,
  IsDeleted
)
values (
  @PortalId,
  @ModuleDefId,
  @ModuleTitle,
  @AllTabs,
  @Header,
  @Footer, 
  @StartDate,
  @EndDate,
  @InheritViewPermissions,
  @IsDeleted
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeletePortalInfo]    Script Date: 10/05/2007 21:21:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeletePortalInfo]
	@PortalId int

AS

/* Delete all the Portal Modules */
DELETE
FROM dnn_Modules
WHERE PortalId = @PortalId

/* Delete all the Portal Search Items */
DELETE dnn_Modules
FROM  dnn_Modules 
	INNER JOIN dnn_SearchItem ON dnn_Modules.ModuleID = dnn_SearchItem.ModuleId
WHERE	PortalId = @PortalId

/* Delete Portal */
DELETE
FROM dnn_Portals
WHERE  PortalId = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPermissionsByModuleID]    Script Date: 10/05/2007 21:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPermissionsByModuleID]
	@ModuleID int
AS

SELECT
	P.[PermissionID],
	P.[PermissionCode],
	P.[ModuleDefID],
	P.[PermissionKey],
	P.[PermissionName]
FROM
	dbo.dnn_Permission P
WHERE
	P.ModuleDefID = (SELECT ModuleDefID FROM dbo.dnn_Modules WHERE ModuleID = @ModuleID)
OR 	P.PermissionCode = 'SYSTEM_MODULE_DEFINITION'
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateModule]    Script Date: 10/05/2007 21:22:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateModule]

	@ModuleId               int,
	@ModuleTitle            nvarchar(256),
	@AllTabs                bit, 
	@Header                 ntext,
	@Footer                 ntext,
	@StartDate              datetime,
	@EndDate                datetime,
	@InheritViewPermissions	bit,
	@IsDeleted              bit

AS

UPDATE dnn_Modules
SET    ModuleTitle = @ModuleTitle,
       AllTabs = @AllTabs,
       Header = @Header,
       Footer = @Footer, 
       StartDate = @StartDate,
       EndDate = @EndDate,
       InheritViewPermissions = @InheritViewPermissions,
       IsDeleted = @IsDeleted
WHERE  ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_FindDatabaseVersion]    Script Date: 10/05/2007 21:21:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_FindDatabaseVersion]

@Major  int,
@Minor  int,
@Build  int

as

select 1
from   dnn_Version
where  Major = @Major
and    Minor = @Minor
and    Build = @Build
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateDatabaseVersion]    Script Date: 10/05/2007 21:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateDatabaseVersion]

@Major  int,
@Minor  int,
@Build  int

as

insert into dnn_Version (
  Major,
  Minor,
  Build,
  CreatedDate
)
values (
  @Major,
  @Minor,
  @Build,
  getdate()
)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetDatabaseVersion]    Script Date: 10/05/2007 21:21:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetDatabaseVersion]

as

select Major,
       Minor,
       Build
from   dnn_Version 
where  VersionId = ( select max(VersionId) from dnn_Version )
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetVendorClassifications]    Script Date: 10/05/2007 21:22:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetVendorClassifications]

@VendorId  int

as

select ClassificationId,
       ClassificationName,
       'IsAssociated' = case when exists ( select 1 from dnn_VendorClassification vc where vc.VendorId = @VendorId and vc.ClassificationId = dnn_Classification.ClassificationId ) then 1 else 0 end
from dnn_Classification
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteUsersOnline]    Script Date: 10/05/2007 21:21:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteUsersOnline]

	@TimeWindow	int
	
as
	-- Clean up the anonymous users table
	DELETE from dnn_AnonymousUsers WHERE LastActiveDate < DateAdd(minute, -@TimeWindow, GetDate())	

	-- Clean up the users online table
	DELETE from dnn_UsersOnline WHERE LastActiveDate < DateAdd(minute, -@TimeWindow, GetDate())
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateOnlineUser]    Script Date: 10/05/2007 21:22:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateOnlineUser]

@UserID 	int,
@PortalID 	int,
@TabID 		int,
@LastActiveDate datetime 

as
BEGIN
	IF EXISTS (SELECT UserID FROM dnn_UsersOnline WHERE UserID = @UserID and PortalID = @PortalID)
		UPDATE 
			dnn_UsersOnline
		SET 
			TabID = @TabID,
			LastActiveDate = @LastActiveDate
		WHERE
			UserID = @UserID
			and 
			PortalID = @PortalID
	ELSE
		INSERT INTO
			dnn_UsersOnline
			(UserID, PortalID, TabID, CreationDate, LastActiveDate) 
		VALUES
			(@UserId, @PortalID, @TabID, GetDate(), @LastActiveDate)

END
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetOnlineUser]    Script Date: 10/05/2007 21:22:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetOnlineUser]
	@UserID int

AS

SELECT
		dnn_UsersOnline.UserID,
		dnn_Users.UserName
	FROM   dnn_UsersOnline
	INNER JOIN dnn_Users ON dnn_UsersOnline.UserID = dnn_Users.UserID
	WHERE  dnn_UsersOnline.UserID = @UserID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddSearchItem]    Script Date: 10/05/2007 21:21:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddSearchItem]

	@Title nvarchar(200),
	@Description nvarchar(2000),
	@Author int,
	@PubDate datetime,
	@ModuleId int,
	@SearchKey nvarchar(100),
	@Guid nvarchar(200), 
	@ImageFileId int

as

insert into dnn_SearchItem (
	Title,
	Description,
	Author,
	PubDate,
	ModuleId,
 	SearchKey,
	Guid,
	HitCount,
	ImageFileId
) 
values (
	@Title,
	@Description,
	@Author,
	@PubDate,
	@ModuleId,
	@SearchKey,
	@Guid,
	0,
	@ImageFileId
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteSearchItem]    Script Date: 10/05/2007 21:21:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteSearchItem]
	@SearchItemID int
AS

DELETE FROM dbo.dnn_SearchItem
WHERE
	[SearchItemID] = @SearchItemID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchItem]    Script Date: 10/05/2007 21:22:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSearchItem]
	@ModuleId int,
	@SearchKey varchar(100) 
AS

select
	[SearchItemID],
	[Title],
	[Description],
	[Author],
	[PubDate],
	[ModuleId],
	[SearchKey],
	[Guid],
	[HitCount],
	ImageFileId
from
	dnn_SearchItem
where
	[ModuleID] = @ModuleID AND
	[SearchKey] = @SearchKey
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateSearchItem]    Script Date: 10/05/2007 21:22:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateSearchItem]
	@SearchItemID int, 
	@Title nvarchar(200), 
	@Description nvarchar(2000), 
	@Author int, 
	@PubDate datetime, 
	@ModuleId int, 
	@SearchKey nvarchar(100), 
	@Guid nvarchar(200), 
	@HitCount int, 
	@ImageFileId int
AS

UPDATE dnn_SearchItem 
SET	[Title] = @Title,
	[Description] = @Description,
	[Author] = @Author,
	[PubDate] = @PubDate,
	[ModuleId] = @ModuleId,
	[SearchKey] = @SearchKey,
	[Guid] = @Guid,
	[HitCount] = @HitCount,
	ImageFileId = 	@ImageFileId
WHERE   [SearchItemID] = @SearchItemID
GO
/****** Object:  StoredProcedure [dbo].[dnn_ListSearchItem]    Script Date: 10/05/2007 21:22:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_ListSearchItem]

AS

select
	[SearchItemID],
	[Title],
	[Description],
	[Author],
	[PubDate],
	[ModuleId],
	[SearchKey],
	[Guid],
	[HitCount],
	ImageFileId
from
	dnn_SearchItem
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteSearchItems]    Script Date: 10/05/2007 21:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_DeleteSearchItems]
(
	@ModuleID int
)
AS

DELETE
FROM	dnn_SearchItem
WHERE	ModuleID = @ModuleID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchIndexers]    Script Date: 10/05/2007 21:22:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSearchIndexers]

as

select dnn_SearchIndexer.*
from dnn_SearchIndexer
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteModuleDefinition]    Script Date: 10/05/2007 21:21:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteModuleDefinition]

@ModuleDefId int

as

delete
from dnn_ModuleDefinitions
where  ModuleDefId = @ModuleDefId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddModuleDefinition]    Script Date: 10/05/2007 21:21:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_AddModuleDefinition]

	@DesktopModuleId int,    
	@FriendlyName    nvarchar(128),
	@DefaultCacheTime int

as

insert into dnn_ModuleDefinitions (
  DesktopModuleId,
  FriendlyName,
  DefaultCacheTime
)
values (
  @DesktopModuleId,
  @FriendlyName,
  @DefaultCacheTime
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateModuleDefinition]    Script Date: 10/05/2007 21:22:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_UpdateModuleDefinition]

	@ModuleDefId int,    
	@FriendlyName    nvarchar(128),
	@DefaultCacheTime int

as

update dnn_ModuleDefinitions 
	SET FriendlyName = @FriendlyName,
		DefaultCacheTime = @DefaultCacheTime
	WHERE ModuleDefId = @ModuleDefId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModuleDefinitionByName]    Script Date: 10/05/2007 21:22:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetModuleDefinitionByName]

@DesktopModuleId int,    
@FriendlyName    nvarchar(128)

as

select *
from   dnn_ModuleDefinitions
where  DesktopModuleId = @DesktopModuleId
and    FriendlyName = @FriendlyName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModuleDefinition]    Script Date: 10/05/2007 21:21:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetModuleDefinition]

@ModuleDefId int

as

select *
from dnn_ModuleDefinitions
where  ModuleDefId = @ModuleDefId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModuleDefinitions]    Script Date: 10/05/2007 21:22:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetModuleDefinitions]

@DesktopModuleId int

as

select *
from   dbo.dnn_ModuleDefinitions
where  DesktopModuleId = @DesktopModuleId or @DesktopModuleId = -1
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateFile]    Script Date: 10/05/2007 21:22:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateFile]
	@FileId      int,
	@FileName    nvarchar(100),
	@Extension   nvarchar(100),
	@Size        int,
	@Width       int,
	@Height      int,
	@ContentType nvarchar(200),
	@Folder      nvarchar(200),
	@FolderID    int

AS

UPDATE dnn_Files
SET    FileName = @FileName,
       Extension = @Extension,
       Size = @Size,
       Width = @Width,
       Height = @Height,
       ContentType = @ContentType,
       Folder = @Folder,
       FolderID = @FolderID
WHERE  FileId = @FileId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetFileById]    Script Date: 10/05/2007 21:21:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetFileById]

@FileId   int,
@PortalId int

as

select FileId,
       dnn_Folders.PortalId,
       FileName,
       Extension,
       Size,
       Width,
       Height,
       ContentType,
       dnn_Files.FolderID,
       'Folder' = FolderPath,
       StorageLocation,
       IsCached
from   dnn_Files
inner join dnn_Folders on dnn_Files.FolderID = dnn_Folders.FolderID
where  FileId = @FileId
and    ((dnn_Folders.PortalId = @PortalId) or (@PortalId is null and dnn_Folders.PortalId is null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModuleSettings]    Script Date: 10/05/2007 21:22:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetModuleSettings]

@ModuleId int

AS
SELECT 
	SettingName,
	CASE WHEN LEFT(LOWER(dnn_ModuleSettings.SettingValue), 6) = 'fileid' 
		THEN
			(SELECT Folder + FileName  
				FROM dnn_Files 
				WHERE 'fileid=' + convert(varchar,dnn_Files.FileID) = dnn_ModuleSettings.SettingValue
			) 
		ELSE 
			dnn_ModuleSettings.SettingValue  
		END 
	AS SettingValue
FROM dnn_ModuleSettings 
WHERE  ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetVendor]    Script Date: 10/05/2007 21:22:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetVendor]

@VendorId int,
@PortalId int

as

select dnn_Vendors.VendorName, 
       dnn_Vendors.Unit, 
       dnn_Vendors.Street, 
       dnn_Vendors.City, 
       dnn_Vendors.Region, 
       dnn_Vendors.Country, 
       dnn_Vendors.PostalCode, 
       dnn_Vendors.Telephone,
       dnn_Vendors.Fax,
       dnn_Vendors.Cell,
       dnn_Vendors.Email,
       dnn_Vendors.Website,
       dnn_Vendors.FirstName,
       dnn_Vendors.LastName,
       dnn_Vendors.ClickThroughs,
       dnn_Vendors.Views,
       'CreatedByUser' = dnn_Users.FirstName + ' ' + dnn_Users.LastName,
       dnn_Vendors.CreatedDate,
      'LogoFile' = case when dnn_Files.FileName is null then dnn_Vendors.LogoFile else dnn_Files.Folder + dnn_Files.FileName end,
       dnn_Vendors.KeyWords,
       dnn_Vendors.Authorized,
       dnn_Vendors.PortalId
from dnn_Vendors
left outer join dnn_Users on dnn_Vendors.CreatedByUser = dnn_Users.UserId
left outer join dnn_Files on dnn_Vendors.LogoFile = 'fileid=' + convert(varchar,dnn_Files.FileID)
where  VendorId = @VendorId
and    ((dnn_Vendors.PortalId = @PortalId) or (dnn_Vendors.PortalId is null and @PortalId is null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddFile]    Script Date: 10/05/2007 21:21:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddFile]

	@PortalId    int,
	@FileName    nvarchar(100),
	@Extension   nvarchar(100),
	@Size        int,
	@Width       int,
	@Height      int,
	@ContentType nvarchar(200),
	@Folder      nvarchar(200),
	@FolderID    int
AS

DECLARE @FileID int

SELECT @FileId = FileID FROM dnn_Files WHERE FolderID = @FolderID AND FileName = @FileName

IF @FileID IS Null
    BEGIN
      INSERT INTO dnn_Files (
        PortalId,
        FileName,
        Extension,
        Size,
        Width,
        Height,
        ContentType,
        Folder,
        FolderID
      )
      VALUES (
        @PortalId,
        @FileName,
        @Extension,
        @Size,
        @Width,
        @Height,
        @ContentType,
        @Folder,
        @FolderID
      )

      SELECT @FileID = SCOPE_IDENTITY()
    END
ELSE
    BEGIN
      UPDATE dnn_Files
      SET    FileName = @FileName,
             Extension = @Extension,
             Size = @Size,
             Width = @Width,
             Height = @Height,
             ContentType = @ContentType,
             Folder = @Folder,
             FolderID = @FolderID
      WHERE  FileId = @FileID
    END

SELECT @FileID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetBanner]    Script Date: 10/05/2007 21:21:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetBanner]

@BannerId int,
@VendorId int,
@PortalID int

as

select dnn_Banners.BannerId,
       dnn_Banners.VendorId,
       'ImageFile' = case when dnn_Files.FileName is null then dnn_Banners.ImageFile else dnn_Files.Folder + dnn_Files.FileName end,
       dnn_Banners.BannerName,
       dnn_Banners.Impressions,
       dnn_Banners.CPM,
       dnn_Banners.Views,
       dnn_Banners.ClickThroughs,
       dnn_Banners.StartDate,
       dnn_Banners.EndDate,
       'CreatedByUser' = dnn_Users.FirstName + ' ' + dnn_Users.LastName,
       dnn_Banners.CreatedDate,
       dnn_Banners.BannerTypeId,
       dnn_Banners.Description,
       dnn_Banners.GroupName,
       dnn_Banners.Criteria,
       dnn_Banners.URL,        
       dnn_Banners.Width,
       dnn_Banners.Height
FROM   dnn_Banners 
INNER JOIN dnn_Vendors ON dnn_Banners.VendorId = dnn_Vendors.VendorId 
LEFT OUTER JOIN dnn_Users ON dnn_Banners.CreatedByUser = dnn_Users.UserID
left outer join dnn_Files on dnn_Banners.ImageFile = 'FileId=' + convert(varchar,dnn_Files.FileID)
where  dnn_Banners.BannerId = @BannerId
and   dnn_Banners.vendorId = @VendorId
AND (dnn_Vendors.PortalId = @PortalID or (dnn_Vendors.PortalId is null and @portalid is null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateFileContent]    Script Date: 10/05/2007 21:22:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_UpdateFileContent]

@FileId      int,
@Content     image

as

update dnn_Files
set    Content = @Content
where  FileId = @FileId
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteFiles]    Script Date: 10/05/2007 21:21:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteFiles]

@PortalId int

as

delete 
from   dnn_Files
where  ((PortalId = @PortalId) or (@PortalId is null and PortalId is null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModuleSetting]    Script Date: 10/05/2007 21:22:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetModuleSetting]

@ModuleId      int,
@SettingName   nvarchar(50)

AS
SELECT 
	CASE WHEN LEFT(LOWER(dnn_ModuleSettings.SettingValue), 6) = 'fileid' 
		THEN
			(SELECT Folder + FileName  
				FROM dnn_Files 
				WHERE 'fileid=' + convert(varchar,dnn_Files.FileID) = dnn_ModuleSettings.SettingValue
			) 
		ELSE 
			dnn_ModuleSettings.SettingValue  
		END 
	AS SettingValue
FROM dnn_ModuleSettings 
WHERE  ModuleId = @ModuleId AND SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteFile]    Script Date: 10/05/2007 21:21:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteFile]
	@PortalId int,
	@FileName nvarchar(100),
	@FolderID int

AS

DELETE 
FROM   dnn_Files
WHERE  FileName = @FileName
AND    FolderID = @FolderID
AND    ((PortalId = @PortalId) OR (@PortalId IS Null AND PortalId IS Null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetFileContent]    Script Date: 10/05/2007 21:21:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetFileContent]

@FileId   int,
@PortalId int

as

select Content
from   dnn_Files
where  FileId = @FileId
and    ((dnn_Files.PortalId = @PortalId) or (@PortalId is null and dnn_Files.PortalId is null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetFiles]    Script Date: 10/05/2007 21:21:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetFiles]

@PortalId   int,
@FolderID   int

AS

SELECT 
	FileId,
             FO.PortalId,
             FileName,
             Extension,
             Size,
             Width,
             Height,
             ContentType,
             F.FolderID,
	     'Folder' = FolderPath,
             StorageLocation,
             IsCached
FROM 
	dnn_Files F
INNER JOIN 
	dnn_Folders FO on F.FolderID = FO.FolderID
WHERE   
	F.FolderID = @FolderID
AND     
	((FO.PortalId = @PortalId) or (@PortalId is NULL AND FO.PortalId is NULL))
ORDER BY FileName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetFile]    Script Date: 10/05/2007 21:21:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetFile]

@FileName  nvarchar(100),
@PortalId  int,
@FolderID  int

as

select FileId,
       dnn_Folders.PortalId,
       FileName,
       Extension,
       Size,
       Width,
       Height,
       ContentType,
       dnn_Files.FolderID,
       'Folder' = FolderPath,
       StorageLocation,
       IsCached
from dnn_Files
inner join dnn_Folders on dnn_Files.FolderID = dnn_Folders.FolderID
where  FileName = @FileName 
and    dnn_Files.FolderID = @FolderID
and    ((dnn_Folders.PortalId = @PortalId) or (@PortalId is null and dnn_Folders.PortalId is null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_FindBanners]    Script Date: 10/05/2007 21:21:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_FindBanners]
	@PortalId     int,
	@BannerTypeId int,
	@GroupName    nvarchar(100)

AS
SELECT  B.BannerId,
        B.VendorId,
        BannerName,
        URL,
		CASE WHEN LEFT(LOWER(ImageFile), 6) = 'fileid' 
			THEN
				(SELECT Folder + FileName  
					FROM dnn_Files 
					WHERE 'fileid=' + convert(varchar,dnn_Files.FileID) = ImageFile
				) 
			ELSE 
				ImageFile  
			END 
		AS ImageFile,
        Impressions,
        CPM,
        B.Views,
        B.ClickThroughs,
        StartDate,
        EndDate,
        BannerTypeId,
        Description,
        GroupName,
        Criteria,
        B.Width,
        B.Height
FROM    dnn_Banners B
INNER JOIN dnn_Vendors V ON B.VendorId = V.VendorId
WHERE   (B.BannerTypeId = @BannerTypeId or @BannerTypeId is null)
AND     (B.GroupName = @GroupName or @GroupName is null)
AND     ((V.PortalId = @PortalId) or (@PortalId is null and V.PortalId is null))
AND     V.Authorized = 1 
AND     (getdate() <= B.EndDate or B.EndDate is null)
ORDER BY BannerId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetAllFiles]    Script Date: 10/05/2007 21:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetAllFiles]

AS

SELECT
	FileId,
             FO.PortalId,
             FileName,
             Extension,
             Size,
             Width,
             Height,
             ContentType,
             F.FolderID,
             'Folder' = FolderPath,
	     StorageLocation,
             IsCached
FROM 
	dnn_Files F

INNER JOIN 
	dnn_Folders FO on F.FolderID = FO.FolderID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortalSpaceUsed]    Script Date: 10/05/2007 21:22:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPortalSpaceUsed]
	@PortalId int
AS

SELECT 'SpaceUsed' = SUM(CAST(Size as bigint))
FROM   dnn_Files
WHERE  ((PortalId = @PortalId) OR (@PortalId is null and PortalId is null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeletePropertyDefinition]    Script Date: 10/05/2007 21:21:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeletePropertyDefinition]

	@PropertyDefinitionId int

AS

UPDATE dbo.dnn_ProfilePropertyDefinition 
	SET Deleted = 1
	WHERE  PropertyDefinitionId = @PropertyDefinitionId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddPropertyDefinition]    Script Date: 10/05/2007 21:21:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddPropertyDefinition]
	@PortalId int,
	@ModuleDefId int,
	@DataType int,
	@DefaultValue nvarchar(50),
	@PropertyCategory nvarchar(50),
	@PropertyName nvarchar(50),
	@Required bit,
	@ValidationExpression nvarchar(100),
	@ViewOrder int,
	@Visible bit,
    @Length int

AS
DECLARE @PropertyDefinitionId int

SELECT @PropertyDefinitionId = PropertyDefinitionId
	FROM   dnn_ProfilePropertyDefinition
	WHERE  (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		AND PropertyName = @PropertyName

IF @PropertyDefinitionId is null
	BEGIN
		INSERT dnn_ProfilePropertyDefinition	(
				PortalId,
				ModuleDefId,
				Deleted,
				DataType,
				DefaultValue,
				PropertyCategory,
				PropertyName,
				Required,
				ValidationExpression,
				ViewOrder,
				Visible,
				Length
			)
			VALUES	(
				@PortalId,
				@ModuleDefId,
				0,
				@DataType,
				@DefaultValue,
				@PropertyCategory,
				@PropertyName,
				@Required,
				@ValidationExpression,
				@ViewOrder,
				@Visible,
				@Length
			)

		SELECT @PropertyDefinitionId = SCOPE_IDENTITY()
	END
ELSE
	BEGIN
		UPDATE dnn_ProfilePropertyDefinition 
			SET DataType = @DataType,
				ModuleDefId = @ModuleDefId,
				DefaultValue = @DefaultValue,
				PropertyCategory = @PropertyCategory,
				Required = @Required,
				ValidationExpression = @ValidationExpression,
				ViewOrder = @ViewOrder,
				Deleted = 0,
				Visible = @Visible,
				Length = @Length
			WHERE PropertyDefinitionId = @PropertyDefinitionId
	END
	
SELECT @PropertyDefinitionId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPropertyDefinitionsByPortal]    Script Date: 10/05/2007 21:22:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPropertyDefinitionsByPortal]

	@PortalID	int

AS
SELECT	dbo.dnn_ProfilePropertyDefinition.*
	FROM	dbo.dnn_ProfilePropertyDefinition
	WHERE  (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		AND Deleted = 0
	ORDER BY ViewOrder
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPropertyDefinitionByName]    Script Date: 10/05/2007 21:22:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPropertyDefinitionByName]
	@PortalID	int,
	@Name		nvarchar(50)

AS
SELECT	*
	FROM	dnn_ProfilePropertyDefinition
	WHERE  (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		AND PropertyName = @Name
	ORDER BY ViewOrder
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdatePropertyDefinition]    Script Date: 10/05/2007 21:22:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdatePropertyDefinition]
	@PropertyDefinitionId int,
	@DataType int,
	@DefaultValue nvarchar(50),
	@PropertyCategory nvarchar(50),
	@PropertyName nvarchar(50),
	@Required bit,
	@ValidationExpression nvarchar(100),
	@ViewOrder int,
	@Visible bit,
    @Length int

as

UPDATE dbo.dnn_ProfilePropertyDefinition 
	SET DataType = @DataType,
		DefaultValue = @DefaultValue,
		PropertyCategory = @PropertyCategory,
		PropertyName = @PropertyName,
		Required = @Required,
		ValidationExpression = @ValidationExpression,
		ViewOrder = @ViewOrder,
		Visible = @Visible,
        Length = @Length
	WHERE PropertyDefinitionId = @PropertyDefinitionId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPropertyDefinitionsByCategory]    Script Date: 10/05/2007 21:22:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPropertyDefinitionsByCategory]
	@PortalID	int,
	@Category	nvarchar(50)

AS
SELECT	*
	FROM	dnn_ProfilePropertyDefinition
	WHERE  (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		AND PropertyCategory = @Category
	ORDER BY ViewOrder
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPropertyDefinition]    Script Date: 10/05/2007 21:22:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPropertyDefinition]

	@PropertyDefinitionID	int

AS
SELECT	dbo.dnn_ProfilePropertyDefinition.*
FROM	dbo.dnn_ProfilePropertyDefinition
WHERE PropertyDefinitionID = @PropertyDefinitionID
	AND Deleted = 0
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateAnonymousUser]    Script Date: 10/05/2007 21:22:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateAnonymousUser]

@UserID 	char(36),
@PortalID 	int,
@TabID 		int,
@LastActiveDate datetime 

as
BEGIN
	IF EXISTS (SELECT UserID FROM dnn_AnonymousUsers WHERE UserID = @UserID and PortalID = @PortalID)
		UPDATE 
			dnn_AnonymousUsers
		SET 
			TabID = @TabID,
			LastActiveDate = @LastActiveDate
		WHERE
			UserID = @UserID
			and 
			PortalID = @PortalID
	ELSE
		INSERT INTO
			dnn_AnonymousUsers
			(UserID, PortalID, TabID, CreationDate, LastActiveDate) 
		VALUES
			(@UserId, @PortalID, @TabID, GetDate(), @LastActiveDate)

END
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetEventLogPendingNotifConfig]    Script Date: 10/05/2007 21:21:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetEventLogPendingNotifConfig]
AS

SELECT 	COUNT(*) as PendingNotifs,
	elc.ID,
	elc.LogTypeKey, 
	elc.LogTypePortalID, 
	elc.LoggingIsActive,
	elc.KeepMostRecent,
	elc.EmailNotificationIsActive,
	elc.NotificationThreshold,
	elc.NotificationThresholdTime,
	elc.NotificationThresholdTimeType,
	elc.MailToAddress, 
	elc.MailFromAddress
FROM dbo.dnn_EventLogConfig elc
INNER JOIN dbo.dnn_EventLog
ON dbo.dnn_EventLog.LogConfigID = elc.ID
WHERE dbo.dnn_EventLog.LogNotificationPending = 1
GROUP BY elc.ID,
	elc.LogTypeKey, 
	elc.LogTypePortalID, 
	elc.LoggingIsActive,
	elc.KeepMostRecent,
	elc.EmailNotificationIsActive,
	elc.NotificationThreshold,
	elc.NotificationThresholdTime,
	elc.NotificationThresholdTimeType,
	elc.MailToAddress, 
	elc.MailFromAddress
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddEventLog]    Script Date: 10/05/2007 21:21:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddEventLog]
	@LogGUID varchar(36),
	@LogTypeKey nvarchar(35),
	@LogUserID int,
	@LogUserName nvarchar(50),
	@LogPortalID int,
	@LogPortalName nvarchar(100),
	@LogCreateDate datetime,
	@LogServerName nvarchar(50),
	@LogProperties ntext,
	@LogConfigID int
AS
INSERT INTO dbo.dnn_EventLog
	(LogGUID,
	LogTypeKey,
	LogUserID,
	LogUserName,
	LogPortalID,
	LogPortalName,
	LogCreateDate,
	LogServerName,
	LogProperties,
	LogConfigID)
VALUES
	(@LogGUID,
	@LogTypeKey,
	@LogUserID,
	@LogUserName,
	@LogPortalID,
	@LogPortalName,
	@LogCreateDate,
	@LogServerName,
	@LogProperties,
	@LogConfigID)

DECLARE @NotificationActive bit
DECLARE @NotificationThreshold bit
DECLARE @ThresholdQueue int
DECLARE @NotificationThresholdTime int
DECLARE @NotificationThresholdTimeType int
DECLARE @MinDateTime smalldatetime
DECLARE @CurrentDateTime smalldatetime

SET @CurrentDateTime = getDate()


SELECT TOP 1 @NotificationActive = EmailNotificationIsActive,
	@NotificationThreshold = NotificationThreshold,
	@NotificationThresholdTime = NotificationThresholdTime,
	@NotificationThresholdTimeType = @NotificationThresholdTimeType,
	@MinDateTime = 
		CASE
			 --seconds
			WHEN NotificationThresholdTimeType=1 THEN DateAdd(second, NotificationThresholdTime * -1, @CurrentDateTime)
			--minutes
			WHEN NotificationThresholdTimeType=2  THEN DateAdd(minute, NotificationThresholdTime * -1, @CurrentDateTime)
			--hours
			WHEN NotificationThresholdTimeType=3  THEN DateAdd(Hour, NotificationThresholdTime * -1, @CurrentDateTime)
			--days
			WHEN NotificationThresholdTimeType=4  THEN DateAdd(Day, NotificationThresholdTime * -1, @CurrentDateTime)
		END
FROM dbo.dnn_EventLogConfig
WHERE ID = @LogConfigID

IF @NotificationActive=1
BEGIN
	
	SELECT @ThresholdQueue = COUNT(*)
	FROM dbo.dnn_EventLog
	INNER JOIN dbo.dnn_EventLogConfig
	ON dbo.dnn_EventLog.LogConfigID = dbo.dnn_EventLogConfig.ID
	WHERE LogCreateDate > @MinDateTime

	PRINT 'MinDateTime=' + convert(varchar(20), @MinDateTime)
	PRINT 'ThresholdQueue=' + convert(varchar(20), @ThresholdQueue)
	PRINT 'NotificationThreshold=' + convert(varchar(20), @NotificationThreshold)

	IF @ThresholdQueue > @NotificationThreshold
	BEGIN
		UPDATE dbo.dnn_EventLog
		SET LogNotificationPending = 1 
		WHERE LogConfigID = @LogConfigID
		AND LogNotificationPending IS NULL		
		AND LogCreateDate > @MinDateTime
	END
END
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetEventLogPendingNotif]    Script Date: 10/05/2007 21:21:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetEventLogPendingNotif]
	@LogConfigID int
AS
SELECT *
FROM dbo.dnn_EventLog
WHERE LogNotificationPending = 1
AND LogConfigID = @LogConfigID
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateEventLogPendingNotif]    Script Date: 10/05/2007 21:22:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateEventLogPendingNotif]
	@LogConfigID int
AS
UPDATE dbo.dnn_EventLog
SET LogNotificationPending = 0
WHERE LogNotificationPending = 1
AND LogConfigID = @LogConfigID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetEventLogByLogGUID]    Script Date: 10/05/2007 21:21:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetEventLogByLogGUID]
	@LogGUID varchar(36)
AS
SELECT *
FROM dbo.dnn_EventLog
WHERE (LogGUID = @LogGUID)
GO
/****** Object:  StoredProcedure [dbo].[dnn_PurgeEventLog]    Script Date: 10/05/2007 21:22:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_PurgeEventLog]
AS
DELETE FROM dbo.dnn_EventLog
FROM dbo.dnn_EventLogConfig elc
WHERE 
    (
    SELECT COUNT(*)
    FROM dbo.dnn_EventLog el
    WHERE el.LogConfigID = elc.ID
	and dbo.dnn_EventLog.LogTypeKey = el.LogTypeKey
	and el.LogCreateDate >= dbo.dnn_EventLog.LogCreateDate
    ) > elc.KeepMostRecent
AND elc.KeepMostRecent<>-1
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteEventLog]    Script Date: 10/05/2007 21:21:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteEventLog]
	@LogGUID varchar(36)
AS
DELETE FROM dbo.dnn_EventLog
WHERE LogGUID = @LogGUID or @LogGUID IS NULL
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddPortalDesktopModule]    Script Date: 10/05/2007 21:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddPortalDesktopModule]

@PortalId int,
@DesktopModuleId int

as

insert into dnn_PortalDesktopModules ( 
  PortalId,
  DesktopModuleId
)
values (
  @PortalId,
  @DesktopModuleId
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetDesktopModulesByPortal]    Script Date: 10/05/2007 21:21:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetDesktopModulesByPortal]

	@PortalId int

AS

SELECT distinct(dnn_DesktopModules.DesktopModuleId) AS DesktopModuleId,
       dnn_DesktopModules.FriendlyName,
       dnn_DesktopModules.Description,
       dnn_DesktopModules.Version,
       dnn_DesktopModules.ispremium,
       dnn_DesktopModules.isadmin,
       dnn_DesktopModules.businesscontrollerclass,
       dnn_DesktopModules.foldername,
       dnn_DesktopModules.modulename,
       dnn_DesktopModules.supportedfeatures,
       dnn_DesktopModules.compatibleversions
FROM dnn_DesktopModules
LEFT OUTER JOIN dnn_PortalDesktopModules on dnn_DesktopModules.DesktopModuleId = dnn_PortalDesktopModules.DesktopModuleId
WHERE  IsAdmin = 0
AND    ( IsPremium = 0 OR (PortalId = @PortalId AND PortalDesktopModuleId IS NOT Null)) 
ORDER BY FriendlyName
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeletePortalDesktopModules]    Script Date: 10/05/2007 21:21:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeletePortalDesktopModules]

@PortalId        int,
@DesktopModuleId int

as

delete
from   dnn_PortalDesktopModules
where  ((PortalId = @PortalId) or (@PortalId is null and @DesktopModuleId is not null))
and    ((DesktopModuleId = @DesktopModuleId) or (@DesktopModuleId is null and @PortalId is not null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortalDesktopModules]    Script Date: 10/05/2007 21:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetPortalDesktopModules]

@PortalId int,
@DesktopModuleId int

as

select dnn_PortalDesktopModules.*,
       PortalName,
       FriendlyName
from   dnn_PortalDesktopModules
inner join dnn_Portals on dnn_PortalDesktopModules.PortalId = dnn_Portals.PortalId
inner join dnn_DesktopModules on dnn_PortalDesktopModules.DesktopModuleId = dnn_DesktopModules.DesktopModuleId
where  ((dnn_PortalDesktopModules.PortalId = @PortalId) or @PortalId is null)
and    ((dnn_PortalDesktopModules.DesktopModuleId = @DesktopModuleId) or @DesktopModuleId is null)
order by dnn_PortalDesktopModules.PortalId, dnn_PortalDesktopModules.DesktopModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateTabOrder]    Script Date: 10/05/2007 21:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateTabOrder]

@TabId    int,
@TabOrder int,
@Level    int,
@ParentId int

as

update dnn_Tabs
set    TabOrder = @TabOrder,
       Level = @Level,
       ParentId = @ParentId
where  TabId = @TabId
GO
/****** Object:  StoredProcedure [dbo].[dnn_VerifyPortalTab]    Script Date: 10/05/2007 21:23:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_VerifyPortalTab]

@PortalId int,
@TabId    int

as

select dnn_Tabs.TabId
from dnn_Tabs
left outer join dnn_Portals on dnn_Tabs.PortalId = dnn_Portals.PortalId
where  TabId = @TabId
and    ( dnn_Portals.PortalId = @PortalId or dnn_Tabs.PortalId is null )
and    IsDeleted = 0
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteTab]    Script Date: 10/05/2007 21:21:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteTab]

@TabId int

as

delete
from dnn_Tabs
where  TabId = @TabId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTabCount]    Script Date: 10/05/2007 21:22:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetTabCount]
	
	@PortalId	int

AS

DECLARE @AdminTabId int
SET @AdminTabId = (SELECT AdminTabId 
						FROM dnn_Portals 
						WHERE PortalID = @PortalID)

SELECT COUNT(*) - 1 
FROM  dnn_Tabs
WHERE (PortalID = @PortalID) 
	AND (TabID <> @AdminTabId) 
	AND (ParentId <> @AdminTabId OR ParentId IS NULL)
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddTab]    Script Date: 10/05/2007 21:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_AddTab]

@PortalId           int,
@TabName            nvarchar(50),
@IsVisible          bit,
@DisableLink        bit,
@ParentId           int,
@IconFile           nvarchar(100),
@Title              nvarchar(200),
@Description        nvarchar(500),
@KeyWords           nvarchar(500),
@Url                nvarchar(255),
@SkinSrc            nvarchar(200),
@ContainerSrc       nvarchar(200),
@TabPath            nvarchar(255),
@StartDate          DateTime,
@EndDate            DateTime,
@RefreshInterval	int,
@PageHeadText		nvarchar(500)

as

insert into dnn_Tabs (
    PortalId,
    TabName,
    IsVisible,
    DisableLink,
    ParentId,
    IconFile,
    Title,
    Description,
    KeyWords,
    IsDeleted,
    Url,
    SkinSrc,
    ContainerSrc,
    TabPath,
    StartDate,
    EndDate,
	RefreshInterval,
	PageHeadText
)
values (
    @PortalId,
    @TabName,
    @IsVisible,
    @DisableLink,
    @ParentId,
    @IconFile,
    @Title,
    @Description,
    @KeyWords,
    0,
    @Url,
    @SkinSrc,
    @ContainerSrc,
    @TabPath,
    @StartDate,
    @EndDate,
    @RefreshInterval,
    @PageHeadText
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_VerifyPortal]    Script Date: 10/05/2007 21:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_VerifyPortal]

@PortalId int

as

select dnn_Tabs.TabId
from dnn_Tabs
inner join dnn_Portals on dnn_Tabs.PortalId = dnn_Portals.PortalId
where dnn_Portals.PortalId = @PortalId
and dnn_Tabs.TabOrder = 1
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateTab]    Script Date: 10/05/2007 21:23:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_UpdateTab]

@TabId              int,
@TabName            nvarchar(50),
@IsVisible          bit,
@DisableLink        bit,
@ParentId           int,
@IconFile           nvarchar(100),
@Title              nvarchar(200),
@Description        nvarchar(500),
@KeyWords           nvarchar(500),
@IsDeleted          bit,
@Url                nvarchar(255),
@SkinSrc            nvarchar(200),
@ContainerSrc       nvarchar(200),
@TabPath            nvarchar(255),
@StartDate          DateTime,
@EndDate            DateTime,
@RefreshInterval	int,
@PageHeadText		nvarchar(500)

as

update dnn_Tabs
set    TabName            = @TabName,
       IsVisible          = @IsVisible,
       DisableLink        = @DisableLink,
       ParentId           = @ParentId,
       IconFile           = @IconFile,
       Title              = @Title,
       Description        = @Description,
       KeyWords           = @KeyWords,
       IsDeleted          = @IsDeleted,
       Url                = @Url,
       SkinSrc            = @SkinSrc,
       ContainerSrc       = @ContainerSrc,
       TabPath            = @TabPath,
       StartDate          = @StartDate,
       EndDate            = @EndDate,
	   RefreshInterval	  = @RefreshInterval,
	   PageHeadText		  = @PageHeadText
where  TabId = @TabId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortalByTab]    Script Date: 10/05/2007 21:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetPortalByTab]

@TabId int,
@HTTPAlias nvarchar(200)
 
as

select HTTPAlias
from dbo.dnn_PortalAlias
inner join dbo.dnn_Tabs on dbo.dnn_PortalAlias.PortalId = dbo.dnn_Tabs.PortalId
where  TabId = @TabId
and    HTTPAlias = @HTTPAlias
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteUserRole]    Script Date: 10/05/2007 21:21:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteUserRole]

@UserId int,
@RoleId int

as

delete
from dnn_UserRoles
where  UserId = @UserId
and    RoleId = @RoleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddUserRole]    Script Date: 10/05/2007 21:21:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddUserRole]

	@PortalId		int,
	@UserId			int,
	@RoleId			int,
	@EffectiveDate	datetime = null,
	@ExpiryDate		datetime = null

AS
DECLARE @UserRoleId int

SELECT @UserRoleId = null

SELECT @UserRoleId = UserRoleId
	FROM   dnn_UserRoles
	WHERE  UserId = @UserId AND RoleId = @RoleId
 
IF @UserRoleId IS NOT NULL
	BEGIN
		UPDATE dnn_UserRoles
			SET ExpiryDate = @ExpiryDate,
				EffectiveDate = @EffectiveDate	
			WHERE  UserRoleId = @UserRoleId
		SELECT @UserRoleId
	END
ELSE
	BEGIN
		INSERT INTO dnn_UserRoles (
			UserId,
			RoleId,
			EffectiveDate,
			ExpiryDate
		  )
		VALUES (
			@UserId,
			@RoleId,
			@EffectiveDate,
			@ExpiryDate
		  )

	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateUserRole]    Script Date: 10/05/2007 21:23:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateUserRole] 
    @UserRoleId int, 
	@EffectiveDate	datetime = null,
	@ExpiryDate		datetime = null
AS

UPDATE dnn_UserRoles 
	SET ExpiryDate = @ExpiryDate,
		EffectiveDate = @EffectiveDate	
	WHERE  UserRoleId = @UserRoleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddModulePermission]    Script Date: 10/05/2007 21:21:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddModulePermission]
	@ModuleID int,
	@PermissionID int,
	@RoleID int,
	@AllowAccess bit
AS

INSERT INTO dbo.dnn_ModulePermission (
	[ModuleID],
	[PermissionID],
	[RoleID],
	[AllowAccess]
) VALUES (
	@ModuleID,
	@PermissionID,
	@RoleID,
	@AllowAccess
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteModulePermissionsByModuleID]    Script Date: 10/05/2007 21:21:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteModulePermissionsByModuleID]
	@ModuleID int
AS

DELETE FROM dbo.dnn_ModulePermission
WHERE
	[ModuleID] = @ModuleID
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteModulePermission]    Script Date: 10/05/2007 21:21:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteModulePermission]
	@ModulePermissionID int
AS

DELETE FROM dbo.dnn_ModulePermission
WHERE
	[ModulePermissionID] = @ModulePermissionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateModulePermission]    Script Date: 10/05/2007 21:22:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateModulePermission]
	@ModulePermissionID int, 
	@ModuleID int, 
	@PermissionID int, 
	@RoleID int ,
	@AllowAccess bit
AS

UPDATE dbo.dnn_ModulePermission SET
	[ModuleID] = @ModuleID,
	[PermissionID] = @PermissionID,
	[RoleID] = @RoleID,
	[AllowAccess] = @AllowAccess
WHERE
	[ModulePermissionID] = @ModulePermissionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddScheduleItemSetting]    Script Date: 10/05/2007 21:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddScheduleItemSetting]

@ScheduleID     int,
@Name           nvarchar(50),
@Value			nvarchar(256)

as

IF EXISTS ( SELECT * FROM dbo.dnn_ScheduleItemSettings WHERE ScheduleID = @ScheduleID AND SettingName = @Name)
BEGIN 
	UPDATE	dbo.dnn_ScheduleItemSettings
	SET		SettingValue = @Value
	WHERE	ScheduleID = @ScheduleID
	AND		SettingName = @Name
END 
ELSE 
BEGIN 
	INSERT INTO dbo.dnn_ScheduleItemSettings (
		ScheduleID,
		SettingName,
		Settingvalue
	)
	VALUES (
		@ScheduleID,
		@Name,
		@Value
	)
END
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetScheduleItemSettings]    Script Date: 10/05/2007 21:22:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetScheduleItemSettings] 
@ScheduleID int
AS
SELECT *
FROM dbo.dnn_ScheduleItemSettings
WHERE ScheduleID = @ScheduleID
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteVendor]    Script Date: 10/05/2007 21:21:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteVendor]

@VendorId int

as

delete
from dnn_Vendors
where  VendorId = @VendorId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetAffiliate]    Script Date: 10/05/2007 21:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetAffiliate]
	@AffiliateId int,
	@VendorId int,
	@PortalID int
AS

	SELECT	dnn_Affiliates.AffiliateId,
		dnn_Affiliates.VendorId,
		dnn_Affiliates.StartDate,
		dnn_Affiliates.EndDate,
		dnn_Affiliates.CPC,
		dnn_Affiliates.Clicks,
		dnn_Affiliates.CPA,
		dnn_Affiliates.Acquisitions
	FROM	dnn_Affiliates 
	INNER JOIN dnn_Vendors ON dnn_Affiliates.VendorId = dnn_Vendors.VendorId
	WHERE	dnn_Affiliates.AffiliateId = @AffiliateId
	AND	dnn_Affiliates.VendorId = @VendorId
	AND	(dnn_Vendors.PortalId = @PortalID or (dnn_Vendors.PortalId is null and @portalid is null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddVendor]    Script Date: 10/05/2007 21:21:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_AddVendor]

@PortalId 	int,
@VendorName nvarchar(50),
@Unit    	nvarchar(50),
@Street 	nvarchar(50),
@City		nvarchar(50),
@Region	    nvarchar(50),
@Country	nvarchar(50),
@PostalCode	nvarchar(50),
@Telephone	nvarchar(50),
@Fax   	    nvarchar(50),
@Cell   	nvarchar(50),
@Email    	nvarchar(50),
@Website	nvarchar(100),
@FirstName	nvarchar(50),
@LastName	nvarchar(50),
@UserName   nvarchar(100),
@LogoFile   nvarchar(100),
@KeyWords   text,
@Authorized bit

as

insert into dnn_Vendors (
  VendorName,
  Unit,
  Street,
  City,
  Region,
  Country,
  PostalCode,
  Telephone,
  PortalId,
  Fax,
  Cell,
  Email,
  Website,
  FirstName,
  Lastname,
  ClickThroughs,
  Views,
  CreatedByUser,
  CreatedDate,
  LogoFile,
  KeyWords,
  Authorized
)
values (
  @VendorName,
  @Unit,
  @Street,
  @City,
  @Region,
  @Country,
  @PostalCode,
  @Telephone,
  @PortalId,
  @Fax,
  @Cell,
  @Email,
  @Website,
  @FirstName,
  @LastName,
  0,
  0,
  @UserName,
  getdate(), 
  @LogoFile,
  @KeyWords,
  @Authorized
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetBannerGroups]    Script Date: 10/05/2007 21:21:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetBannerGroups]
	@PortalId int
AS

SELECT  GroupName
FROM dbo.dnn_Banners
INNER JOIN dbo.dnn_Vendors ON 
	dbo.dnn_Banners.VendorId = dbo.dnn_Vendors.VendorId
WHERE (dbo.dnn_Vendors.PortalId = @PortalId) OR 
	(@PortalId is null and dbo.dnn_Vendors.PortalId is null)
GROUP BY GroupName
ORDER BY GroupName
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateVendor]    Script Date: 10/05/2007 21:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_UpdateVendor]

@VendorId	int,
@VendorName nvarchar(50),
@Unit	 	nvarchar(50),
@Street 	nvarchar(50),
@City		nvarchar(50),
@Region	    nvarchar(50),
@Country	nvarchar(50),
@PostalCode	nvarchar(50),
@Telephone	nvarchar(50),
@Fax		nvarchar(50),
@Cell		nvarchar(50),
@Email		nvarchar(50),
@Website	nvarchar(100),
@FirstName	nvarchar(50),
@LastName	nvarchar(50),
@UserName   nvarchar(100),
@LogoFile   nvarchar(100),
@KeyWords   text,
@Authorized bit

as

update dnn_Vendors
set    VendorName    = @VendorName,
       Unit          = @Unit,
       Street        = @Street,
       City          = @City,
       Region        = @Region,
       Country       = @Country,
       PostalCode    = @PostalCode,
       Telephone     = @Telephone,
       Fax           = @Fax,
       Cell          = @Cell,
       Email         = @Email,
       Website       = @Website,
       FirstName     = @FirstName,
       LastName      = @LastName,
       CreatedByUser = @UserName,
       CreatedDate   = getdate(),
       LogoFile      = @LogoFile,
       KeyWords      = @KeyWords,
       Authorized    = @Authorized
where  VendorId = @VendorId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchItemWordBySearchWord]    Script Date: 10/05/2007 21:22:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSearchItemWordBySearchWord]
	@SearchWordsID int
AS

SELECT
	[SearchItemWordID],
	[SearchItemID],
	[SearchWordsID],
	[Occurrences]
FROM
	dbo.dnn_SearchItemWord
WHERE
	[SearchWordsID]=@SearchWordsID
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteSearchItemWords]    Script Date: 10/05/2007 21:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteSearchItemWords]
	@SearchItemID int
AS

delete from dbo.dnn_SearchItemWord
where
	[SearchItemID] = @SearchItemID
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateSearchItemWord]    Script Date: 10/05/2007 21:22:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateSearchItemWord]
	@SearchItemWordID int, 
	@SearchItemID int, 
	@SearchWordsID int, 
	@Occurrences int 
AS

UPDATE dbo.dnn_SearchItemWord SET
	[SearchItemID] = @SearchItemID,
	[SearchWordsID] = @SearchWordsID,
	[Occurrences] = @Occurrences
WHERE
	[SearchItemWordID] = @SearchItemWordID
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteSearchItemWord]    Script Date: 10/05/2007 21:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteSearchItemWord]
	@SearchItemWordID int
AS

DELETE FROM dbo.dnn_SearchItemWord
WHERE
	[SearchItemWordID] = @SearchItemWordID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchItemWord]    Script Date: 10/05/2007 21:22:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSearchItemWord]
	@SearchItemWordID int
	
AS

SELECT
	[SearchItemWordID],
	[SearchItemID],
	[SearchWordsID],
	[Occurrences]
FROM
	dbo.dnn_SearchItemWord
WHERE
	[SearchItemWordID] = @SearchItemWordID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddSearchItemWord]    Script Date: 10/05/2007 21:21:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddSearchItemWord]
	@SearchItemID int,
	@SearchWordsID int,
	@Occurrences int

AS

DECLARE @ID int
SELECT @id = SearchItemWordID 
	FROM dnn_SearchItemWord
	WHERE SearchItemID=@SearchItemID 
		AND SearchWordsID=@SearchWordsID
 

IF @ID IS NULL
	BEGIN
		INSERT INTO dnn_SearchItemWord (
			[SearchItemID],
			[SearchWordsID],
			[Occurrences]
			) 
		VALUES (
			@SearchItemID,
			@SearchWordsID,
			@Occurrences
			)

		SELECT SCOPE_IDENTITY()
	END
ELSE

	UPDATE dnn_SearchItemWord 
		SET Occurrences = @Occurrences 
		WHERE SearchItemWordID=@id 
			AND Occurrences<>@Occurrences

SELECT @id
GO
/****** Object:  StoredProcedure [dbo].[dnn_ListSearchItemWord]    Script Date: 10/05/2007 21:22:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_ListSearchItemWord]
AS

SELECT
	[SearchItemWordID],
	[SearchItemID],
	[SearchWordsID],
	[Occurrences]
FROM
	dbo.dnn_SearchItemWord
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchItemWordBySearchItem]    Script Date: 10/05/2007 21:22:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSearchItemWordBySearchItem]
	@SearchItemID int
AS

SELECT
	[SearchItemWordID],
	[SearchItemID],
	[SearchWordsID],
	[Occurrences]
FROM
	dbo.dnn_SearchItemWord
WHERE
	[SearchItemID]=@SearchItemID
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteModuleSetting]    Script Date: 10/05/2007 21:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteModuleSetting]
@ModuleId      int,
@SettingName   nvarchar(50)
as

DELETE FROM dnn_ModuleSettings 
WHERE ModuleId = @ModuleId
AND SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateModuleSetting]    Script Date: 10/05/2007 21:22:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateModuleSetting]

@ModuleId      int,
@SettingName   nvarchar(50),
@SettingValue  nvarchar(2000)

as

update dnn_ModuleSettings
set SettingValue = @SettingValue
where ModuleId = @ModuleId
and SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteModuleSettings]    Script Date: 10/05/2007 21:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteModuleSettings]
@ModuleId      int
as

DELETE FROM dnn_ModuleSettings 
WHERE ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddModuleSetting]    Script Date: 10/05/2007 21:21:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddModuleSetting]

@ModuleId      int,
@SettingName   nvarchar(50),
@SettingValue  nvarchar(2000)

as

insert into dnn_ModuleSettings ( 
  ModuleId, 
  SettingName, 
  SettingValue 
) 
values ( 
  @ModuleId, 
  @SettingName, 
  @SettingValue 
)
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddEventLogType]    Script Date: 10/05/2007 21:21:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddEventLogType]
	@LogTypeKey nvarchar(35),
	@LogTypeFriendlyName nvarchar(50),
	@LogTypeDescription nvarchar(128),
	@LogTypeOwner nvarchar(100),
	@LogTypeCSSClass nvarchar(40)
AS
	INSERT INTO dbo.dnn_EventLogTypes
	(LogTypeKey,
	LogTypeFriendlyName,
	LogTypeDescription,
	LogTypeOwner,
	LogTypeCSSClass)
VALUES
	(@LogTypeKey,
	@LogTypeFriendlyName,
	@LogTypeDescription,
	@LogTypeOwner,
	@LogTypeCSSClass)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetEventLogType]    Script Date: 10/05/2007 21:21:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetEventLogType]
AS
SELECT *
FROM dbo.dnn_EventLogTypes
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateEventLogType]    Script Date: 10/05/2007 21:22:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateEventLogType]
	@LogTypeKey nvarchar(35),
	@LogTypeFriendlyName nvarchar(50),
	@LogTypeDescription nvarchar(128),
	@LogTypeOwner nvarchar(100),
	@LogTypeCSSClass nvarchar(40)
AS
UPDATE dbo.dnn_EventLogTypes
	SET LogTypeFriendlyName = @LogTypeFriendlyName,
	LogTypeDescription = @LogTypeDescription,
	LogTypeOwner = @LogTypeOwner,
	LogTypeCSSClass = @LogTypeCSSClass
WHERE	LogTypeKey = @LogTypeKey
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteEventLogType]    Script Date: 10/05/2007 21:21:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteEventLogType]
	@LogTypeKey nvarchar(35)
AS
DELETE FROM dbo.dnn_EventLogTypes
WHERE	LogTypeKey = @LogTypeKey
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateEventLogConfig]    Script Date: 10/05/2007 21:22:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateEventLogConfig]
	@ID int,
	@LogTypeKey nvarchar(35),
	@LogTypePortalID int,
	@LoggingIsActive bit,
	@KeepMostRecent int,
	@EmailNotificationIsActive bit,
	@NotificationThreshold int,
	@NotificationThresholdTime int,
	@NotificationThresholdTimeType int,
	@MailFromAddress nvarchar(50),
	@MailToAddress nvarchar(50)
AS
UPDATE dbo.dnn_EventLogConfig
SET 	LogTypeKey = @LogTypeKey,
	LogTypePortalID = @LogTypePortalID,
	LoggingIsActive = @LoggingIsActive,
	KeepMostRecent = @KeepMostRecent,
	EmailNotificationIsActive = @EmailNotificationIsActive,
	NotificationThreshold = @NotificationThreshold,
	NotificationThresholdTime = @NotificationThresholdTime,
	NotificationThresholdTimeType = @NotificationThresholdTimeType,
	MailFromAddress = @MailFromAddress,
	MailToAddress = @MailToAddress
WHERE	ID = @ID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddEventLogConfig]    Script Date: 10/05/2007 21:21:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddEventLogConfig]
	@LogTypeKey nvarchar(35),
	@LogTypePortalID int,
	@LoggingIsActive bit,
	@KeepMostRecent int,
	@EmailNotificationIsActive bit,
	@NotificationThreshold int,
	@NotificationThresholdTime int,
	@NotificationThresholdTimeType int,
	@MailFromAddress nvarchar(50),
	@MailToAddress nvarchar(50)
AS
INSERT INTO dbo.dnn_EventLogConfig
	(LogTypeKey,
	LogTypePortalID,
	LoggingIsActive,
	KeepMostRecent,
	EmailNotificationIsActive,
	NotificationThreshold,
	NotificationThresholdTime,
	NotificationThresholdTimeType,
	MailFromAddress,
	MailToAddress)
VALUES
	(@LogTypeKey,
	@LogTypePortalID,
	@LoggingIsActive,
	@KeepMostRecent,
	@EmailNotificationIsActive,
	@NotificationThreshold,
	@NotificationThresholdTime,
	@NotificationThresholdTimeType,
	@MailFromAddress,
	@MailToAddress)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetEventLogConfig]    Script Date: 10/05/2007 21:21:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetEventLogConfig]
	@ID int
AS
SELECT *
FROM dbo.dnn_EventLogConfig
WHERE (ID = @ID or @ID IS NULL)
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteEventLogConfig]    Script Date: 10/05/2007 21:21:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteEventLogConfig]
	@ID int
AS
DELETE FROM dbo.dnn_EventLogConfig
WHERE ID = @ID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddUrlTracking]    Script Date: 10/05/2007 21:21:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddUrlTracking]

@PortalID     int,
@Url          nvarchar(255),
@UrlType      char(1),
@LogActivity  bit,
@TrackClicks  bit,
@ModuleId     int,
@NewWindow    bit

as

insert into dnn_UrlTracking (
  PortalID,
  Url,
  UrlType,
  Clicks,
  LastClick,
  CreatedDate,
  LogActivity,
  TrackClicks,
  ModuleId,
  NewWindow
)
values (
  @PortalID,
  @Url,
  @UrlType,
  0,
  null,
  getdate(),
  @LogActivity,
  @TrackClicks,
  @ModuleId,
  @NewWindow
)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUrlTracking]    Script Date: 10/05/2007 21:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetUrlTracking]

@PortalID     int,
@Url          nvarchar(255),
@ModuleId     int

as

select *
from   dnn_UrlTracking
where  PortalID = @PortalID
and    Url = @Url
and    ((ModuleId = @ModuleId) or (ModuleId is null and @ModuleId is null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateUrlTracking]    Script Date: 10/05/2007 21:23:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateUrlTracking]

@PortalID     int,
@Url          nvarchar(255),
@LogActivity  bit,
@TrackClicks  bit,
@ModuleId     int,
@NewWindow    bit

as

update dnn_UrlTracking
set    LogActivity = @LogActivity,
       TrackClicks = @TrackClicks,
       NewWindow = @NewWindow
where  PortalID = @PortalID
and    Url = @Url
and    ((ModuleId = @ModuleId) or (ModuleId is null and @ModuleId is null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateUrlTrackingStats]    Script Date: 10/05/2007 21:23:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateUrlTrackingStats]

@PortalID     int,
@Url          nvarchar(255),
@ModuleId     int

as

update dnn_UrlTracking
set    Clicks = Clicks + 1,
       LastClick = getdate()
where  PortalID = @PortalID
and    Url = @Url
and    ((ModuleId = @ModuleId) or (ModuleId is null and @ModuleId is null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteUrlTracking]    Script Date: 10/05/2007 21:21:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteUrlTracking]

@PortalID     int,
@Url          nvarchar(255),
@ModuleID     int

as

delete
from   dnn_UrlTracking
where  PortalID = @PortalID
and    Url = @Url
and    ((ModuleId = @ModuleId) or (ModuleId is null and @ModuleId is null))
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateAffiliate]    Script Date: 10/05/2007 21:22:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateAffiliate]

@AffiliateId int,
@StartDate         datetime,
@EndDate           datetime,
@CPC               float,
@CPA               float

as

update dnn_Affiliates
set    StartDate   = @StartDate,
       EndDate     = @EndDate,
       CPC         = @CPC,
       CPA         = @CPA
where  AffiliateId = @AffiliateId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddAffiliate]    Script Date: 10/05/2007 21:21:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddAffiliate]

@VendorId      int,
@StartDate     datetime,
@EndDate       datetime,
@CPC           float,
@CPA           float

as

insert into dnn_Affiliates (
    VendorId,
    StartDate,
    EndDate,
    CPC,
    Clicks,
    CPA,
    Acquisitions
)
values (
    @VendorId,
    @StartDate,
    @EndDate,
    @CPC,
    0,
    @CPA,
    0
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateAffiliateStats]    Script Date: 10/05/2007 21:22:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateAffiliateStats]

@AffiliateId  int,
@Clicks       int,
@Acquisitions int

as

update dnn_Affiliates
set    Clicks = Clicks + @Clicks,
       Acquisitions = Acquisitions + @Acquisitions
where  VendorId = @AffiliateId 
and    ( StartDate < getdate() or StartDate is null ) 
and    ( EndDate > getdate() or EndDate is null )
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetAffiliates]    Script Date: 10/05/2007 21:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetAffiliates]

@VendorId int

as

select AffiliateId,
       StartDate,
       EndDate,
       CPC,
       Clicks,
       'CPCTotal' = Clicks * CPC,
       CPA,
       Acquisitions,
       'CPATotal' = Acquisitions * CPA
from   dnn_Affiliates
where  VendorId = @VendorId
order  by StartDate desc
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteAffiliate]    Script Date: 10/05/2007 21:21:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteAffiliate]

@AffiliateId int

as

delete
from   dnn_Affiliates
where  AffiliateId = @AffiliateId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUrls]    Script Date: 10/05/2007 21:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetUrls]

@PortalID     int

as

select *
from   dnn_Urls
where  PortalID = @PortalID
order by Url
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUrl]    Script Date: 10/05/2007 21:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetUrl]

@PortalID     int,
@Url          nvarchar(255)

as

select *
from   dnn_Urls
where  PortalID = @PortalID
and    Url = @Url
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddUrl]    Script Date: 10/05/2007 21:21:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddUrl]

@PortalID     int,
@Url          nvarchar(255)

as

insert into dnn_Urls (
  PortalID,
  Url
)
values (
  @PortalID,
  @Url
)
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteUrl]    Script Date: 10/05/2007 21:21:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteUrl]

@PortalID     int,
@Url          nvarchar(255)

as

delete
from   dnn_Urls
where  PortalID = @PortalID
and    Url = @Url
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateBanner]    Script Date: 10/05/2007 21:22:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateBanner]

@BannerId     int,
@BannerName   nvarchar(100),
@ImageFile    nvarchar(100),
@URL          nvarchar(255),
@Impressions  int,
@CPM          float,
@StartDate    datetime,
@EndDate      datetime,
@UserName     nvarchar(100),
@BannerTypeId int,
@Description  nvarchar(2000),
@GroupName    nvarchar(100),
@Criteria     bit,
@Width        int,
@Height       int

as

update dnn_Banners
set    ImageFile     = @ImageFile,
       BannerName    = @BannerName,
       URL           = @URL,
       Impressions   = @Impressions,
       CPM           = @CPM,
       StartDate     = @StartDate,
       EndDate       = @EndDate,
       CreatedByUser = @UserName,
       CreatedDate   = getdate(),
       BannerTypeId  = @BannerTypeId,
       Description   = @Description,
       GroupName     = @GroupName,
       Criteria      = @Criteria,
       Width         = @Width,
       Height        = @Height
where  BannerId = @BannerId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddBanner]    Script Date: 10/05/2007 21:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddBanner]

@BannerName    nvarchar(100),
@VendorId      int,
@ImageFile     nvarchar(100),
@URL           nvarchar(255),
@Impressions   int,
@CPM           float,
@StartDate     datetime,
@EndDate       datetime,
@UserName      nvarchar(100),
@BannerTypeId  int,
@Description   nvarchar(2000),
@GroupName     nvarchar(100),
@Criteria      bit,
@Width         int,
@Height        int

as

insert into dnn_Banners (
    VendorId,
    ImageFile,
    BannerName,
    URL,
    Impressions,
    CPM,
    Views,
    ClickThroughs,
    StartDate,
    EndDate,
    CreatedByUser,
    CreatedDate,
    BannerTypeId,
    Description,
    GroupName,
    Criteria,
    Width,
    Height
)
values (
    @VendorId,
    @ImageFile,
    @BannerName,
    @URL,
    @Impressions,
    @CPM,
    0,
    0,
    @StartDate,
    @EndDate,
    @UserName,
    getdate(),
    @BannerTypeId,
    @Description,
    @GroupName,
    @Criteria,
    @Width,
    @Height
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteBanner]    Script Date: 10/05/2007 21:21:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteBanner]

@BannerId int

as

delete
from dnn_Banners
where  BannerId = @BannerId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetBanners]    Script Date: 10/05/2007 21:21:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetBanners]

@VendorId int

as

select BannerId,
       BannerName,
       URL,
       Impressions,
       CPM,
       Views,
       ClickThroughs,
       StartDate,
       EndDate,
       BannerTypeId,
       Description,
       GroupName,
       Criteria,
       Width,
       Height
from   dnn_Banners
where  VendorId = @VendorId
order  by CreatedDate desc
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateBannerClickThrough]    Script Date: 10/05/2007 21:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateBannerClickThrough]

@BannerId int,
@VendorId int

as

update dnn_Banners
set    ClickThroughs = ClickThroughs + 1
where  BannerId = @BannerId
and    VendorId = @VendorId
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateBannerViews]    Script Date: 10/05/2007 21:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateBannerViews]

@BannerId  int, 
@StartDate datetime, 
@EndDate   datetime

as

update dnn_Banners
set    Views = Views + 1,
       StartDate = @StartDate,
       EndDate = @EndDate
where  BannerId = @BannerId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddProfile]    Script Date: 10/05/2007 21:21:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddProfile]

@UserId        int, 
@PortalId      int

as

insert into dnn_Profile (
  UserId,
  PortalId,
  ProfileData,
  CreatedDate
)
values (
  @UserId,
  @PortalId,
  '',
  getdate()
)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetProfile]    Script Date: 10/05/2007 21:22:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetProfile]

@UserId    int, 
@PortalId  int

as

select *
from   dnn_Profile
where  UserId = @UserId 
and    PortalId = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateProfile]    Script Date: 10/05/2007 21:22:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateProfile]

@UserId        int, 
@PortalId      int,
@ProfileData   ntext

as

update dnn_Profile
set    ProfileData = @ProfileData,
       CreatedDate = getdate()
where  UserId = @UserId
and    PortalId = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetAllProfiles]    Script Date: 10/05/2007 21:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetAllProfiles]
AS
SELECT * FROM dnn_Profile
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteSearchCommonWord]    Script Date: 10/05/2007 21:21:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteSearchCommonWord]
	@CommonWordID int
AS

DELETE FROM dbo.dnn_SearchCommonWords
WHERE
	[CommonWordID] = @CommonWordID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchCommonWordByID]    Script Date: 10/05/2007 21:22:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSearchCommonWordByID]
	@CommonWordID int
	
AS

SELECT
	[CommonWordID],
	[CommonWord],
	[Locale]
FROM
	dbo.dnn_SearchCommonWords
WHERE
	[CommonWordID] = @CommonWordID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddSearchCommonWord]    Script Date: 10/05/2007 21:21:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddSearchCommonWord]
	@CommonWord nvarchar(255),
	@Locale nvarchar(10)
AS

INSERT INTO dbo.dnn_SearchCommonWords (
	[CommonWord],
	[Locale]
) VALUES (
	@CommonWord,
	@Locale
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchCommonWordsByLocale]    Script Date: 10/05/2007 21:22:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSearchCommonWordsByLocale]
	@Locale nvarchar(10)
	
AS

SELECT
	[CommonWordID],
	[CommonWord],
	[Locale]
FROM
	dbo.dnn_SearchCommonWords
WHERE
	[Locale] = @Locale
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateSearchCommonWord]    Script Date: 10/05/2007 21:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateSearchCommonWord]
	@CommonWordID int, 
	@CommonWord nvarchar(255), 
	@Locale nvarchar(10) 
AS

UPDATE dbo.dnn_SearchCommonWords SET
	[CommonWord] = @CommonWord,
	[Locale] = @Locale
WHERE
	[CommonWordID] = @CommonWordID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortalAliasByPortalID]    Script Date: 10/05/2007 21:22:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetPortalAliasByPortalID]

@PortalID int

as

select *
from dbo.dnn_PortalAlias
where (PortalID = @PortalID or @PortalID = -1)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortalByAlias]    Script Date: 10/05/2007 21:22:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetPortalByAlias]

@HTTPAlias nvarchar(200)

as

select 'PortalId' = min(PortalId)
from dbo.dnn_PortalAlias
where  HTTPAlias = @HTTPAlias
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeletePortalAlias]    Script Date: 10/05/2007 21:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_DeletePortalAlias]
@PortalAliasID int

as

DELETE FROM dbo.dnn_PortalAlias 
WHERE PortalAliasID = @PortalAliasID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortalAliasByPortalAliasID]    Script Date: 10/05/2007 21:22:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetPortalAliasByPortalAliasID]

@PortalAliasID int

as

select *
from dbo.dnn_PortalAlias
where PortalAliasID = @PortalAliasID
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdatePortalAlias]    Script Date: 10/05/2007 21:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_UpdatePortalAlias]
@PortalAliasID int,
@PortalID int,
@HTTPAlias nvarchar(200)

as

UPDATE dbo.dnn_PortalAlias 
SET HTTPAlias = @HTTPAlias
WHERE PortalID = @PortalID
AND	  PortalAliasID = @PortalAliasID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortalAlias]    Script Date: 10/05/2007 21:22:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetPortalAlias]

@HTTPAlias nvarchar(200),
@PortalID int

as

select *
from dbo.dnn_PortalAlias
where HTTPAlias = @HTTPAlias 
and PortalID = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddPortalAlias]    Script Date: 10/05/2007 21:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_AddPortalAlias]

@PortalID int,
@HTTPAlias nvarchar(200)

as

INSERT INTO dbo.dnn_PortalAlias 
(PortalID, HTTPAlias)
VALUES
(@PortalID, @HTTPAlias)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdatePortalAliasOnInstall]    Script Date: 10/05/2007 21:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_UpdatePortalAliasOnInstall]

@PortalAlias nvarchar(200)

as

update dbo.dnn_PortalAlias 
set    HTTPAlias = @PortalAlias
where  HTTPAlias = '_default'
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetList]    Script Date: 10/05/2007 21:21:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetList]
	@ListName nvarchar(50),
	@ParentKey nvarchar(150),
	@DefinitionID int
AS

If @ParentKey = '' 
Begin
	Select DISTINCT 	
	E.[ListName],
	E.[Level],	
	E.[DefinitionID],
	E.[ParentID],	
	(SELECT MAX([SortOrder]) FROM dnn_Lists WHERE [ListName] = E.[ListName]) As [MaxSortOrder],
	(SELECT COUNT(EntryID) FROM dnn_Lists WHERE [ListName] = E.[ListName] AND ParentID = E.[ParentID]) As EntryCount,
	IsNull((SELECT [ListName] + '.' + [Value] + ':' FROM dnn_Lists WHERE [EntryID] = E.[ParentID]), '') + E.[ListName] As [Key],	
	IsNull((SELECT [ListName] + '.' + [Text] + ':' FROM dnn_Lists WHERE [EntryID] = E.[ParentID]), '') + E.[ListName] As [DisplayName],
	IsNull((SELECT [ListName] + '.' + [Value] FROM dnn_Lists WHERE [EntryID] = E.[ParentID]), '') As [ParentKey],
	IsNull((SELECT [ListName] + '.' + [Text] FROM dnn_Lists WHERE [EntryID] = E.[ParentID]), '') As [Parent],
	IsNull((SELECT [ListName] FROM dnn_Lists WHERE [EntryID] = E.[ParentID]),'') As [ParentList]
	From dnn_Lists E (nolock)
	where  ([ListName] = @ListName or @ListName='')
	and (DefinitionID = @DefinitionID or @DefinitionID = -1)
	Order By E.[Level],[DisplayName]
End
Else
Begin

	DECLARE @ParentListName nvarchar(50)
	DECLARE @ParentValue nvarchar(100)
	SET @ParentListName = LEFT(@ParentKey, CHARINDEX( '.', @ParentKey) - 1)
	SET @ParentValue = RIGHT(@ParentKey, LEN(@ParentKey) -  CHARINDEX( '.', @ParentKey))
	Select DISTINCT 	
	E.[ListName],
	E.[Level],	
	E.[DefinitionID],
	E.[ParentID],	
	(SELECT MAX([SortOrder]) FROM dnn_Lists WHERE [ListName] = E.[ListName]) As [MaxSortOrder],
	(SELECT COUNT(EntryID) FROM dnn_Lists WHERE [ListName] = E.[ListName] AND ParentID = E.[ParentID]) As EntryCount,
	IsNull((SELECT [ListName] + '.' + [Value] + ':' FROM dnn_Lists WHERE [EntryID] = E.[ParentID]), '') + E.[ListName] As [Key],	
	IsNull((SELECT [ListName] + '.' + [Text] + ':' FROM dnn_Lists WHERE [EntryID] = E.[ParentID]), '') + E.[ListName] As [DisplayName],
	IsNull((SELECT [ListName] + '.' + [Value] FROM dnn_Lists WHERE [EntryID] = E.[ParentID]), '') As [ParentKey],
	IsNull((SELECT [ListName] + '.' + [Text] FROM dnn_Lists WHERE [EntryID] = E.[ParentID]), '') As [Parent],
	IsNull((SELECT [ListName] FROM dnn_Lists WHERE [EntryID] = E.[ParentID]),'') As [ParentList]
	
	From dnn_Lists E (nolock)
	where  [ListName] = @ListName And
	[ParentID] = (SELECT [EntryID] From dnn_Lists Where [ListName] = @ParentListName And [Value] = @ParentValue)	
	Order By E.[Level], [DisplayName]

End
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteList]    Script Date: 10/05/2007 21:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_DeleteList]

@ListName nvarchar(50),
@ParentKey nvarchar(150)

as

DECLARE @EntryID int

If @ParentKey = '' 
Begin
	-- need to store entries which to be deleted to clean up their sub entries
	DECLARE allentry_cursor CURSOR FOR
	SELECT [EntryID] FROM dnn_Lists Where  [ListName] = @ListName	
	-- then delete their sub entires
	OPEN allentry_cursor
	FETCH NEXT FROM allentry_cursor INTO @EntryID
	While @@FETCH_STATUS = 0
	Begin	
		Delete dnn_Lists Where [ParentID] = @EntryID
   		FETCH NEXT FROM allentry_cursor INTO @EntryID
	End
	-- Delete entries belong to this list
	Delete dnn_Lists
	Where  [ListName] = @ListName
End
Else
Begin

	DECLARE @ParentListName nvarchar(50)
	DECLARE @ParentValue nvarchar(100)
	SET @ParentListName = LEFT(@ParentKey, CHARINDEX( '.', @ParentKey) - 1)
	SET @ParentValue = RIGHT(@ParentKey, LEN(@ParentKey) -  CHARINDEX( '.', @ParentKey))

	-- need to store entries which to be deleted to clean up their sub entries
	DECLARE selentry_cursor CURSOR FOR
	SELECT [EntryID] FROM dnn_Lists Where  [ListName] = @ListName And
	[ParentID] = (SELECT [EntryID] From dnn_Lists Where [ListName] = @ParentListName And [Value] = @ParentValue)
	-- delete their sub entires
	OPEN selentry_cursor
	FETCH NEXT FROM selentry_cursor INTO @EntryID
	While @@FETCH_STATUS = 0
	Begin	
		Delete dnn_Lists Where [ParentID] = @EntryID
   		FETCH NEXT FROM selentry_cursor INTO @EntryID
	End
	-- delete entry list
	Delete dnn_Lists 
	where  [ListName] = @ListName And
	[ParentID] = (SELECT [EntryID] From dnn_Lists Where [ListName] = @ParentListName And [Value] = @ParentValue)	
End
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateListSortOrder]    Script Date: 10/05/2007 21:22:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateListSortOrder]
(
@EntryID	int, 
@MoveUp		bit
)
AS
DECLARE @EntryListName nvarchar(50)
DECLARE @ParentID int
DECLARE @CurrentSortValue int
DECLARE @ReplaceSortValue int
-- Get the current sort order
SELECT @CurrentSortValue = [SortOrder], @EntryListName = [ListName], @ParentID = [ParentID] FROM dnn_Lists (nolock) WHERE [EntryID] = @EntryID
-- Move the item up or down?
IF (@MoveUp = 1)
  BEGIN
    IF (@CurrentSortValue != 1) -- we rearrange sort order only if list enable sort order - sortorder >= 1
      BEGIN
        SET @ReplaceSortValue = @CurrentSortValue - 1
        UPDATE dnn_Lists SET [SortOrder] = @CurrentSortValue WHERE [SortOrder] = @ReplaceSortValue And [ListName] = @EntryListName And [ParentID] = @ParentID
        UPDATE dnn_Lists SET [SortOrder] = @ReplaceSortValue WHERE [EntryID] = @EntryID
      END
  END
ELSE
  BEGIN
    IF (@CurrentSortValue < (SELECT MAX([SortOrder]) FROM dnn_Lists))
    BEGIN
      SET @ReplaceSortValue = @CurrentSortValue + 1
      UPDATE dnn_Lists SET [SortOrder] = @CurrentSortValue WHERE SortOrder = @ReplaceSortValue And [ListName] = @EntryListName  And [ParentID] = @ParentID
      UPDATE dnn_Lists SET [SortOrder] = @ReplaceSortValue WHERE EntryID = @EntryID
    END
  END
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateListEntry]    Script Date: 10/05/2007 21:22:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateListEntry]

@EntryID int, 
@ListName nvarchar(50), 
@Value nvarchar(100), 
@Text nvarchar(150), 
@Description nvarchar(500)

AS

UPDATE dnn_Lists
SET	
	[ListName] = @ListName,
	[Value] = @Value,
	[Text] = @Text,	
	[Description] = @Description
WHERE 	[EntryID] = @EntryID
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteListEntryByID]    Script Date: 10/05/2007 21:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_DeleteListEntryByID]

@EntryId   int,
@DeleteChild bit

as

Delete
From dnn_Lists
Where  [EntryID] = @EntryID

If @DeleteChild = 1
Begin
	Delete 
	From dnn_Lists
	Where [ParentID] = @EntryID
End
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetListEntries]    Script Date: 10/05/2007 21:21:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetListEntries]

@ListName nvarchar(50),
@ParentKey nvarchar(150),
@EntryID int,
@DefinitionID int,
@Value nvarchar(200)

as
IF @ParentKey=''
Begin
	select 
	E.[EntryID],
	E.[ListName],
	E.[Value],
	E.[Text],
	E.[Level],
	E.[SortOrder],
	E.[DefinitionID],
	E.[ParentID],
	E.[Description], 	
	E.[ListName] + '.' + E.[Value] As [Key],	
	E.[ListName] + '.' + E.[Text] As [DisplayName],
	IsNull((SELECT [ListName] + '.' + [Value] FROM dnn_Lists WHERE [EntryID] = E.[ParentID]), '') As [ParentKey],
	IsNull((SELECT [ListName] + '.' + [Text] FROM dnn_Lists WHERE [EntryID] = E.[ParentID]), '') As [Parent],
	IsNull((SELECT [ListName] FROM dnn_Lists WHERE [EntryID] = E.[ParentID]),'') As [ParentList],		
	(SELECT COUNT(DISTINCT [ParentID]) FROM dnn_Lists (nolock) WHERE [ParentID] = E.[EntryID]) As HasChildren
	From dnn_Lists E (nolock)
	Where (E.[ListName] = @ListName or @ListName='')
	and (E.[DefinitionID]=@DefinitionID or @DefinitionID = -1)
	and (E.[EntryID]=@EntryID or @EntryID = -1)
	and (E.[Value]=@Value or @Value = '')
	Order By E.[Level], E.[ListName], E.[SortOrder], E.[Text]
End
Else
Begin

	DECLARE @ParentListName nvarchar(50)
	DECLARE @ParentValue nvarchar(100)
	SET @ParentListName = LEFT(@ParentKey, CHARINDEX( '.', @ParentKey) - 1)
	SET @ParentValue = RIGHT(@ParentKey, LEN(@ParentKey) -  CHARINDEX( '.', @ParentKey))
	select 
	E.[EntryID],
	E.[ListName],
	E.[Value],
	E.[Text],
	E.[Level],
	E.[SortOrder],
	E.[DefinitionID],
	E.[ParentID],
	E.[Description], 	
	E.[ListName] + '.' + E.[Value] As [Key],	
	E.[ListName] + '.' + E.[Text] As [DisplayName],
	IsNull((SELECT [ListName] + '.' + [Value] FROM dnn_Lists WHERE [EntryID] = E.[ParentID]), '') As [ParentKey],
	IsNull((SELECT [ListName] + '.' + [Text] FROM dnn_Lists WHERE [EntryID] = E.[ParentID]), '') As [Parent],
	IsNull((SELECT [ListName] FROM dnn_Lists WHERE [EntryID] = E.[ParentID]),'') As [ParentList],	
	(SELECT COUNT(DISTINCT [ParentID]) FROM dnn_Lists (nolock) WHERE [ParentID] = E.[EntryID]) As HasChildren
	From dnn_Lists E (nolock)
	where  [ListName] = @ListName 
	and (E.[DefinitionID]=@DefinitionID or @DefinitionID = -1)
	and (E.[EntryID]=@EntryID or @EntryID = -1)
	and (E.[Value]=@Value or @Value = '')
	and [ParentID] = (SELECT [EntryID] From dnn_Lists Where [ListName] = @ParentListName And [Value] = @ParentValue)
	Order By E.[Level], E.[ListName], E.[SortOrder], E.[Text]

End
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddListEntry]    Script Date: 10/05/2007 21:21:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_AddListEntry]

@ListName nvarchar(50), 
@Value nvarchar(100), 
@Text nvarchar(150), 
@ParentKey nvarchar(150), 
@EnableSortOrder bit,
@DefinitionID int, 
@Description nvarchar(500)

as

DECLARE @ParentID int
DECLARE @Level int
DECLARE @SortOrder int

IF @EnableSortOrder = 1
BEGIN
	SET @SortOrder = IsNull((SELECT MAX ([SortOrder]) From dnn_Lists Where [ListName] = @ListName), 0) + 1
END
ELSE
BEGIN
	SET @SortOrder = 0
END


If @ParentKey <> ''
BEGIN
	DECLARE @ParentListName nvarchar(50)
	DECLARE @ParentValue nvarchar(100)
	SET @ParentListName = LEFT(@ParentKey, CHARINDEX( '.', @ParentKey) - 1)
	SET @ParentValue = RIGHT(@ParentKey, LEN(@ParentKey) -  CHARINDEX( '.', @ParentKey))
	SELECT @ParentID = [EntryID], @Level = ([Level] + 1) From dnn_Lists Where [ListName] = @ParentListName And [Value] = @ParentValue

	Print 'ParentListName: ' + @ParentListName
	Print 'ParentValue: ' + @ParentValue
	--Print @ParentID
END
ELSE
BEGIN
	SET @ParentID = 0
	SET @Level = 0
END

-- Check if this entry exists
If EXISTS (SELECT [EntryID] From dnn_Lists WHERE [ListName] = @ListName And [Value] = @Value And [Text] = @Text And [ParentID] = @ParentID)
BEGIN
select -1
Return 
END

insert into dnn_Lists 
	(
  	[ListName],
	[Value],
	[Text],
	[Level],
	[SortOrder],
	[DefinitionID],
	[ParentID],
	[Description]
	)
values (
	@ListName,
	@Value,
	@Text,
	@Level,
	@SortOrder,
	@DefinitionID,
	@ParentID,
	@Description  	
	)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateFolder]    Script Date: 10/05/2007 21:22:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateFolder]

	@PortalID int,
	@FolderID int,
	@FolderPath varchar(300),
	@StorageLocation int,
	@IsProtected bit,
        @IsCached bit,
        @LastUpdated datetime

AS

UPDATE dnn_Folders
SET    FolderPath = @FolderPath,
       StorageLocation = @StorageLocation,
       IsProtected = @IsProtected,
       IsCached = @IsCached,
       LastUpdated = @LastUpdated
WHERE  ((PortalID = @PortalID) OR (PortalID IS Null AND @PortalID IS Null))
AND    FolderID = @FolderID
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteFolder]    Script Date: 10/05/2007 21:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteFolder]
	@PortalID int,
	@FolderPath varchar(300)
AS
	DELETE FROM dnn_Folders
	WHERE ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
	AND FolderPath = @FolderPath
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetFolderByFolderPath]    Script Date: 10/05/2007 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetFolderByFolderPath]
	@PortalID int,
	@FolderPath nvarchar(300)
AS
SELECT *
	FROM dbo.dnn_Folders
	WHERE ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
		AND (FolderPath = @FolderPath)
	ORDER BY FolderPath
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetFolders]    Script Date: 10/05/2007 21:21:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetFolders]
	@PortalID int,
	@FolderID int,
	@FolderPath nvarchar(300)
AS
SELECT *
	FROM dnn_Folders
	WHERE ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
		AND (FolderID = @FolderID or @FolderID = -1)
		AND (FolderPath = @FolderPath or @FolderPath = '')
	ORDER BY FolderPath
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddFolder]    Script Date: 10/05/2007 21:21:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddFolder]

	@PortalID int,
	@FolderPath varchar(300),
	@StorageLocation int,
	@IsProtected bit,
	@IsCached bit,
	@LastUpdated datetime

AS

INSERT INTO dnn_Folders (
  PortalID, 
  FolderPath, 
  StorageLocation, 
  IsProtected, 
  IsCached, 
  LastUpdated
)
VALUES (
  @PortalID, 
  @FolderPath, 
  @StorageLocation, 
  @IsProtected, 
  @IsCached, 
  @LastUpdated
)

SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetFolderByFolderID]    Script Date: 10/05/2007 21:21:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetFolderByFolderID]
	@PortalID int,
	@FolderID int
AS
SELECT *
	FROM dbo.dnn_Folders
	WHERE ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
		AND (FolderID = @FolderID)
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteTabModuleSettings]    Script Date: 10/05/2007 21:21:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteTabModuleSettings]
@TabModuleId      int
as

DELETE FROM dnn_TabModuleSettings 
WHERE TabModuleId = @TabModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddTabModuleSetting]    Script Date: 10/05/2007 21:21:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddTabModuleSetting]

@TabModuleId   int,
@SettingName   nvarchar(50),
@SettingValue  nvarchar(2000)

as

insert into dnn_TabModuleSettings ( 
  TabModuleId,
  SettingName, 
  SettingValue 
) 
values ( 
  @TabModuleId,
  @SettingName, 
  @SettingValue 
)
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteTabModuleSetting]    Script Date: 10/05/2007 21:21:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteTabModuleSetting]
@TabModuleId      int,
@SettingName   nvarchar(50)
as

DELETE FROM dnn_TabModuleSettings 
WHERE TabModuleId = @TabModuleId
AND SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateTabModuleSetting]    Script Date: 10/05/2007 21:23:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateTabModuleSetting]

@TabModuleId   int,
@SettingName   nvarchar(50),
@SettingValue  nvarchar(2000)

as

update dnn_TabModuleSettings
set    SettingValue = @SettingValue
where  TabModuleId = @TabModuleId
and    SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTabModuleSettings]    Script Date: 10/05/2007 21:22:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetTabModuleSettings]

@TabModuleId int

as

select SettingName,
       SettingValue
from   dnn_TabModuleSettings 
where  TabModuleId = @TabModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTabModuleSetting]    Script Date: 10/05/2007 21:22:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetTabModuleSetting]

@TabModuleId int,
@SettingName nvarchar(50)

as

select SettingName,
       SettingValue
from   dnn_TabModuleSettings 
where  TabModuleId = @TabModuleId
and    SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateScheduleHistory]    Script Date: 10/05/2007 21:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateScheduleHistory]
@ScheduleHistoryID int,
@EndDate datetime,
@Succeeded bit,
@LogNotes ntext,
@NextStart datetime
AS
UPDATE dbo.dnn_ScheduleHistory
SET	EndDate = @EndDate,
	Succeeded = @Succeeded,
	LogNotes = @LogNotes,
	NextStart = @NextStart
WHERE ScheduleHistoryID = @ScheduleHistoryID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddScheduleHistory]    Script Date: 10/05/2007 21:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddScheduleHistory]
@ScheduleID int,
@StartDate datetime,
@Server varchar(150)
AS
INSERT INTO dbo.dnn_ScheduleHistory
(ScheduleID,
StartDate,
Server)
VALUES
(@ScheduleID,
@StartDate,
@Server)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUserProfile]    Script Date: 10/05/2007 21:22:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetUserProfile]

	@UserId int

AS
SELECT
	ProfileID,
	UserID,
	PropertyDefinitionID,
	'PropertyValue' = case when (PropertyValue Is Null) then PropertyText else PropertyValue end,
	Visibility,
	LastUpdatedDate
	FROM	dnn_UserProfile
	WHERE   UserId = @UserId
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateUserProfileProperty]    Script Date: 10/05/2007 21:23:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateUserProfileProperty]

	@ProfileID				int,
	@UserID					int,
	@PropertyDefinitionID	int,
	@PropertyValue			ntext,
	@Visibility				int,
	@LastUpdatedDate		datetime

AS
IF @ProfileID IS NULL OR @ProfileID = -1
	-- Try the UserID/PropertyDefinitionID to see if the Profile property exists
	SELECT @ProfileID = ProfileID
		FROM   dnn_UserProfile
		WHERE  UserID = @UserID AND PropertyDefinitionID = @PropertyDefinitionID
 
IF @ProfileID IS NOT NULL
	-- Update Property
	BEGIN
		UPDATE dnn_UserProfile
			SET PropertyValue = case when (DATALENGTH(@PropertyValue) > 7500) then NULL else @PropertyValue end,
				PropertyText = case when (DATALENGTH(@PropertyValue) > 7500) then @PropertyValue else NULL end,
				Visibility = @Visibility,
				LastUpdatedDate = @LastUpdatedDate
			WHERE  ProfileID = @ProfileID
		SELECT @ProfileID
	END
ELSE
	-- Insert New Property
	BEGIN
		INSERT INTO dnn_UserProfile (
			UserID,
			PropertyDefinitionID,
			PropertyValue,
			PropertyText,
			Visibility,
			LastUpdatedDate
		  )
		VALUES (
			@UserID,
			@PropertyDefinitionID,
			case when (DATALENGTH(@PropertyValue) > 7500) then NULL else @PropertyValue end,
			case when (DATALENGTH(@PropertyValue) > 7500) then @PropertyValue else NULL end,
			@Visibility,
			@LastUpdatedDate
		  )

	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteVendorClassifications]    Script Date: 10/05/2007 21:21:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteVendorClassifications]

@VendorId  int

as

delete
from dnn_VendorClassification
where  VendorId = @VendorId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddVendorClassification]    Script Date: 10/05/2007 21:21:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddVendorClassification]

@VendorId           int,
@ClassificationId   int

as

insert into dnn_VendorClassification ( 
  VendorId,
  ClassificationId
)
values (
  @VendorId,
  @ClassificationId
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_ListSearchItemWordPosition]    Script Date: 10/05/2007 21:22:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_ListSearchItemWordPosition]
AS

SELECT
	[SearchItemWordPositionID],
	[SearchItemWordID],
	[ContentPosition]
FROM
	dbo.dnn_SearchItemWordPosition
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchItemWordPosition]    Script Date: 10/05/2007 21:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSearchItemWordPosition]
	@SearchItemWordPositionID int
	
AS

SELECT
	[SearchItemWordPositionID],
	[SearchItemWordID],
	[ContentPosition]
FROM
	dbo.dnn_SearchItemWordPosition
WHERE
	[SearchItemWordPositionID] = @SearchItemWordPositionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateSearchItemWordPosition]    Script Date: 10/05/2007 21:22:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateSearchItemWordPosition]
	@SearchItemWordPositionID int, 
	@SearchItemWordID int, 
	@ContentPosition int 
AS

UPDATE dbo.dnn_SearchItemWordPosition SET
	[SearchItemWordID] = @SearchItemWordID,
	[ContentPosition] = @ContentPosition
WHERE
	[SearchItemWordPositionID] = @SearchItemWordPositionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteSearchItemWordPosition]    Script Date: 10/05/2007 21:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteSearchItemWordPosition]
	@SearchItemWordPositionID int
AS

DELETE FROM dbo.dnn_SearchItemWordPosition
WHERE
	[SearchItemWordPositionID] = @SearchItemWordPositionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchItemWordPositionBySearchItemWord]    Script Date: 10/05/2007 21:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSearchItemWordPositionBySearchItemWord]
	@SearchItemWordID int
AS

SELECT
	[SearchItemWordPositionID],
	[SearchItemWordID],
	[ContentPosition]
FROM
	dbo.dnn_SearchItemWordPosition
WHERE
	[SearchItemWordID]=@SearchItemWordID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddSearchItemWordPosition]    Script Date: 10/05/2007 21:21:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[dnn_AddSearchItemWordPosition]
	@SearchItemWordID int,
	@ContentPositions varChar(2000)
AS

	SET NOCOUNT ON

	DECLARE @TempList table
	(
		ItemWordID int,
		Position int
	)

	DECLARE @Position varchar(10), @Pos int

	SET @ContentPositions = LTRIM(RTRIM(@ContentPositions))+ ','
	SET @Pos = CHARINDEX(',', @ContentPositions, 1)

	IF REPLACE(@ContentPositions, ',', '') <> ''
	BEGIN
		WHILE @Pos > 0
		BEGIN
			SET @Position = LTRIM(RTRIM(LEFT(@ContentPositions, @Pos - 1)))
			IF @Position <> ''
			BEGIN
				INSERT INTO @TempList (ItemWordID, Position) VALUES (@SearchItemWordID, CAST(@Position AS int)) 
			END
			SET @ContentPositions = RIGHT(@ContentPositions, LEN(@ContentPositions) - @Pos)
			SET @Pos = CHARINDEX(',', @ContentPositions, 1)

		END
	END	

	INSERT INTO dbo.dnn_SearchItemWordPosition (
		[SearchItemWordID],
		[ContentPosition]) 
	SELECT ItemWordID, Position FROM @TempList
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteSystemMessage]    Script Date: 10/05/2007 21:21:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteSystemMessage]

@PortalID     int,
@MessageName  nvarchar(50)

as

delete
from   dnn_SystemMessages
where  PortalID = @PortalID
and    MessageName = @MessageName
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddSystemMessage]    Script Date: 10/05/2007 21:21:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddSystemMessage]

@PortalID     int,
@MessageName  nvarchar(50),
@MessageValue ntext

as

insert into dnn_SystemMessages (
  PortalID,
  MessageName,
  MessageValue
)
values (
  @PortalID,
  @MessageName,
  @MessageValue
)
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateSystemMessage]    Script Date: 10/05/2007 21:22:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdateSystemMessage]

@PortalID     int,
@MessageName  nvarchar(50),
@MessageValue ntext

as

update dnn_SystemMessages
set    MessageValue = @MessageValue
where  ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
and    MessageName = @MessageName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSystemMessage]    Script Date: 10/05/2007 21:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSystemMessage]

@PortalID     int,
@MessageName  nvarchar(50)

as

select MessageValue
from   dnn_SystemMessages
where  ((PortalID = @PortalID) or (PortalID is null and @PortalID is null)) 
and    MessageName = @MessageName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSystemMessages]    Script Date: 10/05/2007 21:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSystemMessages]

as

select MessageName
from   dnn_SystemMessages
where  PortalID is null
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteSearchWord]    Script Date: 10/05/2007 21:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeleteSearchWord]
	@SearchWordsID int
AS

DELETE FROM dbo.dnn_SearchWord
WHERE
	[SearchWordsID] = @SearchWordsID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchWords]    Script Date: 10/05/2007 21:22:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSearchWords]
AS

SELECT
	[SearchWordsID],
	[Word],
	[HitCount]
FROM
	dbo.dnn_SearchWord
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateSearchWord]    Script Date: 10/05/2007 21:22:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdateSearchWord]
	@SearchWordsID int, 
	@Word nvarchar(100), 
	@IsCommon bit, 
	@HitCount int 
AS

UPDATE dbo.dnn_SearchWord SET
	[Word] = @Word,
	[IsCommon] = @IsCommon,
	[HitCount] = @HitCount
WHERE
	[SearchWordsID] = @SearchWordsID
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddSearchWord]    Script Date: 10/05/2007 21:21:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddSearchWord]
	@Word nvarchar(100)
 
AS

DECLARE @id int
SELECT @id = SearchWordsID 
	FROM dnn_SearchWord
	WHERE Word = @Word
 

IF @id IS NULL
	BEGIN
		INSERT INTO dnn_SearchWord (
			[Word],
			[IsCommon],
			[HitCount]
			) 
		VALUES (
			@Word,
			0,
			1
		)

		SELECT SCOPE_IDENTITY()
	END
ELSE
	SELECT @id
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSearchWordByID]    Script Date: 10/05/2007 21:22:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSearchWordByID]
	@SearchWordsID int
	
AS

SELECT
	[SearchWordsID],
	[Word],
	[IsCommon],
	[HitCount]
FROM
	dbo.dnn_SearchWord
WHERE
	[SearchWordsID] = @SearchWordsID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetHostSettings]    Script Date: 10/05/2007 21:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetHostSettings]
as
select SettingName,
       SettingValue,
       SettingIsSecure
from dnn_HostSettings
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetHostSetting]    Script Date: 10/05/2007 21:21:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetHostSetting]

@SettingName nvarchar(50)

as

select SettingValue
from dnn_HostSettings
where  SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddHostSetting]    Script Date: 10/05/2007 21:21:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_AddHostSetting]

@SettingName   nvarchar(50),
@SettingValue  nvarchar(256),
@SettingIsSecure bit

as

insert into dnn_HostSettings (
  SettingName,
  SettingValue,
  SettingIsSecure
) 
values (
  @SettingName,
  @SettingValue,
  @SettingIsSecure
)
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateHostSetting]    Script Date: 10/05/2007 21:22:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_UpdateHostSetting]

@SettingName   nvarchar(50),
@SettingValue  nvarchar(256),
@SettingIsSecure bit

as

update dnn_HostSettings
set    SettingValue = @SettingValue, SettingIsSecure = @SettingIsSecure
where  SettingName = @SettingName
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddPortalInfo]    Script Date: 10/05/2007 21:21:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddPortalInfo]
	@PortalName         nvarchar(128),
	@Currency           char(3),
	@ExpiryDate         datetime,
	@HostFee            money,
	@HostSpace          int,
	@PageQuota          int,
	@UserQuota          int,
	@SiteLogHistory     int,
	@HomeDirectory		varchar(100)

as
DECLARE @PortalID int

insert into dnn_Portals (
  PortalName,
  ExpiryDate,
  UserRegistration,
  BannerAdvertising,
  Currency,
  HostFee,
  HostSpace,
  PageQuota,
  UserQuota,
  Description,
  KeyWords,
  SiteLogHistory,
  HomeDirectory
)
values (
  @PortalName,
  @ExpiryDate,
  0,
  0,
  @Currency,
  @HostFee,
  @HostSpace,
  @PageQuota,
  @UserQuota,
  @PortalName,
  @PortalName,
  @SiteLogHistory,
  @HomeDirectory
)

SET @PortalID = SCOPE_IDENTITY()

IF @HomeDirectory = ''
BEGIN
	UPDATE dnn_Portals SET HomeDirectory = 'Portals/' + convert(varchar(10), @PortalID) WHERE PortalID = @PortalID
END

SELECT @PortalID
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdatePortalSetup]    Script Date: 10/05/2007 21:22:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_UpdatePortalSetup]

@PortalId            int,
@AdministratorId     int,
@AdministratorRoleId int,
@RegisteredRoleId    int,
@SplashTabId         int,
@HomeTabId           int,
@LoginTabId          int,
@UserTabId           int,
@AdminTabId          int

as

update dnn_Portals
set    AdministratorId = @AdministratorId, 
       AdministratorRoleId = @AdministratorRoleId, 
       RegisteredRoleId = @RegisteredRoleId,
       SplashTabId = @SplashTabId,
       HomeTabId = @HomeTabId,
       LoginTabId = @LoginTabId,
       UserTabId = @UserTabId,
       AdminTabId = @AdminTabId
where  PortalId = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortalCount]    Script Date: 10/05/2007 21:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPortalCount]

AS
SELECT COUNT(*)
FROM dnn_Portals
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdatePortalInfo]    Script Date: 10/05/2007 21:22:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdatePortalInfo]

	@PortalId           int,
	@PortalName         nvarchar(128),
	@LogoFile           nvarchar(50),
	@FooterText         nvarchar(100),
	@ExpiryDate         datetime,
	@UserRegistration   int,
	@BannerAdvertising  int,
	@Currency           char(3),
	@AdministratorId    int,
	@HostFee            money,
	@HostSpace          int,
	@PageQuota          int,
	@UserQuota          int,
	@PaymentProcessor   nvarchar(50),
	@ProcessorUserId    nvarchar(50),
	@ProcessorPassword  nvarchar(50),
	@Description        nvarchar(500),
	@KeyWords           nvarchar(500),
	@BackgroundFile     nvarchar(50),
	@SiteLogHistory     int,
	@SplashTabId          int,
	@HomeTabId          int,
	@LoginTabId         int,
	@UserTabId          int,
	@DefaultLanguage    nvarchar(10),
	@TimeZoneOffset	    int,
	@HomeDirectory		varchar(100)

as
update dbo.dnn_Portals
set    PortalName = @PortalName,
       LogoFile = @LogoFile,
       FooterText = @FooterText,
       ExpiryDate = @ExpiryDate,
       UserRegistration = @UserRegistration,
       BannerAdvertising = @BannerAdvertising,
       Currency = @Currency,
       AdministratorId = @AdministratorId,
       HostFee = @HostFee,
       HostSpace = @HostSpace,
       PageQuota = @PageQuota,
       UserQuota = @UserQuota,
       PaymentProcessor = @PaymentProcessor,
       ProcessorUserId = @ProcessorUserId,
       ProcessorPassword = @ProcessorPassword,
       Description = @Description,
       KeyWords = @KeyWords,
       BackgroundFile = @BackgroundFile,
       SiteLogHistory = @SiteLogHistory,
       SplashTabId = @SplashTabId,
       HomeTabId = @HomeTabId,
       LoginTabId = @LoginTabId,
       UserTabId = @UserTabId,
       DefaultLanguage = @DefaultLanguage,
       TimeZoneOffset = @TimeZoneOffset,
       HomeDirectory = @HomeDirectory
where  PortalId = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPermissionsByFolderPath]    Script Date: 10/05/2007 21:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPermissionsByFolderPath]
	@PortalID int,
	@FolderPath varchar(300)
AS

SELECT
	P.[PermissionID],
	P.[PermissionCode],
	P.[PermissionKey],
	P.[PermissionName]
FROM
	dbo.dnn_Permission P
WHERE
	P.PermissionCode = 'SYSTEM_FOLDER'
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPermission]    Script Date: 10/05/2007 21:22:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPermission]
	@PermissionID int
AS

SELECT
	[PermissionID],
	[PermissionCode],
	[ModuleDefID],
	[PermissionKey],
	[PermissionName]
FROM
	dbo.dnn_Permission
WHERE
	[PermissionID] = @PermissionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPermissionsByModuleDefID]    Script Date: 10/05/2007 21:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPermissionsByModuleDefID]
	@ModuleDefID int
AS
SELECT
	P.[PermissionID],
	P.[PermissionCode],
	P.[ModuleDefID],
	P.[PermissionKey],
	P.[PermissionName]
FROM
	dnn_Permission P
WHERE
	P.ModuleDefID = @ModuleDefID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPermissionByCodeAndKey]    Script Date: 10/05/2007 21:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPermissionByCodeAndKey]
	@PermissionCode varchar(50),
	@PermissionKey varchar(20)
AS

SELECT
	P.[PermissionID],
	P.[PermissionCode],
	P.[ModuleDefID],
	P.[PermissionKey],
	P.[PermissionName]
FROM
	dbo.dnn_Permission P
WHERE
	(P.PermissionCode = @PermissionCode or @PermissionCode IS NULL)
	AND
	(P.PermissionKey = @PermissionKey or @PermissionKey IS NULL)
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeletePermission]    Script Date: 10/05/2007 21:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_DeletePermission]
	@PermissionID int
AS

DELETE FROM dbo.dnn_Permission
WHERE
	[PermissionID] = @PermissionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPermissionsByTabID]    Script Date: 10/05/2007 21:22:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPermissionsByTabID]
	@TabID int
AS

SELECT
	P.[PermissionID],
	P.[PermissionCode],
	P.[PermissionKey],
	P.[ModuleDefID],
	P.[PermissionName]
FROM
	dbo.dnn_Permission P
WHERE
	P.PermissionCode = 'SYSTEM_TAB'
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddPermission]    Script Date: 10/05/2007 21:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddPermission]
	@ModuleDefID int,
	@PermissionCode varchar(50),
	@PermissionKey varchar(20),
	@PermissionName varchar(50)
AS

INSERT INTO dbo.dnn_Permission (
	[ModuleDefID],
	[PermissionCode],
	[PermissionKey],
	[PermissionName]
) VALUES (
	@ModuleDefID,
	@PermissionCode,
	@PermissionKey,
	@PermissionName
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdatePermission]    Script Date: 10/05/2007 21:22:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_UpdatePermission]
	@PermissionID int, 
	@PermissionCode varchar(50),
	@ModuleDefID int, 
	@PermissionKey varchar(20), 
	@PermissionName varchar(50) 
AS

UPDATE dbo.dnn_Permission SET
	[ModuleDefID] = @ModuleDefID,
	[PermissionCode] = @PermissionCode,
	[PermissionKey] = @PermissionKey,
	[PermissionName] = @PermissionName
WHERE
	[PermissionID] = @PermissionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSkins]    Script Date: 10/05/2007 21:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetSkins]

@PortalID		int

AS
SELECT *
FROM	dnn_Skins
WHERE   (PortalID = @PortalID) OR (PortalID is null And @PortalId Is Null)
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddSkin]    Script Date: 10/05/2007 21:21:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_AddSkin]

@SkinRoot               nvarchar(50),
@PortalID		int,
@SkinType               int,
@SkinSrc                nvarchar(200)

as

insert into dnn_Skins (
  SkinRoot,
  PortalID,
  SkinType,
  SkinSrc
)
values (
  @SkinRoot,
  @PortalID,
  @SkinType,
  @SkinSrc
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSkin]    Script Date: 10/05/2007 21:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetSkin]

@SkinRoot               nvarchar(50),
@PortalID		int,
@SkinType               int

as
	
select *
from	dnn_Skins
where   SkinRoot = @SkinRoot
and     SkinType = @SkinType
and     ( PortalID is null or PortalID = @PortalID )
order by PortalID desc
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteSkin]    Script Date: 10/05/2007 21:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteSkin]

@SkinRoot               nvarchar(50),
@PortalID		int,
@SkinType               int

as

delete
from   dnn_Skins
where   SkinRoot = @SkinRoot
and     SkinType = @SkinType
and    ((PortalID is null and @PortalID is null) or (PortalID = @PortalID))
GO
/****** Object:  StoredProcedure [dbo].[dnn_UpdateDesktopModule]    Script Date: 10/05/2007 21:22:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[dnn_UpdateDesktopModule]

	@DesktopModuleId	int,    
	@ModuleName		nvarchar(128),
	@FolderName		nvarchar(128),
	@FriendlyName		nvarchar(128),
	@Description		nvarchar(2000),
	@Version		nvarchar(8),
	@IsPremium		bit,
	@IsAdmin		bit,
	@BusinessController 	nvarchar(200),
	@SupportedFeatures	int,
	@CompatibleVersions 	nvarchar(500)

AS

UPDATE 	dnn_DesktopModules
SET    	ModuleName = @ModuleName,
	FolderName = @FolderName,
	FriendlyName = @FriendlyName,
	Description = @Description,
	Version = @Version,
	IsPremium = @IsPremium,
	IsAdmin = @IsAdmin,
	BusinessControllerClass = @BusinessController,
	SupportedFeatures = @SupportedFeatures,
	CompatibleVersions = @CompatibleVersions
WHERE  DesktopModuleId = @DesktopModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetDesktopModuleByModuleName]    Script Date: 10/05/2007 21:21:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetDesktopModuleByModuleName]

	@ModuleName    nvarchar(128)

as

select *
from   dnn_DesktopModules
where  ModuleName = @ModuleName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetDesktopModule]    Script Date: 10/05/2007 21:21:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetDesktopModule]

@DesktopModuleId int

as

select *
from   dnn_DesktopModules
where  DesktopModuleId = @DesktopModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetDesktopModuleByFriendlyName]    Script Date: 10/05/2007 21:21:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetDesktopModuleByFriendlyName]

	@FriendlyName    nvarchar(128)

as

select *
from   dnn_DesktopModules
where  FriendlyName = @FriendlyName
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteDesktopModule]    Script Date: 10/05/2007 21:21:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteDesktopModule]

@DesktopModuleId int

as

delete
from dnn_DesktopModules
where  DesktopModuleId = @DesktopModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddDesktopModule]    Script Date: 10/05/2007 21:21:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddDesktopModule]
    
	@ModuleName		nvarchar(128),
	@FolderName		nvarchar(128),
	@FriendlyName		nvarchar(128),
	@Description		nvarchar(2000),
	@Version		nvarchar(8),
	@IsPremium		bit,
	@IsAdmin		bit,
	@BusinessController 	nvarchar(200),
	@SupportedFeatures	int,
	@CompatibleVersions	nvarchar(500)

AS

INSERT INTO dnn_DesktopModules (
	ModuleName,
	FolderName,
	FriendlyName,
	Description,
	Version,
	IsPremium,
	IsAdmin,
	BusinessControllerClass,
	SupportedFeatures,
	CompatibleVersions
)
VALUES (
	@ModuleName,
	@FolderName,
	@FriendlyName,
	@Description,
	@Version,
	@IsPremium,
	@IsAdmin,
	@BusinessController,
	@SupportedFeatures,
	@CompatibleVersions
)

SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetDesktopModules]    Script Date: 10/05/2007 21:21:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_GetDesktopModules]

as

select *
from   dnn_DesktopModules
where  IsAdmin = 0
order  by FriendlyName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetSuperUsers]    Script Date: 10/05/2007 21:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dnn_GetSuperUsers]

as

select U.*,
       'PortalId' = -1,
       'FullName' = U.FirstName + ' ' + U.LastName
from   dnn_Users U
where  U.IsSuperUser = 1
GO
/****** Object:  StoredProcedure [dbo].[dnn_DeleteUser]    Script Date: 10/05/2007 21:21:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dnn_DeleteUser]

@UserId   int

as

delete
from dnn_Users
where  UserId = @UserId
GO
/****** Object:  StoredProcedure [dbo].[dnn_AddDefaultPropertyDefinitions]    Script Date: 10/05/2007 21:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_AddDefaultPropertyDefinitions]
	@PortalId int

AS
	DECLARE @TextDataType as int
	SELECT @TextDataType = (SELECT EntryID FROM dnn_Lists WHERE ListName = 'DataType' AND Value = 'Text')
	DECLARE @CountryDataType as int
	SELECT @CountryDataType = (SELECT EntryID FROM dnn_Lists WHERE ListName = 'DataType' AND Value = 'Country')
	DECLARE @RegionDataType as int
	SELECT @RegionDataType = (SELECT EntryID FROM dnn_Lists WHERE ListName = 'DataType' AND Value = 'Region')
	DECLARE @TimeZoneDataType as int
	SELECT @TimeZoneDataType = (SELECT EntryID FROM dnn_Lists WHERE ListName = 'DataType' AND Value = 'TimeZone')
	DECLARE @LocaleDataType as int
	SELECT @LocaleDataType = (SELECT EntryID FROM dnn_Lists WHERE ListName = 'DataType' AND Value = 'Locale')
	DECLARE @RichTextDataType as int
	SELECT @RichTextDataType = (SELECT EntryID FROM dnn_Lists WHERE ListName = 'DataType' AND Value = 'RichText')
	
	DECLARE @RC int

	--Add Name Properties
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Name','Prefix', 0, '', 1, 1, 50
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Name','FirstName' ,0, '', 3, 1, 50
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Name','MiddleName' ,0, '', 5, 1, 50
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Name','LastName' ,0, '', 7, 1, 50
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Name','Suffix' ,0, '', 9, 1, 50
	
	--Add Address Properties
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Address','Unit' ,0, '', 11, 1, 50
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Address','Street' ,0, '', 13, 1, 50
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Address','City' ,0, '', 15, 1, 50
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @RegionDataType, '', 'Address','Region' ,0, '', 17, 1, 0
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @CountryDataType, '', 'Address','Country' ,0, '', 19, 1, 0
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Address','PostalCode' ,0, '', 21, 1, 50

	--Add Contact Info Properties
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Contact Info','Telephone' ,0, '', 23, 1, 50
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Contact Info','Cell' ,0, '', 25, 1, 50
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Contact Info','Fax' ,0, '', 27, 1, 50
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Contact Info','Website' ,0, '', 29, 1, 50
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Contact Info','IM' ,0, '', 31, 1, 50

	--Add Preferences Properties
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @RichTextDataType, '', 'Preferences','Biography' ,0, '', 33, 1, 0
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @TimeZoneDataType, '', 'Preferences','TimeZone' ,0, '', 35, 1, 0
	EXECUTE @RC = dbo.[dnn_AddPropertyDefinition] @PortalId, -1, @LocaleDataType, '', 'Preferences','PreferredLocale' ,0, '', 37, 1, 0
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModulePermissionsByTabID]    Script Date: 10/05/2007 21:22:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetModulePermissionsByTabID]
	
	@TabID int

AS
SELECT *
FROM dnn_vw_ModulePermissions MP
	INNER JOIN dnn_TabModules TM on MP.ModuleID = TM.ModuleID
WHERE  TM.TabID = @TabID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetAllTabsModules]    Script Date: 10/05/2007 21:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetAllTabsModules]

	@PortalId int,
	@AllTabs bit

AS
SELECT	* 
FROM dnn_vw_Modules M
WHERE  M.PortalId = @PortalId 
	AND M.AllTabs = @AllTabs
	AND M.Tabmoduleid =(SELECT min(tabmoduleid) 
		FROM dnn_tabmodules
		WHERE Moduleid = M.ModuleID)
ORDER BY M.ModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetOnlineUsers]    Script Date: 10/05/2007 21:22:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetOnlineUsers]
	@PortalID int

AS
SELECT 
	*
	FROM dnn_UsersOnline UO
		INNER JOIN dnn_vw_Users U ON UO.UserID = U.UserID 
		INNER JOIN dnn_UserPortals UP ON U.UserID = UP.UserId
	WHERE  UP.PortalID = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModulePermissionsByPortal]    Script Date: 10/05/2007 21:22:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetModulePermissionsByPortal]
	
	@PortalID int

AS
SELECT *
FROM dnn_vw_ModulePermissions MP
	INNER JOIN dnn_Modules AS M ON MP.ModuleID = M.ModuleID 
WHERE  M.PortalID = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModulePermission]    Script Date: 10/05/2007 21:22:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetModulePermission]
	
	@ModulePermissionID int

AS
SELECT *
FROM dnn_vw_ModulePermissions
WHERE ModulePermissionID = @ModulePermissionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModulePermissionsByModuleID]    Script Date: 10/05/2007 21:22:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetModulePermissionsByModuleID]
	
	@ModuleID int, 
	@PermissionID int

AS
SELECT *
FROM dnn_vw_ModulePermissions
WHERE (@ModuleID = -1 
			OR ModuleID = @ModuleID
			OR (ModuleID IS NULL AND PermissionCode = 'SYSTEM_MODULE_DEFINITION')
		)
	AND	(PermissionID = @PermissionID OR @PermissionID = -1)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetAllTabs]    Script Date: 10/05/2007 21:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetAllTabs]

AS
SELECT *
FROM   dnn_vw_Tabs
ORDER BY TabOrder, TabName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTabsByParentId]    Script Date: 10/05/2007 21:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetTabsByParentId]

@ParentId int

AS
SELECT *
FROM   dnn_vw_Tabs
WHERE  ParentId = @ParentId
ORDER BY TabOrder
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTab]    Script Date: 10/05/2007 21:22:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetTab]

@TabId    int

AS
SELECT *
FROM   dnn_vw_Tabs
WHERE  TabId = @TabId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTabs]    Script Date: 10/05/2007 21:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetTabs]

@PortalId int

AS
SELECT *
FROM   dnn_vw_Tabs
WHERE  PortalId = @PortalId OR (PortalID IS NULL AND @PortalID IS NULL)
ORDER BY TabOrder, TabName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTabByName]    Script Date: 10/05/2007 21:22:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetTabByName]

@TabName  nvarchar(50),
@PortalId int

as
SELECT *
FROM   dnn_vw_Tabs
where  TabName = @TabName
and    ((PortalId = @PortalId) or (@PortalId is null AND PortalId is null))
order by TabID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUserByUsername]    Script Date: 10/05/2007 21:22:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetUserByUsername]

	@PortalId int,
	@Username nvarchar(100)

AS
SELECT * FROM dnn_vw_Users
WHERE  Username = @Username
	AND    (PortalId = @PortalId OR IsSuperUser = 1 OR @PortalId is null)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUnAuthorizedUsers]    Script Date: 10/05/2007 21:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetUnAuthorizedUsers]
    @PortalId			int
AS

SELECT  *
FROM	dnn_vw_Users
WHERE  PortalId = @PortalId
	AND Authorised = 0
ORDER BY UserName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUserCountByPortal]    Script Date: 10/05/2007 21:22:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetUserCountByPortal]

	@PortalId int

AS

	SELECT COUNT(*) FROM dnn_vw_Users 
		WHERE PortalID = @PortalID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetUser]    Script Date: 10/05/2007 21:22:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetUser]

	@PortalId int,
	@UserId int

AS
SELECT * FROM dnn_vw_Users U
WHERE  UserId = @UserId
	AND    (PortalId = @PortalId or IsSuperUser = 1)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModule]    Script Date: 10/05/2007 21:21:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetModule]

	@ModuleId int,
	@TabId    int
	
AS
SELECT	* 
FROM dnn_vw_Modules
WHERE   ModuleId = @ModuleId
AND     (TabId = @TabId or @TabId is null)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModules]    Script Date: 10/05/2007 21:22:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetModules]

	@PortalId int
	
AS
SELECT	* 
FROM dnn_vw_Modules
WHERE  PortalId = @PortalId
ORDER BY ModuleId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTabModules]    Script Date: 10/05/2007 21:22:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetTabModules]

	@TabId int

AS
SELECT	* 
FROM dnn_vw_Modules
WHERE  TabId = @TabId
ORDER BY ModuleOrder
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetAllModules]    Script Date: 10/05/2007 21:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetAllModules]

AS
SELECT	* 
FROM dnn_vw_Modules
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetModuleByDefinition]    Script Date: 10/05/2007 21:21:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetModuleByDefinition]

	@PortalId int,
	@FriendlyName nvarchar(128)
	
AS
SELECT	* 
FROM dnn_vw_Modules
WHERE  ((PortalId = @PortalId) or (PortalId is null and @PortalID is null))
	AND FriendlyName = @FriendlyName
	AND IsDeleted = 0
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortal]    Script Date: 10/05/2007 21:22:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPortal]

	@PortalId  int

AS
SELECT *
FROM dnn_vw_Portals
WHERE PortalId = @PortalId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortalByPortalAliasID]    Script Date: 10/05/2007 21:22:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPortalByPortalAliasID]

	@PortalAliasId  int

AS
SELECT P.*
FROM dnn_vw_Portals P
	INNER JOIN dnn_PortalAlias PA ON P.PortalID = PA.PortalID
WHERE PA.PortalAliasId = @PortalAliasId
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetExpiredPortals]    Script Date: 10/05/2007 21:21:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetExpiredPortals]

AS
SELECT * FROM dnn_vw_Portals
WHERE ExpiryDate < getDate()
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetPortals]    Script Date: 10/05/2007 21:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetPortals]

AS
SELECT *
FROM dnn_vw_Portals
ORDER BY PortalName
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTabPermissionsByPortal]    Script Date: 10/05/2007 21:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetTabPermissionsByPortal]
	
	@PortalID int

AS
SELECT *
FROM dnn_vw_TabPermissions TP
WHERE 	PortalID = @PortalID OR (PortalId IS NULL AND @PortalId IS NULL)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetTabPermission]    Script Date: 10/05/2007 21:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetTabPermission]

	@TabPermissionID int

AS
SELECT *
FROM dnn_vw_TabPermissions
WHERE TabPermissionID = @TabPermissionID
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetFolderPermissionsByFolderPath]    Script Date: 10/05/2007 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetFolderPermissionsByFolderPath]
	
	@PortalID int,
	@FolderPath varchar(300), 
	@PermissionID int

AS
SELECT *
FROM dnn_vw_FolderPermissions

WHERE	((FolderPath = @FolderPath 
				AND ((PortalID = @PortalID) OR (PortalID IS NULL AND @PortalID IS NULL)))
			OR (FolderPath IS NULL AND PermissionCode = 'SYSTEM_FOLDER'))
	AND	(PermissionID = @PermissionID OR @PermissionID = -1)
GO
/****** Object:  StoredProcedure [dbo].[dnn_GetFolderPermission]    Script Date: 10/05/2007 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[dnn_GetFolderPermission]
	
	@FolderPermissionID int

AS
SELECT *
FROM dnn_vw_FolderPermissions
WHERE FolderPermissionID = @FolderPermissionID
GO
