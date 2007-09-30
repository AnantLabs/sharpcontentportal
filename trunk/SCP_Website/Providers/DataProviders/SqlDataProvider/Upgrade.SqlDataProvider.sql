/************************************************************/
/*****              SqlDataProvider                     *****/
/*****                                                  *****/
/*****                                                  *****/
/***** Note: To manually execute this script you must   *****/
/*****       perform a search and replace operation     *****/
/*****       for {databaseOwner} and {objectQualifier}	*****/
/*****                                                  *****/
/************************************************************/

if exists (select * from dbo.sysobjects where id = object_id(N'{databaseOwner}[{objectQualifier}CheckUpgrade]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE {databaseOwner}[{objectQualifier}CheckUpgrade]
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}CheckUpgrade]

AS

	-- Declare a local table variable to hold the duplicate users we are going to transfer
	DECLARE @DuplicateUsers TABLE (
		UserName nvarchar(200) NULL,
		Duplicates int
	)

	INSERT INTO @DuplicateUsers
		SELECT username, 'Duplicates' = count(*)  
		FROM aspnet_Users
		GROUP BY username
		HAVING count(*)   > 1
		ORDER BY Duplicates DESC

	SELECT 
		U.UserID,
		U.Username,
		U.FirstName,
		U.LastName,
		U.Email,
		D.Duplicates
	FROM {objectQualifier}Users U
		INNER JOIN @DuplicateUsers D ON U.UserName = D.UserName
	WHERE U.IsSuperUser = 1

	SELECT 
		U.UserID,
		U.Username,
		U.FirstName,
		U.LastName,
		U.Email,
		D.Duplicates
	FROM {objectQualifier}Users U
		INNER JOIN @DuplicateUsers D ON U.UserName = D.UserName
	WHERE U.IsSuperUser = 0

GO

if exists (select * from dbo.sysobjects where id = object_id(N'{databaseOwner}[{objectQualifier}GetUserCount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUserCount]
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUserCount]

AS

	SELECT COUNT(*) FROM {objectQualifier}Users

GO

/************************************************************/
/*****              SqlDataProvider                     *****/
/************************************************************/