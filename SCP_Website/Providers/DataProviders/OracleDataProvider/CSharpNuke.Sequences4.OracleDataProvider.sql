DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( ACCOUNTID), 0) +1 INTO startval FROM {databaseOwner}SCP_ACCOUNTNUMBERS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_ACCOUNTNUMBERS
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_ACCOUNTNUMBERS BEFORE INSERT ON {databaseOwner}SCP_ACCOUNTNUMBERS
 FOR EACH ROW WHEN (new.ACCOUNTID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_ACCOUNTNUMBERS.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.ACCOUNTID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( QUESTIONID), 0) +1 INTO startval FROM {databaseOwner}SCP_QUESTIONS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_QUESTIONS
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_QUESTIONS BEFORE INSERT ON {databaseOwner}SCP_QUESTIONS
 FOR EACH ROW WHEN (new.QUESTIONID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_QUESTIONS.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.QUESTIONID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( PROFILEID), 0) +1 INTO startval FROM {databaseOwner}SCP_USERPROFILE;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_USERPROFILE
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_USERPROFILE BEFORE INSERT ON {databaseOwner}SCP_USERPROFILE
 FOR EACH ROW WHEN (new.PROFILEID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_USERPROFILE.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.PROFILEID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( CLASSIFICATIONID), 0) +1 INTO startval FROM {databaseOwner}SCP_CLASSIFICATION;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_CLASSIFICATI
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_CLASSIFICATI BEFORE INSERT ON
 {databaseOwner}SCP_CLASSIFICATION FOR EACH ROW WHEN (new.CLASSIFICATIONID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_CLASSIFICATI.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.CLASSIFICATIONID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( ID), 0) +1 INTO startval FROM {databaseOwner}SCP_EVENTLOGCONFIG;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_EVENTLOGCONF
 START WITH ' || startval; END; 
/


CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_EVENTLOGCONF BEFORE INSERT ON
 {databaseOwner}SCP_EVENTLOGCONFIG FOR EACH ROW WHEN (new.ID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_EVENTLOGCONF.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.ID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( ENTRYID), 0) +1 INTO startval FROM {databaseOwner}SCP_LISTS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_LISTS START
 WITH ' || startval; END; 
/


CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_LISTS BEFORE INSERT ON {databaseOwner}SCP_LISTS
 FOR EACH ROW WHEN (new.ENTRYID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_LISTS.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.ENTRYID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( USERID), 0) +1 INTO startval FROM {databaseOwner}SCP_USERS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_USERS START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_USERS BEFORE INSERT ON {databaseOwner}SCP_USERS
 FOR EACH ROW WHEN (new.USERID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_USERS.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.USERID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( SEARCHITEMID), 0) +1 INTO startval FROM {databaseOwner}SCP_SEARCHITEM;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_SEARCHITEM START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_SEARCHITEM BEFORE INSERT ON {databaseOwner}SCP_SEARCHITEM
 FOR EACH ROW WHEN (new.SEARCHITEMID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_SEARCHITEM.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.SEARCHITEMID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( VENDORCLASSIFICATIONID), 0) +1 INTO startval FROM
 {databaseOwner}SCP_VENDORCLASSIFICATION; EXECUTE IMMEDIATE 'CREATE SEQUENCE
 {databaseOwner}SQ_SCP_VENDORCLASSI START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_VENDORCLASSI BEFORE INSERT ON
 {databaseOwner}SCP_VENDORCLASSIFICATION FOR EACH ROW WHEN (new.VENDORCLASSIFICATIONID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_VENDORCLASSI.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.VENDORCLASSIFICATIONID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( PORTALDESKTOPMODULEID), 0) +1 INTO startval FROM
 {databaseOwner}SCP_PORTALDESKTOPMODULES; EXECUTE IMMEDIATE 'CREATE SEQUENCE
 {databaseOwner}SQ_SCP_PORTALDESKTO START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_PORTALDESKTO BEFORE INSERT ON
 {databaseOwner}SCP_PORTALDESKTOPMODULES FOR EACH ROW WHEN (new.PORTALDESKTOPMODULEID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_PORTALDESKTO.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.PORTALDESKTOPMODULEID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( BANNERID), 0) +1 INTO startval FROM {databaseOwner}SCP_BANNERS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_BANNERS START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_BANNERS BEFORE INSERT ON {databaseOwner}SCP_BANNERS
 FOR EACH ROW WHEN (new.BANNERID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_BANNERS.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.BANNERID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( PORTALALIASID), 0) +1 INTO startval FROM {databaseOwner}SCP_PORTALALIAS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_PORTALALIAS
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_PORTALALIAS BEFORE INSERT ON {databaseOwner}SCP_PORTALALIAS
 FOR EACH ROW WHEN (new.PORTALALIASID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_PORTALALIAS.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.PORTALALIASID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( USERROLEID), 0) +1 INTO startval FROM {databaseOwner}SCP_USERROLES;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_USERROLES START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_USERROLES BEFORE INSERT ON {databaseOwner}SCP_USERROLES
 FOR EACH ROW WHEN (new.USERROLEID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_USERROLES.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.USERROLEID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( VENDORID), 0) +1 INTO startval FROM {databaseOwner}SCP_VENDORS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_VENDORS START
 WITH ' || startval; END; 
