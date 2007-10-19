/* Temp tables for SCPukePkg */

/* SCP_GETDEFAULTLANGUAGEBYMODUL */
DECLARE v_exists NUMBER(10,   0);
BEGIN

  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM all_tables
  WHERE LOWER(TABLE_NAME) = LOWER('tt_templist');

  IF v_exists = 1 THEN
    EXECUTE IMMEDIATE 'DROP TABLE tt_templist';
  END IF;

END;
/

/* SCP_GETDEFAULTLANGUAGEBYMODUL */
CREATE GLOBAL TEMPORARY TABLE {databaseOwner}tp_templist(moduleid NUMBER(10,   0)) ON
COMMIT PRESERVE ROWS;
/

/* SCP_ADDSEARCHITEMWORDPOSITION */
DECLARE v_exists NUMBER(10,   0);
BEGIN

  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM all_tables
  WHERE LOWER(TABLE_NAME) = LOWER('tt_templist_1');

  IF v_exists = 1 THEN
    EXECUTE IMMEDIATE 'DROP TABLE tt_templist_1';
  END IF;

END;
/

/* SCP_ADDSEARCHITEMWORDPOSITION */
CREATE GLOBAL TEMPORARY TABLE {databaseOwner}tp_templist_1(itemwordid NUMBER(10,   0),   POSITION NUMBER(10,   0)) ON
COMMIT PRESERVE ROWS;
/

/*  End temp table for SCNukePkg  */

