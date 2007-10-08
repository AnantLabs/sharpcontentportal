/****** Object:  Table [dbo].[dnn_Questions]    Script Date: 10/07/2007 07:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Questions](
	[QuestionId] [int] NOT NULL,
	[Question] [nvarchar](1000) NULL,
	[Locale] [nvarchar](50) NULL,
 CONSTRAINT [PK_dnn_Questions] PRIMARY KEY CLUSTERED 
(
	[QuestionId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Schedule]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Schedule](
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
 CONSTRAINT [PK_dnn_Schedule] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Version]    Script Date: 10/05/2007 21:16:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Version](
	[VersionId] [int] IDENTITY(1,1) NOT NULL,
	[Major] [int] NOT NULL,
	[Minor] [int] NOT NULL,
	[Build] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dnn_Version] PRIMARY KEY CLUSTERED 
(
	[VersionId] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_Version] UNIQUE NONCLUSTERED 
(
	[Major] ASC,
	[Minor] ASC,
	[Build] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Classification]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Classification](
	[ClassificationId] [int] IDENTITY(1,1) NOT NULL,
	[ClassificationName] [nvarchar](200) NOT NULL,
	[ParentId] [int] NULL,
 CONSTRAINT [PK_dnn_VendorCategory] PRIMARY KEY CLUSTERED 
(
	[ClassificationId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_SearchIndexer]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_SearchIndexer](
	[SearchIndexerID] [int] IDENTITY(1,1) NOT NULL,
	[SearchIndexerAssemblyQualifiedName] [char](200) NOT NULL,
 CONSTRAINT [PK_dnn_SearchIndexer] PRIMARY KEY CLUSTERED 
(
	[SearchIndexerID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_EventLogTypes]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_EventLogTypes](
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
/****** Object:  Table [dbo].[dnn_SearchCommonWords]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_SearchCommonWords](
	[CommonWordID] [int] IDENTITY(1,1) NOT NULL,
	[CommonWord] [nvarchar](255) NOT NULL,
	[Locale] [nvarchar](10) NULL,
 CONSTRAINT [PK_dnn_SearchCommonWords] PRIMARY KEY CLUSTERED 
(
	[CommonWordID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Lists]    Script Date: 10/05/2007 21:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Lists](
	[EntryID] [int] IDENTITY(1,1) NOT NULL,
	[ListName] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](100) NOT NULL,
	[Text] [nvarchar](150) NOT NULL,
	[ParentID] [int] NOT NULL CONSTRAINT [DF_dnn_Lists_ParentID]  DEFAULT ((0)),
	[Level] [int] NOT NULL CONSTRAINT [DF_dnn_Lists_Level]  DEFAULT ((0)),
	[SortOrder] [int] NOT NULL CONSTRAINT [DF_dnn_Lists_SortOrder]  DEFAULT ((0)),
	[DefinitionID] [int] NOT NULL CONSTRAINT [DF_dnn_Lists_DefinitionID]  DEFAULT ((0)),
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_dnn_Lists] PRIMARY KEY CLUSTERED 
(
	[ListName] ASC,
	[Value] ASC,
	[Text] ASC,
	[ParentID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_SearchWord]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_SearchWord](
	[SearchWordsID] [int] IDENTITY(1,1) NOT NULL,
	[Word] [nvarchar](100) NOT NULL,
	[IsCommon] [bit] NULL,
	[HitCount] [int] NOT NULL,
 CONSTRAINT [PK_dnn_SearchWord] PRIMARY KEY CLUSTERED 
(
	[SearchWordsID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_SearchWord] UNIQUE NONCLUSTERED 
(
	[Word] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_HostSettings]    Script Date: 10/05/2007 21:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_HostSettings](
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](256) NOT NULL,
	[SettingIsSecure] [bit] NOT NULL CONSTRAINT [DF_dnn_HostSettings_Secure]  DEFAULT ((0)),
 CONSTRAINT [PK_dnn_HostSettings] PRIMARY KEY CLUSTERED 
(
	[SettingName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Portals]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Portals](
	[PortalID] [int] IDENTITY(0,1) NOT NULL,
	[PortalName] [nvarchar](128) NOT NULL,
	[LogoFile] [nvarchar](50) NULL,
	[FooterText] [nvarchar](100) NULL,
	[ExpiryDate] [datetime] NULL,
	[UserRegistration] [int] NOT NULL CONSTRAINT [DF_dnn_Portals_UserRegistration]  DEFAULT ((0)),
	[BannerAdvertising] [int] NOT NULL CONSTRAINT [DF_dnn_Portals_BannerAdvertising]  DEFAULT ((0)),
	[AdministratorId] [int] NULL,
	[Currency] [char](3) NULL,
	[HostFee] [money] NOT NULL CONSTRAINT [DF_dnn_Portals_HostFee]  DEFAULT ((0)),
	[HostSpace] [int] NOT NULL CONSTRAINT [DF_dnn_Portals_HostSpace]  DEFAULT ((0)),
	[AdministratorRoleId] [int] NULL,
	[RegisteredRoleId] [int] NULL,
	[Description] [nvarchar](500) NULL,
	[KeyWords] [nvarchar](500) NULL,
	[BackgroundFile] [nvarchar](50) NULL,
	[GUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_dnn_Portals_GUID]  DEFAULT (newid()),
	[PaymentProcessor] [nvarchar](50) NULL,
	[ProcessorUserId] [nvarchar](50) NULL,
	[ProcessorPassword] [nvarchar](50) NULL,
	[SiteLogHistory] [int] NULL,
	[HomeTabId] [int] NULL,
	[LoginTabId] [int] NULL,
	[UserTabId] [int] NULL,
	[DefaultLanguage] [nvarchar](10) NOT NULL CONSTRAINT [DF_dnn_Portals_DefaultLanguage]  DEFAULT ('en-US'),
	[TimezoneOffset] [int] NOT NULL CONSTRAINT [DF_dnn_Portals_TimezoneOffset]  DEFAULT ((-8)),
	[AdminTabId] [int] NULL,
	[HomeDirectory] [varchar](100) NOT NULL CONSTRAINT [DF_dnn_Portals_HomeDirectory]  DEFAULT (''),
	[SplashTabId] [int] NULL,
	[PageQuota] [int] NOT NULL CONSTRAINT [DF_dnn_Portals_PageQuota]  DEFAULT ((0)),
	[UserQuota] [int] NOT NULL CONSTRAINT [DF_dnn_Portals_UserQuota]  DEFAULT ((0)),
 CONSTRAINT [PK_dnn_Portals] PRIMARY KEY NONCLUSTERED 
(
	[PortalID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Permission]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Permission](
	[PermissionID] [int] IDENTITY(1,1) NOT NULL,
	[PermissionCode] [varchar](50) NOT NULL,
	[ModuleDefID] [int] NOT NULL,
	[PermissionKey] [varchar](20) NOT NULL,
	[PermissionName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_dnn_Permission] PRIMARY KEY CLUSTERED 
(
	[PermissionID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_DesktopModules]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_DesktopModules](
	[DesktopModuleID] [int] IDENTITY(1,1) NOT NULL,
	[FriendlyName] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](2000) NULL,
	[Version] [nvarchar](8) NULL,
	[IsPremium] [bit] NOT NULL,
	[IsAdmin] [bit] NOT NULL,
	[BusinessControllerClass] [nvarchar](200) NULL,
	[FolderName] [nvarchar](128) NOT NULL,
	[ModuleName] [nvarchar](128) NOT NULL,
	[SupportedFeatures] [int] NOT NULL CONSTRAINT [DF_dnn_DesktopModules_SupportedFeatures]  DEFAULT ((0)),
	[CompatibleVersions] [nvarchar](500) NULL,
 CONSTRAINT [PK_dnn_DesktopModules] PRIMARY KEY CLUSTERED 
(
	[DesktopModuleID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_DesktopModules_ModuleName] UNIQUE NONCLUSTERED 
(
	[ModuleName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Users]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](100) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[IsSuperUser] [bit] NOT NULL CONSTRAINT [DF_dnn_Users_IsSuperUser]  DEFAULT ((0)),
	[AffiliateId] [int] NULL,
	[Email] [nvarchar](256) NULL,
	[DisplayName] [nvarchar](128) NOT NULL CONSTRAINT [DF_dnn_Users_DisplayName]  DEFAULT (''),
	[UpdatePassword] [bit] NOT NULL CONSTRAINT [DF_dnn_Users_UpdatePassword]  DEFAULT ((0)),
 CONSTRAINT [PK_dnn_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_Users] UNIQUE NONCLUSTERED 
(
	[Username] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_UserRoles]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_UserRoles](
	[UserRoleID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[IsTrialUsed] [bit] NULL,
	[EffectiveDate] [datetime] NULL,
 CONSTRAINT [PK_dnn_UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserRoleID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Roles]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Roles](
	[RoleID] [int] IDENTITY(0,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[ServiceFee] [money] NULL CONSTRAINT [DF_dnn_Roles_ServiceFee]  DEFAULT ((0)),
	[BillingFrequency] [char](1) NULL,
	[TrialPeriod] [int] NULL,
	[TrialFrequency] [char](1) NULL,
	[BillingPeriod] [int] NULL,
	[TrialFee] [money] NULL,
	[IsPublic] [bit] NOT NULL CONSTRAINT [DF_dnn_Roles_IsPublic]  DEFAULT ((0)),
	[AutoAssignment] [bit] NOT NULL CONSTRAINT [DF_dnn_Roles_AutoAssignment]  DEFAULT ((0)),
	[RoleGroupID] [int] NULL,
	[RSVPCode] [nvarchar](50) NULL,
	[IconFile] [nvarchar](100) NULL,
 CONSTRAINT [PK_dnn_Roles] PRIMARY KEY NONCLUSTERED 
(
	[RoleID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_RoleName] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[RoleName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_ScheduleItemSettings]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_ScheduleItemSettings](
	[ScheduleID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dnn_ScheduleItemSettings] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC,
	[SettingName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_ScheduleHistory]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_ScheduleHistory](
	[ScheduleHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Succeeded] [bit] NULL,
	[LogNotes] [ntext] NULL,
	[NextStart] [datetime] NULL,
	[Server] [nvarchar](150) NULL,
 CONSTRAINT [PK_dnn_ScheduleHistory] PRIMARY KEY CLUSTERED 
(
	[ScheduleHistoryID] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_TabModuleSettings]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_TabModuleSettings](
	[TabModuleID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](2000) NOT NULL,
 CONSTRAINT [PK_dnn_TabModuleSettings] PRIMARY KEY CLUSTERED 
(
	[TabModuleID] ASC,
	[SettingName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_ModuleSettings]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_ModuleSettings](
	[ModuleID] [int] NOT NULL,
	[SettingName] [nvarchar](50) NOT NULL,
	[SettingValue] [nvarchar](2000) NOT NULL,
 CONSTRAINT [PK_dnn_ModuleSettings] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC,
	[SettingName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_ModulePermission]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_ModulePermission](
	[ModulePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
 CONSTRAINT [PK_dnn_ModulePermission] PRIMARY KEY CLUSTERED 
(
	[ModulePermissionID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_HtmlText]    Script Date: 10/05/2007 21:16:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_HtmlText](
	[ModuleID] [int] NOT NULL,
	[DesktopHtml] [ntext] NOT NULL,
	[DesktopSummary] [ntext] NULL,
	[CreatedByUser] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_dnn_HtmlText] PRIMARY KEY NONCLUSTERED 
(
	[ModuleID] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_TabModules]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_TabModules](
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
	[DisplayTitle] [bit] NOT NULL CONSTRAINT [DF_dnn_TabModules_DisplayTitle]  DEFAULT ((1)),
	[DisplayPrint] [bit] NOT NULL CONSTRAINT [DF_dnn_TabModules_DisplayPrint]  DEFAULT ((1)),
	[DisplaySyndicate] [bit] NOT NULL CONSTRAINT [DF_dnn_TabModules_DisplaySyndicate]  DEFAULT ((1)),
 CONSTRAINT [PK_dnn_TabModules] PRIMARY KEY CLUSTERED 
(
	[TabModuleID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_TabModules] UNIQUE NONCLUSTERED 
(
	[TabID] ASC,
	[ModuleID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Links]    Script Date: 10/05/2007 21:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Links](
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
/****** Object:  Table [dbo].[dnn_SearchItem]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_SearchItem](
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
 CONSTRAINT [PK_dnn_SearchItem] PRIMARY KEY CLUSTERED 
(
	[SearchItemID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_VendorClassification]    Script Date: 10/05/2007 21:16:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_VendorClassification](
	[VendorClassificationId] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NOT NULL,
	[ClassificationId] [int] NOT NULL,
 CONSTRAINT [PK_dnn_VendorClassification] PRIMARY KEY CLUSTERED 
(
	[VendorClassificationId] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_VendorClassification] UNIQUE NONCLUSTERED 
(
	[VendorId] ASC,
	[ClassificationId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_SearchItemWord]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_SearchItemWord](
	[SearchItemWordID] [int] IDENTITY(1,1) NOT NULL,
	[SearchItemID] [int] NOT NULL,
	[SearchWordsID] [int] NOT NULL,
	[Occurrences] [int] NOT NULL,
 CONSTRAINT [PK_dnn_SearchItemWords] PRIMARY KEY CLUSTERED 
(
	[SearchItemWordID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_SearchItemWord] UNIQUE NONCLUSTERED 
(
	[SearchItemID] ASC,
	[SearchWordsID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_ModuleControls]    Script Date: 10/05/2007 21:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_ModuleControls](
	[ModuleControlID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleDefID] [int] NULL,
	[ControlKey] [nvarchar](50) NULL,
	[ControlTitle] [nvarchar](50) NULL,
	[ControlSrc] [nvarchar](256) NULL,
	[IconFile] [nvarchar](100) NULL,
	[ControlType] [int] NOT NULL,
	[ViewOrder] [int] NULL,
	[HelpUrl] [nvarchar](200) NULL,
 CONSTRAINT [PK_dnn_ModuleControls] PRIMARY KEY CLUSTERED 
(
	[ModuleControlID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_ModuleControls] UNIQUE NONCLUSTERED 
(
	[ModuleDefID] ASC,
	[ControlKey] ASC,
	[ControlSrc] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Modules]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Modules](
	[ModuleID] [int] IDENTITY(0,1) NOT NULL,
	[ModuleDefID] [int] NOT NULL,
	[ModuleTitle] [nvarchar](256) NULL,
	[AllTabs] [bit] NOT NULL CONSTRAINT [DF_dnn_Modules_AllTabs]  DEFAULT ((0)),
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_dnn_Modules_IsDeleted]  DEFAULT ((0)),
	[InheritViewPermissions] [bit] NULL,
	[Header] [ntext] NULL,
	[Footer] [ntext] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[PortalID] [int] NULL,
 CONSTRAINT [PK_dnn_Modules] PRIMARY KEY NONCLUSTERED 
(
	[ModuleID] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_UserProfile]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_UserProfile](
	[ProfileID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[PropertyDefinitionID] [int] NOT NULL,
	[PropertyValue] [nvarchar](3750) NULL,
	[PropertyText] [ntext] NULL,
	[Visibility] [int] NOT NULL CONSTRAINT [DF__dnn_UserP__Visib__1352D76D]  DEFAULT ((0)),
	[LastUpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dnn_UserProfile] PRIMARY KEY NONCLUSTERED 
(
	[ProfileID] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_TabPermission]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_TabPermission](
	[TabPermissionID] [int] IDENTITY(1,1) NOT NULL,
	[TabID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
 CONSTRAINT [PK_dnn_TabPermission] PRIMARY KEY CLUSTERED 
(
	[TabPermissionID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Banners]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Banners](
	[BannerId] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NOT NULL,
	[ImageFile] [nvarchar](100) NULL,
	[BannerName] [nvarchar](100) NOT NULL,
	[Impressions] [int] NOT NULL,
	[CPM] [float] NOT NULL,
	[Views] [int] NOT NULL CONSTRAINT [DF_dnn_Banners_Views]  DEFAULT ((0)),
	[ClickThroughs] [int] NOT NULL CONSTRAINT [DF_dnn_Banners_ClickThroughs]  DEFAULT ((0)),
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreatedByUser] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[BannerTypeId] [int] NULL,
	[Description] [nvarchar](2000) NULL,
	[GroupName] [nvarchar](100) NULL,
	[Criteria] [bit] NOT NULL CONSTRAINT [DF_dnn_Banners_Criteria]  DEFAULT ((1)),
	[URL] [nvarchar](255) NULL,
	[Width] [int] NOT NULL CONSTRAINT [DF_dnn_Banners_Width]  DEFAULT ((0)),
	[Height] [int] NOT NULL CONSTRAINT [DF_dnn_Banners_Height]  DEFAULT ((0)),
 CONSTRAINT [PK_dnn_Banner] PRIMARY KEY CLUSTERED 
(
	[BannerId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Affiliates]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Affiliates](
	[AffiliateId] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CPC] [float] NOT NULL,
	[Clicks] [int] NOT NULL,
	[CPA] [float] NOT NULL,
	[Acquisitions] [int] NOT NULL,
 CONSTRAINT [PK_dnn_Affiliates] PRIMARY KEY CLUSTERED 
(
	[AffiliateId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_SearchItemWordPosition]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_SearchItemWordPosition](
	[SearchItemWordPositionID] [int] IDENTITY(1,1) NOT NULL,
	[SearchItemWordID] [int] NOT NULL,
	[ContentPosition] [int] NOT NULL,
 CONSTRAINT [PK_dnn_SearchItemWordPosition] PRIMARY KEY CLUSTERED 
(
	[SearchItemWordPositionID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_EventLogConfig]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_EventLogConfig](
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
 CONSTRAINT [PK_dnn_EventLogConfig] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_EventLog]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_EventLog](
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
/****** Object:  Table [dbo].[dnn_UrlLog]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_UrlLog](
	[UrlLogID] [int] IDENTITY(1,1) NOT NULL,
	[UrlTrackingID] [int] NOT NULL,
	[ClickDate] [datetime] NOT NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_dnn_UrlLog] PRIMARY KEY CLUSTERED 
(
	[UrlLogID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_FolderPermission]    Script Date: 10/05/2007 21:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_FolderPermission](
	[FolderPermissionID] [int] IDENTITY(1,1) NOT NULL,
	[FolderID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[AllowAccess] [bit] NOT NULL,
 CONSTRAINT [PK_dnn_FolderPermission] PRIMARY KEY CLUSTERED 
(
	[FolderPermissionID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Files]    Script Date: 10/05/2007 21:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Files](
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
 CONSTRAINT [PK_dnn_File] PRIMARY KEY CLUSTERED 
(
	[FileId] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Vendors]    Script Date: 10/05/2007 21:16:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Vendors](
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
	[ClickThroughs] [int] NOT NULL CONSTRAINT [DF_dnn_Vendors_ClickThroughs]  DEFAULT ((0)),
	[Views] [int] NOT NULL CONSTRAINT [DF_dnn_Vendors_Views]  DEFAULT ((0)),
	[CreatedByUser] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[LogoFile] [nvarchar](100) NULL,
	[KeyWords] [ntext] NULL,
	[Unit] [nvarchar](50) NULL,
	[Authorized] [bit] NOT NULL CONSTRAINT [DF_dnn_Vendors_Authorized]  DEFAULT ((1)),
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Cell] [varchar](50) NULL,
 CONSTRAINT [PK_dnn_Vendor] PRIMARY KEY CLUSTERED 
(
	[VendorId] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_Vendors] UNIQUE NONCLUSTERED 
(
	[PortalId] ASC,
	[VendorName] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_UrlTracking]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_UrlTracking](
	[UrlTrackingID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[Url] [nvarchar](255) NOT NULL,
	[UrlType] [char](1) NOT NULL,
	[Clicks] [int] NOT NULL,
	[LastClick] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LogActivity] [bit] NOT NULL,
	[TrackClicks] [bit] NOT NULL CONSTRAINT [DF_dnn_UrlTracking_TrackClicks]  DEFAULT ((1)),
	[ModuleId] [int] NULL,
	[NewWindow] [bit] NOT NULL CONSTRAINT [DF_dnn_UrlTracking_NewWindow]  DEFAULT ((0)),
 CONSTRAINT [PK_dnn_UrlTracking] PRIMARY KEY CLUSTERED 
(
	[UrlTrackingID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_UrlTracking] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[Url] ASC,
	[ModuleId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Urls]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Urls](
	[UrlID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[Url] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_dnn_Urls] PRIMARY KEY CLUSTERED 
(
	[UrlID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_Urls] UNIQUE NONCLUSTERED 
(
	[Url] ASC,
	[PortalID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Profile]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Profile](
	[ProfileId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[PortalId] [int] NOT NULL,
	[ProfileData] [ntext] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dnn_Profile] PRIMARY KEY CLUSTERED 
(
	[ProfileId] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_PortalAlias]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_PortalAlias](
	[PortalAliasID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[HTTPAlias] [nvarchar](200) NULL,
 CONSTRAINT [PK_dnn_PortalAlias] PRIMARY KEY CLUSTERED 
(
	[PortalAliasID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_PortalAlias] UNIQUE NONCLUSTERED 
(
	[HTTPAlias] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_SystemMessages]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_SystemMessages](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[MessageName] [nvarchar](50) NOT NULL,
	[MessageValue] [ntext] NOT NULL,
 CONSTRAINT [PK_dnn_SystemMessages] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_SystemMessages] UNIQUE NONCLUSTERED 
(
	[MessageName] ASC,
	[PortalID] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Folders]    Script Date: 10/05/2007 21:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Folders](
	[FolderID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[FolderPath] [varchar](300) NOT NULL,
	[StorageLocation] [int] NOT NULL CONSTRAINT [DF_dnn_Folders_StorageLocation]  DEFAULT ((0)),
	[IsProtected] [bit] NOT NULL CONSTRAINT [DF_dnn_Folders_IsProtected]  DEFAULT ((0)),
	[IsCached] [bit] NOT NULL CONSTRAINT [DF_dnn_Folders_IsCached]  DEFAULT ((0)),
	[LastUpdated] [datetime] NULL,
 CONSTRAINT [PK_dnn_Folders] PRIMARY KEY CLUSTERED 
(
	[FolderID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Skins]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Skins](
	[SkinID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[SkinRoot] [nvarchar](50) NOT NULL,
	[SkinSrc] [nvarchar](200) NOT NULL,
	[SkinType] [int] NOT NULL,
 CONSTRAINT [PK_dnn_Skins] PRIMARY KEY CLUSTERED 
(
	[SkinID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_ProfilePropertyDefinition]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_ProfilePropertyDefinition](
	[PropertyDefinitionID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NULL,
	[ModuleDefID] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[DataType] [int] NOT NULL,
	[DefaultValue] [nvarchar](50) NULL,
	[PropertyCategory] [nvarchar](50) NOT NULL,
	[PropertyName] [nvarchar](50) NOT NULL,
	[Length] [int] NOT NULL CONSTRAINT [DF_dnn_ProfilePropertyDefinition_Length]  DEFAULT ((0)),
	[Required] [bit] NOT NULL,
	[ValidationExpression] [nvarchar](2000) NULL,
	[ViewOrder] [int] NOT NULL,
	[Visible] [bit] NOT NULL,
 CONSTRAINT [PK_dnn_ProfilePropertyDefinition] PRIMARY KEY CLUSTERED 
(
	[PropertyDefinitionID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_AnonymousUsers]    Script Date: 10/05/2007 21:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_AnonymousUsers](
	[UserID] [char](36) NOT NULL,
	[PortalID] [int] NOT NULL,
	[TabID] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_dnn_AnonymousUsers_CreationDate]  DEFAULT (getdate()),
	[LastActiveDate] [datetime] NOT NULL CONSTRAINT [DF_dnn_AnonymousUsers_LastActiveDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_dnn_AnonymousUsers] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[PortalID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_UsersOnline]    Script Date: 10/05/2007 21:16:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_UsersOnline](
	[UserID] [int] NOT NULL,
	[PortalID] [int] NOT NULL,
	[TabID] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__dnn_Users__Creat__3BFFE745]  DEFAULT (getdate()),
	[LastActiveDate] [datetime] NOT NULL CONSTRAINT [DF__dnn_Users__LastA__3CF40B7E]  DEFAULT (getdate()),
 CONSTRAINT [PK_dnn_UsersOnline] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[PortalID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_PortalDesktopModules]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_PortalDesktopModules](
	[PortalDesktopModuleID] [int] IDENTITY(1,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[DesktopModuleID] [int] NOT NULL,
 CONSTRAINT [PK_dnn_PortalDesktopModules] PRIMARY KEY CLUSTERED 
(
	[PortalDesktopModuleID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_PortalDesktopModules] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[DesktopModuleID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_Tabs]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_Tabs](
	[TabID] [int] IDENTITY(0,1) NOT NULL,
	[TabOrder] [int] NOT NULL CONSTRAINT [DF_dnn_Tabs_TabOrder]  DEFAULT ((0)),
	[PortalID] [int] NULL,
	[TabName] [nvarchar](50) NOT NULL,
	[IsVisible] [bit] NOT NULL CONSTRAINT [DF_dnn_Tabs_IsVisible]  DEFAULT ((1)),
	[ParentId] [int] NULL,
	[Level] [int] NOT NULL CONSTRAINT [DF_dnn_Tabs_Level]  DEFAULT ((0)),
	[IconFile] [nvarchar](100) NULL,
	[DisableLink] [bit] NOT NULL CONSTRAINT [DF_dnn_Tabs_DisableLink]  DEFAULT ((0)),
	[Title] [nvarchar](200) NULL,
	[Description] [nvarchar](500) NULL,
	[KeyWords] [nvarchar](500) NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_dnn_Tabs_IsDeleted]  DEFAULT ((0)),
	[Url] [nvarchar](255) NULL,
	[SkinSrc] [nvarchar](200) NULL,
	[ContainerSrc] [nvarchar](200) NULL,
	[TabPath] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[RefreshInterval] [int] NULL,
	[PageHeadText] [nvarchar](500) NULL,
 CONSTRAINT [PK_dnn_Tabs] PRIMARY KEY CLUSTERED 
(
	[TabID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_UserPortals]    Script Date: 10/05/2007 21:16:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_UserPortals](
	[UserId] [int] NOT NULL,
	[PortalId] [int] NOT NULL,
	[UserPortalId] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_dnn_UserPortals_CreatedDate]  DEFAULT (getdate()),
	[Authorised] [bit] NOT NULL CONSTRAINT [DF_dnn_UserPortals_Authorised]  DEFAULT ((1)),
 CONSTRAINT [PK_dnn_UserPortals] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[PortalId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_SiteLog]    Script Date: 10/05/2007 21:16:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_SiteLog](
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
 CONSTRAINT [PK_dnn_SiteLog] PRIMARY KEY CLUSTERED 
(
	[SiteLogId] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_RoleGroups]    Script Date: 10/05/2007 21:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_RoleGroups](
	[RoleGroupID] [int] IDENTITY(0,1) NOT NULL,
	[PortalID] [int] NOT NULL,
	[RoleGroupName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](1000) NULL,
 CONSTRAINT [PK_dnn_RoleGroups] PRIMARY KEY NONCLUSTERED 
(
	[RoleGroupID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_RoleGroupName] UNIQUE NONCLUSTERED 
(
	[PortalID] ASC,
	[RoleGroupName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dnn_ModuleDefinitions]    Script Date: 10/05/2007 21:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dnn_ModuleDefinitions](
	[ModuleDefID] [int] IDENTITY(1,1) NOT NULL,
	[FriendlyName] [nvarchar](128) NOT NULL,
	[DesktopModuleID] [int] NOT NULL,
	[DefaultCacheTime] [int] NOT NULL CONSTRAINT [DF_dnn_ModuleDefinitions_DefaultCacheTime]  DEFAULT ((0)),
 CONSTRAINT [PK_dnn_ModuleDefinitions] PRIMARY KEY NONCLUSTERED 
(
	[ModuleDefID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_dnn_ModuleDefinitions] UNIQUE NONCLUSTERED 
(
	[FriendlyName] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  ForeignKey [FK_dnn_Affiliates_dnn_Vendors]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE [dbo].[dnn_Affiliates]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Affiliates_dnn_Vendors] FOREIGN KEY([VendorId])
REFERENCES [dbo].[dnn_Vendors] ([VendorId])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Affiliates] CHECK CONSTRAINT [FK_dnn_Affiliates_dnn_Vendors]
GO
/****** Object:  ForeignKey [FK_dnn_AnonymousUsers_dnn_Portals]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE [dbo].[dnn_AnonymousUsers]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_AnonymousUsers_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_AnonymousUsers] CHECK CONSTRAINT [FK_dnn_AnonymousUsers_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_Banner_dnn_Vendor]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE [dbo].[dnn_Banners]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Banner_dnn_Vendor] FOREIGN KEY([VendorId])
REFERENCES [dbo].[dnn_Vendors] ([VendorId])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Banners] CHECK CONSTRAINT [FK_dnn_Banner_dnn_Vendor]
GO
/****** Object:  ForeignKey [FK_dnn_Classification_dnn_Classification]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE [dbo].[dnn_Classification]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Classification_dnn_Classification] FOREIGN KEY([ParentId])
REFERENCES [dbo].[dnn_Classification] ([ClassificationId])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Classification] CHECK CONSTRAINT [FK_dnn_Classification_dnn_Classification]
GO
/****** Object:  ForeignKey [FK_dnn_EventLog_dnn_EventLogConfig]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE [dbo].[dnn_EventLog]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_EventLog_dnn_EventLogConfig] FOREIGN KEY([LogConfigID])
REFERENCES [dbo].[dnn_EventLogConfig] ([ID])
GO
ALTER TABLE [dbo].[dnn_EventLog] CHECK CONSTRAINT [FK_dnn_EventLog_dnn_EventLogConfig]
GO
/****** Object:  ForeignKey [FK_dnn_EventLog_dnn_EventLogTypes]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE [dbo].[dnn_EventLog]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_EventLog_dnn_EventLogTypes] FOREIGN KEY([LogTypeKey])
REFERENCES [dbo].[dnn_EventLogTypes] ([LogTypeKey])
GO
ALTER TABLE [dbo].[dnn_EventLog] CHECK CONSTRAINT [FK_dnn_EventLog_dnn_EventLogTypes]
GO
/****** Object:  ForeignKey [FK_dnn_EventLogConfig_dnn_EventLogTypes]    Script Date: 10/05/2007 21:16:44 ******/
ALTER TABLE [dbo].[dnn_EventLogConfig]  WITH CHECK ADD  CONSTRAINT [FK_dnn_EventLogConfig_dnn_EventLogTypes] FOREIGN KEY([LogTypeKey])
REFERENCES [dbo].[dnn_EventLogTypes] ([LogTypeKey])
GO
ALTER TABLE [dbo].[dnn_EventLogConfig] CHECK CONSTRAINT [FK_dnn_EventLogConfig_dnn_EventLogTypes]
GO
/****** Object:  ForeignKey [FK_dnn_Files_dnn_Folders]    Script Date: 10/05/2007 21:16:45 ******/
ALTER TABLE [dbo].[dnn_Files]  WITH CHECK ADD  CONSTRAINT [FK_dnn_Files_dnn_Folders] FOREIGN KEY([FolderID])
REFERENCES [dbo].[dnn_Folders] ([FolderID])
GO
ALTER TABLE [dbo].[dnn_Files] CHECK CONSTRAINT [FK_dnn_Files_dnn_Folders]
GO
/****** Object:  ForeignKey [FK_dnn_Files_dnn_Portals]    Script Date: 10/05/2007 21:16:45 ******/
ALTER TABLE [dbo].[dnn_Files]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Files_dnn_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Files] CHECK CONSTRAINT [FK_dnn_Files_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_FolderPermission_dnn_Folders]    Script Date: 10/05/2007 21:16:45 ******/
ALTER TABLE [dbo].[dnn_FolderPermission]  WITH CHECK ADD  CONSTRAINT [FK_dnn_FolderPermission_dnn_Folders] FOREIGN KEY([FolderID])
REFERENCES [dbo].[dnn_Folders] ([FolderID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_FolderPermission] CHECK CONSTRAINT [FK_dnn_FolderPermission_dnn_Folders]
GO
/****** Object:  ForeignKey [FK_dnn_FolderPermission_dnn_Permission]    Script Date: 10/05/2007 21:16:45 ******/
ALTER TABLE [dbo].[dnn_FolderPermission]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_FolderPermission_dnn_Permission] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[dnn_Permission] ([PermissionID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_FolderPermission] CHECK CONSTRAINT [FK_dnn_FolderPermission_dnn_Permission]
GO
/****** Object:  ForeignKey [FK_dnn_Folders_dnn_Portals]    Script Date: 10/05/2007 21:16:45 ******/
ALTER TABLE [dbo].[dnn_Folders]  WITH CHECK ADD  CONSTRAINT [FK_dnn_Folders_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_Folders] CHECK CONSTRAINT [FK_dnn_Folders_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_HtmlText_dnn_Modules]    Script Date: 10/05/2007 21:16:47 ******/
ALTER TABLE [dbo].[dnn_HtmlText]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_HtmlText_dnn_Modules] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[dnn_Modules] ([ModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_HtmlText] CHECK CONSTRAINT [FK_dnn_HtmlText_dnn_Modules]
GO
/****** Object:  ForeignKey [FK__dnn_Links__Modul__0F824689]    Script Date: 10/05/2007 21:16:50 ******/
ALTER TABLE [dbo].[dnn_Links]  WITH NOCHECK ADD FOREIGN KEY([ModuleID])
REFERENCES [dbo].[dnn_Modules] ([ModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
/****** Object:  ForeignKey [FK_dnn_ModuleControls_dnn_ModuleDefinitions]    Script Date: 10/05/2007 21:16:50 ******/
ALTER TABLE [dbo].[dnn_ModuleControls]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_ModuleControls_dnn_ModuleDefinitions] FOREIGN KEY([ModuleDefID])
REFERENCES [dbo].[dnn_ModuleDefinitions] ([ModuleDefID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_ModuleControls] CHECK CONSTRAINT [FK_dnn_ModuleControls_dnn_ModuleDefinitions]
GO
/****** Object:  ForeignKey [FK_dnn_ModuleDefinitions_dnn_DesktopModules]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE [dbo].[dnn_ModuleDefinitions]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_ModuleDefinitions_dnn_DesktopModules] FOREIGN KEY([DesktopModuleID])
REFERENCES [dbo].[dnn_DesktopModules] ([DesktopModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_ModuleDefinitions] CHECK CONSTRAINT [FK_dnn_ModuleDefinitions_dnn_DesktopModules]
GO
/****** Object:  ForeignKey [FK_dnn_ModulePermission_dnn_Modules]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE [dbo].[dnn_ModulePermission]  WITH CHECK ADD  CONSTRAINT [FK_dnn_ModulePermission_dnn_Modules] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[dnn_Modules] ([ModuleID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_ModulePermission] CHECK CONSTRAINT [FK_dnn_ModulePermission_dnn_Modules]
GO
/****** Object:  ForeignKey [FK_dnn_ModulePermission_dnn_Permission]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE [dbo].[dnn_ModulePermission]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_ModulePermission_dnn_Permission] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[dnn_Permission] ([PermissionID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_ModulePermission] CHECK CONSTRAINT [FK_dnn_ModulePermission_dnn_Permission]
GO
/****** Object:  ForeignKey [FK_dnn_Modules_dnn_ModuleDefinitions]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE [dbo].[dnn_Modules]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Modules_dnn_ModuleDefinitions] FOREIGN KEY([ModuleDefID])
REFERENCES [dbo].[dnn_ModuleDefinitions] ([ModuleDefID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Modules] CHECK CONSTRAINT [FK_dnn_Modules_dnn_ModuleDefinitions]
GO
/****** Object:  ForeignKey [FK_dnn_Modules_dnn_Portals]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE [dbo].[dnn_Modules]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Modules_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Modules] CHECK CONSTRAINT [FK_dnn_Modules_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_ModuleSettings_dnn_Modules]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE [dbo].[dnn_ModuleSettings]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_ModuleSettings_dnn_Modules] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[dnn_Modules] ([ModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_ModuleSettings] CHECK CONSTRAINT [FK_dnn_ModuleSettings_dnn_Modules]
GO
/****** Object:  ForeignKey [FK_dnn_PortalAlias_dnn_Portals]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE [dbo].[dnn_PortalAlias]  WITH CHECK ADD  CONSTRAINT [FK_dnn_PortalAlias_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_PortalAlias] CHECK CONSTRAINT [FK_dnn_PortalAlias_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_PortalDesktopModules_dnn_DesktopModules]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE [dbo].[dnn_PortalDesktopModules]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_PortalDesktopModules_dnn_DesktopModules] FOREIGN KEY([DesktopModuleID])
REFERENCES [dbo].[dnn_DesktopModules] ([DesktopModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_PortalDesktopModules] CHECK CONSTRAINT [FK_dnn_PortalDesktopModules_dnn_DesktopModules]
GO
/****** Object:  ForeignKey [FK_dnn_PortalDesktopModules_dnn_Portals]    Script Date: 10/05/2007 21:16:51 ******/
ALTER TABLE [dbo].[dnn_PortalDesktopModules]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_PortalDesktopModules_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_PortalDesktopModules] CHECK CONSTRAINT [FK_dnn_PortalDesktopModules_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_Profile_dnn_Portals]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE [dbo].[dnn_Profile]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Profile_dnn_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Profile] CHECK CONSTRAINT [FK_dnn_Profile_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_Profile_dnn_Users]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE [dbo].[dnn_Profile]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Profile_dnn_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[dnn_Users] ([UserID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Profile] CHECK CONSTRAINT [FK_dnn_Profile_dnn_Users]
GO
/****** Object:  ForeignKey [FK_dnn_ProfilePropertyDefinition_dnn_Portals]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE [dbo].[dnn_ProfilePropertyDefinition]  WITH CHECK ADD  CONSTRAINT [FK_dnn_ProfilePropertyDefinition_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_ProfilePropertyDefinition] CHECK CONSTRAINT [FK_dnn_ProfilePropertyDefinition_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_RoleGroups_dnn_Portals]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE [dbo].[dnn_RoleGroups]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_RoleGroups_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_RoleGroups] CHECK CONSTRAINT [FK_dnn_RoleGroups_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_Roles_dnn_Portals]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE [dbo].[dnn_Roles]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Roles_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Roles] CHECK CONSTRAINT [FK_dnn_Roles_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_Roles_dnn_RoleGroups]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE [dbo].[dnn_Roles]  WITH CHECK ADD  CONSTRAINT [FK_dnn_Roles_dnn_RoleGroups] FOREIGN KEY([RoleGroupID])
REFERENCES [dbo].[dnn_RoleGroups] ([RoleGroupID])
GO
ALTER TABLE [dbo].[dnn_Roles] CHECK CONSTRAINT [FK_dnn_Roles_dnn_RoleGroups]
GO
/****** Object:  ForeignKey [FK_dnn_ScheduleHistory_dnn_Schedule]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE [dbo].[dnn_ScheduleHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_ScheduleHistory_dnn_Schedule] FOREIGN KEY([ScheduleID])
REFERENCES [dbo].[dnn_Schedule] ([ScheduleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_ScheduleHistory] CHECK CONSTRAINT [FK_dnn_ScheduleHistory_dnn_Schedule]
GO
/****** Object:  ForeignKey [FK_dnn_ScheduleItemSettings_dnn_Schedule]    Script Date: 10/05/2007 21:16:52 ******/
ALTER TABLE [dbo].[dnn_ScheduleItemSettings]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_ScheduleItemSettings_dnn_Schedule] FOREIGN KEY([ScheduleID])
REFERENCES [dbo].[dnn_Schedule] ([ScheduleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_ScheduleItemSettings] CHECK CONSTRAINT [FK_dnn_ScheduleItemSettings_dnn_Schedule]
GO
/****** Object:  ForeignKey [FK_dnn_SearchItem_dnn_Modules]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE [dbo].[dnn_SearchItem]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_SearchItem_dnn_Modules] FOREIGN KEY([ModuleId])
REFERENCES [dbo].[dnn_Modules] ([ModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_SearchItem] CHECK CONSTRAINT [FK_dnn_SearchItem_dnn_Modules]
GO
/****** Object:  ForeignKey [FK_dnn_SearchItemWord_dnn_SearchItem]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE [dbo].[dnn_SearchItemWord]  WITH CHECK ADD  CONSTRAINT [FK_dnn_SearchItemWord_dnn_SearchItem] FOREIGN KEY([SearchItemID])
REFERENCES [dbo].[dnn_SearchItem] ([SearchItemID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_SearchItemWord] CHECK CONSTRAINT [FK_dnn_SearchItemWord_dnn_SearchItem]
GO
/****** Object:  ForeignKey [FK_dnn_SearchItemWord_dnn_SearchWord]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE [dbo].[dnn_SearchItemWord]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_SearchItemWord_dnn_SearchWord] FOREIGN KEY([SearchWordsID])
REFERENCES [dbo].[dnn_SearchWord] ([SearchWordsID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_SearchItemWord] CHECK CONSTRAINT [FK_dnn_SearchItemWord_dnn_SearchWord]
GO
/****** Object:  ForeignKey [FK_dnn_SearchItemWordPosition_dnn_SearchItemWord]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE [dbo].[dnn_SearchItemWordPosition]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_SearchItemWordPosition_dnn_SearchItemWord] FOREIGN KEY([SearchItemWordID])
REFERENCES [dbo].[dnn_SearchItemWord] ([SearchItemWordID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_SearchItemWordPosition] CHECK CONSTRAINT [FK_dnn_SearchItemWordPosition_dnn_SearchItemWord]
GO
/****** Object:  ForeignKey [FK_dnn_SiteLog_dnn_Portals]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE [dbo].[dnn_SiteLog]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_SiteLog_dnn_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_SiteLog] CHECK CONSTRAINT [FK_dnn_SiteLog_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_Skins_dnn_Portals]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE [dbo].[dnn_Skins]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Skins_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Skins] CHECK CONSTRAINT [FK_dnn_Skins_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_SystemMessages_dnn_Portals]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE [dbo].[dnn_SystemMessages]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_SystemMessages_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_SystemMessages] CHECK CONSTRAINT [FK_dnn_SystemMessages_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_TabModules_dnn_Modules]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE [dbo].[dnn_TabModules]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_TabModules_dnn_Modules] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[dnn_Modules] ([ModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_TabModules] CHECK CONSTRAINT [FK_dnn_TabModules_dnn_Modules]
GO
/****** Object:  ForeignKey [FK_dnn_TabModules_dnn_Tabs]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE [dbo].[dnn_TabModules]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_TabModules_dnn_Tabs] FOREIGN KEY([TabID])
REFERENCES [dbo].[dnn_Tabs] ([TabID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_TabModules] CHECK CONSTRAINT [FK_dnn_TabModules_dnn_Tabs]
GO
/****** Object:  ForeignKey [FK_dnn_TabModuleSettings_dnn_TabModules]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE [dbo].[dnn_TabModuleSettings]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_TabModuleSettings_dnn_TabModules] FOREIGN KEY([TabModuleID])
REFERENCES [dbo].[dnn_TabModules] ([TabModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_TabModuleSettings] CHECK CONSTRAINT [FK_dnn_TabModuleSettings_dnn_TabModules]
GO
/****** Object:  ForeignKey [FK_dnn_TabPermission_dnn_Permission]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE [dbo].[dnn_TabPermission]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_TabPermission_dnn_Permission] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[dnn_Permission] ([PermissionID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_TabPermission] CHECK CONSTRAINT [FK_dnn_TabPermission_dnn_Permission]
GO
/****** Object:  ForeignKey [FK_dnn_TabPermission_dnn_Tabs]    Script Date: 10/05/2007 21:16:53 ******/
ALTER TABLE [dbo].[dnn_TabPermission]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_TabPermission_dnn_Tabs] FOREIGN KEY([TabID])
REFERENCES [dbo].[dnn_Tabs] ([TabID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_TabPermission] CHECK CONSTRAINT [FK_dnn_TabPermission_dnn_Tabs]
GO
/****** Object:  ForeignKey [FK_dnn_Tabs_dnn_Portals]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE [dbo].[dnn_Tabs]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Tabs_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Tabs] CHECK CONSTRAINT [FK_dnn_Tabs_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_Tabs_dnn_Tabs]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE [dbo].[dnn_Tabs]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Tabs_dnn_Tabs] FOREIGN KEY([ParentId])
REFERENCES [dbo].[dnn_Tabs] ([TabID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Tabs] CHECK CONSTRAINT [FK_dnn_Tabs_dnn_Tabs]
GO
/****** Object:  ForeignKey [FK_dnn_UrlLog_dnn_UrlTracking]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE [dbo].[dnn_UrlLog]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_UrlLog_dnn_UrlTracking] FOREIGN KEY([UrlTrackingID])
REFERENCES [dbo].[dnn_UrlTracking] ([UrlTrackingID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_UrlLog] CHECK CONSTRAINT [FK_dnn_UrlLog_dnn_UrlTracking]
GO
/****** Object:  ForeignKey [FK_dnn_Urls_dnn_Portals]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE [dbo].[dnn_Urls]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Urls_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Urls] CHECK CONSTRAINT [FK_dnn_Urls_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_UrlTracking_dnn_Portals]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE [dbo].[dnn_UrlTracking]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_UrlTracking_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_UrlTracking] CHECK CONSTRAINT [FK_dnn_UrlTracking_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_UserPortals_dnn_Portals]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE [dbo].[dnn_UserPortals]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_UserPortals_dnn_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_UserPortals] CHECK CONSTRAINT [FK_dnn_UserPortals_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_UserPortals_dnn_Users]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE [dbo].[dnn_UserPortals]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_UserPortals_dnn_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[dnn_Users] ([UserID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_UserPortals] CHECK CONSTRAINT [FK_dnn_UserPortals_dnn_Users]
GO
/****** Object:  ForeignKey [FK_dnn_UserProfile_dnn_ProfilePropertyDefinition]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE [dbo].[dnn_UserProfile]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_UserProfile_dnn_ProfilePropertyDefinition] FOREIGN KEY([PropertyDefinitionID])
REFERENCES [dbo].[dnn_ProfilePropertyDefinition] ([PropertyDefinitionID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_UserProfile] CHECK CONSTRAINT [FK_dnn_UserProfile_dnn_ProfilePropertyDefinition]
GO
/****** Object:  ForeignKey [FK_dnn_UserProfile_dnn_Users]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE [dbo].[dnn_UserProfile]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_UserProfile_dnn_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[dnn_Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dnn_UserProfile] CHECK CONSTRAINT [FK_dnn_UserProfile_dnn_Users]
GO
/****** Object:  ForeignKey [FK_dnn_UserRoles_dnn_Roles]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE [dbo].[dnn_UserRoles]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_UserRoles_dnn_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[dnn_Roles] ([RoleID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_UserRoles] CHECK CONSTRAINT [FK_dnn_UserRoles_dnn_Roles]
GO
/****** Object:  ForeignKey [FK_dnn_UserRoles_dnn_Users]    Script Date: 10/05/2007 21:16:54 ******/
ALTER TABLE [dbo].[dnn_UserRoles]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_UserRoles_dnn_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[dnn_Users] ([UserID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_UserRoles] CHECK CONSTRAINT [FK_dnn_UserRoles_dnn_Users]
GO
/****** Object:  ForeignKey [FK_dnn_UsersOnline_dnn_Portals]    Script Date: 10/05/2007 21:16:55 ******/
ALTER TABLE [dbo].[dnn_UsersOnline]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_UsersOnline_dnn_Portals] FOREIGN KEY([PortalID])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_UsersOnline] CHECK CONSTRAINT [FK_dnn_UsersOnline_dnn_Portals]
GO
/****** Object:  ForeignKey [FK_dnn_UsersOnline_dnn_Users]    Script Date: 10/05/2007 21:16:55 ******/
ALTER TABLE [dbo].[dnn_UsersOnline]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_UsersOnline_dnn_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[dnn_Users] ([UserID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_UsersOnline] CHECK CONSTRAINT [FK_dnn_UsersOnline_dnn_Users]
GO
/****** Object:  ForeignKey [FK_dnn_VendorClassification_dnn_Classification]    Script Date: 10/05/2007 21:16:55 ******/
ALTER TABLE [dbo].[dnn_VendorClassification]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_VendorClassification_dnn_Classification] FOREIGN KEY([ClassificationId])
REFERENCES [dbo].[dnn_Classification] ([ClassificationId])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_VendorClassification] CHECK CONSTRAINT [FK_dnn_VendorClassification_dnn_Classification]
GO
/****** Object:  ForeignKey [FK_dnn_VendorClassification_dnn_Vendors]    Script Date: 10/05/2007 21:16:55 ******/
ALTER TABLE [dbo].[dnn_VendorClassification]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_VendorClassification_dnn_Vendors] FOREIGN KEY([VendorId])
REFERENCES [dbo].[dnn_Vendors] ([VendorId])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_VendorClassification] CHECK CONSTRAINT [FK_dnn_VendorClassification_dnn_Vendors]
GO
/****** Object:  ForeignKey [FK_dnn_Vendor_dnn_Portals]    Script Date: 10/05/2007 21:16:55 ******/
ALTER TABLE [dbo].[dnn_Vendors]  WITH NOCHECK ADD  CONSTRAINT [FK_dnn_Vendor_dnn_Portals] FOREIGN KEY([PortalId])
REFERENCES [dbo].[dnn_Portals] ([PortalID])
ON DELETE CASCADE
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[dnn_Vendors] CHECK CONSTRAINT [FK_dnn_Vendor_dnn_Portals]
GO
