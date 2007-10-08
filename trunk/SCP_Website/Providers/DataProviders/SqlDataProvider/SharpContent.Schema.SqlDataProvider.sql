/*
Script created by SQL Compare version 5.2.0.32 from Red Gate Software Ltd at 11/29/2006 11:11:44 AM
Run this script on (local).SharpContent_Empty to make it the same as (local).SharpContent_Development
Please back up your database before running this script
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TABLE tempErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

PRINT N'Creating {databaseOwner}[{objectQualifier}RoleGroups]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}RoleGroups]
(
[RoleGroupID] [int] NOT NULL IDENTITY(0, 1),
[PortalID] [int] NOT NULL,
[RoleGroupName] [nvarchar] (50) NOT NULL,
[Description] [nvarchar] (1000) NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}RoleGroups] on {databaseOwner}[{objectQualifier}RoleGroups]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}RoleGroups] ADD CONSTRAINT [PK_{objectQualifier}RoleGroups] PRIMARY KEY NONCLUSTERED  ([RoleGroupID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Schedule]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Schedule]
(
[ScheduleID] [int] NOT NULL IDENTITY(1, 1),
[TypeFullName] [varchar] (200) NOT NULL,
[TimeLapse] [int] NOT NULL,
[TimeLapseMeasurement] [varchar] (2) NOT NULL,
[RetryTimeLapse] [int] NOT NULL,
[RetryTimeLapseMeasurement] [varchar] (2) NOT NULL,
[RetainHistoryNum] [int] NOT NULL,
[AttachToEvent] [varchar] (50) NOT NULL,
[CatchUpEnabled] [bit] NOT NULL,
[Enabled] [bit] NOT NULL,
[ObjectDependencies] [varchar] (300) NOT NULL,
[Servers] [nvarchar] (150) NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Schedule] on {databaseOwner}[{objectQualifier}Schedule]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Schedule] ADD CONSTRAINT [PK_{objectQualifier}Schedule] PRIMARY KEY CLUSTERED  ([ScheduleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}SiteLog]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SiteLog]
(
[SiteLogId] [int] NOT NULL IDENTITY(1, 1),
[DateTime] [smalldatetime] NOT NULL,
[PortalId] [int] NOT NULL,
[UserId] [int] NULL,
[Referrer] [nvarchar] (255) NULL,
[Url] [nvarchar] (255) NULL,
[UserAgent] [nvarchar] (255) NULL,
[UserHostAddress] [nvarchar] (255) NULL,
[UserHostName] [nvarchar] (255) NULL,
[TabId] [int] NULL,
[AffiliateId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}SiteLog] on {databaseOwner}[{objectQualifier}SiteLog]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SiteLog] ADD CONSTRAINT [PK_{objectQualifier}SiteLog] PRIMARY KEY CLUSTERED  ([SiteLogId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}SiteLog] on {databaseOwner}[{objectQualifier}SiteLog]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}SiteLog] ON {databaseOwner}[{objectQualifier}SiteLog] ([PortalId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSiteLog4]'
GO

create procedure {databaseOwner}{objectQualifier}GetSiteLog4

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}TabPermission]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}TabPermission]
(
[TabPermissionID] [int] NOT NULL IDENTITY(1, 1),
[TabID] [int] NOT NULL,
[PermissionID] [int] NOT NULL,
[RoleID] [int] NOT NULL,
[AllowAccess] [bit] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}TabPermission] on {databaseOwner}[{objectQualifier}TabPermission]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabPermission] ADD CONSTRAINT [PK_{objectQualifier}TabPermission] PRIMARY KEY CLUSTERED  ([TabPermissionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}ModuleControls]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ModuleControls]
(
[ModuleControlID] [int] NOT NULL IDENTITY(1, 1),
[ModuleDefID] [int] NULL,
[ControlKey] [nvarchar] (50) NULL,
[ControlTitle] [nvarchar] (50) NULL,
[ControlSrc] [nvarchar] (256) NULL,
[IconFile] [nvarchar] (100) NULL,
[ControlType] [int] NOT NULL,
[ViewOrder] [int] NULL,
[HelpUrl] [nvarchar] (200) NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}ModuleControls] on {databaseOwner}[{objectQualifier}ModuleControls]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleControls] ADD CONSTRAINT [PK_{objectQualifier}ModuleControls] PRIMARY KEY CLUSTERED  ([ModuleControlID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModuleControlByKeyAndSrc]'
GO

CREATE  PROCEDURE {databaseOwner}{objectQualifier}GetModuleControlByKeyAndSrc

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}FolderPermission]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}FolderPermission]
(
[FolderPermissionID] [int] NOT NULL IDENTITY(1, 1),
[FolderID] [int] NOT NULL,
[PermissionID] [int] NOT NULL,
[RoleID] [int] NOT NULL,
[AllowAccess] [bit] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}FolderPermission] on {databaseOwner}[{objectQualifier}FolderPermission]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}FolderPermission] ADD CONSTRAINT [PK_{objectQualifier}FolderPermission] PRIMARY KEY CLUSTERED  ([FolderPermissionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Version]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Version]
(
[VersionId] [int] NOT NULL IDENTITY(1, 1),
[Major] [int] NOT NULL,
[Minor] [int] NOT NULL,
[Build] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Version] on {databaseOwner}[{objectQualifier}Version]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Version] ADD CONSTRAINT [PK_{objectQualifier}Version] PRIMARY KEY CLUSTERED  ([VersionId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateDatabaseVersion]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateDatabaseVersion

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Classification]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Classification]
(
[ClassificationId] [int] NOT NULL IDENTITY(1, 1),
[ClassificationName] [nvarchar] (200) NOT NULL,
[ParentId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}VendorCategory] on {databaseOwner}[{objectQualifier}Classification]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Classification] ADD CONSTRAINT [PK_{objectQualifier}VendorCategory] PRIMARY KEY CLUSTERED  ([ClassificationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}Classification] on {databaseOwner}[{objectQualifier}Classification]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}Classification] ON {databaseOwner}[{objectQualifier}Classification] ([ParentId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}SearchItem]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SearchItem]
(
[SearchItemID] [int] NOT NULL IDENTITY(1, 1),
[Title] [nvarchar] (200) NOT NULL,
[Description] [nvarchar] (2000) NOT NULL,
[Author] [int] NULL,
[PubDate] [datetime] NOT NULL,
[ModuleId] [int] NOT NULL,
[SearchKey] [nvarchar] (100) NOT NULL,
[Guid] [varchar] (200) NULL,
[HitCount] [int] NULL,
[ImageFileId] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}SearchItem] on {databaseOwner}[{objectQualifier}SearchItem]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItem] ADD CONSTRAINT [PK_{objectQualifier}SearchItem] PRIMARY KEY CLUSTERED  ([SearchItemID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}SearchItem] on {databaseOwner}[{objectQualifier}SearchItem]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_{objectQualifier}SearchItem] ON {databaseOwner}[{objectQualifier}SearchItem] ([ModuleId], [SearchKey])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}SearchIndexer]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SearchIndexer]
(
[SearchIndexerID] [int] NOT NULL IDENTITY(1, 1),
[SearchIndexerAssemblyQualifiedName] [char] (200) NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}SearchIndexer] on {databaseOwner}[{objectQualifier}SearchIndexer]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchIndexer] ADD CONSTRAINT [PK_{objectQualifier}SearchIndexer] PRIMARY KEY CLUSTERED  ([SearchIndexerID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchIndexers]'
GO

create procedure {databaseOwner}{objectQualifier}GetSearchIndexers

as

select {objectQualifier}SearchIndexer.*
from {objectQualifier}SearchIndexer









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Files]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Files]
(
[FileId] [int] NOT NULL IDENTITY(1, 1),
[PortalId] [int] NULL,
[FileName] [nvarchar] (100) NOT NULL,
[Extension] [nvarchar] (100) NOT NULL,
[Size] [int] NOT NULL,
[Width] [int] NULL,
[Height] [int] NULL,
[ContentType] [nvarchar] (200) NOT NULL,
[Folder] [nvarchar] (200) NULL,
[FolderID] [int] NOT NULL,
[Content] [image] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}File] on {databaseOwner}[{objectQualifier}Files]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Files] ADD CONSTRAINT [PK_{objectQualifier}File] PRIMARY KEY CLUSTERED  ([FileId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}Files] on {databaseOwner}[{objectQualifier}Files]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}Files] ON {databaseOwner}[{objectQualifier}Files] ([PortalId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortalSpaceUsed]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetPortalSpaceUsed
	@PortalId int
AS

SELECT 'SpaceUsed' = SUM(CAST(Size as bigint))
FROM   {objectQualifier}Files
WHERE  ((PortalId = @PortalId) OR (@PortalId is null and PortalId is null))


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}ProfilePropertyDefinition]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ProfilePropertyDefinition]
(
[PropertyDefinitionID] [int] NOT NULL IDENTITY(1, 1),
[PortalID] [int] NULL,
[ModuleDefID] [int] NULL,
[Deleted] [bit] NOT NULL,
[DataType] [int] NOT NULL,
[DefaultValue] [nvarchar] (50) NULL,
[PropertyCategory] [nvarchar] (50) NOT NULL,
[PropertyName] [nvarchar] (50) NOT NULL,
[Length] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}ProfilePropertyDefinition_Length] DEFAULT ((0)),
[Required] [bit] NOT NULL,
[ValidationExpression] [nvarchar] (2000) NULL,
[ViewOrder] [int] NOT NULL,
[Visible] [bit] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}ProfilePropertyDefinition] on {databaseOwner}[{objectQualifier}ProfilePropertyDefinition]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ProfilePropertyDefinition] ADD CONSTRAINT [PK_{objectQualifier}ProfilePropertyDefinition] PRIMARY KEY CLUSTERED  ([PropertyDefinitionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}ProfilePropertyDefinition] on {databaseOwner}[{objectQualifier}ProfilePropertyDefinition]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_{objectQualifier}ProfilePropertyDefinition] ON {databaseOwner}[{objectQualifier}ProfilePropertyDefinition] ([PortalID], [ModuleDefID], [PropertyName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}ProfilePropertyDefinition_PropertyName] on {databaseOwner}[{objectQualifier}ProfilePropertyDefinition]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}ProfilePropertyDefinition_PropertyName] ON {databaseOwner}[{objectQualifier}ProfilePropertyDefinition] ([PropertyName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}EventLog]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}EventLog]
(
[LogGUID] [varchar] (36) NOT NULL,
[LogTypeKey] [nvarchar] (35) NOT NULL,
[LogConfigID] [int] NULL,
[LogUserID] [int] NULL,
[LogUserName] [nvarchar] (50) NULL,
[LogPortalID] [int] NULL,
[LogPortalName] [nvarchar] (100) NULL,
[LogCreateDate] [datetime] NOT NULL,
[LogServerName] [nvarchar] (50) NOT NULL,
[LogProperties] [ntext] NOT NULL,
[LogNotificationPending] [bit] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_EventLogMaster] on {databaseOwner}[{objectQualifier}EventLog]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}EventLog] ADD CONSTRAINT [PK_EventLogMaster] PRIMARY KEY CLUSTERED  ([LogGUID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}PortalDesktopModules]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules]
(
[PortalDesktopModuleID] [int] NOT NULL IDENTITY(1, 1),
[PortalID] [int] NOT NULL,
[DesktopModuleID] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}PortalDesktopModules] on {databaseOwner}[{objectQualifier}PortalDesktopModules]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules] ADD CONSTRAINT [PK_{objectQualifier}PortalDesktopModules] PRIMARY KEY CLUSTERED  ([PortalDesktopModuleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeletePortalDesktopModules]'
GO

create procedure {databaseOwner}{objectQualifier}DeletePortalDesktopModules

@PortalId        int,
@DesktopModuleId int

as

delete
from   {objectQualifier}PortalDesktopModules
where  ((PortalId = @PortalId) or (@PortalId is null and @DesktopModuleId is not null))
and    ((DesktopModuleId = @DesktopModuleId) or (@DesktopModuleId is null and @PortalId is not null))









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSiteLog6]'
GO

create procedure {databaseOwner}{objectQualifier}GetSiteLog6

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UserRoles]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}UserRoles]
(
[UserRoleID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[RoleID] [int] NOT NULL,
[ExpiryDate] [datetime] NULL,
[IsTrialUsed] [bit] NULL,
[EffectiveDate] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}UserRoles] on {databaseOwner}[{objectQualifier}UserRoles]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserRoles] ADD CONSTRAINT [PK_{objectQualifier}UserRoles] PRIMARY KEY CLUSTERED  ([UserRoleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}UserRoles_1] on {databaseOwner}[{objectQualifier}UserRoles]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}UserRoles_1] ON {databaseOwner}[{objectQualifier}UserRoles] ([UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}UserRoles] on {databaseOwner}[{objectQualifier}UserRoles]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}UserRoles] ON {databaseOwner}[{objectQualifier}UserRoles] ([RoleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}ModulePermission]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ModulePermission]
(
[ModulePermissionID] [int] NOT NULL IDENTITY(1, 1),
[ModuleID] [int] NOT NULL,
[PermissionID] [int] NOT NULL,
[RoleID] [int] NOT NULL,
[AllowAccess] [bit] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}ModulePermission] on {databaseOwner}[{objectQualifier}ModulePermission]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModulePermission] ADD CONSTRAINT [PK_{objectQualifier}ModulePermission] PRIMARY KEY CLUSTERED  ([ModulePermissionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}ScheduleItemSettings]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ScheduleItemSettings]
(
[ScheduleID] [int] NOT NULL,
[SettingName] [nvarchar] (50) NOT NULL,
[SettingValue] [nvarchar] (256) NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}ScheduleItemSettings] on {databaseOwner}[{objectQualifier}ScheduleItemSettings]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ScheduleItemSettings] ADD CONSTRAINT [PK_{objectQualifier}ScheduleItemSettings] PRIMARY KEY CLUSTERED  ([ScheduleID], [SettingName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetScheduleItemSettings]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetScheduleItemSettings 
@ScheduleID int
AS
SELECT *
FROM {databaseOwner}{objectQualifier}ScheduleItemSettings
WHERE ScheduleID = @ScheduleID









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetDatabaseVersion]'
GO

create procedure {databaseOwner}{objectQualifier}GetDatabaseVersion

as

select Major,
       Minor,
       Build
from   {objectQualifier}Version 
where  VersionId = ( select max(VersionId) from {objectQualifier}Version )









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}SearchItemWord]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SearchItemWord]
(
[SearchItemWordID] [int] NOT NULL IDENTITY(1, 1),
[SearchItemID] [int] NOT NULL,
[SearchWordsID] [int] NOT NULL,
[Occurrences] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}SearchItemWords] on {databaseOwner}[{objectQualifier}SearchItemWord]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWord] ADD CONSTRAINT [PK_{objectQualifier}SearchItemWords] PRIMARY KEY CLUSTERED  ([SearchItemWordID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}ModuleSettings]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ModuleSettings]
(
[ModuleID] [int] NOT NULL,
[SettingName] [nvarchar] (50) NOT NULL,
[SettingValue] [nvarchar] (2000) NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}ModuleSettings] on {databaseOwner}[{objectQualifier}ModuleSettings]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleSettings] ADD CONSTRAINT [PK_{objectQualifier}ModuleSettings] PRIMARY KEY CLUSTERED  ([ModuleID], [SettingName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}EventLogTypes]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}EventLogTypes]
(
[LogTypeKey] [nvarchar] (35) NOT NULL,
[LogTypeFriendlyName] [nvarchar] (50) NOT NULL,
[LogTypeDescription] [nvarchar] (128) NOT NULL,
[LogTypeOwner] [nvarchar] (100) NOT NULL,
[LogTypeCSSClass] [nvarchar] (40) NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_EventLogTypes] on {databaseOwner}[{objectQualifier}EventLogTypes]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}EventLogTypes] ADD CONSTRAINT [PK_EventLogTypes] PRIMARY KEY CLUSTERED  ([LogTypeKey])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}EventLogConfig]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}EventLogConfig]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[LogTypeKey] [nvarchar] (35) NULL,
[LogTypePortalID] [int] NULL,
[LoggingIsActive] [bit] NOT NULL,
[KeepMostRecent] [int] NOT NULL,
[EmailNotificationIsActive] [bit] NOT NULL,
[NotificationThreshold] [int] NULL,
[NotificationThresholdTime] [int] NULL,
[NotificationThresholdTimeType] [int] NULL,
[MailFromAddress] [nvarchar] (50) NOT NULL,
[MailToAddress] [nvarchar] (50) NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}EventLogConfig] on {databaseOwner}[{objectQualifier}EventLogConfig]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}EventLogConfig] ADD CONSTRAINT [PK_{objectQualifier}EventLogConfig] PRIMARY KEY CLUSTERED  ([ID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}LogTypeKey_{objectQualifier}LogTypePortalID] on {databaseOwner}[{objectQualifier}EventLogConfig]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_{objectQualifier}LogTypeKey_{objectQualifier}LogTypePortalID] ON {databaseOwner}[{objectQualifier}EventLogConfig] ([LogTypeKey], [LogTypePortalID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Affiliates]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Affiliates]
(
[AffiliateId] [int] NOT NULL IDENTITY(1, 1),
[VendorId] [int] NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[CPC] [float] NOT NULL,
[Clicks] [int] NOT NULL,
[CPA] [float] NOT NULL,
[Acquisitions] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Affiliates] on {databaseOwner}[{objectQualifier}Affiliates]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Affiliates] ADD CONSTRAINT [PK_{objectQualifier}Affiliates] PRIMARY KEY CLUSTERED  ([AffiliateId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateAffiliate]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateAffiliate

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Urls]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Urls]
(
[UrlID] [int] NOT NULL IDENTITY(1, 1),
[PortalID] [int] NULL,
[Url] [nvarchar] (255) NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Urls] on {databaseOwner}[{objectQualifier}Urls]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Urls] ADD CONSTRAINT [PK_{objectQualifier}Urls] PRIMARY KEY CLUSTERED  ([UrlID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddUrl]'
GO

create procedure {databaseOwner}{objectQualifier}AddUrl

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetProfilePropertyDefinitionID]'
GO

CREATE FUNCTION {databaseOwner}[{objectQualifier}GetProfilePropertyDefinitionID]
(
	@PortalID				int,
	@PropertyName			nvarchar(50)
)
RETURNS int

AS
BEGIN
	DECLARE @DefinitionID int
	SELECT @DefinitionID = -1

	IF  @PropertyName IS NULL
		OR LEN(@PropertyName) = 0
		RETURN -1

	IF @PortalID IS NULL
		SET @POrtalID = -1

	SET @DefinitionID = (SELECT PropertyDefinitionID 
							FROM {objectQualifier}ProfilePropertyDefinition
							WHERE PortalID = @PortalID
								AND PropertyName = @PropertyName
						)
	
	RETURN @DefinitionID
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteUrl]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteUrl

@PortalID     int,
@Url          nvarchar(255)

as

delete
from   {objectQualifier}Urls
where  PortalID = @PortalID
and    Url = @Url









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPropertyDefinitionsByPortal]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetPropertyDefinitionsByPortal

	@PortalID	int

AS
SELECT	{databaseOwner}{objectQualifier}ProfilePropertyDefinition.*
	FROM	{databaseOwner}{objectQualifier}ProfilePropertyDefinition
	WHERE  (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		AND Deleted = 0
	ORDER BY ViewOrder


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteEventLogType]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteEventLogType
	@LogTypeKey nvarchar(35)
AS
DELETE FROM {databaseOwner}{objectQualifier}EventLogTypes
WHERE	LogTypeKey = @LogTypeKey
	


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Profile]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Profile]
(
[ProfileId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[PortalId] [int] NOT NULL,
[ProfileData] [ntext] NOT NULL,
[CreatedDate] [datetime] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Profile] on {databaseOwner}[{objectQualifier}Profile]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Profile] ADD CONSTRAINT [PK_{objectQualifier}Profile] PRIMARY KEY CLUSTERED  ([ProfileId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}Profile] on {databaseOwner}[{objectQualifier}Profile]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_{objectQualifier}Profile] ON {databaseOwner}[{objectQualifier}Profile] ([UserId], [PortalId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteAffiliate]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteAffiliate

@AffiliateId int

as

delete
from   {objectQualifier}Affiliates
where  AffiliateId = @AffiliateId









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetRoleGroups]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetScheduleByTypeFullName]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}GetScheduleByTypeFullName
	@TypeFullName varchar(200),
	@Server varchar(150)
AS

	SELECT S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, S.Servers
	FROM {objectQualifier}Schedule S
	WHERE S.TypeFullName = @TypeFullName 
	AND (S.Servers LIKE ',%' + @Server + '%,' or S.Servers IS NULL)
	GROUP BY S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled, S.Servers

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}SearchCommonWords]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SearchCommonWords]
(
[CommonWordID] [int] NOT NULL IDENTITY(1, 1),
[CommonWord] [nvarchar] (255) NOT NULL,
[Locale] [nvarchar] (10) NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}SearchCommonWords] on {databaseOwner}[{objectQualifier}SearchCommonWords]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchCommonWords] ADD CONSTRAINT [PK_{objectQualifier}SearchCommonWords] PRIMARY KEY CLUSTERED  ([CommonWordID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchCommonWordsByLocale]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetSearchCommonWordsByLocale
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetProfile]'
GO

create procedure {databaseOwner}{objectQualifier}GetProfile

@UserId    int, 
@PortalId  int

as

select *
from   {objectQualifier}Profile
where  UserId = @UserId 
and    PortalId = @PortalId









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}PortalAlias]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}PortalAlias]
(
[PortalAliasID] [int] NOT NULL IDENTITY(1, 1),
[PortalID] [int] NOT NULL,
[HTTPAlias] [nvarchar] (200) NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}PortalAlias] on {databaseOwner}[{objectQualifier}PortalAlias]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalAlias] ADD CONSTRAINT [PK_{objectQualifier}PortalAlias] PRIMARY KEY CLUSTERED  ([PortalAliasID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateModuleControl]'
GO

CREATE  procedure {databaseOwner}{objectQualifier}UpdateModuleControl

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}fn_GetVersion]'
GO

CREATE FUNCTION {databaseOwner}[{objectQualifier}fn_GetVersion]
(
	@maj AS int,
	@min AS int,
	@bld AS int
)
RETURNS bit

AS
BEGIN
	IF Exists (SELECT * FROM {objectQualifier}Version
					WHERE Major = @maj
						AND Minor = @min
						AND Build = @bld
				)
		BEGIN
			RETURN 1
		END
	RETURN 0
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSiteLog7]'
GO

create procedure {databaseOwner}{objectQualifier}GetSiteLog7

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateModuleSetting]'
GO


create procedure {databaseOwner}{objectQualifier}UpdateModuleSetting

@ModuleId      int,
@SettingName   nvarchar(50),
@SettingValue  nvarchar(2000)

as

update {objectQualifier}ModuleSettings
set SettingValue = @SettingValue
where ModuleId = @ModuleId
and SettingName = @SettingName









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddModuleControl]'
GO

CREATE  procedure {databaseOwner}{objectQualifier}AddModuleControl
    
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}TabModuleSettings]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}TabModuleSettings]
(
[TabModuleID] [int] NOT NULL,
[SettingName] [nvarchar] (50) NOT NULL,
[SettingValue] [nvarchar] (2000) NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}TabModuleSettings] on {databaseOwner}[{objectQualifier}TabModuleSettings]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModuleSettings] ADD CONSTRAINT [PK_{objectQualifier}TabModuleSettings] PRIMARY KEY CLUSTERED  ([TabModuleID], [SettingName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}ScheduleHistory]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ScheduleHistory]
(
[ScheduleHistoryID] [int] NOT NULL IDENTITY(1, 1),
[ScheduleID] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NULL,
[Succeeded] [bit] NULL,
[LogNotes] [ntext] NULL,
[NextStart] [datetime] NULL,
[Server] [nvarchar] (150) NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}ScheduleHistory] on {databaseOwner}[{objectQualifier}ScheduleHistory]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ScheduleHistory] ADD CONSTRAINT [PK_{objectQualifier}ScheduleHistory] PRIMARY KEY CLUSTERED  ([ScheduleHistoryID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddScheduleHistory]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}AddScheduleHistory
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UserProfile]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}UserProfile]
(
[ProfileID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[PropertyDefinitionID] [int] NOT NULL,
[PropertyValue] [nvarchar] (3750) NULL,
[PropertyText] [ntext] NULL,
[Visibility] [int] NOT NULL CONSTRAINT [DF__{objectQualifier}UserP__Visib__1352D76D] DEFAULT ((0)),
[LastUpdatedDate] [datetime] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}UserProfile] on {databaseOwner}[{objectQualifier}UserProfile]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserProfile] ADD CONSTRAINT [PK_{objectQualifier}UserProfile] PRIMARY KEY NONCLUSTERED  ([ProfileID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}UserProfile] on {databaseOwner}[{objectQualifier}UserProfile]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}UserProfile] ON {databaseOwner}[{objectQualifier}UserProfile] ([UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}VendorClassification]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}VendorClassification]
(
[VendorClassificationId] [int] NOT NULL IDENTITY(1, 1),
[VendorId] [int] NOT NULL,
[ClassificationId] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}VendorClassification] on {databaseOwner}[{objectQualifier}VendorClassification]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}VendorClassification] ADD CONSTRAINT [PK_{objectQualifier}VendorClassification] PRIMARY KEY CLUSTERED  ([VendorClassificationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}VendorClassification_1] on {databaseOwner}[{objectQualifier}VendorClassification]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}VendorClassification_1] ON {databaseOwner}[{objectQualifier}VendorClassification] ([ClassificationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteVendorClassifications]'
GO


create procedure {databaseOwner}{objectQualifier}DeleteVendorClassifications

@VendorId  int

as

delete
from {objectQualifier}VendorClassification
where  VendorId = @VendorId










GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSiteLog1]'
GO


create procedure {databaseOwner}{objectQualifier}GetSiteLog1

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortalAliasByPortalAliasID]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetPortalAliasByPortalAliasID

@PortalAliasID int

as

select *
from {databaseOwner}{objectQualifier}PortalAlias
where PortalAliasID = @PortalAliasID









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteFolderPermission]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteFolderPermission
	@FolderPermissionID int
AS

DELETE FROM {databaseOwner}{objectQualifier}FolderPermission
WHERE
	[FolderPermissionID] = @FolderPermissionID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSiteLog8]'
GO

create procedure {databaseOwner}{objectQualifier}GetSiteLog8

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}SearchItemWordPosition]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SearchItemWordPosition]
(
[SearchItemWordPositionID] [int] NOT NULL IDENTITY(1, 1),
[SearchItemWordID] [int] NOT NULL,
[ContentPosition] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}SearchItemWordPosition] on {databaseOwner}[{objectQualifier}SearchItemWordPosition]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWordPosition] ADD CONSTRAINT [PK_{objectQualifier}SearchItemWordPosition] PRIMARY KEY CLUSTERED  ([SearchItemWordPositionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddSearchItemWordPosition]'
GO

CREATE  PROCEDURE {databaseOwner}{objectQualifier}AddSearchItemWordPosition
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}PurgeEventLog]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}PurgeEventLog
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateFile]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateFile
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}SystemMessages]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SystemMessages]
(
[MessageID] [int] NOT NULL IDENTITY(1, 1),
[PortalID] [int] NULL,
[MessageName] [nvarchar] (50) NOT NULL,
[MessageValue] [ntext] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}SystemMessages] on {databaseOwner}[{objectQualifier}SystemMessages]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SystemMessages] ADD CONSTRAINT [PK_{objectQualifier}SystemMessages] PRIMARY KEY CLUSTERED  ([MessageID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteSystemMessage]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteSystemMessage

@PortalID     int,
@MessageName  nvarchar(50)

as

delete
from   {objectQualifier}SystemMessages
where  PortalID = @PortalID
and    MessageName = @MessageName









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTabModuleSettings]'
GO

create procedure {databaseOwner}{objectQualifier}GetTabModuleSettings

@TabModuleId int

as

select SettingName,
       SettingValue
from   {objectQualifier}TabModuleSettings 
where  TabModuleId = @TabModuleId









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModuleSettings]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPropertyDefinition]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPropertyDefinition]

	@PropertyDefinitionID	int

AS
SELECT	{databaseOwner}{objectQualifier}ProfilePropertyDefinition.*
FROM	{databaseOwner}{objectQualifier}ProfilePropertyDefinition
WHERE PropertyDefinitionID = @PropertyDefinitionID
	AND Deleted = 0

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}SearchWord]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SearchWord]
(
[SearchWordsID] [int] NOT NULL IDENTITY(1, 1),
[Word] [nvarchar] (100) NOT NULL,
[IsCommon] [bit] NULL,
[HitCount] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}SearchWord] on {databaseOwner}[{objectQualifier}SearchWord]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchWord] ADD CONSTRAINT [PK_{objectQualifier}SearchWord] PRIMARY KEY CLUSTERED  ([SearchWordsID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchWordByID]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetSearchWordByID
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPropertyDefinitionsByCategory]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetPropertyDefinitionsByCategory
	@PortalID	int,
	@Category	nvarchar(50)

AS
SELECT	*
	FROM	{objectQualifier}ProfilePropertyDefinition
	WHERE  (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		AND PropertyCategory = @Category
	ORDER BY ViewOrder


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Permission]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Permission]
(
[PermissionID] [int] NOT NULL IDENTITY(1, 1),
[PermissionCode] [varchar] (50) NOT NULL,
[ModuleDefID] [int] NOT NULL,
[PermissionKey] [varchar] (20) NOT NULL,
[PermissionName] [varchar] (50) NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Permission] on {databaseOwner}[{objectQualifier}Permission]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Permission] ADD CONSTRAINT [PK_{objectQualifier}Permission] PRIMARY KEY CLUSTERED  ([PermissionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPermissionByCodeAndKey]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetPermissionByCodeAndKey
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSiteLog5]'
GO

create procedure {databaseOwner}{objectQualifier}GetSiteLog5

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSchedule]'
GO
CREATE PROCEDURE {databaseOwner}{objectQualifier}GetSchedule
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddFile]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}AddFile

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateRoleGroup]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Skins]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Skins]
(
[SkinID] [int] NOT NULL IDENTITY(1, 1),
[PortalID] [int] NULL,
[SkinRoot] [nvarchar] (50) NOT NULL,
[SkinSrc] [nvarchar] (200) NOT NULL,
[SkinType] [int] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Skins] on {databaseOwner}[{objectQualifier}Skins]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Skins] ADD CONSTRAINT [PK_{objectQualifier}Skins] PRIMARY KEY CLUSTERED  ([SkinID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddSkin]'
GO

create procedure {databaseOwner}{objectQualifier}AddSkin

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteModulePermissionsByModuleID]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteModulePermissionsByModuleID
	@ModuleID int
AS

DELETE FROM {databaseOwner}{objectQualifier}ModulePermission
WHERE
	[ModuleID] = @ModuleID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTabModuleSetting]'
GO

create procedure {databaseOwner}{objectQualifier}GetTabModuleSetting

@TabModuleId int,
@SettingName nvarchar(50)

as

select SettingName,
       SettingValue
from   {objectQualifier}TabModuleSettings 
where  TabModuleId = @TabModuleId
and    SettingName = @SettingName









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteRoleGroup]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeleteRoleGroup]

	@RoleGroupId      int
	
AS

DELETE  
FROM {databaseOwner}{objectQualifier}RoleGroups
WHERE  RoleGroupId = @RoleGroupId


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetScheduleByEvent]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetScheduleByEvent
@EventName varchar(50),
@Server varchar(150)
AS
SELECT S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled
FROM {databaseOwner}{objectQualifier}Schedule S
WHERE S.AttachToEvent = @EventName
AND (S.Servers LIKE ',%' + @Server + '%,' or S.Servers IS NULL)
GROUP BY S.ScheduleID, S.TypeFullName, S.TimeLapse, S.TimeLapseMeasurement,  S.RetryTimeLapse, S.RetryTimeLapseMeasurement, S.ObjectDependencies, S.AttachToEvent, S.RetainHistoryNum, S.CatchUpEnabled, S.Enabled



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateScheduleHistory]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateScheduleHistory
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeletePermission]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}DeletePermission
	@PermissionID int
AS

DELETE FROM {databaseOwner}{objectQualifier}Permission
WHERE
	[PermissionID] = @PermissionID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddSearchItem]'
GO

create procedure {databaseOwner}{objectQualifier}AddSearchItem

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}FindDatabaseVersion]'
GO

create procedure {databaseOwner}{objectQualifier}FindDatabaseVersion

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteSchedule]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteSchedule
@ScheduleID int
AS
DELETE FROM {databaseOwner}{objectQualifier}Schedule
WHERE ScheduleID = @ScheduleID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddUserRole]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetEventLogConfig]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetEventLogConfig
	@ID int
AS
SELECT *
FROM {databaseOwner}{objectQualifier}EventLogConfig
WHERE (ID = @ID or @ID IS NULL)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddEventLog]'
GO






CREATE PROCEDURE {databaseOwner}{objectQualifier}AddEventLog
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddPortalAlias]'
GO
CREATE procedure {databaseOwner}{objectQualifier}AddPortalAlias

@PortalID int,
@HTTPAlias nvarchar(200)

as

INSERT INTO {databaseOwner}{objectQualifier}PortalAlias 
(PortalID, HTTPAlias)
VALUES
(@PortalID, @HTTPAlias)

select SCOPE_IDENTITY()









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteSearchItems]'
GO

CREATE procedure {databaseOwner}{objectQualifier}DeleteSearchItems
(
	@ModuleID int
)
AS

DELETE
FROM	{objectQualifier}SearchItem
WHERE	ModuleID = @ModuleID







GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortalAlias]'
GO


CREATE procedure {databaseOwner}{objectQualifier}GetPortalAlias

@HTTPAlias nvarchar(200),
@PortalID int

as

select *
from {databaseOwner}{objectQualifier}PortalAlias
where HTTPAlias = @HTTPAlias 
and PortalID = @PortalID










GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteSearchItemWord]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteSearchItemWord
	@SearchItemWordID int
AS

DELETE FROM {databaseOwner}{objectQualifier}SearchItemWord
WHERE
	[SearchItemWordID] = @SearchItemWordID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateUserRole]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteModuleSetting]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteModuleSetting
@ModuleId      int,
@SettingName   nvarchar(50)
as

DELETE FROM {objectQualifier}ModuleSettings 
WHERE ModuleId = @ModuleId
AND SettingName = @SettingName


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSkins]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetSkins]

@PortalID		int

AS
SELECT *
FROM	{objectQualifier}Skins
WHERE   (PortalID = @PortalID) OR (PortalID is null And @PortalId Is Null)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdatePortalAliasOnInstall]'
GO

CREATE procedure {databaseOwner}{objectQualifier}UpdatePortalAliasOnInstall

@PortalAlias nvarchar(200)

as

update {databaseOwner}{objectQualifier}PortalAlias 
set    HTTPAlias = @PortalAlias
where  HTTPAlias = '_default'


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UrlLog]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}UrlLog]
(
[UrlLogID] [int] NOT NULL IDENTITY(1, 1),
[UrlTrackingID] [int] NOT NULL,
[ClickDate] [datetime] NOT NULL,
[UserID] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}UrlLog] on {databaseOwner}[{objectQualifier}UrlLog]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlLog] ADD CONSTRAINT [PK_{objectQualifier}UrlLog] PRIMARY KEY CLUSTERED  ([UrlLogID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddFolderPermission]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}AddFolderPermission
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUrl]'
GO

create procedure {databaseOwner}{objectQualifier}GetUrl

@PortalID     int,
@Url          nvarchar(255)

as

select *
from   {objectQualifier}Urls
where  PortalID = @PortalID
and    Url = @Url









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdatePermission]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdatePermission
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateAffiliateStats]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateAffiliateStats

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteTabModuleSettings]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteTabModuleSettings
@TabModuleId      int
as

DELETE FROM {objectQualifier}TabModuleSettings 
WHERE TabModuleId = @TabModuleId


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddUrlLog]'
GO

create procedure {databaseOwner}{objectQualifier}AddUrlLog

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddSearchItemWord]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddAffiliate]'
GO

create procedure {databaseOwner}{objectQualifier}AddAffiliate

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateEventLogType]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateEventLogType
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdatePortalAlias]'
GO

CREATE procedure {databaseOwner}{objectQualifier}UpdatePortalAlias
@PortalAliasID int,
@PortalID int,
@HTTPAlias nvarchar(200)

as

UPDATE {databaseOwner}{objectQualifier}PortalAlias 
SET HTTPAlias = @HTTPAlias
WHERE PortalID = @PortalID
AND	  PortalAliasID = @PortalAliasID
	








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddPermission]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}AddPermission
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateFolderPermission]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateFolderPermission
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchItemWord]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetSearchItemWord
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteModuleControl]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteModuleControl

@ModuleControlId int

as

delete
from   {objectQualifier}ModuleControls
where  ModuleControlId = @ModuleControlId









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddModulePermission]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}AddModulePermission
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchItem]'
GO

create procedure {databaseOwner}{objectQualifier}GetSearchItem
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddVendorClassification]'
GO


create procedure {databaseOwner}{objectQualifier}AddVendorClassification

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteSiteLog]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteSiteLog

@DateTime                      datetime, 
@PortalId                      int

as

delete
from {objectQualifier}SiteLog
where  PortalId = @PortalId
and    DateTime < @DateTime









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateSearchItem]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateSearchItem
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSystemMessages]'
GO

create procedure {databaseOwner}{objectQualifier}GetSystemMessages

as

select MessageName
from   {objectQualifier}SystemMessages
where  PortalID is null









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSystemMessage]'
GO

create procedure {databaseOwner}{objectQualifier}GetSystemMessage

@PortalID     int,
@MessageName  nvarchar(50)

as

select MessageValue
from   {objectQualifier}SystemMessages
where  ((PortalID = @PortalID) or (PortalID is null and @PortalID is null)) 
and    MessageName = @MessageName









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddTabModuleSetting]'
GO

create procedure {databaseOwner}{objectQualifier}AddTabModuleSetting

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}ListSearchItem]'
GO

create procedure {databaseOwner}{objectQualifier}ListSearchItem

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeletePropertyDefinition]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}DeletePropertyDefinition]

	@PropertyDefinitionId int

AS

UPDATE {databaseOwner}{objectQualifier}ProfilePropertyDefinition 
	SET Deleted = 1
	WHERE  PropertyDefinitionId = @PropertyDefinitionId

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddTabPermission]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}AddTabPermission
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateTabPermission]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateTabPermission
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddEventLogConfig]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}AddEventLogConfig
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}ListSearchItemWord]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}ListSearchItemWord
AS

SELECT
	[SearchItemWordID],
	[SearchItemID],
	[SearchWordsID],
	[Occurrences]
FROM
	{databaseOwner}{objectQualifier}SearchItemWord








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchItemWordBySearchItem]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetSearchItemWordBySearchItem
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetElement]'
GO

CREATE FUNCTION {databaseOwner}[{objectQualifier}GetElement]
(
	@ord AS INT,
	@str AS VARCHAR(8000),
	@delim AS VARCHAR(1) 
)
RETURNS INT

AS

BEGIN
	-- If input is invalid, return null.
	IF  @str IS NULL
		OR LEN(@str) = 0
		OR @ord IS NULL
		OR @ord < 1
		-- @ord > [is the] expression that calculates the number of elements.
		OR @ord > LEN(@str) - LEN(REPLACE(@str, @delim, '')) + 1
		RETURN NULL
 
	DECLARE @pos AS INT, @curord AS INT
	SELECT @pos = 1, @curord = 1
	-- Find next element's start position and increment index.
	WHILE @curord < @ord
		SELECT
			@pos = CHARINDEX(@delim, @str, @pos) + 1,
			@curord = @curord + 1
	RETURN    CAST(SUBSTRING(@str, @pos, CHARINDEX(@delim, @str + @delim, @pos) - @pos) AS INT)
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetProfileElement]'
GO

CREATE FUNCTION {databaseOwner}[{objectQualifier}GetProfileElement]
(
	@fieldName AS NVARCHAR(100),
	@fields AS NVARCHAR(4000),
	@values AS NVARCHAR(4000)
)

RETURNS NVARCHAR(4000)

AS

BEGIN

	-- If input is invalid, return null.
	IF  @fieldName IS NULL
		OR LEN(@fieldName) = 0
		OR @fields IS NULL
		OR LEN(@fields) = 0
		OR @values IS NULL
		OR LEN(@values) = 0
		RETURN NULL

	-- locate FieldName in Fields
	DECLARE @fieldNameToken AS NVARCHAR(20)
	DECLARE @fieldNameStart AS INTEGER, @valueStart AS INTEGER, @valueLength AS INTEGER

	-- Only handle string type fields (:S:)
	SET @fieldNameStart = CHARINDEX(@fieldName + ':S',@Fields,0)

	-- If field is not found, return null
	IF @fieldNameStart = 0 RETURN NULL
	SET @fieldNameStart = @fieldNameStart + LEN(@fieldName) + 3

	-- Get the field token which I've defined as the start of the field offset to the end of the length
	SET @fieldNameToken =
	SUBSTRING(@Fields,@fieldNameStart,LEN(@Fields)-@fieldNameStart)

	-- Get the values for the offset and length
	SET @valueStart = {databaseOwner}{objectQualifier}getelement(1,@fieldNameToken,':')
	SET @valueLength = {databaseOwner}{objectQualifier}getelement(2,@fieldNameToken,':')

	-- Check for sane values, 0 length means the profile item was stored, just no data
	IF @valueLength = 0 RETURN ''

	-- Return the string
	RETURN SUBSTRING(@values, @valueStart+1, @valueLength)
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSiteLog12]'
GO

create procedure {databaseOwner}{objectQualifier}GetSiteLog12

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetRoleGroup]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteSearchCommonWord]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteSearchCommonWord
	@CommonWordID int
AS

DELETE FROM {databaseOwner}{objectQualifier}SearchCommonWords
WHERE
	[CommonWordID] = @CommonWordID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddSearchCommonWord]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}AddSearchCommonWord
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddSiteLog]'
GO

create procedure {databaseOwner}{objectQualifier}AddSiteLog

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchWords]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetSearchWords
AS

SELECT
	[SearchWordsID],
	[Word],
	[HitCount]
FROM
	{databaseOwner}{objectQualifier}SearchWord








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddScheduleItemSetting]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}AddScheduleItemSetting

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateSearchItemWordPosition]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateSearchItemWordPosition
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchCommonWordByID]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetSearchCommonWordByID
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteTabModuleSetting]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteTabModuleSetting
@TabModuleId      int,
@SettingName   nvarchar(50)
as

DELETE FROM {objectQualifier}TabModuleSettings 
WHERE TabModuleId = @TabModuleId
AND SettingName = @SettingName


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteSearchWord]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteSearchWord
	@SearchWordsID int
AS

DELETE FROM {databaseOwner}{objectQualifier}SearchWord
WHERE
	[SearchWordsID] = @SearchWordsID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddSchedule]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}AddSchedule
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModuleControl]'
GO

create procedure {databaseOwner}{objectQualifier}GetModuleControl

@ModuleControlId int

as

select *
from   {objectQualifier}ModuleControls
where  ModuleControlId = @ModuleControlId









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}ListSearchItemWordPosition]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}ListSearchItemWordPosition
AS

SELECT
	[SearchItemWordPositionID],
	[SearchItemWordID],
	[ContentPosition]
FROM
	{databaseOwner}{objectQualifier}SearchItemWordPosition








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPropertyDefinitionByName]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetPropertyDefinitionByName
	@PortalID	int,
	@Name		nvarchar(50)

AS
SELECT	*
	FROM	{objectQualifier}ProfilePropertyDefinition
	WHERE  (PortalId = @PortalId OR (PortalId IS NULL AND @PortalId IS NULL))
		AND PropertyName = @Name
	ORDER BY ViewOrder


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetAllProfiles]'
GO

create procedure {databaseOwner}{objectQualifier}GetAllProfiles
AS
SELECT * FROM {objectQualifier}Profile




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetFileContent]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetFileContent

@FileId   int,
@PortalId int

as

select Content
from   {objectQualifier}Files
where  FileId = @FileId
and    (({objectQualifier}Files.PortalId = @PortalId) or (@PortalId is null and {objectQualifier}Files.PortalId is null))


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetEventLogPendingNotif]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetEventLogPendingNotif
	@LogConfigID int
AS
SELECT *
FROM {databaseOwner}{objectQualifier}EventLog
WHERE LogNotificationPending = 1
AND LogConfigID = @LogConfigID



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetScheduleHistory]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}GetScheduleHistory
@ScheduleID int
AS
SELECT S.ScheduleID, S.TypeFullName, SH.StartDate, SH.EndDate, SH.Succeeded, SH.LogNotes, SH.NextStart, SH.Server
FROM {databaseOwner}{objectQualifier}Schedule S
INNER JOIN {databaseOwner}{objectQualifier}ScheduleHistory SH
ON S.ScheduleID = SH.ScheduleID
WHERE S.ScheduleID = @ScheduleID or @ScheduleID = -1


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPermissionsByTabID]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetPermissionsByTabID
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchItemWordPosition]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetSearchItemWordPosition
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUserProfile]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateEventLogPendingNotif]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateEventLogPendingNotif
	@LogConfigID int
AS
UPDATE {databaseOwner}{objectQualifier}EventLog
SET LogNotificationPending = 0
WHERE LogNotificationPending = 1
AND LogConfigID = @LogConfigID



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateProfile]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateProfile

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateEventLogConfig]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateEventLogConfig
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateSearchWord]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateSearchWord
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteSearchItemWordPosition]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteSearchItemWordPosition
	@SearchItemWordPositionID int
AS

DELETE FROM {databaseOwner}{objectQualifier}SearchItemWordPosition
WHERE
	[SearchItemWordPositionID] = @SearchItemWordPositionID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteEventLog]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteEventLog
	@LogGUID varchar(36)
AS
DELETE FROM {databaseOwner}{objectQualifier}EventLog
WHERE LogGUID = @LogGUID or @LogGUID IS NULL



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetAffiliates]'
GO

create procedure {databaseOwner}{objectQualifier}GetAffiliates

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdatePropertyDefinition]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateUserProfileProperty]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPermissionsByFolderPath]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}GetPermissionsByFolderPath
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateSearchItemWord]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateSearchItemWord
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortalByAlias]'
GO


CREATE procedure {databaseOwner}{objectQualifier}GetPortalByAlias

@HTTPAlias nvarchar(200)

as

select 'PortalId' = min(PortalId)
from {databaseOwner}{objectQualifier}PortalAlias
where  HTTPAlias = @HTTPAlias









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddSystemMessage]'
GO

create procedure {databaseOwner}{objectQualifier}AddSystemMessage

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPermission]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetPermission
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModuleSetting]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddPortalDesktopModule]'
GO

create procedure {databaseOwner}{objectQualifier}AddPortalDesktopModule

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteTabPermission]'
GO



CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteTabPermission
	@TabPermissionID int
AS

DELETE FROM {databaseOwner}{objectQualifier}TabPermission
WHERE
	[TabPermissionID] = @TabPermissionID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddRoleGroup]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetEventLogType]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetEventLogType
AS
SELECT *
FROM {databaseOwner}{objectQualifier}EventLogTypes



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteModulePermission]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteModulePermission
	@ModulePermissionID int
AS

DELETE FROM {databaseOwner}{objectQualifier}ModulePermission
WHERE
	[ModulePermissionID] = @ModulePermissionID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteFile]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteFile
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteSearchItem]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteSearchItem
	@SearchItemID int
AS

DELETE FROM {databaseOwner}{objectQualifier}SearchItem
WHERE
	[SearchItemID] = @SearchItemID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateTabModuleSetting]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateTabModuleSetting

@TabModuleId   int,
@SettingName   nvarchar(50),
@SettingValue  nvarchar(2000)

as

update {objectQualifier}TabModuleSettings
set    SettingValue = @SettingValue
where  TabModuleId = @TabModuleId
and    SettingName = @SettingName









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteSkin]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteSkin

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModuleControls]'
GO

create procedure {databaseOwner}{objectQualifier}GetModuleControls

@ModuleDefId int

as

select *
from   {objectQualifier}ModuleControls
where  (ModuleDefId is null and @ModuleDefId is null) or (ModuleDefId = @ModuleDefId)
order  by ControlKey, ViewOrder









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteModuleSettings]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteModuleSettings
@ModuleId      int
as

DELETE FROM {objectQualifier}ModuleSettings 
WHERE ModuleId = @ModuleId


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeletePortalAlias]'
GO

CREATE procedure {databaseOwner}{objectQualifier}DeletePortalAlias
@PortalAliasID int

as

DELETE FROM {databaseOwner}{objectQualifier}PortalAlias 
WHERE PortalAliasID = @PortalAliasID
	








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteUserRole]'
GO


create procedure {databaseOwner}{objectQualifier}DeleteUserRole

@UserId int,
@RoleId int

as

delete
from {objectQualifier}UserRoles
where  UserId = @UserId
and    RoleId = @RoleId


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUrls]'
GO

create procedure {databaseOwner}{objectQualifier}GetUrls

@PortalID     int

as

select *
from   {objectQualifier}Urls
where  PortalID = @PortalID
order by Url









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteTabPermissionsByTabID]'
GO



CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteTabPermissionsByTabID
	@TabID int
AS

DELETE FROM {databaseOwner}{objectQualifier}TabPermission
WHERE
	[TabID] = @TabID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddEventLogType]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}AddEventLogType
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddModuleSetting]'
GO

create procedure {databaseOwner}{objectQualifier}AddModuleSetting

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateModulePermission]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateModulePermission
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateFileContent]'
GO

CREATE procedure {databaseOwner}{objectQualifier}UpdateFileContent

@FileId      int,
@Content     image

as

update {objectQualifier}Files
set    Content = @Content
where  FileId = @FileId


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateSystemMessage]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateSystemMessage

@PortalID     int,
@MessageName  nvarchar(50),
@MessageValue ntext

as

update {objectQualifier}SystemMessages
set    MessageValue = @MessageValue
where  ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
and    MessageName = @MessageName









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteFiles]'
GO


create procedure {databaseOwner}{objectQualifier}DeleteFiles

@PortalId int

as

delete 
from   {objectQualifier}Files
where  ((PortalId = @PortalId) or (@PortalId is null and PortalId is null))









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateSearchCommonWord]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateSearchCommonWord
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPermissionsByModuleDefID]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchItemWordBySearchWord]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetSearchItemWordBySearchWord
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteEventLogConfig]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteEventLogConfig
	@ID int
AS
DELETE FROM {databaseOwner}{objectQualifier}EventLogConfig
WHERE ID = @ID



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetScheduleByScheduleID]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetScheduleByScheduleID
@ScheduleID int
AS
SELECT S.*
FROM {databaseOwner}{objectQualifier}Schedule S
WHERE S.ScheduleID = @ScheduleID









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSkin]'
GO

create procedure {databaseOwner}{objectQualifier}GetSkin

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteSearchItemWords]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteSearchItemWords
	@SearchItemID int
AS

delete from {databaseOwner}{objectQualifier}SearchItemWord
where
	[SearchItemID] = @SearchItemID








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchItemWordPositionBySearchItemWord]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetSearchItemWordPositionBySearchItemWord
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddSearchWord]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateSchedule]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateSchedule
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetEventLogByLogGUID]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}GetEventLogByLogGUID
	@LogGUID varchar(36)
AS
SELECT *
FROM {databaseOwner}{objectQualifier}EventLog
WHERE (LogGUID = @LogGUID)



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddProfile]'
GO

create procedure {databaseOwner}{objectQualifier}AddProfile

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortalAliasByPortalID]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetPortalAliasByPortalID

@PortalID int

as

select *
from {databaseOwner}{objectQualifier}PortalAlias
where (PortalID = @PortalID or @PortalID = -1)










GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Portals]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Portals]
(
[PortalID] [int] NOT NULL IDENTITY(0, 1),
[PortalName] [nvarchar] (128) NOT NULL,
[LogoFile] [nvarchar] (50) NULL,
[FooterText] [nvarchar] (100) NULL,
[ExpiryDate] [datetime] NULL,
[UserRegistration] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_UserRegistration] DEFAULT ((0)),
[BannerAdvertising] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_BannerAdvertising] DEFAULT ((0)),
[AdministratorId] [int] NULL,
[Currency] [char] (3) NULL,
[HostFee] [money] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_HostFee] DEFAULT ((0)),
[HostSpace] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_HostSpace] DEFAULT ((0)),
[AdministratorRoleId] [int] NULL,
[RegisteredRoleId] [int] NULL,
[Description] [nvarchar] (500) NULL,
[KeyWords] [nvarchar] (500) NULL,
[BackgroundFile] [nvarchar] (50) NULL,
[GUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_GUID] DEFAULT (newid()),
[PaymentProcessor] [nvarchar] (50) NULL,
[ProcessorUserId] [nvarchar] (50) NULL,
[ProcessorPassword] [nvarchar] (50) NULL,
[SiteLogHistory] [int] NULL,
[HomeTabId] [int] NULL,
[LoginTabId] [int] NULL,
[UserTabId] [int] NULL,
[DefaultLanguage] [nvarchar] (10) NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_DefaultLanguage] DEFAULT ('en-US'),
[TimezoneOffset] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_TimezoneOffset] DEFAULT ((-8)),
[AdminTabId] [int] NULL,
[HomeDirectory] [varchar] (100) NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_HomeDirectory] DEFAULT (''),
[SplashTabId] [int] NULL,
[PageQuota] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_PageQuota] DEFAULT ((0)),
[UserQuota] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_UserQuota] DEFAULT ((0))
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Portals] on {databaseOwner}[{objectQualifier}Portals]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Portals] ADD CONSTRAINT [PK_{objectQualifier}Portals] PRIMARY KEY NONCLUSTERED  ([PortalID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DesktopModules]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}DesktopModules]
(
[DesktopModuleID] [int] NOT NULL IDENTITY(1, 1),
[FriendlyName] [nvarchar] (128) NOT NULL,
[Description] [nvarchar] (2000) NULL,
[Version] [nvarchar] (8) NULL,
[IsPremium] [bit] NOT NULL,
[IsAdmin] [bit] NOT NULL,
[BusinessControllerClass] [nvarchar] (200) NULL,
[FolderName] [nvarchar] (128) NOT NULL,
[ModuleName] [nvarchar] (128) NOT NULL,
[SupportedFeatures] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}DesktopModules_SupportedFeatures] DEFAULT ((0)),
[CompatibleVersions] [nvarchar] (500) NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}DesktopModules] on {databaseOwner}[{objectQualifier}DesktopModules]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}DesktopModules] ADD CONSTRAINT [PK_{objectQualifier}DesktopModules] PRIMARY KEY CLUSTERED  ([DesktopModuleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}DesktopModules_FriendlyName] on {databaseOwner}[{objectQualifier}DesktopModules]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}DesktopModules_FriendlyName] ON {databaseOwner}[{objectQualifier}DesktopModules] ([FriendlyName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}PurgeScheduleHistory]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}PurgeScheduleHistory
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Users]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Users]
(
[UserID] [int] NOT NULL IDENTITY(1, 1),
[Username] [nvarchar] (100) NOT NULL,
[FirstName] [nvarchar] (50) NOT NULL,
[LastName] [nvarchar] (50) NOT NULL,
[IsSuperUser] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Users_IsSuperUser] DEFAULT ((0)),
[AffiliateId] [int] NULL,
[Email] [nvarchar] (256) NULL,
[DisplayName] [nvarchar] (128) NOT NULL CONSTRAINT [DF_{objectQualifier}Users_DisplayName] DEFAULT (''),
[UpdatePassword] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Users_UpdatePassword] DEFAULT ((0))
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Users] on {databaseOwner}[{objectQualifier}Users]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Users] ADD CONSTRAINT [PK_{objectQualifier}Users] PRIMARY KEY CLUSTERED  ([UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSiteLog3]'
GO

create procedure {databaseOwner}{objectQualifier}GetSiteLog3

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Roles]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Roles]
(
[RoleID] [int] NOT NULL IDENTITY(0, 1),
[PortalID] [int] NOT NULL,
[RoleName] [nvarchar] (50) NOT NULL,
[Description] [nvarchar] (1000) NULL,
[ServiceFee] [money] NULL CONSTRAINT [DF_{objectQualifier}Roles_ServiceFee] DEFAULT ((0)),
[BillingFrequency] [char] (1) NULL,
[TrialPeriod] [int] NULL,
[TrialFrequency] [char] (1) NULL,
[BillingPeriod] [int] NULL,
[TrialFee] [money] NULL,
[IsPublic] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Roles_IsPublic] DEFAULT ((0)),
[AutoAssignment] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Roles_AutoAssignment] DEFAULT ((0)),
[RoleGroupID] [int] NULL,
[RSVPCode] [nvarchar] (50) NULL,
[IconFile] [nvarchar] (100) NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Roles] on {databaseOwner}[{objectQualifier}Roles]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Roles] ADD CONSTRAINT [PK_{objectQualifier}Roles] PRIMARY KEY NONCLUSTERED  ([RoleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}Roles] on {databaseOwner}[{objectQualifier}Roles]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}Roles] ON {databaseOwner}[{objectQualifier}Roles] ([BillingFrequency])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddPropertyDefinition]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}AddPropertyDefinition
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
				Length = @Length
			WHERE PropertyDefinitionId = @PropertyDefinitionId
	END
	
SELECT @PropertyDefinitionId


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTabPermissionsByTabID]'
GO



CREATE PROCEDURE {databaseOwner}{objectQualifier}GetTabPermissionsByTabID
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetDesktopModuleByModuleName]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetDesktopModuleByModuleName

	@ModuleName    nvarchar(128)

as

select *
from   {objectQualifier}DesktopModules
where  ModuleName = @ModuleName



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}TabModules]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}TabModules]
(
[TabModuleID] [int] NOT NULL IDENTITY(1, 1),
[TabID] [int] NOT NULL,
[ModuleID] [int] NOT NULL,
[PaneName] [nvarchar] (50) NOT NULL,
[ModuleOrder] [int] NOT NULL,
[CacheTime] [int] NOT NULL,
[Alignment] [nvarchar] (10) NULL,
[Color] [nvarchar] (20) NULL,
[Border] [nvarchar] (1) NULL,
[IconFile] [nvarchar] (100) NULL,
[Visibility] [int] NOT NULL,
[ContainerSrc] [nvarchar] (200) NULL,
[DisplayTitle] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}TabModules_DisplayTitle] DEFAULT ((1)),
[DisplayPrint] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}TabModules_DisplayPrint] DEFAULT ((1)),
[DisplaySyndicate] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}TabModules_DisplaySyndicate] DEFAULT ((1))
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}TabModules] on {databaseOwner}[{objectQualifier}TabModules]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules] ADD CONSTRAINT [PK_{objectQualifier}TabModules] PRIMARY KEY CLUSTERED  ([TabModuleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UserPortals]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}UserPortals]
(
[UserId] [int] NOT NULL,
[PortalId] [int] NOT NULL,
[UserPortalId] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_{objectQualifier}UserPortals_CreatedDate] DEFAULT (getdate()),
[Authorised] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}UserPortals_Authorised] DEFAULT ((1))
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}UserPortals] on {databaseOwner}[{objectQualifier}UserPortals]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserPortals] ADD CONSTRAINT [PK_{objectQualifier}UserPortals] PRIMARY KEY CLUSTERED  ([UserId], [PortalId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}UserPortals_1] on {databaseOwner}[{objectQualifier}UserPortals]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}UserPortals_1] ON {databaseOwner}[{objectQualifier}UserPortals] ([UserId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}UserPortals] on {databaseOwner}[{objectQualifier}UserPortals]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}UserPortals] ON {databaseOwner}[{objectQualifier}UserPortals] ([PortalId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Modules]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Modules]
(
[ModuleID] [int] NOT NULL IDENTITY(0, 1),
[ModuleDefID] [int] NOT NULL,
[ModuleTitle] [nvarchar] (256) NULL,
[AllTabs] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Modules_AllTabs] DEFAULT ((0)),
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Modules_IsDeleted] DEFAULT ((0)),
[InheritViewPermissions] [bit] NULL,
[Header] [ntext] NULL,
[Footer] [ntext] NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[PortalID] [int] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Modules] on {databaseOwner}[{objectQualifier}Modules]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Modules] ADD CONSTRAINT [PK_{objectQualifier}Modules] PRIMARY KEY NONCLUSTERED  ([ModuleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}Modules] on {databaseOwner}[{objectQualifier}Modules]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}Modules] ON {databaseOwner}[{objectQualifier}Modules] ([ModuleDefID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateModuleOrder]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateModuleOrder

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UsersOnline]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}UsersOnline]
(
[UserID] [int] NOT NULL,
[PortalID] [int] NOT NULL,
[TabID] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__{objectQualifier}Users__Creat__3BFFE745] DEFAULT (getdate()),
[LastActiveDate] [datetime] NOT NULL CONSTRAINT [DF__{objectQualifier}Users__LastA__3CF40B7E] DEFAULT (getdate())
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}UsersOnline] on {databaseOwner}[{objectQualifier}UsersOnline]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UsersOnline] ADD CONSTRAINT [PK_{objectQualifier}UsersOnline] PRIMARY KEY CLUSTERED  ([UserID], [PortalID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUserRolesByUsername]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetUserRolesByUsername

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetVendorClassifications]'
GO

create procedure {databaseOwner}{objectQualifier}GetVendorClassifications

@VendorId  int

as

select ClassificationId,
       ClassificationName,
       'IsAssociated' = case when exists ( select 1 from {objectQualifier}VendorClassification vc where vc.VendorId = @VendorId and vc.ClassificationId = {objectQualifier}Classification.ClassificationId ) then 1 else 0 end
from {objectQualifier}Classification








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}ModuleDefinitions]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ModuleDefinitions]
(
[ModuleDefID] [int] NOT NULL IDENTITY(1, 1),
[FriendlyName] [nvarchar] (128) NOT NULL,
[DesktopModuleID] [int] NOT NULL,
[DefaultCacheTime] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}ModuleDefinitions_DefaultCacheTime] DEFAULT ((0))
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}ModuleDefinitions] on {databaseOwner}[{objectQualifier}ModuleDefinitions]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleDefinitions] ADD CONSTRAINT [PK_{objectQualifier}ModuleDefinitions] PRIMARY KEY NONCLUSTERED  ([ModuleDefID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}ModuleDefinitions_1] on {databaseOwner}[{objectQualifier}ModuleDefinitions]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}ModuleDefinitions_1] ON {databaseOwner}[{objectQualifier}ModuleDefinitions] ([DesktopModuleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteModuleDefinition]'
GO


create procedure {databaseOwner}{objectQualifier}DeleteModuleDefinition

@ModuleDefId int

as

delete
from {objectQualifier}ModuleDefinitions
where  ModuleDefId = @ModuleDefId










GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetEventLogPendingNotifConfig]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetEventLogPendingNotifConfig
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AnonymousUsers]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}AnonymousUsers]
(
[UserID] [char] (36) NOT NULL,
[PortalID] [int] NOT NULL,
[TabID] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_{objectQualifier}AnonymousUsers_CreationDate] DEFAULT (getdate()),
[LastActiveDate] [datetime] NOT NULL CONSTRAINT [DF_{objectQualifier}AnonymousUsers_LastActiveDate] DEFAULT (getdate())
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}AnonymousUsers] on {databaseOwner}[{objectQualifier}AnonymousUsers]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}AnonymousUsers] ADD CONSTRAINT [PK_{objectQualifier}AnonymousUsers] PRIMARY KEY CLUSTERED  ([UserID], [PortalID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetDefaultLanguageByModule]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetDefaultLanguageByModule
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetDesktopModules]'
GO

create procedure {databaseOwner}{objectQualifier}GetDesktopModules

as

select *
from   {objectQualifier}DesktopModules
where  IsAdmin = 0
order  by FriendlyName


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Tabs]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Tabs]
(
[TabID] [int] NOT NULL IDENTITY(0, 1),
[TabOrder] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Tabs_TabOrder] DEFAULT ((0)),
[PortalID] [int] NULL,
[TabName] [nvarchar] (50) NOT NULL,
[IsVisible] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Tabs_IsVisible] DEFAULT ((1)),
[ParentId] [int] NULL,
[Level_] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Tabs_Level] DEFAULT ((0)),
[IconFile] [nvarchar] (100) NULL,
[DisableLink] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Tabs_DisableLink] DEFAULT ((0)),
[Title] [nvarchar] (200) NULL,
[Description] [nvarchar] (500) NULL,
[KeyWords] [nvarchar] (500) NULL,
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Tabs_IsDeleted] DEFAULT ((0)),
[Url] [nvarchar] (255) NULL,
[SkinSrc] [nvarchar] (200) NULL,
[ContainerSrc] [nvarchar] (200) NULL,
[TabPath] [nvarchar] (255) NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[RefreshInterval] [int] NULL,
[PageHeadText] [nvarchar] (500) NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Tabs] on {databaseOwner}[{objectQualifier}Tabs]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs] ADD CONSTRAINT [PK_{objectQualifier}Tabs] PRIMARY KEY CLUSTERED  ([TabID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}Tabs_1] on {databaseOwner}[{objectQualifier}Tabs]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}Tabs_1] ON {databaseOwner}[{objectQualifier}Tabs] ([PortalID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}Tabs_2] on {databaseOwner}[{objectQualifier}Tabs]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}Tabs_2] ON {databaseOwner}[{objectQualifier}Tabs] ([ParentId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetEventLog]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetEventLog
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Vendors]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Vendors]
(
[VendorId] [int] NOT NULL IDENTITY(1, 1),
[VendorName] [nvarchar] (50) NOT NULL,
[Street] [nvarchar] (50) NULL,
[City] [nvarchar] (50) NULL,
[Region] [nvarchar] (50) NULL,
[Country] [nvarchar] (50) NULL,
[PostalCode] [nvarchar] (50) NULL,
[Telephone] [nvarchar] (50) NULL,
[PortalId] [int] NULL,
[Fax] [nvarchar] (50) NULL,
[Email] [nvarchar] (50) NULL,
[Website] [nvarchar] (100) NULL,
[ClickThroughs] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Vendors_ClickThroughs] DEFAULT ((0)),
[Views] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Vendors_Views] DEFAULT ((0)),
[CreatedByUser] [nvarchar] (100) NULL,
[CreatedDate] [datetime] NULL,
[LogoFile] [nvarchar] (100) NULL,
[KeyWords] [ntext] NULL,
[Unit] [nvarchar] (50) NULL,
[Authorized] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Vendors_Authorized] DEFAULT ((1)),
[FirstName] [nvarchar] (50) NULL,
[LastName] [nvarchar] (50) NULL,
[Cell] [varchar] (50) NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Vendor] on {databaseOwner}[{objectQualifier}Vendors]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Vendors] ADD CONSTRAINT [PK_{objectQualifier}Vendor] PRIMARY KEY CLUSTERED  ([VendorId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteVendor]'
GO


create procedure {databaseOwner}{objectQualifier}DeleteVendor

@VendorId int

as

delete
from {objectQualifier}Vendors
where  VendorId = @VendorId










GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}vw_ModulePermissions]'
GO

CREATE VIEW {databaseOwner}[{objectQualifier}vw_ModulePermissions]
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
FROM {objectQualifier}ModulePermission AS MP 
	LEFT OUTER JOIN {objectQualifier}Permission AS P ON MP.PermissionID = P.PermissionID 
	LEFT OUTER JOIN {objectQualifier}Roles AS R ON MP.RoleID = R.RoleID

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTabCount]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteRole]'
GO

CREATE procedure {databaseOwner}{objectQualifier}DeleteRole

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UrlTracking]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}UrlTracking]
(
[UrlTrackingID] [int] NOT NULL IDENTITY(1, 1),
[PortalID] [int] NULL,
[Url] [nvarchar] (255) NOT NULL,
[UrlType] [char] (1) NOT NULL,
[Clicks] [int] NOT NULL,
[LastClick] [datetime] NULL,
[CreatedDate] [datetime] NOT NULL,
[LogActivity] [bit] NOT NULL,
[TrackClicks] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}UrlTracking_TrackClicks] DEFAULT ((1)),
[ModuleId] [int] NULL,
[NewWindow] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}UrlTracking_NewWindow] DEFAULT ((0))
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}UrlTracking] on {databaseOwner}[{objectQualifier}UrlTracking]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlTracking] ADD CONSTRAINT [PK_{objectQualifier}UrlTracking] PRIMARY KEY CLUSTERED  ([UrlTrackingID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUrlLog]'
GO

create procedure {databaseOwner}{objectQualifier}GetUrlLog

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetRole]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchSettings]'
GO

create procedure {databaseOwner}{objectQualifier}GetSearchSettings

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteDesktopModule]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteDesktopModule

@DesktopModuleId int

as

delete
from {objectQualifier}DesktopModules
where  DesktopModuleId = @DesktopModuleId








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Banners]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Banners]
(
[BannerId] [int] NOT NULL IDENTITY(1, 1),
[VendorId] [int] NOT NULL,
[ImageFile] [nvarchar] (100) NULL,
[BannerName] [nvarchar] (100) NOT NULL,
[Impressions] [int] NOT NULL,
[CPM] [float] NOT NULL,
[Views] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Banners_Views] DEFAULT ((0)),
[ClickThroughs] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Banners_ClickThroughs] DEFAULT ((0)),
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[CreatedByUser] [nvarchar] (100) NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[BannerTypeId] [int] NULL,
[Description] [nvarchar] (2000) NULL,
[GroupName] [nvarchar] (100) NULL,
[Criteria] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Banners_Criteria] DEFAULT ((1)),
[URL] [nvarchar] (255) NULL,
[Width] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Banners_Width] DEFAULT ((0)),
[Height] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Banners_Height] DEFAULT ((0))
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Banner] on {databaseOwner}[{objectQualifier}Banners]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Banners] ADD CONSTRAINT [PK_{objectQualifier}Banner] PRIMARY KEY CLUSTERED  ([BannerId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}Banners_1] on {databaseOwner}[{objectQualifier}Banners]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}Banners_1] ON {databaseOwner}[{objectQualifier}Banners] ([VendorId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_{objectQualifier}Banners] on {databaseOwner}[{objectQualifier}Banners]'
GO
CREATE NONCLUSTERED INDEX [IX_{objectQualifier}Banners] ON {databaseOwner}[{objectQualifier}Banners] ([BannerTypeId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddUrlTracking]'
GO

create procedure {databaseOwner}{objectQualifier}AddUrlTracking

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateTab]'
GO


CREATE procedure {databaseOwner}{objectQualifier}UpdateTab

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdatePortalInfo]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetRolesByUser]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateModule]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateModule

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Lists]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Lists]
(
[EntryID] [int] NOT NULL IDENTITY(1, 1),
[ListName] [nvarchar] (50) NOT NULL,
[Value] [nvarchar] (100) NOT NULL,
[Text] [nvarchar] (150) NOT NULL,
[ParentID] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Lists_ParentID] DEFAULT ((0)),
[Level_] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Lists_Level] DEFAULT ((0)),
[SortOrder] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Lists_SortOrder] DEFAULT ((0)),
[DefinitionID] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Lists_DefinitionID] DEFAULT ((0)),
[Description] [nvarchar] (500) NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Lists] on {databaseOwner}[{objectQualifier}Lists]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Lists] ADD CONSTRAINT [PK_{objectQualifier}Lists] PRIMARY KEY CLUSTERED  ([ListName], [Value], [Text], [ParentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}Folders]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Folders]
(
[FolderID] [int] NOT NULL IDENTITY(1, 1),
[PortalID] [int] NULL,
[FolderPath] [varchar] (300) NOT NULL,
[StorageLocation] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Folders_StorageLocation] DEFAULT ((0)),
[IsProtected] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Folders_IsProtected] DEFAULT ((0)),
[IsCached] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Folders_IsCached] DEFAULT ((0)),
[LastUpdated] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}Folders] on {databaseOwner}[{objectQualifier}Folders]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Folders] ADD CONSTRAINT [PK_{objectQualifier}Folders] PRIMARY KEY CLUSTERED  ([FolderID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateFolder]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateFolder

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetBanner]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetBanner

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUsersByRolename]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModuleControlsByKey]'
GO

create procedure {databaseOwner}{objectQualifier}GetModuleControlsByKey

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModuleDefinition]'
GO

create procedure {databaseOwner}{objectQualifier}GetModuleDefinition

@ModuleDefId int

as

select *
from {objectQualifier}ModuleDefinitions
where  ModuleDefId = @ModuleDefId









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetAffiliate]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}GetAffiliate
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteTabModule]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteTabModule

@TabId      int,
@ModuleId   int

as

delete
from   {objectQualifier}TabModules 
where  TabId = @TabId
and    ModuleId = @ModuleId








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}vw_TabPermissions]'
GO

CREATE VIEW {databaseOwner}[{objectQualifier}vw_TabPermissions]
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
FROM {objectQualifier}TabPermission AS TP 
	INNER JOIN {objectQualifier}Tabs AS T ON TP.TabID = T.TabID	
	LEFT OUTER JOIN {objectQualifier}Permission AS P ON TP.PermissionID = P.PermissionID 
	LEFT OUTER JOIN {objectQualifier}Roles AS R ON TP.RoleID = R.RoleID

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateTabModule]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateTabModule

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetScheduleNextTask]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetScheduleNextTask
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddUser]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUrlTracking]'
GO

create procedure {databaseOwner}{objectQualifier}GetUrlTracking

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortalByTab]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetPortalByTab

@TabId int,
@HTTPAlias nvarchar(200)
 
as

select HTTPAlias
from {databaseOwner}{objectQualifier}PortalAlias
inner join {databaseOwner}{objectQualifier}Tabs on {databaseOwner}{objectQualifier}PortalAlias.PortalId = {databaseOwner}{objectQualifier}Tabs.PortalId
where  TabId = @TabId
and    HTTPAlias = @HTTPAlias 









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetFileById]'
GO

create procedure {databaseOwner}{objectQualifier}GetFileById

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}VerifyPortal]'
GO

create procedure {databaseOwner}{objectQualifier}VerifyPortal

@PortalId int

as

select {objectQualifier}Tabs.TabId
from {objectQualifier}Tabs
inner join {objectQualifier}Portals on {objectQualifier}Tabs.PortalId = {objectQualifier}Portals.PortalId
where {objectQualifier}Portals.PortalId = @PortalId
and {objectQualifier}Tabs.TabOrder = 1  









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddVendor]'
GO

CREATE procedure {databaseOwner}{objectQualifier}AddVendor

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSiteLog9]'
GO

create procedure {databaseOwner}{objectQualifier}GetSiteLog9

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchResultModules]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetSearchResultModules

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteUserPortal]'
GO

CREATE procedure {databaseOwner}{objectQualifier}DeleteUserPortal
	@UserId   int,
	@PortalId int
AS

	DELETE FROM {objectQualifier}UserPortals
	WHERE Userid = @UserId and PortalId = @PortalId

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortalCount]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPortalCount]

AS
SELECT COUNT(*)
FROM {objectQualifier}Portals

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetBannerGroups]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetVendor]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetVendor

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddRole]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}HostSettings]'
GO
CREATE TABLE {databaseOwner}[{objectQualifier}HostSettings]
(
[SettingName] [nvarchar] (50) NOT NULL,
[SettingValue] [nvarchar] (256) NOT NULL,
[SettingIsSecure] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}HostSettings_Secure] DEFAULT ((0))
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_{objectQualifier}HostSettings] on {databaseOwner}[{objectQualifier}HostSettings]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}HostSettings] ADD CONSTRAINT [PK_{objectQualifier}HostSettings] PRIMARY KEY CLUSTERED  ([SettingName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetHostSettings]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetHostSettings
as
select SettingName,
       SettingValue,
       SettingIsSecure
from {objectQualifier}HostSettings



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}vw_FolderPermissions]'
GO

CREATE VIEW {databaseOwner}[{objectQualifier}vw_FolderPermissions]
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
FROM {objectQualifier}FolderPermission AS FP 
	LEFT OUTER JOIN {objectQualifier}Folders AS F ON FP.FolderID = F.FolderID 
	LEFT OUTER JOIN {objectQualifier}Permission AS P ON FP.PermissionID = P.PermissionID 
	LEFT OUTER JOIN {objectQualifier}Roles AS R ON FP.RoleID = R.RoleID


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModulePermissionsByPortal]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModulePermissionsByPortal]
	
	@PortalID int

AS
SELECT *
FROM {objectQualifier}vw_ModulePermissions MP
	INNER JOIN {objectQualifier}Modules AS M ON MP.ModuleID = M.ModuleID 
WHERE  M.PortalID = @PortalID

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetDesktopModulesByPortal]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}GetDesktopModulesByPortal

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetRoles]'
GO


create procedure {databaseOwner}{objectQualifier}GetRoles

as

select *
from   {databaseOwner}{objectQualifier}Roles









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddListEntry]'
GO

CREATE procedure {databaseOwner}{objectQualifier}AddListEntry

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
	SELECT @ParentID = [EntryID], @Level = ([Level_] + 1) From {objectQualifier}Lists Where [ListName] = @ParentListName And [Value] = @ParentValue

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
	[Level_],
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetRolesByGroup]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTabPermission]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabPermission]

	@TabPermissionID int

AS
SELECT *
FROM {objectQualifier}vw_TabPermissions
WHERE TabPermissionID = @TabPermissionID

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdatePortalSetup]'
GO

create procedure {databaseOwner}{objectQualifier}UpdatePortalSetup

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

update {objectQualifier}Portals
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddTab]'
GO


CREATE procedure {databaseOwner}{objectQualifier}AddTab

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetHostSetting]'
GO


create procedure {databaseOwner}{objectQualifier}GetHostSetting

@SettingName nvarchar(50)

as

select SettingValue
from {objectQualifier}HostSettings
where  SettingName = @SettingName










GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateAnonymousUser]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateAnonymousUser

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddTabModule]'
GO

create procedure {databaseOwner}{objectQualifier}AddTabModule
    
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPermissionsByModuleID]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}GetPermissionsByModuleID
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetOnlineUser]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateVendor]'
GO

CREATE procedure {databaseOwner}{objectQualifier}UpdateVendor

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModuleDefinitions]'
GO


CREATE procedure {databaseOwner}{objectQualifier}GetModuleDefinitions

@DesktopModuleId int

as

select *
from   {databaseOwner}{objectQualifier}ModuleDefinitions
where  DesktopModuleId = @DesktopModuleId or @DesktopModuleId = -1










GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}IsUserInRole]'
GO


create procedure {databaseOwner}{objectQualifier}IsUserInRole
    
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetFolderPermissionsByFolderPath]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortalDesktopModules]'
GO

create procedure {databaseOwner}{objectQualifier}GetPortalDesktopModules

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateHostSetting]'
GO

CREATE procedure {databaseOwner}{objectQualifier}UpdateHostSetting

@SettingName   nvarchar(50),
@SettingValue  nvarchar(256),
@SettingIsSecure bit

as

update {objectQualifier}HostSettings
set    SettingValue = @SettingValue, SettingIsSecure = @SettingIsSecure
where  SettingName = @SettingName



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateTabOrder]'
GO


create procedure {databaseOwner}{objectQualifier}UpdateTabOrder

@TabId    int,
@TabOrder int,
@Level    int,
@ParentId int

as

update {objectQualifier}Tabs
set    TabOrder = @TabOrder,
       Level_ = @Level,
       ParentId = @ParentId
where  TabId = @TabId










GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetAllFiles]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}FindBanners]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetFolderByFolderID]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetFolderByFolderID
	@PortalID int,
	@FolderID int
AS
SELECT *
	FROM {databaseOwner}{objectQualifier}Folders
	WHERE ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
		AND (FolderID = @FolderID)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteList]'
GO



CREATE procedure {databaseOwner}{objectQualifier}DeleteList

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUserRoles]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSuperUsers]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetSuperUsers

as

select U.*,
       'PortalId' = -1,
       'FullName' = U.FirstName + ' ' + U.LastName
from   {objectQualifier}Users U
where  U.IsSuperUser = 1







GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateDesktopModule]'
GO

CREATE  PROCEDURE {databaseOwner}{objectQualifier}UpdateDesktopModule

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetList]'
GO


CREATE procedure {databaseOwner}{objectQualifier}GetList
	@ListName nvarchar(50),
	@ParentKey nvarchar(150),
	@DefinitionID int
AS

If @ParentKey = '' 
Begin
	Select DISTINCT 	
	E.[ListName],
	E.[Level_],	
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
	Order By E.[Level_],[DisplayName]
End
Else
Begin

	DECLARE @ParentListName nvarchar(50)
	DECLARE @ParentValue nvarchar(100)
	SET @ParentListName = LEFT(@ParentKey, CHARINDEX( '.', @ParentKey) - 1)
	SET @ParentValue = RIGHT(@ParentKey, LEN(@ParentKey) -  CHARINDEX( '.', @ParentKey))
	Select DISTINCT 	
	E.[ListName],
	E.[Level_],	
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
	Order By E.[Level_], [DisplayName]

End

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetFile]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetFile

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetBanners]'
GO

create procedure {databaseOwner}{objectQualifier}GetBanners

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddModuleDefinition]'
GO

CREATE procedure {databaseOwner}{objectQualifier}AddModuleDefinition

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteModule]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteModule

@ModuleId   int

as

delete
from   {objectQualifier}Modules 
where  ModuleId = @ModuleId








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteUser]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteUser

@UserId   int

as

delete
from {objectQualifier}Users
where  UserId = @UserId


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateModuleDefinition]'
GO

CREATE procedure {databaseOwner}{objectQualifier}UpdateModuleDefinition

	@ModuleDefId int,    
	@FriendlyName    nvarchar(128),
	@DefaultCacheTime int

as

update {objectQualifier}ModuleDefinitions 
	SET FriendlyName = @FriendlyName,
		DefaultCacheTime = @DefaultCacheTime
	WHERE ModuleDefId = @ModuleDefId


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddHostSetting]'
GO

CREATE procedure {databaseOwner}{objectQualifier}AddHostSetting

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateRole]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetServices]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetServices
    
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetVendorsByEmail]'
GO


CREATE procedure {databaseOwner}{objectQualifier}GetVendorsByEmail
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetVendorsByName]'
GO


CREATE procedure {databaseOwner}{objectQualifier}GetVendorsByName
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetDesktopModule]'
GO

create procedure {databaseOwner}{objectQualifier}GetDesktopModule

@DesktopModuleId int

as

select *
from   {objectQualifier}DesktopModules
where  DesktopModuleId = @DesktopModuleId









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTabPanes]'
GO

create procedure {databaseOwner}{objectQualifier}GetTabPanes

@TabId    int

as

select distinct(PaneName) as PaneName
from   {objectQualifier}TabModules
where  TabId = @TabId
order by PaneName









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteUsersOnline]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteUsersOnline

	@TimeWindow	int
	
as
	-- Clean up the anonymous users table
	DELETE from {objectQualifier}AnonymousUsers WHERE LastActiveDate < DateAdd(minute, -@TimeWindow, GetDate())	

	-- Clean up the users online table
	DELETE from {objectQualifier}UsersOnline WHERE LastActiveDate < DateAdd(minute, -@TimeWindow, GetDate())	









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddFolder]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}AddFolder

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateListSortOrder]'
GO



CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateListSortOrder
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateUrlTracking]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateUrlTracking

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddModule]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}AddModule
    
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModulePermissionsByTabID]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModulePermissionsByTabID]
	
	@TabID int

AS
SELECT *
FROM {objectQualifier}vw_ModulePermissions MP
	INNER JOIN {objectQualifier}TabModules TM on MP.ModuleID = TM.ModuleID
WHERE  TM.TabID = @TabID

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateBannerViews]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateBannerViews

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateListEntry]'
GO



CREATE PROCEDURE {databaseOwner}{objectQualifier}UpdateListEntry

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetDesktopModuleByFriendlyName]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetDesktopModuleByFriendlyName

	@FriendlyName    nvarchar(128)

as

select *
from   {objectQualifier}DesktopModules
where  FriendlyName = @FriendlyName



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateBannerClickThrough]'
GO


create procedure {databaseOwner}{objectQualifier}UpdateBannerClickThrough

@BannerId int,
@VendorId int

as

update {objectQualifier}Banners
set    ClickThroughs = ClickThroughs + 1
where  BannerId = @BannerId
and    VendorId = @VendorId









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeletePortalInfo]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTabPermissionsByPortal]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabPermissionsByPortal]
	
	@PortalID int

AS
SELECT *
FROM {objectQualifier}vw_TabPermissions TP
WHERE 	PortalID = @PortalID OR (PortalId IS NULL AND @PortalId IS NULL)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetFiles]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTabModuleOrder]'
GO

create procedure {databaseOwner}{objectQualifier}GetTabModuleOrder

@TabId    int, 
@PaneName nvarchar(50)

as

select *
from   {objectQualifier}TabModules 
where  TabId = @TabId 
and    PaneName = @PaneName
order by ModuleOrder









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateUser]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}VerifyPortalTab]'
GO

create procedure {databaseOwner}{objectQualifier}VerifyPortalTab

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteFolder]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteFolder
	@PortalID int,
	@FolderPath varchar(300)
AS
	DELETE FROM {objectQualifier}Folders
	WHERE ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
	AND FolderPath = @FolderPath







GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateOnlineUser]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateOnlineUser

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUsers]'
GO

create procedure {databaseOwner}{objectQualifier}GetUsers

@PortalId int

as

select *
from {objectQualifier}Users U
left join {objectQualifier}UserPortals UP on U.UserId = UP.UserId
where ( UP.PortalId = @PortalId or @PortalId is null )
order by U.FirstName + ' ' + U.LastName   







GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetListEntries]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetListEntries

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
	E.[Level_],
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
	Order By E.[Level_], E.[ListName], E.[SortOrder], E.[Text]
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
	E.[Level_],
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
	Order By E.[Level_], E.[ListName], E.[SortOrder], E.[Text]

End








GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteBanner]'
GO


create procedure {databaseOwner}{objectQualifier}DeleteBanner

@BannerId int

as

delete
from {objectQualifier}Banners
where  BannerId = @BannerId










GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetVendors]'
GO


CREATE procedure {databaseOwner}{objectQualifier}GetVendors
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteListEntryByID]'
GO



CREATE procedure {databaseOwner}{objectQualifier}DeleteListEntryByID

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddPortalInfo]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddDesktopModule]'
GO


CREATE PROCEDURE {databaseOwner}{objectQualifier}AddDesktopModule
    
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetFolderByFolderPath]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetFolderByFolderPath
	@PortalID int,
	@FolderPath nvarchar(300)
AS
SELECT *
	FROM {databaseOwner}{objectQualifier}Folders
	WHERE ((PortalID = @PortalID) or (PortalID is null and @PortalID is null))
		AND (FolderPath = @FolderPath)
	ORDER BY FolderPath

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateUrlTrackingStats]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateUrlTrackingStats

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModuleDefinitionByName]'
GO

create procedure {databaseOwner}{objectQualifier}GetModuleDefinitionByName

@DesktopModuleId int,    
@FriendlyName    nvarchar(128)

as

select *
from   {objectQualifier}ModuleDefinitions
where  DesktopModuleId = @DesktopModuleId
and    FriendlyName = @FriendlyName



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}UpdateBanner]'
GO

create procedure {databaseOwner}{objectQualifier}UpdateBanner

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddBanner]'
GO


create procedure {databaseOwner}{objectQualifier}AddBanner

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModulePermissionsByModuleID]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteTab]'
GO


create procedure {databaseOwner}{objectQualifier}DeleteTab

@TabId int

as

delete
from {objectQualifier}Tabs
where  TabId = @TabId









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetFolderPermission]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetFolderPermission]
	
	@FolderPermissionID int

AS
SELECT *
FROM {objectQualifier}vw_FolderPermissions
WHERE FolderPermissionID = @FolderPermissionID

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModulePermission]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModulePermission]
	
	@ModulePermissionID int

AS
SELECT *
FROM {objectQualifier}vw_ModulePermissions
WHERE ModulePermissionID = @ModulePermissionID

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteUrlTracking]'
GO

create procedure {databaseOwner}{objectQualifier}DeleteUrlTracking

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetRoleByName]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetFolders]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchModules]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetSearchModules

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}vw_Tabs]'
GO

CREATE VIEW {databaseOwner}[{objectQualifier}vw_Tabs]
AS
SELECT     
	T.TabID, 
	T.TabOrder, 
	T.PortalID, 
	T.TabName, 
	T.IsVisible, 
	T.ParentId, 
	T.[Level_],
	CASE WHEN LEFT(LOWER(T.IconFile), 6) = 'fileid' 
		THEN
			(SELECT Folder + FileName  
				FROM {objectQualifier}Files 
				WHERE 'fileid=' + convert(varchar,{objectQualifier}Files.FileID) = T.IconFile
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
    CASE WHEN EXISTS (SELECT 1 FROM {objectQualifier}Tabs T2 WHERE T2.ParentId = T .TabId) THEN 'true' ELSE 'false' END AS 'HasChildren', 
    T.RefreshInterval, 
    T.PageHeadText
FROM {databaseOwner}{objectQualifier}Tabs AS T 


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetAllTabs]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetAllTabs]

AS
SELECT *
FROM   {objectQualifier}vw_Tabs
ORDER BY TabOrder, TabName

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUserRole]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}AddDefaultPropertyDefinitions]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSiteLog2]'
GO

create procedure {databaseOwner}{objectQualifier}GetSiteLog2

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}vw_Users]'
GO

CREATE VIEW {databaseOwner}[{objectQualifier}vw_Users]
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
FROM {objectQualifier}Users U
	LEFT OUTER JOIN {objectQualifier}UserPortals UP On U.UserId = UP.UserId

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUsersByUserName]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}vw_Modules]'
GO

CREATE VIEW {databaseOwner}[{objectQualifier}vw_Modules]
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
					FROM {objectQualifier}Files 
					WHERE 'fileid=' + convert(varchar,{objectQualifier}Files.FileID) = TM.IconFile
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
FROM   {objectQualifier}ModuleDefinitions AS MD 
	INNER JOIN {objectQualifier}Modules AS M ON MD.ModuleDefID = M.ModuleDefID 
	INNER JOIN {objectQualifier}DesktopModules AS DM ON MD.DesktopModuleID = DM.DesktopModuleID 
	INNER JOIN {objectQualifier}ModuleControls AS MC ON MD.ModuleDefID = MC.ModuleDefID 
	LEFT OUTER JOIN {objectQualifier}Tabs AS T 
		INNER JOIN {objectQualifier}TabModules AS TM ON T.TabID = TM.TabID 
	ON M.ModuleID = TM.ModuleID
WHERE     (MC.ControlKey IS NULL)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModule]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}vw_Portals]'
GO

CREATE VIEW {databaseOwner}[{objectQualifier}vw_Portals]
AS
SELECT     
	PortalID, 
	PortalName, 
	CASE WHEN LEFT(LOWER(LogoFile), 6) = 'fileid' 
		THEN
			(SELECT Folder + FileName  
				FROM {objectQualifier}Files 
				WHERE 'fileid=' + convert(varchar,{objectQualifier}Files.FileID) = LogoFile
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
				FROM {objectQualifier}Files 
				WHERE 'fileid=' + convert(varchar,{objectQualifier}Files.FileID) = BackgroundFile
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
    (SELECT TabID FROM {objectQualifier}Tabs WHERE (PortalID IS NULL) AND (ParentId IS NULL)) AS SuperTabId,
	(SELECT RoleName FROM {objectQualifier}Roles WHERE (RoleID = P.AdministratorRoleId)) AS AdministratorRoleName,
	(SELECT RoleName FROM {objectQualifier}Roles WHERE (RoleID = P.RegisteredRoleId)) AS RegisteredRoleName
FROM {objectQualifier}Portals AS P
LEFT OUTER JOIN {objectQualifier}Users AS U ON P.AdministratorId = U.UserID

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetExpiredPortals]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetExpiredPortals]

AS
SELECT * FROM {objectQualifier}vw_Portals
WHERE ExpiryDate < getDate()

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}DeleteFolderPermissionsByFolderPath]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}DeleteFolderPermissionsByFolderPath
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUsersByProfileProperty]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUsersByEmail]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortals]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPortals]

AS
SELECT *
FROM {objectQualifier}vw_Portals
ORDER BY PortalName

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUser]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUser]

	@PortalId int,
	@UserId int

AS
SELECT * FROM {objectQualifier}vw_Users U
WHERE  UserId = @UserId
	AND    (PortalId = @PortalId or IsSuperUser = 1)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchItems]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetSearchItems

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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetSearchResults]'
GO

CREATE procedure {databaseOwner}{objectQualifier}GetSearchResults
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModules]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetModules]

	@PortalId int
	
AS
SELECT	* 
FROM {objectQualifier}vw_Modules
WHERE  PortalId = @PortalId
ORDER BY ModuleId


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortalRoles]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTabsByParentId]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabsByParentId]

@ParentId int

AS
SELECT *
FROM   {objectQualifier}vw_Tabs
WHERE  ParentId = @ParentId
ORDER BY TabOrder

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetFoldersByUser]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetFoldersByUser
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetAllUsers]'
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
		ORDER BY AccountNumber, Username

    SELECT  *
    FROM	{objectQualifier}vw_Users u, 
			#PageIndexForUsers p
    WHERE  u.UserId = p.UserId 
		AND (PortalId = @PortalId OR (PortalId Is Null AND @PortalId is null ))
        AND p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
	ORDER BY AccountNumber, Username

    SELECT  TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortalByPortalAliasID]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPortalByPortalAliasID]

	@PortalAliasId  int

AS
SELECT P.*
FROM {objectQualifier}vw_Portals P
	INNER JOIN {objectQualifier}PortalAlias PA ON P.PortalID = PA.PortalID
WHERE PA.PortalAliasId = @PortalAliasId

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetOnlineUsers]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetOnlineUsers
	@PortalID int

AS
SELECT 
	*
	FROM {objectQualifier}UsersOnline UO
		INNER JOIN {objectQualifier}vw_Users U ON UO.UserID = U.UserID 
		INNER JOIN {objectQualifier}UserPortals UP ON U.UserID = UP.UserId
	WHERE  UP.PortalID = @PortalID

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUserCountByPortal]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUserCountByPortal]

	@PortalId int

AS

	SELECT COUNT(*) FROM {objectQualifier}vw_Users 
		WHERE PortalID = @PortalID


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTabs]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabs]

@PortalId int

AS
SELECT *
FROM   {objectQualifier}vw_Tabs
WHERE  PortalId = @PortalId OR (PortalID IS NULL AND @PortalID IS NULL)
ORDER BY TabOrder, TabName

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTab]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTab]

@TabId    int

AS
SELECT *
FROM   {objectQualifier}vw_Tabs
WHERE  TabId = @TabId

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTabModules]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetTabModules]

	@TabId int

AS
SELECT	* 
FROM {objectQualifier}vw_Modules
WHERE  TabId = @TabId
ORDER BY ModuleOrder


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortalsByName]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetPortal]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetPortal]

	@PortalId  int

AS
SELECT *
FROM {objectQualifier}vw_Portals
WHERE PortalId = @PortalId

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUnAuthorizedUsers]'
GO

CREATE PROCEDURE {databaseOwner}{objectQualifier}GetUnAuthorizedUsers
    @PortalId			int
AS

SELECT  *
FROM	{objectQualifier}vw_Users
WHERE  PortalId = @PortalId
	AND Authorised = 0
ORDER BY UserName

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetAllTabsModules]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetUserByUsername]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetUserByUsername]

	@PortalId int,
	@Username nvarchar(100)

AS
SELECT * FROM {objectQualifier}vw_Users
WHERE  Username = @Username
	AND    (PortalId = @PortalId OR IsSuperUser = 1 OR @PortalId is null)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetAllModules]'
GO

CREATE PROCEDURE {databaseOwner}[{objectQualifier}GetAllModules]

AS
SELECT	* 
FROM {objectQualifier}vw_Modules


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTabByName]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetModuleByDefinition]'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetCurrencies]'
GO


create procedure {databaseOwner}{objectQualifier}GetCurrencies

as

select Code,
       Description
from {objectQualifier}CodeCurrency






GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating {databaseOwner}[{objectQualifier}GetTables]'
GO

create procedure {databaseOwner}{objectQualifier}GetTables

as

/* Be carefull when changing this procedure as the GetSearchTables() function 
   in SearchDB.vb is only looking at the first column (to support databases that cannot return 
   a TableName column name (like MySQL))
*/

