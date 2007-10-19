/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPasswordQuestions]    Script Date: 10/07/2007 08:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPasswordQuestions] 
	@locale nvarchar(10)
AS

DECLARE @count int

SELECT @count = COUNT(*) FROM {objectQualifier}Questions WHERE LOWER([Locale]) = LOWER(@locale)
  
IF (@count = 0)
	BEGIN
		SELECT * FROM {objectQualifier}Questions WHERE LOWER([Locale]) = 'en-us' OR [locale] IS NULL
	END
ELSE
	BEGIN
		SELECT * FROM {objectQualifier}Questions WHERE LOWER([Locale]) = LOWER(@locale)
	END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetVendorsByEmail]    Script Date: 10/05/2007 21:22:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetVendorsByEmail]
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
	FROM {objectQualifier}Vendors
	WHERE ( (Email = @Filter) AND ((PortalId = @PortalId) or (@PortalId is null and PortalId is null)) )
	ORDER BY VendorId DESC


	SELECT COUNT(*) as TotalRecords
	FROM #PageIndex


	SELECT {objectQualifier}Vendors.*,
       		'Banners' = ( select count(*) from {objectQualifier}Banners where {objectQualifier}Banners.VendorId = {objectQualifier}Vendors.VendorId )
	FROM {objectQualifier}Vendors
	INNER JOIN #PageIndex PageIndex
		ON {objectQualifier}Vendors.VendorId = PageIndex.VendorId
	WHERE ( (PageIndex.IndexID > @PageLowerBound) OR @PageLowerBound is null )	
		AND ( (PageIndex.IndexID < @PageUpperBound) OR @PageUpperBound is null )	
	ORDER BY
		PageIndex.IndexID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetVendorsByName]    Script Date: 10/05/2007 21:22:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetVendorsByName]
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
	FROM {objectQualifier}Vendors
	WHERE ( (VendorName like @Filter + '%') AND ((PortalId = @PortalId) or (@PortalId is null and PortalId is null)) )
	ORDER BY VendorId DESC


	SELECT COUNT(*) as TotalRecords
	FROM #PageIndex


	SELECT {objectQualifier}Vendors.*,
       		'Banners' = ( select count(*) from {objectQualifier}Banners where {objectQualifier}Banners.VendorId = {objectQualifier}Vendors.VendorId )
	FROM {objectQualifier}Vendors
	INNER JOIN #PageIndex PageIndex
		ON {objectQualifier}Vendors.VendorId = PageIndex.VendorId
	WHERE ( (PageIndex.IndexID > @PageLowerBound) OR @PageLowerBound is null )	
		AND ( (PageIndex.IndexID < @PageUpperBound) OR @PageUpperBound is null )	
	ORDER BY
		PageIndex.IndexID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetVendors]    Script Date: 10/05/2007 21:22:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetVendors]
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
	FROM {objectQualifier}Vendors
	WHERE ( ((Authorized = 0 AND @UnAuthorized = 1) OR @UnAuthorized = 0 ) AND ((PortalId = @PortalId) or (@PortalId is null and PortalId is null)) )
	ORDER BY VendorId DESC


	SELECT COUNT(*) as TotalRecords
	FROM #PageIndex


	SELECT {objectQualifier}Vendors.*,
       		'Banners' = ( select count(*) from {objectQualifier}Banners where {objectQualifier}Banners.VendorId = {objectQualifier}Vendors.VendorId )
	FROM {objectQualifier}Vendors
	INNER JOIN #PageIndex PageIndex
		ON {objectQualifier}Vendors.VendorId = PageIndex.VendorId
	WHERE ( (PageIndex.IndexID > @PageLowerBound) OR @PageLowerBound is null )	
		AND ( (PageIndex.IndexID < @PageUpperBound) OR @PageUpperBound is null )	
	ORDER BY
		PageIndex.IndexID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetEventLog]    Script Date: 10/05/2007 21:21:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetEventLog]
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
	SELECT {objectQualifier}EventLog.LogGUID
	FROM {objectQualifier}EventLog
	INNER JOIN {objectQualifier}EventLogConfig
		ON {objectQualifier}EventLog.LogConfigID = {objectQualifier}EventLogConfig.ID
	WHERE (LogPortalID = @PortalID or @PortalID IS NULL)
		AND ({objectQualifier}EventLog.LogTypeKey = @LogTypeKey or @LogTypeKey IS NULL)
	ORDER BY LogCreateDate DESC


	SELECT {objectQualifier}EventLog.*
	FROM {objectQualifier}EventLog
	INNER JOIN {objectQualifier}EventLogConfig
		ON {objectQualifier}EventLog.LogConfigID = {objectQualifier}EventLogConfig.ID
	INNER JOIN #PageIndex PageIndex
		ON {objectQualifier}EventLog.LogGUID = PageIndex.LogGUID
	WHERE PageIndex.IndexID			> @PageLowerBound	
		AND	PageIndex.IndexID			< @PageUpperBound	
	ORDER BY
		PageIndex.IndexID	

	SELECT COUNT(*) as TotalRecords
	FROM #PageIndex
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUsersByUserName]    Script Date: 10/05/2007 21:22:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUsersByUserName]
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
        SELECT UserId FROM	{objectQualifier}vw_Users 
        WHERE  Username LIKE @UserNameToMatch
			AND ( PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
	    ORDER BY UserName

    SELECT  *
    FROM	{objectQualifier}vw_Users u, 
			#PageIndexForUsers p
    WHERE  u.UserId = p.UserId
			AND ( PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
			AND p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY u.UserName

    SELECT  TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers
END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUsersByProfileProperty]    Script Date: 10/05/2007 21:22:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUsersByProfileProperty]
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
		FROM   {objectQualifier}ProfilePropertyDefinition P
			INNER JOIN {objectQualifier}UserProfile UP ON P.PropertyDefinitionID = UP.PropertyDefinitionID 
			INNER JOIN {objectQualifier}Users U ON UP.UserID = U.UserID
		WHERE (PropertyName = @PropertyName) AND (PropertyValue LIKE @PropertyValue OR PropertyText LIKE @PropertyValue )
			AND (P.Portalid = @PortalId OR (P.PortalId Is Null AND @PortalId is null ))
		ORDER BY U.DisplayName

    SELECT  *
    FROM	{objectQualifier}vw_Users u, 
			#PageIndexForUsers p
    WHERE  u.UserId = p.UserId
			AND ( PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
			AND p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
		ORDER BY U.DisplayName

    SELECT  TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers

END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUsersByEmail]    Script Date: 10/05/2007 21:22:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUsersByEmail]
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
            SELECT UserId FROM	{objectQualifier}vw_Users 
            WHERE  Email IS NULL
				AND ( PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
            ORDER BY Email
    ELSE
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT UserId FROM	{objectQualifier}vw_Users 
            WHERE  LOWER(Email) LIKE LOWER(@EmailToMatch)
				AND ( PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
            ORDER BY Email

    SELECT  *
    FROM	{objectQualifier}vw_Users u, 
			#PageIndexForUsers p
    WHERE  u.UserId = p.UserId
			AND ( PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
			AND p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY LOWER(u.Email)

    SELECT  TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers

END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetAllUsers]    Script Date: 10/05/2007 21:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetAllUsers]

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
        SELECT UserId FROM	{objectQualifier}vw_Users 
		WHERE (PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
		ORDER BY FirstName + ' ' + LastName

    SELECT  *
    FROM	{objectQualifier}vw_Users u, 
			#PageIndexForUsers p
    WHERE  u.UserId = p.UserId 
		AND (PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
        AND p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
	ORDER BY FirstName + ' ' + LastName

    SELECT  TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers

END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortalsByName]    Script Date: 10/05/2007 21:22:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPortalsByName]
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
        SELECT PortalId FROM	{objectQualifier}vw_Portals
        WHERE  PortalName LIKE @NameToMatch
	    ORDER BY PortalName

    SELECT  *
    FROM	{objectQualifier}vw_Portals p, 
			#PageIndexForPortals i
    WHERE  p.PortalId = i.PortalId
			AND i.IndexId >= @PageLowerBound AND i.IndexId <= @PageUpperBound
    ORDER BY p.PortalName

    SELECT  TotalRecords = COUNT(*)
    FROM    #PageIndexForPortals
END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetCurrencies]    Script Date: 10/05/2007 21:21:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetCurrencies]

as

select Code,
       Description
from {objectQualifier}CodeCurrency
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTables]    Script Date: 10/05/2007 21:22:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetTables]

as

/* Be carefull when changing this procedure as the GetSearchTables() function 
   in SearchDB.vb is only looking at the first column (to support databases that cannot return 
   a TableName column name (like MySQL))
*/

select 'TableName' = [name]
from   sysobjects 
where  xtype = 'U'
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUsersByRolename]    Script Date: 10/05/2007 21:22:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUsersByRolename]

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
	FROM {objectQualifier}UserPortals AS UP 
			RIGHT OUTER JOIN {objectQualifier}UserRoles  UR 
			INNER JOIN {objectQualifier}Roles R ON UR.RoleID = R.RoleID 
			RIGHT OUTER JOIN {objectQualifier}Users AS U ON UR.UserID = U.UserID 
		ON UP.UserId = U.UserID	
	WHERE ( UP.PortalId = @PortalId OR @PortalId IS Null )
		AND (R.RoleName = @Rolename)
		AND (R.PortalId = @PortalId OR @PortalId IS Null )
	ORDER BY U.FirstName + ' ' + U.LastName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetRolesByUser]    Script Date: 10/05/2007 21:22:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetRolesByUser]
    
	@UserId        int,
	@PortalId      int

AS

SELECT {objectQualifier}Roles.RoleName,
       {objectQualifier}Roles.RoleId
	FROM {objectQualifier}UserRoles
		INNER JOIN {objectQualifier}Users on {objectQualifier}UserRoles.UserId = {objectQualifier}Users.UserId
		INNER JOIN {objectQualifier}Roles on {objectQualifier}UserRoles.RoleId = {objectQualifier}Roles.RoleId
	WHERE  {objectQualifier}Users.UserId = @UserId
		AND    {objectQualifier}Roles.PortalId = @PortalId
		AND    (EffectiveDate <= getdate() or EffectiveDate is null)
		AND    (ExpiryDate >= getdate() or ExpiryDate is null)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetFoldersByUser]    Script Date: 10/05/2007 21:21:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetFoldersByUser]
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
FROM {databaseOwner}{objectQualifier}Roles R
	INNER JOIN {databaseOwner}{objectQualifier}UserRoles UR ON R.RoleID = UR.RoleID 
	RIGHT OUTER JOIN {databaseOwner}{objectQualifier}Folders F
		INNER JOIN {databaseOwner}{objectQualifier}FolderPermission FP ON F.FolderID = FP.FolderID 
		INNER JOIN {databaseOwner}{objectQualifier}Permission P ON FP.PermissionID = P.PermissionID 
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortalRoles]    Script Date: 10/05/2007 21:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPortalRoles]

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
FROM {databaseOwner}{objectQualifier}Roles R
	LEFT OUTER JOIN {databaseOwner}{objectQualifier}Lists L1 on R.BillingFrequency = L1.Value
	LEFT OUTER JOIN {databaseOwner}{objectQualifier}Lists L2 on R.TrialFrequency = L2.Value
WHERE  PortalId = @PortalId
	OR     PortalId is null
ORDER BY R.RoleName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddRole]    Script Date: 10/05/2007 21:21:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddRole]

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

INSERT INTO {databaseOwner}{objectQualifier}Roles (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetRolesByGroup]    Script Date: 10/05/2007 21:22:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetRolesByGroup]

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
FROM {databaseOwner}{objectQualifier}Roles R
	LEFT OUTER JOIN {databaseOwner}{objectQualifier}Lists L1 on R.BillingFrequency = L1.Value
	LEFT OUTER JOIN {databaseOwner}{objectQualifier}Lists L2 on R.TrialFrequency = L2.Value
WHERE  (RoleGroupId = @RoleGroupId OR (RoleGroupId IS NULL AND @RoleGroupId IS NULL))
	AND PortalId = @PortalId
ORDER BY R.RoleName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetRoles]    Script Date: 10/05/2007 21:22:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetRoles]

as

select *
from   {databaseOwner}{objectQualifier}Roles
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}IsUserInRole]    Script Date: 10/05/2007 21:22:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}IsUserInRole]
    
@UserId        int,
@RoleId        int,
@PortalId      int

as

select {objectQualifier}UserRoles.UserId,
       {objectQualifier}UserRoles.RoleId
from {objectQualifier}UserRoles
inner join {objectQualifier}Roles on {objectQualifier}UserRoles.RoleId = {objectQualifier}Roles.RoleId
where  {objectQualifier}UserRoles.UserId = @UserId
and    {objectQualifier}UserRoles.RoleId = @RoleId
and    {objectQualifier}Roles.PortalId = @PortalId
and    ({objectQualifier}UserRoles.ExpiryDate >= getdate() or {objectQualifier}UserRoles.ExpiryDate is null)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUserRole]    Script Date: 10/05/2007 21:22:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetUserRole]

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
	FROM	{objectQualifier}UserRoles ur
		INNER JOIN {objectQualifier}UserPortals up on ur.UserId = up.UserId
		INNER JOIN {objectQualifier}Roles r on r.RoleID = ur.RoleID
	WHERE   up.UserId = @UserId
		AND     up.PortalId = @PortalId
		AND     ur.RoleId = @RoleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetRole]    Script Date: 10/05/2007 21:22:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetRole]

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
FROM   {objectQualifier}Roles
WHERE  RoleId = @RoleId
	AND    PortalId = @PortalId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetRoleByName]    Script Date: 10/05/2007 21:22:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetRoleByName]

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
FROM   {objectQualifier}Roles
WHERE  PortalId = @PortalId 
	AND RoleName = @RoleName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteRole]    Script Date: 10/05/2007 21:21:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}DeleteRole]

@RoleId int

as

delete 
from {objectQualifier}FolderPermission
where  RoleId = @RoleId

delete 
from {objectQualifier}ModulePermission
where  RoleId = @RoleId

delete 
from {objectQualifier}TabPermission
where  RoleId = @RoleId

delete 
from {objectQualifier}Roles
where  RoleId = @RoleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUserRoles]    Script Date: 10/05/2007 21:22:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUserRoles]
    
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
FROM {objectQualifier}UserRoles UR
	INNER JOIN {objectQualifier}Users U ON UR.UserID = U.UserID 
	INNER JOIN {objectQualifier}Roles R ON UR.RoleID = R.RoleID 
WHERE
	U.UserID = @UserId AND R.PortalID = @PortalId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTabPermissionsByTabID]    Script Date: 10/05/2007 21:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabPermissionsByTabID]
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
	{databaseOwner}{objectQualifier}TabPermission M
LEFT JOIN
	{databaseOwner}{objectQualifier}Permission P
ON	M.PermissionID = P.PermissionID
LEFT JOIN
	{databaseOwner}{objectQualifier}Roles R
ON	M.RoleID = R.RoleID
WHERE
	(M.[TabID] = @TabID
	OR (M.TabID IS NULL and P.PermissionCode = 'SYSTEM_TAB'))
AND	(P.[PermissionID] = @PermissionID or @PermissionID = -1)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetServices]    Script Date: 10/05/2007 21:22:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetServices]
    
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
       'ExpiryDate' = ( select ExpiryDate from {databaseOwner}{objectQualifier}UserRoles where {databaseOwner}{objectQualifier}UserRoles.RoleId = R.RoleId and {databaseOwner}{objectQualifier}UserRoles.UserId = @UserId ),
       'Subscribed' = ( select UserRoleId from {databaseOwner}{objectQualifier}UserRoles where {databaseOwner}{objectQualifier}UserRoles.RoleId = R.RoleId and {databaseOwner}{objectQualifier}UserRoles.UserId = @UserId )
from {databaseOwner}{objectQualifier}Roles R
inner join {databaseOwner}{objectQualifier}Lists L1 on R.BillingFrequency = L1.Value
left outer join {databaseOwner}{objectQualifier}Lists L2 on R.TrialFrequency = L2.Value
where  R.PortalId = @PortalId
and    R.IsPublic = 1
and L1.ListName='Frequency'
and L2.ListName='Frequency'
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateRole]    Script Date: 10/05/2007 21:22:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateRole]

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

UPDATE {databaseOwner}{objectQualifier}Roles
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
/****** Object:  StoredProcedure [dbo].[scp_GetUserRolesByUserId]    Script Date: 10/10/2007 11:54:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUserRolesByUserId] 

@PortalId	int, 
@UserID		int, 
@RoleID		int,
@PageIndex	int,   
@PageSize	int 
	
AS

	IF @UserID Is Null
	BEGIN

		-- Set the page bounds
		DECLARE @PageLowerBound int
		DECLARE @PageUpperBound int
		SET @PageLowerBound = @PageSize * @PageIndex
		SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

		-- Create a temp table TO store the select results
		CREATE TABLE #PageIndexForUsers
		(
			IndexID int IDENTITY (0, 1) NOT NULL,
			UserID int
		)

		 -- Insert into our temp table
		INSERT INTO #PageIndexForUsers (UserID)
        SELECT	UR.UserID
			FROM scp_UserRoles UR
				INNER JOIN scp_Users U ON UR.UserID = U.UserID
				INNER JOIN scp_Roles R ON R.RoleID = UR.RoleID
			WHERE  R.PortalId = @PortalId
				AND (R.RoleID = @roleID)
		
		SELECT	R.*,
				U.Username,
				U.Firstname,
				U.lastname,        
				U.DisplayName,
				UR.UserRoleID,
				UR.UserID,
				UR.EffectiveDate,
				UR.ExpiryDate,
				UR.IsTrialUsed
			FROM scp_UserRoles UR
				INNER JOIN scp_Users U ON UR.UserID = U.UserID
				INNER JOIN scp_Roles R ON R.RoleID = UR.RoleID
				INNER JOIN #PageIndexForUsers P ON U.UserID = P.UserID
			WHERE UR.RoleID = @RoleID AND P.IndexID >= @PageLowerBound AND P.IndexID <= @PageUpperBound
			ORDER BY U.UserName

		SELECT TotalRecords = COUNT(*) FROM #PageIndexForUsers
	END
	ELSE
	BEGIN
		IF @RoleID Is NULL
			SELECT	R.*,							
					U.Username,        
					U.Firstname,
					U.lastname,        
					U.DisplayName,
					UR.UserRoleID,
					UR.UserID,
					UR.EffectiveDate,
					UR.ExpiryDate,
					UR.IsTrialUsed
				FROM scp_UserRoles UR
					INNER JOIN scp_Users U ON UR.UserID = U.UserID
					INNER JOIN scp_Roles R ON R.RoleID = UR.RoleID
				WHERE R.PortalId = @PortalId
					AND (U.UserID = @UserID)			
		ELSE
			SELECT	R.*,
					U.Username,        
					U.Firstname,
					U.lastname,        
					U.DisplayName,
					UR.UserRoleID,
					UR.UserID,
					UR.EffectiveDate,
					UR.ExpiryDate,
					UR.IsTrialUsed
				FROM scp_UserRoles UR
					INNER JOIN scp_Users U ON UR.UserID = U.UserID
					INNER JOIN scp_Roles R ON R.RoleID = UR.RoleID
				WHERE R.PortalId = @PortalId
					AND (R.RoleID = @RoleID)
					AND (U.UserID = @UserID)
	END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUserRolesByUsername]    Script Date: 10/05/2007 21:22:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUserRolesByUsername]

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
			FROM	{objectQualifier}UserRoles UR
				INNER JOIN {objectQualifier}Users U ON UR.UserID = U.UserID
				INNER JOIN {objectQualifier}Roles R ON R.RoleID = UR.RoleID
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
					FROM	{objectQualifier}UserRoles UR
						INNER JOIN {objectQualifier}Users U ON UR.UserID = U.UserID
						INNER JOIN {objectQualifier}Roles R ON R.RoleID = UR.RoleID
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
					FROM	{objectQualifier}UserRoles UR
						INNER JOIN {objectQualifier}Users U ON UR.UserID = U.UserID
						INNER JOIN {objectQualifier}Roles R ON R.RoleID = UR.RoleID
					WHERE  R.PortalId = @PortalId
						AND    (R.Rolename = @Rolename or @RoleName is NULL)
						AND    (U.Username = @Username or @Username is NULL)
			END
	END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddHtmlText]    Script Date: 10/05/2007 21:21:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/** Create Stored Procedures **/

