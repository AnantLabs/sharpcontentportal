﻿/************************************************************/
/*****              SqlDataProvider                     *****/
/*****                                                  *****/
/*****                                                  *****/
/***** Note: To manually execute this script you must   *****/
/*****       perform a search and replace operation     *****/
/*****       for {databaseOwner} and {objectQualifier}  *****/
/*****                                                  *****/
/************************************************************/

/** Remove SharpContent Objects **/

ALTER TABLE {databaseOwner}[{objectQualifier}TabModuleSettings] DROP CONSTRAINT [FK_{objectQualifier}TabModuleSettings_{objectQualifier}TabModules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Roles] DROP CONSTRAINT [FK_{objectQualifier}Roles_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs] DROP CONSTRAINT [FK_{objectQualifier}Tabs_{objectQualifier}Portals], CONSTRAINT [FK_{objectQualifier}Tabs_{objectQualifier}Tabs]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Profile] DROP CONSTRAINT [FK_{objectQualifier}Profile_{objectQualifier}Portals], CONSTRAINT [FK_{objectQualifier}Profile_{objectQualifier}Users]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWord] DROP CONSTRAINT [FK_{objectQualifier}SearchItemWord_{objectQualifier}SearchItem], CONSTRAINT [FK_{objectQualifier}SearchItemWord_{objectQualifier}SearchWord]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Modules] DROP CONSTRAINT [FK_{objectQualifier}Modules_{objectQualifier}ModuleDefinitions], CONSTRAINT [FK_{objectQualifier}Modules_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Folders] DROP CONSTRAINT [FK_{objectQualifier}Folders_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Affiliates] DROP CONSTRAINT [FK_{objectQualifier}Affiliates_{objectQualifier}Vendors]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserDefinedRows] DROP CONSTRAINT [FK_{objectQualifier}UserDefinedRows_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Classification] DROP CONSTRAINT [FK_{objectQualifier}Classification_{objectQualifier}Classification]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ScheduleHistory] DROP CONSTRAINT [FK_{objectQualifier}ScheduleHistory_{objectQualifier}Schedule]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Vendors] DROP CONSTRAINT [FK_{objectQualifier}Vendor_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserDefinedFields] DROP CONSTRAINT [FK_{objectQualifier}UserDefinedFields_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWordPosition] DROP CONSTRAINT [FK_{objectQualifier}SearchItemWordPosition_{objectQualifier}SearchItemWord]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Announcements] DROP CONSTRAINT [FK_{objectQualifier}Announcements_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Urls] DROP CONSTRAINT [FK_{objectQualifier}Urls_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalAlias] DROP CONSTRAINT [FK_{objectQualifier}PortalAlias_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlLog] DROP CONSTRAINT [FK_{objectQualifier}UrlLog_{objectQualifier}UrlTracking]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserRoles] DROP CONSTRAINT [FK_{objectQualifier}UserRoles_{objectQualifier}Roles], CONSTRAINT [FK_{objectQualifier}UserRoles_{objectQualifier}Users]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleSettings] DROP CONSTRAINT [FK_{objectQualifier}ModuleSettings_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Skins] DROP CONSTRAINT [FK_{objectQualifier}Skins_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SystemMessages] DROP CONSTRAINT [FK_{objectQualifier}SystemMessages_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModulePermission] DROP CONSTRAINT [FK_{objectQualifier}ModulePermission_{objectQualifier}Modules], CONSTRAINT [FK_{objectQualifier}ModulePermission_{objectQualifier}Permission]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules] DROP CONSTRAINT [FK_{objectQualifier}PortalDesktopModules_{objectQualifier}DesktopModules], CONSTRAINT [FK_{objectQualifier}PortalDesktopModules_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Links] DROP CONSTRAINT [FK_{objectQualifier}Links_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserPortals] DROP CONSTRAINT [FK_{objectQualifier}UserPortals_{objectQualifier}Portals], CONSTRAINT [FK_{objectQualifier}UserPortals_{objectQualifier}Users]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}HtmlText] DROP CONSTRAINT [FK_{objectQualifier}HtmlText_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UsersOnline] DROP CONSTRAINT [FK_{objectQualifier}UsersOnline_{objectQualifier}Portals], CONSTRAINT [FK_{objectQualifier}UsersOnline_{objectQualifier}Users]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleControls] DROP CONSTRAINT [FK_{objectQualifier}ModuleControls_{objectQualifier}ModuleDefinitions]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Discussion] DROP CONSTRAINT [FK_{objectQualifier}Discussion_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}FolderPermission] DROP CONSTRAINT [FK_{objectQualifier}FolderPermission_{objectQualifier}Folders], CONSTRAINT [FK_{objectQualifier}FolderPermission_{objectQualifier}Permission]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabPermission] DROP CONSTRAINT [FK_{objectQualifier}TabPermission_{objectQualifier}Permission], CONSTRAINT [FK_{objectQualifier}TabPermission_{objectQualifier}Tabs]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleDefinitions] DROP CONSTRAINT [FK_{objectQualifier}ModuleDefinitions_{objectQualifier}DesktopModules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Files] DROP CONSTRAINT [FK_{objectQualifier}Files_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserDefinedData] DROP CONSTRAINT [FK_{objectQualifier}UserDefinedData_{objectQualifier}UserDefinedFields], CONSTRAINT [FK_{objectQualifier}UserDefinedData_{objectQualifier}UserDefinedRows]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlTracking] DROP CONSTRAINT [FK_{objectQualifier}UrlTracking_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules] DROP CONSTRAINT [FK_{objectQualifier}TabModules_{objectQualifier}Modules], CONSTRAINT [FK_{objectQualifier}TabModules_{objectQualifier}Tabs]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}FAQs] DROP CONSTRAINT [FK_{objectQualifier}FAQs_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Events] DROP CONSTRAINT [FK_{objectQualifier}Events_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Documents] DROP CONSTRAINT [FK_{objectQualifier}Documents_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}VendorClassification] DROP CONSTRAINT [FK_{objectQualifier}VendorClassification_{objectQualifier}Classification], CONSTRAINT [FK_{objectQualifier}VendorClassification_{objectQualifier}Vendors]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SiteLog] DROP CONSTRAINT [FK_{objectQualifier}SiteLog_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItem] DROP CONSTRAINT [FK_{objectQualifier}SearchItem_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Contacts] DROP CONSTRAINT [FK_{objectQualifier}Contacts_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Banners] DROP CONSTRAINT [FK_{objectQualifier}Banner_{objectQualifier}Vendor]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ScheduleItemSettings] DROP CONSTRAINT [FK_{objectQualifier}ScheduleItemSettings_{objectQualifier}Schedule]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}AnonymousUsers] DROP CONSTRAINT [FK_{objectQualifier}AnonymousUsers_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Urls] DROP CONSTRAINT [PK_{objectQualifier}Urls]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Urls] DROP CONSTRAINT [IX_{objectQualifier}Urls]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Roles] DROP CONSTRAINT [PK_{objectQualifier}Roles]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Roles] DROP CONSTRAINT [IX_{objectQualifier}RoleName]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Roles] DROP CONSTRAINT [DF_{objectQualifier}Roles_ServiceFee]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Roles] DROP CONSTRAINT [DF_{objectQualifier}Roles_IsPublic]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Roles] DROP CONSTRAINT [DF_{objectQualifier}Roles_AutoAssignment]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs] DROP CONSTRAINT [PK_{objectQualifier}Tabs]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs] DROP CONSTRAINT [DF_{objectQualifier}Tabs_TabOrder]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs] DROP CONSTRAINT [DF_{objectQualifier}Tabs_IsVisible]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs] DROP CONSTRAINT [DF_{objectQualifier}Tabs_Level]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs] DROP CONSTRAINT [DF_{objectQualifier}Tabs_DisableLink]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Tabs] DROP CONSTRAINT [DF_{objectQualifier}Tabs_IsDeleted]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Users] DROP CONSTRAINT [PK_{objectQualifier}Users]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Users] DROP CONSTRAINT [IX_{objectQualifier}Users]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Users] DROP CONSTRAINT [DF_{objectQualifier}Users_IsSuperUser]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchIndexer] DROP CONSTRAINT [PK_{objectQualifier}SearchIndexer]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Profile] DROP CONSTRAINT [PK_{objectQualifier}Profile]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWord] DROP CONSTRAINT [PK_{objectQualifier}SearchItemWords]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Modules] DROP CONSTRAINT [PK_{objectQualifier}Modules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Modules] DROP CONSTRAINT [DF_{objectQualifier}Modules_AllTabs]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Modules] DROP CONSTRAINT [DF_{objectQualifier}Modules_IsDeleted]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Folders] DROP CONSTRAINT [PK_{objectQualifier}Folders]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Affiliates] DROP CONSTRAINT [PK_{objectQualifier}Affiliates]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Schedule] DROP CONSTRAINT [PK_{objectQualifier}Schedule]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserDefinedRows] DROP CONSTRAINT [PK_{objectQualifier}UserDefinedRows]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Permission] DROP CONSTRAINT [PK_{objectQualifier}Permission]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Classification] DROP CONSTRAINT [PK_{objectQualifier}VendorCategory]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Version] DROP CONSTRAINT [PK_{objectQualifier}Version]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Version] DROP CONSTRAINT [IX_{objectQualifier}Version]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ScheduleHistory] DROP CONSTRAINT [PK_{objectQualifier}ScheduleHistory]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModuleSettings] DROP CONSTRAINT [PK_{objectQualifier}TabModuleSettings]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}FAQs] DROP CONSTRAINT [PK_{objectQualifier}FAQs]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItemWordPosition] DROP CONSTRAINT [PK_{objectQualifier}SearchItemWordPosition]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Announcements] DROP CONSTRAINT [PK_{objectQualifier}Announcements]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Portals] DROP CONSTRAINT [PK_{objectQualifier}Portals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Portals] DROP CONSTRAINT [DF_{objectQualifier}Portals_UserRegistration]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Portals] DROP CONSTRAINT [DF_{objectQualifier}Portals_BannerAdvertising]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Portals] DROP CONSTRAINT [DF_{objectQualifier}Portals_HostFee]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Portals] DROP CONSTRAINT [DF_{objectQualifier}Portals_HostSpace]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Portals] DROP CONSTRAINT [DF_{objectQualifier}Portals_GUId]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Portals] DROP CONSTRAINT [DF_{objectQualifier}Portals_DefaultLanguage]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Portals] DROP CONSTRAINT [DF_{objectQualifier}Portals_TimeZoneOffset]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Portals] DROP CONSTRAINT [DF_{objectQualifier}Portals_HomeDirectory]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalAlias] DROP CONSTRAINT [PK_{objectQualifier}PortalAlias]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalAlias] DROP CONSTRAINT [IX_{objectQualifier}PortalAlias]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlLog] DROP CONSTRAINT [PK_{objectQualifier}UrlLog]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserRoles] DROP CONSTRAINT [PK_{objectQualifier}UserRoles]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleSettings] DROP CONSTRAINT [PK_{objectQualifier}ModuleSettings]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Skins] DROP CONSTRAINT [PK_{objectQualifier}Skins]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SystemMessages] DROP CONSTRAINT [PK_{objectQualifier}SystemMessages]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SystemMessages] DROP CONSTRAINT [IX_{objectQualifier}SystemMessages]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UsersOnline] DROP CONSTRAINT [PK_{objectQualifier}UsersOnline]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UsersOnline] DROP CONSTRAINT [DF_{objectQualifier}UsersOnline_CreationDate]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UsersOnline] DROP CONSTRAINT [DF_{objectQualifier}UsersOnline_LastActiveDate]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModulePermission] DROP CONSTRAINT [PK_{objectQualifier}ModulePermission]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules] DROP CONSTRAINT [PK_{objectQualifier}PortalDesktopModules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules] DROP CONSTRAINT [IX_{objectQualifier}PortalDesktopModules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Links] DROP CONSTRAINT [PK_{objectQualifier}Links]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserPortals] DROP CONSTRAINT [PK_{objectQualifier}UserPortals]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserPortals] DROP CONSTRAINT [DF_{objectQualifier}UserPortals_CreatedDate]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Lists] DROP CONSTRAINT [PK_{objectQualifier}Lists]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Lists] DROP CONSTRAINT [DF_{objectQualifier}Lists_ParentID]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Lists] DROP CONSTRAINT [DF_{objectQualifier}Lists_Level]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Lists] DROP CONSTRAINT [DF_{objectQualifier}Lists_SortOrder]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Lists] DROP CONSTRAINT [DF_{objectQualifier}Lists_DefinitionID]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}HtmlText] DROP CONSTRAINT [PK_{objectQualifier}HtmlText]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserDefinedFields] DROP CONSTRAINT [PK_{objectQualifier}UserDefinedTable]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserDefinedFields] DROP CONSTRAINT [DF_{objectQualifier}UserDefinedFields_FieldOrder]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleControls] DROP CONSTRAINT [PK_{objectQualifier}ModuleControls]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleControls] DROP CONSTRAINT [IX_{objectQualifier}ModuleControls]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Discussion] DROP CONSTRAINT [PK_{objectQualifier}Discussion]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}FolderPermission] DROP CONSTRAINT [PK_{objectQualifier}FolderPermission]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabPermission] DROP CONSTRAINT [PK_{objectQualifier}TabPermission]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleDefinitions] DROP CONSTRAINT [PK_{objectQualifier}ModuleDefinitions]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleDefinitions] DROP CONSTRAINT [IX_{objectQualifier}ModuleDefinitions]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ModuleDefinitions] DROP CONSTRAINT [DF_{objectQualifier}ModuleDefinitions_DefaultCacheTime]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}DesktopModules] DROP CONSTRAINT [PK_{objectQualifier}DesktopModules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}DesktopModules] DROP CONSTRAINT [IX_{objectQualifier}DesktopModules_ModuleName]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}DesktopModules] DROP CONSTRAINT [DF_{objectQualifier}DesktopModules_SupportedFeatures]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Files] DROP CONSTRAINT [PK_{objectQualifier}File]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UserDefinedData] DROP CONSTRAINT [PK_{objectQualifier}UserDefinedData]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}HostSettings] DROP CONSTRAINT [PK_{objectQualifier}HostSettings]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}HostSettings] DROP CONSTRAINT [DF_{objectQualifier}HostSettings_Secure]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Vendors] DROP CONSTRAINT [PK_{objectQualifier}Vendor]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Vendors] DROP CONSTRAINT [IX_{objectQualifier}Vendors]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Vendors] DROP CONSTRAINT [DF_{objectQualifier}Vendors_ClickThroughs]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Vendors] DROP CONSTRAINT [DF_{objectQualifier}Vendors_Views]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Vendors] DROP CONSTRAINT [DF_{objectQualifier}Vendors_Authorized]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchCommonWords] DROP CONSTRAINT [PK_{objectQualifier}SearchCommonWords]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlTracking] DROP CONSTRAINT [PK_{objectQualifier}UrlTracking]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlTracking] DROP CONSTRAINT [IX_{objectQualifier}UrlTracking]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlTracking] DROP CONSTRAINT [DF_{objectQualifier}UrlTracking_TrackClicks]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}UrlTracking] DROP CONSTRAINT [DF_{objectQualifier}UrlTracking_NewWindow]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules] DROP CONSTRAINT [PK_{objectQualifier}TabModules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules] DROP CONSTRAINT [IX_{objectQualifier}TabModules]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules] DROP CONSTRAINT [DF_{objectQualifier}TabModules_DisplayTitle]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules] DROP CONSTRAINT [DF_{objectQualifier}TabModules_DisplayPrint]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}TabModules] DROP CONSTRAINT [DF_{objectQualifier}TabModules_DisplaySyndicate]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Events] DROP CONSTRAINT [PK_{objectQualifier}Events]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Documents] DROP CONSTRAINT [PK_{objectQualifier}Documents]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchWord] DROP CONSTRAINT [PK_{objectQualifier}SearchWord]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}VendorClassification] DROP CONSTRAINT [PK_{objectQualifier}VendorClassification]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}VendorClassification] DROP CONSTRAINT [IX_{objectQualifier}VendorClassification]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SiteLog] DROP CONSTRAINT [PK_{objectQualifier}SiteLog]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}SearchItem] DROP CONSTRAINT [PK_{objectQualifier}SearchItem]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Contacts] DROP CONSTRAINT [PK_{objectQualifier}Contacts]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Banners] DROP CONSTRAINT [PK_{objectQualifier}Banner]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Banners] DROP CONSTRAINT [DF_{objectQualifier}Banners_Views]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Banners] DROP CONSTRAINT [DF_{objectQualifier}Banners_ClickThroughs]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Banners] DROP CONSTRAINT [DF_{objectQualifier}Banners_Criteria]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Banners] DROP CONSTRAINT [DF_{objectQualifier}Banners_Width]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}Banners] DROP CONSTRAINT [DF_{objectQualifier}Banners_Height]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}ScheduleItemSettings] DROP CONSTRAINT [PK_{objectQualifier}ScheduleItemSettings]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}AnonymousUsers] DROP CONSTRAINT [PK_{objectQualifier}AnonymousUsers]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}AnonymousUsers] DROP CONSTRAINT [DF_{objectQualifier}AnonymousUsers_CreationDate]
GO
ALTER TABLE {databaseOwner}[{objectQualifier}AnonymousUsers] DROP CONSTRAINT [DF_{objectQualifier}AnonymousUsers_LastActiveDate]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Announcements].[IX_{objectQualifier}Announcements]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Banners].[IX_{objectQualifier}Banners_1]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Banners].[IX_{objectQualifier}Banners]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Classification].[IX_{objectQualifier}Classification]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Contacts].[IX_{objectQualifier}Contacts]
GO
DROP INDEX {databaseOwner}[{objectQualifier}DesktopModules].[IX_{objectQualifier}DesktopModules_FriendlyName]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Discussion].[IX_{objectQualifier}Discussion]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Documents].[IX_{objectQualifier}Documents]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Events].[IX_{objectQualifier}Events]
GO
DROP INDEX {databaseOwner}[{objectQualifier}FAQs].[IX_{objectQualifier}FAQs]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Files].[IX_{objectQualifier}Files]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Links].[IX_{objectQualifier}Links]
GO
DROP INDEX {databaseOwner}[{objectQualifier}ModuleDefinitions].[IX_{objectQualifier}ModuleDefinitions_1]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Modules].[IX_{objectQualifier}Modules]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Profile].[IX_{objectQualifier}Profile]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Roles].[IX_{objectQualifier}Roles]
GO
DROP INDEX {databaseOwner}[{objectQualifier}SearchItem].[IX_{objectQualifier}SearchItem]
GO
DROP INDEX {databaseOwner}[{objectQualifier}SiteLog].[IX_{objectQualifier}SiteLog]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Tabs].[IX_{objectQualifier}Tabs_1]
GO
DROP INDEX {databaseOwner}[{objectQualifier}Tabs].[IX_{objectQualifier}Tabs_2]
GO
DROP INDEX {databaseOwner}[{objectQualifier}UserDefinedData].[IX_{objectQualifier}UserDefinedData]
GO
DROP INDEX {databaseOwner}[{objectQualifier}UserDefinedData].[IX_{objectQualifier}UserDefinedData_1]
GO
DROP INDEX {databaseOwner}[{objectQualifier}UserDefinedFields].[IX_{objectQualifier}UserDefinedFields]
GO
DROP INDEX {databaseOwner}[{objectQualifier}UserDefinedRows].[IX_{objectQualifier}UserDefinedRows]
GO
DROP INDEX {databaseOwner}[{objectQualifier}UserPortals].[IX_{objectQualifier}UserPortals_1]
GO
DROP INDEX {databaseOwner}[{objectQualifier}UserPortals].[IX_{objectQualifier}UserPortals]
GO
DROP INDEX {databaseOwner}[{objectQualifier}UserRoles].[IX_{objectQualifier}UserRoles_1]
GO
DROP INDEX {databaseOwner}[{objectQualifier}UserRoles].[IX_{objectQualifier}UserRoles]
GO
DROP INDEX {databaseOwner}[{objectQualifier}VendorClassification].[IX_{objectQualifier}VendorClassification_1]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetCurrencies]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPortals]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUserDefinedRows]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetBanner]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPortalTabModules]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetFolderPermissionsByFolderPath]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItems]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchResultModules]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetFAQ]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPortalByPortalAliasID]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddUrlTracking]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModuleDefinitionByName]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteUsersOnline]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUserDefinedFields]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetRole]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteModule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateDesktopModule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddTabModule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetAllModules]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteList]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTabModuleOrder]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteTab]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateRole]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteListEntryByID]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddModuleDefinition]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetListEntries]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSiteLog9]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetHostSetting]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddTab]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteBanner]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateModule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddDesktopModule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateUserDefinedFieldOrder]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateTabOrder]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeletePortalInfo]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateVendor]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateUrlTracking]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateUser]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModuleDefinitions]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetThreadMessages]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateModuleOrder]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteUserDefinedField]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUserByUsername]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateOnlineUser]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdatePortalSetup]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}IsUserInRole]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateUserDefinedField]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddVendor]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateBannerClickThrough]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetDesktopModule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteDesktopModule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUrlTracking]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUserDefinedField]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTab]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetDesktopModuleByFriendlyName]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteModuleDefinition]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetDesktopModules]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateListSortOrder]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetAllTabs]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateTab]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetRoleByName]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTabByName]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddHostSetting]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetDefaultLanguageByModule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddListEntry]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddBanner]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddPortalInfo]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPortalByTab]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetRoles]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddUser]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}VerifyPortal]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModuleDefinition]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetServices]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetEvent]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchSettings]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetRolesByUser]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateUrlTrackingStats]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteVendor]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUser]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUsers]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateAnonymousUser]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddUserDefinedField]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUserRole]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteTabModule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateBanner]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModules]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}VerifyPortalTab]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTabs]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetLinks]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetAnnouncement]
GO
DROP TABLE {databaseOwner}[{objectQualifier}UserPortals]
GO
DROP TABLE {databaseOwner}[{objectQualifier}UsersOnline]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetHostSettings]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSiteLog2]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetDocuments]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModuleControlsByKey]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetDocument]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUserRolesByUsername]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSuperUsers]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdatePortalInfo]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateBannerViews]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModulePermissionsByPortal]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchResults]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteUser]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTabPermissionsByPortal]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPortalDesktopModules]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddModule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTabsByParentId]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetContact]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetLink]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteRole]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTabPermissionsByTabID]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetVendorClassifications]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModulePermissionsByModuleID]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetVendors]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPortalRoles]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTopLevelMessages]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddRole]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateListEntry]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateHostSetting]
GO
DROP TABLE {databaseOwner}[{objectQualifier}HostSettings]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetAllTabsModules]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModuleByDefinition]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}FindBanners]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUrlLog]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetBanners]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Banners]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetMessage]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTabPanes]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUserDefinedRow]
GO
DROP TABLE {databaseOwner}[{objectQualifier}UserDefinedFields]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateModuleDefinition]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetAffiliate]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchModules]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetVendor]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateTabModule]
GO
DROP TABLE {databaseOwner}[{objectQualifier}TabModules]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModulePermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetAnnouncements]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetList]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Lists]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetFolderPermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPermissionsByModuleID]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSiteLog3]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Users]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSchedule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPortal]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Roles]
GO
DROP TABLE {databaseOwner}[{objectQualifier}AnonymousUsers]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetDesktopModulesByPortal]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetDesktopModuleByModuleName]
GO
DROP TABLE {databaseOwner}[{objectQualifier}DesktopModules]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Modules]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteUrlTracking]
GO
DROP TABLE {databaseOwner}[{objectQualifier}UrlTracking]
GO
DROP TABLE {databaseOwner}[{objectQualifier}ModuleDefinitions]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Tabs]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Portals]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Vendors]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddModuleControl]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteModulePermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetHtmlText]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdatePortalAlias]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchCommonWordsByLocale]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddSearchWord]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddSearchItemWord]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddFAQ]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSystemMessage]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteVendorClassifications]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddSearchItemWordPosition]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteSearchItemWordPosition]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteDocument]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPortalSpaceUsed]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateUserRole]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateDatabaseVersion]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddScheduleHistory]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddFile]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteSiteLog]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSiteLog6]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSiteLog7]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUserDefinedData]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteFolder]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddProfile]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteUserDefinedRow]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddVendorClassification]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateDocument]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddHtmlText]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddSkin]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUrls]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPermissionsByTabID]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteFile]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}ListSearchItemWord]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddPermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateFolderPermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateFAQ]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModuleControl]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetEvents]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateHtmlText]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModuleControlByKeyAndSrc]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdatePermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetFolders]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateSearchItem]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetUrl]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteSearchItemWords]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeletePortalDesktopModules]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPortalAliasByPortalID]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetScheduleByEvent]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateMessage]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateFile]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPermissionByCodeAndKey]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteSystemMessage]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetMessageByParentId]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateModulePermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetProfile]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteLink]
GO
DROP TABLE {databaseOwner}[{objectQualifier}HtmlText]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPortalByAlias]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetAffiliates]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateScheduleHistory]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteTabPermissionsByTabID]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddModulePermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModuleControls]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteSearchItemWord]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateTabModuleSetting]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteFolderPermissionsByFolderPath]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddEvent]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeletePortalAlias]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetEventsByDate]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddContact]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddLink]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddPortalDesktopModule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateModuleSetting]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Classification]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItem]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteAffiliate]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateUserDefinedData]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchCommonWordByID]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateAnnouncement]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetScheduleItemSettings]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddUrl]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateProfile]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModuleSetting]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSiteLog12]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateAffiliate]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteAnnouncement]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddPortalAlias]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPermissionsByFolderPath]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetScheduleHistory]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteFolderPermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddSearchItem]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}PurgeScheduleHistory]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteEvent]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItemWordPosition]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddTabPermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetModuleSettings]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateModuleControl]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateSystemMessage]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSystemMessages]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetScheduleByTypeFullName]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetFileById]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteSearchWord]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteSkin]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddUrlLog]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItemWordPositionBySearchItemWord]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteFiles]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteModuleControl]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteSearchItems]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSiteLog4]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddAnnouncement]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetFiles]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateSearchWord]
GO
DROP TABLE {databaseOwner}[{objectQualifier}ScheduleItemSettings]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetAllProfiles]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}ListSearchItem]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateLink]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateFolder]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddAffiliate]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddUserDefinedData]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSiteLog8]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchWords]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateContact]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteSearchItem]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Announcements]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateSearchItemWord]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteFAQ]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetScheduleByScheduleID]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteUrl]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Urls]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItemWordBySearchItem]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}FindDatabaseVersion]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTabModuleSettings]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddSchedule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddTabModuleSetting]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateSearchItemWordPosition]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteMessage]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSiteLog5]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTables]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTabModuleSetting]
GO
DROP TABLE {databaseOwner}[{objectQualifier}TabModuleSettings]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetDatabaseVersion]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Version]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddUserRole]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Profile]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetFile]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItemWordBySearchWord]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddSystemMessage]
GO
DROP TABLE {databaseOwner}[{objectQualifier}SystemMessages]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Links]
GO
DROP TABLE {databaseOwner}[{objectQualifier}VendorClassification]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateTabPermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteSearchCommonWord]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateSearchCommonWord]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetTabPermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteModulePermissionsByModuleID]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeletePermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddSiteLog]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddDocument]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Documents]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchWordByID]
GO
DROP TABLE {databaseOwner}[{objectQualifier}SearchWord]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetFAQs]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetContacts]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateEvent]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Events]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddUserDefinedRow]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSiteLog1]
GO
DROP TABLE {databaseOwner}[{objectQualifier}SiteLog]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateSchedule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdateAffiliateStats]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Affiliates]
GO
DROP TABLE {databaseOwner}[{objectQualifier}ModuleControls]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteSchedule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPortalAliasByPortalAliasID]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddFolder]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Folders]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Permission]
GO
DROP TABLE {databaseOwner}[{objectQualifier}ModulePermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddSearchCommonWord]
GO
DROP TABLE {databaseOwner}[{objectQualifier}SearchCommonWords]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddMessage]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Discussion]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Files]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetScheduleNextTask]
GO
DROP TABLE {databaseOwner}[{objectQualifier}ScheduleHistory]
GO
DROP TABLE {databaseOwner}[{objectQualifier}UserDefinedRows]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteContact]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Contacts]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Schedule]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddModuleSetting]
GO
DROP TABLE {databaseOwner}[{objectQualifier}ModuleSettings]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetPortalAlias]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteTabPermission]
GO
DROP TABLE {databaseOwner}[{objectQualifier}TabPermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}ListSearchItemWordPosition]
GO
DROP TABLE {databaseOwner}[{objectQualifier}SearchItemWordPosition]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchIndexers]
GO
DROP TABLE {databaseOwner}[{objectQualifier}SearchIndexer]
GO
DROP TABLE {databaseOwner}[{objectQualifier}UrlLog]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}AddFolderPermission]
GO
DROP TABLE {databaseOwner}[{objectQualifier}PortalDesktopModules]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteUserDefinedData]
GO
DROP TABLE {databaseOwner}[{objectQualifier}UserDefinedData]
GO
DROP TABLE {databaseOwner}[{objectQualifier}FolderPermission]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSkin]
GO
DROP TABLE {databaseOwner}[{objectQualifier}Skins]
GO
DROP TABLE {databaseOwner}[{objectQualifier}SearchItem]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}DeleteUserRole]
GO
DROP TABLE {databaseOwner}[{objectQualifier}UserRoles]
GO
DROP TABLE {databaseOwner}[{objectQualifier}FAQs]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}GetSearchItemWord]
GO
DROP TABLE {databaseOwner}[{objectQualifier}SearchItemWord]
GO
DROP PROCEDURE {databaseOwner}[{objectQualifier}UpdatePortalAliasOnInstall]
GO
DROP TABLE {databaseOwner}[{objectQualifier}PortalAlias]
GO

