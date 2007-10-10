/****** Object:  Table {databaseOwner}[{objectQualifier}Questions]    Script Date: 10/07/2007 07:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Questions](
	[QuestionId] [int] NOT NULL,
	[Question] [nvarchar](1000) NULL,
	[Locale] [nvarchar](50) NULL,
 CONSTRAINT [PK_{objectQualifier}Questions] PRIMARY KEY CLUSTERED 
(
	[QuestionId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Schedule]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Schedule](
	[ScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[TypeFullName] [varchar](200) NOT NULL,
	[TimeLapse] [int] NOT NULL,
	[TimeLapseMeasurement] [varchar](2) NOT NULL,
	[RetryTimeLapse] [int] NOT NULL,
	[RetryTimeLapseMeasurement] [varchar](2) NOT NULL,
	[RetainHistoryNum] [int] NOT NULL,
	[AttachToEvent] [varchar](50) NOT NULL,
	[CatchUpEnabled] [bit] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[ObjectDependencies] [varchar](300) NOT NULL,
	[Servers] [nvarchar](150) NULL,
 CONSTRAINT [PK_{objectQualifier}Schedule] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Version]    Script Date: 10/05/2007 21:16:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Version](
	[VersionId] [int] IDENTITY(1,1) NOT NULL,
	[Major] [int] NOT NULL,
	[Minor] [int] NOT NULL,
	[Build] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}Version] PRIMARY KEY CLUSTERED 
(
	[VersionId] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}Version] UNIQUE NONCLUSTERED 
(
	[Major] ASC,
	[Minor] ASC,
	[Build] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Classification]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Classification](
	[ClassificationId] [int] IDENTITY(1,1) NOT NULL,
	[ClassificationName] [nvarchar](200) NOT NULL,
	[ParentId] [int] NULL,
 CONSTRAINT [PK_{objectQualifier}VendorCategory] PRIMARY KEY CLUSTERED 
(
	[ClassificationId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}SearchIndexer]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SearchIndexer](
	[SearchIndexerID] [int] IDENTITY(1,1) NOT NULL,
	[SearchIndexerAssemblyQualifiedName] [char](200) NOT NULL,
 CONSTRAINT [PK_{objectQualifier}SearchIndexer] PRIMARY KEY CLUSTERED 
(
	[SearchIndexerID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}EventLogTypes]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}EventLogTypes](
	[LogTypeKey] [nvarchar](35) NOT NULL,
	[LogTypeFriendlyName] [nvarchar](50) NOT NULL,
	[LogTypeDescription] [nvarchar](128) NOT NULL,
	[LogTypeOwner] [nvarchar](100) NOT NULL,
	[LogTypeCSSClass] [nvarchar](40) NOT NULL,
 CONSTRAINT [PK_EventLogTypes] PRIMARY KEY CLUSTERED 
(
	[LogTypeKey] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}SearchCommonWords]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SearchCommonWords](
	[CommonWordID] [int] IDENTITY(1,1) NOT NULL,
	[CommonWord] [nvarchar](255) NOT NULL,
	[Locale] [nvarchar](10) NULL,
 CONSTRAINT [PK_{objectQualifier}SearchCommonWords] PRIMARY KEY CLUSTERED 
(
	[CommonWordID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Lists]    Script Date: 10/05/2007 21:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Lists](
	[EntryID] [int] IDENTITY(1,1) NOT NULL,
	[ListName] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](100) NOT NULL,
	[Text] [nvarchar](150) NOT NULL,
	[ParentID] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Lists_ParentID]  DEFAULT ((0)),
	[Level] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Lists_Level]  DEFAULT ((0)),
	[SortOrder] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Lists_SortOrder]  DEFAULT ((0)),
	[DefinitionID] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Lists_DefinitionID]  DEFAULT ((0)),
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_{objectQualifier}Lists] PRIMARY KEY CLUSTERED 
(
	[ListName] ASC,
	[Value] ASC,
	[Text] ASC,
	[ParentID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}SearchWord]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SearchWord](
	[SearchWordsID] [int] IDENTITY(1,1) NOT NULL,
	[Word] [nvarchar](100) NOT NULL,
	[IsCommon] [bit] NULL,
	[HitCount] [int] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}SearchWord] PRIMARY KEY CLUSTERED 
(
	[SearchWordsID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}SearchWord] UNIQUE NONCLUSTERED 
(
	[Word] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}HostSettings]    Script Date: 10/05/2007 21:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}HostSettings](
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](256) NOT NULL,
	[SettingIsSecure] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}HostSettings_Secure]  DEFAULT ((0)),
 CONSTRAINT [PK_{objectQualifier}HostSettings] PRIMARY KEY CLUSTERED 
(
	[SettingName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Portals](
	[PortalID] [int] IDENTITY(0,1) NOT NULL,
	[PortalName] [nvarchar](128) NOT NULL,
	[LogoFile] [nvarchar](50) NULL,
	[FooterText] [nvarchar](100) NULL,
	[ExpiryDate] [datetime] NULL,
	[UserRegistration] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_UserRegistration]  DEFAULT ((0)),
	[BannerAdvertising] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_BannerAdvertising]  DEFAULT ((0)),
	[AdministratorId] [int] NULL,
	[Currency] [char](3) NULL,
	[HostFee] [money] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_HostFee]  DEFAULT ((0)),
	[HostSpace] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_HostSpace]  DEFAULT ((0)),
	[AdministratorRoleId] [int] NULL,
	[RegisteredRoleId] [int] NULL,
	[Description] [nvarchar](500) NULL,
	[KeyWords] [nvarchar](500) NULL,
	[BackgroundFile] [nvarchar](50) NULL,
	[GUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_GUID]  DEFAULT (newid()),
	[PaymentProcessor] [nvarchar](50) NULL,
	[ProcessorUserId] [nvarchar](50) NULL,
	[ProcessorPassword] [nvarchar](50) NULL,
	[SiteLogHistory] [int] NULL,
	[HomeTabId] [int] NULL,
	[LoginTabId] [int] NULL,
	[UserTabId] [int] NULL,
	[DefaultLanguage] [nvarchar](10) NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_DefaultLanguage]  DEFAULT ('en-US'),
	[TimezoneOffset] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_TimezoneOffset]  DEFAULT ((-8)),
	[AdminTabId] [int] NULL,
	[HomeDirectory] [varchar](100) NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_HomeDirectory]  DEFAULT (''),
	[SplashTabId] [int] NULL,
	[PageQuota] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_PageQuota]  DEFAULT ((0)),
	[UserQuota] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Portals_UserQuota]  DEFAULT ((0)),
	[PowerUserRoleId] [int] NULL
 CONSTRAINT [PK_{objectQualifier}Portals] PRIMARY KEY NONCLUSTERED 
(
	[PortalID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Permission]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Permission](
	[PermissionID] [int] IDENTITY(1,1) NOT NULL,
	[PermissionCode] [varchar](50) NOT NULL,
	[ModuleDefID] [int] NOT NULL,
	[PermissionKey] [varchar](20) NOT NULL,
	[PermissionName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_{objectQualifier}Permission] PRIMARY KEY CLUSTERED 
(
	[PermissionID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}DesktopModules]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}DesktopModules](
	[DesktopModuleID] [int] IDENTITY(1,1) NOT NULL,
	[FriendlyName] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](2000) NULL,
	[Version] [nvarchar](8) NULL,
	[IsPremium] [bit] NOT NULL,
	[IsAdmin] [bit] NOT NULL,
	[BusinessControllerClass] [nvarchar](200) NULL,
	[FolderName] [nvarchar](128) NOT NULL,
	[ModuleName] [nvarchar](128) NOT NULL,
	[SupportedFeatures] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}DesktopModules_SupportedFeatures]  DEFAULT ((0)),
	[CompatibleVersions] [nvarchar](500) NULL,
 CONSTRAINT [PK_{objectQualifier}DesktopModules] PRIMARY KEY CLUSTERED 
(
	[DesktopModuleID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}DesktopModules_ModuleName] UNIQUE NONCLUSTERED 
(
	[ModuleName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Users]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](100) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[IsSuperUser] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Users_IsSuperUser]  DEFAULT ((0)),
	[AffiliateId] [int] NULL,
	[Email] [nvarchar](256) NULL,
	[DisplayName] [nvarchar](128) NOT NULL CONSTRAINT [DF_{objectQualifier}Users_DisplayName]  DEFAULT (''),
	[UpdatePassword] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Users_UpdatePassword]  DEFAULT ((0)),
 CONSTRAINT [PK_{objectQualifier}Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}Users] UNIQUE NONCLUSTERED 
(
	[Username] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}UserRoles]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}UserRoles](
	[UserRoleID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[IsTrialUsed] [bit] NULL,
	[EffectiveDate] [datetime] NULL,
 CONSTRAINT [PK_{objectQualifier}UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserRoleID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Roles]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Roles](
	[RoleID] [int] IDENTITY(0,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[ServiceFee] [money] NULL CONSTRAINT [DF_{objectQualifier}Roles_ServiceFee]  DEFAULT ((0)),
	[BillingFrequency] [char](1) NULL,
	[TrialPeriod] [int] NULL,
	[TrialFrequency] [char](1) NULL,
	[BillingPeriod] [int] NULL,
	[TrialFee] [money] NULL,
	[IsPublic] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Roles_IsPublic]  DEFAULT ((0)),
	[AutoAssignment] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Roles_AutoAssignment]  DEFAULT ((0)),
	[RoleGroupID] [int] NULL,
	[RSVPCode] [nvarchar](50) NULL,
	[IconFile] [nvarchar](100) NULL,
 CONSTRAINT [PK_{objectQualifier}Roles] PRIMARY KEY NONCLUSTERED 
(
	[RoleID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}RoleName] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[RoleName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}ScheduleItemSettings]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ScheduleItemSettings](
	[ScheduleID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_{objectQualifier}ScheduleItemSettings] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC,
	[SettingName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}ScheduleHistory]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ScheduleHistory](
	[ScheduleHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Succeeded] [bit] NULL,
	[LogNotes] [ntext] NULL,
	[NextStart] [datetime] NULL,
	[Server] [nvarchar](150) NULL,
 CONSTRAINT [PK_{objectQualifier}ScheduleHistory] PRIMARY KEY CLUSTERED 
(
	[ScheduleHistoryID] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}TabModuleSettings]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}TabModuleSettings](
	[TabModuleID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](2000) NOT NULL,
 CONSTRAINT [PK_{objectQualifier}TabModuleSettings] PRIMARY KEY CLUSTERED 
(
	[TabModuleID] ASC,
	[SettingName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}ModuleSettings]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ModuleSettings](
	[ModuleID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](2000) NOT NULL,
 CONSTRAINT [PK_{objectQualifier}ModuleSettings] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC,
	[SettingName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}ModulePermission]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ModulePermission](
	[ModulePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}ModulePermission] PRIMARY KEY CLUSTERED 
(
	[ModulePermissionID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}HtmlText]    Script Date: 10/05/2007 21:16:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}HtmlText](
	[ModuleID] [int] NOT NULL,
	[DesktopHtml] [ntext] NOT NULL,
	[DesktopSummary] [ntext] NULL,
	[CreatedByUser] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_{objectQualifier}HtmlText] PRIMARY KEY NONCLUSTERED 
(
	[ModuleID] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}TabModules]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}TabModules](
	[TabModuleID] [int] IDENTITY(1,1) NOT NULL,
	[TabID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[PaneName] [nvarchar](50) NOT NULL,
	[ModuleOrder] [int] NOT NULL,
	[CacheTime] [int] NOT NULL,
	[Alignment] [nvarchar](10) NULL,
	[Color] [nvarchar](20) NULL,
	[Border] [nvarchar](1) NULL,
	[IconFile] [nvarchar](100) NULL,
	[Visibility] [int] NOT NULL,
	[ContainerSrc] [nvarchar](200) NULL,
	[DisplayTitle] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}TabModules_DisplayTitle]  DEFAULT ((1)),
	[DisplayPrint] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}TabModules_DisplayPrint]  DEFAULT ((1)),
	[DisplaySyndicate] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}TabModules_DisplaySyndicate]  DEFAULT ((1)),
 CONSTRAINT [PK_{objectQualifier}TabModules] PRIMARY KEY CLUSTERED 
(
	[TabModuleID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}TabModules] UNIQUE NONCLUSTERED 
(
	[TabID] ASC,
	[ModuleID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Links]    Script Date: 10/05/2007 21:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Links](
	[ItemID] [int] IDENTITY(0,1) NOT NULL,
	[ModuleID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Title] [nvarchar](100) NULL,
	[Url] [nvarchar](250) NULL,
	[ViewOrder] [int] NULL,
	[Description] [nvarchar](2000) NULL,
	[CreatedByUser] [int] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ItemID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}SearchItem]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SearchItem](
	[SearchItemID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](2000) NOT NULL,
	[Author] [int] NULL,
	[PubDate] [datetime] NOT NULL,
	[ModuleId] [int] NOT NULL,
	[SearchKey] [nvarchar](100) NOT NULL,
	[Guid] [varchar](200) NULL,
	[HitCount] [int] NULL,
	[ImageFileId] [int] NULL,
 CONSTRAINT [PK_{objectQualifier}SearchItem] PRIMARY KEY CLUSTERED 
(
	[SearchItemID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}VendorClassification]    Script Date: 10/05/2007 21:16:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}VendorClassification](
	[VendorClassificationId] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NOT NULL,
	[ClassificationId] [int] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}VendorClassification] PRIMARY KEY CLUSTERED 
(
	[VendorClassificationId] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}VendorClassification] UNIQUE NONCLUSTERED 
(
	[VendorId] ASC,
	[ClassificationId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}SearchItemWord]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SearchItemWord](
	[SearchItemWordID] [int] IDENTITY(1,1) NOT NULL,
	[SearchItemID] [int] NOT NULL,
	[SearchWordsID] [int] NOT NULL,
	[Occurrences] [int] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}SearchItemWords] PRIMARY KEY CLUSTERED 
(
	[SearchItemWordID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}SearchItemWord] UNIQUE NONCLUSTERED 
(
	[SearchItemID] ASC,
	[SearchWordsID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}ModuleControls]    Script Date: 10/05/2007 21:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ModuleControls](
	[ModuleControlID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleDefID] [int] NULL,
	[ControlKey] [nvarchar](50) NULL,
	[ControlTitle] [nvarchar](50) NULL,
	[ControlSrc] [nvarchar](256) NULL,
	[IconFile] [nvarchar](100) NULL,
	[ControlType] [int] NOT NULL,
	[ViewOrder] [int] NULL,
	[HelpUrl] [nvarchar](200) NULL,
 CONSTRAINT [PK_{objectQualifier}ModuleControls] PRIMARY KEY CLUSTERED 
(
	[ModuleControlID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}ModuleControls] UNIQUE NONCLUSTERED 
(
	[ModuleDefID] ASC,
	[ControlKey] ASC,
	[ControlSrc] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Modules]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Modules](
	[ModuleID] [int] IDENTITY(0,1) NOT NULL,
	[ModuleDefID] [int] NOT NULL,
	[ModuleTitle] [nvarchar](256) NULL,
	[AllTabs] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Modules_AllTabs]  DEFAULT ((0)),
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Modules_IsDeleted]  DEFAULT ((0)),
	[InheritViewPermissions] [bit] NULL,
	[Header] [ntext] NULL,
	[Footer] [ntext] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[PortalID] [int] NULL,
 CONSTRAINT [PK_{objectQualifier}Modules] PRIMARY KEY NONCLUSTERED 
(
	[ModuleID] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}UserProfile]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}UserProfile](
	[ProfileID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[PropertyDefinitionID] [int] NOT NULL,
	[PropertyValue] [nvarchar](3750) NULL,
	[PropertyText] [ntext] NULL,
	[Visibility] [int] NOT NULL CONSTRAINT [DF__{objectQualifier}UserP__Visib__1352D76D]  DEFAULT ((0)),
	[LastUpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}UserProfile] PRIMARY KEY NONCLUSTERED 
(
	[ProfileID] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}TabPermission]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}TabPermission](
	[TabPermissionID] [int] IDENTITY(1,1) NOT NULL,
	[TabID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}TabPermission] PRIMARY KEY CLUSTERED 
(
	[TabPermissionID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Banners]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Banners](
	[BannerId] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NOT NULL,
	[ImageFile] [nvarchar](100) NULL,
	[BannerName] [nvarchar](100) NOT NULL,
	[Impressions] [int] NOT NULL,
	[CPM] [float] NOT NULL,
	[Views] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Banners_Views]  DEFAULT ((0)),
	[ClickThroughs] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Banners_ClickThroughs]  DEFAULT ((0)),
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreatedByUser] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[BannerTypeId] [int] NULL,
	[Description] [nvarchar](2000) NULL,
	[GroupName] [nvarchar](100) NULL,
	[Criteria] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Banners_Criteria]  DEFAULT ((1)),
	[URL] [nvarchar](255) NULL,
	[Width] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Banners_Width]  DEFAULT ((0)),
	[Height] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Banners_Height]  DEFAULT ((0)),
 CONSTRAINT [PK_{objectQualifier}Banner] PRIMARY KEY CLUSTERED 
(
	[BannerId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Affiliates]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Affiliates](
	[AffiliateId] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CPC] [float] NOT NULL,
	[Clicks] [int] NOT NULL,
	[CPA] [float] NOT NULL,
	[Acquisitions] [int] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}Affiliates] PRIMARY KEY CLUSTERED 
(
	[AffiliateId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}SearchItemWordPosition]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SearchItemWordPosition](
	[SearchItemWordPositionID] [int] IDENTITY(1,1) NOT NULL,
	[SearchItemWordID] [int] NOT NULL,
	[ContentPosition] [int] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}SearchItemWordPosition] PRIMARY KEY CLUSTERED 
(
	[SearchItemWordPositionID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}EventLogConfig]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}EventLogConfig](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LogTypeKey] [nvarchar](35) NULL,
	[LogTypePortalID] [int] NULL,
	[LoggingIsActive] [bit] NOT NULL,
	[KeepMostRecent] [int] NOT NULL,
	[EmailNotificationIsActive] [bit] NOT NULL,
	[NotificationThreshold] [int] NULL,
	[NotificationThresholdTime] [int] NULL,
	[NotificationThresholdTimeType] [int] NULL,
	[MailFromAddress] [nvarchar](50) NOT NULL,
	[MailToAddress] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_{objectQualifier}EventLogConfig] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}EventLog]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}EventLog](
	[LogGUID] [varchar](36) NOT NULL,
	[LogTypeKey] [nvarchar](35) NOT NULL,
	[LogConfigID] [int] NULL,
	[LogUserID] [int] NULL,
	[LogUserName] [nvarchar](50) NULL,
	[LogPortalID] [int] NULL,
	[LogPortalName] [nvarchar](100) NULL,
	[LogCreateDate] [datetime] NOT NULL,
	[LogServerName] [nvarchar](50) NOT NULL,
	[LogProperties] [ntext] NOT NULL,
	[LogNotificationPending] [bit] NULL,
 CONSTRAINT [PK_EventLogMaster] PRIMARY KEY CLUSTERED 
(
	[LogGUID] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}UrlLog]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}UrlLog](
	[UrlLogID] [int] IDENTITY(1,1) NOT NULL,
	[UrlTrackingID] [int] NOT NULL,
	[ClickDate] [datetime] NOT NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_{objectQualifier}UrlLog] PRIMARY KEY CLUSTERED 
(
	[UrlLogID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}FolderPermission]    Script Date: 10/05/2007 21:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}FolderPermission](
	[FolderPermissionID] [int] IDENTITY(1,1) NOT NULL,
	[FolderID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}FolderPermission] PRIMARY KEY CLUSTERED 
(
	[FolderPermissionID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Files]    Script Date: 10/05/2007 21:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Files](
	[FileId] [int] IDENTITY(1,1) NOT NULL,
	[PortalId] [int] NULL,
	[FileName] [nvarchar](100) NOT NULL,
	[Extension] [nvarchar](100) NOT NULL,
	[Size] [int] NOT NULL,
	[Width] [int] NULL,
	[Height] [int] NULL,
	[ContentType] [nvarchar](200) NOT NULL,
	[Folder] [nvarchar](200) NULL,
	[FolderID] [int] NOT NULL,
	[Content] [image] NULL,
 CONSTRAINT [PK_{objectQualifier}File] PRIMARY KEY CLUSTERED 
(
	[FileId] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Vendors]    Script Date: 10/05/2007 21:16:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Vendors](
	[VendorId] [int] IDENTITY(1,1) NOT NULL,
	[VendorName] [nvarchar](50) NOT NULL,
	[Street] [nvarchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[Region] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](50) NULL,
	[Telephone] [nvarchar](50) NULL,
	[PortalId] [int] NULL,
	[Fax] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[Website] [nvarchar](100) NULL,
	[ClickThroughs] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Vendors_ClickThroughs]  DEFAULT ((0)),
	[Views] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Vendors_Views]  DEFAULT ((0)),
	[CreatedByUser] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[LogoFile] [nvarchar](100) NULL,
	[KeyWords] [ntext] NULL,
	[Unit] [nvarchar](50) NULL,
	[Authorized] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Vendors_Authorized]  DEFAULT ((1)),
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Cell] [varchar](50) NULL,
 CONSTRAINT [PK_{objectQualifier}Vendor] PRIMARY KEY CLUSTERED 
(
	[VendorId] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}Vendors] UNIQUE NONCLUSTERED 
(
	[PortalId] ASC,
	[VendorName] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}UrlTracking]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}UrlTracking](
	[UrlTrackingID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[Url] [nvarchar](255) NOT NULL,
	[UrlType] [char](1) NOT NULL,
	[Clicks] [int] NOT NULL,
	[LastClick] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LogActivity] [bit] NOT NULL,
	[TrackClicks] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}UrlTracking_TrackClicks]  DEFAULT ((1)),
	[ModuleId] [int] NULL,
	[NewWindow] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}UrlTracking_NewWindow]  DEFAULT ((0)),
 CONSTRAINT [PK_{objectQualifier}UrlTracking] PRIMARY KEY CLUSTERED 
(
	[UrlTrackingID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}UrlTracking] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[Url] ASC,
	[ModuleId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Urls]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Urls](
	[UrlID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[Url] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_{objectQualifier}Urls] PRIMARY KEY CLUSTERED 
(
	[UrlID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}Urls] UNIQUE NONCLUSTERED 
(
	[Url] ASC,
	[PortalID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Profile]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Profile](
	[ProfileId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[PortalId] [int] NOT NULL,
	[ProfileData] [ntext] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}Profile] PRIMARY KEY CLUSTERED 
(
	[ProfileId] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}PortalAlias]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}PortalAlias](
	[PortalAliasID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[HTTPAlias] [nvarchar](200) NULL,
 CONSTRAINT [PK_{objectQualifier}PortalAlias] PRIMARY KEY CLUSTERED 
(
	[PortalAliasID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}PortalAlias] UNIQUE NONCLUSTERED 
(
	[HTTPAlias] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}SystemMessages]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SystemMessages](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[MessageName] [nvarchar](50) NOT NULL,
	[MessageValue] [ntext] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}SystemMessages] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}SystemMessages] UNIQUE NONCLUSTERED 
(
	[MessageName] ASC,
	[PortalID] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Folders]    Script Date: 10/05/2007 21:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Folders](
	[FolderID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[FolderPath] [varchar](300) NOT NULL,
	[StorageLocation] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Folders_StorageLocation]  DEFAULT ((0)),
	[IsProtected] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Folders_IsProtected]  DEFAULT ((0)),
	[IsCached] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Folders_IsCached]  DEFAULT ((0)),
	[LastUpdated] [datetime] NULL,
 CONSTRAINT [PK_{objectQualifier}Folders] PRIMARY KEY CLUSTERED 
(
	[FolderID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Skins]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Skins](
	[SkinID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[SkinRoot] [nvarchar](50) NOT NULL,
	[SkinSrc] [nvarchar](200) NOT NULL,
	[SkinType] [int] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}Skins] PRIMARY KEY CLUSTERED 
(
	[SkinID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}ProfilePropertyDefinition]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ProfilePropertyDefinition](
	[PropertyDefinitionID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[ModuleDefID] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[DataType] [int] NOT NULL,
	[DefaultValue] [nvarchar](50) NULL,
	[PropertyCategory] [nvarchar](50) NOT NULL,
	[PropertyName] [nvarchar](50) NOT NULL,
	[Length] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}ProfilePropertyDefinition_Length]  DEFAULT ((0)),
	[Required] [bit] NOT NULL,
	[ValidationExpression] [nvarchar](2000) NULL,
	[ViewOrder] [int] NOT NULL,
	[Visible] [bit] NOT NULL,
	[Searchable] [bit] NOT NULL
 CONSTRAINT [PK_{objectQualifier}ProfilePropertyDefinition] PRIMARY KEY CLUSTERED 
(
	[PropertyDefinitionID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}AnonymousUsers]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}AnonymousUsers](
	[UserID] [char](36) NOT NULL,
	[PortalID] [int] NOT NULL,
	[TabID] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_{objectQualifier}AnonymousUsers_CreationDate]  DEFAULT (getdate()),
	[LastActiveDate] [datetime] NOT NULL CONSTRAINT [DF_{objectQualifier}AnonymousUsers_LastActiveDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_{objectQualifier}AnonymousUsers] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[PortalID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}UsersOnline]    Script Date: 10/05/2007 21:16:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}UsersOnline](
	[UserID] [int] NOT NULL,
	[PortalID] [int] NOT NULL,
	[TabID] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__{objectQualifier}Users__Creat__3BFFE745]  DEFAULT (getdate()),
	[LastActiveDate] [datetime] NOT NULL CONSTRAINT [DF__{objectQualifier}Users__LastA__3CF40B7E]  DEFAULT (getdate()),
 CONSTRAINT [PK_{objectQualifier}UsersOnline] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[PortalID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}PortalDesktopModules]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules](
	[PortalDesktopModuleID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[DesktopModuleID] [int] NOT NULL,
 CONSTRAINT [PK_{objectQualifier}PortalDesktopModules] PRIMARY KEY CLUSTERED 
(
	[PortalDesktopModuleID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}PortalDesktopModules] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[DesktopModuleID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}Tabs]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}Tabs](
	[TabID] [int] IDENTITY(0,1) NOT NULL,
	[TabOrder] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Tabs_TabOrder]  DEFAULT ((0)),
	[PortalID] [int] NULL,
	[TabName] [nvarchar](50) NOT NULL,
	[IsVisible] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Tabs_IsVisible]  DEFAULT ((1)),
	[ParentId] [int] NULL,
	[Level] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}Tabs_Level]  DEFAULT ((0)),
	[IconFile] [nvarchar](100) NULL,
	[DisableLink] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Tabs_DisableLink]  DEFAULT ((0)),
	[Title] [nvarchar](200) NULL,
	[Description] [nvarchar](500) NULL,
	[KeyWords] [nvarchar](500) NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}Tabs_IsDeleted]  DEFAULT ((0)),
	[Url] [nvarchar](255) NULL,
	[SkinSrc] [nvarchar](200) NULL,
	[ContainerSrc] [nvarchar](200) NULL,
	[TabPath] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[RefreshInterval] [int] NULL,
	[PageHeadText] [nvarchar](500) NULL,
 CONSTRAINT [PK_{objectQualifier}Tabs] PRIMARY KEY CLUSTERED 
(
	[TabID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}UserPortals]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}UserPortals](
	[UserId] [int] NOT NULL,
	[PortalId] [int] NOT NULL,
	[UserPortalId] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_{objectQualifier}UserPortals_CreatedDate]  DEFAULT (getdate()),
	[Authorised] [bit] NOT NULL CONSTRAINT [DF_{objectQualifier}UserPortals_Authorised]  DEFAULT ((1)),
 CONSTRAINT [PK_{objectQualifier}UserPortals] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[PortalId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}SiteLog]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}SiteLog](
	[SiteLogId] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [smalldatetime] NOT NULL,
	[PortalId] [int] NOT NULL,
	[UserId] [int] NULL,
	[Referrer] [nvarchar](255) NULL,
	[Url] [nvarchar](255) NULL,
	[UserAgent] [nvarchar](255) NULL,
	[UserHostAddress] [nvarchar](255) NULL,
	[UserHostName] [nvarchar](255) NULL,
	[TabId] [int] NULL,
	[AffiliateId] [int] NULL,
 CONSTRAINT [PK_{objectQualifier}SiteLog] PRIMARY KEY CLUSTERED 
(
	[SiteLogId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}RoleGroups]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}RoleGroups](
	[RoleGroupID] [int] IDENTITY(0,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[RoleGroupName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](1000) NULL,
 CONSTRAINT [PK_{objectQualifier}RoleGroups] PRIMARY KEY NONCLUSTERED 
(
	[RoleGroupID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}RoleGroupName] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[RoleGroupName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}[{objectQualifier}ModuleDefinitions]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE {databaseOwner}[{objectQualifier}ModuleDefinitions](
	[ModuleDefID] [int] IDENTITY(1,1) NOT NULL,
	[FriendlyName] [nvarchar](128) NOT NULL,
	[DesktopModuleID] [int] NOT NULL,
	[DefaultCacheTime] [int] NOT NULL CONSTRAINT [DF_{objectQualifier}ModuleDefinitions_DefaultCacheTime]  DEFAULT ((0)),
 CONSTRAINT [PK_{objectQualifier}ModuleDefinitions] PRIMARY KEY NONCLUSTERED 
(
	[ModuleDefID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_{objectQualifier}ModuleDefinitions] UNIQUE NONCLUSTERED 
(
	[FriendlyName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Affiliates_{objectQualifier}Vendors]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Affiliates]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Affiliates_{objectQualifier}Vendors] FOREIGN KEY([VendorId])
REFERENCES {databaseOwner}[{objectQualifier}Vendors] ([VendorId])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Affiliates] CHECK CONSTRAINT [FK_{objectQualifier}Affiliates_{objectQualifier}Vendors]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}AnonymousUsers_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}AnonymousUsers]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}AnonymousUsers_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}AnonymousUsers] CHECK CONSTRAINT [FK_{objectQualifier}AnonymousUsers_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Banner_{objectQualifier}Vendor]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Banners]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Banner_{objectQualifier}Vendor] FOREIGN KEY([VendorId])
REFERENCES {databaseOwner}[{objectQualifier}Vendors] ([VendorId])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Banners] CHECK CONSTRAINT [FK_{objectQualifier}Banner_{objectQualifier}Vendor]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Classification_{objectQualifier}Classification]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Classification]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Classification_{objectQualifier}Classification] FOREIGN KEY([ParentId])
REFERENCES {databaseOwner}[{objectQualifier}Classification] ([ClassificationId])
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Classification] CHECK CONSTRAINT [FK_{objectQualifier}Classification_{objectQualifier}Classification]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}EventLog_{objectQualifier}EventLogConfig]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}EventLog]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}EventLog_{objectQualifier}EventLogConfig] FOREIGN KEY([LogConfigID])
REFERENCES {databaseOwner}[{objectQualifier}EventLogConfig] ([ID])
GO
ALTER TABLE {databaseOwner}[{objectQualifier}EventLog] CHECK CONSTRAINT [FK_{objectQualifier}EventLog_{objectQualifier}EventLogConfig]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}EventLog_{objectQualifier}EventLogTypes]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}EventLog]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}EventLog_{objectQualifier}EventLogTypes] FOREIGN KEY([LogTypeKey])
REFERENCES {databaseOwner}[{objectQualifier}EventLogTypes] ([LogTypeKey])
GO
ALTER TABLE {databaseOwner}[{objectQualifier}EventLog] CHECK CONSTRAINT [FK_{objectQualifier}EventLog_{objectQualifier}EventLogTypes]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}EventLogConfig_{objectQualifier}EventLogTypes]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}EventLogConfig]  WITH CHECK ADD  CONSTRAINT [FK_{objectQualifier}EventLogConfig_{objectQualifier}EventLogTypes] FOREIGN KEY([LogTypeKey])
REFERENCES {databaseOwner}[{objectQualifier}EventLogTypes] ([LogTypeKey])
GO
ALTER TABLE {databaseOwner}[{objectQualifier}EventLogConfig] CHECK CONSTRAINT [FK_{objectQualifier}EventLogConfig_{objectQualifier}EventLogTypes]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Files_{objectQualifier}Folders]    Script Date: 10/05/2007 21:16:45 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Files]  WITH CHECK ADD  CONSTRAINT [FK_{objectQualifier}Files_{objectQualifier}Folders] FOREIGN KEY([FolderID])
REFERENCES {databaseOwner}[{objectQualifier}Folders] ([FolderID])
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Files] CHECK CONSTRAINT [FK_{objectQualifier}Files_{objectQualifier}Folders]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Files_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:45 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Files]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Files_{objectQualifier}Portals] FOREIGN KEY([PortalId])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Files] CHECK CONSTRAINT [FK_{objectQualifier}Files_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}FolderPermission_{objectQualifier}Folders]    Script Date: 10/05/2007 21:16:45 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}FolderPermission]  WITH CHECK ADD  CONSTRAINT [FK_{objectQualifier}FolderPermission_{objectQualifier}Folders] FOREIGN KEY([FolderID])
REFERENCES {databaseOwner}[{objectQualifier}Folders] ([FolderID])
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}FolderPermission] CHECK CONSTRAINT [FK_{objectQualifier}FolderPermission_{objectQualifier}Folders]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}FolderPermission_{objectQualifier}Permission]    Script Date: 10/05/2007 21:16:45 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}FolderPermission]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}FolderPermission_{objectQualifier}Permission] FOREIGN KEY([PermissionID])
REFERENCES {databaseOwner}[{objectQualifier}Permission] ([PermissionID])
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}FolderPermission] CHECK CONSTRAINT [FK_{objectQualifier}FolderPermission_{objectQualifier}Permission]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Folders_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:45 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Folders]  WITH CHECK ADD  CONSTRAINT [FK_{objectQualifier}Folders_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Folders] CHECK CONSTRAINT [FK_{objectQualifier}Folders_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}HtmlText_{objectQualifier}Modules]    Script Date: 10/05/2007 21:16:47 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}HtmlText]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}HtmlText_{objectQualifier}Modules] FOREIGN KEY([ModuleID])
REFERENCES {databaseOwner}[{objectQualifier}Modules] ([ModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}HtmlText] CHECK CONSTRAINT [FK_{objectQualifier}HtmlText_{objectQualifier}Modules]
GO
/****** Object:  ForeignKey [FK__{objectQualifier}Links__Modul__0F824689]    Script Date: 10/05/2007 21:16:50 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Links]  WITH NOCHECK ADD FOREIGN KEY([ModuleID])
REFERENCES {databaseOwner}[{objectQualifier}Modules] ([ModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
/****** Object:  ForeignKey [FK_{objectQualifier}ModuleControls_{objectQualifier}ModuleDefinitions]    Script Date: 10/05/2007 21:16:50 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleControls]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}ModuleControls_{objectQualifier}ModuleDefinitions] FOREIGN KEY([ModuleDefID])
REFERENCES {databaseOwner}[{objectQualifier}ModuleDefinitions] ([ModuleDefID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleControls] CHECK CONSTRAINT [FK_{objectQualifier}ModuleControls_{objectQualifier}ModuleDefinitions]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}ModuleDefinitions_{objectQualifier}DesktopModules]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleDefinitions]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}ModuleDefinitions_{objectQualifier}DesktopModules] FOREIGN KEY([DesktopModuleID])
REFERENCES {databaseOwner}[{objectQualifier}DesktopModules] ([DesktopModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleDefinitions] CHECK CONSTRAINT [FK_{objectQualifier}ModuleDefinitions_{objectQualifier}DesktopModules]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}ModulePermission_{objectQualifier}Modules]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}ModulePermission]  WITH CHECK ADD  CONSTRAINT [FK_{objectQualifier}ModulePermission_{objectQualifier}Modules] FOREIGN KEY([ModuleID])
REFERENCES {databaseOwner}[{objectQualifier}Modules] ([ModuleID])
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModulePermission] CHECK CONSTRAINT [FK_{objectQualifier}ModulePermission_{objectQualifier}Modules]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}ModulePermission_{objectQualifier}Permission]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}ModulePermission]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}ModulePermission_{objectQualifier}Permission] FOREIGN KEY([PermissionID])
REFERENCES {databaseOwner}[{objectQualifier}Permission] ([PermissionID])
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModulePermission] CHECK CONSTRAINT [FK_{objectQualifier}ModulePermission_{objectQualifier}Permission]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Modules_{objectQualifier}ModuleDefinitions]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Modules]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Modules_{objectQualifier}ModuleDefinitions] FOREIGN KEY([ModuleDefID])
REFERENCES {databaseOwner}[{objectQualifier}ModuleDefinitions] ([ModuleDefID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Modules] CHECK CONSTRAINT [FK_{objectQualifier}Modules_{objectQualifier}ModuleDefinitions]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Modules_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Modules]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Modules_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Modules] CHECK CONSTRAINT [FK_{objectQualifier}Modules_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}ModuleSettings_{objectQualifier}Modules]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleSettings]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}ModuleSettings_{objectQualifier}Modules] FOREIGN KEY([ModuleID])
REFERENCES {databaseOwner}[{objectQualifier}Modules] ([ModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleSettings] CHECK CONSTRAINT [FK_{objectQualifier}ModuleSettings_{objectQualifier}Modules]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}PortalAlias_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}PortalAlias]  WITH CHECK ADD  CONSTRAINT [FK_{objectQualifier}PortalAlias_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalAlias] CHECK CONSTRAINT [FK_{objectQualifier}PortalAlias_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}PortalDesktopModules_{objectQualifier}DesktopModules]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}PortalDesktopModules_{objectQualifier}DesktopModules] FOREIGN KEY([DesktopModuleID])
REFERENCES {databaseOwner}[{objectQualifier}DesktopModules] ([DesktopModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules] CHECK CONSTRAINT [FK_{objectQualifier}PortalDesktopModules_{objectQualifier}DesktopModules]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}PortalDesktopModules_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}PortalDesktopModules_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules] CHECK CONSTRAINT [FK_{objectQualifier}PortalDesktopModules_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Profile_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Profile]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Profile_{objectQualifier}Portals] FOREIGN KEY([PortalId])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Profile] CHECK CONSTRAINT [FK_{objectQualifier}Profile_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Profile_{objectQualifier}Users]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Profile]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Profile_{objectQualifier}Users] FOREIGN KEY([UserId])
REFERENCES {databaseOwner}[{objectQualifier}Users] ([UserID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Profile] CHECK CONSTRAINT [FK_{objectQualifier}Profile_{objectQualifier}Users]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}ProfilePropertyDefinition_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}ProfilePropertyDefinition]  WITH CHECK ADD  CONSTRAINT [FK_{objectQualifier}ProfilePropertyDefinition_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ProfilePropertyDefinition] CHECK CONSTRAINT [FK_{objectQualifier}ProfilePropertyDefinition_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}RoleGroups_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}RoleGroups]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}RoleGroups_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}RoleGroups] CHECK CONSTRAINT [FK_{objectQualifier}RoleGroups_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Roles_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Roles]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Roles_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Roles] CHECK CONSTRAINT [FK_{objectQualifier}Roles_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Roles_{objectQualifier}RoleGroups]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Roles]  WITH CHECK ADD  CONSTRAINT [FK_{objectQualifier}Roles_{objectQualifier}RoleGroups] FOREIGN KEY([RoleGroupID])
REFERENCES {databaseOwner}[{objectQualifier}RoleGroups] ([RoleGroupID])
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Roles] CHECK CONSTRAINT [FK_{objectQualifier}Roles_{objectQualifier}RoleGroups]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}ScheduleHistory_{objectQualifier}Schedule]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}ScheduleHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}ScheduleHistory_{objectQualifier}Schedule] FOREIGN KEY([ScheduleID])
REFERENCES {databaseOwner}[{objectQualifier}Schedule] ([ScheduleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ScheduleHistory] CHECK CONSTRAINT [FK_{objectQualifier}ScheduleHistory_{objectQualifier}Schedule]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}ScheduleItemSettings_{objectQualifier}Schedule]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}ScheduleItemSettings]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}ScheduleItemSettings_{objectQualifier}Schedule] FOREIGN KEY([ScheduleID])
REFERENCES {databaseOwner}[{objectQualifier}Schedule] ([ScheduleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ScheduleItemSettings] CHECK CONSTRAINT [FK_{objectQualifier}ScheduleItemSettings_{objectQualifier}Schedule]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}SearchItem_{objectQualifier}Modules]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItem]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}SearchItem_{objectQualifier}Modules] FOREIGN KEY([ModuleId])
REFERENCES {databaseOwner}[{objectQualifier}Modules] ([ModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItem] CHECK CONSTRAINT [FK_{objectQualifier}SearchItem_{objectQualifier}Modules]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}SearchItemWord_{objectQualifier}SearchItem]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWord]  WITH CHECK ADD  CONSTRAINT [FK_{objectQualifier}SearchItemWord_{objectQualifier}SearchItem] FOREIGN KEY([SearchItemID])
REFERENCES {databaseOwner}[{objectQualifier}SearchItem] ([SearchItemID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWord] CHECK CONSTRAINT [FK_{objectQualifier}SearchItemWord_{objectQualifier}SearchItem]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}SearchItemWord_{objectQualifier}SearchWord]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWord]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}SearchItemWord_{objectQualifier}SearchWord] FOREIGN KEY([SearchWordsID])
REFERENCES {databaseOwner}[{objectQualifier}SearchWord] ([SearchWordsID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWord] CHECK CONSTRAINT [FK_{objectQualifier}SearchItemWord_{objectQualifier}SearchWord]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}SearchItemWordPosition_{objectQualifier}SearchItemWord]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWordPosition]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}SearchItemWordPosition_{objectQualifier}SearchItemWord] FOREIGN KEY([SearchItemWordID])
REFERENCES {databaseOwner}[{objectQualifier}SearchItemWord] ([SearchItemWordID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWordPosition] CHECK CONSTRAINT [FK_{objectQualifier}SearchItemWordPosition_{objectQualifier}SearchItemWord]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}SiteLog_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}SiteLog]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}SiteLog_{objectQualifier}Portals] FOREIGN KEY([PortalId])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SiteLog] CHECK CONSTRAINT [FK_{objectQualifier}SiteLog_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Skins_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Skins]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Skins_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Skins] CHECK CONSTRAINT [FK_{objectQualifier}Skins_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}SystemMessages_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}SystemMessages]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}SystemMessages_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SystemMessages] CHECK CONSTRAINT [FK_{objectQualifier}SystemMessages_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}TabModules_{objectQualifier}Modules]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}TabModules_{objectQualifier}Modules] FOREIGN KEY([ModuleID])
REFERENCES {databaseOwner}[{objectQualifier}Modules] ([ModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules] CHECK CONSTRAINT [FK_{objectQualifier}TabModules_{objectQualifier}Modules]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}TabModules_{objectQualifier}Tabs]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}TabModules_{objectQualifier}Tabs] FOREIGN KEY([TabID])
REFERENCES {databaseOwner}[{objectQualifier}Tabs] ([TabID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules] CHECK CONSTRAINT [FK_{objectQualifier}TabModules_{objectQualifier}Tabs]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}TabModuleSettings_{objectQualifier}TabModules]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}TabModuleSettings]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}TabModuleSettings_{objectQualifier}TabModules] FOREIGN KEY([TabModuleID])
REFERENCES {databaseOwner}[{objectQualifier}TabModules] ([TabModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModuleSettings] CHECK CONSTRAINT [FK_{objectQualifier}TabModuleSettings_{objectQualifier}TabModules]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}TabPermission_{objectQualifier}Permission]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}TabPermission]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}TabPermission_{objectQualifier}Permission] FOREIGN KEY([PermissionID])
REFERENCES {databaseOwner}[{objectQualifier}Permission] ([PermissionID])
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabPermission] CHECK CONSTRAINT [FK_{objectQualifier}TabPermission_{objectQualifier}Permission]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}TabPermission_{objectQualifier}Tabs]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}TabPermission]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}TabPermission_{objectQualifier}Tabs] FOREIGN KEY([TabID])
REFERENCES {databaseOwner}[{objectQualifier}Tabs] ([TabID])
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabPermission] CHECK CONSTRAINT [FK_{objectQualifier}TabPermission_{objectQualifier}Tabs]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Tabs_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Tabs_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs] CHECK CONSTRAINT [FK_{objectQualifier}Tabs_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Tabs_{objectQualifier}Tabs]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Tabs_{objectQualifier}Tabs] FOREIGN KEY([ParentId])
REFERENCES {databaseOwner}[{objectQualifier}Tabs] ([TabID])
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs] CHECK CONSTRAINT [FK_{objectQualifier}Tabs_{objectQualifier}Tabs]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}UrlLog_{objectQualifier}UrlTracking]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}UrlLog]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}UrlLog_{objectQualifier}UrlTracking] FOREIGN KEY([UrlTrackingID])
REFERENCES {databaseOwner}[{objectQualifier}UrlTracking] ([UrlTrackingID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlLog] CHECK CONSTRAINT [FK_{objectQualifier}UrlLog_{objectQualifier}UrlTracking]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Urls_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Urls]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Urls_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Urls] CHECK CONSTRAINT [FK_{objectQualifier}Urls_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}UrlTracking_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}UrlTracking]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}UrlTracking_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlTracking] CHECK CONSTRAINT [FK_{objectQualifier}UrlTracking_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}UserPortals_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}UserPortals]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}UserPortals_{objectQualifier}Portals] FOREIGN KEY([PortalId])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserPortals] CHECK CONSTRAINT [FK_{objectQualifier}UserPortals_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}UserPortals_{objectQualifier}Users]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}UserPortals]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}UserPortals_{objectQualifier}Users] FOREIGN KEY([UserId])
REFERENCES {databaseOwner}[{objectQualifier}Users] ([UserID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserPortals] CHECK CONSTRAINT [FK_{objectQualifier}UserPortals_{objectQualifier}Users]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}UserProfile_{objectQualifier}ProfilePropertyDefinition]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}UserProfile]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}UserProfile_{objectQualifier}ProfilePropertyDefinition] FOREIGN KEY([PropertyDefinitionID])
REFERENCES {databaseOwner}[{objectQualifier}ProfilePropertyDefinition] ([PropertyDefinitionID])
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserProfile] CHECK CONSTRAINT [FK_{objectQualifier}UserProfile_{objectQualifier}ProfilePropertyDefinition]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}UserProfile_{objectQualifier}Users]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}UserProfile]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}UserProfile_{objectQualifier}Users] FOREIGN KEY([UserID])
REFERENCES {databaseOwner}[{objectQualifier}Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserProfile] CHECK CONSTRAINT [FK_{objectQualifier}UserProfile_{objectQualifier}Users]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}UserRoles_{objectQualifier}Roles]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}UserRoles]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}UserRoles_{objectQualifier}Roles] FOREIGN KEY([RoleID])
REFERENCES {databaseOwner}[{objectQualifier}Roles] ([RoleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserRoles] CHECK CONSTRAINT [FK_{objectQualifier}UserRoles_{objectQualifier}Roles]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}UserRoles_{objectQualifier}Users]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}UserRoles]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}UserRoles_{objectQualifier}Users] FOREIGN KEY([UserID])
REFERENCES {databaseOwner}[{objectQualifier}Users] ([UserID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserRoles] CHECK CONSTRAINT [FK_{objectQualifier}UserRoles_{objectQualifier}Users]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}UsersOnline_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:55 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}UsersOnline]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}UsersOnline_{objectQualifier}Portals] FOREIGN KEY([PortalID])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UsersOnline] CHECK CONSTRAINT [FK_{objectQualifier}UsersOnline_{objectQualifier}Portals]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}UsersOnline_{objectQualifier}Users]    Script Date: 10/05/2007 21:16:55 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}UsersOnline]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}UsersOnline_{objectQualifier}Users] FOREIGN KEY([UserID])
REFERENCES {databaseOwner}[{objectQualifier}Users] ([UserID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UsersOnline] CHECK CONSTRAINT [FK_{objectQualifier}UsersOnline_{objectQualifier}Users]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}VendorClassification_{objectQualifier}Classification]    Script Date: 10/05/2007 21:16:55 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}VendorClassification]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}VendorClassification_{objectQualifier}Classification] FOREIGN KEY([ClassificationId])
REFERENCES {databaseOwner}[{objectQualifier}Classification] ([ClassificationId])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}VendorClassification] CHECK CONSTRAINT [FK_{objectQualifier}VendorClassification_{objectQualifier}Classification]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}VendorClassification_{objectQualifier}Vendors]    Script Date: 10/05/2007 21:16:55 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}VendorClassification]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}VendorClassification_{objectQualifier}Vendors] FOREIGN KEY([VendorId])
REFERENCES {databaseOwner}[{objectQualifier}Vendors] ([VendorId])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}VendorClassification] CHECK CONSTRAINT [FK_{objectQualifier}VendorClassification_{objectQualifier}Vendors]
GO
/****** Object:  ForeignKey [FK_{objectQualifier}Vendor_{objectQualifier}Portals]    Script Date: 10/05/2007 21:16:55 ******/
ALTER TABLE {databaseOwner}[{objectQualifier}Vendors]  WITH NOCHECK ADD  CONSTRAINT [FK_{objectQualifier}Vendor_{objectQualifier}Portals] FOREIGN KEY([PortalId])
REFERENCES {databaseOwner}[{objectQualifier}Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Vendors] CHECK CONSTRAINT [FK_{objectQualifier}Vendor_{objectQualifier}Portals]
GO