CREATE OR REPLACE PACKAGE {databaseOwner}SCPUKE_PKG AUTHID CURRENT_USER AS
  FUNCTION formatsql(i_value IN NVARCHAR2) RETURN NVARCHAR2;
  FUNCTION dateadd(INTERVAL VARCHAR2,   adding NUMBER,   entry_date DATE) RETURN DATE;
  FUNCTION scp_getelement(i_ord IN NUMBER DEFAULT NULL,   i_str IN VARCHAR2 DEFAULT NULL,   i_delim IN VARCHAR2 DEFAULT NULL) RETURN NUMBER;
  FUNCTION scp_getprofileelement(i_fieldname IN nvarchar2 DEFAULT NULL,   i_fields IN nvarchar2 DEFAULT NULL,   i_values IN nvarchar2 DEFAULT NULL) RETURN nvarchar2;
  FUNCTION scp_getprofilepropertydefinit(i_portalid IN NUMBER DEFAULT NULL,   i_propertyname IN nvarchar2 DEFAULT NULL) RETURN NUMBER;
  FUNCTION scp_fn_getversion(i_maj IN NUMBER DEFAULT NULL,   i_min IN NUMBER DEFAULT NULL,   i_bld IN NUMBER DEFAULT NULL) RETURN NUMBER;
  
  PROCEDURE scp_addaccount(i_portalid IN NUMBER DEFAULT NULL, i_accountnumber IN VARCHAR2 DEFAULT NULL, i_accountname IN VARCHAR2 DEFAULT NULL, i_description IN NVARCHAR2 DEFAULT NULL, i_email1 IN NVARCHAR2 DEFAULT NULL, i_email2 IN NVARCHAR2 DEFAULT NULL, i_isenabled IN NUMBER DEFAULT NULL, o_accountid OUT NUMBER);
  PROCEDURE scp_addportalalias(i_portalid IN NUMBER DEFAULT NULL,   i_httpalias IN nvarchar2 DEFAULT NULL,   o_portalaliasid OUT {databaseOwner}scp_portalalias.portalaliasid%TYPE);
  PROCEDURE scp_addschedulehistory(i_scheduleid IN NUMBER DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_server IN NVARCHAR2 DEFAULT NULL,   o_schedulehistoryid OUT {databaseOwner}scp_schedulehistory.schedulehistoryid%TYPE);
  PROCEDURE scp_addeventlog(i_logguid IN VARCHAR2 DEFAULT NULL,   i_logtypekey IN nvarchar2 DEFAULT NULL,   i_loguserid IN NUMBER DEFAULT NULL,   i_logusername IN nvarchar2 DEFAULT NULL,   i_logportalid IN NUMBER DEFAULT NULL,   i_logportalname IN nvarchar2 DEFAULT NULL,   i_logcreatedate IN DATE DEFAULT NULL,   i_logservername IN nvarchar2 DEFAULT NULL,   i_logproperties IN nclob DEFAULT NULL,   i_logconfigid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_addurl(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_addfile(i_portalid IN NUMBER DEFAULT NULL,   i_filename IN nvarchar2 DEFAULT NULL,   i_extension IN nvarchar2 DEFAULT NULL,   i_size IN NUMBER DEFAULT NULL,   i_width IN NUMBER DEFAULT NULL,   i_height IN NUMBER DEFAULT NULL,   i_contenttype IN nvarchar2 DEFAULT NULL,   i_folder IN nvarchar2 DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   o_fileid OUT {databaseOwner}scp_files.fileid%TYPE);
  PROCEDURE scp_addbanner(i_bannername IN nvarchar2 DEFAULT NULL,   i_vendorid IN NUMBER DEFAULT NULL,   i_imagefile IN nvarchar2 DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_impressions IN NUMBER DEFAULT NULL,   i_cpm IN FLOAT DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_bannertypeid IN NUMBER DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_groupname IN nvarchar2 DEFAULT NULL,   i_criteria IN NUMBER DEFAULT NULL,   i_width IN NUMBER DEFAULT NULL,   i_height IN NUMBER DEFAULT NULL,   o_bannerid OUT {databaseOwner}scp_banners.bannerid%TYPE);
  PROCEDURE scp_addrolegroup(i_portalid IN NUMBER DEFAULT NULL,   i_rolegroupname IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   o_rolegroupid OUT {databaseOwner}scp_rolegroups.rolegroupid%TYPE);
  PROCEDURE scp_addtabpermission(i_tabid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL,   o_tabpermissionid OUT {databaseOwner}scp_tabpermission.tabpermissionid%TYPE);
  PROCEDURE scp_addeventlogconfig(i_logtypekey IN nvarchar2 DEFAULT NULL,   i_logtypeportalid IN NUMBER DEFAULT NULL,   i_loggingisactive IN NUMBER DEFAULT NULL,   i_keepmostrecent IN NUMBER DEFAULT NULL,   i_emailnotificationisactive IN NUMBER DEFAULT NULL,   i_notificationthreshold IN NUMBER DEFAULT NULL,   i_notificationthresholdtime IN NUMBER DEFAULT NULL,   i_notificationthresholdtype IN NUMBER DEFAULT NULL,   i_mailfromaddress IN nvarchar2 DEFAULT NULL,   i_mailtoaddress IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_addskin(i_skinroot IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_skintype IN NUMBER DEFAULT NULL,   i_skinsrc IN nvarchar2 DEFAULT NULL,   o_skinid OUT {databaseOwner}scp_skins.skinid%TYPE);
  PROCEDURE scp_addsystemmessage(i_portalid IN NUMBER DEFAULT NULL,   i_messagename IN nvarchar2 DEFAULT NULL,   i_messagevalue IN nclob DEFAULT NULL);
  PROCEDURE scp_addmodulesetting(i_moduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL,   i_settingvalue IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_addurltracking(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_urltype IN CHAR DEFAULT NULL,   i_logactivity IN NUMBER DEFAULT NULL,   i_trackclicks IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_newwindow IN NUMBER DEFAULT NULL);
  PROCEDURE scp_addprofile(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_addportaldesktopmodule(i_portalid IN NUMBER DEFAULT NULL,   i_desktopmoduleid IN NUMBER DEFAULT NULL,   o_portaldesktopmoduleid OUT {databaseOwner}scp_portaldesktopmodules.portaldesktopmoduleid%TYPE);
  PROCEDURE scp_addscheduleitemsetting(i_scheduleid IN NUMBER DEFAULT NULL,   i_name IN nvarchar2 DEFAULT NULL,   i_value IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_addsearchitemwordposition(i_searchitemwordid IN NUMBER DEFAULT NULL,   i_contentpositions IN VARCHAR2 DEFAULT NULL);
  PROCEDURE scp_addvendorclassification(i_vendorid IN NUMBER DEFAULT NULL,   i_classificationid IN NUMBER DEFAULT NULL,   o_vendorclassificationid OUT {databaseOwner}scp_vendorclassification.vendorclassificationid%TYPE);
  PROCEDURE scp_addsearchword(i_word IN nvarchar2 DEFAULT NULL,   o_searchwordsid OUT {databaseOwner}scp_searchword.searchwordsid%TYPE);
  PROCEDURE scp_addmoduledefinition(i_desktopmoduleid IN NUMBER DEFAULT NULL,   i_friendlyname IN nvarchar2 DEFAULT NULL,   i_defaultcachetime IN NUMBER DEFAULT NULL,   o_moduledefid OUT {databaseOwner}scp_moduledefinitions.moduledefid%TYPE);
  PROCEDURE scp_adduserrole(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_effectivedate IN DATE DEFAULT NULL,   i_expirydate IN DATE DEFAULT NULL,   o_userroleid OUT {databaseOwner}scp_userroles.userroleid%TYPE);
  PROCEDURE scp_addeventlogtype(i_logtypekey IN nvarchar2 DEFAULT NULL,   i_logtypefriendlyname IN nvarchar2 DEFAULT NULL,   i_logtypedescription IN nvarchar2 DEFAULT NULL,   i_logtypeowner IN nvarchar2 DEFAULT NULL,   i_logtypecssclass IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_addportalinfo(i_portalname IN nvarchar2 DEFAULT NULL,   i_currency IN CHAR DEFAULT NULL,   i_expirydate IN DATE DEFAULT NULL,   i_hostfee IN NUMBER DEFAULT NULL,   i_hostspace IN NUMBER DEFAULT NULL,   i_pagequota IN NUMBER DEFAULT NULL,   i_userquota IN NUMBER DEFAULT NULL,   i_siteloghistory IN NUMBER DEFAULT NULL,   i_homedirectory IN VARCHAR2 DEFAULT NULL,   o_portalid OUT {databaseOwner}scp_portals.portalid%TYPE);
  PROCEDURE scp_adduser(i_portalid IN NUMBER DEFAULT NULL, i_accountid IN number, i_username IN nvarchar2 DEFAULT NULL,   i_firstname IN nvarchar2 DEFAULT NULL,   i_lastname IN nvarchar2 DEFAULT NULL,   i_affiliateid IN NUMBER DEFAULT NULL,   i_issuperuser IN NUMBER DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL,   i_displayname IN nvarchar2 DEFAULT NULL,   i_updatepassword IN NUMBER DEFAULT NULL,   i_authorised IN NUMBER DEFAULT NULL,   o_userid OUT {databaseOwner}scp_users.userid%TYPE);
  PROCEDURE scp_addtabmodulesetting(i_tabmoduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL,   i_settingvalue IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_adddesktopmodule(i_modulename IN nvarchar2 DEFAULT NULL,   i_foldername IN nvarchar2 DEFAULT NULL,   i_friendlyname IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_version IN nvarchar2 DEFAULT NULL,   i_ispremium IN NUMBER DEFAULT NULL,   i_isadmin IN NUMBER DEFAULT NULL,   i_businesscontroller IN nvarchar2 DEFAULT NULL,   i_supportedfeatures IN NUMBER DEFAULT NULL,   i_compatibleversions IN nvarchar2 DEFAULT NULL,   o_desktopmoduleid OUT {databaseOwner}scp_desktopmodules.desktopmoduleid%TYPE);
  PROCEDURE scp_addpermission(i_moduledefid IN NUMBER DEFAULT NULL,   i_permissioncode IN VARCHAR2 DEFAULT NULL,   i_permissionkey IN VARCHAR2 DEFAULT NULL,   i_permissionname IN VARCHAR2 DEFAULT NULL,   o_permissionid OUT {databaseOwner}scp_permission.permissionid%TYPE);
  PROCEDURE scp_addsearchitem(i_title IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_author IN NUMBER DEFAULT NULL,   i_pubdate IN DATE DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_searchkey IN nvarchar2 DEFAULT NULL,   i_guid IN varchar2 DEFAULT NULL,   i_imagefileid IN NUMBER DEFAULT NULL,   o_searchitemid OUT {databaseOwner}scp_searchitem.searchitemid%TYPE);
  PROCEDURE scp_addschedule(i_typefullname IN VARCHAR2 DEFAULT NULL,   i_timelapse IN NUMBER DEFAULT NULL,   i_timelapsemeasurement IN VARCHAR2 DEFAULT NULL,   i_retrytimelapse IN NUMBER DEFAULT NULL,   i_retrytimelapsemeasurement IN VARCHAR2 DEFAULT NULL,   i_retainhistorynum IN NUMBER DEFAULT NULL,   i_attachtoevent IN VARCHAR2 DEFAULT NULL,   i_catchupenabled IN NUMBER DEFAULT NULL,   i_enabled IN NUMBER DEFAULT NULL,   i_objectdependencies IN VARCHAR2 DEFAULT NULL,   i_servers IN NVARCHAR2 DEFAULT NULL,   o_scheduleid OUT {databaseOwner}scp_schedule.scheduleid%TYPE);
  PROCEDURE scp_addvendor(i_portalid IN NUMBER DEFAULT NULL,   i_vendorname IN nvarchar2 DEFAULT NULL,   i_unit IN nvarchar2 DEFAULT NULL,   i_street IN nvarchar2 DEFAULT NULL,   i_city IN nvarchar2 DEFAULT NULL,   i_region IN nvarchar2 DEFAULT NULL,   i_country IN nvarchar2 DEFAULT NULL,   i_postalcode IN nvarchar2 DEFAULT NULL,   i_telephone IN nvarchar2 DEFAULT NULL,   i_fax IN nvarchar2 DEFAULT NULL,   i_cell IN varchar2 DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL,   i_website IN nvarchar2 DEFAULT NULL,   i_firstname IN nvarchar2 DEFAULT NULL,   i_lastname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_logofile IN nvarchar2 DEFAULT NULL,   i_keywords IN NCLOB DEFAULT NULL,   i_authorized IN NUMBER DEFAULT NULL,   o_vendorid OUT {databaseOwner}scp_vendors.vendorid%TYPE);
  PROCEDURE scp_addmodule(i_portalid IN NUMBER DEFAULT NULL,   i_moduledefid IN NUMBER DEFAULT NULL,   i_moduletitle IN nvarchar2 DEFAULT NULL,   i_alltabs IN NUMBER DEFAULT NULL,   i_header IN nclob DEFAULT NULL,   i_footer IN nclob DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_inheritviewpermissions IN NUMBER DEFAULT NULL,   i_isdeleted IN NUMBER DEFAULT NULL,   o_moduleid OUT {databaseOwner}scp_modules.moduleid%TYPE);
  PROCEDURE scp_addlistentry(i_listname IN nvarchar2 DEFAULT NULL,   i_value IN nvarchar2 DEFAULT NULL,   i_text IN nvarchar2 DEFAULT NULL,   i_parentkey IN nvarchar2 DEFAULT NULL,   i_enablesortorder IN NUMBER DEFAULT NULL,   i_definitionid IN NUMBER DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   o_entryid OUT {databaseOwner}scp_lists.entryid%TYPE);
  PROCEDURE scp_addtab(i_portalid IN NUMBER DEFAULT NULL,   i_tabname IN nvarchar2 DEFAULT NULL,   i_isvisible IN NUMBER DEFAULT NULL,   i_disablelink IN NUMBER DEFAULT NULL,   i_parentid IN NUMBER DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   i_title IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_keywords IN nvarchar2 DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_skinsrc IN nvarchar2 DEFAULT NULL,   i_containersrc IN nvarchar2 DEFAULT NULL,   i_tabpath IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_refreshinterval IN NUMBER DEFAULT NULL,   i_pageheadtext IN nvarchar2 DEFAULT NULL,   o_tabid OUT {databaseOwner}scp_tabs.tabid%TYPE);
  PROCEDURE scp_addurllog(i_urltrackingid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_addsearchitemword(i_searchitemid IN NUMBER DEFAULT NULL,   i_searchwordsid IN NUMBER DEFAULT NULL,   i_occurrences IN NUMBER DEFAULT NULL,   o_searchitemwordid OUT {databaseOwner}scp_searchitemword.searchitemwordid%TYPE);
  PROCEDURE scp_addhostsetting(i_settingname IN nvarchar2 DEFAULT NULL,   i_settingvalue IN nvarchar2 DEFAULT NULL,   i_settingissecure IN NUMBER DEFAULT NULL);
  PROCEDURE scp_addsitelog(i_datetime IN DATE DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   i_referrer IN nvarchar2 DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_useragent IN nvarchar2 DEFAULT NULL,   i_userhostaddress IN nvarchar2 DEFAULT NULL,   i_userhostname IN nvarchar2 DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   i_affiliateid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_addmodulecontrol(i_moduledefid IN NUMBER DEFAULT NULL,   i_controlkey IN nvarchar2 DEFAULT NULL,   i_controltitle IN nvarchar2 DEFAULT NULL,   i_controlsrc IN nvarchar2 DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   i_controltype IN NUMBER DEFAULT NULL,   i_vieworder IN NUMBER DEFAULT NULL,   i_helpurl IN nvarchar2 DEFAULT NULL,   o_modulecontrolid OUT {databaseOwner}scp_modulecontrols.modulecontrolid%TYPE);
  PROCEDURE scp_addaffiliate(i_vendorid IN NUMBER DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_cpc IN FLOAT DEFAULT NULL,   i_cpa IN FLOAT DEFAULT NULL,   o_affiliateid OUT {databaseOwner}scp_affiliates.affiliateid%TYPE);
  PROCEDURE scp_addsearchcommonword(i_commonword IN nvarchar2 DEFAULT NULL,   i_locale IN nvarchar2 DEFAULT NULL,   o_commonwordid OUT {databaseOwner}scp_searchcommonwords.commonwordid%TYPE);
  PROCEDURE scp_addmodulepermission(i_moduleid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL,   o_modulepermissionid OUT {databaseOwner}scp_modulepermission.modulepermissionid%TYPE);
  PROCEDURE scp_addtabmodule(i_tabid IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_moduleorder IN NUMBER DEFAULT NULL,   i_panename IN nvarchar2 DEFAULT NULL,   i_cachetime IN NUMBER DEFAULT NULL,   i_alignment IN nvarchar2 DEFAULT NULL,   i_color IN nvarchar2 DEFAULT NULL,   i_border IN nvarchar2 DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   i_visibility IN NUMBER DEFAULT NULL,   i_containersrc IN nvarchar2 DEFAULT NULL,   i_displaytitle IN NUMBER DEFAULT NULL,   i_displayprint IN NUMBER DEFAULT NULL,   i_displaysyndicate IN NUMBER DEFAULT NULL);
  PROCEDURE scp_addrole(i_portalid IN NUMBER DEFAULT NULL,   i_rolegroupid IN NUMBER DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_servicefee IN NUMBER DEFAULT NULL,   i_billingperiod IN NUMBER DEFAULT NULL,   i_billingfrequency IN CHAR DEFAULT NULL,   i_trialfee IN NUMBER DEFAULT NULL,   i_trialperiod IN NUMBER DEFAULT NULL,   i_trialfrequency IN CHAR DEFAULT NULL,   i_ispublic IN NUMBER DEFAULT NULL,   i_autoassignment IN NUMBER DEFAULT NULL,   i_rsvpcode IN nvarchar2 DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   o_roleid OUT {databaseOwner}scp_roles.roleid%TYPE);
  PROCEDURE scp_addfolder(i_portalid IN NUMBER DEFAULT NULL,   i_folderpath IN VARCHAR2 DEFAULT NULL,   i_storagelocation IN NUMBER DEFAULT NULL,   i_isprotected IN NUMBER DEFAULT NULL,   i_iscached IN NUMBER DEFAULT NULL,   i_lastupdated IN DATE DEFAULT NULL,   o_folderid OUT {databaseOwner}scp_folders.folderid%TYPE);
  PROCEDURE scp_addfolderpermission(i_folderid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL,   o_folderpermissionid OUT {databaseOwner}scp_folderpermission.folderpermissionid%TYPE);
  PROCEDURE scp_addpropertydefinition(i_portalid IN NUMBER DEFAULT NULL,   i_moduledefid IN NUMBER DEFAULT NULL,   i_datatype IN NUMBER DEFAULT NULL,   i_defaultvalue IN nvarchar2 DEFAULT NULL,   i_propertycategory IN nvarchar2 DEFAULT NULL,   i_propertyname IN nvarchar2 DEFAULT NULL,   i_required IN NUMBER DEFAULT NULL,   i_validationexpression IN nvarchar2 DEFAULT NULL,   i_vieworder IN NUMBER DEFAULT NULL,   i_visible IN NUMBER DEFAULT NULL,   i_length IN NUMBER DEFAULT NULL,   i_searchable IN NUMBER DEFAULT NULL,   o_propertydefinitionid OUT {databaseOwner}scp_profilepropertydefinition.propertydefinitionid%TYPE);
  PROCEDURE scp_adddefaultpropertydef(i_portalid IN NUMBER DEFAULT NULL);

  PROCEDURE scp_deletesearchitemword(i_searchitemwordid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletesystemmessage(i_portalid IN NUMBER DEFAULT NULL,   i_messagename IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_deletefolder(i_portalid IN NUMBER DEFAULT NULL,   i_folderpath IN VARCHAR2 DEFAULT NULL);
  PROCEDURE scp_deleteaffiliate(i_affiliateid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletemoduledefinition(i_moduledefid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletelist(i_listname IN VARCHAR2 DEFAULT NULL,   i_parentkey IN VARCHAR2 DEFAULT NULL);
  PROCEDURE scp_deleteeventlog(i_logguid IN VARCHAR2 DEFAULT NULL);
  PROCEDURE scp_deletefolderpermission(i_folderpermissionid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletefile(i_portalid IN NUMBER DEFAULT NULL,   i_filename IN nvarchar2 DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleterole(i_roleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_delfolderpermsbypath(i_portalid IN NUMBER DEFAULT NULL,   i_folderpath IN VARCHAR2 DEFAULT NULL);
  PROCEDURE scp_deleteskin(i_skinroot IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_skintype IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleteschedule(i_scheduleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleterolegroup(i_rolegroupid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleteportalinfo(i_portalid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletebanner(i_bannerid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletesearchitemwordposit(i_searchitemwordpositionid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletelistentrybyid(i_entryid IN NUMBER DEFAULT NULL,   i_deletechild IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletemodulesettings(i_moduleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleteusersonline(i_timewindow IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleteuseronline(i_userid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletemodule(i_moduleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleteportaldesktopmodule(i_portalid IN NUMBER DEFAULT NULL,   i_desktopmoduleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletesearchcommonword(i_commonwordid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleteuser(i_userid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletetabpermission(i_tabpermissionid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletetabpermissionsbytab(i_tabid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletemodulecontrol(i_modulecontrolid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletetabmodulesetting(i_tabmoduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_deleteportalalias(i_portalaliasid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletesearchitem(i_searchitemid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletepermission(i_permissionid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletetabmodule(i_tabid IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_delmodpermsbymodid(i_moduleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletevendor(i_vendorid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleteeventlogtype(i_logtypekey IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_deleteuserrole(i_userid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletesearchword(i_searchwordsid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleteuserportal(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleteurl(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_deletetabmodulesettings(i_tabmoduleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletesearchitemwords(i_searchitemid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletemodulepermission(i_modulepermissionid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleteeventlogconfig(i_id IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletesitelog(i_datetime IN DATE DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_delvendorclassifications(i_vendorid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletemodulesetting(i_moduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_deletedesktopmodule(i_desktopmoduleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deleteurltracking(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletetab(i_tabid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletesearchitems(i_moduleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletepropertydefinition(i_propertydefinitionid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_deletefiles(i_portalid IN NUMBER DEFAULT NULL);
  
  PROCEDURE scp_getpasswordquestions(i_locale IN NVARCHAR2 DEFAULT NULL, o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getaccountid(i_portalid IN NUMBER DEFAULT NULL, i_accountnumber IN VARCHAR2 DEFAULT NULL, o_accountid OUT NUMBER);
  PROCEDURE scp_getaccountbyid(i_accountid IN NUMBER DEFAULT NULL, o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getaccountbynumber(i_portalid IN NUMBER DEFAULT NULL, i_accountnumber IN VARCHAR2 DEFAULT NULL, o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getaccounts(i_portalid IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1,   o_totalrecords OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getaffiliates(i_vendorid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchcommonwordbyid(i_commonwordid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodulesetting(i_moduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchcommonwordsbyloc(i_locale IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getdesktopmodulesbyportal(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getunauthorizedusers(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodule(i_moduleid IN NUMBER DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettabmodules(i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportalbytab(i_tabid IN NUMBER DEFAULT NULL,   i_httpalias IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodulepermissionsbymod(i_moduleid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsystemmessages(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getpropertydefbycategory(i_portalid IN NUMBER DEFAULT NULL,   i_category IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_geturltracking(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchwordbyid(i_searchwordsid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getvendor(i_vendorId IN NUMBER,  i_portalid IN NUMBER,  o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getvendors(i_portalid IN NUMBER DEFAULT NULL,   i_unauthorized IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getusersbyemail(i_portalid IN NUMBER DEFAULT NULL,   i_emailtomatch IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getrolesbyuser(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_geteventlogpendingnotifco(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodulecontrol(i_modulecontrolid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getuserrole(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportalsbyname(i_nametomatch IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_GetBanner (i_BannerId in number,    i_VendorId in number,    i_PortalID in number,    o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getbanners(i_vendorid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getfolderbyfolderid(i_portalid IN NUMBER DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getpropertydefbyportal(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettabpermission(i_tabpermissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchitems(i_portalid IN NUMBER DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getfile(i_filename IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gethostsetting(i_settingname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getpropertydefbyname(portalid IN NUMBER DEFAULT NULL,   name IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getpermissionsbymoduleid(i_moduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodulecontrolbykeyscr(i_moduledefid IN NUMBER DEFAULT NULL,   i_controlkey IN nvarchar2 DEFAULT NULL,   i_controlsrc IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchitemwordbyword(i_searchwordsid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettabsbyparentid(i_parentid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodulecontrolsbykey(i_controlkey IN nvarchar2 DEFAULT NULL,   i_moduledefid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportals(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsitelog4(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_geteventlogpendingnotif(i_logconfigid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettables(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getallfiles(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsitelog9(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getuser(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getrole(i_roleid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmoduledefinition(i_moduledefid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodules(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodulesettings(i_moduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getpermissionsbymoddefid(i_moduledefid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getpermissionbycodeandkey(i_permissioncode IN VARCHAR2 DEFAULT NULL,   i_permissionkey IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getfolderpermissionbypath(i_portalid IN NUMBER DEFAULT NULL,   i_folderpath IN VARCHAR2 DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getrolegroups(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsitelog6(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchsettings(i_moduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getvendorsbyemail(i_filter IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getrolegroup(i_portalid IN NUMBER DEFAULT NULL,   i_rolegroupid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsitelog8(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportal(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getfilebyid(i_fileid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getfolderbyfolderpath(i_portalid IN NUMBER DEFAULT NULL,   i_folderpath IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getpermissionsbytabid(i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getusersbyaccountnumber(i_portalid IN NUMBER DEFAULT NULL,   i_accounttomatch IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getusersbyusername(i_portalid IN NUMBER DEFAULT NULL,   i_usernametomatch IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_geteventlogconfig(i_id IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmoduledefinitionbyname(i_desktopmoduleid IN NUMBER DEFAULT NULL,   i_friendlyname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getusersbyprofileproperty(i_portalid IN NUMBER DEFAULT NULL,   i_propertyname IN nvarchar2 DEFAULT NULL,   i_propertyvalue IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_geturl(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettabmodulesettings(i_tabmoduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodulecontrols(i_moduledefid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getpropertydefinition(i_propertydefinitionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getvendorclassifications(i_vendorid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getexpiredportals(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getskins(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchresults(i_portalid IN NUMBER DEFAULT NULL,   i_word IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getlist(i_listname IN nvarchar2 DEFAULT NULL,   i_parentkey IN nvarchar2 DEFAULT NULL,   i_definitionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchmodules ( i_portalid IN NUMBER,  o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchresultmodules(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsitelog7(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchitemwordbyitem(i_searchitemid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettab(i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportalbyportalaliasid(i_portalaliasid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getonlineuser(i_userid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportalbyalias(i_httpalias IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchitemwordwordid(i_searchitemwordid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportalaliasbyaliasid(i_portalaliasid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getallmodules(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getrolesbygroup(i_rolegroupid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettabpanes(i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getrolebyname(i_portalid IN NUMBER DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getdefaultlanguagebymod(i_modulelist IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gethostsettings(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_geteventlogbylogguid(i_logguid IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getdesktopmodules(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_geturllog(i_urltrackingid IN NUMBER DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getschedulenexttask(i_server IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getuserbyusername(i_portalid IN NUMBER DEFAULT NULL, i_accountnumber IN varchar2,   i_username IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getuserroles(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getdatabaseversion(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getskin(i_skinroot IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_skintype IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsitelog2(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_geteventlog(i_portalid IN NUMBER DEFAULT NULL,   i_logtypekey IN nvarchar2 DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getlistentries(i_listname IN nvarchar2 DEFAULT NULL,   i_parentkey IN nvarchar2 DEFAULT NULL,   i_entryid IN NUMBER DEFAULT NULL,   i_definitionid IN NUMBER DEFAULT NULL,   i_value IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getuserprofile(i_userid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodulepermission(i_modulepermissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettabmoduleorder(i_tabid IN NUMBER DEFAULT NULL,   i_panename IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getvendorsbyname(i_filter IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_geturls(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getalltabsmodules(i_portalid IN NUMBER DEFAULT NULL,   i_alltabs IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getprofile(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getfoldersbyuser(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   i_includesecure IN NUMBER DEFAULT NULL,   i_includedatabase IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL,   i_permissionkeys IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getdesktopmodule(i_desktopmoduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettabcount(i_portalid IN NUMBER DEFAULT NULL,   o_tabcount OUT number);
  PROCEDURE scp_getschedulebytypefullname(i_typefullname IN VARCHAR2 DEFAULT NULL,   i_server IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodulepermissionsbyptl(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodulebydefinition(i_portalid IN NUMBER DEFAULT NULL,   i_friendlyname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getfolderpermission(i_folderpermissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchitemword(i_searchitemwordid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getpermission(i_permissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getfilecontent(i_fileid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getscheduleitemsettings(i_scheduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettabpermissionsbytabid(i_tabid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getschedulebyevent(i_eventname IN VARCHAR2 DEFAULT NULL,   i_server IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettabbyname(i_tabname IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsitelog12(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportalspaceused(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getpermissionsbyfolderpth(i_portalid IN NUMBER DEFAULT NULL,   i_folderpath IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsuperusers(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getschedulehistory(i_scheduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getuserrolesbyuserid(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportalcount(o_count OUT number);
  PROCEDURE scp_getusercountbyportal(i_portalid IN NUMBER DEFAULT NULL,   o_usercount OUT NUMBER);
  PROCEDURE scp_getcurrencies(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchitemwordposition(i_searchitemwordpositionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getdesktopmodulebymodname(i_modulename IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getroles(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsitelog5(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchwords(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getschedulebyscheduleid(i_scheduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportalaliasbyportalid(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getallprofiles(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchitem(i_moduleid IN NUMBER DEFAULT NULL,   i_searchkey IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsearchindexers(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getservices(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getbannergroups(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportalalias(i_httpalias IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettabpermissionsbyportal(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsitelog3(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getaffiliate(i_affiliateid IN NUMBER DEFAULT NULL,   i_vendorid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsitelog1(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportaldesktopmodules(i_portalid IN NUMBER DEFAULT NULL,   i_desktopmoduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmoduledefinitions(i_desktopmoduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getdesktopmodulebyname(i_friendlyname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getportalroles(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getusersbyrolename(i_portalid IN NUMBER DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getallusers(i_portalid IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_geteventlogtype(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettabs(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getfolders(i_portalid IN NUMBER DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   i_folderpath IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getusers(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getalltabs(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_gettabmodulesetting(i_tabmoduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getmodulepermissionsbytab(i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getsystemmessage(i_portalid IN NUMBER DEFAULT NULL,   i_messagename IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getonlineusers(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getfiles(i_portalid IN NUMBER DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_getschedule(i_server IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);

  PROCEDURE scp_updateaccount(i_accountid IN NUMBER DEFAULT NULL, i_accountname IN VARCHAR2 DEFAULT NULL, i_description IN NVARCHAR2 DEFAULT NULL, i_email1 IN NVARCHAR2 DEFAULT NULL, i_email2 IN NVARCHAR2 DEFAULT NULL, i_isenabled IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatefolderpermission(i_folderpermissionid IN NUMBER DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updateonlineuser(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   i_lastactivedate IN DATE DEFAULT NULL);
  PROCEDURE scp_updateuserprofileproperty(i_profileid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   i_propertydefinitionid IN NUMBER DEFAULT NULL,   i_propertyvalue IN nclob DEFAULT NULL,   i_visibility IN NUMBER DEFAULT NULL,   i_lastupdateddate IN DATE DEFAULT NULL,   o_profileid OUT {databaseOwner}scp_userprofile.profileid%TYPE);
  PROCEDURE scp_updateeventlogconfig(i_id IN NUMBER DEFAULT NULL,   i_logtypekey IN nvarchar2 DEFAULT NULL,   i_logtypeportalid IN NUMBER DEFAULT NULL,   i_loggingisactive IN NUMBER DEFAULT NULL,   i_keepmostrecent IN NUMBER DEFAULT NULL,   i_emailnotificationisactive IN NUMBER DEFAULT NULL,   i_notificationthreshold IN NUMBER DEFAULT NULL,   i_notificationthresholdtime IN NUMBER DEFAULT NULL,   i_notificationthresholdtype IN NUMBER DEFAULT NULL,   i_mailfromaddress IN nvarchar2 DEFAULT NULL,   i_mailtoaddress IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updateuserrole(i_userroleid IN NUMBER DEFAULT NULL,   i_effectivedate IN DATE DEFAULT NULL,   i_expirydate IN DATE DEFAULT NULL);
  PROCEDURE scp_updatemoduledefinition(i_moduledefid IN NUMBER DEFAULT NULL,   i_friendlyname IN nvarchar2 DEFAULT NULL,   i_defaultcachetime IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatemodulecontrol(i_modulecontrolid IN NUMBER DEFAULT NULL,   i_moduledefid IN NUMBER DEFAULT NULL,   i_controlkey IN nvarchar2 DEFAULT NULL,   i_controltitle IN nvarchar2 DEFAULT NULL,   i_controlsrc IN nvarchar2 DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   i_controltype IN NUMBER DEFAULT NULL,   i_vieworder IN NUMBER DEFAULT NULL,   i_helpurl IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updatetaborder(i_tabid IN NUMBER DEFAULT NULL,   i_taborder IN NUMBER DEFAULT NULL,   i_level IN NUMBER DEFAULT NULL,   i_parentid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatefile(i_fileid IN NUMBER DEFAULT NULL,   i_filename IN nvarchar2 DEFAULT NULL,   i_extension IN nvarchar2 DEFAULT NULL,   i_size_ IN NUMBER DEFAULT NULL,   i_width IN NUMBER DEFAULT NULL,   i_height IN NUMBER DEFAULT NULL,   i_contenttype IN nvarchar2 DEFAULT NULL,   i_folder IN nvarchar2 DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updateeventlogtype(i_logtypekey IN nvarchar2 DEFAULT NULL,   i_logtypefriendlyname IN nvarchar2 DEFAULT NULL,   i_logtypedescription IN nvarchar2 DEFAULT NULL,   i_logtypeowner IN nvarchar2 DEFAULT NULL,   i_logtypecssclass IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updatesearchcommonword(i_commonwordid IN NUMBER DEFAULT NULL,   i_commonword IN nvarchar2 DEFAULT NULL,   i_locale IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updatelistsortorder(i_entryid IN NUMBER DEFAULT NULL,   i_moveup IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatevendor(i_vendorid IN NUMBER DEFAULT NULL,   i_vendorname IN nvarchar2 DEFAULT NULL,   i_unit IN nvarchar2 DEFAULT NULL,   i_street IN nvarchar2 DEFAULT NULL,   i_city IN nvarchar2 DEFAULT NULL,   i_region IN nvarchar2 DEFAULT NULL,   i_country IN nvarchar2 DEFAULT NULL,   i_postalcode IN nvarchar2 DEFAULT NULL,   i_telephone IN nvarchar2 DEFAULT NULL,   i_fax IN nvarchar2 DEFAULT NULL,   i_cell IN nvarchar2 DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL,   i_website IN nvarchar2 DEFAULT NULL,   i_firstname IN nvarchar2 DEFAULT NULL,   i_lastname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_logofile IN nvarchar2 DEFAULT NULL,   i_keywords IN CLOB DEFAULT NULL,   i_authorized IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatetabmodulesetting(i_tabmoduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL,   i_settingvalue IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updatedatabaseversion(i_major IN NUMBER DEFAULT NULL,   i_minor IN NUMBER DEFAULT NULL,   i_build IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updateurltrackingstats(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatedesktopmodule(i_desktopmoduleid IN NUMBER DEFAULT NULL,   i_modulename IN nvarchar2 DEFAULT NULL,   i_foldername IN nvarchar2 DEFAULT NULL,   i_friendlyname IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_version IN nvarchar2 DEFAULT NULL,   i_ispremium IN NUMBER DEFAULT NULL,   i_isadmin IN NUMBER DEFAULT NULL,   i_businesscontroller IN nvarchar2 DEFAULT NULL,   i_supportedfeatures IN NUMBER DEFAULT NULL,   i_compatibleversions IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updatetabmodule(i_tabid IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_moduleorder IN NUMBER DEFAULT NULL,   i_panename IN nvarchar2 DEFAULT NULL,   i_cachetime IN NUMBER DEFAULT NULL,   i_alignment IN nvarchar2 DEFAULT NULL,   i_color IN nvarchar2 DEFAULT NULL,   i_border IN nvarchar2 DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   i_visibility IN NUMBER DEFAULT NULL,   i_containersrc IN nvarchar2 DEFAULT NULL,   i_displaytitle IN NUMBER DEFAULT NULL,   i_displayprint IN NUMBER DEFAULT NULL,   i_displaysyndicate IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatebannerviews(i_bannerid IN NUMBER DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL);
  PROCEDURE scp_updaterole(i_roleid IN NUMBER DEFAULT NULL,   i_rolegroupid IN NUMBER DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_servicefee IN NUMBER DEFAULT NULL,   i_billingperiod IN NUMBER DEFAULT NULL,   i_billingfrequency IN CHAR DEFAULT NULL,   i_trialfee IN NUMBER DEFAULT NULL,   i_trialperiod IN NUMBER DEFAULT NULL,   i_trialfrequency IN CHAR DEFAULT NULL,   i_ispublic IN NUMBER DEFAULT NULL,   i_autoassignment IN NUMBER DEFAULT NULL,   i_rsvpcode IN nvarchar2 DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updatemodulesetting(i_moduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL,   i_settingvalue IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updateaffiliate(i_affiliateid IN NUMBER DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_cpc IN FLOAT DEFAULT NULL,   i_cpa IN FLOAT DEFAULT NULL);
  PROCEDURE scp_updateportalalias(i_portalaliasid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_httpalias IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updateaffiliatestats(i_affiliateid IN NUMBER DEFAULT NULL,   i_clicks IN NUMBER DEFAULT NULL,   i_acquisitions IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updateanonymoususer(i_userid IN CHAR DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   i_lastactivedate IN DATE DEFAULT NULL);
  PROCEDURE scp_updatemodule(i_moduleid IN NUMBER DEFAULT NULL,   i_moduletitle IN nvarchar2 DEFAULT NULL,   i_alltabs IN NUMBER DEFAULT NULL,   i_header IN nclob DEFAULT NULL,   i_footer IN nclob DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_inheritviewpermissions IN NUMBER DEFAULT NULL,   i_isdeleted IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updateportalaliasoninstal(i_portalalias IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updatetabpermission(i_tabpermissionid IN NUMBER DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updaterolegroup(i_rolegroupid IN NUMBER DEFAULT NULL,   i_rolegroupname IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updateportalsetup(i_portalid IN NUMBER DEFAULT NULL,   i_administratorid IN NUMBER DEFAULT NULL,   i_administratorroleid IN NUMBER DEFAULT NULL,   i_poweruserroleid IN NUMBER DEFAULT NULL,   i_registeredroleid IN NUMBER DEFAULT NULL,   i_splashtabid IN NUMBER DEFAULT NULL,   i_hometabid IN NUMBER DEFAULT NULL,   i_logintabid IN NUMBER DEFAULT NULL,   i_usertabid IN NUMBER DEFAULT NULL,   i_admintabid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatefilecontent(i_fileid IN NUMBER DEFAULT NULL,   content IN BLOB DEFAULT NULL);
  PROCEDURE scp_updatelistentry(i_entryid IN NUMBER DEFAULT NULL,   i_listname IN nvarchar2 DEFAULT NULL,   i_value IN nvarchar2 DEFAULT NULL,   i_text IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updatebanner(i_bannerid IN NUMBER DEFAULT NULL,   i_bannername IN nvarchar2 DEFAULT NULL,   i_imagefile IN nvarchar2 DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_impressions IN NUMBER DEFAULT NULL,   i_cpm IN FLOAT DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_bannertypeid IN NUMBER DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_groupname IN nvarchar2 DEFAULT NULL,   i_criteria IN NUMBER DEFAULT NULL,   i_width IN NUMBER DEFAULT NULL,   i_height IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updateschedulehistory(i_schedulehistoryid IN NUMBER DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_succeeded IN NUMBER DEFAULT NULL,   i_lognotes IN nclob DEFAULT NULL,   i_nextstart IN DATE DEFAULT NULL);
  PROCEDURE scp_updatemoduleorder(i_tabid IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_moduleorder IN NUMBER DEFAULT NULL,   i_panename IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updatetab(i_tabid IN NUMBER DEFAULT NULL,   i_tabname IN nvarchar2 DEFAULT NULL,   i_isvisible IN NUMBER DEFAULT NULL,   i_disablelink IN NUMBER DEFAULT NULL,   i_parentid IN NUMBER DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   i_title IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_keywords IN nvarchar2 DEFAULT NULL,   i_isdeleted IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_skinsrc IN nvarchar2 DEFAULT NULL,   i_containersrc IN nvarchar2 DEFAULT NULL,   i_tabpath IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_refreshinterval IN NUMBER DEFAULT NULL,   i_pageheadtext IN nvarchar2 DEFAULT NULL);
  PROCEDURE scp_updatebannerclickthrough(i_bannerid IN NUMBER DEFAULT NULL,   i_vendorid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatepropertydefinition(i_propertydefinitionid IN NUMBER DEFAULT NULL,   i_datatype IN NUMBER DEFAULT NULL,   i_defaultvalue IN nvarchar2 DEFAULT NULL,   i_propertycategory IN nvarchar2 DEFAULT NULL,   i_propertyname IN nvarchar2 DEFAULT NULL,   i_required IN NUMBER DEFAULT NULL,   i_validationexpression IN nvarchar2 DEFAULT NULL,   i_vieworder IN NUMBER DEFAULT NULL,   i_visible IN NUMBER DEFAULT NULL,   i_length IN NUMBER DEFAULT NULL,   i_searchable IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatehostsetting(i_settingname IN nvarchar2 DEFAULT NULL,   i_settingvalue IN nvarchar2 DEFAULT NULL,   i_settingissecure IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatesearchitem(i_searchitemid IN NUMBER DEFAULT NULL,   i_title IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_author IN NUMBER DEFAULT NULL,   i_pubdate IN DATE DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_searchkey IN nvarchar2 DEFAULT NULL,   i_guid IN nvarchar2 DEFAULT NULL,   i_hitcount IN NUMBER DEFAULT NULL,   i_imagefileid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatefolder(i_portalid IN NUMBER DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   i_folderpath IN VARCHAR2 DEFAULT NULL,   i_storagelocation IN NUMBER DEFAULT NULL,   i_isprotected IN NUMBER DEFAULT NULL,   i_iscached IN NUMBER DEFAULT NULL,   i_lastupdated IN DATE DEFAULT NULL);
  PROCEDURE scp_updateprofile(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_profiledata IN nclob DEFAULT NULL);
  PROCEDURE scp_updatesystemmessage(i_portalid IN NUMBER DEFAULT NULL,   i_messagename IN nvarchar2 DEFAULT NULL,   i_messagevalue IN nclob DEFAULT NULL);
  PROCEDURE scp_updatesearchitemwordposit(i_searchitemwordpositionid IN NUMBER DEFAULT NULL,   i_searchitemwordid IN NUMBER DEFAULT NULL,   i_contentposition IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updateschedule(i_scheduleid IN NUMBER DEFAULT NULL,   i_typefullname IN VARCHAR2 DEFAULT NULL,   i_timelapse IN NUMBER DEFAULT NULL,   i_timelapsemeasurement IN VARCHAR2 DEFAULT NULL,   i_retrytimelapse IN NUMBER DEFAULT NULL,   i_retrytimelapsemeasurement IN VARCHAR2 DEFAULT NULL,   i_retainhistorynum IN NUMBER DEFAULT NULL,   i_attachtoevent IN VARCHAR2 DEFAULT NULL,   i_catchupenabled IN NUMBER DEFAULT NULL,   i_enabled IN NUMBER DEFAULT NULL,   i_objectdependencies IN VARCHAR2 DEFAULT NULL,   i_servers IN VARCHAR2 DEFAULT NULL);
  PROCEDURE scp_updatesearchitemword(i_searchitemwordid IN NUMBER DEFAULT NULL,   i_searchitemid IN NUMBER DEFAULT NULL,   i_searchwordsid IN NUMBER DEFAULT NULL,   i_occurrences IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updateurltracking(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_logactivity IN NUMBER DEFAULT NULL,   i_trackclicks IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_newwindow IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updateuser(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_firstname IN nvarchar2 DEFAULT NULL,   i_lastname IN nvarchar2 DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL,   i_displayname IN nvarchar2 DEFAULT NULL,   i_updatepassword IN NUMBER DEFAULT NULL,   i_authorised IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatepermission(i_permissionid IN NUMBER DEFAULT NULL,   i_permissioncode IN VARCHAR2 DEFAULT NULL,   i_moduledefid IN NUMBER DEFAULT NULL,   i_permissionkey IN VARCHAR2 DEFAULT NULL,   i_permissionname IN VARCHAR2 DEFAULT NULL);
  PROCEDURE scp_updateportalinfo(i_portalid IN NUMBER DEFAULT NULL,   i_portalname IN nvarchar2 DEFAULT NULL,   i_logofile IN nvarchar2 DEFAULT NULL,   i_footertext IN nvarchar2 DEFAULT NULL,   i_expirydate IN DATE DEFAULT NULL,   i_userregistration IN NUMBER DEFAULT NULL,   i_banneradvertising IN NUMBER DEFAULT NULL,   i_currency IN CHAR DEFAULT NULL,   i_administratorid IN NUMBER DEFAULT NULL,   i_hostfee IN NUMBER DEFAULT NULL,   i_hostspace IN NUMBER DEFAULT NULL,   i_pagequota IN NUMBER DEFAULT NULL,   i_userquota IN NUMBER DEFAULT NULL,   i_paymentprocessor IN nvarchar2 DEFAULT NULL,   i_processoruserid IN nvarchar2 DEFAULT NULL,   i_processorpassword IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_keywords IN nvarchar2 DEFAULT NULL,   i_backgroundfile IN nvarchar2 DEFAULT NULL,   i_siteloghistory IN NUMBER DEFAULT NULL,   i_splashtabid IN NUMBER DEFAULT NULL,   i_hometabid IN NUMBER DEFAULT NULL,   i_logintabid IN NUMBER DEFAULT NULL,   i_usertabid IN NUMBER DEFAULT NULL,   i_defaultlanguage IN nvarchar2 DEFAULT NULL,   i_timezoneoffset IN NUMBER DEFAULT NULL,   i_homedirectory IN VARCHAR2 DEFAULT NULL,   i_adminaccountid IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatesearchword(i_searchwordsid IN NUMBER DEFAULT NULL,   i_word IN nvarchar2 DEFAULT NULL,   i_iscommon IN NUMBER DEFAULT NULL,   i_hitcount IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updatemodulepermission(i_modulepermissionid IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL);
  PROCEDURE scp_updateeventlogpendingnoti(i_logconfigid IN NUMBER DEFAULT NULL);

  PROCEDURE scp_listsearchitemwordpositio(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_purgeeventlog;
  PROCEDURE scp_verifyportaltab(i_portalid IN NUMBER DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_finddatabaseversion(i_major IN NUMBER DEFAULT NULL,   i_minor IN NUMBER DEFAULT NULL,   i_build IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_listsearchitemword(o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_purgeschedulehistory;
  PROCEDURE scp_findbanners(i_portalid IN NUMBER DEFAULT NULL,   i_bannertypeid IN NUMBER DEFAULT NULL,   i_groupname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_verifyportal(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_isuserinrole(i_userid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE scp_listsearchitem(o_rc1 OUT {databaseOwner}global_pkg.rct1);
END scpuke_pkg;
/