select 'TableName' = [name]
from   sysobjects 
where  xtype = 'U' 









GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}Version]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Version] ADD CONSTRAINT [IX_{objectQualifier}Version] UNIQUE NONCLUSTERED  ([Major], [Minor], [Build])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}TabModules]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules] ADD CONSTRAINT [IX_{objectQualifier}TabModules] UNIQUE NONCLUSTERED  ([TabID], [ModuleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}PortalDesktopModules]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules] ADD CONSTRAINT [IX_{objectQualifier}PortalDesktopModules] UNIQUE NONCLUSTERED  ([PortalID], [DesktopModuleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}Urls]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Urls] ADD CONSTRAINT [IX_{objectQualifier}Urls] UNIQUE NONCLUSTERED  ([Url], [PortalID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}Users]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Users] ADD CONSTRAINT [IX_{objectQualifier}Users] UNIQUE NONCLUSTERED  ([Username])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}DesktopModules]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}DesktopModules] ADD CONSTRAINT [IX_{objectQualifier}DesktopModules_ModuleName] UNIQUE NONCLUSTERED  ([ModuleName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}ModuleDefinitions]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleDefinitions] ADD CONSTRAINT [IX_{objectQualifier}ModuleDefinitions] UNIQUE NONCLUSTERED  ([FriendlyName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}SearchWord]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchWord] ADD CONSTRAINT [IX_{objectQualifier}SearchWord] UNIQUE NONCLUSTERED  ([Word])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}SystemMessages]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SystemMessages] ADD CONSTRAINT [IX_{objectQualifier}SystemMessages] UNIQUE NONCLUSTERED  ([MessageName], [PortalID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}PortalAlias]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalAlias] ADD CONSTRAINT [IX_{objectQualifier}PortalAlias] UNIQUE NONCLUSTERED  ([HTTPAlias])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}RoleGroups]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}RoleGroups] ADD CONSTRAINT [IX_{objectQualifier}RoleGroupName] UNIQUE NONCLUSTERED  ([PortalID], [RoleGroupName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}Vendors]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Vendors] ADD CONSTRAINT [IX_{objectQualifier}Vendors] UNIQUE NONCLUSTERED  ([PortalId], [VendorName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}UrlTracking]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlTracking] ADD CONSTRAINT [IX_{objectQualifier}UrlTracking] UNIQUE NONCLUSTERED  ([PortalID], [Url], [ModuleId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}Roles]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Roles] ADD CONSTRAINT [IX_{objectQualifier}RoleName] UNIQUE NONCLUSTERED  ([PortalID], [RoleName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}ModuleControls]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleControls] ADD CONSTRAINT [IX_{objectQualifier}ModuleControls] UNIQUE NONCLUSTERED  ([ModuleDefID], [ControlKey], [ControlSrc])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}SearchItemWord]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWord] ADD CONSTRAINT [IX_{objectQualifier}SearchItemWord] UNIQUE NONCLUSTERED  ([SearchItemID], [SearchWordsID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to {databaseOwner}[{objectQualifier}VendorClassification]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}VendorClassification] ADD CONSTRAINT [IX_{objectQualifier}VendorClassification] UNIQUE NONCLUSTERED  ([VendorId], [ClassificationId])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}TabModuleSettings]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModuleSettings] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}TabModuleSettings_{objectQualifier}TabModules] FOREIGN KEY ([TabModuleID]) REFERENCES {databaseOwner}[{objectQualifier}TabModules] ([TabModuleID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Roles]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Roles] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}Roles_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}UserRoles]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserRoles] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}UserRoles_{objectQualifier}Roles] FOREIGN KEY ([RoleID]) REFERENCES {databaseOwner}[{objectQualifier}Roles] ([RoleID]) ON DELETE CASCADE NOT FOR REPLICATION,
CONSTRAINT [FK_{objectQualifier}UserRoles_{objectQualifier}Users] FOREIGN KEY ([UserID]) REFERENCES {databaseOwner}[{objectQualifier}Users] ([UserID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Profile]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Profile] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}Profile_{objectQualifier}Portals] FOREIGN KEY ([PortalId]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION,
CONSTRAINT [FK_{objectQualifier}Profile_{objectQualifier}Users] FOREIGN KEY ([UserId]) REFERENCES {databaseOwner}[{objectQualifier}Users] ([UserID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}UrlTracking]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlTracking] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}UrlTracking_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Tabs]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}Tabs_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION,
CONSTRAINT [FK_{objectQualifier}Tabs_{objectQualifier}Tabs] FOREIGN KEY ([ParentId]) REFERENCES {databaseOwner}[{objectQualifier}Tabs] ([TabID]) NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Affiliates]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Affiliates] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}Affiliates_{objectQualifier}Vendors] FOREIGN KEY ([VendorId]) REFERENCES {databaseOwner}[{objectQualifier}Vendors] ([VendorId]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Classification]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Classification] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}Classification_{objectQualifier}Classification] FOREIGN KEY ([ParentId]) REFERENCES {databaseOwner}[{objectQualifier}Classification] ([ClassificationId]) NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}RoleGroups]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}RoleGroups] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}RoleGroups_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Vendors]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Vendors] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}Vendor_{objectQualifier}Portals] FOREIGN KEY ([PortalId]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}SearchItemWordPosition]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWordPosition] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}SearchItemWordPosition_{objectQualifier}SearchItemWord] FOREIGN KEY ([SearchItemWordID]) REFERENCES {databaseOwner}[{objectQualifier}SearchItemWord] ([SearchItemWordID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}SearchItemWord]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWord] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}SearchItemWord_{objectQualifier}SearchWord] FOREIGN KEY ([SearchWordsID]) REFERENCES {databaseOwner}[{objectQualifier}SearchWord] ([SearchWordsID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}UrlLog]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlLog] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}UrlLog_{objectQualifier}UrlTracking] FOREIGN KEY ([UrlTrackingID]) REFERENCES {databaseOwner}[{objectQualifier}UrlTracking] ([UrlTrackingID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}ModuleSettings]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleSettings] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}ModuleSettings_{objectQualifier}Modules] FOREIGN KEY ([ModuleID]) REFERENCES {databaseOwner}[{objectQualifier}Modules] ([ModuleID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Skins]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Skins] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}Skins_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}SystemMessages]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SystemMessages] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}SystemMessages_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}PortalDesktopModules]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}PortalDesktopModules_{objectQualifier}DesktopModules] FOREIGN KEY ([DesktopModuleID]) REFERENCES {databaseOwner}[{objectQualifier}DesktopModules] ([DesktopModuleID]) ON DELETE CASCADE NOT FOR REPLICATION,
CONSTRAINT [FK_{objectQualifier}PortalDesktopModules_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}TabModules]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}TabModules_{objectQualifier}Modules] FOREIGN KEY ([ModuleID]) REFERENCES {databaseOwner}[{objectQualifier}Modules] ([ModuleID]) ON DELETE CASCADE NOT FOR REPLICATION,
CONSTRAINT [FK_{objectQualifier}TabModules_{objectQualifier}Tabs] FOREIGN KEY ([TabID]) REFERENCES {databaseOwner}[{objectQualifier}Tabs] ([TabID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Modules]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Modules] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}Modules_{objectQualifier}ModuleDefinitions] FOREIGN KEY ([ModuleDefID]) REFERENCES {databaseOwner}[{objectQualifier}ModuleDefinitions] ([ModuleDefID]) ON DELETE CASCADE NOT FOR REPLICATION,
CONSTRAINT [FK_{objectQualifier}Modules_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}UserPortals]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserPortals] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}UserPortals_{objectQualifier}Portals] FOREIGN KEY ([PortalId]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION,
CONSTRAINT [FK_{objectQualifier}UserPortals_{objectQualifier}Users] FOREIGN KEY ([UserId]) REFERENCES {databaseOwner}[{objectQualifier}Users] ([UserID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}UserProfile]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserProfile] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}UserProfile_{objectQualifier}ProfilePropertyDefinition] FOREIGN KEY ([PropertyDefinitionID]) REFERENCES {databaseOwner}[{objectQualifier}ProfilePropertyDefinition] ([PropertyDefinitionID]) ON DELETE CASCADE,
CONSTRAINT [FK_{objectQualifier}UserProfile_{objectQualifier}Users] FOREIGN KEY ([UserID]) REFERENCES {databaseOwner}[{objectQualifier}Users] ([UserID]) ON DELETE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}UsersOnline]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UsersOnline] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}UsersOnline_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION,
CONSTRAINT [FK_{objectQualifier}UsersOnline_{objectQualifier}Users] FOREIGN KEY ([UserID]) REFERENCES {databaseOwner}[{objectQualifier}Users] ([UserID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}ModuleControls]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleControls] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}ModuleControls_{objectQualifier}ModuleDefinitions] FOREIGN KEY ([ModuleDefID]) REFERENCES {databaseOwner}[{objectQualifier}ModuleDefinitions] ([ModuleDefID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}TabPermission]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabPermission] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}TabPermission_{objectQualifier}Permission] FOREIGN KEY ([PermissionID]) REFERENCES {databaseOwner}[{objectQualifier}Permission] ([PermissionID]) ON DELETE CASCADE,
CONSTRAINT [FK_{objectQualifier}TabPermission_{objectQualifier}Tabs] FOREIGN KEY ([TabID]) REFERENCES {databaseOwner}[{objectQualifier}Tabs] ([TabID]) ON DELETE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}ModuleDefinitions]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleDefinitions] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}ModuleDefinitions_{objectQualifier}DesktopModules] FOREIGN KEY ([DesktopModuleID]) REFERENCES {databaseOwner}[{objectQualifier}DesktopModules] ([DesktopModuleID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Urls]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Urls] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}Urls_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Files]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Files] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}Files_{objectQualifier}Portals] FOREIGN KEY ([PortalId]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}ScheduleHistory]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ScheduleHistory] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}ScheduleHistory_{objectQualifier}Schedule] FOREIGN KEY ([ScheduleID]) REFERENCES {databaseOwner}[{objectQualifier}Schedule] ([ScheduleID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}VendorClassification]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}VendorClassification] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}VendorClassification_{objectQualifier}Classification] FOREIGN KEY ([ClassificationId]) REFERENCES {databaseOwner}[{objectQualifier}Classification] ([ClassificationId]) ON DELETE CASCADE NOT FOR REPLICATION,
CONSTRAINT [FK_{objectQualifier}VendorClassification_{objectQualifier}Vendors] FOREIGN KEY ([VendorId]) REFERENCES {databaseOwner}[{objectQualifier}Vendors] ([VendorId]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}SiteLog]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SiteLog] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}SiteLog_{objectQualifier}Portals] FOREIGN KEY ([PortalId]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}SearchItem]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItem] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}SearchItem_{objectQualifier}Modules] FOREIGN KEY ([ModuleId]) REFERENCES {databaseOwner}[{objectQualifier}Modules] ([ModuleID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Banners]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Banners] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}Banner_{objectQualifier}Vendor] FOREIGN KEY ([VendorId]) REFERENCES {databaseOwner}[{objectQualifier}Vendors] ([VendorId]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}ScheduleItemSettings]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ScheduleItemSettings] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}ScheduleItemSettings_{objectQualifier}Schedule] FOREIGN KEY ([ScheduleID]) REFERENCES {databaseOwner}[{objectQualifier}Schedule] ([ScheduleID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}AnonymousUsers]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}AnonymousUsers] WITH NOCHECK ADD
CONSTRAINT [FK_{objectQualifier}AnonymousUsers_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}EventLog]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}EventLog] ADD
CONSTRAINT [FK_{objectQualifier}EventLog_{objectQualifier}EventLogTypes] FOREIGN KEY ([LogTypeKey]) REFERENCES {databaseOwner}[{objectQualifier}EventLogTypes] ([LogTypeKey]),
CONSTRAINT [FK_{objectQualifier}EventLog_{objectQualifier}EventLogConfig] FOREIGN KEY ([LogConfigID]) REFERENCES {databaseOwner}[{objectQualifier}EventLogConfig] ([ID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}EventLogConfig]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}EventLogConfig] ADD
CONSTRAINT [FK_{objectQualifier}EventLogConfig_{objectQualifier}EventLogTypes] FOREIGN KEY ([LogTypeKey]) REFERENCES {databaseOwner}[{objectQualifier}EventLogTypes] ([LogTypeKey])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Folders]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Folders] ADD
CONSTRAINT [FK_{objectQualifier}Folders_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}ModulePermission]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModulePermission] ADD
CONSTRAINT [FK_{objectQualifier}ModulePermission_{objectQualifier}Modules] FOREIGN KEY ([ModuleID]) REFERENCES {databaseOwner}[{objectQualifier}Modules] ([ModuleID]) ON DELETE CASCADE,
CONSTRAINT [FK_{objectQualifier}ModulePermission_{objectQualifier}Permission] FOREIGN KEY ([PermissionID]) REFERENCES {databaseOwner}[{objectQualifier}Permission] ([PermissionID]) ON DELETE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}SearchItemWord]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWord] ADD
CONSTRAINT [FK_{objectQualifier}SearchItemWord_{objectQualifier}SearchItem] FOREIGN KEY ([SearchItemID]) REFERENCES {databaseOwner}[{objectQualifier}SearchItem] ([SearchItemID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}PortalAlias]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalAlias] ADD
CONSTRAINT [FK_{objectQualifier}PortalAlias_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Roles]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Roles] ADD
CONSTRAINT [FK_{objectQualifier}Roles_{objectQualifier}RoleGroups] FOREIGN KEY ([RoleGroupID]) REFERENCES {databaseOwner}[{objectQualifier}RoleGroups] ([RoleGroupID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}Files]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Files] ADD
CONSTRAINT [FK_{objectQualifier}Files_{objectQualifier}Folders] FOREIGN KEY ([FolderID]) REFERENCES {databaseOwner}[{objectQualifier}Folders] ([FolderID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}ProfilePropertyDefinition]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ProfilePropertyDefinition] ADD
CONSTRAINT [FK_{objectQualifier}ProfilePropertyDefinition_{objectQualifier}Portals] FOREIGN KEY ([PortalID]) REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID]) ON DELETE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to {databaseOwner}[{objectQualifier}FolderPermission]'
GO
ALTER TABLE {databaseOwner}[{objectQualifier}FolderPermission] ADD
CONSTRAINT [FK_{objectQualifier}FolderPermission_{objectQualifier}Folders] FOREIGN KEY ([FolderID]) REFERENCES {databaseOwner}[{objectQualifier}Folders] ([FolderID]) ON DELETE CASCADE,
CONSTRAINT [FK_{objectQualifier}FolderPermission_{objectQualifier}Permission] FOREIGN KEY ([PermissionID]) REFERENCES {databaseOwner}[{objectQualifier}Permission] ([PermissionID]) ON DELETE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering permissions on {databaseOwner}[{objectQualifier}fn_GetVersion]'
GO
GRANT EXECUTE ON  {databaseOwner}[{objectQualifier}fn_GetVersion] TO [public]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering permissions on {databaseOwner}[{objectQualifier}GetProfilePropertyDefinitionID]'
GO
GRANT EXECUTE ON  {databaseOwner}[{objectQualifier}GetProfilePropertyDefinitionID] TO [public]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering permissions on {databaseOwner}[{objectQualifier}GetProfileElement]'
GO
GRANT EXECUTE ON  {databaseOwner}[{objectQualifier}GetProfileElement] TO [public]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering permissions on {databaseOwner}[{objectQualifier}GetElement]'
GO
GRANT EXECUTE ON  {databaseOwner}[{objectQualifier}GetElement] TO [public]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO tempErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering permissions on {databaseOwner}[{objectQualifier}AddDefaultPropertyDefinitions]'
GO
GRANT EXECUTE ON  {databaseOwner}[{objectQualifier}AddDefaultPropertyDefinitions] TO [public]

DROP TABLE tempErrors
GO