create procedure {databaseOwner}[{objectQualifier}AddHtmlText]

	@ModuleId       int,
	@DesktopHtml    ntext,
	@DesktopSummary ntext,
	@UserID         int

as

insert into {objectQualifier}HtmlText (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateHtmlText]    Script Date: 10/05/2007 21:22:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateHtmlText]

	@ModuleId       int,
	@DesktopHtml    ntext,
	@DesktopSummary ntext,
	@UserID         int

as

update {objectQualifier}HtmlText
set    DesktopHtml    = @DesktopHtml,
       DesktopSummary = @DesktopSummary,
       CreatedByUser  = @UserID,
       CreatedDate    = getdate()
where  ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetHtmlText]    Script Date: 10/05/2007 21:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetHtmlText]

	@ModuleId int

as

select *
from {objectQualifier}HtmlText
where  ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetRoleGroup]    Script Date: 10/05/2007 21:22:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetRoleGroup]

	@PortalId		int,
	@RoleGroupId    int
	
AS

SELECT
	RoleGroupId,
	PortalId,
	RoleGroupName,
	Description
FROM {databaseOwner}{objectQualifier}RoleGroups
WHERE  (RoleGroupId = @RoleGroupId OR RoleGroupId IS NULL AND @RoleGroupId IS NULL)
	AND    PortalId = @PortalId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateRoleGroup]    Script Date: 10/05/2007 21:22:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateRoleGroup]

	@RoleGroupId      int,
	@RoleGroupName	  nvarchar(50),
	@Description      nvarchar(1000)

AS

UPDATE {databaseOwner}{objectQualifier}RoleGroups
SET    RoleGroupName = @RoleGroupName,
	   Description = @Description
WHERE  RoleGroupId = @RoleGroupId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteRoleGroup]    Script Date: 10/05/2007 21:21:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteRoleGroup]

	@RoleGroupId      int
	
AS

DELETE  
FROM {databaseOwner}{objectQualifier}RoleGroups
WHERE  RoleGroupId = @RoleGroupId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddRoleGroup]    Script Date: 10/05/2007 21:21:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddRoleGroup]

	@PortalId         int,
	@RoleGroupName    nvarchar(50),
	@Description      nvarchar(1000)

AS

INSERT INTO {databaseOwner}{objectQualifier}RoleGroups (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetRoleGroups]    Script Date: 10/05/2007 21:22:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetRoleGroups]

	@PortalId		int
	
AS

SELECT
	RoleGroupId,
	PortalId,
	RoleGroupName,
	Description
FROM {databaseOwner}{objectQualifier}RoleGroups
WHERE  PortalId = @PortalId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetScheduleByTypeFullName]    Script Date: 10/05/2007 21:22:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetScheduleByTypeFullName]
	@TypeFullName varchar(200),
	@Server varchar(150)
AS

	SELECT S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, S.Servers
	FROM {objectQualifier}Schedule S
	WHERE S.TypeFullName = @TypeFullName 
	AND (S.Servers LIKE ',%' + @Server + '%,' or S.Servers IS NULL)
	GROUP BY S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, S.Servers
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetScheduleNextTask]    Script Date: 10/05/2007 21:22:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetScheduleNextTask]
	@Server varchar(150)
AS
SELECT TOP 1 S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, SH.NextStart
FROM {objectQualifier}Schedule S
LEFT JOIN {objectQualifier}ScheduleHistory SH
ON S.ScheduleID = SH.ScheduleID
WHERE ((SH.ScheduleHistoryID = (SELECT TOP 1 S1.ScheduleHistoryID FROM {objectQualifier}ScheduleHistory S1 WHERE S1.ScheduleID = S.ScheduleID ORDER BY S1.NextStart DESC)
OR  SH.ScheduleHistoryID IS NULL) AND S.Enabled = 1)
AND (S.Servers LIKE ',%' + @Server + '%,' or S.Servers IS NULL)
GROUP BY S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, SH.NextStart
ORDER BY SH.NextStart ASC
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetScheduleByEvent]    Script Date: 10/05/2007 21:22:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetScheduleByEvent]
@EventName varchar(50),
@Server varchar(150)
AS
SELECT S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled
FROM {databaseOwner}{objectQualifier}Schedule S
WHERE S.AttachToEvent = @EventName
AND (S.Servers LIKE ',%' + @Server + '%,' or S.Servers IS NULL)
GROUP BY S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateSchedule]    Script Date: 10/05/2007 21:22:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateSchedule]
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
UPDATE {databaseOwner}{objectQualifier}Schedule
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSchedule]    Script Date: 10/05/2007 21:22:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSchedule]
	@Server varchar(150)
AS
SELECT S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, SH.NextStart, S.Servers
FROM {objectQualifier}Schedule S
LEFT JOIN {objectQualifier}ScheduleHistory SH
ON S.ScheduleID = SH.ScheduleID
WHERE (SH.ScheduleHistoryID = (SELECT TOP 1 S1.ScheduleHistoryID FROM {objectQualifier}ScheduleHistory S1 WHERE S1.ScheduleID = S.ScheduleID ORDER BY S1.NextStart DESC)
OR  SH.ScheduleHistoryID IS NULL)
AND (@Server IS NULL or S.Servers LIKE ',%' + @Server + '%,' or S.Servers IS NULL)
GROUP BY S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, SH.NextStart, S.Servers
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetScheduleByScheduleID]    Script Date: 10/05/2007 21:22:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetScheduleByScheduleID]
@ScheduleID int
AS
SELECT S.*
FROM {databaseOwner}{objectQualifier}Schedule S
WHERE S.ScheduleID = @ScheduleID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}PurgeScheduleHistory]    Script Date: 10/05/2007 21:22:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}PurgeScheduleHistory]
AS
DELETE FROM {databaseOwner}{objectQualifier}ScheduleHistory
FROM {databaseOwner}{objectQualifier}Schedule s
WHERE
    (
    SELECT COUNT(*)
    FROM {databaseOwner}{objectQualifier}ScheduleHistory sh
    WHERE
        sh.ScheduleID = {databaseOwner}{objectQualifier}ScheduleHistory.ScheduleID AND
        sh.ScheduleID = s.ScheduleID AND
        sh.StartDate >= {databaseOwner}{objectQualifier}ScheduleHistory.StartDate
    ) > s.RetainHistoryNum
AND RetainHistoryNum<>-1
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddSchedule]    Script Date: 10/05/2007 21:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddSchedule]
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
INSERT INTO {objectQualifier}Schedule
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetScheduleHistory]    Script Date: 10/05/2007 21:22:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetScheduleHistory]
@ScheduleID int
AS
SELECT S.ScheduleID, S.TypeFullName, SH.StartDate, SH.EndDate, SH.Succeeded, SH.LogNotes, SH.NextStart, SH.Server
FROM {databaseOwner}{objectQualifier}Schedule S
INNER JOIN {databaseOwner}{objectQualifier}ScheduleHistory SH
ON S.ScheduleID = SH.ScheduleID
WHERE S.ScheduleID = @ScheduleID or @ScheduleID = -1
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteSchedule]    Script Date: 10/05/2007 21:21:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteSchedule]
@ScheduleID int
AS
DELETE FROM {databaseOwner}{objectQualifier}Schedule
WHERE ScheduleID = @ScheduleID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTabPanes]    Script Date: 10/05/2007 21:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetTabPanes]

@TabId    int

as

select distinct(PaneName) as PaneName
from   {objectQualifier}TabModules
where  TabId = @TabId
order by PaneName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateModuleOrder]    Script Date: 10/05/2007 21:22:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateModuleOrder]

@TabId              int,
@ModuleId           int,
@ModuleOrder        int,
@PaneName           nvarchar(50)

as

update {objectQualifier}TabModules
set    ModuleOrder = @ModuleOrder,
       PaneName = @PaneName
where  TabId = @TabId
and    ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchModules]    Script Date: 10/05/2007 21:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSearchModules]

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
FROM {objectQualifier}Modules M
	INNER JOIN {objectQualifier}TabModules TM ON M.ModuleId = TM.ModuleId
	INNER JOIN {objectQualifier}Tabs T ON TM.TabId = T.TabId
	INNER JOIN {objectQualifier}ModuleDefinitions MD ON M.ModuleDefId = MD.ModuleDefId
	INNER JOIN {objectQualifier}DesktopModules DM ON MD.DesktopModuleId = DM.DesktopModuleId
	INNER JOIN {objectQualifier}ModuleControls MC ON MD.ModuleDefId = MC.ModuleDefId
	LEFT OUTER JOIN {objectQualifier}Files F ON TM.IconFile = 'fileid=' + convert(varchar,F.FileID)
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchSettings]    Script Date: 10/05/2007 21:22:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSearchSettings]

	@ModuleID	int

AS

select     	tm.ModuleID, 
			settings.SettingName, 
			settings.SettingValue
from	{objectQualifier}Tabs searchTabs INNER JOIN
		{objectQualifier}TabModules searchTabModules ON searchTabs.TabID = searchTabModules.TabID INNER JOIN
        {objectQualifier}Portals p ON searchTabs.PortalID = p.PortalID INNER JOIN
        {objectQualifier}Tabs t ON p.PortalID = t.PortalID INNER JOIN
        {objectQualifier}TabModules tm ON t.TabID = tm.TabID INNER JOIN
        {objectQualifier}ModuleSettings settings ON searchTabModules.ModuleID = settings.ModuleID
where   searchTabs.TabName = N'Search Admin'
and		tm.ModuleID = @ModuleID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTabModuleOrder]    Script Date: 10/05/2007 21:22:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetTabModuleOrder]

@TabId    int, 
@PaneName nvarchar(50)

as

select *
from   {objectQualifier}TabModules 
where  TabId = @TabId 
and    PaneName = @PaneName
order by ModuleOrder
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchResultModules]    Script Date: 10/05/2007 21:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetSearchResultModules]

@PortalID int

AS

SELECT     
		TM.TabID, 
		T.TabName  AS SearchTabName
FROM	{objectQualifier}Modules M
INNER JOIN	{objectQualifier}ModuleDefinitions MD ON MD.ModuleDefID = M.ModuleDefID 
INNER JOIN	{objectQualifier}TabModules TM ON TM.ModuleID = M.ModuleID 
INNER JOIN	{objectQualifier}Tabs T ON T.TabID = TM.TabID
WHERE	MD.FriendlyName = N'Search Results'
	AND T.PortalID = @PortalID
	AND T.IsDeleted = 0
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddTabModule]    Script Date: 10/05/2007 21:21:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddTabModule]
    
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

insert into {objectQualifier}TabModules ( 
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateTabModule]    Script Date: 10/05/2007 21:23:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateTabModule]

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

update {objectQualifier}TabModules
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteTabModule]    Script Date: 10/05/2007 21:21:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteTabModule]

@TabId      int,
@ModuleId   int

as

delete
from   {objectQualifier}TabModules 
where  TabId = @TabId
and    ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchItems]    Script Date: 10/05/2007 21:22:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItems]

@PortalId int,
@TabId int,
@ModuleId int

AS

SELECT si.*,
       'AuthorName' = u.FirstName + ' ' + u.LastName,
       t.TabId
FROM   {databaseOwner}{objectQualifier}SearchItem si
	LEFT OUTER JOIN {databaseOwner}{objectQualifier}Users u ON si.Author = u.UserID
	INNER JOIN {databaseOwner}{objectQualifier}Modules m ON si.ModuleId = m.ModuleID 
	INNER JOIN {databaseOwner}{objectQualifier}TabModules tm ON m.ModuleId = tm.ModuleID 
	INNER JOIN {databaseOwner}{objectQualifier}Tabs t ON tm.TabID = t.TabID
	INNER JOIN {databaseOwner}{objectQualifier}Portals p ON t.PortalID = p.PortalID
WHERE (p.PortalId = @PortalId or @PortalId is null)
	AND   (t.TabId = @TabId or @TabId is null)
	AND   (m.ModuleId = @ModuleId or @ModuleId is null)
ORDER BY PubDate DESC
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchResults]    Script Date: 10/05/2007 21:22:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetSearchResults]
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
FROM    {objectQualifier}SearchWord sw
	INNER JOIN {objectQualifier}SearchItemWord siw ON sw.SearchWordsID = siw.SearchWordsID
	INNER JOIN {objectQualifier}SearchItem si ON siw.SearchItemID = si.SearchItemID
	INNER JOIN {objectQualifier}Modules m ON si.ModuleId = m.ModuleID
	LEFT OUTER JOIN {objectQualifier}TabModules tm ON si.ModuleId = tm.ModuleID
	INNER JOIN {objectQualifier}Tabs t ON tm.TabID = t.TabID
	LEFT OUTER JOIN {objectQualifier}Users u ON si.Author = u.UserID
WHERE   (((m.StartDate Is Null) OR (GetDate() > m.StartDate)) AND ((m.EndDate Is Null) OR (GetDate() < m.EndDate)))
	AND (((t.StartDate Is Null) OR (GetDate() > t.StartDate)) AND ((t.EndDate Is Null) OR (GetDate() < t.EndDate)))
	AND (sw.Word = @Word) 
	AND (t.IsDeleted = 0) 
	AND (m.IsDeleted = 0) 
	AND (t.PortalID = @PortalID)
ORDER BY Relevance DESC
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUrlLog]    Script Date: 10/05/2007 21:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetUrlLog]

@URLTrackingID int,
@StartDate     datetime,
@EndDate       datetime

as

select {objectQualifier}UrlLog.*,
       'FullName' = {objectQualifier}Users.FirstName + ' ' + {objectQualifier}Users.LastName
from   {objectQualifier}UrlLog
inner join {objectQualifier}UrlTracking on {objectQualifier}UrlLog.UrlTrackingId = {objectQualifier}UrlTracking.UrlTrackingId
left outer join {objectQualifier}Users on {objectQualifier}UrlLog.UserId = {objectQualifier}Users.UserId
where  {objectQualifier}UrlLog.UrlTrackingID = @UrlTrackingID
and    ((ClickDate >= @StartDate) or @StartDate is null)
and    ((ClickDate <= @EndDate) or @EndDate is null)
order by ClickDate
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddUrlLog]    Script Date: 10/05/2007 21:21:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddUrlLog]

@UrlTrackingID int,
@UserID        int

as

insert into {objectQualifier}UrlLog (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSiteLog4]    Script Date: 10/05/2007 21:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSiteLog4]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select Referrer,
 'Requests' = count(*),
 'LastRequest' = max(DateTime)
from {objectQualifier}SiteLog
where {objectQualifier}SiteLog.PortalId = @PortalId
and {objectQualifier}SiteLog.DateTime between @StartDate and @EndDate
and Referrer is not null
and Referrer not like '%' + @PortalAlias + '%'
group by Referrer
order by Requests desc
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSiteLog3]    Script Date: 10/05/2007 21:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSiteLog3]

	@PortalId int,
	@PortalAlias nvarchar(50),
	@StartDate datetime,
	@EndDate datetime

as

select 'Name' = {objectQualifier}Users.FirstName + ' ' + {objectQualifier}Users.LastName,
	'Requests' = count(*),
	'LastRequest' = max(DateTime)
from {objectQualifier}SiteLog
inner join {objectQualifier}Users on {objectQualifier}SiteLog.UserId = {objectQualifier}Users.UserId
where {objectQualifier}SiteLog.PortalId = @PortalId
and {objectQualifier}SiteLog.DateTime between @StartDate and @EndDate
and {objectQualifier}SiteLog.UserId is not null
group by {objectQualifier}Users.FirstName + ' ' + {objectQualifier}Users.LastName
order by Requests desc
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteSiteLog]    Script Date: 10/05/2007 21:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteSiteLog]

@DateTime                      datetime, 
@PortalId                      int

as

delete
from {objectQualifier}SiteLog
where  PortalId = @PortalId
and    DateTime < @DateTime
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSiteLog2]    Script Date: 10/05/2007 21:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSiteLog2]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select {objectQualifier}SiteLog.DateTime,
 'Name' = 
 case
when {objectQualifier}SiteLog.UserId is null then null
else {objectQualifier}Users.FirstName + ' ' + {objectQualifier}Users.LastName
end,
 'Referrer' = 
 case 
 when {objectQualifier}SiteLog.Referrer like '%' + @PortalAlias + '%' then null 
 else {objectQualifier}SiteLog.Referrer
 end,
 'UserAgent' = 
 case 
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 1%' then 'Internet Explorer 1'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 2%' then 'Internet Explorer 2'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 3%' then 'Internet Explorer 3'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 4%' then 'Internet Explorer 4'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 5%' then 'Internet Explorer 5'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 6%' then 'Internet Explorer 6'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE%' then 'Internet Explorer'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/1%' then 'Netscape Navigator 1'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/2%' then 'Netscape Navigator 2'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/3%' then 'Netscape Navigator 3'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/4%' then 'Netscape Navigator 4'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/5%' then 'Netscape Navigator 6+'
 else {objectQualifier}SiteLog.UserAgent
 end,
 {objectQualifier}SiteLog.UserHostAddress,
 {objectQualifier}Tabs.TabName