/


CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_VENDORS BEFORE INSERT ON {databaseOwner}SCP_VENDORS
 FOR EACH ROW WHEN (new.VENDORID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_VENDORS.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.VENDORID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( PROPERTYDEFINITIONID), 0) +1 INTO startval FROM
 {databaseOwner}SCP_PROFILEPROPERTYDEFINITION; EXECUTE IMMEDIATE 'CREATE SEQUENCE
 {databaseOwner}SQ_SCP_PROFILEPROPE START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_PROFILEPROPE BEFORE INSERT ON
 {databaseOwner}SCP_PROFILEPROPERTYDEFINITION FOR EACH ROW WHEN (new.PROPERTYDEFINITIONID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_PROFILEPROPE.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.PROPERTYDEFINITIONID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( PORTALID), 0) +1 INTO startval FROM {databaseOwner}SCP_PORTALS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_PORTALS START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_PORTALS BEFORE INSERT ON {databaseOwner}SCP_PORTALS
 FOR EACH ROW WHEN (new.PORTALID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_PORTALS.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.PORTALID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( ROLEGROUPID), 0) +1 INTO startval FROM {databaseOwner}SCP_ROLEGROUPS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_ROLEGROUPS START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_ROLEGROUPS BEFORE INSERT ON {databaseOwner}SCP_ROLEGROUPS
 FOR EACH ROW WHEN (new.ROLEGROUPID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_ROLEGROUPS.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.ROLEGROUPID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( COMMONWORDID), 0) +1 INTO startval FROM {databaseOwner}SCP_SEARCHCOMMONWORDS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_SEARCHCOMMON
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_SEARCHCOMMON BEFORE INSERT ON
 {databaseOwner}SCP_SEARCHCOMMONWORDS FOR EACH ROW WHEN (new.COMMONWORDID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_SEARCHCOMMON.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.COMMONWORDID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( DESKTOPMODULEID), 0) +1 INTO startval FROM {databaseOwner}SCP_DESKTOPMODULES;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_DESKTOPMODUL
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_DESKTOPMODUL BEFORE INSERT ON
 {databaseOwner}SCP_DESKTOPMODULES FOR EACH ROW WHEN (new.DESKTOPMODULEID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_DESKTOPMODUL.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.DESKTOPMODULEID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( SKINID), 0) +1 INTO startval FROM {databaseOwner}SCP_SKINS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_SKINS START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_SKINS BEFORE INSERT ON {databaseOwner}SCP_SKINS
 FOR EACH ROW WHEN (new.SKINID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_SKINS.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.SKINID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( SEARCHWORDSID), 0) +1 INTO startval FROM {databaseOwner}SCP_SEARCHWORD;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_SEARCHWORD START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_SEARCHWORD BEFORE INSERT ON {databaseOwner}SCP_SEARCHWORD
 FOR EACH ROW WHEN (new.SEARCHWORDSID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_SEARCHWORD.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.SEARCHWORDSID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( TABPERMISSIONID), 0) +1 INTO startval FROM {databaseOwner}SCP_TABPERMISSION;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_TABPERMISSION
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_TABPERMISSION BEFORE INSERT ON
 {databaseOwner}SCP_TABPERMISSION FOR EACH ROW WHEN (new.TABPERMISSIONID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_TABPERMISSION.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.TABPERMISSIONID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( MODULECONTROLID), 0) +1 INTO startval FROM {databaseOwner}SCP_MODULECONTROLS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_MODULECONTRO
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_MODULECONTRO BEFORE INSERT ON
 {databaseOwner}SCP_MODULECONTROLS FOR EACH ROW WHEN (new.MODULECONTROLID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_MODULECONTRO.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.MODULECONTROLID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( TABMODULEID), 0) +1 INTO startval FROM {databaseOwner}SCP_TABMODULES;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_TABMODULES START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_TABMODULES BEFORE INSERT ON {databaseOwner}SCP_TABMODULES
 FOR EACH ROW WHEN (new.TABMODULEID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_TABMODULES.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.TABMODULEID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( MODULEDEFID), 0) +1 INTO startval FROM {databaseOwner}SCP_MODULEDEFINITIONS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_MODULEDEFINI
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_MODULEDEFINI BEFORE INSERT ON
 {databaseOwner}SCP_MODULEDEFINITIONS FOR EACH ROW WHEN (new.MODULEDEFID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_MODULEDEFINI.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.MODULEDEFID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( FOLDERPERMISSIONID), 0) +1 INTO startval FROM {databaseOwner}SCP_FOLDERPERMISSION;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_FOLDERPERMIS
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_FOLDERPERMIS BEFORE INSERT ON
 {databaseOwner}SCP_FOLDERPERMISSION FOR EACH ROW WHEN (new.FOLDERPERMISSIONID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_FOLDERPERMIS.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.FOLDERPERMISSIONID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( SEARCHITEMWORDPOSITIONID), 0) +1 INTO startval
 FROM {databaseOwner}SCP_SEARCHITEMWORDPOSITION; EXECUTE IMMEDIATE 'CREATE SEQUENCE
 {databaseOwner}SQ_SCP_SEARCHITEMWORDPOS START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_SEARCHITEMWORDPOS BEFORE INSERT ON
 {databaseOwner}SCP_SEARCHITEMWORDPOSITION FOR EACH ROW WHEN (new.SEARCHITEMWORDPOSITIONID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_SEARCHITEMWORDPOS.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.SEARCHITEMWORDPOSITIONID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( SITELOGID), 0) +1 INTO startval FROM {databaseOwner}SCP_SITELOG;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_SITELOG START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_SITELOG BEFORE INSERT ON {databaseOwner}SCP_SITELOG
 FOR EACH ROW WHEN (new.SITELOGID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_SITELOG.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.SITELOGID:={databaseOwner}global_Pkg.identity;
 END;
/


DECLARE 
  v_exists NUMBER(1,0);
  v_startval NUMBER(10,0);
BEGIN  
    v_exists := 0;
    SELECT COUNT(*) 
    INTO v_exists
    FROM user_objects
    WHERE LOWER(OBJECT_NAME) = LOWER('SQ_SCP_VERSION')
    AND OBJECT_TYPE = 'SEQUENCE';
    
    IF v_exists = 0 THEN
      SELECT NVL (MAX(VERSIONID), 0) +1 INTO v_startval FROM {databaseOwner}SCP_VERSION;
      EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_VERSION START WITH ' || v_startval; 
    END IF;
    
    v_exists := 0;
    SELECT COUNT(*)
    INTO v_exists
    FROM user_tables
    WHERE LOWER(TABLE_NAME) = LOWER('scp_Version');
 
    IF v_exists = 1 THEN
      v_exists := 0;
      SELECT COUNT(*) 
      INTO v_exists
      FROM user_objects
      WHERE LOWER(OBJECT_NAME) = LOWER('TR_SQ_SCP_VERSION') 
      AND OBJECT_TYPE = 'TRIGGER';
      IF v_exists = 0 THEN 
        EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_VERSION BEFORE INSERT ON {databaseOwner}SCP_VERSION
        FOR EACH ROW WHEN (new.VERSIONID IS NULL) BEGIN SELECT {databaseOwner}SQ_SCP_VERSION.nextval
        INTO {databaseOwner}global_Pkg.identity FROM dual; :new.VERSIONID:={databaseOwner}global_Pkg.identity; END;';
      END IF;
  END IF;
END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( SCHEDULEID), 0) +1 INTO startval FROM {databaseOwner}SCP_SCHEDULE;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_SCHEDULE START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_SCHEDULE BEFORE INSERT ON {databaseOwner}SCP_SCHEDULE
 FOR EACH ROW WHEN (new.SCHEDULEID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_SCHEDULE.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.SCHEDULEID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( FOLDERID), 0) +1 INTO startval FROM {databaseOwner}SCP_FOLDERS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_FOLDERS START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_FOLDERS BEFORE INSERT ON {databaseOwner}SCP_FOLDERS
 FOR EACH ROW WHEN (new.FOLDERID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_FOLDERS.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.FOLDERID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( SEARCHINDEXERID), 0) +1 INTO startval FROM {databaseOwner}SCP_SEARCHINDEXER;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_SEARCHINDEXER
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_SEARCHINDEXER BEFORE INSERT ON
 {databaseOwner}SCP_SEARCHINDEXER FOR EACH ROW WHEN (new.SEARCHINDEXERID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_SEARCHINDEXER.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.SEARCHINDEXERID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( URLLOGID), 0) +1 INTO startval FROM {databaseOwner}SCP_URLLOG;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_URLLOG START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_URLLOG BEFORE INSERT ON {databaseOwner}SCP_URLLOG
 FOR EACH ROW WHEN (new.URLLOGID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_URLLOG.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.URLLOGID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( MODULEID), 0) +1 INTO startval FROM {databaseOwner}SCP_MODULES;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_MODULES START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_MODULES BEFORE INSERT ON {databaseOwner}SCP_MODULES
 FOR EACH ROW WHEN (new.MODULEID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_MODULES.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.MODULEID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( MESSAGEID), 0) +1 INTO startval FROM {databaseOwner}SCP_SYSTEMMESSAGES;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_SYSTEMMESSAG
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_SYSTEMMESSAG BEFORE INSERT ON
 {databaseOwner}SCP_SYSTEMMESSAGES FOR EACH ROW WHEN (new.MESSAGEID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_SYSTEMMESSAG.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.MESSAGEID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( USERPORTALID), 0) +1 INTO startval FROM {databaseOwner}SCP_USERPORTALS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_USERPORTALS
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_USERPORTALS BEFORE INSERT ON {databaseOwner}SCP_USERPORTALS
 FOR EACH ROW WHEN (new.USERPORTALID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_USERPORTALS.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.USERPORTALID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( ROLEID), 0) +1 INTO startval FROM {databaseOwner}SCP_ROLES;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_ROLES START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_ROLES BEFORE INSERT ON {databaseOwner}SCP_ROLES
 FOR EACH ROW WHEN (new.ROLEID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_ROLES.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.ROLEID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( PROFILEID), 0) +1 INTO startval FROM {databaseOwner}SCP_PROFILE;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_PROFILE START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_PROFILE BEFORE INSERT ON {databaseOwner}SCP_PROFILE
 FOR EACH ROW WHEN (new.PROFILEID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_PROFILE.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.PROFILEID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( PERMISSIONID), 0) +1 INTO startval FROM {databaseOwner}SCP_PERMISSION;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_PERMISSION START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_PERMISSION BEFORE INSERT ON {databaseOwner}SCP_PERMISSION
 FOR EACH ROW WHEN (new.PERMISSIONID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_PERMISSION.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.PERMISSIONID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( FILEID), 0) +1 INTO startval FROM {databaseOwner}SCP_FILES;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_FILES START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_FILES BEFORE INSERT ON {databaseOwner}SCP_FILES
 FOR EACH ROW WHEN (new.FILEID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_FILES.nextval INTO
 {databaseOwner}global_Pkg.identity FROM dual; :new.FILEID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( AFFILIATEID), 0) +1 INTO startval FROM {databaseOwner}SCP_AFFILIATES;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_AFFILIATES START
 WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_AFFILIATES BEFORE INSERT ON {databaseOwner}SCP_AFFILIATES
 FOR EACH ROW WHEN (new.AFFILIATEID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_AFFILIATES.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.AFFILIATEID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( SCHEDULEHISTORYID), 0) +1 INTO startval FROM {databaseOwner}SCP_SCHEDULEHISTORY;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_SCHEDULEHIST
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_SCHEDULEHIST BEFORE INSERT ON
 {databaseOwner}SCP_SCHEDULEHISTORY FOR EACH ROW WHEN (new.SCHEDULEHISTORYID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_SCHEDULEHIST.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.SCHEDULEHISTORYID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( MODULEPERMISSIONID), 0) +1 INTO startval FROM {databaseOwner}SCP_MODULEPERMISSION;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_MODULEPERMIS
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_MODULEPERMIS BEFORE INSERT ON
 {databaseOwner}SCP_MODULEPERMISSION FOR EACH ROW WHEN (new.MODULEPERMISSIONID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_MODULEPERMIS.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.MODULEPERMISSIONID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( TABID), 0) +1 INTO startval FROM {databaseOwner}SCP_TABS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_TABS START WITH
 ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_TABS BEFORE INSERT ON {databaseOwner}SCP_TABS
 FOR EACH ROW WHEN (new.TABID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_TABS.nextval INTO {databaseOwner}global_Pkg.identity
 FROM dual; :new.TABID:={databaseOwner}global_Pkg.identity; END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( URLTRACKINGID), 0) +1 INTO startval FROM {databaseOwner}SCP_URLTRACKING;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_URLTRACKING
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_URLTRACKING BEFORE INSERT ON {databaseOwner}SCP_URLTRACKING
 FOR EACH ROW WHEN (new.URLTRACKINGID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_URLTRACKING.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.URLTRACKINGID:={databaseOwner}global_Pkg.identity;
 END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( URLID), 0) +1 INTO startval FROM {databaseOwner}SCP_URLS;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_URLS START WITH
 ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_URLS BEFORE INSERT ON {databaseOwner}SCP_URLS
 FOR EACH ROW WHEN (new.URLID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_URLS.nextval INTO {databaseOwner}global_Pkg.identity
 FROM dual; :new.URLID:={databaseOwner}global_Pkg.identity; END;
/

DECLARE startval NUMBER; BEGIN SELECT NVL (MAX( SEARCHITEMWORDID), 0) +1 INTO startval FROM {databaseOwner}SCP_SEARCHITEMWORD;
 EXECUTE IMMEDIATE 'CREATE SEQUENCE {databaseOwner}SQ_SCP_SEARCHITEMWO
 START WITH ' || startval; END; 
/

CREATE OR REPLACE TRIGGER {databaseOwner}TR_SQ_SCP_SEARCHITEMWO BEFORE INSERT ON
 {databaseOwner}SCP_SEARCHITEMWORD FOR EACH ROW WHEN (new.SEARCHITEMWORDID IS NULL)  BEGIN  SELECT {databaseOwner}SQ_SCP_SEARCHITEMWO.nextval
 INTO {databaseOwner}global_Pkg.identity FROM dual; :new.SEARCHITEMWORDID:={databaseOwner}global_Pkg.identity;
 END;
/