/** Remove AspNet Data **/

/** Delete Profile **/
DELETE	dbo.aspnet_Profile
FROM	dbo.aspnet_Applications 
		INNER JOIN dbo.aspnet_Users ON dbo.aspnet_Applications.ApplicationId = dbo.aspnet_Users.ApplicationId 
		INNER JOIN dbo.aspnet_Profile ON dbo.aspnet_Users.UserId = dbo.aspnet_Profile.UserId
WHERE   (dbo.aspnet_Applications.ApplicationName LIKE N'{objectQualifier}%')
GO

/** Delete Membership **/
DELETE	dbo.aspnet_Membership
FROM    dbo.aspnet_Applications 
		INNER JOIN dbo.aspnet_Membership ON dbo.aspnet_Applications.ApplicationId = dbo.aspnet_Membership.ApplicationId
WHERE     (dbo.aspnet_Applications.ApplicationName LIKE N'{objectQualifier}%')
GO

/** Delete UsersInRoles **/
DELETE	dbo.aspnet_UsersInRoles
FROM    dbo.aspnet_Applications 
		INNER JOIN dbo.aspnet_Users ON dbo.aspnet_Applications.ApplicationId = dbo.aspnet_Users.ApplicationId 
		INNER JOIN dbo.aspnet_UsersInRoles ON dbo.aspnet_Users.UserId = dbo.aspnet_UsersInRoles.UserId
WHERE   (dbo.aspnet_Applications.ApplicationName LIKE N'{objectQualifier}%')
GO

/** Delete Users **/
DELETE	dbo.aspnet_Users
FROM    dbo.aspnet_Applications 
		INNER JOIN dbo.aspnet_Users ON dbo.aspnet_Applications.ApplicationId = dbo.aspnet_Users.ApplicationId
WHERE   (dbo.aspnet_Applications.ApplicationName LIKE N'{objectQualifier}%')
GO

/** Delete Roles **/
DELETE	dbo.aspnet_Roles
FROM    dbo.aspnet_Applications 
		INNER JOIN dbo.aspnet_Roles ON dbo.aspnet_Applications.ApplicationId = dbo.aspnet_Roles.ApplicationId
WHERE   (dbo.aspnet_Applications.ApplicationName LIKE N'{objectQualifier}%')
GO

/** Delete Applications **/
DELETE	dbo.aspnet_Applications
WHERE   (ApplicationName LIKE N'{objectQualifier}%')
GO

/************************************************************/
/*****              SqlDataProvider                     *****/
/************************************************************/