from {objectQualifier}SiteLog
left outer join {objectQualifier}Users on {objectQualifier}SiteLog.UserId = {objectQualifier}Users.UserId 
left outer join {objectQualifier}Tabs on {objectQualifier}SiteLog.TabId = {objectQualifier}Tabs.TabId 
where {objectQualifier}SiteLog.PortalId = @PortalId
and {objectQualifier}SiteLog.DateTime between @StartDate and @EndDate
order by {objectQualifier}SiteLog.DateTime desc
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSiteLog12]    Script Date: 10/05/2007 21:22:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSiteLog12]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select AffiliateId,
 'Requests' = count(*),
 'LastReferral' = max(DateTime)
from {objectQualifier}SiteLog
where {objectQualifier}SiteLog.PortalId = @PortalId
and {objectQualifier}SiteLog.DateTime between @StartDate and @EndDate
and AffiliateId is not null
group by AffiliateId
order by Requests desc
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSiteLog6]    Script Date: 10/05/2007 21:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSiteLog6]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select 'Hour' = datepart(hour,DateTime),
 'Views' = count(*),
 'Visitors' = count(distinct {objectQualifier}SiteLog.UserHostAddress),
 'Users' = count(distinct {objectQualifier}SiteLog.UserId)
from {objectQualifier}SiteLog
where PortalId = @PortalId
and {objectQualifier}SiteLog.DateTime between @StartDate and @EndDate
group by datepart(hour,DateTime)
order by Hour
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddSiteLog]    Script Date: 10/05/2007 21:21:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddSiteLog]

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

insert into {objectQualifier}SiteLog ( 
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSiteLog7]    Script Date: 10/05/2007 21:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSiteLog7]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select 'WeekDay' = datepart(weekday,DateTime),
 'Views' = count(*),
 'Visitors' = count(distinct {objectQualifier}SiteLog.UserHostAddress),
 'Users' = count(distinct {objectQualifier}SiteLog.UserId)
from {objectQualifier}SiteLog
where PortalId = @PortalId
and {objectQualifier}SiteLog.DateTime between @StartDate and @EndDate
group by datepart(weekday,DateTime)
order by WeekDay
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSiteLog1]    Script Date: 10/05/2007 21:22:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSiteLog1]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select 'Date' = convert(varchar,DateTime,102),
 'Views' = count(*),
 'Visitors' = count(distinct {objectQualifier}SiteLog.UserHostAddress),
 'Users' = count(distinct {objectQualifier}SiteLog.UserId)
from {objectQualifier}SiteLog
where PortalId = @PortalId
and {objectQualifier}SiteLog.DateTime between @StartDate and @EndDate
group by convert(varchar,DateTime,102)
order by Date desc
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSiteLog8]    Script Date: 10/05/2007 21:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSiteLog8]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select 'Month' = datepart(month,DateTime),
 'Views' = count(*),
 'Visitors' = count(distinct {objectQualifier}SiteLog.UserHostAddress),
 'Users' = count(distinct {objectQualifier}SiteLog.UserId)
from {objectQualifier}SiteLog
where PortalId = @PortalId
and {objectQualifier}SiteLog.DateTime between @StartDate and @EndDate
group by datepart(month,DateTime)
order by Month
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSiteLog5]    Script Date: 10/05/2007 21:22:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSiteLog5]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select'UserAgent' = 
 case 
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 1%' then 'Internet Explorer 1'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 2%' then 'Internet Explorer 2'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 3%' then 'Internet Explorer 3'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 4%' then 'Internet Explorer 4'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 5%' then 'Internet Explorer 5'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 6%' then 'Internet Explorer 6'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE%' then 'Internet Explorer'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/1%' then 'Netscape Navigator 1'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/2%' then 'Netscape Navigator 2'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/3%' then 'Netscape Navigator 3'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/4%' then 'Netscape Navigator 4'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/5%' then 'Netscape Navigator 6+'
 else {objectQualifier}SiteLog.UserAgent
 end,
 'Requests' = count(*),
 'LastRequest' = max(DateTime)
from {objectQualifier}SiteLog
where PortalId = @PortalId
and {objectQualifier}SiteLog.DateTime between @StartDate and @EndDate
group by case 
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 1%' then 'Internet Explorer 1'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 2%' then 'Internet Explorer 2'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 3%' then 'Internet Explorer 3'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 4%' then 'Internet Explorer 4'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 5%' then 'Internet Explorer 5'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE 6%' then 'Internet Explorer 6'
 when {objectQualifier}SiteLog.UserAgent like '%MSIE%' then 'Internet Explorer'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/1%' then 'Netscape Navigator 1'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/2%' then 'Netscape Navigator 2'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/3%' then 'Netscape Navigator 3'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/4%' then 'Netscape Navigator 4'
 when {objectQualifier}SiteLog.UserAgent like '%Mozilla/5%' then 'Netscape Navigator 6+'
 else {objectQualifier}SiteLog.UserAgent
 end
order by Requests desc
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSiteLog9]    Script Date: 10/05/2007 21:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSiteLog9]

@PortalId int,
@PortalAlias nvarchar(50),
@StartDate datetime,
@EndDate datetime

as

select 'Page' = {objectQualifier}Tabs.TabName,
 'Requests' = count(*),
 'LastRequest' = max(DateTime)
from {objectQualifier}SiteLog
inner join {objectQualifier}Tabs on {objectQualifier}SiteLog.TabId = {objectQualifier}Tabs.TabId
where {objectQualifier}SiteLog.PortalId = @PortalId
and {objectQualifier}SiteLog.DateTime between @StartDate and @EndDate
and {objectQualifier}SiteLog.TabId is not null
group by {objectQualifier}Tabs.TabName
order by Requests desc
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetLinks]    Script Date: 10/05/2007 21:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetLinks]

@ModuleId int

as

select {objectQualifier}Links.ItemId,
       {objectQualifier}Links.ModuleId,
       {objectQualifier}Links.CreatedByUser,
       {objectQualifier}Links.CreatedDate,
       {objectQualifier}Links.Title,
       {objectQualifier}Links.URL,
       {objectQualifier}Links.ViewOrder,
       {objectQualifier}Links.Description,
       {objectQualifier}UrlTracking.TrackClicks,
       {objectQualifier}UrlTracking.NewWindow
from   {objectQualifier}Links
left outer join {objectQualifier}UrlTracking on {objectQualifier}Links.URL = {objectQualifier}UrlTracking.Url and {objectQualifier}UrlTracking.ModuleId = @ModuleID 
where  {objectQualifier}Links.ModuleId = @ModuleId
order by {objectQualifier}Links.ViewOrder, {objectQualifier}Links.Title
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateLink]    Script Date: 10/05/2007 21:22:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateLink]

	@ItemId      int,
	@UserId      int,
	@Title       nvarchar(100),
	@Url         nvarchar(250),
	@ViewOrder   int,
	@Description nvarchar(2000)

as

update {objectQualifier}Links
set    CreatedByUser = @UserId,
       CreatedDate   = GetDate(),
       Title         = @Title,
       Url           = @Url,
       ViewOrder     = @ViewOrder,
       Description   = @Description
where  ItemId = @ItemId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddLink]    Script Date: 10/05/2007 21:21:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/** Create Optimized Stored Procedures **/

create procedure {databaseOwner}[{objectQualifier}AddLink]

	@ModuleId    int,
	@UserId      int,
	@Title       nvarchar(100),
	@Url         nvarchar(250),
	@ViewOrder   int,
	@Description nvarchar(2000)

as

insert into {objectQualifier}Links (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetLink]    Script Date: 10/05/2007 21:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetLink]

@ItemId   int,
@ModuleId int

as

select  {objectQualifier}Links.ItemId,
	{objectQualifier}Links.ModuleId,
	{objectQualifier}Links.Title,
	{objectQualifier}Links.URL,
        {objectQualifier}Links.ViewOrder,
        {objectQualifier}Links.Description,
        {objectQualifier}Links.CreatedByUser,
        {objectQualifier}Links.CreatedDate,
        {objectQualifier}UrlTracking.TrackClicks,
        {objectQualifier}UrlTracking.NewWindow
from    {objectQualifier}Links
left outer join {objectQualifier}UrlTracking on {objectQualifier}Links.URL = {objectQualifier}UrlTracking.Url and {objectQualifier}UrlTracking.ModuleId = @ModuleID 
where  {objectQualifier}Links.ItemId = @ItemId
and    {objectQualifier}Links.ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteLink]    Script Date: 10/05/2007 21:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteLink]

	@ItemId int

as

delete
from {objectQualifier}Links
where  ItemId = @ItemId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateTabPermission]    Script Date: 10/05/2007 21:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateTabPermission]
	@TabPermissionID int, 
	@TabID int, 
	@PermissionID int, 
	@RoleID int ,
	@AllowAccess bit
AS

UPDATE {databaseOwner}{objectQualifier}TabPermission SET
	[TabID] = @TabID,
	[PermissionID] = @PermissionID,
	[RoleID] = @RoleID,
	[AllowAccess] = @AllowAccess
WHERE
	[TabPermissionID] = @TabPermissionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddTabPermission]    Script Date: 10/05/2007 21:21:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddTabPermission]
	@TabID int,
	@PermissionID int,
	@RoleID int,
	@AllowAccess bit
AS

INSERT INTO {databaseOwner}{objectQualifier}TabPermission (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteTabPermissionsByTabID]    Script Date: 10/05/2007 21:21:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteTabPermissionsByTabID]
	@TabID int
AS

DELETE FROM {databaseOwner}{objectQualifier}TabPermission
WHERE
	[TabID] = @TabID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteTabPermission]    Script Date: 10/05/2007 21:21:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteTabPermission]
	@TabPermissionID int
AS

DELETE FROM {databaseOwner}{objectQualifier}TabPermission
WHERE
	[TabPermissionID] = @TabPermissionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddUser]    Script Date: 10/05/2007 21:21:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddUser]

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
	FROM   {objectQualifier}Users
	WHERE  Username = @Username

IF @UserID is null
	BEGIN
		INSERT INTO {objectQualifier}Users (
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
		IF not exists ( SELECT 1 FROM {objectQualifier}UserPortals WHERE UserID = @UserID AND PortalID = @PortalID )
			BEGIN
				INSERT INTO {objectQualifier}UserPortals (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteUserPortal]    Script Date: 10/05/2007 21:21:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}DeleteUserPortal]
	@UserId   int,
	@PortalId int
AS

	DELETE FROM {objectQualifier}UserPortals
	WHERE Userid = @UserId and PortalId = @PortalId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateUser]    Script Date: 10/05/2007 21:23:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateUser]

	@UserId         int,
	@PortalId		int,
	@FirstName		nvarchar(50),
	@LastName		nvarchar(50),
	@Email          nvarchar(256),
	@DisplayName    nvarchar(100),
	@UpdatePassword	bit,
	@Authorised		bit

AS
UPDATE {objectQualifier}Users
SET
	FirstName = @FirstName,
    LastName = @LastName,
    Email = @Email,
	DisplayName = @DisplayName,
	UpdatePassword = @UpdatePassword
WHERE  UserId = @UserId

UPDATE {objectQualifier}UserPortals
SET
	Authorised = @Authorised
WHERE  UserId = @UserId
	AND PortalId = @PortalId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUsers]    Script Date: 10/05/2007 21:22:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetUsers]

@PortalId int

as

select *
from {objectQualifier}Users U
left join {objectQualifier}UserPortals UP on U.UserId = UP.UserId
where ( UP.PortalId = @PortalId or @PortalId is null )
order by U.FirstName + ' ' + U.LastName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModuleControl]    Script Date: 10/05/2007 21:21:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetModuleControl]

@ModuleControlId int

as

select *
from   {objectQualifier}ModuleControls
where  ModuleControlId = @ModuleControlId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModuleControlByKeyAndSrc]    Script Date: 10/05/2007 21:21:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE {databaseOwner}[{objectQualifier}GetModuleControlByKeyAndSrc]

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
from       {databaseOwner}{objectQualifier}ModuleControls
where ((ModuleDefId is null and @ModuleDefId is null) or (ModuleDefID = @ModuleDefID))
and ((ControlKey is null and @ControlKey is null) or (ControlKey = @ControlKey))
and ((ControlSrc is null and @ControlSrc is null) or (ControlSrc = @ControlSrc))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteModuleControl]    Script Date: 10/05/2007 21:21:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteModuleControl]

@ModuleControlId int

as

delete
from   {objectQualifier}ModuleControls
where  ModuleControlId = @ModuleControlId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModuleControls]    Script Date: 10/05/2007 21:21:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetModuleControls]

@ModuleDefId int

as

select *
from   {objectQualifier}ModuleControls
where  (ModuleDefId is null and @ModuleDefId is null) or (ModuleDefId = @ModuleDefId)
order  by ControlKey, ViewOrder
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModuleControlsByKey]    Script Date: 10/05/2007 21:21:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetModuleControlsByKey]

@ControlKey        nvarchar(50),
@ModuleDefId       int

as

select {objectQualifier}ModuleDefinitions.*,
       ModuleControlID,
       ControlTitle,
       ControlSrc,
       IconFile,
       ControlType,
       HelpUrl
from   {objectQualifier}ModuleControls
left outer join {objectQualifier}ModuleDefinitions on {objectQualifier}ModuleControls.ModuleDefId = {objectQualifier}ModuleDefinitions.ModuleDefId
where  ((ControlKey is null and @ControlKey is null) or (ControlKey = @ControlKey))
and    (({objectQualifier}ModuleControls.ModuleDefId is null and @ModuleDefId is null) or ({objectQualifier}ModuleControls.ModuleDefId = @ModuleDefId))
and    ControlType >= -1
order by ViewOrder
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddModuleControl]    Script Date: 10/05/2007 21:21:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure {databaseOwner}[{objectQualifier}AddModuleControl]
    
@ModuleDefID                   int,
@ControlKey                    nvarchar(50),
@ControlTitle                  nvarchar(50),
@ControlSrc                    nvarchar(256),
@IconFile                      nvarchar(100),
@ControlType                   int,
@ViewOrder                     int,
@HelpUrl                       nvarchar(200)

as

insert into {objectQualifier}ModuleControls (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateModuleControl]    Script Date: 10/05/2007 21:22:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure {databaseOwner}[{objectQualifier}UpdateModuleControl]

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

update {objectQualifier}ModuleControls
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteFolderPermissionsByFolderPath]    Script Date: 10/05/2007 21:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteFolderPermissionsByFolderPath]
	@PortalID int,
	@FolderPath varchar(300)
AS
DECLARE @FolderID int
SELECT @FolderID = FolderID FROM {databaseOwner}{objectQualifier}Folders
WHERE FolderPath = @FolderPath
AND ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))

DELETE FROM {databaseOwner}{objectQualifier}FolderPermission
WHERE
	[FolderID] = @FolderID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteFolderPermission]    Script Date: 10/05/2007 21:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteFolderPermission]
	@FolderPermissionID int
AS

DELETE FROM {databaseOwner}{objectQualifier}FolderPermission
WHERE
	[FolderPermissionID] = @FolderPermissionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateFolderPermission]    Script Date: 10/05/2007 21:22:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateFolderPermission]
	@FolderPermissionID int, 
	@FolderID int, 
	@PermissionID int, 
	@RoleID int ,
	@AllowAccess bit
AS

UPDATE {databaseOwner}{objectQualifier}FolderPermission SET
	[FolderID] = @FolderID,
	[PermissionID] = @PermissionID,
	[RoleID] = @RoleID,
	[AllowAccess] = @AllowAccess
WHERE
	[FolderPermissionID] = @FolderPermissionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddFolderPermission]    Script Date: 10/05/2007 21:21:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddFolderPermission]
	@FolderID int,
	@PermissionID int,
	@RoleID int,
	@AllowAccess bit
AS

INSERT INTO {databaseOwner}{objectQualifier}FolderPermission (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetDefaultLanguageByModule]    Script Date: 10/05/2007 21:21:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetDefaultLanguageByModule]
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
FROM            {objectQualifier}Modules  m
INNER JOIN      {objectQualifier}Portals p ON p.PortalID = m.PortalID
WHERE		m.ModuleID in (SELECT ModuleID FROM @TempList)
ORDER BY        m.ModuleID	
		
END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteModule]    Script Date: 10/05/2007 21:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteModule]

@ModuleId   int

as

delete
from   {objectQualifier}Modules 
where  ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddModule]    Script Date: 10/05/2007 21:21:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddModule]
    
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

INSERT INTO {objectQualifier}Modules ( 
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeletePortalInfo]    Script Date: 10/05/2007 21:21:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeletePortalInfo]
	@PortalId int

AS

/* Delete all the Portal Modules */
DELETE
FROM {objectQualifier}Modules
WHERE PortalId = @PortalId

/* Delete all the Portal Search Items */
DELETE {objectQualifier}Modules
FROM  {objectQualifier}Modules 
	INNER JOIN {objectQualifier}SearchItem ON {objectQualifier}Modules.ModuleID = {objectQualifier}SearchItem.ModuleId
WHERE	PortalId = @PortalId

/* Delete Portal */
DELETE
FROM {objectQualifier}Portals
WHERE  PortalId = @PortalId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPermissionsByModuleID]    Script Date: 10/05/2007 21:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPermissionsByModuleID]
	@ModuleID int
AS

SELECT
	P.[PermissionID],
	P.[PermissionCode],
	P.[ModuleDefID],
	P.[PermissionKey],
	P.[PermissionName]
FROM
	{databaseOwner}{objectQualifier}Permission P
WHERE
	P.ModuleDefID = (SELECT ModuleDefID FROM {databaseOwner}{objectQualifier}Modules WHERE ModuleID = @ModuleID)
OR 	P.PermissionCode = 'SYSTEM_MODULE_DEFINITION'
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateModule]    Script Date: 10/05/2007 21:22:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateModule]

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

UPDATE {objectQualifier}Modules
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}FindDatabaseVersion]    Script Date: 10/05/2007 21:21:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}FindDatabaseVersion]

@Major  int,
@Minor  int,
@Build  int

as

select 1
from   {objectQualifier}Version
where  Major = @Major
and    Minor = @Minor
and    Build = @Build
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateDatabaseVersion]    Script Date: 10/05/2007 21:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateDatabaseVersion]

@Major  int,
@Minor  int,
@Build  int

as

insert into {objectQualifier}Version (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetDatabaseVersion]    Script Date: 10/05/2007 21:21:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetDatabaseVersion]

as

select Major,
       Minor,
       Build
from   {objectQualifier}Version 
where  VersionId = ( select max(VersionId) from {objectQualifier}Version )
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetVendorClassifications]    Script Date: 10/05/2007 21:22:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetVendorClassifications]

@VendorId  int

as

select ClassificationId,
       ClassificationName,
       'IsAssociated' = case when exists ( select 1 from {objectQualifier}VendorClassification vc where vc.VendorId = @VendorId and vc.ClassificationId = {objectQualifier}Classification.ClassificationId ) then 1 else 0 end
from {objectQualifier}Classification
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteUsersOnline]    Script Date: 10/05/2007 21:21:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteUsersOnline]

	@TimeWindow	int
	
as
	-- Clean up the anonymous users table
	DELETE from {objectQualifier}AnonymousUsers WHERE LastActiveDate < DateAdd(minute, -@TimeWindow, GetDate())	

	-- Clean up the users online table
	DELETE from {objectQualifier}UsersOnline WHERE LastActiveDate < DateAdd(minute, -@TimeWindow, GetDate())
GO
/****** Object:  StoredProcedure [dbo].[scp_DeleteUserOnline]    Script Date: 10/12/2007 08:50:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[scp_DeleteUserOnline] 
	@UserID int
AS
	DELETE FROM scp_UsersOnline WHERE UserID = @UserID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateOnlineUser]    Script Date: 10/05/2007 21:22:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateOnlineUser]

@UserID 	int,
@PortalID 	int,
@TabID 		int,
@LastActiveDate datetime 

as
BEGIN
	IF EXISTS (SELECT UserID FROM {objectQualifier}UsersOnline WHERE UserID = @UserID and PortalID = @PortalID)
		UPDATE 
			{objectQualifier}UsersOnline
		SET 
			TabID = @TabID,
			LastActiveDate = @LastActiveDate
		WHERE
			UserID = @UserID
			and 
			PortalID = @PortalID
	ELSE
		INSERT INTO
			{objectQualifier}UsersOnline
			(UserID, PortalID, TabID, CreationDate, LastActiveDate) 
		VALUES
			(@UserId, @PortalID, @TabID, GetDate(), @LastActiveDate)

END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetOnlineUser]    Script Date: 10/05/2007 21:22:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetOnlineUser]
	@UserID int

AS

SELECT
		{objectQualifier}UsersOnline.UserID,
		{objectQualifier}Users.UserName
	FROM   {objectQualifier}UsersOnline
	INNER JOIN {objectQualifier}Users ON {objectQualifier}UsersOnline.UserID = {objectQualifier}Users.UserID
	WHERE  {objectQualifier}UsersOnline.UserID = @UserID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddSearchItem]    Script Date: 10/05/2007 21:21:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddSearchItem]

	@Title nvarchar(200),
	@Description nvarchar(2000),
	@Author int,
	@PubDate datetime,
	@ModuleId int,
	@SearchKey nvarchar(100),
	@Guid nvarchar(200), 
	@ImageFileId int

as

insert into {objectQualifier}SearchItem (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteSearchItem]    Script Date: 10/05/2007 21:21:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteSearchItem]
	@SearchItemID int
AS

DELETE FROM {databaseOwner}{objectQualifier}SearchItem
WHERE
	[SearchItemID] = @SearchItemID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchItem]    Script Date: 10/05/2007 21:22:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSearchItem]
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
	{objectQualifier}SearchItem
where
	[ModuleID] = @ModuleID AND
	[SearchKey] = @SearchKey
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateSearchItem]    Script Date: 10/05/2007 21:22:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateSearchItem]
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

UPDATE {objectQualifier}SearchItem 
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}ListSearchItem]    Script Date: 10/05/2007 21:22:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}ListSearchItem]

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
	{objectQualifier}SearchItem
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteSearchItems]    Script Date: 10/05/2007 21:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}DeleteSearchItems]
(
	@ModuleID int
)
AS

DELETE
FROM	{objectQualifier}SearchItem
WHERE	ModuleID = @ModuleID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchIndexers]    Script Date: 10/05/2007 21:22:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSearchIndexers]

as

select {objectQualifier}SearchIndexer.*
from {objectQualifier}SearchIndexer
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteModuleDefinition]    Script Date: 10/05/2007 21:21:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteModuleDefinition]

@ModuleDefId int

as

delete
from {objectQualifier}ModuleDefinitions
where  ModuleDefId = @ModuleDefId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddModuleDefinition]    Script Date: 10/05/2007 21:21:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}AddModuleDefinition]

	@DesktopModuleId int,    
	@FriendlyName    nvarchar(128),
	@DefaultCacheTime int

as

insert into {objectQualifier}ModuleDefinitions (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateModuleDefinition]    Script Date: 10/05/2007 21:22:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}UpdateModuleDefinition]

	@ModuleDefId int,    
	@FriendlyName    nvarchar(128),
	@DefaultCacheTime int

as

update {objectQualifier}ModuleDefinitions 
	SET FriendlyName = @FriendlyName,
		DefaultCacheTime = @DefaultCacheTime
	WHERE ModuleDefId = @ModuleDefId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModuleDefinitionByName]    Script Date: 10/05/2007 21:22:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetModuleDefinitionByName]

@DesktopModuleId int,    
@FriendlyName    nvarchar(128)

as

select *
from   {objectQualifier}ModuleDefinitions
where  DesktopModuleId = @DesktopModuleId
and    FriendlyName = @FriendlyName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModuleDefinition]    Script Date: 10/05/2007 21:21:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetModuleDefinition]

@ModuleDefId int

as

select *
from {objectQualifier}ModuleDefinitions
where  ModuleDefId = @ModuleDefId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModuleDefinitions]    Script Date: 10/05/2007 21:22:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetModuleDefinitions]

@DesktopModuleId int

as

select *
from   {databaseOwner}{objectQualifier}ModuleDefinitions
where  DesktopModuleId = @DesktopModuleId or @DesktopModuleId = -1
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateFile]    Script Date: 10/05/2007 21:22:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateFile]
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

UPDATE {objectQualifier}Files
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetFileById]    Script Date: 10/05/2007 21:21:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetFileById]

@FileId   int,
@PortalId int

as

select FileId,
       {objectQualifier}Folders.PortalId,
       FileName,
       Extension,
       Size,
       Width,
       Height,
       ContentType,
       {objectQualifier}Files.FolderID,
       'Folder' = FolderPath,
       StorageLocation,
       IsCached
from   {objectQualifier}Files
inner join {objectQualifier}Folders on {objectQualifier}Files.FolderID = {objectQualifier}Folders.FolderID
where  FileId = @FileId
and    (({objectQualifier}Folders.PortalId = @PortalId) or (@PortalId is null and {objectQualifier}Folders.PortalId is null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModuleSettings]    Script Date: 10/05/2007 21:22:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModuleSettings]

@ModuleId int

AS
SELECT 
	SettingName,
	CASE WHEN LEFT(LOWER({objectQualifier}ModuleSettings.SettingValue), 6) = 'fileid' 
		THEN
			(SELECT Folder + FileName  
				FROM {objectQualifier}Files 
				WHERE 'fileid=' + convert(varchar,{objectQualifier}Files.FileID) = {objectQualifier}ModuleSettings.SettingValue
			) 
		ELSE 
			{objectQualifier}ModuleSettings.SettingValue  
		END 
	AS SettingValue
FROM {objectQualifier}ModuleSettings 
WHERE  ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetVendor]    Script Date: 10/05/2007 21:22:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetVendor]

@VendorId int,
@PortalId int

as

select {objectQualifier}Vendors.VendorName, 
       {objectQualifier}Vendors.Unit, 
       {objectQualifier}Vendors.Street, 
       {objectQualifier}Vendors.City, 
       {objectQualifier}Vendors.Region, 
       {objectQualifier}Vendors.Country, 
       {objectQualifier}Vendors.PostalCode, 
       {objectQualifier}Vendors.Telephone,
       {objectQualifier}Vendors.Fax,
       {objectQualifier}Vendors.Cell,
       {objectQualifier}Vendors.Email,
       {objectQualifier}Vendors.Website,
       {objectQualifier}Vendors.FirstName,
       {objectQualifier}Vendors.LastName,
       {objectQualifier}Vendors.ClickThroughs,
       {objectQualifier}Vendors.Views,
       'CreatedByUser' = {objectQualifier}Users.FirstName + ' ' + {objectQualifier}Users.LastName,
       {objectQualifier}Vendors.CreatedDate,
      'LogoFile' = case when {objectQualifier}Files.FileName is null then {objectQualifier}Vendors.LogoFile else {objectQualifier}Files.Folder + {objectQualifier}Files.FileName end,
       {objectQualifier}Vendors.KeyWords,
       {objectQualifier}Vendors.Authorized,
       {objectQualifier}Vendors.PortalId
from {objectQualifier}Vendors
left outer join {objectQualifier}Users on {objectQualifier}Vendors.CreatedByUser = {objectQualifier}Users.UserId
left outer join {objectQualifier}Files on {objectQualifier}Vendors.LogoFile = 'fileid=' + convert(varchar,{objectQualifier}Files.FileID)
where  VendorId = @VendorId
and    (({objectQualifier}Vendors.PortalId = @PortalId) or ({objectQualifier}Vendors.PortalId is null and @PortalId is null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddFile]    Script Date: 10/05/2007 21:21:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddFile]

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

SELECT @FileId = FileID FROM {objectQualifier}Files WHERE FolderID = @FolderID AND FileName = @FileName

IF @FileID IS Null
    BEGIN
      INSERT INTO {objectQualifier}Files (
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
      UPDATE {objectQualifier}Files
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetBanner]    Script Date: 10/05/2007 21:21:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetBanner]

@BannerId int,
@VendorId int,
@PortalID int

as

select {objectQualifier}Banners.BannerId,
       {objectQualifier}Banners.VendorId,
       'ImageFile' = case when {objectQualifier}Files.FileName is null then {objectQualifier}Banners.ImageFile else {objectQualifier}Files.Folder + {objectQualifier}Files.FileName end,
       {objectQualifier}Banners.BannerName,
       {objectQualifier}Banners.Impressions,
       {objectQualifier}Banners.CPM,
       {objectQualifier}Banners.Views,
       {objectQualifier}Banners.ClickThroughs,
       {objectQualifier}Banners.StartDate,
       {objectQualifier}Banners.EndDate,
       'CreatedByUser' = {objectQualifier}Users.FirstName + ' ' + {objectQualifier}Users.LastName,
       {objectQualifier}Banners.CreatedDate,
       {objectQualifier}Banners.BannerTypeId,
       {objectQualifier}Banners.Description,
       {objectQualifier}Banners.GroupName,
       {objectQualifier}Banners.Criteria,
       {objectQualifier}Banners.URL,        
       {objectQualifier}Banners.Width,
       {objectQualifier}Banners.Height
FROM   {objectQualifier}Banners 
INNER JOIN {objectQualifier}Vendors ON {objectQualifier}Banners.VendorId = {objectQualifier}Vendors.VendorId 
LEFT OUTER JOIN {objectQualifier}Users ON {objectQualifier}Banners.CreatedByUser = {objectQualifier}Users.UserID
left outer join {objectQualifier}Files on {objectQualifier}Banners.ImageFile = 'FileId=' + convert(varchar,{objectQualifier}Files.FileID)
where  {objectQualifier}Banners.BannerId = @BannerId
and   {objectQualifier}Banners.vendorId = @VendorId
AND ({objectQualifier}Vendors.PortalId = @PortalID or ({objectQualifier}Vendors.PortalId is null and @portalid is null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateFileContent]    Script Date: 10/05/2007 21:22:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}UpdateFileContent]

@FileId      int,
@Content     image

as

update {objectQualifier}Files
set    Content = @Content
where  FileId = @FileId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteFiles]    Script Date: 10/05/2007 21:21:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteFiles]

@PortalId int

as

delete 
from   {objectQualifier}Files
where  ((PortalId = @PortalId) or (@PortalId is null and PortalId is null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModuleSetting]    Script Date: 10/05/2007 21:22:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModuleSetting]

@ModuleId      int,
@SettingName   nvarchar(50)

AS
SELECT 
	CASE WHEN LEFT(LOWER({objectQualifier}ModuleSettings.SettingValue), 6) = 'fileid' 
		THEN
			(SELECT Folder + FileName  
				FROM {objectQualifier}Files 
				WHERE 'fileid=' + convert(varchar,{objectQualifier}Files.FileID) = {objectQualifier}ModuleSettings.SettingValue
			) 
		ELSE 
			{objectQualifier}ModuleSettings.SettingValue  
		END 
	AS SettingValue
FROM {objectQualifier}ModuleSettings 
WHERE  ModuleId = @ModuleId AND SettingName = @SettingName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteFile]    Script Date: 10/05/2007 21:21:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteFile]
	@PortalId int,
	@FileName nvarchar(100),
	@FolderID int

AS

DELETE 
FROM   {objectQualifier}Files
WHERE  FileName = @FileName
AND    FolderID = @FolderID
AND    ((PortalId = @PortalId) OR (@PortalId IS Null AND PortalId IS Null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetFileContent]    Script Date: 10/05/2007 21:21:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetFileContent]

@FileId   int,
@PortalId int

as

select Content
from   {objectQualifier}Files
where  FileId = @FileId
and    (({objectQualifier}Files.PortalId = @PortalId) or (@PortalId is null and {objectQualifier}Files.PortalId is null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetFiles]    Script Date: 10/05/2007 21:21:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetFiles]

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
	{objectQualifier}Files F
INNER JOIN 
	{objectQualifier}Folders FO on F.FolderID = FO.FolderID
WHERE   
	F.FolderID = @FolderID
AND     
	((FO.PortalId = @PortalId) or (@PortalId is NULL AND FO.PortalId is NULL))
ORDER BY FileName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetFile]    Script Date: 10/05/2007 21:21:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetFile]

@FileName  nvarchar(100),
@PortalId  int,
@FolderID  int

as

select FileId,
       {objectQualifier}Folders.PortalId,
       FileName,
       Extension,
       Size,
       Width,
       Height,
       ContentType,
       {objectQualifier}Files.FolderID,
       'Folder' = FolderPath,
       StorageLocation,
       IsCached
from {objectQualifier}Files
inner join {objectQualifier}Folders on {objectQualifier}Files.FolderID = {objectQualifier}Folders.FolderID
where  FileName = @FileName 
and    {objectQualifier}Files.FolderID = @FolderID
and    (({objectQualifier}Folders.PortalId = @PortalId) or (@PortalId is null and {objectQualifier}Folders.PortalId is null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}FindBanners]    Script Date: 10/05/2007 21:21:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}FindBanners]
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
					FROM {objectQualifier}Files 
					WHERE 'fileid=' + convert(varchar,{objectQualifier}Files.FileID) = ImageFile
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
FROM    {objectQualifier}Banners B
INNER JOIN {objectQualifier}Vendors V ON B.VendorId = V.VendorId
WHERE   (B.BannerTypeId = @BannerTypeId or @BannerTypeId is null)
AND     (B.GroupName = @GroupName or @GroupName is null)
AND     ((V.PortalId = @PortalId) or (@PortalId is null and V.PortalId is null))
AND     V.Authorized = 1 
AND     (getdate() <= B.EndDate or B.EndDate is null)
ORDER BY BannerId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetAllFiles]    Script Date: 10/05/2007 21:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetAllFiles]

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
	{objectQualifier}Files F

INNER JOIN 
	{objectQualifier}Folders FO on F.FolderID = FO.FolderID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortalSpaceUsed]    Script Date: 10/05/2007 21:22:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPortalSpaceUsed]
	@PortalId int
AS

SELECT 'SpaceUsed' = SUM(CAST(Size as bigint))
FROM   {objectQualifier}Files
WHERE  ((PortalId = @PortalId) OR (@PortalId is null and PortalId is null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeletePropertyDefinition]    Script Date: 10/05/2007 21:21:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeletePropertyDefinition]

	@PropertyDefinitionId int

AS

UPDATE {databaseOwner}{objectQualifier}ProfilePropertyDefinition 
	SET Deleted = 1
	WHERE  PropertyDefinitionId = @PropertyDefinitionId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddPropertyDefinition]    Script Date: 10/05/2007 21:21:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddPropertyDefinition]
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
    @Length int,
    @Searchable bit

AS
DECLARE @PropertyDefinitionId int

SELECT @PropertyDefinitionId = PropertyDefinitionId
	FROM   {objectQualifier}ProfilePropertyDefinition
	WHERE  (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		AND PropertyName = @PropertyName

IF @PropertyDefinitionId is null
	BEGIN
		INSERT {objectQualifier}ProfilePropertyDefinition	(
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
				Length,
				Searchable
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
				@Length,
				@Searchable
			)

		SELECT @PropertyDefinitionId = SCOPE_IDENTITY()
	END
ELSE
	BEGIN
		UPDATE {objectQualifier}ProfilePropertyDefinition 
			SET DataType = @DataType,
				ModuleDefId = @ModuleDefId,
				DefaultValue = @DefaultValue,
				PropertyCategory = @PropertyCategory,
				Required = @Required,
				ValidationExpression = @ValidationExpression,
				ViewOrder = @ViewOrder,
				Deleted = 0,
				Visible = @Visible,
				Length = @Length,
				Searchable = @Searchable
			WHERE PropertyDefinitionId = @PropertyDefinitionId
	END
	
SELECT @PropertyDefinitionId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPropertyDefinitionsByPortal]    Script Date: 10/05/2007 21:22:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPropertyDefinitionsByPortal]

	@PortalID	int

AS
SELECT	{databaseOwner}{objectQualifier}ProfilePropertyDefinition.*
	FROM	{databaseOwner}{objectQualifier}ProfilePropertyDefinition
	WHERE  (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		AND Deleted = 0
	ORDER BY ViewOrder
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPropertyDefinitionByName]    Script Date: 10/05/2007 21:22:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPropertyDefinitionByName]
	@PortalID	int,
	@Name		nvarchar(50)

AS
SELECT	*
	FROM	{objectQualifier}ProfilePropertyDefinition
	WHERE  (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		AND PropertyName = @Name
	ORDER BY ViewOrder
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdatePropertyDefinition]    Script Date: 10/05/2007 21:22:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdatePropertyDefinition]
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

UPDATE {databaseOwner}{objectQualifier}ProfilePropertyDefinition 
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPropertyDefinitionsByCategory]    Script Date: 10/05/2007 21:22:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPropertyDefinitionsByCategory]
	@PortalID	int,
	@Category	nvarchar(50)

AS
SELECT	*
	FROM	{objectQualifier}ProfilePropertyDefinition
	WHERE  (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		AND PropertyCategory = @Category
	ORDER BY ViewOrder
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPropertyDefinition]    Script Date: 10/05/2007 21:22:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPropertyDefinition]

	@PropertyDefinitionID	int

AS
SELECT	{databaseOwner}{objectQualifier}ProfilePropertyDefinition.*
FROM	{databaseOwner}{objectQualifier}ProfilePropertyDefinition
WHERE PropertyDefinitionID = @PropertyDefinitionID
	AND Deleted = 0
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateAnonymousUser]    Script Date: 10/05/2007 21:22:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateAnonymousUser]

@UserID 	char(36),
@PortalID 	int,
@TabID 		int,
@LastActiveDate datetime 

as
BEGIN
	IF EXISTS (SELECT UserID FROM {objectQualifier}AnonymousUsers WHERE UserID = @UserID and PortalID = @PortalID)
		UPDATE 
			{objectQualifier}AnonymousUsers
		SET 
			TabID = @TabID,
			LastActiveDate = @LastActiveDate
		WHERE
			UserID = @UserID
			and 
			PortalID = @PortalID
	ELSE
		INSERT INTO
			{objectQualifier}AnonymousUsers
			(UserID, PortalID, TabID, CreationDate, LastActiveDate) 
		VALUES
			(@UserId, @PortalID, @TabID, GetDate(), @LastActiveDate)

END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetEventLogPendingNotifConfig]    Script Date: 10/05/2007 21:21:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetEventLogPendingNotifConfig]
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
FROM {databaseOwner}{objectQualifier}EventLogConfig elc
INNER JOIN {databaseOwner}{objectQualifier}EventLog
ON {databaseOwner}{objectQualifier}EventLog.LogConfigID = elc.ID
WHERE {databaseOwner}{objectQualifier}EventLog.LogNotificationPending = 1
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddEventLog]    Script Date: 10/05/2007 21:21:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddEventLog]
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
INSERT INTO {databaseOwner}{objectQualifier}EventLog
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
FROM {databaseOwner}{objectQualifier}EventLogConfig
WHERE ID = @LogConfigID

IF @NotificationActive=1
BEGIN
	
	SELECT @ThresholdQueue = COUNT(*)
	FROM {databaseOwner}{objectQualifier}EventLog
	INNER JOIN {databaseOwner}{objectQualifier}EventLogConfig
	ON {databaseOwner}{objectQualifier}EventLog.LogConfigID = {databaseOwner}{objectQualifier}EventLogConfig.ID
	WHERE LogCreateDate > @MinDateTime

	PRINT 'MinDateTime=' + convert(varchar(20), @MinDateTime)
	PRINT 'ThresholdQueue=' + convert(varchar(20), @ThresholdQueue)
	PRINT 'NotificationThreshold=' + convert(varchar(20), @NotificationThreshold)

	IF @ThresholdQueue > @NotificationThreshold
	BEGIN
		UPDATE {databaseOwner}{objectQualifier}EventLog
		SET LogNotificationPending = 1 
		WHERE LogConfigID = @LogConfigID
		AND LogNotificationPending IS NULL		
		AND LogCreateDate > @MinDateTime
	END
END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetEventLogPendingNotif]    Script Date: 10/05/2007 21:21:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetEventLogPendingNotif]
	@LogConfigID int
AS
SELECT *
FROM {databaseOwner}{objectQualifier}EventLog
WHERE LogNotificationPending = 1
AND LogConfigID = @LogConfigID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateEventLogPendingNotif]    Script Date: 10/05/2007 21:22:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateEventLogPendingNotif]
	@LogConfigID int
AS
UPDATE {databaseOwner}{objectQualifier}EventLog
SET LogNotificationPending = 0
WHERE LogNotificationPending = 1
AND LogConfigID = @LogConfigID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetEventLogByLogGUID]    Script Date: 10/05/2007 21:21:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetEventLogByLogGUID]
	@LogGUID varchar(36)
AS
SELECT *
FROM {databaseOwner}{objectQualifier}EventLog
WHERE (LogGUID = @LogGUID)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}PurgeEventLog]    Script Date: 10/05/2007 21:22:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}PurgeEventLog]
AS
DELETE FROM {databaseOwner}{objectQualifier}EventLog
FROM {databaseOwner}{objectQualifier}EventLogConfig elc
WHERE 
    (
    SELECT COUNT(*)
    FROM {databaseOwner}{objectQualifier}EventLog el
    WHERE el.LogConfigID = elc.ID
	and {databaseOwner}{objectQualifier}EventLog.LogTypeKey = el.LogTypeKey
	and el.LogCreateDate >= {databaseOwner}{objectQualifier}EventLog.LogCreateDate
    ) > elc.KeepMostRecent
AND elc.KeepMostRecent<>-1
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteEventLog]    Script Date: 10/05/2007 21:21:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteEventLog]
	@LogGUID varchar(36)
AS
DELETE FROM {databaseOwner}{objectQualifier}EventLog
WHERE LogGUID = @LogGUID or @LogGUID IS NULL
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddPortalDesktopModule]    Script Date: 10/05/2007 21:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddPortalDesktopModule]

@PortalId int,
@DesktopModuleId int

as

insert into {objectQualifier}PortalDesktopModules ( 
  PortalId,
  DesktopModuleId
)
values (
  @PortalId,
  @DesktopModuleId
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetDesktopModulesByPortal]    Script Date: 10/05/2007 21:21:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetDesktopModulesByPortal]

	@PortalId int

AS

SELECT distinct({objectQualifier}DesktopModules.DesktopModuleId) AS DesktopModuleId,
       {objectQualifier}DesktopModules.FriendlyName,
       {objectQualifier}DesktopModules.Description,
       {objectQualifier}DesktopModules.Version,
       {objectQualifier}DesktopModules.ispremium,
       {objectQualifier}DesktopModules.isadmin,
       {objectQualifier}DesktopModules.businesscontrollerclass,
       {objectQualifier}DesktopModules.foldername,
       {objectQualifier}DesktopModules.modulename,
       {objectQualifier}DesktopModules.supportedfeatures,
       {objectQualifier}DesktopModules.compatibleversions
FROM {objectQualifier}DesktopModules
LEFT OUTER JOIN {objectQualifier}PortalDesktopModules on {objectQualifier}DesktopModules.DesktopModuleId = {objectQualifier}PortalDesktopModules.DesktopModuleId
WHERE  IsAdmin = 0
AND    ( IsPremium = 0 OR (PortalId = @PortalId AND PortalDesktopModuleId IS NOT Null)) 
ORDER BY FriendlyName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeletePortalDesktopModules]    Script Date: 10/05/2007 21:21:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeletePortalDesktopModules]

@PortalId        int,
@DesktopModuleId int

as

delete
from   {objectQualifier}PortalDesktopModules
where  ((PortalId = @PortalId) or (@PortalId is null and @DesktopModuleId is not null))
and    ((DesktopModuleId = @DesktopModuleId) or (@DesktopModuleId is null and @PortalId is not null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortalDesktopModules]    Script Date: 10/05/2007 21:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetPortalDesktopModules]

@PortalId int,
@DesktopModuleId int

as

select {objectQualifier}PortalDesktopModules.*,
       PortalName,
       FriendlyName
from   {objectQualifier}PortalDesktopModules
inner join {objectQualifier}Portals on {objectQualifier}PortalDesktopModules.PortalId = {objectQualifier}Portals.PortalId
inner join {objectQualifier}DesktopModules on {objectQualifier}PortalDesktopModules.DesktopModuleId = {objectQualifier}DesktopModules.DesktopModuleId
where  (({objectQualifier}PortalDesktopModules.PortalId = @PortalId) or @PortalId is null)
and    (({objectQualifier}PortalDesktopModules.DesktopModuleId = @DesktopModuleId) or @DesktopModuleId is null)
order by {objectQualifier}PortalDesktopModules.PortalId, {objectQualifier}PortalDesktopModules.DesktopModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateTabOrder]    Script Date: 10/05/2007 21:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateTabOrder]

@TabId    int,
@TabOrder int,
@Level    int,
@ParentId int

as

update {objectQualifier}Tabs
set    TabOrder = @TabOrder,
       Level = @Level,
       ParentId = @ParentId
where  TabId = @TabId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}VerifyPortalTab]    Script Date: 10/05/2007 21:23:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}VerifyPortalTab]

@PortalId int,
@TabId    int

as

select {objectQualifier}Tabs.TabId
from {objectQualifier}Tabs
left outer join {objectQualifier}Portals on {objectQualifier}Tabs.PortalId = {objectQualifier}Portals.PortalId
where  TabId = @TabId
and    ( {objectQualifier}Portals.PortalId = @PortalId or {objectQualifier}Tabs.PortalId is null )
and    IsDeleted = 0
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteTab]    Script Date: 10/05/2007 21:21:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteTab]

@TabId int

as

delete
from {objectQualifier}Tabs
where  TabId = @TabId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTabCount]    Script Date: 10/05/2007 21:22:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabCount]
	
	@PortalId	int

AS

DECLARE @AdminTabId int
SET @AdminTabId = (SELECT AdminTabId 
						FROM {objectQualifier}Portals 
						WHERE PortalID = @PortalID)

SELECT COUNT(*) - 1 
FROM  {objectQualifier}Tabs
WHERE (PortalID = @PortalID) 
	AND (TabID <> @AdminTabId) 
	AND (ParentId <> @AdminTabId OR ParentId IS NULL)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddTab]    Script Date: 10/05/2007 21:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}AddTab]

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

insert into {objectQualifier}Tabs (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}VerifyPortal]    Script Date: 10/05/2007 21:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}VerifyPortal]

@PortalId int

as

select {objectQualifier}Tabs.TabId
from {objectQualifier}Tabs
inner join {objectQualifier}Portals on {objectQualifier}Tabs.PortalId = {objectQualifier}Portals.PortalId
where {objectQualifier}Portals.PortalId = @PortalId
and {objectQualifier}Tabs.TabOrder = 1
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateTab]    Script Date: 10/05/2007 21:23:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}UpdateTab]

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

update {objectQualifier}Tabs
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortalByTab]    Script Date: 10/05/2007 21:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetPortalByTab]

@TabId int,
@HTTPAlias nvarchar(200)
 
as

select HTTPAlias
from {databaseOwner}{objectQualifier}PortalAlias
inner join {databaseOwner}{objectQualifier}Tabs on {databaseOwner}{objectQualifier}PortalAlias.PortalId = {databaseOwner}{objectQualifier}Tabs.PortalId
where  TabId = @TabId
and    HTTPAlias = @HTTPAlias
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteUserRole]    Script Date: 10/05/2007 21:21:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteUserRole]

@UserId int,
@RoleId int

as

delete
from {objectQualifier}UserRoles
where  UserId = @UserId
and    RoleId = @RoleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddUserRole]    Script Date: 10/05/2007 21:21:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddUserRole]

	@PortalId		int,
	@UserId			int,
	@RoleId			int,
	@EffectiveDate	datetime = null,
	@ExpiryDate		datetime = null

AS
DECLARE @UserRoleId int

SELECT @UserRoleId = null

SELECT @UserRoleId = UserRoleId
	FROM   {objectQualifier}UserRoles
	WHERE  UserId = @UserId AND RoleId = @RoleId
 
IF @UserRoleId IS NOT NULL
	BEGIN
		UPDATE {objectQualifier}UserRoles
			SET ExpiryDate = @ExpiryDate,
				EffectiveDate = @EffectiveDate	
			WHERE  UserRoleId = @UserRoleId
		SELECT @UserRoleId
	END
ELSE
	BEGIN
		INSERT INTO {objectQualifier}UserRoles (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateUserRole]    Script Date: 10/05/2007 21:23:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateUserRole] 
    @UserRoleId int, 
	@EffectiveDate	datetime = null,
	@ExpiryDate		datetime = null
AS

UPDATE {objectQualifier}UserRoles 
	SET ExpiryDate = @ExpiryDate,
		EffectiveDate = @EffectiveDate	
	WHERE  UserRoleId = @UserRoleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddModulePermission]    Script Date: 10/05/2007 21:21:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddModulePermission]
	@ModuleID int,
	@PermissionID int,
	@RoleID int,
	@AllowAccess bit
AS

INSERT INTO {databaseOwner}{objectQualifier}ModulePermission (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteModulePermissionsByModuleID]    Script Date: 10/05/2007 21:21:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteModulePermissionsByModuleID]
	@ModuleID int
AS

DELETE FROM {databaseOwner}{objectQualifier}ModulePermission
WHERE
	[ModuleID] = @ModuleID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteModulePermission]    Script Date: 10/05/2007 21:21:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteModulePermission]
	@ModulePermissionID int
AS

DELETE FROM {databaseOwner}{objectQualifier}ModulePermission
WHERE
	[ModulePermissionID] = @ModulePermissionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateModulePermission]    Script Date: 10/05/2007 21:22:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateModulePermission]
	@ModulePermissionID int, 
	@ModuleID int, 
	@PermissionID int, 
	@RoleID int ,
	@AllowAccess bit
AS

UPDATE {databaseOwner}{objectQualifier}ModulePermission SET
	[ModuleID] = @ModuleID,
	[PermissionID] = @PermissionID,
	[RoleID] = @RoleID,
	[AllowAccess] = @AllowAccess
WHERE
	[ModulePermissionID] = @ModulePermissionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddScheduleItemSetting]    Script Date: 10/05/2007 21:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddScheduleItemSetting]

@ScheduleID     int,
@Name           nvarchar(50),
@Value			nvarchar(256)

as

IF EXISTS ( SELECT * FROM {databaseOwner}{objectQualifier}ScheduleItemSettings WHERE ScheduleID = @ScheduleID AND SettingName = @Name)
BEGIN 
	UPDATE	{databaseOwner}{objectQualifier}ScheduleItemSettings
	SET		SettingValue = @Value
	WHERE	ScheduleID = @ScheduleID
	AND		SettingName = @Name
END 
ELSE 
BEGIN 
	INSERT INTO {databaseOwner}{objectQualifier}ScheduleItemSettings (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetScheduleItemSettings]    Script Date: 10/05/2007 21:22:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetScheduleItemSettings] 
@ScheduleID int
AS
SELECT *
FROM {databaseOwner}{objectQualifier}ScheduleItemSettings
WHERE ScheduleID = @ScheduleID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteVendor]    Script Date: 10/05/2007 21:21:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteVendor]

@VendorId int

as

delete
from {objectQualifier}Vendors
where  VendorId = @VendorId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetAffiliate]    Script Date: 10/05/2007 21:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetAffiliate]
	@AffiliateId int,
	@VendorId int,
	@PortalID int
AS

	SELECT	{objectQualifier}Affiliates.AffiliateId,
		{objectQualifier}Affiliates.VendorId,
		{objectQualifier}Affiliates.StartDate,
		{objectQualifier}Affiliates.EndDate,
		{objectQualifier}Affiliates.CPC,
		{objectQualifier}Affiliates.Clicks,
		{objectQualifier}Affiliates.CPA,
		{objectQualifier}Affiliates.Acquisitions
	FROM	{objectQualifier}Affiliates 
	INNER JOIN {objectQualifier}Vendors ON {objectQualifier}Affiliates.VendorId = {objectQualifier}Vendors.VendorId
	WHERE	{objectQualifier}Affiliates.AffiliateId = @AffiliateId
	AND	{objectQualifier}Affiliates.VendorId = @VendorId
	AND	({objectQualifier}Vendors.PortalId = @PortalID or ({objectQualifier}Vendors.PortalId is null and @portalid is null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddVendor]    Script Date: 10/05/2007 21:21:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}AddVendor]

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

insert into {objectQualifier}Vendors (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetBannerGroups]    Script Date: 10/05/2007 21:21:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetBannerGroups]
	@PortalId int
AS

SELECT  GroupName
FROM {databaseOwner}{objectQualifier}Banners
INNER JOIN {databaseOwner}{objectQualifier}Vendors ON 
	{databaseOwner}{objectQualifier}Banners.VendorId = {databaseOwner}{objectQualifier}Vendors.VendorId
WHERE ({databaseOwner}{objectQualifier}Vendors.PortalId = @PortalId) OR 
	(@PortalId is null and {databaseOwner}{objectQualifier}Vendors.PortalId is null)
GROUP BY GroupName
ORDER BY GroupName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateVendor]    Script Date: 10/05/2007 21:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}UpdateVendor]

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

update {objectQualifier}Vendors
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchItemWordBySearchWord]    Script Date: 10/05/2007 21:22:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItemWordBySearchWord]
	@SearchWordsID int
AS

SELECT
	[SearchItemWordID],
	[SearchItemID],
	[SearchWordsID],
	[Occurrences]
FROM
	{databaseOwner}{objectQualifier}SearchItemWord
WHERE
	[SearchWordsID]=@SearchWordsID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteSearchItemWords]    Script Date: 10/05/2007 21:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteSearchItemWords]
	@SearchItemID int
AS

delete from {databaseOwner}{objectQualifier}SearchItemWord
where
	[SearchItemID] = @SearchItemID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateSearchItemWord]    Script Date: 10/05/2007 21:22:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateSearchItemWord]
	@SearchItemWordID int, 
	@SearchItemID int, 
	@SearchWordsID int, 
	@Occurrences int 
AS

UPDATE {databaseOwner}{objectQualifier}SearchItemWord SET
	[SearchItemID] = @SearchItemID,
	[SearchWordsID] = @SearchWordsID,
	[Occurrences] = @Occurrences
WHERE
	[SearchItemWordID] = @SearchItemWordID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteSearchItemWord]    Script Date: 10/05/2007 21:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteSearchItemWord]
	@SearchItemWordID int
AS

DELETE FROM {databaseOwner}{objectQualifier}SearchItemWord
WHERE
	[SearchItemWordID] = @SearchItemWordID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchItemWord]    Script Date: 10/05/2007 21:22:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItemWord]
	@SearchItemWordID int
	
AS

SELECT
	[SearchItemWordID],
	[SearchItemID],
	[SearchWordsID],
	[Occurrences]
FROM
	{databaseOwner}{objectQualifier}SearchItemWord
WHERE
	[SearchItemWordID] = @SearchItemWordID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddSearchItemWord]    Script Date: 10/05/2007 21:21:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddSearchItemWord]
	@SearchItemID int,
	@SearchWordsID int,
	@Occurrences int

AS

DECLARE @ID int
SELECT @id = SearchItemWordID 
	FROM {objectQualifier}SearchItemWord
	WHERE SearchItemID=@SearchItemID 
		AND SearchWordsID=@SearchWordsID
 

IF @ID IS NULL
	BEGIN
		INSERT INTO {objectQualifier}SearchItemWord (
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

	UPDATE {objectQualifier}SearchItemWord 
		SET Occurrences = @Occurrences 
		WHERE SearchItemWordID=@id 
			AND Occurrences<>@Occurrences

SELECT @id
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}ListSearchItemWord]    Script Date: 10/05/2007 21:22:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}ListSearchItemWord]
AS

SELECT
	[SearchItemWordID],
	[SearchItemID],
	[SearchWordsID],
	[Occurrences]
FROM
	{databaseOwner}{objectQualifier}SearchItemWord
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchItemWordBySearchItem]    Script Date: 10/05/2007 21:22:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItemWordBySearchItem]
	@SearchItemID int
AS

SELECT
	[SearchItemWordID],
	[SearchItemID],
	[SearchWordsID],
	[Occurrences]
FROM
	{databaseOwner}{objectQualifier}SearchItemWord
WHERE
	[SearchItemID]=@SearchItemID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteModuleSetting]    Script Date: 10/05/2007 21:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteModuleSetting]
@ModuleId      int,
@SettingName   nvarchar(50)
as

DELETE FROM {objectQualifier}ModuleSettings 
WHERE ModuleId = @ModuleId
AND SettingName = @SettingName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateModuleSetting]    Script Date: 10/05/2007 21:22:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateModuleSetting]

@ModuleId      int,
@SettingName   nvarchar(50),
@SettingValue  nvarchar(2000)

as

update {objectQualifier}ModuleSettings
set SettingValue = @SettingValue
where ModuleId = @ModuleId
and SettingName = @SettingName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteModuleSettings]    Script Date: 10/05/2007 21:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteModuleSettings]
@ModuleId      int
as

DELETE FROM {objectQualifier}ModuleSettings 
WHERE ModuleId = @ModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddModuleSetting]    Script Date: 10/05/2007 21:21:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddModuleSetting]

@ModuleId      int,
@SettingName   nvarchar(50),
@SettingValue  nvarchar(2000)

as

insert into {objectQualifier}ModuleSettings ( 
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddEventLogType]    Script Date: 10/05/2007 21:21:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddEventLogType]
	@LogTypeKey nvarchar(35),
	@LogTypeFriendlyName nvarchar(50),
	@LogTypeDescription nvarchar(128),
	@LogTypeOwner nvarchar(100),
	@LogTypeCSSClass nvarchar(40)
AS
	INSERT INTO {databaseOwner}{objectQualifier}EventLogTypes
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetEventLogType]    Script Date: 10/05/2007 21:21:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetEventLogType]
AS
SELECT *
FROM {databaseOwner}{objectQualifier}EventLogTypes
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateEventLogType]    Script Date: 10/05/2007 21:22:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateEventLogType]
	@LogTypeKey nvarchar(35),
	@LogTypeFriendlyName nvarchar(50),
	@LogTypeDescription nvarchar(128),
	@LogTypeOwner nvarchar(100),
	@LogTypeCSSClass nvarchar(40)
AS
UPDATE {databaseOwner}{objectQualifier}EventLogTypes
	SET LogTypeFriendlyName = @LogTypeFriendlyName,
	LogTypeDescription = @LogTypeDescription,
	LogTypeOwner = @LogTypeOwner,
	LogTypeCSSClass = @LogTypeCSSClass
WHERE	LogTypeKey = @LogTypeKey
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteEventLogType]    Script Date: 10/05/2007 21:21:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteEventLogType]
	@LogTypeKey nvarchar(35)
AS
DELETE FROM {databaseOwner}{objectQualifier}EventLogTypes
WHERE	LogTypeKey = @LogTypeKey
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateEventLogConfig]    Script Date: 10/05/2007 21:22:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateEventLogConfig]
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
UPDATE {databaseOwner}{objectQualifier}EventLogConfig
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddEventLogConfig]    Script Date: 10/05/2007 21:21:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddEventLogConfig]
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
INSERT INTO {databaseOwner}{objectQualifier}EventLogConfig
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetEventLogConfig]    Script Date: 10/05/2007 21:21:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetEventLogConfig]
	@ID int
AS
SELECT *
FROM {databaseOwner}{objectQualifier}EventLogConfig
WHERE (ID = @ID or @ID IS NULL)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteEventLogConfig]    Script Date: 10/05/2007 21:21:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteEventLogConfig]
	@ID int
AS
DELETE FROM {databaseOwner}{objectQualifier}EventLogConfig
WHERE ID = @ID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddUrlTracking]    Script Date: 10/05/2007 21:21:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddUrlTracking]

@PortalID     int,
@Url          nvarchar(255),
@UrlType      char(1),
@LogActivity  bit,
@TrackClicks  bit,
@ModuleId     int,
@NewWindow    bit

as

insert into {objectQualifier}UrlTracking (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUrlTracking]    Script Date: 10/05/2007 21:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetUrlTracking]

@PortalID     int,
@Url          nvarchar(255),
@ModuleId     int

as

select *
from   {objectQualifier}UrlTracking
where  PortalID = @PortalID
and    Url = @Url
and    ((ModuleId = @ModuleId) or (ModuleId is null and @ModuleId is null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateUrlTracking]    Script Date: 10/05/2007 21:23:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateUrlTracking]

@PortalID     int,
@Url          nvarchar(255),
@LogActivity  bit,
@TrackClicks  bit,
@ModuleId     int,
@NewWindow    bit

as

update {objectQualifier}UrlTracking
set    LogActivity = @LogActivity,
       TrackClicks = @TrackClicks,
       NewWindow = @NewWindow
where  PortalID = @PortalID
and    Url = @Url
and    ((ModuleId = @ModuleId) or (ModuleId is null and @ModuleId is null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateUrlTrackingStats]    Script Date: 10/05/2007 21:23:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateUrlTrackingStats]

@PortalID     int,
@Url          nvarchar(255),
@ModuleId     int

as

update {objectQualifier}UrlTracking
set    Clicks = Clicks + 1,
       LastClick = getdate()
where  PortalID = @PortalID
and    Url = @Url
and    ((ModuleId = @ModuleId) or (ModuleId is null and @ModuleId is null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteUrlTracking]    Script Date: 10/05/2007 21:21:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteUrlTracking]

@PortalID     int,
@Url          nvarchar(255),
@ModuleID     int

as

delete
from   {objectQualifier}UrlTracking
where  PortalID = @PortalID
and    Url = @Url
and    ((ModuleId = @ModuleId) or (ModuleId is null and @ModuleId is null))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateAffiliate]    Script Date: 10/05/2007 21:22:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateAffiliate]

@AffiliateId int,
@StartDate         datetime,
@EndDate           datetime,
@CPC               float,
@CPA               float

as

update {objectQualifier}Affiliates
set    StartDate   = @StartDate,
       EndDate     = @EndDate,
       CPC         = @CPC,
       CPA         = @CPA
where  AffiliateId = @AffiliateId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddAffiliate]    Script Date: 10/05/2007 21:21:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddAffiliate]

@VendorId      int,
@StartDate     datetime,
@EndDate       datetime,
@CPC           float,
@CPA           float

as

insert into {objectQualifier}Affiliates (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateAffiliateStats]    Script Date: 10/05/2007 21:22:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateAffiliateStats]

@AffiliateId  int,
@Clicks       int,
@Acquisitions int

as

update {objectQualifier}Affiliates
set    Clicks = Clicks + @Clicks,
       Acquisitions = Acquisitions + @Acquisitions
where  VendorId = @AffiliateId 
and    ( StartDate < getdate() or StartDate is null ) 
and    ( EndDate > getdate() or EndDate is null )
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetAffiliates]    Script Date: 10/05/2007 21:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetAffiliates]

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
from   {objectQualifier}Affiliates
where  VendorId = @VendorId
order  by StartDate desc
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteAffiliate]    Script Date: 10/05/2007 21:21:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteAffiliate]

@AffiliateId int

as

delete
from   {objectQualifier}Affiliates
where  AffiliateId = @AffiliateId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUrls]    Script Date: 10/05/2007 21:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetUrls]

@PortalID     int

as

select *
from   {objectQualifier}Urls
where  PortalID = @PortalID
order by Url
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUrl]    Script Date: 10/05/2007 21:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetUrl]

@PortalID     int,
@Url          nvarchar(255)

as

select *
from   {objectQualifier}Urls
where  PortalID = @PortalID
and    Url = @Url
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddUrl]    Script Date: 10/05/2007 21:21:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddUrl]

@PortalID     int,
@Url          nvarchar(255)

as

insert into {objectQualifier}Urls (
  PortalID,
  Url
)
values (
  @PortalID,
  @Url
)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteUrl]    Script Date: 10/05/2007 21:21:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteUrl]

@PortalID     int,
@Url          nvarchar(255)

as

delete
from   {objectQualifier}Urls
where  PortalID = @PortalID
and    Url = @Url
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateBanner]    Script Date: 10/05/2007 21:22:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateBanner]

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

update {objectQualifier}Banners
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddBanner]    Script Date: 10/05/2007 21:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddBanner]

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

insert into {objectQualifier}Banners (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteBanner]    Script Date: 10/05/2007 21:21:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteBanner]

@BannerId int

as

delete
from {objectQualifier}Banners
where  BannerId = @BannerId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetBanners]    Script Date: 10/05/2007 21:21:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetBanners]

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
from   {objectQualifier}Banners
where  VendorId = @VendorId
order  by CreatedDate desc
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateBannerClickThrough]    Script Date: 10/05/2007 21:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateBannerClickThrough]

@BannerId int,
@VendorId int

as

update {objectQualifier}Banners
set    ClickThroughs = ClickThroughs + 1
where  BannerId = @BannerId
and    VendorId = @VendorId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateBannerViews]    Script Date: 10/05/2007 21:22:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateBannerViews]

@BannerId  int, 
@StartDate datetime, 
@EndDate   datetime

as

update {objectQualifier}Banners
set    Views = Views + 1,
       StartDate = @StartDate,
       EndDate = @EndDate
where  BannerId = @BannerId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddProfile]    Script Date: 10/05/2007 21:21:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddProfile]

@UserId        int, 
@PortalId      int

as

insert into {objectQualifier}Profile (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetProfile]    Script Date: 10/05/2007 21:22:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetProfile]

@UserId    int, 
@PortalId  int

as

select *
from   {objectQualifier}Profile
where  UserId = @UserId 
and    PortalId = @PortalId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateProfile]    Script Date: 10/05/2007 21:22:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateProfile]

@UserId        int, 
@PortalId      int,
@ProfileData   ntext

as

update {objectQualifier}Profile
set    ProfileData = @ProfileData,
       CreatedDate = getdate()
where  UserId = @UserId
and    PortalId = @PortalId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetAllProfiles]    Script Date: 10/05/2007 21:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetAllProfiles]
AS
SELECT * FROM {objectQualifier}Profile
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteSearchCommonWord]    Script Date: 10/05/2007 21:21:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteSearchCommonWord]
	@CommonWordID int
AS

DELETE FROM {databaseOwner}{objectQualifier}SearchCommonWords
WHERE
	[CommonWordID] = @CommonWordID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchCommonWordByID]    Script Date: 10/05/2007 21:22:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSearchCommonWordByID]
	@CommonWordID int
	
AS

SELECT
	[CommonWordID],
	[CommonWord],
	[Locale]
FROM
	{databaseOwner}{objectQualifier}SearchCommonWords
WHERE
	[CommonWordID] = @CommonWordID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddSearchCommonWord]    Script Date: 10/05/2007 21:21:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddSearchCommonWord]
	@CommonWord nvarchar(255),
	@Locale nvarchar(10)
AS

INSERT INTO {databaseOwner}{objectQualifier}SearchCommonWords (
	[CommonWord],
	[Locale]
) VALUES (
	@CommonWord,
	@Locale
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchCommonWordsByLocale]    Script Date: 10/05/2007 21:22:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSearchCommonWordsByLocale]
	@Locale nvarchar(10)
	
AS

SELECT
	[CommonWordID],
	[CommonWord],
	[Locale]
FROM
	{databaseOwner}{objectQualifier}SearchCommonWords
WHERE
	[Locale] = @Locale
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateSearchCommonWord]    Script Date: 10/05/2007 21:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateSearchCommonWord]
	@CommonWordID int, 
	@CommonWord nvarchar(255), 
	@Locale nvarchar(10) 
AS

UPDATE {databaseOwner}{objectQualifier}SearchCommonWords SET
	[CommonWord] = @CommonWord,
	[Locale] = @Locale
WHERE
	[CommonWordID] = @CommonWordID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortalAliasByPortalID]    Script Date: 10/05/2007 21:22:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetPortalAliasByPortalID]

@PortalID int

as

select *
from {databaseOwner}{objectQualifier}PortalAlias
where (PortalID = @PortalID or @PortalID = -1)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortalByAlias]    Script Date: 10/05/2007 21:22:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetPortalByAlias]

@HTTPAlias nvarchar(200)

as

select 'PortalId' = min(PortalId)
from {databaseOwner}{objectQualifier}PortalAlias
where  HTTPAlias = @HTTPAlias
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeletePortalAlias]    Script Date: 10/05/2007 21:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}DeletePortalAlias]
@PortalAliasID int

as

DELETE FROM {databaseOwner}{objectQualifier}PortalAlias 
WHERE PortalAliasID = @PortalAliasID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortalAliasByPortalAliasID]    Script Date: 10/05/2007 21:22:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetPortalAliasByPortalAliasID]

@PortalAliasID int

as

select *
from {databaseOwner}{objectQualifier}PortalAlias
where PortalAliasID = @PortalAliasID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdatePortalAlias]    Script Date: 10/05/2007 21:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}UpdatePortalAlias]
@PortalAliasID int,
@PortalID int,
@HTTPAlias nvarchar(200)

as

UPDATE {databaseOwner}{objectQualifier}PortalAlias 
SET HTTPAlias = @HTTPAlias
WHERE PortalID = @PortalID
AND	  PortalAliasID = @PortalAliasID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortalAlias]    Script Date: 10/05/2007 21:22:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetPortalAlias]

@HTTPAlias nvarchar(200),
@PortalID int

as

select *
from {databaseOwner}{objectQualifier}PortalAlias
where HTTPAlias = @HTTPAlias 
and PortalID = @PortalID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddPortalAlias]    Script Date: 10/05/2007 21:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}AddPortalAlias]

@PortalID int,
@HTTPAlias nvarchar(200)

as

INSERT INTO {databaseOwner}{objectQualifier}PortalAlias 
(PortalID, HTTPAlias)
VALUES
(@PortalID, @HTTPAlias)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdatePortalAliasOnInstall]    Script Date: 10/05/2007 21:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}UpdatePortalAliasOnInstall]

@PortalAlias nvarchar(200)

as

update {databaseOwner}{objectQualifier}PortalAlias 
set    HTTPAlias = @PortalAlias
where  HTTPAlias = '_default'
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetList]    Script Date: 10/05/2007 21:21:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetList]
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
	(SELECT MAX([SortOrder]) FROM {objectQualifier}Lists WHERE [ListName] = E.[ListName]) As [MaxSortOrder],
	(SELECT COUNT(EntryID) FROM {objectQualifier}Lists WHERE [ListName] = E.[ListName] AND ParentID = E.[ParentID]) As EntryCount,
	IsNull((SELECT [ListName] + '.' + [Value] + ':' FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]), '') + E.[ListName] As [Key],	
	IsNull((SELECT [ListName] + '.' + [Text] + ':' FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]), '') + E.[ListName] As [DisplayName],
	IsNull((SELECT [ListName] + '.' + [Value] FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]), '') As [ParentKey],
	IsNull((SELECT [ListName] + '.' + [Text] FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]), '') As [Parent],
	IsNull((SELECT [ListName] FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]),'') As [ParentList]
	From {objectQualifier}Lists E (nolock)
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
	(SELECT MAX([SortOrder]) FROM {objectQualifier}Lists WHERE [ListName] = E.[ListName]) As [MaxSortOrder],
	(SELECT COUNT(EntryID) FROM {objectQualifier}Lists WHERE [ListName] = E.[ListName] AND ParentID = E.[ParentID]) As EntryCount,
	IsNull((SELECT [ListName] + '.' + [Value] + ':' FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]), '') + E.[ListName] As [Key],	
	IsNull((SELECT [ListName] + '.' + [Text] + ':' FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]), '') + E.[ListName] As [DisplayName],
	IsNull((SELECT [ListName] + '.' + [Value] FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]), '') As [ParentKey],
	IsNull((SELECT [ListName] + '.' + [Text] FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]), '') As [Parent],
	IsNull((SELECT [ListName] FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]),'') As [ParentList]
	
	From {objectQualifier}Lists E (nolock)
	where  [ListName] = @ListName And
	[ParentID] = (SELECT [EntryID] From {objectQualifier}Lists Where [ListName] = @ParentListName And [Value] = @ParentValue)	
	Order By E.[Level], [DisplayName]

End
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteList]    Script Date: 10/05/2007 21:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}DeleteList]

@ListName nvarchar(50),
@ParentKey nvarchar(150)

as

DECLARE @EntryID int

If @ParentKey = '' 
Begin
	-- need to store entries which to be deleted to clean up their sub entries
	DECLARE allentry_cursor CURSOR FOR
	SELECT [EntryID] FROM {objectQualifier}Lists Where  [ListName] = @ListName	
	-- then delete their sub entires
	OPEN allentry_cursor
	FETCH NEXT FROM allentry_cursor INTO @EntryID
	While @@FETCH_STATUS = 0
	Begin	
		Delete {objectQualifier}Lists Where [ParentID] = @EntryID
   		FETCH NEXT FROM allentry_cursor INTO @EntryID
	End
	-- Delete entries belong to this list
	Delete {objectQualifier}Lists
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
	SELECT [EntryID] FROM {objectQualifier}Lists Where  [ListName] = @ListName And
	[ParentID] = (SELECT [EntryID] From {objectQualifier}Lists Where [ListName] = @ParentListName And [Value] = @ParentValue)
	-- delete their sub entires
	OPEN selentry_cursor
	FETCH NEXT FROM selentry_cursor INTO @EntryID
	While @@FETCH_STATUS = 0
	Begin	
		Delete {objectQualifier}Lists Where [ParentID] = @EntryID
   		FETCH NEXT FROM selentry_cursor INTO @EntryID
	End
	-- delete entry list
	Delete {objectQualifier}Lists 
	where  [ListName] = @ListName And
	[ParentID] = (SELECT [EntryID] From {objectQualifier}Lists Where [ListName] = @ParentListName And [Value] = @ParentValue)	
End
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateListSortOrder]    Script Date: 10/05/2007 21:22:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateListSortOrder]
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
SELECT @CurrentSortValue = [SortOrder], @EntryListName = [ListName], @ParentID = [ParentID] FROM {objectQualifier}Lists (nolock) WHERE [EntryID] = @EntryID
-- Move the item up or down?
IF (@MoveUp = 1)
  BEGIN
    IF (@CurrentSortValue != 1) -- we rearrange sort order only if list enable sort order - sortorder >= 1
      BEGIN
        SET @ReplaceSortValue = @CurrentSortValue - 1
        UPDATE {objectQualifier}Lists SET [SortOrder] = @CurrentSortValue WHERE [SortOrder] = @ReplaceSortValue And [ListName] = @EntryListName And [ParentID] = @ParentID
        UPDATE {objectQualifier}Lists SET [SortOrder] = @ReplaceSortValue WHERE [EntryID] = @EntryID
      END
  END
ELSE
  BEGIN
    IF (@CurrentSortValue < (SELECT MAX([SortOrder]) FROM {objectQualifier}Lists))
    BEGIN
      SET @ReplaceSortValue = @CurrentSortValue + 1
      UPDATE {objectQualifier}Lists SET [SortOrder] = @CurrentSortValue WHERE SortOrder = @ReplaceSortValue And [ListName] = @EntryListName  And [ParentID] = @ParentID
      UPDATE {objectQualifier}Lists SET [SortOrder] = @ReplaceSortValue WHERE EntryID = @EntryID
    END
  END
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateListEntry]    Script Date: 10/05/2007 21:22:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateListEntry]

@EntryID int, 
@ListName nvarchar(50), 
@Value nvarchar(100), 
@Text nvarchar(150), 
@Description nvarchar(500)

AS

UPDATE {objectQualifier}Lists
SET	
	[ListName] = @ListName,
	[Value] = @Value,
	[Text] = @Text,	
	[Description] = @Description
WHERE 	[EntryID] = @EntryID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteListEntryByID]    Script Date: 10/05/2007 21:21:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}DeleteListEntryByID]

@EntryId   int,
@DeleteChild bit

as

Delete
From {objectQualifier}Lists
Where  [EntryID] = @EntryID

If @DeleteChild = 1
Begin
	Delete 
	From {objectQualifier}Lists
	Where [ParentID] = @EntryID
End
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetListEntries]    Script Date: 10/05/2007 21:21:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetListEntries]

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
	IsNull((SELECT [ListName] + '.' + [Value] FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]), '') As [ParentKey],
	IsNull((SELECT [ListName] + '.' + [Text] FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]), '') As [Parent],
	IsNull((SELECT [ListName] FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]),'') As [ParentList],		
	(SELECT COUNT(DISTINCT [ParentID]) FROM {objectQualifier}Lists (nolock) WHERE [ParentID] = E.[EntryID]) As HasChildren
	From {objectQualifier}Lists E (nolock)
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
	IsNull((SELECT [ListName] + '.' + [Value] FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]), '') As [ParentKey],
	IsNull((SELECT [ListName] + '.' + [Text] FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]), '') As [Parent],
	IsNull((SELECT [ListName] FROM {objectQualifier}Lists WHERE [EntryID] = E.[ParentID]),'') As [ParentList],	
	(SELECT COUNT(DISTINCT [ParentID]) FROM {objectQualifier}Lists (nolock) WHERE [ParentID] = E.[EntryID]) As HasChildren
	From {objectQualifier}Lists E (nolock)
	where  [ListName] = @ListName 
	and (E.[DefinitionID]=@DefinitionID or @DefinitionID = -1)
	and (E.[EntryID]=@EntryID or @EntryID = -1)
	and (E.[Value]=@Value or @Value = '')
	and [ParentID] = (SELECT [EntryID] From {objectQualifier}Lists Where [ListName] = @ParentListName And [Value] = @ParentValue)
	Order By E.[Level], E.[ListName], E.[SortOrder], E.[Text]

End
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddListEntry]    Script Date: 10/05/2007 21:21:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}AddListEntry]

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
	SET @SortOrder = IsNull((SELECT MAX ([SortOrder]) From {objectQualifier}Lists Where [ListName] = @ListName), 0) + 1
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
	SELECT @ParentID = [EntryID], @Level = ([Level] + 1) From {objectQualifier}Lists Where [ListName] = @ParentListName And [Value] = @ParentValue

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
If EXISTS (SELECT [EntryID] From {objectQualifier}Lists WHERE [ListName] = @ListName And [Value] = @Value And [Text] = @Text And [ParentID] = @ParentID)
BEGIN
select -1
Return 
END

insert into {objectQualifier}Lists 
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateFolder]    Script Date: 10/05/2007 21:22:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateFolder]

	@PortalID int,
	@FolderID int,
	@FolderPath varchar(300),
	@StorageLocation int,
	@IsProtected bit,
        @IsCached bit,
        @LastUpdated datetime

AS

UPDATE {objectQualifier}Folders
SET    FolderPath = @FolderPath,
       StorageLocation = @StorageLocation,
       IsProtected = @IsProtected,
       IsCached = @IsCached,
       LastUpdated = @LastUpdated
WHERE  ((PortalID = @PortalID) OR (PortalID IS Null AND @PortalID IS Null))
AND    FolderID = @FolderID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteFolder]    Script Date: 10/05/2007 21:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteFolder]
	@PortalID int,
	@FolderPath varchar(300)
AS
	DELETE FROM {objectQualifier}Folders
	WHERE ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
	AND FolderPath = @FolderPath
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetFolderByFolderPath]    Script Date: 10/05/2007 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetFolderByFolderPath]
	@PortalID int,
	@FolderPath nvarchar(300)
AS
SELECT *
	FROM {databaseOwner}{objectQualifier}Folders
	WHERE ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
		AND (FolderPath = @FolderPath)
	ORDER BY FolderPath
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetFolders]    Script Date: 10/05/2007 21:21:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetFolders]
	@PortalID int,
	@FolderID int,
	@FolderPath nvarchar(300)
AS
SELECT *
	FROM {objectQualifier}Folders
	WHERE ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
		AND (FolderID = @FolderID or @FolderID = -1)
		AND (FolderPath = @FolderPath or @FolderPath = '')
	ORDER BY FolderPath
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddFolder]    Script Date: 10/05/2007 21:21:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddFolder]

	@PortalID int,
	@FolderPath varchar(300),
	@StorageLocation int,
	@IsProtected bit,
	@IsCached bit,
	@LastUpdated datetime

AS

INSERT INTO {objectQualifier}Folders (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetFolderByFolderID]    Script Date: 10/05/2007 21:21:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetFolderByFolderID]
	@PortalID int,
	@FolderID int
AS
SELECT *
	FROM {databaseOwner}{objectQualifier}Folders
	WHERE ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
		AND (FolderID = @FolderID)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteTabModuleSettings]    Script Date: 10/05/2007 21:21:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteTabModuleSettings]
@TabModuleId      int
as

DELETE FROM {objectQualifier}TabModuleSettings 
WHERE TabModuleId = @TabModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddTabModuleSetting]    Script Date: 10/05/2007 21:21:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddTabModuleSetting]

@TabModuleId   int,
@SettingName   nvarchar(50),
@SettingValue  nvarchar(2000)

as

insert into {objectQualifier}TabModuleSettings ( 
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteTabModuleSetting]    Script Date: 10/05/2007 21:21:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteTabModuleSetting]
@TabModuleId      int,
@SettingName   nvarchar(50)
as

DELETE FROM {objectQualifier}TabModuleSettings 
WHERE TabModuleId = @TabModuleId
AND SettingName = @SettingName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateTabModuleSetting]    Script Date: 10/05/2007 21:23:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateTabModuleSetting]

@TabModuleId   int,
@SettingName   nvarchar(50),
@SettingValue  nvarchar(2000)

as

update {objectQualifier}TabModuleSettings
set    SettingValue = @SettingValue
where  TabModuleId = @TabModuleId
and    SettingName = @SettingName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTabModuleSettings]    Script Date: 10/05/2007 21:22:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetTabModuleSettings]

@TabModuleId int

as

select SettingName,
       SettingValue
from   {objectQualifier}TabModuleSettings 
where  TabModuleId = @TabModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTabModuleSetting]    Script Date: 10/05/2007 21:22:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetTabModuleSetting]

@TabModuleId int,
@SettingName nvarchar(50)

as

select SettingName,
       SettingValue
from   {objectQualifier}TabModuleSettings 
where  TabModuleId = @TabModuleId
and    SettingName = @SettingName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateScheduleHistory]    Script Date: 10/05/2007 21:22:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateScheduleHistory]
@ScheduleHistoryID int,
@EndDate datetime,
@Succeeded bit,
@LogNotes ntext,
@NextStart datetime
AS
UPDATE {databaseOwner}{objectQualifier}ScheduleHistory
SET	EndDate = @EndDate,
	Succeeded = @Succeeded,
	LogNotes = @LogNotes,
	NextStart = @NextStart
WHERE ScheduleHistoryID = @ScheduleHistoryID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddScheduleHistory]    Script Date: 10/05/2007 21:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddScheduleHistory]
@ScheduleID int,
@StartDate datetime,
@Server varchar(150)
AS
INSERT INTO {databaseOwner}{objectQualifier}ScheduleHistory
(ScheduleID,
StartDate,
Server)
VALUES
(@ScheduleID,
@StartDate,
@Server)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUserProfile]    Script Date: 10/05/2007 21:22:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetUserProfile]

	@UserId int

AS
SELECT
	ProfileID,
	UserID,
	PropertyDefinitionID,
	'PropertyValue' = case when (PropertyValue Is Null) then PropertyText else PropertyValue end,
	Visibility,
	LastUpdatedDate
	FROM	{objectQualifier}UserProfile
	WHERE   UserId = @UserId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateUserProfileProperty]    Script Date: 10/05/2007 21:23:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateUserProfileProperty]

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
		FROM   {objectQualifier}UserProfile
		WHERE  UserID = @UserID AND PropertyDefinitionID = @PropertyDefinitionID
 
IF @ProfileID IS NOT NULL
	-- Update Property
	BEGIN
		UPDATE {objectQualifier}UserProfile
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
		INSERT INTO {objectQualifier}UserProfile (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteVendorClassifications]    Script Date: 10/05/2007 21:21:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteVendorClassifications]

@VendorId  int

as

delete
from {objectQualifier}VendorClassification
where  VendorId = @VendorId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddVendorClassification]    Script Date: 10/05/2007 21:21:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddVendorClassification]

@VendorId           int,
@ClassificationId   int

as

insert into {objectQualifier}VendorClassification ( 
  VendorId,
  ClassificationId
)
values (
  @VendorId,
  @ClassificationId
)

select SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}ListSearchItemWordPosition]    Script Date: 10/05/2007 21:22:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}ListSearchItemWordPosition]
AS

SELECT
	[SearchItemWordPositionID],
	[SearchItemWordID],
	[ContentPosition]
FROM
	{databaseOwner}{objectQualifier}SearchItemWordPosition
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchItemWordPosition]    Script Date: 10/05/2007 21:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItemWordPosition]
	@SearchItemWordPositionID int
	
AS

SELECT
	[SearchItemWordPositionID],
	[SearchItemWordID],
	[ContentPosition]
FROM
	{databaseOwner}{objectQualifier}SearchItemWordPosition
WHERE
	[SearchItemWordPositionID] = @SearchItemWordPositionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateSearchItemWordPosition]    Script Date: 10/05/2007 21:22:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateSearchItemWordPosition]
	@SearchItemWordPositionID int, 
	@SearchItemWordID int, 
	@ContentPosition int 
AS

UPDATE {databaseOwner}{objectQualifier}SearchItemWordPosition SET
	[SearchItemWordID] = @SearchItemWordID,
	[ContentPosition] = @ContentPosition
WHERE
	[SearchItemWordPositionID] = @SearchItemWordPositionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteSearchItemWordPosition]    Script Date: 10/05/2007 21:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteSearchItemWordPosition]
	@SearchItemWordPositionID int
AS

DELETE FROM {databaseOwner}{objectQualifier}SearchItemWordPosition
WHERE
	[SearchItemWordPositionID] = @SearchItemWordPositionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchItemWordPositionBySearchItemWord]    Script Date: 10/05/2007 21:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItemWordPositionBySearchItemWord]
	@SearchItemWordID int
AS

SELECT
	[SearchItemWordPositionID],
	[SearchItemWordID],
	[ContentPosition]
FROM
	{databaseOwner}{objectQualifier}SearchItemWordPosition
WHERE
	[SearchItemWordID]=@SearchItemWordID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddSearchItemWordPosition]    Script Date: 10/05/2007 21:21:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE {databaseOwner}[{objectQualifier}AddSearchItemWordPosition]
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

	INSERT INTO {databaseOwner}{objectQualifier}SearchItemWordPosition (
		[SearchItemWordID],
		[ContentPosition]) 
	SELECT ItemWordID, Position FROM @TempList
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteSystemMessage]    Script Date: 10/05/2007 21:21:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteSystemMessage]

@PortalID     int,
@MessageName  nvarchar(50)

as

delete
from   {objectQualifier}SystemMessages
where  PortalID = @PortalID
and    MessageName = @MessageName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddSystemMessage]    Script Date: 10/05/2007 21:21:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddSystemMessage]

@PortalID     int,
@MessageName  nvarchar(50),
@MessageValue ntext

as

insert into {objectQualifier}SystemMessages (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateSystemMessage]    Script Date: 10/05/2007 21:22:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdateSystemMessage]

@PortalID     int,
@MessageName  nvarchar(50),
@MessageValue ntext

as

update {objectQualifier}SystemMessages
set    MessageValue = @MessageValue
where  ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
and    MessageName = @MessageName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSystemMessage]    Script Date: 10/05/2007 21:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSystemMessage]

@PortalID     int,
@MessageName  nvarchar(50)

as

select MessageValue
from   {objectQualifier}SystemMessages
where  ((PortalID = @PortalID) or (PortalID is null and @PortalID is null)) 
and    MessageName = @MessageName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSystemMessages]    Script Date: 10/05/2007 21:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSystemMessages]

as

select MessageName
from   {objectQualifier}SystemMessages
where  PortalID is null
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteSearchWord]    Script Date: 10/05/2007 21:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteSearchWord]
	@SearchWordsID int
AS

DELETE FROM {databaseOwner}{objectQualifier}SearchWord
WHERE
	[SearchWordsID] = @SearchWordsID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchWords]    Script Date: 10/05/2007 21:22:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSearchWords]
AS

SELECT
	[SearchWordsID],
	[Word],
	[HitCount]
FROM
	{databaseOwner}{objectQualifier}SearchWord
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateSearchWord]    Script Date: 10/05/2007 21:22:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdateSearchWord]
	@SearchWordsID int, 
	@Word nvarchar(100), 
	@IsCommon bit, 
	@HitCount int 
AS

UPDATE {databaseOwner}{objectQualifier}SearchWord SET
	[Word] = @Word,
	[IsCommon] = @IsCommon,
	[HitCount] = @HitCount
WHERE
	[SearchWordsID] = @SearchWordsID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddSearchWord]    Script Date: 10/05/2007 21:21:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddSearchWord]
	@Word nvarchar(100)
 
AS

DECLARE @id int
SELECT @id = SearchWordsID 
	FROM {objectQualifier}SearchWord
	WHERE Word = @Word
 

IF @id IS NULL
	BEGIN
		INSERT INTO {objectQualifier}SearchWord (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSearchWordByID]    Script Date: 10/05/2007 21:22:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSearchWordByID]
	@SearchWordsID int
	
AS

SELECT
	[SearchWordsID],
	[Word],
	[IsCommon],
	[HitCount]
FROM
	{databaseOwner}{objectQualifier}SearchWord
WHERE
	[SearchWordsID] = @SearchWordsID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetHostSettings]    Script Date: 10/05/2007 21:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetHostSettings]
as
select SettingName,
       SettingValue,
       SettingIsSecure
from {objectQualifier}HostSettings
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetHostSetting]    Script Date: 10/05/2007 21:21:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetHostSetting]

@SettingName nvarchar(50)

as

select SettingValue
from {objectQualifier}HostSettings
where  SettingName = @SettingName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddHostSetting]    Script Date: 10/05/2007 21:21:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}AddHostSetting]

@SettingName   nvarchar(50),
@SettingValue  nvarchar(256),
@SettingIsSecure bit

as

insert into {objectQualifier}HostSettings (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateHostSetting]    Script Date: 10/05/2007 21:22:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}UpdateHostSetting]

@SettingName   nvarchar(50),
@SettingValue  nvarchar(256),
@SettingIsSecure bit

as

update {objectQualifier}HostSettings
set    SettingValue = @SettingValue, SettingIsSecure = @SettingIsSecure
where  SettingName = @SettingName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddPortalInfo]    Script Date: 10/05/2007 21:21:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddPortalInfo]
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

insert into {objectQualifier}Portals (
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
	UPDATE {objectQualifier}Portals SET HomeDirectory = 'Portals/' + convert(varchar(10), @PortalID) WHERE PortalID = @PortalID
END

SELECT @PortalID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdatePortalSetup]    Script Date: 10/05/2007 21:22:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}UpdatePortalSetup]

@PortalId            int,
@AdministratorId     int,
@AdministratorRoleId int,
@PowerUserRoleId     int,
@RegisteredRoleId    int,
@SplashTabId         int,
@HomeTabId           int,
@LoginTabId          int,
@UserTabId           int,
@AdminTabId          int

as

update {objectQualifier}Portals
set    AdministratorId = @AdministratorId, 
       AdministratorRoleId = @AdministratorRoleId,
       PowerUserRoleId = @PowerUserRoleId, 
       RegisteredRoleId = @RegisteredRoleId,
       SplashTabId = @SplashTabId,
       HomeTabId = @HomeTabId,
       LoginTabId = @LoginTabId,
       UserTabId = @UserTabId,
       AdminTabId = @AdminTabId
where  PortalId = @PortalId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortalCount]    Script Date: 10/05/2007 21:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPortalCount]

AS
SELECT COUNT(*)
FROM {objectQualifier}Portals
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdatePortalInfo]    Script Date: 10/05/2007 21:22:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdatePortalInfo]

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
update {databaseOwner}{objectQualifier}Portals
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPermissionsByFolderPath]    Script Date: 10/05/2007 21:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPermissionsByFolderPath]
	@PortalID int,
	@FolderPath varchar(300)
AS

SELECT
	P.[PermissionID],
	P.[PermissionCode],
	P.[PermissionKey],
	P.[PermissionName]
FROM
	{databaseOwner}{objectQualifier}Permission P
WHERE
	P.PermissionCode = 'SYSTEM_FOLDER'
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPermission]    Script Date: 10/05/2007 21:22:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPermission]
	@PermissionID int
AS

SELECT
	[PermissionID],
	[PermissionCode],
	[ModuleDefID],
	[PermissionKey],
	[PermissionName]
FROM
	{databaseOwner}{objectQualifier}Permission
WHERE
	[PermissionID] = @PermissionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPermissionsByModuleDefID]    Script Date: 10/05/2007 21:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPermissionsByModuleDefID]
	@ModuleDefID int
AS
SELECT
	P.[PermissionID],
	P.[PermissionCode],
	P.[ModuleDefID],
	P.[PermissionKey],
	P.[PermissionName]
FROM
	{objectQualifier}Permission P
WHERE
	P.ModuleDefID = @ModuleDefID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPermissionByCodeAndKey]    Script Date: 10/05/2007 21:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPermissionByCodeAndKey]
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
	{databaseOwner}{objectQualifier}Permission P
WHERE
	(P.PermissionCode = @PermissionCode or @PermissionCode IS NULL)
	AND
	(P.PermissionKey = @PermissionKey or @PermissionKey IS NULL)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeletePermission]    Script Date: 10/05/2007 21:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeletePermission]
	@PermissionID int
AS

DELETE FROM {databaseOwner}{objectQualifier}Permission
WHERE
	[PermissionID] = @PermissionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPermissionsByTabID]    Script Date: 10/05/2007 21:22:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPermissionsByTabID]
	@TabID int
AS

SELECT
	P.[PermissionID],
	P.[PermissionCode],
	P.[PermissionKey],
	P.[ModuleDefID],
	P.[PermissionName]
FROM
	{databaseOwner}{objectQualifier}Permission P
WHERE
	P.PermissionCode = 'SYSTEM_TAB'
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddPermission]    Script Date: 10/05/2007 21:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddPermission]
	@ModuleDefID int,
	@PermissionCode varchar(50),
	@PermissionKey varchar(20),
	@PermissionName varchar(50)
AS

INSERT INTO {databaseOwner}{objectQualifier}Permission (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdatePermission]    Script Date: 10/05/2007 21:22:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}UpdatePermission]
	@PermissionID int, 
	@PermissionCode varchar(50),
	@ModuleDefID int, 
	@PermissionKey varchar(20), 
	@PermissionName varchar(50) 
AS

UPDATE {databaseOwner}{objectQualifier}Permission SET
	[ModuleDefID] = @ModuleDefID,
	[PermissionCode] = @PermissionCode,
	[PermissionKey] = @PermissionKey,
	[PermissionName] = @PermissionName
WHERE
	[PermissionID] = @PermissionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSkins]    Script Date: 10/05/2007 21:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSkins]

@PortalID		int

AS
SELECT *
FROM	{objectQualifier}Skins
WHERE   (PortalID = @PortalID) OR (PortalID is null And @PortalId Is Null)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddSkin]    Script Date: 10/05/2007 21:21:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}AddSkin]

@SkinRoot               nvarchar(50),
@PortalID		int,
@SkinType               int,
@SkinSrc                nvarchar(200)

as

insert into {objectQualifier}Skins (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSkin]    Script Date: 10/05/2007 21:22:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetSkin]

@SkinRoot               nvarchar(50),
@PortalID		int,
@SkinType               int

as
	
select *
from	{objectQualifier}Skins
where   SkinRoot = @SkinRoot
and     SkinType = @SkinType
and     ( PortalID is null or PortalID = @PortalID )
order by PortalID desc
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteSkin]    Script Date: 10/05/2007 21:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteSkin]

@SkinRoot               nvarchar(50),
@PortalID		int,
@SkinType               int

as

delete
from   {objectQualifier}Skins
where   SkinRoot = @SkinRoot
and     SkinType = @SkinType
and    ((PortalID is null and @PortalID is null) or (PortalID = @PortalID))
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}UpdateDesktopModule]    Script Date: 10/05/2007 21:22:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE {databaseOwner}[{objectQualifier}UpdateDesktopModule]

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

UPDATE 	{objectQualifier}DesktopModules
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetDesktopModuleByModuleName]    Script Date: 10/05/2007 21:21:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetDesktopModuleByModuleName]

	@ModuleName    nvarchar(128)

as

select *
from   {objectQualifier}DesktopModules
where  ModuleName = @ModuleName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetDesktopModule]    Script Date: 10/05/2007 21:21:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetDesktopModule]

@DesktopModuleId int

as

select *
from   {objectQualifier}DesktopModules
where  DesktopModuleId = @DesktopModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetDesktopModuleByFriendlyName]    Script Date: 10/05/2007 21:21:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetDesktopModuleByFriendlyName]

	@FriendlyName    nvarchar(128)

as

select *
from   {objectQualifier}DesktopModules
where  FriendlyName = @FriendlyName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteDesktopModule]    Script Date: 10/05/2007 21:21:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteDesktopModule]

@DesktopModuleId int

as

delete
from {objectQualifier}DesktopModules
where  DesktopModuleId = @DesktopModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddDesktopModule]    Script Date: 10/05/2007 21:21:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddDesktopModule]
    
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

INSERT INTO {objectQualifier}DesktopModules (
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
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetDesktopModules]    Script Date: 10/05/2007 21:21:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}GetDesktopModules]

as

select *
from   {objectQualifier}DesktopModules
where  IsAdmin = 0
order  by FriendlyName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetSuperUsers]    Script Date: 10/05/2007 21:22:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure {databaseOwner}[{objectQualifier}GetSuperUsers]

as

select U.*,
       'PortalId' = -1,
       'FullName' = U.FirstName + ' ' + U.LastName
from   {objectQualifier}Users U
where  U.IsSuperUser = 1
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}DeleteUser]    Script Date: 10/05/2007 21:21:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure {databaseOwner}[{objectQualifier}DeleteUser]

@UserId   int

as

delete
from {objectQualifier}Users
where  UserId = @UserId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}AddDefaultPropertyDefinitions]    Script Date: 10/05/2007 21:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}AddDefaultPropertyDefinitions]
	@PortalId int

AS
	DECLARE @TextDataType as int
	SELECT @TextDataType = (SELECT EntryID FROM {objectQualifier}Lists WHERE ListName = 'DataType' AND Value = 'Text')
	DECLARE @CountryDataType as int
	SELECT @CountryDataType = (SELECT EntryID FROM {objectQualifier}Lists WHERE ListName = 'DataType' AND Value = 'Country')
	DECLARE @RegionDataType as int
	SELECT @RegionDataType = (SELECT EntryID FROM {objectQualifier}Lists WHERE ListName = 'DataType' AND Value = 'Region')
	DECLARE @TimeZoneDataType as int
	SELECT @TimeZoneDataType = (SELECT EntryID FROM {objectQualifier}Lists WHERE ListName = 'DataType' AND Value = 'TimeZone')
	DECLARE @LocaleDataType as int
	SELECT @LocaleDataType = (SELECT EntryID FROM {objectQualifier}Lists WHERE ListName = 'DataType' AND Value = 'Locale')
	DECLARE @RichTextDataType as int
	SELECT @RichTextDataType = (SELECT EntryID FROM {objectQualifier}Lists WHERE ListName = 'DataType' AND Value = 'RichText')
	
	DECLARE @RC int

	--Add Name Properties
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Name','Prefix', 0, '', 1, 1, 50
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Name','FirstName' ,0, '', 3, 1, 50
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Name','MiddleName' ,0, '', 5, 1, 50
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Name','LastName' ,0, '', 7, 1, 50
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Name','Suffix' ,0, '', 9, 1, 50
	
	--Add Address Properties
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Address','Unit' ,0, '', 11, 1, 50
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Address','Street' ,0, '', 13, 1, 50
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Address','City' ,0, '', 15, 1, 50
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @RegionDataType, '', 'Address','Region' ,0, '', 17, 1, 0
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @CountryDataType, '', 'Address','Country' ,0, '', 19, 1, 0
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Address','PostalCode' ,0, '', 21, 1, 50

	--Add Contact Info Properties
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Contact Info','Telephone' ,0, '', 23, 1, 50
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Contact Info','Cell' ,0, '', 25, 1, 50
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Contact Info','Fax' ,0, '', 27, 1, 50
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Contact Info','Website' ,0, '', 29, 1, 50
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TextDataType, '', 'Contact Info','IM' ,0, '', 31, 1, 50

	--Add Preferences Properties
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @RichTextDataType, '', 'Preferences','Biography' ,0, '', 33, 1, 0
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @TimeZoneDataType, '', 'Preferences','TimeZone' ,0, '', 35, 1, 0
	EXECUTE @RC = {databaseOwner}[{objectQualifier}AddPropertyDefinition] @PortalId, -1, @LocaleDataType, '', 'Preferences','PreferredLocale' ,0, '', 37, 1, 0
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModulePermissionsByTabID]    Script Date: 10/05/2007 21:22:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModulePermissionsByTabID]
	
	@TabID int

AS
SELECT *
FROM {objectQualifier}vw_ModulePermissions MP
	INNER JOIN {objectQualifier}TabModules TM on MP.ModuleID = TM.ModuleID
WHERE  TM.TabID = @TabID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetAllTabsModules]    Script Date: 10/05/2007 21:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetAllTabsModules]

	@PortalId int,
	@AllTabs bit

AS
SELECT	* 
FROM {objectQualifier}vw_Modules M
WHERE  M.PortalId = @PortalId 
	AND M.AllTabs = @AllTabs
	AND M.Tabmoduleid =(SELECT min(tabmoduleid) 
		FROM {objectQualifier}tabmodules
		WHERE Moduleid = M.ModuleID)
ORDER BY M.ModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetOnlineUsers]    Script Date: 10/05/2007 21:22:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetOnlineUsers]
	@PortalID int

AS
SELECT 
	*
	FROM {objectQualifier}UsersOnline UO
		INNER JOIN {objectQualifier}vw_Users U ON UO.UserID = U.UserID 
		INNER JOIN {objectQualifier}UserPortals UP ON U.UserID = UP.UserId
	WHERE  UP.PortalID = @PortalID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModulePermissionsByPortal]    Script Date: 10/05/2007 21:22:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModulePermissionsByPortal]
	
	@PortalID int

AS
SELECT *
FROM {objectQualifier}vw_ModulePermissions MP
	INNER JOIN {objectQualifier}Modules AS M ON MP.ModuleID = M.ModuleID 
WHERE  M.PortalID = @PortalID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModulePermission]    Script Date: 10/05/2007 21:22:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModulePermission]
	
	@ModulePermissionID int

AS
SELECT *
FROM {objectQualifier}vw_ModulePermissions
WHERE ModulePermissionID = @ModulePermissionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModulePermissionsByModuleID]    Script Date: 10/05/2007 21:22:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModulePermissionsByModuleID]
	
	@ModuleID int, 
	@PermissionID int

AS
SELECT *
FROM {objectQualifier}vw_ModulePermissions
WHERE (@ModuleID = -1 
			OR ModuleID = @ModuleID
			OR (ModuleID IS NULL AND PermissionCode = 'SYSTEM_MODULE_DEFINITION')
		)
	AND	(PermissionID = @PermissionID OR @PermissionID = -1)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetAllTabs]    Script Date: 10/05/2007 21:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetAllTabs]

AS
SELECT *
FROM   {objectQualifier}vw_Tabs
ORDER BY TabOrder, TabName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTabsByParentId]    Script Date: 10/05/2007 21:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabsByParentId]

@ParentId int

AS
SELECT *
FROM   {objectQualifier}vw_Tabs
WHERE  ParentId = @ParentId
ORDER BY TabOrder
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTab]    Script Date: 10/05/2007 21:22:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTab]

@TabId    int

AS
SELECT *
FROM   {objectQualifier}vw_Tabs
WHERE  TabId = @TabId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTabs]    Script Date: 10/05/2007 21:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabs]

@PortalId int

AS
SELECT *
FROM   {objectQualifier}vw_Tabs
WHERE  PortalId = @PortalId OR (PortalID IS NULL AND @PortalID IS NULL)
ORDER BY TabOrder, TabName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTabByName]    Script Date: 10/05/2007 21:22:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabByName]

@TabName  nvarchar(50),
@PortalId int

as
SELECT *
FROM   {objectQualifier}vw_Tabs
where  TabName = @TabName
and    ((PortalId = @PortalId) or (@PortalId is null AND PortalId is null))
order by TabID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUserByUsername]    Script Date: 10/05/2007 21:22:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUserByUsername]

	@PortalId int,
	@Username nvarchar(100)

AS
SELECT * FROM {objectQualifier}vw_Users
WHERE  Username = @Username
	AND    (PortalId = @PortalId OR IsSuperUser = 1 OR @PortalId is null)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUnAuthorizedUsers]    Script Date: 10/05/2007 21:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUnAuthorizedUsers]
    @PortalId			int
AS

SELECT  *
FROM	{objectQualifier}vw_Users
WHERE  PortalId = @PortalId
	AND Authorised = 0
ORDER BY UserName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUserCountByPortal]    Script Date: 10/05/2007 21:22:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUserCountByPortal]

	@PortalId int

AS

	SELECT COUNT(*) FROM {objectQualifier}vw_Users 
		WHERE PortalID = @PortalID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetUser]    Script Date: 10/05/2007 21:22:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUser]

	@PortalId int,
	@UserId int

AS
SELECT * FROM {objectQualifier}vw_Users U
WHERE  UserId = @UserId
	AND    (PortalId = @PortalId or IsSuperUser = 1)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModule]    Script Date: 10/05/2007 21:21:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModule]

	@ModuleId int,
	@TabId    int
	
AS
SELECT	* 
FROM {objectQualifier}vw_Modules
WHERE   ModuleId = @ModuleId
AND     (TabId = @TabId or @TabId is null)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModules]    Script Date: 10/05/2007 21:22:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModules]

	@PortalId int
	
AS
SELECT	* 
FROM {objectQualifier}vw_Modules
WHERE  PortalId = @PortalId
ORDER BY ModuleId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTabModules]    Script Date: 10/05/2007 21:22:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabModules]

	@TabId int

AS
SELECT	* 
FROM {objectQualifier}vw_Modules
WHERE  TabId = @TabId
ORDER BY ModuleOrder
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetAllModules]    Script Date: 10/05/2007 21:21:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetAllModules]

AS
SELECT	* 
FROM {objectQualifier}vw_Modules
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetModuleByDefinition]    Script Date: 10/05/2007 21:21:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModuleByDefinition]

	@PortalId int,
	@FriendlyName nvarchar(128)
	
AS
SELECT	* 
FROM {objectQualifier}vw_Modules
WHERE  ((PortalId = @PortalId) or (PortalId is null and @PortalID is null))
	AND FriendlyName = @FriendlyName
	AND IsDeleted = 0
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortal]    Script Date: 10/05/2007 21:22:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPortal]

	@PortalId  int

AS
SELECT *
FROM {objectQualifier}vw_Portals
WHERE PortalId = @PortalId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortalByPortalAliasID]    Script Date: 10/05/2007 21:22:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPortalByPortalAliasID]

	@PortalAliasId  int

AS
SELECT P.*
FROM {objectQualifier}vw_Portals P
	INNER JOIN {objectQualifier}PortalAlias PA ON P.PortalID = PA.PortalID
WHERE PA.PortalAliasId = @PortalAliasId
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetExpiredPortals]    Script Date: 10/05/2007 21:21:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetExpiredPortals]

AS
SELECT * FROM {objectQualifier}vw_Portals
WHERE ExpiryDate < getDate()
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetPortals]    Script Date: 10/05/2007 21:22:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPortals]

AS
SELECT *
FROM {objectQualifier}vw_Portals
ORDER BY PortalName
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTabPermissionsByPortal]    Script Date: 10/05/2007 21:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabPermissionsByPortal]
	
	@PortalID int

AS
SELECT *
FROM {objectQualifier}vw_TabPermissions TP
WHERE 	PortalID = @PortalID OR (PortalId IS NULL AND @PortalId IS NULL)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetTabPermission]    Script Date: 10/05/2007 21:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabPermission]

	@TabPermissionID int

AS
SELECT *
FROM {objectQualifier}vw_TabPermissions
WHERE TabPermissionID = @TabPermissionID
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetFolderPermissionsByFolderPath]    Script Date: 10/05/2007 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetFolderPermissionsByFolderPath]
	
	@PortalID int,
	@FolderPath varchar(300), 
	@PermissionID int

AS
SELECT *
FROM {objectQualifier}vw_FolderPermissions

WHERE	((FolderPath = @FolderPath 
				AND ((PortalID = @PortalID) OR (PortalID IS NULL AND @PortalID IS NULL)))
			OR (FolderPath IS NULL AND PermissionCode = 'SYSTEM_FOLDER'))
	AND	(PermissionID = @PermissionID OR @PermissionID = -1)
GO
/****** Object:  StoredProcedure {databaseOwner}[{objectQualifier}GetFolderPermission]    Script Date: 10/05/2007 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetFolderPermission]
	
	@FolderPermissionID int

AS
SELECT *
FROM {objectQualifier}vw_FolderPermissions
WHERE FolderPermissionID = @FolderPermissionID
GO
