CREATE OR REPLACE PACKAGE BODY {databaseOwner}scpuke_pkg AS

  --------------------------------------------------------
  --  DDL for Function FORMATSQL
  --------------------------------------------------------

  FUNCTION FORMATSQL(i_value IN NVARCHAR2) RETURN NVARCHAR2 AS
    v_value NVARCHAR2(50);
  BEGIN
    
    v_value := REPLACE(i_value, '_', '\_');
  
    RETURN v_value;
    
  END FORMATSQL;
  
  --------------------------------------------------------
  --  DDL for Function DATEADD
  --------------------------------------------------------

  FUNCTION DATEADD(INTERVAL VARCHAR2,   adding NUMBER,   entry_date DATE) RETURN DATE AS
    result DATE;
  BEGIN

    IF(UPPER(INTERVAL) = 'D') OR(UPPER(INTERVAL) = 'Y') OR(UPPER(INTERVAL) = 'W') OR(UPPER(INTERVAL) = 'DD') OR(UPPER(INTERVAL) = 'DDD') OR(UPPER(INTERVAL) = 'DAY') THEN
      result := entry_date + adding;
    ELSIF
      (UPPER(INTERVAL) = 'WW') OR(UPPER(INTERVAL) = 'IW') OR(UPPER(INTERVAL) = 'WEEK') THEN
      result := entry_date +(adding *7);
    ELSIF
      (UPPER(INTERVAL) = 'YYYY') OR(UPPER(INTERVAL) = 'YEAR') THEN
      result := add_months(entry_date,   adding *12);
    ELSIF
          (UPPER(INTERVAL) = 'Q') OR(UPPER(INTERVAL) = 'QUARTER') THEN
            result := add_months(entry_date,   adding *3);
    ELSIF
      (UPPER(INTERVAL) = 'M') OR(UPPER(INTERVAL) = 'MM') OR(UPPER(INTERVAL) = 'MONTH') THEN
      result := add_months(entry_date,   adding);
    ELSIF
      (UPPER(INTERVAL) = 'H') OR(UPPER(INTERVAL) = 'HH') OR(UPPER(INTERVAL) = 'HOUR') THEN
      result := entry_date +(adding / 24);
    ELSIF
      (UPPER(INTERVAL) = 'N') OR(UPPER(INTERVAL) = 'MI') OR(UPPER(INTERVAL) = 'MINUTE') THEN
      result := entry_date +(adding / 24 / 60);
    ELSIF
      (UPPER(INTERVAL) = 'S') OR(UPPER(INTERVAL) = 'SS') OR(UPPER(INTERVAL) = 'SECOND') THEN
      result := entry_date +(adding / 24 / 60 / 60);
    END IF;

    RETURN result;

    EXCEPTION
    WHEN others THEN
      raise_application_error('-20000',   sqlerrm);
      return null;
  END dateadd;
  
  --------------------------------------------------------
  --  DDL for Function CSWS_GETELEMENT
  --------------------------------------------------------
  
  FUNCTION SCP_GETELEMENT (i_ord IN NUMBER DEFAULT NULL,   i_str IN VARCHAR2 DEFAULT NULL,   i_delim IN VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
    v_pos NUMBER(10,   0);
    v_curord NUMBER(10,   0);
  BEGIN
    BEGIN
  
      IF i_str IS NULL OR LENGTH(i_str) = 0 OR i_ord IS NULL OR i_ord < 1 OR i_ord > LENGTH(i_str) -LENGTH(REPLACE(i_str,   i_delim,   '')) + 1 THEN
        RETURN NULL;
      END IF;
  
      v_pos := 1;
      v_curord := 1;
  
      WHILE v_curord < i_ord
      LOOP
  
        v_pos := instr(i_str,   i_delim,   v_pos) + 1;
        v_curord := v_curord + 1;
  
      END LOOP;
  
      RETURN CAST(substr(i_str,   v_pos,   instr(i_str || i_delim,   i_delim,   v_pos) - v_pos) AS NUMBER);
    END;
  END scp_getelement;
   
  --------------------------------------------------------
  --  DDL for Function CSWS_GETPROFILEELEMENT
  --------------------------------------------------------
  
  FUNCTION SCP_GETPROFILEELEMENT (i_fieldname IN nvarchar2 DEFAULT NULL,   i_fields IN nvarchar2 DEFAULT NULL,   i_values IN nvarchar2 DEFAULT NULL) RETURN nvarchar2 AS
    v_fieldnametoken nvarchar2(20);
    v_fieldnamestart NUMBER(10,   0);
    v_valuestart NUMBER(10,   0);
    v_valuelength NUMBER(10,   0);
  BEGIN
    BEGIN
  
      IF i_fieldname IS NULL OR LENGTH(i_fieldname) = 0 OR i_fields IS NULL OR LENGTH(i_fields) = 0 OR i_values IS NULL OR LENGTH(i_values) = 0 THEN
        RETURN NULL;
      END IF;
  
      v_fieldnamestart := instr(i_fields,   i_fieldname || ':S',   0);
  
      IF v_fieldnamestart = 0 THEN
        RETURN NULL;
      END IF;
  
      v_fieldnamestart := v_fieldnamestart + LENGTH(i_fieldname) + 3;
      v_fieldnametoken := SUBSTR(i_fields,   v_fieldnamestart,   LENGTH(i_fields) -v_fieldnamestart);
  
      v_valuestart := {databaseOwner}scpuke_pkg.scp_getelement(1,   v_fieldnametoken,   ':');
  
      v_valuelength := {databaseOwner}scpuke_pkg.scp_getelement(2,   v_fieldnametoken,   ':');
  
      IF v_valuelength = 0 THEN
        RETURN '';
      END IF;
  
      RETURN SUBSTR(i_values,   v_valuestart + 1,   v_valuelength);
    END;
  END scp_getprofileelement;
   
  --------------------------------------------------------
  --  DDL for Function CSWS_GETPROFILEPROPERTYDEFINIT
  --------------------------------------------------------
  
  FUNCTION SCP_GETPROFILEPROPERTYDEFINIT (i_portalid IN NUMBER DEFAULT NULL,   i_propertyname IN nvarchar2 DEFAULT NULL) RETURN NUMBER AS
    v_definitionid NUMBER(10,   0);
    v_portalid NUMBER(10,   0);
  BEGIN
    BEGIN
  
      v_definitionid := -1;
  
      IF i_propertyname IS NULL OR LENGTH(i_propertyname) = 0 THEN
        RETURN -1;
      END IF;
  
      IF i_portalid IS NULL THEN
        v_portalid := -1;
        ELSE
        v_portalid := i_portalid;
      END IF;
  
      SELECT propertydefinitionid
      INTO v_definitionid
      FROM {databaseOwner}scp_profilepropertydefinition
      WHERE portalid = v_portalid
       AND propertyname = i_propertyname;
      RETURN v_definitionid;
    END;
  END scp_getprofilepropertydefinit;
   
  --------------------------------------------------------
  --  DDL for Function CSWS_FN_GETVERSION
  --------------------------------------------------------
  
  FUNCTION SCP_FN_GETVERSION (i_maj IN NUMBER DEFAULT NULL,   i_min IN NUMBER DEFAULT NULL,   i_bld IN NUMBER DEFAULT NULL) RETURN NUMBER AS
    v_exists NUMBER(10,   0);
  BEGIN
    BEGIN
  
      BEGIN
        v_exists := 0;
        SELECT COUNT(*)
        INTO v_exists
        FROM dual
        WHERE EXISTS
          (SELECT *
           FROM {databaseOwner}scp_version
           WHERE major = i_maj
           AND minor = i_min
           AND build = i_bld)
        ;
  
      END;
  
      IF v_exists != 0 THEN
        BEGIN
          RETURN 1;
        END;
      END IF;
  
      RETURN 0;
    END;
  END scp_fn_getversion;
  
  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDACCOUNT
  -------------------------------------------------------- 
 
  PROCEDURE scp_addaccount(i_portalid IN NUMBER DEFAULT NULL, i_accountnumber IN VARCHAR2 DEFAULT NULL, i_accountname IN VARCHAR2 DEFAULT NULL, i_description IN NVARCHAR2 DEFAULT NULL, i_email1 IN NVARCHAR2 DEFAULT NULL, i_email2 IN NVARCHAR2 DEFAULT NULL,  i_isenabled IN NUMBER DEFAULT NULL, o_accountid OUT NUMBER) AS  
  BEGIN
    
    INSERT
    INTO {databaseOwner}scp_accountnumbers(portalid, accountnumber, accountname, description, email1, email2, isenabled)
    VALUES (i_portalid, i_accountnumber, i_accountname, i_description, i_email1, i_email2, i_isenabled)
    RETURNING accountid INTO o_accountid;        
    
  END scp_addaccount;
 
  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDPORTALALIAS
  --------------------------------------------------------

  PROCEDURE scp_addportalalias(i_portalid IN NUMBER DEFAULT NULL,   i_httpalias IN nvarchar2 DEFAULT NULL,   o_portalaliasid OUT {databaseOwner}scp_portalalias.portalaliasid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_portalalias(portalid,   httpalias)
    VALUES(i_portalid,   i_httpalias) returning portalaliasid
    INTO o_portalaliasid;

  END scp_addportalalias;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDSCHEDULEHISTORY
  --------------------------------------------------------

  PROCEDURE scp_addschedulehistory(i_scheduleid IN NUMBER DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_server IN NVARCHAR2 DEFAULT NULL,   o_schedulehistoryid OUT {databaseOwner}scp_schedulehistory.schedulehistoryid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_schedulehistory(scheduleid,   startdate,   server)
    VALUES(i_scheduleid,   i_startdate,   i_server) returning schedulehistoryid
    INTO o_schedulehistoryid;

  END scp_addschedulehistory;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDEVENTLOG
  --------------------------------------------------------

  PROCEDURE scp_addeventlog(i_logguid IN VARCHAR2 DEFAULT NULL,   i_logtypekey IN nvarchar2 DEFAULT NULL,   i_loguserid IN NUMBER DEFAULT NULL,   i_logusername IN nvarchar2 DEFAULT NULL,   i_logportalid IN NUMBER DEFAULT NULL,   i_logportalname IN nvarchar2 DEFAULT NULL,   i_logcreatedate IN DATE DEFAULT NULL,   i_logservername IN nvarchar2 DEFAULT NULL,   i_logproperties IN nclob DEFAULT NULL,   i_logconfigid IN NUMBER DEFAULT NULL) AS
  v_notificationactive NUMBER(1,   0);
  v_notificationthreshold NUMBER(1,   0);
  v_thresholdqueue NUMBER(10,   0);
  v_notificationthresholdtime NUMBER(10,   0);
  v_notificationthresholdtype NUMBER(10,   0);
  v_mindatetime DATE;
  v_currentdatetime DATE;
  BEGIN
    INSERT
    INTO {databaseOwner}scp_eventlog(logguid,   logtypekey,   loguserid,   logusername,   logportalid,   logportalname,   logcreatedate,   logservername,   logproperties,   logconfigid)
    VALUES(i_logguid,   i_logtypekey,   i_loguserid,   i_logusername,   i_logportalid,   i_logportalname,   i_logcreatedate,   i_logservername,   i_logproperties,   i_logconfigid);

    v_currentdatetime := sysdate;
    FOR rec IN
      (SELECT emailnotificationisactive,
         notificationthreshold,
         notificationthresholdtime,
         notificationthresholdtimetype,
         CASE
       WHEN notificationthresholdtimetype = 1 THEN
        {databaseOwner}scpuke_pkg.dateadd('SS',    notificationthresholdtime *-1,    v_currentdatetime)
       WHEN notificationthresholdtimetype = 2 THEN
        {databaseOwner}scpuke_pkg.dateadd('MI',    notificationthresholdtime *-1,    v_currentdatetime)
       WHEN notificationthresholdtimetype = 3 THEN
        {databaseOwner}scpuke_pkg.dateadd('HH',    notificationthresholdtime *-1,    v_currentdatetime)
       WHEN notificationthresholdtimetype = 4 THEN
        {databaseOwner}scpuke_pkg.dateadd('DD',    notificationthresholdtime *-1,    v_currentdatetime)
       END tmp_mindatetime
       FROM {databaseOwner}scp_eventlogconfig
       WHERE id = i_logconfigid)
    LOOP
      v_notificationactive := rec.emailnotificationisactive;
      v_notificationthreshold := rec.notificationthreshold;
      v_notificationthresholdtime := rec.notificationthresholdtime;
      v_notificationthresholdtype := rec.notificationthresholdtimetype;
      v_mindatetime := rec.tmp_mindatetime;
    END LOOP;

    IF v_notificationactive = 1 THEN
      BEGIN

        SELECT COUNT(*)
        INTO v_thresholdqueue
        FROM {databaseOwner}scp_eventlog
        INNER JOIN {databaseOwner}scp_eventlogconfig ON scp_eventlog.logconfigid = scp_eventlogconfig.id
        WHERE logcreatedate > v_mindatetime;

        DBMS_OUTPUT.PUT_LINE('MinDateTime=' || v_mindatetime);
        DBMS_OUTPUT.PUT_LINE('ThresholdQueue=' || v_thresholdqueue);
        DBMS_OUTPUT.PUT_LINE('NotificationThreshold=' || v_notificationthreshold);

        IF v_thresholdqueue > v_notificationthreshold THEN
          BEGIN

            UPDATE {databaseOwner}scp_eventlog
            SET lognotificationpending = 1
            WHERE logconfigid = i_logconfigid
             AND lognotificationpending IS NULL
             AND logcreatedate > v_mindatetime;

          END;
        END IF;

      END;
    END IF;

  END scp_addeventlog;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDURL
  --------------------------------------------------------

  PROCEDURE scp_addurl(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_urls(portalid,   url)
    VALUES(i_portalid,   i_url);

  END scp_addurl;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDFILE
  --------------------------------------------------------

  PROCEDURE scp_addfile(i_portalid IN NUMBER DEFAULT NULL,   i_filename IN nvarchar2 DEFAULT NULL,   i_extension IN nvarchar2 DEFAULT NULL,   i_size IN NUMBER DEFAULT NULL,   i_width IN NUMBER DEFAULT NULL,   i_height IN NUMBER DEFAULT NULL,   i_contenttype IN nvarchar2 DEFAULT NULL,   i_folder IN nvarchar2 DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   o_fileid OUT {databaseOwner}scp_files.fileid%TYPE) AS

  BEGIN
  
    FOR rec IN
    (SELECT fileid
    FROM {databaseOwner}scp_files
    WHERE folderid = i_folderid
     AND filename = i_filename)
    LOOP
      o_fileid := rec.fileid;
    END LOOP;

    IF o_fileid IS NULL THEN
      BEGIN
        INSERT
        INTO {databaseOwner}scp_files(portalid,   filename,   extension,   size_,   width,   height,   contenttype,   folder,   folderid)
        VALUES(i_portalid,   i_filename,   i_extension,   i_size,   i_width,   i_height,   i_contenttype,   i_folder,   i_folderid) returning fileid
        INTO o_fileid;

      END;
    ELSE
      BEGIN

        UPDATE {databaseOwner}scp_files
        SET filename = i_filename,
          extension = i_extension,
          size_ = i_size,
          width = i_width,
          height = i_height,
          contenttype = i_contenttype,
          folder = i_folder,
          folderid = i_folderid
        WHERE fileid = o_fileid;

      END;
    END IF;

  END scp_addfile;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDBANNER
  --------------------------------------------------------

  PROCEDURE scp_addbanner(i_bannername IN nvarchar2 DEFAULT NULL,   i_vendorid IN NUMBER DEFAULT NULL,   i_imagefile IN nvarchar2 DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_impressions IN NUMBER DEFAULT NULL,   i_cpm IN FLOAT DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_bannertypeid IN NUMBER DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_groupname IN nvarchar2 DEFAULT NULL,   i_criteria IN NUMBER DEFAULT NULL,   i_width IN NUMBER DEFAULT NULL,   i_height IN NUMBER DEFAULT NULL,   o_bannerid OUT {databaseOwner}scp_banners.bannerid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_banners(vendorid,   imagefile,   bannername,   url,   impressions,   cpm,   views,   clickthroughs,   startdate,   enddate,   createdbyuser,   createddate,   bannertypeid,   description,   groupname,   criteria,   width,   height)
    VALUES(i_vendorid,   i_imagefile,   i_bannername,   i_url,   i_impressions,   i_cpm,   0,   0,   i_startdate,   i_enddate,   i_username,   sysdate,   i_bannertypeid,   i_description,   i_groupname,   i_criteria,   i_width,   i_height) returning bannerid
    INTO o_bannerid;

  END scp_addbanner;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDROLEGROUP
  --------------------------------------------------------

  PROCEDURE scp_addrolegroup(i_portalid IN NUMBER DEFAULT NULL,   i_rolegroupname IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   o_rolegroupid OUT {databaseOwner}scp_rolegroups.rolegroupid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_rolegroups(portalid,   rolegroupname,   description)
    VALUES(i_portalid,   i_rolegroupname,   i_description) returning rolegroupid
    INTO o_rolegroupid;

  END scp_addrolegroup;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDTABPERMISSION
  --------------------------------------------------------

  PROCEDURE scp_addtabpermission(i_tabid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL,   o_tabpermissionid OUT {databaseOwner}scp_tabpermission.tabpermissionid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_tabpermission(tabid,   permissionid,   roleid,   allowaccess)
    VALUES(i_tabid,   i_permissionid,   i_roleid,   i_allowaccess) returning tabpermissionid
    INTO o_tabpermissionid;

  END scp_addtabpermission;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDEVENTLOGCONFIG
  --------------------------------------------------------

  PROCEDURE scp_addeventlogconfig(i_logtypekey IN nvarchar2 DEFAULT NULL,   i_logtypeportalid IN NUMBER DEFAULT NULL,   i_loggingisactive IN NUMBER DEFAULT NULL,   i_keepmostrecent IN NUMBER DEFAULT NULL,   i_emailnotificationisactive IN NUMBER DEFAULT NULL,   i_notificationthreshold IN NUMBER DEFAULT NULL,   i_notificationthresholdtime IN NUMBER DEFAULT NULL,   i_notificationthresholdtype IN NUMBER DEFAULT NULL,   i_mailfromaddress IN nvarchar2 DEFAULT NULL,   i_mailtoaddress IN nvarchar2 DEFAULT NULL) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_eventlogconfig(logtypekey,   logtypeportalid,   loggingisactive,   keepmostrecent,   emailnotificationisactive,   notificationthreshold,   notificationthresholdtime,   notificationthresholdtimetype,   mailfromaddress,   mailtoaddress)
    VALUES(i_logtypekey,   i_logtypeportalid,   i_loggingisactive,   i_keepmostrecent,   i_emailnotificationisactive,   i_notificationthreshold,   i_notificationthresholdtime,   i_notificationthresholdtype,   i_mailfromaddress,   i_mailtoaddress);

  END scp_addeventlogconfig;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDSKIN
  --------------------------------------------------------

  PROCEDURE scp_addskin(i_skinroot IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_skintype IN NUMBER DEFAULT NULL,   i_skinsrc IN nvarchar2 DEFAULT NULL,   o_skinid OUT {databaseOwner}scp_skins.skinid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_skins(skinroot,   portalid,   skintype,   skinsrc)
    VALUES(i_skinroot,   i_portalid,   i_skintype,   i_skinsrc) returning skinid
    INTO o_skinid;

  END scp_addskin;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDSYSTEMMESSAGE
  --------------------------------------------------------

  PROCEDURE scp_addsystemmessage(i_portalid IN NUMBER DEFAULT NULL,   i_messagename IN nvarchar2 DEFAULT NULL,   i_messagevalue IN nclob DEFAULT NULL) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_systemmessages(portalid,   messagename,   messagevalue)
    VALUES(i_portalid,   i_messagename,   i_messagevalue);

  END scp_addsystemmessage;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDMODULESETTING
  --------------------------------------------------------

  PROCEDURE scp_addmodulesetting(i_moduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL,   i_settingvalue IN nvarchar2 DEFAULT NULL) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_modulesettings(moduleid,   settingname,   settingvalue)
    VALUES(i_moduleid,   i_settingname,   i_settingvalue);

  END scp_addmodulesetting;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDURLTRACKING
  --------------------------------------------------------

  PROCEDURE scp_addurltracking(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_urltype IN CHAR DEFAULT NULL,   i_logactivity IN NUMBER DEFAULT NULL,   i_trackclicks IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_newwindow IN NUMBER DEFAULT NULL) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_urltracking(portalid,   url,   urltype,   clicks,   lastclick,   createddate,   logactivity,   trackclicks,   moduleid,   newwindow)
    VALUES(i_portalid,   i_url,   i_urltype,   0,   NULL,   sysdate,   i_logactivity,   i_trackclicks,   i_moduleid,   i_newwindow);

  END scp_addurltracking;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDPROFILE
  --------------------------------------------------------

  PROCEDURE scp_addprofile(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_profile(userid,   portalid,   profiledata,   createddate)
    VALUES(i_userid,   i_portalid,   NULL,   sysdate);

  END scp_addprofile;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDPORTALDESKTOPMODULE
  --------------------------------------------------------

  PROCEDURE scp_addportaldesktopmodule(i_portalid IN NUMBER DEFAULT NULL,   i_desktopmoduleid IN NUMBER DEFAULT NULL,   o_portaldesktopmoduleid OUT {databaseOwner}scp_portaldesktopmodules.portaldesktopmoduleid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_portaldesktopmodules(portalid,   desktopmoduleid)
    VALUES(i_portalid,   i_desktopmoduleid) returning portaldesktopmoduleid
    INTO o_portaldesktopmoduleid;

  END scp_addportaldesktopmodule;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDSCHEDULEITEMSETTING
  --------------------------------------------------------

  PROCEDURE scp_addscheduleitemsetting(i_scheduleid IN NUMBER DEFAULT NULL,   i_name IN nvarchar2 DEFAULT NULL,   i_value IN nvarchar2 DEFAULT NULL) AS
  v_exists NUMBER(10,   0);
  BEGIN

    BEGIN
      v_exists := 0;
      SELECT COUNT(*)
      INTO v_exists
      FROM dual
      WHERE EXISTS
        (SELECT *
         FROM {databaseOwner}scp_scheduleitemsettings
         WHERE scheduleid = i_scheduleid
         AND settingname = i_name)
      ;

    END;

    IF v_exists != 0 THEN
      BEGIN

        UPDATE {databaseOwner}scp_scheduleitemsettings
        SET settingvalue = i_value
        WHERE scheduleid = i_scheduleid
         AND settingname = i_name;

      END;
    ELSE
      BEGIN
        INSERT
        INTO {databaseOwner}scp_scheduleitemsettings(scheduleid,   settingname,   settingvalue)
        VALUES(i_scheduleid,   i_name,   i_value);

      END;
    END IF;

  END scp_addscheduleitemsetting;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDSEARCHITEMWORDPOSITION
  --------------------------------------------------------

  PROCEDURE scp_addsearchitemwordposition(i_searchitemwordid IN NUMBER DEFAULT NULL,   i_contentpositions IN VARCHAR2 DEFAULT NULL) AS
  v_contentpositions VARCHAR2(50);
  v_position VARCHAR2(50);
  v_pos NUMBER(10,   0);
  BEGIN
    
    v_contentpositions := TRIM(i_contentpositions) || ',';
    v_pos := instr(v_contentpositions,   ',',   1);

    IF REPLACE(v_contentpositions,   ',',   '') IS NOT NULL THEN
      BEGIN
        WHILE v_pos > 0 LOOP
          BEGIN
          
            v_position := TRIM(SUBSTR(v_contentpositions, 1, v_pos - 1));

            IF v_position IS NOT NULL THEN
              BEGIN
              
                INSERT INTO {databaseOwner}scp_searchitemwordposition(searchitemwordid,   contentposition)                
                VALUES(i_searchitemwordid, CAST(v_position AS NUMBER));
                
              END;
            END IF;

            v_contentpositions := SUBSTR(v_contentpositions, v_pos + 1);
            v_pos := instr(v_contentpositions,   ',',   1);
            
          END;
        END LOOP;
      END;
    END IF;

  END scp_addsearchitemwordposition;
  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDVENDORCLASSIFICATION
  --------------------------------------------------------

  PROCEDURE scp_addvendorclassification(i_vendorid IN NUMBER DEFAULT NULL,   i_classificationid IN NUMBER DEFAULT NULL,   o_vendorclassificationid OUT {databaseOwner}scp_vendorclassification.vendorclassificationid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_vendorclassification(vendorid,   classificationid)
    VALUES(i_vendorid,   i_classificationid) returning vendorclassificationid
    INTO o_vendorclassificationid;

  END scp_addvendorclassification;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDSEARCHWORD
  --------------------------------------------------------

  PROCEDURE scp_addsearchword(i_word IN nvarchar2 DEFAULT NULL,   o_searchwordsid OUT {databaseOwner}scp_searchword.searchwordsid%TYPE) AS
  BEGIN
  
    FOR rec IN
    (SELECT searchwordsid
    FROM {databaseOwner}scp_searchword
    WHERE word = i_word)
    LOOP
      o_searchwordsid := rec.searchwordsid;
    END LOOP;

    IF o_searchwordsid IS NULL THEN
      BEGIN
        INSERT
        INTO {databaseOwner}scp_searchword(word,   iscommon,   hitcount)
        VALUES(i_word,   0,   1) returning searchwordsid
        INTO o_searchwordsid;

      END;

    END IF;

  END scp_addsearchword;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDMODULEDEFINITION
  --------------------------------------------------------

  PROCEDURE scp_addmoduledefinition(i_desktopmoduleid IN NUMBER DEFAULT NULL,   i_friendlyname IN nvarchar2 DEFAULT NULL,   i_defaultcachetime IN NUMBER DEFAULT NULL,   o_moduledefid OUT {databaseOwner}scp_moduledefinitions.moduledefid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_moduledefinitions(desktopmoduleid,   friendlyname,   defaultcachetime)
    VALUES(i_desktopmoduleid,   i_friendlyname,   i_defaultcachetime) returning moduledefid
    INTO o_moduledefid;

  END scp_addmoduledefinition;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDUSERROLE
  --------------------------------------------------------

  PROCEDURE scp_adduserrole(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_effectivedate IN DATE DEFAULT NULL,   i_expirydate IN DATE DEFAULT NULL,   o_userroleid OUT {databaseOwner}scp_userroles.userroleid%TYPE) AS
  BEGIN

    FOR rec IN
    (SELECT userroleid
    FROM {databaseOwner}scp_userroles
    WHERE userid = i_userid
     AND roleid = i_roleid)
    LOOP
		o_userroleid := rec.userroleid;
    END LOOP;

    IF o_userroleid IS NOT NULL THEN
      BEGIN

        UPDATE {databaseOwner}scp_userroles
        SET expirydate = i_expirydate,
          effectivedate = i_effectivedate
        WHERE userroleid = o_userroleid;

      END;
    ELSE
      BEGIN
        INSERT
        INTO {databaseOwner}scp_userroles(userid,   roleid,   effectivedate,   expirydate)
        VALUES(i_userid,   i_roleid,   i_effectivedate,   i_expirydate) returning userroleid
        INTO o_userroleid;

      END;
    END IF;

  END scp_adduserrole;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDEVENTLOGTYPE
  --------------------------------------------------------

  PROCEDURE scp_addeventlogtype(i_logtypekey IN nvarchar2 DEFAULT NULL,   i_logtypefriendlyname IN nvarchar2 DEFAULT NULL,   i_logtypedescription IN nvarchar2 DEFAULT NULL,   i_logtypeowner IN nvarchar2 DEFAULT NULL,   i_logtypecssclass IN nvarchar2 DEFAULT NULL) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_eventlogtypes(logtypekey,   logtypefriendlyname,   logtypedescription,   logtypeowner,   logtypecssclass)
    VALUES(i_logtypekey,   i_logtypefriendlyname,   i_logtypedescription,   i_logtypeowner,   i_logtypecssclass);

  END scp_addeventlogtype;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDPORTALINFO
  --------------------------------------------------------

  PROCEDURE scp_addportalinfo(i_portalname IN nvarchar2 DEFAULT NULL,   i_currency IN CHAR DEFAULT NULL,   i_expirydate IN DATE DEFAULT NULL,   i_hostfee IN NUMBER DEFAULT NULL,   i_hostspace IN NUMBER DEFAULT NULL,   i_pagequota IN NUMBER DEFAULT NULL,   i_userquota IN NUMBER DEFAULT NULL,   i_siteloghistory IN NUMBER DEFAULT NULL,   i_homedirectory IN VARCHAR2 DEFAULT NULL,   o_portalid OUT {databaseOwner}scp_portals.portalid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_portals(portalname,   expirydate,   userregistration,   banneradvertising,   currency,   hostfee,   hostspace,   pagequota,   userquota,   description,   keywords,   siteloghistory,   homedirectory)
    VALUES(i_portalname,   i_expirydate,   0,   0,   i_currency,   i_hostfee,   i_hostspace,   i_pagequota,   i_userquota,   i_portalname,   i_portalname,   i_siteloghistory,   i_homedirectory) returning portalid
    INTO o_portalid;

    IF i_homedirectory IS NULL THEN
      BEGIN

        UPDATE {databaseOwner}scp_portals
        SET homedirectory = 'Portals/' || portalid
        WHERE portalid = o_portalid;

      END;
    END IF;

  END scp_addportalinfo;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDUSER
  --------------------------------------------------------

  PROCEDURE scp_adduser(i_portalid IN NUMBER DEFAULT NULL, i_accountid IN number, i_username IN nvarchar2 DEFAULT NULL,   i_firstname IN nvarchar2 DEFAULT NULL,   i_lastname IN nvarchar2 DEFAULT NULL,   i_affiliateid IN NUMBER DEFAULT NULL,   i_issuperuser IN NUMBER DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL,   i_displayname IN nvarchar2 DEFAULT NULL,   i_updatepassword IN NUMBER DEFAULT NULL,   i_authorised IN NUMBER DEFAULT NULL,   o_userid OUT {databaseOwner}scp_users.userid%TYPE) AS
  v_exists NUMBER(1,   0);
BEGIN
    FOR rec IN
    (SELECT userid
    FROM {databaseOwner}scp_users
    WHERE username = i_username
    AND accountid = i_accountid)
    LOOP
      o_userid := rec.userid;
    END LOOP;

    IF o_userid IS NULL THEN
      BEGIN
        INSERT
        INTO {databaseOwner}scp_users(username,   firstname,   lastname,   affiliateid,   issuperuser,   email,   displayname,   updatepassword, accountid)
        VALUES(i_username,   i_firstname,   i_lastname,   i_affiliateid,   i_issuperuser,   i_email,   i_displayname,   i_updatepassword, i_accountid) returning userid
        INTO o_userid;
      END;
    END IF;

    IF i_issuperuser = 0 THEN
         BEGIN
            v_exists := 0;
            SELECT COUNT(*) 
            INTO v_exists
            FROM {databaseOwner}scp_userportals
            WHERE userid = o_userid
            AND portalid = i_portalid;
          END;
          IF v_exists = 0 THEN
            BEGIN
              INSERT
              INTO {databaseOwner}scp_userportals(userid,   portalid,   authorised)
              VALUES(o_userid,   i_portalid,   i_authorised);
            END;
          END IF;
    END IF;

  END scp_adduser;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDTABMODULESETTING
  --------------------------------------------------------

  PROCEDURE scp_addtabmodulesetting(i_tabmoduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL,   i_settingvalue IN nvarchar2 DEFAULT NULL) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_tabmodulesettings(tabmoduleid,   settingname,   settingvalue)
    VALUES(i_tabmoduleid,   i_settingname,   i_settingvalue);

  END scp_addtabmodulesetting;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDDESKTOPMODULE
  --------------------------------------------------------

  PROCEDURE scp_adddesktopmodule(i_modulename IN nvarchar2 DEFAULT NULL,   i_foldername IN nvarchar2 DEFAULT NULL,   i_friendlyname IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_version IN nvarchar2 DEFAULT NULL,   i_ispremium IN NUMBER DEFAULT NULL,   i_isadmin IN NUMBER DEFAULT NULL,   i_businesscontroller IN nvarchar2 DEFAULT NULL,   i_supportedfeatures IN NUMBER DEFAULT NULL,   i_compatibleversions IN nvarchar2 DEFAULT NULL,   o_desktopmoduleid OUT {databaseOwner}scp_desktopmodules.desktopmoduleid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_desktopmodules(modulename,   foldername,   friendlyname,   description,   version,   ispremium,   isadmin,   businesscontrollerclass,   supportedfeatures,   compatibleversions)
    VALUES(i_modulename,   i_foldername,   i_friendlyname,   i_description,   i_version,   i_ispremium,   i_isadmin,   i_businesscontroller,   i_supportedfeatures,   i_compatibleversions) returning desktopmoduleid
    INTO o_desktopmoduleid;

  END scp_adddesktopmodule;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDPERMISSION
  --------------------------------------------------------

  PROCEDURE scp_addpermission(i_moduledefid IN NUMBER DEFAULT NULL,   i_permissioncode IN VARCHAR2 DEFAULT NULL,   i_permissionkey IN VARCHAR2 DEFAULT NULL,   i_permissionname IN VARCHAR2 DEFAULT NULL,   o_permissionid OUT {databaseOwner}scp_permission.permissionid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_permission(moduledefid,   permissioncode,   permissionkey,   permissionname)
    VALUES(i_moduledefid,   i_permissioncode,   i_permissionkey,   i_permissionname) returning permissionid
    INTO o_permissionid;

  END scp_addpermission;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDSEARCHITEM
  --------------------------------------------------------

  PROCEDURE scp_addsearchitem(i_title IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_author IN NUMBER DEFAULT NULL,   i_pubdate IN DATE DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_searchkey IN nvarchar2 DEFAULT NULL,   i_guid IN varchar2 DEFAULT NULL,   i_imagefileid IN NUMBER DEFAULT NULL,   o_searchitemid OUT {databaseOwner}scp_searchitem.searchitemid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_searchitem(title,   description,   author,   pubdate,   moduleid,   searchkey,   guid,   hitcount,   imagefileid)
    VALUES(i_title,   i_description,   i_author,   i_pubdate,   i_moduleid,   i_searchkey,   i_guid,   0,   i_imagefileid) returning searchitemid
    INTO o_searchitemid;

  END scp_addsearchitem;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDSCHEDULE
  --------------------------------------------------------

  PROCEDURE scp_addschedule(i_typefullname IN VARCHAR2 DEFAULT NULL,   i_timelapse IN NUMBER DEFAULT NULL,   i_timelapsemeasurement IN VARCHAR2 DEFAULT NULL,   i_retrytimelapse IN NUMBER DEFAULT NULL,   i_retrytimelapsemeasurement IN VARCHAR2 DEFAULT NULL,   i_retainhistorynum IN NUMBER DEFAULT NULL,   i_attachtoevent IN VARCHAR2 DEFAULT NULL,   i_catchupenabled IN NUMBER DEFAULT NULL,   i_enabled IN NUMBER DEFAULT NULL,   i_objectdependencies IN VARCHAR2 DEFAULT NULL,   i_servers IN NVARCHAR2 DEFAULT NULL,   o_scheduleid OUT {databaseOwner}scp_schedule.scheduleid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_schedule(typefullname,   timelapse,   timelapsemeasurement,   retrytimelapse,   retrytimelapsemeasurement,   retainhistorynum,   attachtoevent,   catchupenabled,   enabled,   objectdependencies,   servers)
    VALUES(i_typefullname,   i_timelapse,   i_timelapsemeasurement,   i_retrytimelapse,   i_retrytimelapsemeasurement,   i_retainhistorynum,   i_attachtoevent,   i_catchupenabled,   i_enabled,   i_objectdependencies,   i_servers) returning scheduleid
    INTO o_scheduleid;

  END scp_addschedule;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDVENDOR
  --------------------------------------------------------

  PROCEDURE scp_addvendor(i_portalid IN NUMBER DEFAULT NULL,   i_vendorname IN nvarchar2 DEFAULT NULL,   i_unit IN nvarchar2 DEFAULT NULL,   i_street IN nvarchar2 DEFAULT NULL,   i_city IN nvarchar2 DEFAULT NULL,   i_region IN nvarchar2 DEFAULT NULL,   i_country IN nvarchar2 DEFAULT NULL,   i_postalcode IN nvarchar2 DEFAULT NULL,   i_telephone IN nvarchar2 DEFAULT NULL,   i_fax IN nvarchar2 DEFAULT NULL,   i_cell IN varchar2 DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL,   i_website IN nvarchar2 DEFAULT NULL,   i_firstname IN nvarchar2 DEFAULT NULL,   i_lastname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_logofile IN nvarchar2 DEFAULT NULL,   i_keywords IN NCLOB DEFAULT NULL,   i_authorized IN NUMBER DEFAULT NULL,   o_vendorid OUT {databaseOwner}scp_vendors.vendorid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_vendors(vendorname,   unit,   street,   city,   region,   country,   postalcode,   telephone,   portalid,   fax,   cell,   email,   website,   firstname,   lastname,   clickthroughs,   views,   createdbyuser,   createddate,   logofile,   keywords,   authorized)
    VALUES(i_vendorname,   i_unit,   i_street,   i_city,   i_region,   i_country,   i_postalcode,   i_telephone,   i_portalid,   i_fax,   i_cell,   i_email,   i_website,   i_firstname,   i_lastname,   0,   0,   i_username,   sysdate,   i_logofile,   i_keywords,   i_authorized) returning vendorid
    INTO o_vendorid;

  END scp_addvendor;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDMODULE
  --------------------------------------------------------

  PROCEDURE scp_addmodule(i_portalid IN NUMBER DEFAULT NULL,   i_moduledefid IN NUMBER DEFAULT NULL,   i_moduletitle IN nvarchar2 DEFAULT NULL,   i_alltabs IN NUMBER DEFAULT NULL,   i_header IN nclob DEFAULT NULL,   i_footer IN nclob DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_inheritviewpermissions IN NUMBER DEFAULT NULL,   i_isdeleted IN NUMBER DEFAULT NULL,   o_moduleid OUT {databaseOwner}scp_modules.moduleid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_modules(portalid,   moduledefid,   moduletitle,   alltabs,   header,   footer,   startdate,   enddate,   inheritviewpermissions,   isdeleted)
    VALUES(i_portalid,   i_moduledefid,   i_moduletitle,   i_alltabs,   i_header,   i_footer,   i_startdate,   i_enddate,   i_inheritviewpermissions,   i_isdeleted) returning moduleid
    INTO o_moduleid;

  END scp_addmodule;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDLISTENTRY
  --------------------------------------------------------

  PROCEDURE scp_addlistentry(i_listname IN nvarchar2 DEFAULT NULL,   i_value IN nvarchar2 DEFAULT NULL,   i_text IN nvarchar2 DEFAULT NULL,   i_parentkey IN nvarchar2 DEFAULT NULL,   i_enablesortorder IN NUMBER DEFAULT NULL,   i_definitionid IN NUMBER DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   o_entryid OUT {databaseOwner}scp_lists.entryid%TYPE) AS
  v_parentid NUMBER(10,   0);
  v_level NUMBER(10,   0);
  v_sortorder NUMBER(10,   0);
  v_parentlistname nvarchar2(50);
  v_parentvalue nvarchar2(100);
  v_exists NUMBER(10,   0);
  BEGIN

    IF i_enablesortorder = 1 THEN
      BEGIN
        SELECT nvl(MAX(sortorder),   0) + 1
        INTO v_sortorder
        FROM {databaseOwner}scp_lists
        WHERE listname = i_listname;
      END;
    ELSE
      BEGIN
        v_sortorder := 0;
      END;
    END IF;

    IF i_parentkey IS NOT NULL THEN
      BEGIN
        v_parentlistname := SUBSTR(i_parentkey,   1,   instr(i_parentkey,   '.') -1);
        v_parentvalue := SUBSTR(i_parentkey,   LENGTH(i_parentkey) -instr(i_parentkey,   '.'));

        FOR rec IN
          (SELECT entryid,
            (v_level + 1) tmp_level
           FROM {databaseOwner}scp_lists
           WHERE listname = v_parentlistname
           AND VALUE = v_parentvalue)
        LOOP
          v_parentid := rec.entryid;
          v_level := rec.tmp_level;

        END LOOP;

        DBMS_OUTPUT.PUT_LINE('ParentListName: ' || v_parentlistname);
        DBMS_OUTPUT.PUT_LINE('ParentValue: ' || v_parentvalue);
      END;
    ELSE
      BEGIN
        v_parentid := 0;
        v_level := 0;
      END;
    END IF;

    BEGIN
      v_exists := 0;
      SELECT COUNT(*)
      INTO v_exists
      FROM dual
      WHERE EXISTS
        (SELECT entryid
         FROM {databaseOwner}scp_lists
         WHERE listname = listname
         AND VALUE = VALUE
         AND text = text
         AND parentid = parentid)
      ;

    END;

    IF v_exists != 0 THEN
      BEGIN

        o_entryid := -1;
        RETURN;
      END;
    END IF;

    INSERT
    INTO {databaseOwner}scp_lists(listname,   VALUE,   text,   level_,   sortorder,   definitionid,   parentid,   description)
    VALUES(i_listname,   i_value,   i_text,   v_level,   v_sortorder,   i_definitionid,   v_parentid,   i_description) returning entryid
    INTO o_entryid;

  END scp_addlistentry;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDTAB
  --------------------------------------------------------

  PROCEDURE scp_addtab(i_portalid IN NUMBER DEFAULT NULL,   i_tabname IN nvarchar2 DEFAULT NULL,   i_isvisible IN NUMBER DEFAULT NULL,   i_disablelink IN NUMBER DEFAULT NULL,   i_parentid IN NUMBER DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   i_title IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_keywords IN nvarchar2 DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_skinsrc IN nvarchar2 DEFAULT NULL,   i_containersrc IN nvarchar2 DEFAULT NULL,   i_tabpath IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_refreshinterval IN NUMBER DEFAULT NULL,   i_pageheadtext IN nvarchar2 DEFAULT NULL,   o_tabid OUT {databaseOwner}scp_tabs.tabid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_tabs(portalid,   tabname,   isvisible,   disablelink,   parentid,   iconfile,   title,   description,   keywords,   isdeleted,   url,   skinsrc,   containersrc,   tabpath,   startdate,   enddate,   refreshinterval,   pageheadtext)
    VALUES(i_portalid,   i_tabname,   i_isvisible,   i_disablelink,   i_parentid,   i_iconfile,   i_title,   i_description,   i_keywords,   0,   i_url,   i_skinsrc,   i_containersrc,   i_tabpath,   i_startdate,   i_enddate,   i_refreshinterval,   i_pageheadtext) returning tabid
    INTO o_tabid;

  END scp_addtab;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDURLLOG
  --------------------------------------------------------

  PROCEDURE scp_addurllog(i_urltrackingid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_urllog(urltrackingid,   clickdate,   userid)
    VALUES(i_urltrackingid,   sysdate,   i_userid);

  END scp_addurllog;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDSEARCHITEMWORD
  --------------------------------------------------------

  PROCEDURE scp_addsearchitemword(i_searchitemid IN NUMBER DEFAULT NULL,   i_searchwordsid IN NUMBER DEFAULT NULL,   i_occurrences IN NUMBER DEFAULT NULL,   o_searchitemwordid OUT {databaseOwner}scp_searchitemword.searchitemwordid%TYPE) AS
  BEGIN
  
    FOR rec IN
    (SELECT searchitemwordid
    FROM {databaseOwner}scp_searchitemword
    WHERE searchitemid = i_searchitemid
     AND searchwordsid = i_searchwordsid)
    LOOP
      o_searchitemwordid := rec.searchitemwordid;
    END LOOP;

    IF o_searchitemwordid IS NULL THEN
      BEGIN
        INSERT
        INTO {databaseOwner}scp_searchitemword(searchitemid,   searchwordsid,   occurrences)
        VALUES(i_searchitemid,   i_searchwordsid,   i_occurrences) returning searchitemwordid
        INTO o_searchitemwordid;
      END;
    ELSE
      UPDATE {databaseOwner}scp_searchitemword
      SET occurrences = i_occurrences
      WHERE searchitemwordid = o_searchitemwordid
       AND occurrences <> i_occurrences;
    END IF;

  END scp_addsearchitemword;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDHOSTSETTING
  --------------------------------------------------------

  PROCEDURE scp_addhostsetting(i_settingname IN nvarchar2 DEFAULT NULL,   i_settingvalue IN nvarchar2 DEFAULT NULL,   i_settingissecure IN NUMBER DEFAULT NULL) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_hostsettings(settingname,   settingvalue,   settingissecure)
    VALUES(i_settingname,   i_settingvalue,   i_settingissecure);

  END scp_addhostsetting;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDSITELOG
  --------------------------------------------------------

  PROCEDURE scp_addsitelog(i_datetime IN DATE DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   i_referrer IN nvarchar2 DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_useragent IN nvarchar2 DEFAULT NULL,   i_userhostaddress IN nvarchar2 DEFAULT NULL,   i_userhostname IN nvarchar2 DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   i_affiliateid IN NUMBER DEFAULT NULL) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_sitelog(datetime,   portalid,   userid,   referrer,   url,   useragent,   userhostaddress,   userhostname,   tabid,   affiliateid)
    VALUES(i_datetime,   i_portalid,   i_userid,   i_referrer,   i_url,   i_useragent,   i_userhostaddress,   i_userhostname,   i_tabid,   i_affiliateid);

  END scp_addsitelog;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDMODULECONTROL
  --------------------------------------------------------

  PROCEDURE scp_addmodulecontrol(i_moduledefid IN NUMBER DEFAULT NULL,   i_controlkey IN nvarchar2 DEFAULT NULL,   i_controltitle IN nvarchar2 DEFAULT NULL,   i_controlsrc IN nvarchar2 DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   i_controltype IN NUMBER DEFAULT NULL,   i_vieworder IN NUMBER DEFAULT NULL,   i_helpurl IN nvarchar2 DEFAULT NULL,   o_modulecontrolid OUT {databaseOwner}scp_modulecontrols.modulecontrolid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_modulecontrols(moduledefid,   controlkey,   controltitle,   controlsrc,   iconfile,   controltype,   vieworder,   helpurl)
    VALUES(i_moduledefid,   i_controlkey,   i_controltitle,   i_controlsrc,   i_iconfile,   i_controltype,   i_vieworder,   i_helpurl) returning modulecontrolid
    INTO o_modulecontrolid;

  END scp_addmodulecontrol;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDAFFILIATE
  --------------------------------------------------------

  PROCEDURE scp_addaffiliate(i_vendorid IN NUMBER DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_cpc IN FLOAT DEFAULT NULL,   i_cpa IN FLOAT DEFAULT NULL,   o_affiliateid OUT {databaseOwner}scp_affiliates.affiliateid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_affiliates(vendorid,   startdate,   enddate,   cpc,   clicks,   cpa,   acquisitions)
    VALUES(i_vendorid,   i_startdate,   i_enddate,   i_cpc,   0,   i_cpa,   0) returning affiliateid
    INTO o_affiliateid;

  END scp_addaffiliate;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDSEARCHCOMMONWORD
  --------------------------------------------------------

  PROCEDURE scp_addsearchcommonword(i_commonword IN nvarchar2 DEFAULT NULL,   i_locale IN nvarchar2 DEFAULT NULL,   o_commonwordid OUT {databaseOwner}scp_searchcommonwords.commonwordid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_searchcommonwords(commonword,   locale)
    VALUES(i_commonword,   i_locale) returning commonwordid
    INTO o_commonwordid;

  END scp_addsearchcommonword;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDMODULEPERMISSION
  --------------------------------------------------------

  PROCEDURE scp_addmodulepermission(i_moduleid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL,   o_modulepermissionid OUT {databaseOwner}scp_modulepermission.modulepermissionid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_modulepermission(moduleid,   permissionid,   roleid,   allowaccess)
    VALUES(i_moduleid,   i_permissionid,   i_roleid,   i_allowaccess) returning modulepermissionid
    INTO o_modulepermissionid;

  END scp_addmodulepermission;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDTABMODULE
  --------------------------------------------------------

  PROCEDURE scp_addtabmodule(i_tabid IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_moduleorder IN NUMBER DEFAULT NULL,   i_panename IN nvarchar2 DEFAULT NULL,   i_cachetime IN NUMBER DEFAULT NULL,   i_alignment IN nvarchar2 DEFAULT NULL,   i_color IN nvarchar2 DEFAULT NULL,   i_border IN nvarchar2 DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   i_visibility IN NUMBER DEFAULT NULL,   i_containersrc IN nvarchar2 DEFAULT NULL,   i_displaytitle IN NUMBER DEFAULT NULL,   i_displayprint IN NUMBER DEFAULT NULL,   i_displaysyndicate IN NUMBER DEFAULT NULL) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_tabmodules(tabid,   moduleid,   moduleorder,   panename,   cachetime,   alignment,   color,   border,   iconfile,   visibility,   containersrc,   displaytitle,   displayprint,   displaysyndicate)
    VALUES(i_tabid,   i_moduleid,   i_moduleorder,   i_panename,   i_cachetime,   i_alignment,   i_color,   i_border,   i_iconfile,   i_visibility,   i_containersrc,   i_displaytitle,   i_displayprint,   i_displaysyndicate);

  END scp_addtabmodule;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDROLE
  --------------------------------------------------------

  PROCEDURE scp_addrole(i_portalid IN NUMBER DEFAULT NULL,   i_rolegroupid IN NUMBER DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_servicefee IN NUMBER DEFAULT NULL,   i_billingperiod IN NUMBER DEFAULT NULL,   i_billingfrequency IN CHAR DEFAULT NULL,   i_trialfee IN NUMBER DEFAULT NULL,   i_trialperiod IN NUMBER DEFAULT NULL,   i_trialfrequency IN CHAR DEFAULT NULL,   i_ispublic IN NUMBER DEFAULT NULL,   i_autoassignment IN NUMBER DEFAULT NULL,   i_rsvpcode IN nvarchar2 DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   o_roleid OUT {databaseOwner}scp_roles.roleid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_roles(portalid,   rolegroupid,   rolename,   description,   servicefee,   billingperiod,   billingfrequency,   trialfee,   trialperiod,   trialfrequency,   ispublic,   autoassignment,   rsvpcode,   iconfile)
    VALUES(i_portalid,   i_rolegroupid,   i_rolename,   i_description,   i_servicefee,   i_billingperiod,   i_billingfrequency,   i_trialfee,   i_trialperiod,   i_trialfrequency,   i_ispublic,   i_autoassignment,   i_rsvpcode,   i_iconfile) returning roleid
    INTO o_roleid;

  END scp_addrole;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDFOLDER
  --------------------------------------------------------

  PROCEDURE scp_addfolder(i_portalid IN NUMBER DEFAULT NULL,   i_folderpath IN VARCHAR2 DEFAULT NULL,   i_storagelocation IN NUMBER DEFAULT NULL,   i_isprotected IN NUMBER DEFAULT NULL,   i_iscached IN NUMBER DEFAULT NULL,   i_lastupdated IN DATE DEFAULT NULL,   o_folderid OUT {databaseOwner}scp_folders.folderid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_folders(portalid,   folderpath,   storagelocation,   isprotected,   iscached,   lastupdated)
    VALUES(i_portalid,   i_folderpath,   i_storagelocation,   i_isprotected,   i_iscached,   i_lastupdated) returning folderid
    INTO o_folderid;

  END scp_addfolder;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDFOLDERPERMISSION
  --------------------------------------------------------

  PROCEDURE scp_addfolderpermission(i_folderid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL,   o_folderpermissionid OUT {databaseOwner}scp_folderpermission.folderpermissionid%TYPE) AS
  BEGIN
    INSERT
    INTO {databaseOwner}scp_folderpermission(folderid,   permissionid,   roleid,   allowaccess)
    VALUES(i_folderid,   i_permissionid,   i_roleid,   i_allowaccess) returning folderpermissionid
    INTO o_folderpermissionid;

  END scp_addfolderpermission;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDPROPERTYDEFINITION
  --------------------------------------------------------

  PROCEDURE scp_addpropertydefinition(i_portalid IN NUMBER DEFAULT NULL,   i_moduledefid IN NUMBER DEFAULT NULL,   i_datatype IN NUMBER DEFAULT NULL,   i_defaultvalue IN nvarchar2 DEFAULT NULL,   i_propertycategory IN nvarchar2 DEFAULT NULL,   i_propertyname IN nvarchar2 DEFAULT NULL,   i_required IN NUMBER DEFAULT NULL,   i_validationexpression IN nvarchar2 DEFAULT NULL,   i_vieworder IN NUMBER DEFAULT NULL,   i_visible IN NUMBER DEFAULT NULL,   i_length IN NUMBER DEFAULT NULL,   i_searchable IN NUMBER DEFAULT NULL,   o_propertydefinitionid OUT {databaseOwner}scp_profilepropertydefinition.propertydefinitionid%TYPE) AS
  BEGIN
    
    FOR rec IN
    (SELECT propertydefinitionid
    FROM {databaseOwner}scp_profilepropertydefinition
    WHERE(portalid = i_portalid OR(i_portalid IS NULL
     AND portalid IS NULL))
     AND propertyname = i_propertyname)
     LOOP
      o_propertydefinitionid := rec.propertydefinitionid;
     END LOOP;

    IF o_propertydefinitionid IS NULL THEN
      BEGIN
        INSERT
        INTO {databaseOwner}scp_profilepropertydefinition(portalid,   moduledefid,   deleted,   datatype,   defaultvalue,   propertycategory,   propertyname,   required,   validationexpression,   vieworder,   visible,   length,   searchable)
        VALUES(i_portalid,   i_moduledefid,   0,   i_datatype,   i_defaultvalue,   i_propertycategory,   i_propertyname,   i_required,   i_validationexpression,   i_vieworder,   i_visible,   i_length,   i_searchable) returning propertydefinitionid
        INTO o_propertydefinitionid;

      END;
    ELSE
      BEGIN

        UPDATE {databaseOwner}scp_profilepropertydefinition
        SET datatype = i_datatype,
          moduledefid = i_moduledefid,
          defaultvalue = i_defaultvalue,
          propertycategory = i_propertycategory,
          required = i_required,
          validationexpression = i_validationexpression,
          vieworder = i_vieworder,
          deleted = 0,
          visible = i_visible,
          length = i_length,
          searchable = i_searchable
        WHERE propertydefinitionid = o_propertydefinitionid;

      END;
    END IF;

  END scp_addpropertydefinition;

  --------------------------------------------------------
  --  DDL for Procedure SCP_ADDDEFAULTPROPERTYDEF
  --------------------------------------------------------

  PROCEDURE scp_adddefaultpropertydef(i_portalid IN NUMBER DEFAULT NULL) AS
  v_textdatatype NUMBER(10,   0);
  v_countrydatatype NUMBER(10,   0);
  v_regiondatatype NUMBER(10,   0);
  v_timezonedatatype NUMBER(10,   0);
  v_localedatatype NUMBER(10,   0);
  v_richtextdatatype NUMBER(10,   0);
  v_id NUMBER(10,   0);
  BEGIN

    SELECT entryid
    INTO v_textdatatype
    FROM {databaseOwner}scp_lists
    WHERE listname = 'DataType'
     AND VALUE = 'Text';
    SELECT entryid
    INTO v_countrydatatype
    FROM {databaseOwner}scp_lists
    WHERE listname = 'DataType'
     AND VALUE = 'Country';
    SELECT entryid
    INTO v_regiondatatype
    FROM {databaseOwner}scp_lists
    WHERE listname = 'DataType'
     AND VALUE = 'Region';
    SELECT entryid
    INTO v_timezonedatatype
    FROM {databaseOwner}scp_lists
    WHERE listname = 'DataType'
     AND VALUE = 'TimeZone';
    SELECT entryid
    INTO v_localedatatype
    FROM {databaseOwner}scp_lists
    WHERE listname = 'DataType'
     AND VALUE = 'Locale';
    SELECT entryid
    INTO v_richtextdatatype
    FROM {databaseOwner}scp_lists
    WHERE listname = 'DataType'
     AND VALUE = 'RichText';

    --Add Name Properties 
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Name',   'Prefix',   0,   ' ',   1,   1,   50,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Name',   'FirstName',   0,   ' ',   3,   1,   50,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Name',   'MiddleName',   0,   ' ',   5,   1,   50,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Name',   'LastName',   0,   ' ',   7,   1,   50,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Name',   'Suffix',   0,   ' ',   9,   1,   50,   1,   v_id);

    --Add Address Properties 
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Address',   'Unit',   0,   ' ',   11,   1,   50,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Address',   'Street',   0,   ' ',   13,   1,   50,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Address',   'City',   0,   ' ',   15,   1,   50,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_regiondatatype,   ' ',   'Address',   'Region',   0,   ' ',   17,   1,   0,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_countrydatatype,   ' ',   'Address',   'Country',   0,   ' ',   19,   1,   0,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Address',   'PostalCode',   0,   ' ',   21,   1,   50,   1,   v_id);

    --Add Contact Info Properties 
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Contact Info',   'Telephone',   0,   ' ',   23,   1,   50,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Contact Info',   'Cell',   0,   ' ',   25,   1,   50,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Contact Info',   'Fax',   0,   ' ',   27,   1,   50,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Contact Info',   'Website',   0,   ' ',   29,   1,   50,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_textdatatype,   ' ',   'Contact Info',   'IM',   0,   ' ',   31,   1,   50,   1,   v_id);

    --Add Preferences Properties 
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_richtextdatatype,   ' ',   'Preferences',   'Biography',   0,   ' ',   33,   1,   0,   1,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_timezonedatatype,   ' ',   'Preferences',   'TimeZone',   0,   ' ',   35,   1,   0,   0,   v_id);
    {databaseOwner}scpuke_pkg.scp_addpropertydefinition(i_portalid,   -1,   v_localedatatype,   ' ',   'Preferences',   'PreferredLocale',   0,   ' ',   37,   1,   0,   0,   v_id);

  END scp_adddefaultpropertydef;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETESEARCHITEMWORD
  --------------------------------------------------------

  PROCEDURE scp_deletesearchitemword(i_searchitemwordid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_searchitemword
    WHERE searchitemwordid = i_searchitemwordid;

  END scp_deletesearchitemword;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETESYSTEMMESSAGE
  --------------------------------------------------------

  PROCEDURE scp_deletesystemmessage(i_portalid IN NUMBER DEFAULT NULL,   i_messagename IN nvarchar2 DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_systemmessages
    WHERE portalid = i_portalid
     AND messagename = i_messagename;

  END scp_deletesystemmessage;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEFOLDER
  --------------------------------------------------------

  PROCEDURE scp_deletefolder(i_portalid IN NUMBER DEFAULT NULL,   i_folderpath IN VARCHAR2 DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_folders
    WHERE((portalid = i_portalid) OR(portalid IS NULL
     AND portalid IS NULL))
     AND folderpath = i_folderpath;

  END scp_deletefolder;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEAFFILIATE
  --------------------------------------------------------

  PROCEDURE scp_deleteaffiliate(i_affiliateid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_affiliates
    WHERE affiliateid = i_affiliateid;

  END scp_deleteaffiliate;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEMODULEDEFINITION
  --------------------------------------------------------

  PROCEDURE scp_deletemoduledefinition(i_moduledefid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_moduledefinitions
    WHERE moduledefid = i_moduledefid;

  END scp_deletemoduledefinition;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETELIST
  --------------------------------------------------------

  PROCEDURE scp_deletelist(i_listname IN VARCHAR2 DEFAULT NULL,   i_parentkey IN VARCHAR2 DEFAULT NULL) AS

  v_parentlistname nvarchar2(50);
  v_parentvalue nvarchar2(100);

  BEGIN

    IF i_parentkey IS NULL THEN

      -- need to store entries which to be deleted to clean up their sub entries 
      FOR rec IN
        (SELECT entryid
         FROM {databaseOwner}scp_lists
         WHERE listname = i_listname)
      LOOP

        -- delete sub entires

        DELETE {databaseOwner}scp_lists
        WHERE parentid = rec.entryid;

      END LOOP;

      -- Delete entries belong to this list 

      DELETE {databaseOwner}scp_lists
      WHERE listname = i_listname;

    ELSE

      v_parentlistname := SUBSTR(i_parentkey,   1,   instr(i_parentkey,   '.') -1);
      v_parentvalue := SUBSTR(i_parentkey,   LENGTH(i_parentkey) -instr(i_parentkey,   '.'));
      -- need to store entries which to be deleted to clean up their sub entries 
      FOR rec IN
        (SELECT entryid
         FROM {databaseOwner}scp_lists
         WHERE listname = i_listname
         AND parentid =
          (SELECT entryid
           FROM {databaseOwner}scp_lists
           WHERE listname = v_parentlistname
           AND VALUE = v_parentvalue)
        )
      LOOP

        -- delete their sub entires 

        DELETE {databaseOwner}scp_lists
        WHERE parentid = rec.entryid;

      END LOOP;

      -- delete entry list 

      DELETE {databaseOwner}scp_lists
      WHERE listname = i_listname
       AND parentid =
        (SELECT entryid
         FROM {databaseOwner}scp_lists
         WHERE listname = v_parentlistname
         AND VALUE = v_parentvalue)
      ;

    END IF;

  END scp_deletelist;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEEVENTLOG
  --------------------------------------------------------

  PROCEDURE scp_deleteeventlog(i_logguid IN VARCHAR2 DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_eventlog
    WHERE logguid = i_logguid OR logguid IS NULL;

  END scp_deleteeventlog;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEFOLDERPERMISSION
  --------------------------------------------------------

  PROCEDURE scp_deletefolderpermission(i_folderpermissionid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_folderpermission
    WHERE folderpermissionid = i_folderpermissionid;

  END scp_deletefolderpermission;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEFILE
  --------------------------------------------------------

  PROCEDURE scp_deletefile(i_portalid IN NUMBER DEFAULT NULL,   i_filename IN nvarchar2 DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_files
    WHERE filename = i_filename
     AND folderid = i_folderid
     AND((portalid = i_portalid) OR(i_portalid IS NULL
     AND portalid IS NULL));

  END scp_deletefile;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEROLE
  --------------------------------------------------------

  PROCEDURE scp_deleterole(i_roleid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_folderpermission
    WHERE roleid = i_roleid;

    DELETE FROM {databaseOwner}scp_modulepermission
    WHERE roleid = i_roleid;

    DELETE FROM {databaseOwner}scp_tabpermission
    WHERE roleid = i_roleid;

    DELETE FROM {databaseOwner}scp_roles
    WHERE roleid = i_roleid;

  END scp_deleterole;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELFOLDERPERMSBYPATH
  --------------------------------------------------------

  PROCEDURE scp_delfolderpermsbypath(i_portalid IN NUMBER DEFAULT NULL, i_folderpath IN VARCHAR2 DEFAULT NULL) AS
  v_folderid NUMBER(10,   0);

  BEGIN
    FOR rec IN
      (SELECT folderid
       FROM {databaseOwner}scp_folders
       WHERE ((folderpath = i_folderpath) OR ((folderpath IS NULL) AND (i_folderpath IS NULL)))
       AND((portalid = i_portalid) OR ((portalid IS NULL) AND (i_portalid IS NULL))))
    LOOP
      v_folderid := rec.folderid;

    END LOOP;

    DELETE FROM {databaseOwner}scp_folderpermission
    WHERE folderid = v_folderid;

  END scp_delfolderpermsbypath;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETESKIN
  --------------------------------------------------------

  PROCEDURE scp_deleteskin(i_skinroot IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_skintype IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_skins
    WHERE skinroot = i_skinroot
     AND skintype = i_skintype
     AND((i_portalid IS NULL
     AND portalid IS NULL) OR(portalid = i_portalid));

  END scp_deleteskin;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETESCHEDULE
  --------------------------------------------------------

  PROCEDURE scp_deleteschedule(i_scheduleid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_schedule
    WHERE scheduleid = i_scheduleid;

  END scp_deleteschedule;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEROLEGROUP
  --------------------------------------------------------

  PROCEDURE scp_deleterolegroup(i_rolegroupid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_rolegroups
    WHERE rolegroupid = i_rolegroupid;

  END scp_deleterolegroup;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEPORTALINFO
  --------------------------------------------------------

  PROCEDURE scp_deleteportalinfo(i_portalid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_modules
    WHERE portalid = i_portalid;

    DELETE scp_modules
    WHERE rowid IN
      (SELECT scp_modules.rowid
       FROM {databaseOwner}scp_modules
       INNER JOIN {databaseOwner}scp_searchitem ON scp_modules.moduleid = scp_searchitem.moduleid

       WHERE portalid = i_portalid)
    ;

    DELETE FROM {databaseOwner}scp_portals
    WHERE portalid = i_portalid;

  END scp_deleteportalinfo;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEBANNER
  --------------------------------------------------------

  PROCEDURE scp_deletebanner(i_bannerid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_banners
    WHERE bannerid = i_bannerid;

  END scp_deletebanner;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETESEARCHITEMWORDPOSIT
  --------------------------------------------------------

  PROCEDURE scp_deletesearchitemwordposit(i_searchitemwordpositionid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_searchitemwordposition
    WHERE searchitemwordpositionid = i_searchitemwordpositionid;

  END scp_deletesearchitemwordposit;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETELISTENTRYBYID
  --------------------------------------------------------

  PROCEDURE scp_deletelistentrybyid(i_entryid IN NUMBER DEFAULT NULL,   i_deletechild IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_lists
    WHERE entryid = i_entryid;

    IF i_deletechild = 1 THEN
      BEGIN

        DELETE FROM {databaseOwner}scp_lists
        WHERE parentid = i_entryid;

      END;
    END IF;

  END scp_deletelistentrybyid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEMODULESETTINGS
  --------------------------------------------------------

  PROCEDURE scp_deletemodulesettings(i_moduleid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_modulesettings
    WHERE moduleid = i_moduleid;

  END scp_deletemodulesettings;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEUSERSONLINE
  --------------------------------------------------------

  PROCEDURE scp_deleteusersonline(i_timewindow IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_anonymoususers
    WHERE lastactivedate < {databaseOwner}scpuke_pkg.dateadd('MI',   -i_timewindow,   sysdate);

    DELETE FROM {databaseOwner}scp_usersonline
    WHERE lastactivedate < {databaseOwner}scpuke_pkg.dateadd('MI',   -i_timewindow,   sysdate);

  END scp_deleteusersonline;
  
  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEUSERONLINE
  --------------------------------------------------------

  PROCEDURE scp_deleteuseronline(i_userid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_usersonline
    WHERE userid = i_userid;

  END scp_deleteuseronline;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEMODULE
  --------------------------------------------------------

  PROCEDURE scp_deletemodule(i_moduleid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_modules
    WHERE moduleid = i_moduleid;

  END scp_deletemodule;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEPORTALDESKTOPMODULE
  --------------------------------------------------------

  PROCEDURE scp_deleteportaldesktopmodule(i_portalid IN NUMBER DEFAULT NULL,   i_desktopmoduleid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_portaldesktopmodules
    WHERE((portalid = i_portalid) OR(i_portalid IS NULL
     AND i_desktopmoduleid IS NOT NULL))
     AND((desktopmoduleid = i_desktopmoduleid) OR(i_desktopmoduleid IS NULL
     AND i_portalid IS NOT NULL));

  END scp_deleteportaldesktopmodule;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETESEARCHCOMMONWORD
  --------------------------------------------------------

  PROCEDURE scp_deletesearchcommonword(i_commonwordid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_searchcommonwords
    WHERE commonwordid = i_commonwordid;

  END scp_deletesearchcommonword;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEUSER
  --------------------------------------------------------

  PROCEDURE scp_deleteuser(i_userid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_users
    WHERE userid = i_userid;

  END scp_deleteuser;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETETABPERMISSION
  --------------------------------------------------------

  PROCEDURE scp_deletetabpermission(i_tabpermissionid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_tabpermission
    WHERE tabpermissionid = i_tabpermissionid;

  END scp_deletetabpermission;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETETABPERMISSIONSBYTAB
  --------------------------------------------------------

  PROCEDURE scp_deletetabpermissionsbytab(i_tabid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_tabpermission
    WHERE tabid = i_tabid;

  END scp_deletetabpermissionsbytab;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEMODULECONTROL
  --------------------------------------------------------

  PROCEDURE scp_deletemodulecontrol(i_modulecontrolid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_modulecontrols
    WHERE modulecontrolid = i_modulecontrolid;

  END scp_deletemodulecontrol;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETETABMODULESETTING
  --------------------------------------------------------

  PROCEDURE scp_deletetabmodulesetting(i_tabmoduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_tabmodulesettings
    WHERE tabmoduleid = i_tabmoduleid
     AND settingname = i_settingname;

  END scp_deletetabmodulesetting;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEPORTALALIAS
  --------------------------------------------------------

  PROCEDURE scp_deleteportalalias(i_portalaliasid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_portalalias
    WHERE portalaliasid = i_portalaliasid;

  END scp_deleteportalalias;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETESEARCHITEM
  --------------------------------------------------------

  PROCEDURE scp_deletesearchitem(i_searchitemid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_searchitem
    WHERE searchitemid = i_searchitemid;

  END scp_deletesearchitem;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEPERMISSION
  --------------------------------------------------------

  PROCEDURE scp_deletepermission(i_permissionid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_permission
    WHERE permissionid = i_permissionid;

  END scp_deletepermission;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETETABMODULE
  --------------------------------------------------------

  PROCEDURE scp_deletetabmodule(i_tabid IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_tabmodules
    WHERE tabid = i_tabid
     AND moduleid = i_moduleid;

  END scp_deletetabmodule;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELMODPERMSBYMODID
  --------------------------------------------------------

  PROCEDURE scp_delmodpermsbymodid(i_moduleid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_modulepermission
    WHERE moduleid = i_moduleid;

  END scp_delmodpermsbymodid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEVENDOR
  --------------------------------------------------------

  PROCEDURE scp_deletevendor(i_vendorid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_vendors
    WHERE vendorid = i_vendorid;

  END scp_deletevendor;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEEVENTLOGTYPE
  --------------------------------------------------------

  PROCEDURE scp_deleteeventlogtype(i_logtypekey IN nvarchar2 DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_eventlogtypes
    WHERE logtypekey = i_logtypekey;

  END scp_deleteeventlogtype;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEUSERROLE
  --------------------------------------------------------

  PROCEDURE scp_deleteuserrole(i_userid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_userroles
    WHERE userid = i_userid
     AND roleid = i_roleid;

  END scp_deleteuserrole;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETESEARCHWORD
  --------------------------------------------------------

  PROCEDURE scp_deletesearchword(i_searchwordsid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_searchword
    WHERE searchwordsid = i_searchwordsid;

  END scp_deletesearchword;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEUSERPORTAL
  --------------------------------------------------------

  PROCEDURE scp_deleteuserportal(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_userportals
    WHERE userid = i_userid
     AND portalid = i_portalid;

  END scp_deleteuserportal;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEURL
  --------------------------------------------------------

  PROCEDURE scp_deleteurl(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_urls
    WHERE portalid = i_portalid
     AND url = i_url;

  END scp_deleteurl;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETETABMODULESETTINGS
  --------------------------------------------------------

  PROCEDURE scp_deletetabmodulesettings(i_tabmoduleid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_tabmodulesettings
    WHERE tabmoduleid = i_tabmoduleid;

  END scp_deletetabmodulesettings;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETESEARCHITEMWORDS
  --------------------------------------------------------

  PROCEDURE scp_deletesearchitemwords(i_searchitemid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_searchitemword
    WHERE searchitemid = i_searchitemid;

  END scp_deletesearchitemwords;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEMODULEPERMISSION
  --------------------------------------------------------

  PROCEDURE scp_deletemodulepermission(i_modulepermissionid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_modulepermission
    WHERE modulepermissionid = i_modulepermissionid;

  END scp_deletemodulepermission;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEEVENTLOGCONFIG
  --------------------------------------------------------

  PROCEDURE scp_deleteeventlogconfig(i_id IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_eventlogconfig
    WHERE id = i_id;

  END scp_deleteeventlogconfig;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETESITELOG
  --------------------------------------------------------

  PROCEDURE scp_deletesitelog(i_datetime IN DATE DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_sitelog
    WHERE(portalid = i_portalid)
     AND(datetime < i_datetime);

  END scp_deletesitelog;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELVENDORCLASSIFICATIONS
  --------------------------------------------------------

  PROCEDURE scp_delvendorclassifications(i_vendorid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_vendorclassification
    WHERE vendorid = i_vendorid;

  END scp_delvendorclassifications;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEMODULESETTING
  --------------------------------------------------------

  PROCEDURE scp_deletemodulesetting(i_moduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_modulesettings
    WHERE moduleid = i_moduleid
     AND settingname = i_settingname;

  END scp_deletemodulesetting;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEDESKTOPMODULE
  --------------------------------------------------------

  PROCEDURE scp_deletedesktopmodule(i_desktopmoduleid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_desktopmodules
    WHERE desktopmoduleid = i_desktopmoduleid;

  END scp_deletedesktopmodule;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEURLTRACKING
  --------------------------------------------------------

  PROCEDURE scp_deleteurltracking(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_urltracking
    WHERE portalid = i_portalid
     AND url = i_url
     AND((moduleid = i_moduleid) OR(i_moduleid IS NULL
     AND moduleid IS NULL));

  END scp_deleteurltracking;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETETAB
  --------------------------------------------------------

  PROCEDURE scp_deletetab(i_tabid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_tabs
    WHERE tabid = i_tabid;

  END scp_deletetab;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETESEARCHITEMS
  --------------------------------------------------------

  PROCEDURE scp_deletesearchitems(i_moduleid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_searchitem
    WHERE moduleid = i_moduleid;

  END scp_deletesearchitems;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEPROPERTYDEFINITION
  --------------------------------------------------------

  PROCEDURE scp_deletepropertydefinition(i_propertydefinitionid IN NUMBER DEFAULT NULL) AS
  BEGIN

    UPDATE {databaseOwner}scp_profilepropertydefinition
    SET deleted = 1
    WHERE propertydefinitionid = i_propertydefinitionid;

  END scp_deletepropertydefinition;

  --------------------------------------------------------
  --  DDL for Procedure SCP_DELETEFILES
  --------------------------------------------------------

  PROCEDURE scp_deletefiles(i_portalid IN NUMBER DEFAULT NULL) AS
  BEGIN

    DELETE FROM {databaseOwner}scp_files
    WHERE((portalid = i_portalid) OR(i_portalid IS NULL
     AND portalid IS NULL));

  END scp_deletefiles;
  
  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPASSWORDQUESTION
  --------------------------------------------------------
  
  PROCEDURE scp_getpasswordquestions(i_locale IN NVARCHAR2 DEFAULT NULL, o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
    v_count number(10,0);
  BEGIN
  
    SELECT COUNT(*) INTO v_count
    FROM {databaseOwner}scp_questions
    WHERE LOWER(locale) = LOWER(i_locale);    
  
    IF (v_count = 0) THEN
  
      OPEN o_rc1 FOR
      SELECT * FROM {databaseOwner}scp_questions
      WHERE LOWER(locale) = 'en-us' OR locale IS NULL;
    
    ELSE
    
      OPEN o_rc1 FOR
      SELECT * FROM {databaseOwner}scp_questions
      WHERE LOWER(locale) = LOWER(i_locale);
      
    END IF;
  
  END scp_getpasswordquestions;
  
  --------------------------------------------------------
  --  DDL for Procedure SCP_GETACCOUNTID
  --------------------------------------------------------

  PROCEDURE scp_getaccountid(i_portalid IN NUMBER DEFAULT NULL, i_accountnumber IN VARCHAR2 DEFAULT NULL, o_accountid OUT NUMBER) AS

  BEGIN
  
    SELECT accountid INTO o_accountid
    FROM {databaseOwner}scp_accountnumbers
    WHERE (portalid = i_portalid 
    OR (i_portalid IS NULL AND portalid IS NULL))
    AND accountnumber = i_accountnumber;	  
      
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
      o_accountid := -1;
  
  END scp_getaccountid;
  
  --------------------------------------------------------
  --  DDL for Procedure SCP_GETACCOUNTBYID
  --------------------------------------------------------
  
  PROCEDURE scp_getaccountbyid(i_accountid IN NUMBER DEFAULT NULL, o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
  
  BEGIN
  
      OPEN o_rc1 FOR
	  SELECT *
	  FROM {databaseOwner}scp_accountnumbers
	  WHERE accountid = i_accountid;
  
  END scp_getaccountbyid;
  
  --------------------------------------------------------
  --  DDL for Procedure SCP_GETACCOUNTBYNUMBER
  --------------------------------------------------------
  
  PROCEDURE scp_getaccountbynumber(i_portalid IN NUMBER DEFAULT NULL, i_accountnumber IN VARCHAR2 DEFAULT NULL, o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
  
  BEGIN
  
    OPEN o_rc1 FOR
    SELECT *
    FROM {databaseOwner}scp_accountnumbers
    WHERE LOWER(accountnumber) = LOWER(i_accountnumber)
     AND (portalid = i_portalid 
     OR (i_portalid IS NULL AND portalid IS NULL));
  
  END scp_getaccountbynumber;
  
  --------------------------------------------------------
  --  DDL for Procedure SCP_GETACCOUNTS
  --------------------------------------------------------

  PROCEDURE scp_getaccounts(i_portalid IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1,   o_totalrecords OUT {databaseOwner}global_pkg.rct1) AS
  v_pagelowerbound NUMBER(10,   0);
  v_pageupperbound NUMBER(10,   0);
  BEGIN
      v_pagelowerbound := (i_pagesize * i_pageindex) + 1;
      v_pageupperbound := i_pagesize + v_pagelowerbound - 1;
      
      OPEN o_rc1 FOR    
      SELECT *
      FROM (SELECT accounts.*, ROWNUM rnum 
      FROM (SELECT *
	  FROM {databaseOwner}scp_accountnumbers
	  WHERE (portalid = i_portalid OR (i_portalid IS NULL
          AND portalid IS NULL))
      ORDER BY accountnumber) accounts
      WHERE ROWNUM <= v_pageupperbound)
      WHERE rnum >= v_pagelowerbound;
  
      OPEN o_totalrecords FOR
      SELECT COUNT(*) TotalRecords 
      FROM {databaseOwner}scp_accountnumbers
	  WHERE (portalid = i_portalid OR (i_portalid IS NULL
          AND portalid IS NULL));
  
  END scp_getaccounts;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETAFFILIATES
  --------------------------------------------------------

  PROCEDURE scp_getaffiliates(i_vendorid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT affiliateid,
      startdate,
      enddate,
      cpc,
      clicks,
      clicks *cpc cpctotal,
      cpa,
      acquisitions,
      acquisitions *cpa cpatotal
    FROM {databaseOwner}scp_affiliates
    WHERE vendorid = i_vendorid
    ORDER BY startdate DESC;
  END scp_getaffiliates;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSEARCHCOMMONWORDBYID
  --------------------------------------------------------

  PROCEDURE scp_getsearchcommonwordbyid(i_commonwordid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT commonwordid,
      commonword,
      locale
    FROM {databaseOwner}scp_searchcommonwords
    WHERE commonwordid = i_commonwordid;
  END scp_getsearchcommonwordbyid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULESETTING
  --------------------------------------------------------

  PROCEDURE scp_getmodulesetting(i_moduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT
    CASE
    WHEN SUBSTR(LOWER(scp_modulesettings.settingvalue),   1,   6) = 'fileid' THEN
        (SELECT folder || filename
         FROM {databaseOwner}scp_files
         WHERE 'FileID=' ||scp_files.fileid = scp_modulesettings.settingvalue)
    ELSE
      scp_modulesettings.settingvalue
    END settingvalue
    FROM {databaseOwner}scp_modulesettings
    WHERE moduleid = i_moduleid
     AND settingname = i_settingname;
  END scp_getmodulesetting;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSEARCHCOMMONWORDSBYLOC
  --------------------------------------------------------

  PROCEDURE scp_getsearchcommonwordsbyloc(i_locale IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT commonwordid,
      commonword,
      locale
    FROM {databaseOwner}scp_searchcommonwords
    WHERE locale = i_locale;
  END scp_getsearchcommonwordsbyloc;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETDESKTOPMODULESBYPORTAL
  --------------------------------------------------------

  PROCEDURE scp_getdesktopmodulesbyportal(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT DISTINCT(scp_desktopmodules.desktopmoduleid) desktopmoduleid,
      scp_desktopmodules.friendlyname,
      scp_desktopmodules.description,
      scp_desktopmodules.version,
      scp_desktopmodules.ispremium,
      scp_desktopmodules.isadmin,
      scp_desktopmodules.businesscontrollerclass,
      scp_desktopmodules.foldername,
      scp_desktopmodules.modulename,
      scp_desktopmodules.supportedfeatures,
      scp_desktopmodules.compatibleversions
    FROM {databaseOwner}scp_desktopmodules LEFT JOIN {databaseOwner}scp_portaldesktopmodules ON scp_desktopmodules.desktopmoduleid = scp_portaldesktopmodules.desktopmoduleid

    WHERE isadmin = 0
     AND(ispremium = 0 OR(portalid = i_portalid
     AND portaldesktopmoduleid IS NOT NULL))
    ORDER BY scp_desktopmodules.friendlyname;
  END scp_getdesktopmodulesbyportal;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETUNAUTHORIZEDUSERS
  --------------------------------------------------------

  PROCEDURE scp_getunauthorizedusers(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_users
    WHERE portalid = i_portalid
     AND authorised = 0
    ORDER BY accountnumber, username;
  END scp_getunauthorizedusers;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULE
  --------------------------------------------------------

  PROCEDURE scp_getmodule(i_moduleid IN NUMBER DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_modules
    WHERE moduleid = i_moduleid
     AND(tabid = i_tabid OR i_tabid IS NULL);
  END scp_getmodule;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETTABMODULES
  --------------------------------------------------------

  PROCEDURE scp_gettabmodules(i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_modules
    WHERE tabid = i_tabid
    ORDER BY moduleorder;
  END scp_gettabmodules;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPORTALBYTAB
  --------------------------------------------------------

  PROCEDURE scp_getportalbytab(i_tabid IN NUMBER DEFAULT NULL,   i_httpalias IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT httpalias
    FROM {databaseOwner}scp_portalalias
    INNER JOIN {databaseOwner}scp_tabs ON scp_portalalias.portalid = scp_tabs.portalid
    WHERE tabid = i_tabid
     AND httpalias = i_httpalias;
  END scp_getportalbytab;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULEPERMISSIONSBYMOD
  --------------------------------------------------------

  PROCEDURE scp_getmodulepermissionsbymod(i_moduleid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_modulepermissions
    WHERE(moduleid = -1 OR moduleid = i_moduleid OR(moduleid IS NULL
     AND permissioncode = 'SYSTEM_MODULE_DEFINITION'))
     AND(permissionid = i_permissionid OR i_permissionid = -1);
  END scp_getmodulepermissionsbymod;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSYSTEMMESSAGES
  --------------------------------------------------------

  PROCEDURE scp_getsystemmessages(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT messagename
    FROM {databaseOwner}scp_systemmessages
    WHERE portalid IS NULL;
  END scp_getsystemmessages;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPROPERTYDEFBYCATEGORY
  --------------------------------------------------------

  PROCEDURE scp_getpropertydefbycategory(i_portalid IN NUMBER DEFAULT NULL,   i_category IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_profilepropertydefinition
    WHERE(portalid = i_portalid OR(i_portalid IS NULL
     AND portalid IS NULL))
     AND propertycategory = i_category
    ORDER BY vieworder;
  END scp_getpropertydefbycategory;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETURLTRACKING
  --------------------------------------------------------

  PROCEDURE scp_geturltracking(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_urltracking
    WHERE portalid = i_portalid
     AND url = i_url
     AND((moduleid = i_moduleid) OR(i_moduleid IS NULL
     AND moduleid IS NULL));
  END scp_geturltracking;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSEARCHWORDBYID
  --------------------------------------------------------

  PROCEDURE scp_getsearchwordbyid(i_searchwordsid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT searchwordsid,
      word,
      iscommon,
      hitcount
    FROM {databaseOwner}scp_searchword
    WHERE searchwordsid = i_searchwordsid;
  END scp_getsearchwordbyid;
  
  --------------------------------------------------------
  --  DDL for Procedure SCP_GETVENDOR
  --------------------------------------------------------

PROCEDURE scp_GetVendor (  i_VendorId in number,  i_PortalId in number,  o_rc1 out {databaseOwner}global_pkg.rct1)
as
begin

    open o_rc1 for
    select scp_Vendors.VendorName, 
       scp_Vendors.Unit, 
       scp_Vendors.Street, 
       scp_Vendors.City, 
       scp_Vendors.Region, 
       scp_Vendors.Country, 
       scp_Vendors.PostalCode, 
       scp_Vendors.Telephone,
       scp_Vendors.Fax,
       scp_Vendors.Cell,
       scp_Vendors.Email,
       scp_Vendors.Website,
       scp_Vendors.FirstName,
       scp_Vendors.LastName,
       scp_Vendors.ClickThroughs,
       scp_Vendors.Views,
       scp_Users.FirstName || ' ' ||scp_Users.LastName as CreatedByUser,
       scp_Vendors.CreatedDate,
       case when scp_Files.FileName is null then scp_Vendors.LogoFile else scp_Files.Folder || scp_Files.FileName end as LogoFile,
       scp_Vendors.KeyWords,
       scp_Vendors.Authorized,
       scp_Vendors.PortalId
    from {databaseOwner}scp_Vendors
    left outer join {databaseOwner}scp_Users on scp_Vendors.CreatedByUser = scp_Users.UserId
    left outer join {databaseOwner}scp_Files on scp_Vendors.LogoFile = 'FileID=' || scp_Files.FileID
    where  VendorId = i_VendorId
    and    ((scp_Vendors.PortalId = i_PortalId) or (scp_Vendors.PortalId is null and i_PortalId is null));

  end scp_GetVendor;
  --------------------------------------------------------
  --  DDL for Procedure SCP_GETVENDORS
  --------------------------------------------------------

  PROCEDURE scp_getvendors(i_portalid IN NUMBER DEFAULT NULL,   i_unauthorized IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1) AS
  v_pagelowerbound NUMBER(10,   0);
  v_pageupperbound NUMBER(10,   0);
  BEGIN
    v_pagelowerbound := (i_pagesize * i_pageindex) + 1;
    v_pageupperbound := i_pagesize + v_pagelowerbound - 1;

    OPEN o_rc1 FOR   
    SELECT *
    FROM (SELECT vendors.*, ROWNUM rnum 
    FROM (SELECT scp_vendors.*, 
    (SELECT COUNT(*) 
    FROM {databaseOwner}scp_banners 
    WHERE scp_banners.vendorid = scp_vendors.vendorid) banners
    FROM {databaseOwner}scp_vendors    
    WHERE((authorized = 0 AND i_unauthorized = 1) OR (i_unauthorized = 0))
     AND((portalid = i_portalid) OR (i_portalid IS NULL
     AND portalid IS NULL))
    ORDER BY vendorid DESC) vendors
    WHERE ROWNUM <= v_pageupperbound)
    WHERE rnum >= v_pagelowerbound;
    
    OPEN o_totalrecords FOR
    SELECT COUNT(*) TotalRecords
    FROM {databaseOwner}scp_vendors    
    WHERE((authorized = 0 AND i_unauthorized = 1) OR (i_unauthorized = 0))
     AND((portalid = i_portalid) OR (i_portalid IS NULL
     AND portalid IS NULL));
    
  END scp_getvendors;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETUSERSBYEMAIL
  --------------------------------------------------------

  PROCEDURE scp_getusersbyemail(i_portalid IN NUMBER DEFAULT NULL,   i_emailtomatch IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1) AS
  v_pagelowerbound NUMBER(10,   0);
  v_pageupperbound NUMBER(10,   0);
  BEGIN    
      v_pagelowerbound := (i_pagesize * i_pageindex) + 1;
      v_pageupperbound := i_pagesize + v_pagelowerbound - 1;

      OPEN o_rc1 FOR
      SELECT *
	  FROM (SELECT a.*, ROWNUM rnum 
      FROM (SELECT *
      FROM {databaseOwner}scp_vw_users
      WHERE LOWER(email) LIKE LOWER({databaseOwner}scpuke_pkg.FORMATSQL(i_emailtomatch)) ESCAPE '\' OR (i_emailtomatch IS NULL AND email IS NULL)
		AND(portalid = i_portalid OR (i_portalid IS NULL AND portalid IS NULL))
      ORDER BY accountnumber, LOWER(email)) a
      WHERE ROWNUM <= v_pageupperbound)
      WHERE rnum >= v_pagelowerbound;
      
      OPEN o_totalrecords FOR
      SELECT COUNT(*) TotalRecords
      FROM {databaseOwner}scp_vw_users
      WHERE LOWER(email) LIKE LOWER({databaseOwner}scpuke_pkg.FORMATSQL(i_emailtomatch)) ESCAPE '\' OR (i_emailtomatch IS NULL AND email IS NULL)
		AND(portalid = i_portalid OR (i_portalid IS NULL AND portalid IS NULL));
    
  END scp_getusersbyemail;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETROLESBYUSER
  --------------------------------------------------------

  PROCEDURE scp_getrolesbyuser(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT scp_roles.rolename,
      scp_roles.roleid
    FROM {databaseOwner}scp_userroles
    INNER JOIN {databaseOwner}scp_users ON scp_userroles.userid = scp_users.userid
    INNER JOIN {databaseOwner}scp_roles ON scp_userroles.roleid = scp_roles.roleid
    WHERE scp_users.userid = i_userid
     AND scp_roles.portalid = i_portalid
     AND(effectivedate <= sysdate OR effectivedate IS NULL)
     AND(expirydate >= sysdate OR expirydate IS NULL);
  END scp_getrolesbyuser;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETEVENTLOGPENDINGNOTIFCO
  --------------------------------------------------------

  PROCEDURE scp_geteventlogpendingnotifco(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT COUNT(*) pendingnotifs,
      elc.id,
      elc.logtypekey,
      elc.logtypeportalid,
      elc.loggingisactive,
      elc.keepmostrecent,
      elc.emailnotificationisactive,
      elc.notificationthreshold,
      elc.notificationthresholdtime,
      elc.notificationthresholdtimetype,
      elc.mailtoaddress,
      elc.mailfromaddress
    FROM {databaseOwner}scp_eventlogconfig elc
    INNER JOIN {databaseOwner}scp_eventlog ON scp_eventlog.logconfigid = elc.id
    WHERE scp_eventlog.lognotificationpending = 1
    GROUP BY elc.id,
      elc.logtypekey,
      elc.logtypeportalid,
      elc.loggingisactive,
      elc.keepmostrecent,
      elc.emailnotificationisactive,
      elc.notificationthreshold,
      elc.notificationthresholdtime,
      elc.notificationthresholdtimetype,
      elc.mailtoaddress,
      elc.mailfromaddress;
  END scp_geteventlogpendingnotifco;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULECONTROL
  --------------------------------------------------------

  PROCEDURE scp_getmodulecontrol(i_modulecontrolid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_modulecontrols
    WHERE modulecontrolid = i_modulecontrolid;
  END scp_getmodulecontrol;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETUSERROLE
  --------------------------------------------------------

  PROCEDURE scp_getuserrole(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT r.*,
      ur.userroleid,
      ur.userid,
      ur.effectivedate,
      ur.expirydate,
      ur.istrialused
    FROM {databaseOwner}scp_userroles ur
    INNER JOIN {databaseOwner}scp_userportals up ON ur.userid = up.userid
    INNER JOIN {databaseOwner}scp_roles r ON r.roleid = ur.roleid
    WHERE up.userid = i_userid
     AND up.portalid = i_portalid
     AND ur.roleid = i_roleid;
  END scp_getuserrole;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPORTALSBYNAME
  --------------------------------------------------------

  PROCEDURE scp_getportalsbyname(i_nametomatch IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1) AS
  v_pagelowerbound NUMBER(10,   0);
  v_pageupperbound NUMBER(10,   0);
  BEGIN
  
      v_pagelowerbound := (i_pagesize * i_pageindex) + 1;
    v_pageupperbound := i_pagesize + v_pagelowerbound - 1;

      OPEN o_rc1 FOR
      SELECT *
      FROM (SELECT portals.*, ROWNUM rnum 
      FROM (SELECT *
      FROM {databaseOwner}scp_vw_portals
      WHERE LOWER(portalname) LIKE LOWER({databaseOwner}scpuke_pkg.FORMATSQL(i_nametomatch) || '%') ESCAPE '\'
      ORDER BY LOWER(portalname)) portals
      WHERE ROWNUM <= v_pageupperbound)
      WHERE rnum >= v_pagelowerbound;      
      
      OPEN o_totalrecords FOR
      SELECT COUNT(*) TotalRecords
      FROM {databaseOwner}scp_vw_portals
      WHERE LOWER(portalname) LIKE LOWER({databaseOwner}scpuke_pkg.FORMATSQL(i_nametomatch)) || '%' ESCAPE '\';
      
  END scp_getportalsbyname;
  
  --------------------------------------------------------
  --  DDL for Procedure SCP_GETBANNER
  --------------------------------------------------------

  procedure scp_getbanner (i_BannerId in number,    i_VendorId in number,    i_PortalID in number,    o_rc1 OUT {databaseOwner}global_pkg.rct1)
  as
  begin
  
    open o_rc1 for
    select scp_Banners.BannerId,
       scp_Banners.VendorId,
       case when scp_Files.FileName is null then scp_Banners.ImageFile else scp_Files.Folder || scp_Files.FileName end as ImageFile,
       scp_Banners.BannerName,
       scp_Banners.Impressions,
       scp_Banners.CPM,
       scp_Banners.Views,
       scp_Banners.ClickThroughs,
       scp_Banners.StartDate,
       scp_Banners.EndDate,
       scp_Users.FirstName || ' ' || scp_Users.LastName as CreatedByUser,
       scp_Banners.CreatedDate,
       scp_Banners.BannerTypeId,
       scp_Banners.Description,
       scp_Banners.GroupName,
       scp_Banners.Criteria,
       scp_Banners.URL,        
       scp_Banners.Width,
       scp_Banners.Height
    FROM   {databaseOwner}scp_Banners 
    INNER JOIN {databaseOwner}scp_Vendors ON scp_Banners.VendorId = scp_Vendors.VendorId 
    LEFT OUTER JOIN {databaseOwner}scp_Users ON scp_Banners.CreatedByUser = scp_Users.UserID
    left outer join {databaseOwner}scp_Files on scp_Banners.ImageFile = 'FileID=' || scp_Files.FileID
    where  scp_Banners.BannerId = i_BannerId
    and   scp_Banners.vendorId = i_VendorId
    AND (scp_Vendors.PortalId = i_PortalID or (scp_Vendors.PortalId is null and i_portalid is null));

end scp_getbanner;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETBANNERS
  --------------------------------------------------------

  PROCEDURE scp_getbanners(i_vendorid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT bannerid,
      bannername,
      url,
      impressions,
      cpm,
      views,
      clickthroughs,
      startdate,
      enddate,
      bannertypeid,
      description,
      groupname,
      criteria,
      width,
      height
    FROM {databaseOwner}scp_banners
    WHERE vendorid = i_vendorid
    ORDER BY createddate DESC;
  END scp_getbanners;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETFOLDERBYFOLDERID
  --------------------------------------------------------

  PROCEDURE scp_getfolderbyfolderid(i_portalid IN NUMBER DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_folders
    WHERE((portalid = i_portalid) OR(i_portalid IS NULL
     AND portalid IS NULL))
     AND(folderid = i_folderid);
  END scp_getfolderbyfolderid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPROPERTYDEFBYPORTAL
  --------------------------------------------------------

  PROCEDURE scp_getpropertydefbyportal(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_profilepropertydefinition
    WHERE(portalid = i_portalid OR(i_portalid IS NULL
     AND portalid IS NULL))
     AND deleted = 0
    ORDER BY vieworder;
  END scp_getpropertydefbyportal;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETTABPERMISSION
  --------------------------------------------------------

  PROCEDURE scp_gettabpermission(i_tabpermissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_tabpermissions
    WHERE tabpermissionid = i_tabpermissionid;
  END scp_gettabpermission;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSEARCHITEMS
  --------------------------------------------------------

  PROCEDURE scp_getsearchitems(i_portalid IN NUMBER DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT si.*,
      u.firstname || ' ' || u.lastname authorname,
      t.tabid
    FROM {databaseOwner}scp_searchitem si LEFT JOIN {databaseOwner}scp_users u ON si.author = u.userid
    INNER JOIN {databaseOwner}scp_modules m ON si.moduleid = m.moduleid
    INNER JOIN {databaseOwner}scp_tabmodules tm ON m.moduleid = tm.moduleid
    INNER JOIN {databaseOwner}scp_tabs t ON tm.tabid = t.tabid
    INNER JOIN {databaseOwner}scp_portals p ON t.portalid = p.portalid
    WHERE(p.portalid = i_portalid OR i_portalid IS NULL)
     AND(t.tabid = i_tabid OR i_tabid IS NULL)
     AND(m.moduleid = i_moduleid OR i_moduleid IS NULL)
    ORDER BY pubdate DESC;
  END scp_getsearchitems;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETFILE
  --------------------------------------------------------

  PROCEDURE scp_getfile(i_filename IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT fileid,
      scp_folders.portalid,
      filename,
      extension,
      size_,
      width,
      height,
      contenttype,
      scp_files.folderid,
      folderpath folder,
      storagelocation,
      iscached
    FROM {databaseOwner}scp_files
    INNER JOIN {databaseOwner}scp_folders ON scp_files.folderid = scp_folders.folderid
    WHERE filename = i_filename
     AND scp_files.folderid = i_folderid
     AND((scp_folders.portalid = i_portalid) OR(i_portalid IS NULL
     AND scp_folders.portalid IS NULL));
  END scp_getfile;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETHOSTSETTING
  --------------------------------------------------------

  PROCEDURE scp_gethostsetting(i_settingname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT settingvalue
    FROM {databaseOwner}scp_hostsettings
    WHERE settingname = i_settingname;
  END scp_gethostsetting;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPROPERTYDEFBYNAME
  --------------------------------------------------------

  PROCEDURE scp_getpropertydefbyname(portalid IN NUMBER DEFAULT NULL,   name IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_profilepropertydefinition
    WHERE(portalid = portalid OR(portalid IS NULL
     AND portalid IS NULL))
     AND propertyname = name
    ORDER BY vieworder;
  END scp_getpropertydefbyname;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPERMISSIONSBYMODULEID
  --------------------------------------------------------

  PROCEDURE scp_getpermissionsbymoduleid(i_moduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT p.permissionid,
      p.permissioncode,
      p.moduledefid,
      p.permissionkey,
      p.permissionname
    FROM {databaseOwner}scp_permission p
    WHERE p.moduledefid =
      (SELECT moduledefid
       FROM {databaseOwner}scp_modules
       WHERE moduleid = i_moduleid)
    OR p.permissioncode = 'SYSTEM_MODULE_DEFINITION';
  END scp_getpermissionsbymoduleid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULECONTROLBYKEYSCR
  --------------------------------------------------------

  PROCEDURE scp_getmodulecontrolbykeyscr(i_moduledefid IN NUMBER DEFAULT NULL,   i_controlkey IN nvarchar2 DEFAULT NULL,   i_controlsrc IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT modulecontrolid,
      moduledefid,
      controlkey,
      controltitle,
      controlsrc,
      iconfile,
      controltype,
      vieworder
    FROM {databaseOwner}scp_modulecontrols
    WHERE((i_moduledefid IS NULL
     AND moduledefid IS NULL) OR(moduledefid = i_moduledefid))
     AND((i_controlkey IS NULL
     AND controlkey IS NULL) OR(controlkey = i_controlkey))
     AND((i_controlsrc IS NULL
     AND controlsrc IS NULL) OR(controlsrc = i_controlsrc));
  END scp_getmodulecontrolbykeyscr;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSEARCHITEMWORDBYWORD
  --------------------------------------------------------

  PROCEDURE scp_getsearchitemwordbyword(i_searchwordsid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT searchitemwordid,
      searchitemid,
      searchwordsid,
      occurrences
    FROM {databaseOwner}scp_searchitemword
    WHERE searchwordsid = i_searchwordsid;
  END scp_getsearchitemwordbyword;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETTABSBYPARENTID
  --------------------------------------------------------

  PROCEDURE scp_gettabsbyparentid(i_parentid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_tabs
    WHERE parentid = i_parentid
    ORDER BY taborder;
  END scp_gettabsbyparentid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULECONTROLSBYKEY
  --------------------------------------------------------

  PROCEDURE scp_getmodulecontrolsbykey(i_controlkey IN nvarchar2 DEFAULT NULL,   i_moduledefid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT scp_moduledefinitions.*,
      modulecontrolid,
      controltitle,
      controlsrc,
      iconfile,
      controltype,
      helpurl
    FROM {databaseOwner}scp_modulecontrols LEFT JOIN {databaseOwner}scp_moduledefinitions ON scp_modulecontrols.moduledefid = scp_moduledefinitions.moduledefid

    WHERE((i_controlkey IS NULL
     AND controlkey IS NULL) OR(controlkey = i_controlkey))
     AND((scp_modulecontrols.moduledefid IS NULL
     AND i_moduledefid IS NULL) OR(scp_modulecontrols.moduledefid = i_moduledefid))
     AND controltype >= -1
    ORDER BY vieworder;
  END scp_getmodulecontrolsbykey;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPORTALS
  --------------------------------------------------------

  PROCEDURE scp_getportals(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_portals
    ORDER BY portalname;
  END scp_getportals;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSITELOG4
  --------------------------------------------------------

  PROCEDURE scp_getsitelog4(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT referrer,
      COUNT(*) requests,
      MAX(datetime) lastrequest
    FROM {databaseOwner}scp_sitelog
    WHERE scp_sitelog.portalid = i_portalid
     AND scp_sitelog.datetime BETWEEN i_startdate
     AND i_enddate
     AND referrer IS NOT NULL
     AND referrer NOT LIKE '%' || {databaseOwner}scpuke_pkg.FORMATSQL(i_portalalias) || '%' ESCAPE '\'
    GROUP BY referrer
    ORDER BY requests DESC;
  END scp_getsitelog4;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETEVENTLOGPENDINGNOTIF
  --------------------------------------------------------

  PROCEDURE scp_geteventlogpendingnotif(i_logconfigid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_eventlog
    WHERE lognotificationpending = 1
     AND logconfigid = i_logconfigid;
  END scp_geteventlogpendingnotif;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETTABLES
  --------------------------------------------------------

  PROCEDURE scp_gettables(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM user_objects
    WHERE object_type = 'TABLE'
     AND TEMPORARY = 'N'
     AND object_name LIKE '%SCP\_%' ESCAPE '\'
    ORDER BY object_name;

  END scp_gettables;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETALLFILES
  --------------------------------------------------------

  PROCEDURE scp_getallfiles(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT fileid,
      fo.portalid,
      filename,
      extension,
      size_,
      width,
      height,
      contenttype,
      f.folderid,
      folderpath folder,
      storagelocation,
      iscached
    FROM {databaseOwner}scp_files f
    INNER JOIN {databaseOwner}scp_folders fo ON f.folderid = fo.folderid;
  END scp_getallfiles;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSITELOG9
  --------------------------------------------------------

  PROCEDURE scp_getsitelog9(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT scp_tabs.tabname PAGE,
      COUNT(*) requests,
      MAX(datetime) lastrequest
    FROM {databaseOwner}scp_sitelog
    INNER JOIN {databaseOwner}scp_tabs ON scp_sitelog.tabid = scp_tabs.tabid
    WHERE scp_sitelog.portalid = i_portalid
     AND scp_sitelog.datetime BETWEEN i_startdate
     AND i_enddate
     AND scp_sitelog.tabid IS NOT NULL
    GROUP BY scp_tabs.tabname
    ORDER BY requests DESC;
  END scp_getsitelog9;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETUSER
  --------------------------------------------------------

  PROCEDURE scp_getuser(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_users u
    WHERE userid = i_userid
     AND(portalid = i_portalid OR issuperuser = 1);
  END scp_getuser;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETROLE
  --------------------------------------------------------

  PROCEDURE scp_getrole(i_roleid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT roleid,
      portalid,
      rolegroupid,
      rolename,
      description,
      servicefee,
      billingperiod,
      billingfrequency,
      trialfee,
      trialperiod,
      trialfrequency,
      ispublic,
      autoassignment,
      rsvpcode,
      iconfile
    FROM {databaseOwner}scp_roles
    WHERE roleid = i_roleid
     AND portalid = i_portalid;
  END scp_getrole;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULEDEFINITION
  --------------------------------------------------------

  PROCEDURE scp_getmoduledefinition(i_moduledefid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_moduledefinitions
    WHERE moduledefid = i_moduledefid;
  END scp_getmoduledefinition;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULES
  --------------------------------------------------------

  PROCEDURE scp_getmodules(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_modules
    WHERE portalid = i_portalid
    ORDER BY moduleid;
  END scp_getmodules;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULESETTINGS
  --------------------------------------------------------

  PROCEDURE scp_getmodulesettings(i_moduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT settingname,
      CASE
    WHEN SUBSTR(LOWER(scp_modulesettings.settingvalue),   1,   6) = 'fileid' THEN
        (SELECT folder || filename
         FROM {databaseOwner}scp_files
         WHERE 'FileID=' || scp_files.fileid = scp_modulesettings.settingvalue)
    ELSE
      scp_modulesettings.settingvalue
    END settingvalue
    FROM {databaseOwner}scp_modulesettings
    WHERE moduleid = i_moduleid;
  END scp_getmodulesettings;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPERMISSIONSBYMODDEFID
  --------------------------------------------------------

  PROCEDURE scp_getpermissionsbymoddefid(i_moduledefid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT p.permissionid,
      p.permissioncode,
      p.moduledefid,
      p.permissionkey,
      p.permissionname
    FROM {databaseOwner}scp_permission p
    WHERE p.moduledefid = i_moduledefid;
  END scp_getpermissionsbymoddefid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPERMISSIONBYCODEANDKEY
  --------------------------------------------------------

  PROCEDURE scp_getpermissionbycodeandkey(i_permissioncode IN VARCHAR2 DEFAULT NULL,   i_permissionkey IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT p.permissionid,
      p.permissioncode,
      p.moduledefid,
      p.permissionkey,
      p.permissionname
    FROM {databaseOwner}scp_permission p
    WHERE(p.permissioncode = i_permissioncode OR i_permissioncode IS NULL)
     AND(p.permissionkey = i_permissionkey OR i_permissionkey IS NULL);
  END scp_getpermissionbycodeandkey;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETFOLDERPERMISSIONBYPATH
  --------------------------------------------------------

  PROCEDURE scp_getfolderpermissionbypath(i_portalid IN NUMBER DEFAULT NULL,   i_folderpath IN VARCHAR2 DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR
    SELECT *
    FROM {databaseOwner}scp_vw_folderpermissions
    WHERE((folderpath = i_folderpath
     AND((portalid = i_portalid) OR (i_portalid IS NULL AND portalid IS NULL))) 
     OR ((folderpath IS NULL AND i_folderpath IS NULL) AND permissioncode = 'SYSTEM_FOLDER'))
     AND(permissionid = i_permissionid OR i_permissionid = -1);
     
  END scp_getfolderpermissionbypath;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETROLEGROUPS
  --------------------------------------------------------

  PROCEDURE scp_getrolegroups(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT rolegroupid,
      portalid,
      rolegroupname,
      description
    FROM {databaseOwner}scp_rolegroups
    WHERE portalid = i_portalid;
  END scp_getrolegroups;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSITELOG6
  --------------------------------------------------------

  PROCEDURE scp_getsitelog6(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT to_number(to_char(datetime,   'HH')) HOUR,
      COUNT(*) views,
      COUNT(DISTINCT scp_sitelog.userhostaddress) visitors,
      COUNT(DISTINCT scp_sitelog.userid) users
    FROM {databaseOwner}scp_sitelog
    WHERE portalid = i_portalid
     AND scp_sitelog.datetime BETWEEN i_startdate
     AND i_enddate
    GROUP BY to_number(to_char(datetime,   'HH'))
    ORDER BY HOUR;
  END scp_getsitelog6;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSEARCHSETTINGS
  --------------------------------------------------------

  PROCEDURE scp_getsearchsettings(i_moduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT tm.moduleid,
      settings.settingname,
      settings.settingvalue
    FROM {databaseOwner}scp_tabs searchtabs
    INNER JOIN {databaseOwner}scp_tabmodules searchtabmodules ON searchtabs.tabid = searchtabmodules.tabid
    INNER JOIN {databaseOwner}scp_portals p ON searchtabs.portalid = p.portalid
    INNER JOIN {databaseOwner}scp_tabs t ON p.portalid = t.portalid
    INNER JOIN {databaseOwner}scp_tabmodules tm ON t.tabid = tm.tabid
    INNER JOIN {databaseOwner}scp_modulesettings settings ON searchtabmodules.moduleid = settings.moduleid
    WHERE searchtabs.tabname = 'Search Admin'
     AND tm.moduleid = i_moduleid;
  END scp_getsearchsettings;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETVENDORSBYEMAIL
  --------------------------------------------------------

  PROCEDURE scp_getvendorsbyemail(i_filter IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1) AS
  v_pagelowerbound NUMBER(10,   0);
  v_pageupperbound NUMBER(10,   0);
  BEGIN
    v_pagelowerbound := (i_pagesize * i_pageindex) + 1;
    v_pageupperbound := i_pagesize + v_pagelowerbound - 1;
    
    OPEN o_rc1 FOR    
    SELECT *
    FROM (SELECT vendors.*, ROWNUM rnum 
		FROM (SELECT scp_vendors.*,
		(SELECT COUNT(*) FROM {databaseOwner}scp_banners WHERE scp_banners.vendorid = scp_vendors.vendorid) banners
		FROM {databaseOwner}scp_vendors
		WHERE((email = i_filter)
			AND((portalid = i_portalid) OR (i_portalid IS NULL
			AND portalid IS NULL)))
		ORDER BY vendorid DESC) vendors
		WHERE ROWNUM <= v_pageupperbound)
    WHERE rnum >= v_pagelowerbound;
    
    OPEN o_totalrecords FOR
    SELECT COUNT(*) totalrecords
    FROM {databaseOwner}scp_vendors
	WHERE((email = i_filter)
		AND((portalid = i_portalid) OR (i_portalid IS NULL
		AND portalid IS NULL)));
    
  END scp_getvendorsbyemail;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETROLEGROUP
  --------------------------------------------------------

  PROCEDURE scp_getrolegroup(i_portalid IN NUMBER DEFAULT NULL,   i_rolegroupid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT rolegroupid,
      portalid,
      rolegroupname,
      description
    FROM {databaseOwner}scp_rolegroups
    WHERE(rolegroupid = i_rolegroupid OR rolegroupid IS NULL
     AND i_rolegroupid IS NULL)
     AND portalid = i_portalid;
  END scp_getrolegroup;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSITELOG8
  --------------------------------------------------------

  PROCEDURE scp_getsitelog8(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT to_number(to_char(datetime,   'MM')) MONTH,
      COUNT(*) views,
      COUNT(DISTINCT scp_sitelog.userhostaddress) visitors,
      COUNT(DISTINCT scp_sitelog.userid) users
    FROM {databaseOwner}scp_sitelog
    WHERE portalid = i_portalid
     AND scp_sitelog.datetime BETWEEN i_startdate
     AND i_enddate
    GROUP BY to_number(to_char(datetime,   'MM'))
    ORDER BY MONTH;
  END scp_getsitelog8;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPORTAL
  --------------------------------------------------------

  PROCEDURE scp_getportal(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_portals
    WHERE portalid = i_portalid;
  END scp_getportal;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETFILEBYID
  --------------------------------------------------------

  PROCEDURE scp_getfilebyid(i_fileid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT fileid,
      scp_folders.portalid,
      filename,
      extension,
      size_,
      width,
      height,
      contenttype,
      scp_files.folderid,
      folderpath folder,
      storagelocation,
      iscached
    FROM {databaseOwner}scp_files
    INNER JOIN {databaseOwner}scp_folders ON scp_files.folderid = scp_folders.folderid
    WHERE fileid = i_fileid
     AND((scp_folders.portalid = i_portalid) OR(i_portalid IS NULL
     AND scp_folders.portalid IS NULL));
  END scp_getfilebyid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETFOLDERBYFOLDERPATH
  --------------------------------------------------------

  PROCEDURE scp_getfolderbyfolderpath(i_portalid IN NUMBER DEFAULT NULL,   i_folderpath IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

	OPEN o_rc1 FOR
    SELECT *
    FROM {databaseOwner}scp_folders
    WHERE((portalid = i_portalid) OR(i_portalid IS NULL
     AND portalid IS NULL))
     AND((LOWER(folderpath) = LOWER(i_folderpath)) OR (folderpath IS NULL
      AND i_folderpath IS NULL))
    ORDER BY folderpath;

  END scp_getfolderbyfolderpath;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPERMISSIONSBYTABID
  --------------------------------------------------------

  PROCEDURE scp_getpermissionsbytabid(i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT p.permissionid,
      p.permissioncode,
      p.permissionkey,
      p.moduledefid,
      p.permissionname
    FROM {databaseOwner}scp_permission p
    WHERE p.permissioncode = 'SYSTEM_TAB';
  END scp_getpermissionsbytabid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETUSERSBYACCOUNTNUMBER
  --------------------------------------------------------

  PROCEDURE scp_getusersbyaccountnumber(i_portalid IN NUMBER DEFAULT NULL,   i_accounttomatch IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1) AS
  v_pagelowerbound NUMBER(10,   0);
  v_pageupperbound NUMBER(10,   0);
  BEGIN
    BEGIN
      v_pagelowerbound := (i_pagesize * i_pageindex) + 1;
    v_pageupperbound := i_pagesize + v_pagelowerbound - 1;

      OPEN o_rc1 FOR      
      SELECT *
      FROM (SELECT a.*, ROWNUM rnum 
      FROM (SELECT *
      FROM {databaseOwner}scp_vw_users
      WHERE LOWER(accountnumber) LIKE LOWER({databaseOwner}scpuke_pkg.FORMATSQL(i_accounttomatch)) ESCAPE '\'
       AND(portalid = i_portalid OR (i_portalid IS NULL AND portalid IS NULL))
      ORDER BY accountnumber, username) a
      WHERE ROWNUM <= v_pageupperbound)
      WHERE rnum >= v_pagelowerbound;
      
      OPEN o_totalrecords FOR
      SELECT COUNT(*) TotalRecords
      FROM {databaseOwner}scp_vw_users
      WHERE LOWER(accountnumber) LIKE LOWER({databaseOwner}scpuke_pkg.FORMATSQL(i_accounttomatch)) ESCAPE '\'
       AND(portalid = i_portalid OR (i_portalid IS NULL AND portalid IS NULL));
      
    END;
  END scp_getusersbyaccountnumber;
  
  --------------------------------------------------------
  --  DDL for Procedure SCP_GETUSERSBYUSERNAME
  --------------------------------------------------------

  PROCEDURE scp_getusersbyusername(i_portalid IN NUMBER DEFAULT NULL,   i_usernametomatch IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1) AS
  v_pagelowerbound NUMBER(10,   0);
  v_pageupperbound NUMBER(10,   0);
  BEGIN
    BEGIN
      v_pagelowerbound := (i_pagesize * i_pageindex) + 1;
    v_pageupperbound := i_pagesize + v_pagelowerbound - 1;

      OPEN o_rc1 FOR
      SELECT *
      FROM (SELECT a.*, ROWNUM rnum 
      FROM (SELECT *
      FROM {databaseOwner}scp_vw_users
      WHERE LOWER(username) LIKE LOWER({databaseOwner}scpuke_pkg.FORMATSQL(i_usernametomatch)) ESCAPE '\'
       AND(portalid = i_portalid OR (i_portalid IS NULL AND portalid IS NULL))
      ORDER BY accountnumber, username) a
      WHERE ROWNUM <= v_pageupperbound)
      WHERE rnum >= v_pagelowerbound;
      
      OPEN o_totalrecords FOR
      SELECT COUNT(*) TotalRecords
      FROM {databaseOwner}scp_vw_users
      WHERE LOWER(username) LIKE LOWER({databaseOwner}scpuke_pkg.FORMATSQL(i_usernametomatch)) ESCAPE '\'
       AND(portalid = i_portalid OR (i_portalid IS NULL AND portalid IS NULL));
      
    END;
  END scp_getusersbyusername;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETEVENTLOGCONFIG
  --------------------------------------------------------

  PROCEDURE scp_geteventlogconfig(i_id IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_eventlogconfig
    WHERE(id = i_id OR i_id IS NULL);
  END scp_geteventlogconfig;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULEDEFINITIONBYNAME
  --------------------------------------------------------

  PROCEDURE scp_getmoduledefinitionbyname(i_desktopmoduleid IN NUMBER DEFAULT NULL,   i_friendlyname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR
    SELECT *
    FROM {databaseOwner}scp_moduledefinitions
    WHERE desktopmoduleid = i_desktopmoduleid
     AND friendlyname = i_friendlyname;
     
  END scp_getmoduledefinitionbyname;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETUSERSBYPROFILEPROPERTY
  --------------------------------------------------------

  PROCEDURE scp_getusersbyprofileproperty(i_portalid IN NUMBER DEFAULT NULL,   i_propertyname IN nvarchar2 DEFAULT NULL,   i_propertyvalue IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1) AS
  v_pagelowerbound NUMBER(10,   0);
  v_pageupperbound NUMBER(10,   0);
  BEGIN
  
      v_pagelowerbound := (i_pagesize * i_pageindex) + 1;
    v_pageupperbound := i_pagesize + v_pagelowerbound - 1;

      OPEN o_rc1 FOR
      SELECT *
      FROM (SELECT a.*, ROWNUM rnum 
      FROM (SELECT vu.* FROM {databaseOwner}scp_vw_users vu
      INNER JOIN {databaseOwner}scp_userprofile up ON vu.userid = up.userid
      INNER JOIN {databaseOwner}scp_profilepropertydefinition p ON up.propertydefinitionid = p.propertydefinitionid
      INNER JOIN {databaseOwner}scp_users u ON up.userid = u.userid
      INNER JOIN {databaseOwner}scp_accountnumbers an ON u.accountid = an.accountid
      WHERE(propertyname = i_propertyname)
       AND(LOWER(propertyvalue) LIKE LOWER({databaseOwner}scpuke_pkg.FORMATSQL(i_propertyvalue)) ESCAPE '\' OR LOWER(propertytext) LIKE LOWER({databaseOwner}scpuke_pkg.FORMATSQL(i_propertyvalue)) ESCAPE '\')
       AND(p.portalid = i_portalid OR(p.portalid IS NULL
       AND i_portalid IS NULL))
      ORDER BY an.accountnumber, u.username) a
      WHERE ROWNUM <= v_pageupperbound)
      WHERE rnum >= v_pagelowerbound;      

      OPEN o_totalrecords FOR
      SELECT COUNT(*) TotalRecords
      FROM {databaseOwner}scp_profilepropertydefinition p
      INNER JOIN {databaseOwner}scp_userprofile up ON p.propertydefinitionid = up.propertydefinitionid
      INNER JOIN {databaseOwner}scp_users u ON up.userid = u.userid
      WHERE(propertyname = i_propertyname)
       AND(LOWER(propertyvalue) LIKE LOWER({databaseOwner}scpuke_pkg.FORMATSQL(i_propertyvalue)) ESCAPE '\' OR LOWER(propertytext) LIKE LOWER({databaseOwner}scpuke_pkg.FORMATSQL(i_propertyvalue)) ESCAPE '\')
       AND(p.portalid = i_portalid OR(p.portalid IS NULL
       AND i_portalid IS NULL));
      
  END scp_getusersbyprofileproperty;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETURL
  --------------------------------------------------------

  PROCEDURE scp_geturl(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_urls
    WHERE portalid = i_portalid
     AND url = i_url;
  END scp_geturl;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETTABMODULESETTINGS
  --------------------------------------------------------

  PROCEDURE scp_gettabmodulesettings(i_tabmoduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT settingname,
      settingvalue
    FROM {databaseOwner}scp_tabmodulesettings
    WHERE tabmoduleid = i_tabmoduleid;
  END scp_gettabmodulesettings;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULECONTROLS
  --------------------------------------------------------

  PROCEDURE scp_getmodulecontrols(i_moduledefid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_modulecontrols
    WHERE(i_moduledefid IS NULL
     AND moduledefid IS NULL) OR(moduledefid = i_moduledefid)
    ORDER BY controlkey,
      vieworder;
  END scp_getmodulecontrols;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPROPERTYDEFINITION
  --------------------------------------------------------

  PROCEDURE scp_getpropertydefinition(i_propertydefinitionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_profilepropertydefinition
    WHERE propertydefinitionid = i_propertydefinitionid
     AND deleted = 0;
  END scp_getpropertydefinition;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETVENDORCLASSIFICATIONS
  --------------------------------------------------------

  PROCEDURE scp_getvendorclassifications(i_vendorid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT classificationid,
      classificationname,
      CASE
    WHEN EXISTS
      (SELECT 1
       FROM {databaseOwner}scp_vendorclassification vc
       WHERE vc.vendorid = i_vendorid
       AND vc.classificationid = scp_classification.classificationid)
    THEN
      1
    ELSE
      0
    END isassociated
    FROM {databaseOwner}scp_classification;
  END scp_getvendorclassifications;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETEXPIREDPORTALS
  --------------------------------------------------------

  PROCEDURE scp_getexpiredportals(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_portals
    WHERE expirydate < sysdate;
  END scp_getexpiredportals;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSKINS
  --------------------------------------------------------

  PROCEDURE scp_getskins(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_skins
    WHERE(portalid = i_portalid) OR(i_portalid IS NULL
     AND portalid IS NULL);
  END scp_getskins;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSEARCHRESULTS
  --------------------------------------------------------

  PROCEDURE scp_getsearchresults(i_portalid IN NUMBER DEFAULT NULL,   i_word IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
	v_word NVARCHAR2(50);
  BEGIN
	
	v_word := REPLACE(i_word, '*', '%');
	
    OPEN o_rc1 FOR
    SELECT si.searchitemid,
      sw.word,
      siw.occurrences,
      siw.occurrences + 1000 relevance,
      m.moduleid,
      tm.tabid,
      si.title,
      si.description,
      si.author,
      si.pubdate,
      si.searchkey,
      si.guid,
      si.imagefileid,
      u.firstname || ' ' || u.lastname authorname,
      m.portalid
    FROM {databaseOwner}scp_searchword sw
    INNER JOIN {databaseOwner}scp_searchitemword siw ON sw.searchwordsid = siw.searchwordsid
    INNER JOIN {databaseOwner}scp_searchitem si ON siw.searchitemid = si.searchitemid
    INNER JOIN {databaseOwner}scp_modules m ON si.moduleid = m.moduleid LEFT JOIN {databaseOwner}scp_tabmodules tm ON si.moduleid = tm.moduleid
    INNER JOIN {databaseOwner}scp_tabs t ON tm.tabid = t.tabid LEFT JOIN {databaseOwner}scp_users u ON si.author = u.userid
    WHERE(((m.startdate IS NULL) OR(sysdate > m.startdate))
     AND((m.enddate IS NULL) OR(sysdate < m.enddate)))
     AND(((t.startdate IS NULL) OR(sysdate > t.startdate))
     AND((t.enddate IS NULL) OR(sysdate < t.enddate)))
     AND(sw.word LIKE {databaseOwner}scpuke_pkg.FORMATSQL(v_word) ESCAPE '\')
     AND(t.isdeleted = 0)
     AND(m.isdeleted = 0)
     AND(t.portalid = i_portalid)
    ORDER BY relevance DESC;
    
  END scp_getsearchresults;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETLIST
  --------------------------------------------------------

  PROCEDURE scp_getlist(i_listname IN nvarchar2 DEFAULT NULL,   i_parentkey IN nvarchar2 DEFAULT NULL,   i_definitionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
  v_parentlistname nvarchar2(50);
  v_parentvalue nvarchar2(100);
  BEGIN

    IF i_parentkey IS NULL THEN
      BEGIN

        OPEN o_rc1 FOR

        SELECT DISTINCT e.listname,
          e.level_,
          e.definitionid,
          e.parentid,
            (SELECT MAX(sortorder)
           FROM {databaseOwner}scp_lists
           WHERE listname = e.listname)
        maxsortorder,
            (SELECT COUNT(entryid)
           FROM {databaseOwner}scp_lists
           WHERE listname = e.listname
           AND parentid = e.parentid)
        entrycount,
          nvl(
          (SELECT listname || '.' || VALUE || ':'
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        + e.listname KEY,
          nvl(
          (SELECT listname || '.' || text || ':'
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        + e.listname displayname,
          nvl(
          (SELECT listname || '.' || VALUE
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        parentkey,
          nvl(
          (SELECT listname || '.' || text
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        parent,
          nvl(
          (SELECT listname
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        parentlist
        FROM {databaseOwner}scp_lists e
        WHERE(listname = i_listname OR i_listname IS NULL)
         AND(definitionid = i_definitionid OR i_definitionid = -1)
        ORDER BY e.level_,
          displayname;
      END;
    ELSE
      BEGIN
        v_parentlistname := SUBSTR(i_parentkey,   1,   instr(i_parentkey,   '.') -1);
        v_parentvalue := SUBSTR(i_parentkey,   LENGTH(i_parentkey) -instr(i_parentkey,   '.'));

        OPEN o_rc1 FOR

        SELECT DISTINCT e.listname,
          e.level_,
          e.definitionid,
          e.parentid,
            (SELECT MAX(sortorder)
           FROM {databaseOwner}scp_lists
           WHERE listname = e.listname)
        maxsortorder,
            (SELECT COUNT(entryid)
           FROM {databaseOwner}scp_lists
           WHERE listname = e.listname
           AND parentid = e.parentid)
        entrycount,
          nvl(
          (SELECT listname || '.' || VALUE || ':'
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        + e.listname KEY,
          nvl(
          (SELECT listname || '.' || text || ':'
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        + e.listname displayname,
          nvl(
          (SELECT listname || '.' || VALUE
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        parentkey,
          nvl(
          (SELECT listname || '.' || text
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        parent,
          nvl(
          (SELECT listname
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        parentlist
        FROM {databaseOwner}scp_lists e
        WHERE listname = listname
         AND parentid =
          (SELECT entryid
           FROM {databaseOwner}scp_lists
           WHERE listname = v_parentlistname
           AND VALUE = v_parentvalue)
        ORDER BY e.level_,
          displayname;
      END;
    END IF;

  END scp_getlist;
  
  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSEARCHMODULES
  --------------------------------------------------------
  
  PROCEDURE scp_getsearchmodules ( i_PortalID in number,  o_rc1 OUT {databaseOwner}global_pkg.rct1) AS 
  BEGIN 
    OPEN o_rc1 FOR
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
       case when F.FileName is null then TM.IconFile else F.Folder || F.FileName end as IconFile, 
       DM.*, 
       MC.ModuleControlId, 
       MC.ControlSrc, 
       MC.ControlType, 
       MC.ControlTitle, 
       MC.HelpURL 
    FROM {databaseOwner}scp_Modules M 
	INNER JOIN {databaseOwner}scp_TabModules TM ON M.ModuleId = TM.ModuleId 
	INNER JOIN {databaseOwner}scp_Tabs T ON TM.TabId = T.TabId 
	INNER JOIN {databaseOwner}scp_ModuleDefinitions MD ON M.ModuleDefId = MD.ModuleDefId 
	INNER JOIN {databaseOwner}scp_DesktopModules DM ON MD.DesktopModuleId = DM.DesktopModuleId 
	INNER JOIN {databaseOwner}scp_ModuleControls MC ON MD.ModuleDefId = MC.ModuleDefId 
	LEFT OUTER JOIN {databaseOwner}scp_Files F ON TM.IconFile = 'FileID=' || F.FileID 
    WHERE  M.IsDeleted = 0   
	AND T.IsDeleted = 0   
	AND ControlKey is null  
	AND DM.IsAdmin = 0 
	AND (bitand(DM.SupportedFeatures , 2) = 2) 
	AND (T.EndDate > sysdate or T.EndDate IS NULL)  
	AND (T.StartDate <= sysdate or T.StartDate IS NULL)  
	AND (M.StartDate <= sysdate or M.StartDate IS NULL)  
	AND (M.EndDate > sysdate or M.EndDate IS NULL)  
	AND (NOT (DM.BusinessControllerClass IS NULL)) 
	AND (T.PortalID = i_PortalID OR (T.PortalID IS NULL AND i_PortalID Is NULL)) 
    ORDER BY TM.ModuleOrder;
  
  END scp_getsearchmodules;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSEARCHRESULTMODULES
  --------------------------------------------------------

  PROCEDURE scp_getsearchresultmodules(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT tm.tabid,
      t.tabname searchtabname
    FROM {databaseOwner}scp_modules m
    INNER JOIN {databaseOwner}scp_moduledefinitions md ON md.moduledefid = m.moduledefid
    INNER JOIN {databaseOwner}scp_tabmodules tm ON tm.moduleid = m.moduleid
    INNER JOIN {databaseOwner}scp_tabs t ON t.tabid = tm.tabid
    WHERE md.friendlyname = 'Search Results'
     AND t.portalid = i_portalid
     AND t.isdeleted = 0;
  END scp_getsearchresultmodules;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSITELOG7
  --------------------------------------------------------

  PROCEDURE scp_getsitelog7(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT to_number(to_char(datetime,   'D')) weekday,
      COUNT(*) views,
      COUNT(DISTINCT scp_sitelog.userhostaddress) visitors,
      COUNT(DISTINCT scp_sitelog.userid) users
    FROM {databaseOwner}scp_sitelog
    WHERE portalid = i_portalid
     AND scp_sitelog.datetime BETWEEN i_startdate
     AND i_enddate
    GROUP BY to_number(to_char(datetime,   'D'))
    ORDER BY weekday;
  END scp_getsitelog7;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSEARCHITEMWORDBYITEM
  --------------------------------------------------------

  PROCEDURE scp_getsearchitemwordbyitem(i_searchitemid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT searchitemwordid,
      searchitemid,
      searchwordsid,
      occurrences
    FROM {databaseOwner}scp_searchitemword
    WHERE searchitemid = i_searchitemid;
  END scp_getsearchitemwordbyitem;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETTAB
  --------------------------------------------------------

  PROCEDURE scp_gettab(i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_tabs
    WHERE tabid = i_tabid;
  END scp_gettab;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPORTALBYPORTALALIASID
  --------------------------------------------------------

  PROCEDURE scp_getportalbyportalaliasid(i_portalaliasid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT p.*
    FROM {databaseOwner}scp_vw_portals p
    INNER JOIN {databaseOwner}scp_portalalias pa ON p.portalid = pa.portalid
    WHERE pa.portalaliasid = i_portalaliasid;
  END scp_getportalbyportalaliasid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETONLINEUSER
  --------------------------------------------------------

  PROCEDURE scp_getonlineuser(i_userid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT scp_usersonline.userid,
      scp_users.username
    FROM {databaseOwner}scp_usersonline
    INNER JOIN {databaseOwner}scp_users ON scp_usersonline.userid = scp_users.userid
    WHERE scp_usersonline.userid = i_userid;
  END scp_getonlineuser;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPORTALBYALIAS
  --------------------------------------------------------

  PROCEDURE scp_getportalbyalias(i_httpalias IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT MIN(portalid) portalid
    FROM {databaseOwner}scp_portalalias
    WHERE httpalias = i_httpalias;
  END scp_getportalbyalias;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSEARCHITEMWORDWORDID
  --------------------------------------------------------

  PROCEDURE scp_getsearchitemwordwordid(i_searchitemwordid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT searchitemwordpositionid,
      searchitemwordid,
      contentposition
    FROM {databaseOwner}scp_searchitemwordposition
    WHERE searchitemwordid = i_searchitemwordid;
  END scp_getsearchitemwordwordid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPORTALALIASBYALIASID
  --------------------------------------------------------

  PROCEDURE scp_getportalaliasbyaliasid(i_portalaliasid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_portalalias
    WHERE portalaliasid = i_portalaliasid;
  END scp_getportalaliasbyaliasid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETALLMODULES
  --------------------------------------------------------

  PROCEDURE scp_getallmodules(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_modules;
  END scp_getallmodules;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETROLESBYGROUP
  --------------------------------------------------------

  PROCEDURE scp_getrolesbygroup(i_rolegroupid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT r.roleid,
      r.portalid,
      r.rolegroupid,
      r.rolename,
      r.description,
      CASE
    WHEN ROUND(to_number(r.servicefee),   0) <> 0 THEN
      r.servicefee
    ELSE
      NULL
    END servicefee,
      CASE
    WHEN ROUND(to_number(r.servicefee),   0) <> 0 THEN
      r.billingperiod
    ELSE
      NULL
    END billingperiod,
      CASE
    WHEN ROUND(to_number(r.servicefee),   0) <> 0 THEN
      l1.text
    ELSE
      NULL
    END billingfrequency,
      CASE
    WHEN r.trialfrequency <> 'N' THEN
      r.trialfee
    ELSE
      NULL
    END trialfee,
      CASE
    WHEN r.trialfrequency <> 'N' THEN
      r.trialperiod
    ELSE
      NULL
    END trialperiod,
      CASE
    WHEN r.trialfrequency <> 'N' THEN
      l2.text
    ELSE
      NULL
    END trialfrequency,
      CASE
    WHEN r.ispublic = 1 THEN
      'True'
    ELSE
      'False'
    END ispublic,
      CASE
    WHEN r.autoassignment = 1 THEN
      'True'
    ELSE
      'False'
    END autoassignment,
      r.rsvpcode,
      r.iconfile
    FROM {databaseOwner}scp_roles r LEFT JOIN {databaseOwner}scp_lists l1 ON r.billingfrequency = l1.VALUE LEFT JOIN {databaseOwner}scp_lists l2 ON r.trialfrequency = l2.VALUE
    WHERE(rolegroupid = i_rolegroupid OR(i_rolegroupid IS NULL
     AND rolegroupid IS NULL))
     AND portalid = i_portalid
    ORDER BY r.rolename;
  END scp_getrolesbygroup;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETTABPANES
  --------------------------------------------------------

  PROCEDURE scp_gettabpanes(i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT DISTINCT(panename) panename
    FROM {databaseOwner}scp_tabmodules
    WHERE tabid = i_tabid
    ORDER BY panename;
  END scp_gettabpanes;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETROLEBYNAME
  --------------------------------------------------------

  PROCEDURE scp_getrolebyname(i_portalid IN NUMBER DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT roleid,
      portalid,
      rolegroupid,
      rolename,
      description,
      servicefee,
      billingperiod,
      billingfrequency,
      trialfee,
      trialperiod,
      trialfrequency,
      ispublic,
      autoassignment,
      rsvpcode,
      iconfile
    FROM {databaseOwner}scp_roles
    WHERE portalid = i_portalid
     AND rolename = i_rolename;
  END scp_getrolebyname;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETDEFAULTLANGUAGEBYMOD
  --------------------------------------------------------

  PROCEDURE scp_getdefaultlanguagebymod(i_modulelist IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
  v_modulelist VARCHAR2(50);
  BEGIN
    BEGIN
    
      v_modulelist := TRIM(i_modulelist);
      
      OPEN o_rc1 FOR
      SELECT DISTINCT m.moduleid, p.defaultlanguage
      FROM {databaseOwner}scp_modules m INNER JOIN {databaseOwner}scp_portals p ON p.portalid = m.portalid
      WHERE m.moduleid IN (v_modulelist) ORDER BY m.moduleid;
      
    END;
  END scp_getdefaultlanguagebymod;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETHOSTSETTINGS
  --------------------------------------------------------

  PROCEDURE scp_gethostsettings(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT settingname,
      settingvalue,
      settingissecure
    FROM {databaseOwner}scp_hostsettings;
  END scp_gethostsettings;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETEVENTLOGBYLOGGUID
  --------------------------------------------------------

  PROCEDURE scp_geteventlogbylogguid(i_logguid IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR
    SELECT *
    FROM {databaseOwner}scp_eventlog
    WHERE(logguid = i_logguid);
    
  END scp_geteventlogbylogguid;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETDESKTOPMODULES
  --------------------------------------------------------

  PROCEDURE scp_getdesktopmodules(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_desktopmodules
    WHERE isadmin = 0
    ORDER BY friendlyname;
  END scp_getdesktopmodules;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETURLLOG
  --------------------------------------------------------

  PROCEDURE scp_geturllog(i_urltrackingid IN NUMBER DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT scp_urllog.*,
      scp_users.firstname || ' ' || scp_users.lastname fullname
    FROM {databaseOwner}scp_urllog
    INNER JOIN {databaseOwner}scp_urltracking ON scp_urllog.urltrackingid = scp_urltracking.urltrackingid LEFT JOIN {databaseOwner}scp_users ON scp_urllog.userid = scp_users.userid
    WHERE scp_urllog.urltrackingid = i_urltrackingid
     AND((clickdate >= i_startdate) OR i_startdate IS NULL)
     AND((clickdate <= i_enddate) OR i_enddate IS NULL)
    ORDER BY clickdate;
  END scp_geturllog;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSCHEDULENEXTTASK
  --------------------------------------------------------

  PROCEDURE scp_getschedulenexttask(i_server IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
  BEGIN

    OPEN o_rc1 FOR
    SELECT *
    FROM
      (SELECT s.scheduleid,
         s.typefullname,
         s.timelapse,
         s.timelapsemeasurement,
         s.retrytimelapse,
         s.retrytimelapsemeasurement,
         s.objectdependencies,
         s.attachtoevent,
         s.retainhistorynum,
         s.catchupenabled,
         s.enabled,
         sh.nextstart
       FROM {databaseOwner}scp_schedule s LEFT JOIN {databaseOwner}scp_schedulehistory sh ON s.scheduleid = sh.scheduleid
       WHERE(((sh.schedulehistoryid,    1) IN
        (SELECT s1.schedulehistoryid,    row_number() over(
         ORDER BY s1.nextstart DESC)
         FROM {databaseOwner}scp_schedulehistory s1
         WHERE s1.scheduleid = s.scheduleid) OR sh.schedulehistoryid IS NULL)
         AND s.enabled = 1)
      AND(s.servers LIKE ',%' || {databaseOwner}scpuke_pkg.FORMATSQL(i_server) || '%,' ESCAPE '\' OR s.servers IS NULL)
       GROUP BY s.scheduleid,
         s.typefullname,
         s.timelapse,
         s.timelapsemeasurement,
         s.retrytimelapse,
         s.retrytimelapsemeasurement,
         s.objectdependencies,
         s.attachtoevent,
         s.retainhistorynum,
         s.catchupenabled,
         s.enabled,
         sh.nextstart
       ORDER BY sh.nextstart ASC)
    WHERE rownum <= 1;
  END scp_getschedulenexttask;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETUSERBYUSERNAME
  --------------------------------------------------------

  PROCEDURE scp_getuserbyusername(i_portalid IN NUMBER DEFAULT NULL, i_accountnumber IN varchar2,   i_username IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR
    SELECT *
    FROM {databaseOwner}scp_vw_users
    WHERE LOWER(accountnumber) = LOWER(i_accountnumber)
     AND LOWER(username) = LOWER(i_username)
     AND(portalid = i_portalid OR issuperuser = 1 OR i_portalid IS NULL);
     
  END scp_getuserbyusername;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETUSERROLES
  --------------------------------------------------------

  PROCEDURE scp_getuserroles(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT ur.userroleid,
      u.userid,
      u.displayname,
      u.email,
      ur.effectivedate,
      ur.expirydate,
      ur.istrialused
    FROM {databaseOwner}scp_userroles ur
    INNER JOIN {databaseOwner}scp_users u ON ur.userid = u.userid
    INNER JOIN {databaseOwner}scp_roles r ON ur.roleid = r.roleid
    WHERE u.userid = i_userid
     AND r.portalid = i_portalid;
  END scp_getuserroles;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETDATABASEVERSION
  --------------------------------------------------------

  PROCEDURE scp_getdatabaseversion(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT major,
      minor,
      build
    FROM {databaseOwner}scp_version
    WHERE versionid =
      (SELECT MAX(versionid)
       FROM {databaseOwner}scp_version)
    ;
  END scp_getdatabaseversion;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSKIN
  --------------------------------------------------------

  PROCEDURE scp_getskin(i_skinroot IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_skintype IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_skins
    WHERE skinroot = i_skinroot
     AND skintype = i_skintype
     AND(i_portalid IS NULL OR portalid = i_portalid)
    ORDER BY portalid DESC;
  END scp_getskin;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSITELOG2
  --------------------------------------------------------

  PROCEDURE scp_getsitelog2(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
  BEGIN

    OPEN o_rc1 FOR

    SELECT scp_sitelog.datetime,
      CASE
    WHEN scp_sitelog.userid IS NULL THEN
      NULL
    ELSE
      scp_users.firstname || ' ' || scp_users.lastname
    END name,
      CASE
    WHEN scp_sitelog.referrer LIKE '%' || {databaseOwner}scpuke_pkg.FORMATSQL(i_portalalias) || '%' ESCAPE '\' THEN
      NULL
    ELSE
      scp_sitelog.referrer
    END referrer,
      CASE
    WHEN scp_sitelog.useragent LIKE '%MSIE 1%' THEN
      'Internet Explorer 1'
    WHEN scp_sitelog.useragent LIKE '%MSIE 2%' THEN
      'Internet Explorer 2'
    WHEN scp_sitelog.useragent LIKE '%MSIE 3%' THEN
      'Internet Explorer 3'
    WHEN scp_sitelog.useragent LIKE '%MSIE 4%' THEN
      'Internet Explorer 4'
    WHEN scp_sitelog.useragent LIKE '%MSIE 5%' THEN
      'Internet Explorer 5'
    WHEN scp_sitelog.useragent LIKE '%MSIE 6%' THEN
      'Internet Explorer 6'
    WHEN scp_sitelog.useragent LIKE '%MSIE%' THEN
      'Internet Explorer'
    WHEN scp_sitelog.useragent LIKE '%Mozilla1%' THEN
      'Netscape Navigator 1'
    WHEN scp_sitelog.useragent LIKE '%Mozilla2%' THEN
      'Netscape Navigator 2'
    WHEN scp_sitelog.useragent LIKE '%Mozilla3%' THEN
      'Netscape Navigator 3'
    WHEN scp_sitelog.useragent LIKE '%Mozilla4%' THEN
      'Netscape Navigator 4'
    WHEN scp_sitelog.useragent LIKE '%Mozilla5%' THEN
      'Netscape Navigator 6+'
    ELSE
      to_char(scp_sitelog.useragent)
    END useragent,
      scp_sitelog.userhostaddress,
      scp_tabs.tabname
    FROM {databaseOwner}scp_sitelog LEFT JOIN {databaseOwner}scp_users ON scp_sitelog.userid = scp_users.userid LEFT JOIN {databaseOwner}scp_tabs ON scp_sitelog.tabid = scp_tabs.tabid
    WHERE scp_sitelog.portalid = i_portalid
     AND scp_sitelog.datetime BETWEEN i_startdate
     AND i_enddate
    ORDER BY scp_sitelog.datetime DESC;
  END scp_getsitelog2;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETEVENTLOG
  --------------------------------------------------------

  PROCEDURE scp_geteventlog(i_portalid IN NUMBER DEFAULT NULL,   i_logtypekey IN nvarchar2 DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1) AS
  v_pagelowerbound NUMBER(10,   0);
  v_pageupperbound NUMBER(10,   0);
  BEGIN
    v_pagelowerbound := (i_pagesize * i_pageindex) + 1;
    v_pageupperbound := i_pagesize + v_pagelowerbound - 1;
    
    OPEN o_rc1 FOR
    SELECT *
    FROM (SELECT a.*, ROWNUM rnum 
    FROM (SELECT scp_eventlog.*
    FROM {databaseOwner}scp_eventlog
    INNER JOIN {databaseOwner}scp_eventlogconfig ON scp_eventlog.logconfigid = scp_eventlogconfig.id
    WHERE(logportalid = i_portalid OR i_portalid IS NULL)
     AND(scp_eventlog.logtypekey = i_logtypekey OR i_logtypekey IS NULL)
    ORDER BY logcreatedate DESC) a
    WHERE ROWNUM <= v_pageupperbound)
    WHERE rnum >= v_pagelowerbound;
    
    OPEN o_totalrecords FOR
    SELECT COUNT(*) TotalRecords
    FROM {databaseOwner}scp_eventlog
    INNER JOIN {databaseOwner}scp_eventlogconfig ON scp_eventlog.logconfigid = scp_eventlogconfig.id
    WHERE(logportalid = i_portalid OR i_portalid IS NULL)
     AND(scp_eventlog.logtypekey = i_logtypekey OR i_logtypekey IS NULL);
    
  END scp_geteventlog;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETLISTENTRIES
  --------------------------------------------------------

  PROCEDURE scp_getlistentries(i_listname IN nvarchar2 DEFAULT NULL,   i_parentkey IN nvarchar2 DEFAULT NULL,   i_entryid IN NUMBER DEFAULT NULL,   i_definitionid IN NUMBER DEFAULT NULL,   i_value IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
  v_parentlistname nvarchar2(50);
  v_parentvalue nvarchar2(100);
  BEGIN

    IF i_parentkey IS NULL THEN
      BEGIN

        OPEN o_rc1 FOR

        SELECT e.entryid,
          e.listname,
          e.value,
          e.text,
          e.level_,
          e.sortorder,
          e.definitionid,
          e.parentid,
          e.description,
          e.listname || '.' || e.value KEY,
          e.listname || '.' || e.text displayname,
          nvl(
          (SELECT listname || '.' || VALUE
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        parentkey,
          nvl(
          (SELECT listname || '.' || text
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        parent,
          nvl(
          (SELECT listname
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        parentlist,
            (SELECT COUNT(DISTINCT parentid)
           FROM {databaseOwner}scp_lists
           WHERE parentid = e.entryid)
        haschildren
        FROM {databaseOwner}scp_lists e
        WHERE(e.listname = i_listname OR i_listname IS NULL)
         AND(e.definitionid = i_definitionid OR i_definitionid = -1)
         AND(e.entryid = i_entryid OR i_entryid = -1)
         AND(e.VALUE = i_value OR i_value IS NULL)
        ORDER BY e.level_,
          e.listname,
          e.sortorder,
          e.text;
      END;
    ELSE
      BEGIN
        v_parentlistname := SUBSTR(i_parentkey,   1,   instr(i_parentkey,   '.') -1);
        v_parentvalue := SUBSTR(i_parentkey,   LENGTH(i_parentkey) -instr(i_parentkey,   '.'));

        OPEN o_rc1 FOR

        SELECT e.entryid,
          e.listname,
          e.VALUE,
          e.text,
          e.level_,
          e.sortorder,
          e.definitionid,
          e.parentid,
          e.description,
          e.listname || '.' || e.VALUE KEY,
          e.listname || '.' || e.text displayname,
          nvl(
          (SELECT listname || '.' || VALUE
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        parentkey,
          nvl(
          (SELECT listname || '.' || text
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        parent,
          nvl(
          (SELECT listname
           FROM {databaseOwner}scp_lists
           WHERE entryid = e.parentid),
             ' ')
        parentlist,
            (SELECT COUNT(DISTINCT parentid)
           FROM {databaseOwner}scp_lists
           WHERE parentid = e.entryid)
        haschildren
        FROM {databaseOwner}scp_lists e
        WHERE listname = i_listname
         AND(e.definitionid = i_definitionid OR i_definitionid = -1)
         AND(e.entryid = i_entryid OR i_entryid = -1)
         AND(e.VALUE = i_value OR i_value IS NULL)
         AND parentid =
          (SELECT entryid
           FROM {databaseOwner}scp_lists
           WHERE listname = v_parentlistname
           AND VALUE = v_parentvalue)
        ORDER BY e.level_,
          e.listname,
          e.sortorder,
          e.text;
      END;
    END IF;

  END scp_getlistentries;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETUSERPROFILE
  --------------------------------------------------------

  PROCEDURE scp_getuserprofile(i_userid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT profileid,
      userid,
      propertydefinitionid,
      CASE
    WHEN(propertyvalue IS NULL) THEN
      propertytext
    ELSE
      to_nclob(propertyvalue)
    END propertyvalue,
      visibility,
      lastupdateddate
    FROM {databaseOwner}scp_userprofile
    WHERE userid = i_userid;
  END scp_getuserprofile;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULEPERMISSION
  --------------------------------------------------------

  PROCEDURE scp_getmodulepermission(i_modulepermissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_modulepermissions
    WHERE modulepermissionid = i_modulepermissionid;
  END scp_getmodulepermission;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETTABMODULEORDER
  --------------------------------------------------------

  PROCEDURE scp_gettabmoduleorder(i_tabid IN NUMBER DEFAULT NULL,   i_panename IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_tabmodules
    WHERE tabid = i_tabid
     AND panename = i_panename
    ORDER BY moduleorder;
  END scp_gettabmoduleorder;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETVENDORSBYNAME
  --------------------------------------------------------

  PROCEDURE scp_getvendorsbyname(i_filter IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1) AS
  v_pagelowerbound NUMBER(10,   0);
  v_pageupperbound NUMBER(10,   0);
  BEGIN
  
    v_pagelowerbound := (i_pagesize * i_pageindex) + 1;
    v_pageupperbound := i_pagesize + v_pagelowerbound - 1;
    
    OPEN o_rc1 FOR
    SELECT *
    FROM (SELECT vendors.*, ROWNUM rnum 
    FROM (SELECT scp_vendors.*,
    (SELECT COUNT(*) FROM {databaseOwner}scp_banners WHERE scp_banners.vendorid = scp_vendors.vendorid) banners
    FROM {databaseOwner}scp_vendors
    WHERE((vendorname LIKE {databaseOwner}scpuke_pkg.FORMATSQL(i_filter) || '%' ESCAPE '\')
     AND((portalid = i_portalid) OR(i_portalid IS NULL
     AND portalid IS NULL)))
    ORDER BY vendorid DESC) vendors
    WHERE ROWNUM <= v_pageupperbound)
    WHERE rnum >= v_pagelowerbound;
    
    OPEN o_totalrecords FOR
    SELECT COUNT(*) TotalRecords
    FROM {databaseOwner}scp_vendors
    WHERE((vendorname LIKE {databaseOwner}scpuke_pkg.FORMATSQL(i_filter) || '%' ESCAPE '\')
     AND((portalid = i_portalid) OR(i_portalid IS NULL
     AND portalid IS NULL)));
     
  END scp_getvendorsbyname;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETURLS
  --------------------------------------------------------

  PROCEDURE scp_geturls(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_urls
    WHERE portalid = i_portalid
    ORDER BY url;
  END scp_geturls;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETALLTABSMODULES
  --------------------------------------------------------

  PROCEDURE scp_getalltabsmodules(i_portalid IN NUMBER DEFAULT NULL,   i_alltabs IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_modules m
    WHERE m.portalid = i_portalid
     AND m.alltabs = i_alltabs
     AND m.tabmoduleid =
      (SELECT MIN(tabmoduleid)
       FROM {databaseOwner}scp_tabmodules
       WHERE moduleid = m.moduleid)
    ORDER BY m.moduleid;
  END scp_getalltabsmodules;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPROFILE
  --------------------------------------------------------

  PROCEDURE scp_getprofile(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_profile
    WHERE userid = i_userid
     AND portalid = i_portalid;
  END scp_getprofile;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETFOLDERSBYUSER
  --------------------------------------------------------

  PROCEDURE scp_getfoldersbyuser(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   i_includesecure IN NUMBER DEFAULT NULL,   i_includedatabase IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL,   i_permissionkeys IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT DISTINCT f.folderid,
      f.portalid,
      f.folderpath,
      f.storagelocation,
      f.isprotected,
      f.iscached,
      f.lastupdated
    FROM {databaseOwner}scp_roles r
    INNER JOIN {databaseOwner}scp_userroles ur ON r.roleid = ur.roleid RIGHT JOIN {databaseOwner}scp_folders f
    INNER JOIN {databaseOwner}scp_folderpermission fp ON f.folderid = fp.folderid
    INNER JOIN {databaseOwner}scp_permission p ON fp.permissionid = p.permissionid ON r.roleid = fp.roleid
    WHERE(ur.userid = i_userid OR(fp.roleid = -1
     AND i_userid IS NOT NULL) OR(fp.roleid = -3))
     AND instr(i_permissionkeys,   p.permissionkey) > 0
     AND fp.allowaccess = i_allowaccess
     AND f.portalid = i_portalid
     AND(f.storagelocation = 0 OR(f.storagelocation = 1
     AND i_includesecure = 1) OR(f.storagelocation = 2
     AND i_includedatabase = 1))
    ORDER BY f.folderpath;
  END scp_getfoldersbyuser;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETDESKTOPMODULE
  --------------------------------------------------------

  PROCEDURE scp_getdesktopmodule(i_desktopmoduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_desktopmodules
    WHERE desktopmoduleid = i_desktopmoduleid;
  END scp_getdesktopmodule;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETTABCOUNT
  --------------------------------------------------------

  PROCEDURE scp_gettabcount(i_portalid IN NUMBER DEFAULT NULL,   o_tabcount OUT number) AS
  v_admintabid NUMBER(10,   0);
  BEGIN
	FOR rec IN
    (SELECT admintabid
    FROM {databaseOwner}scp_portals
    WHERE portalid = i_portalid)
    LOOP
		v_admintabid := rec.admintabid;
    END LOOP;

    SELECT COUNT(*) -1
    INTO o_tabcount
    FROM {databaseOwner}scp_tabs
    WHERE(portalid = i_portalid)
     AND(tabid <> v_admintabid)
     AND(parentid <> v_admintabid OR parentid IS NULL);
  END scp_gettabcount;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSCHEDULEBYTYPEFULLNAME
  --------------------------------------------------------

  PROCEDURE scp_getschedulebytypefullname(i_typefullname IN VARCHAR2 DEFAULT NULL,   i_server IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
  BEGIN

    OPEN o_rc1 FOR

    SELECT s.scheduleid,
      s.typefullname,
      s.timelapse,
      s.timelapsemeasurement,
      s.retrytimelapse,
      s.retrytimelapsemeasurement,
      s.objectdependencies,
      s.attachtoevent,
      s.retainhistorynum,
      s.catchupenabled,
      s.enabled,
      s.servers
    FROM {databaseOwner}scp_schedule s
    WHERE s.typefullname = i_typefullname
     AND(s.servers LIKE ',%' || {databaseOwner}scpuke_pkg.FORMATSQL(i_server) || '%,' ESCAPE '\' OR s.servers IS NULL)
    GROUP BY s.scheduleid,
      s.typefullname,
      s.timelapse,
      s.timelapsemeasurement,
      s.retrytimelapse,
      s.retrytimelapsemeasurement,
      s.objectdependencies,
      s.attachtoevent,
      s.retainhistorynum,
      s.catchupenabled,
      s.enabled,
      s.servers;
  END scp_getschedulebytypefullname;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULEPERMISSIONSBYPTL
  --------------------------------------------------------

  PROCEDURE scp_getmodulepermissionsbyptl(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_modulepermissions mp
    INNER JOIN {databaseOwner}scp_modules m ON mp.moduleid = m.moduleid
    WHERE m.portalid = i_portalid;
  END scp_getmodulepermissionsbyptl;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETMODULEBYDEFINITION
  --------------------------------------------------------

  PROCEDURE scp_getmodulebydefinition(i_portalid IN NUMBER DEFAULT NULL,   i_friendlyname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_modules
    WHERE((portalid = i_portalid) OR(i_portalid IS NULL
     AND portalid IS NULL))
     AND friendlyname = i_friendlyname
     AND isdeleted = 0;
  END scp_getmodulebydefinition;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETFOLDERPERMISSION
  --------------------------------------------------------

  PROCEDURE scp_getfolderpermission(i_folderpermissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_vw_folderpermissions
    WHERE folderpermissionid = i_folderpermissionid;
  END scp_getfolderpermission;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSEARCHITEMWORD
  --------------------------------------------------------

  PROCEDURE scp_getsearchitemword(i_searchitemwordid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT searchitemwordid,
      searchitemid,
      searchwordsid,
      occurrences
    FROM {databaseOwner}scp_searchitemword
    WHERE searchitemwordid = i_searchitemwordid;
  END scp_getsearchitemword;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETPERMISSION
  --------------------------------------------------------

  PROCEDURE scp_getpermission(i_permissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT permissionid,
      permissioncode,
      moduledefid,
      permissionkey,
      permissionname
    FROM {databaseOwner}scp_permission
    WHERE permissionid = i_permissionid;
  END scp_getpermission;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETFILECONTENT
  --------------------------------------------------------

  PROCEDURE scp_getfilecontent(i_fileid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT content
    FROM {databaseOwner}scp_files
    WHERE fileid = i_fileid
     AND((scp_files.portalid = i_portalid) OR(i_portalid IS NULL
     AND scp_files.portalid IS NULL));
  END scp_getfilecontent;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETSCHEDULEITEMSETTINGS
  --------------------------------------------------------

  PROCEDURE scp_getscheduleitemsettings(i_scheduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT *
    FROM {databaseOwner}scp_scheduleitemsettings
    WHERE scheduleid = i_scheduleid;
  END scp_getscheduleitemsettings;

  --------------------------------------------------------
  --  DDL for Procedure SCP_GETTABPERMISSIONSBYTABID
  --------------------------------------------------------

  PROCEDURE scp_gettabpermissionsbytabid(i_tabid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

  BEGIN

    OPEN o_rc1 FOR

    SELECT m.tabpermissionid,
      m.tabid,
      p.permissionid,
      m.roleid,
      CASE m.roleid
  WHEN -1 THEN
    'All Users'
  WHEN -2 THEN
    'Superuser'
  WHEN -3 THEN
    'Unauthenticated Users'
  ELSE
    to_char(r.rolename)
  END rolename,
    m.allowaccess,
    p.permissioncode,
    p.permissionkey,
    p.permissionname
  FROM {databaseOwner}scp_tabpermission m LEFT JOIN {databaseOwner}scp_permission p ON m.permissionid = p.permissionid LEFT JOIN {databaseOwner}scp_roles r ON m.roleid = r.roleid
  WHERE(m.tabid = i_tabid OR(m.tabid IS NULL
   AND p.permissioncode = 'SYSTEM_TAB'))
   AND(p.permissionid = i_permissionid OR i_permissionid = -1);
END scp_gettabpermissionsbytabid;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSCHEDULEBYEVENT
--------------------------------------------------------

PROCEDURE scp_getschedulebyevent(i_eventname IN VARCHAR2 DEFAULT NULL,   i_server IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
BEGIN

  OPEN o_rc1 FOR

  SELECT s.scheduleid,
    s.typefullname,
    s.timelapse,
    s.timelapsemeasurement,
    s.retrytimelapse,
    s.retrytimelapsemeasurement,
    s.objectdependencies,
    s.attachtoevent,
    s.retainhistorynum,
    s.catchupenabled,
    s.enabled
  FROM {databaseOwner}scp_schedule s
  WHERE s.attachtoevent = i_eventname
   AND(s.servers LIKE ',%' || {databaseOwner}scpuke_pkg.FORMATSQL(i_server) || '%,' ESCAPE '\' OR s.servers IS NULL)
  GROUP BY s.scheduleid,
    s.typefullname,
    s.timelapse,
    s.timelapsemeasurement,
    s.retrytimelapse,
    s.retrytimelapsemeasurement,
    s.objectdependencies,
    s.attachtoevent,
    s.retainhistorynum,
    s.catchupenabled,
    s.enabled;
END scp_getschedulebyevent;

--------------------------------------------------------
--  DDL for Procedure SCP_GETTABBYNAME
--------------------------------------------------------

PROCEDURE scp_gettabbyname(i_tabname IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_vw_tabs
  WHERE tabname = i_tabname
   AND((portalid = i_portalid) OR(i_portalid IS NULL
   AND portalid IS NULL))
  ORDER BY tabid;
END scp_gettabbyname;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSITELOG12
--------------------------------------------------------

PROCEDURE scp_getsitelog12(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT affiliateid,
    COUNT(*) requests,
    MAX(datetime) lastreferral
  FROM {databaseOwner}scp_sitelog
  WHERE scp_sitelog.portalid = i_portalid
   AND scp_sitelog.datetime BETWEEN i_startdate
   AND i_enddate
   AND affiliateid IS NOT NULL
  GROUP BY affiliateid
  ORDER BY requests DESC;
END scp_getsitelog12;

--------------------------------------------------------
--  DDL for Procedure SCP_GETPORTALSPACEUSED
--------------------------------------------------------

PROCEDURE scp_getportalspaceused(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT SUM(CAST(size_ AS
  NUMBER(19,   0))) spaceused
  FROM {databaseOwner}scp_files
  WHERE((portalid = i_portalid) OR(i_portalid IS NULL
   AND portalid IS NULL));
END scp_getportalspaceused;

--------------------------------------------------------
--  DDL for Procedure SCP_GETPERMISSIONSBYFOLDERPTH
--------------------------------------------------------

PROCEDURE scp_getpermissionsbyfolderpth(i_portalid IN NUMBER DEFAULT NULL,   i_folderpath IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT p.permissionid,
    p.permissioncode,
    p.permissionkey,
    p.permissionname
  FROM {databaseOwner}scp_permission p
  WHERE p.permissioncode = 'SYSTEM_FOLDER';
END scp_getpermissionsbyfolderpth;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSUPERUSERS
--------------------------------------------------------

PROCEDURE scp_getsuperusers(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT u.*,
    -1 portalid,
    u.firstname || ' ' || u.lastname fullname
  FROM {databaseOwner}scp_users u
  WHERE u.issuperuser = 1;
END scp_getsuperusers;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSCHEDULEHISTORY
--------------------------------------------------------

PROCEDURE scp_getschedulehistory(i_scheduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT s.scheduleid,
    s.typefullname,
    sh.startdate,
    sh.enddate,
    sh.succeeded,
    sh.lognotes,
    sh.nextstart,
    sh.server
  FROM {databaseOwner}scp_schedule s
  INNER JOIN {databaseOwner}scp_schedulehistory sh ON s.scheduleid = sh.scheduleid
  WHERE s.scheduleid = i_scheduleid OR i_scheduleid = -1;
END scp_getschedulehistory;

--------------------------------------------------------
--  DDL for Procedure SCP_GETUSERROLESBYUSERID
--------------------------------------------------------

PROCEDURE scp_getuserrolesbyuserid(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1) AS
v_pagelowerbound NUMBER(10,   0);
v_pageupperbound NUMBER(10,   0);
BEGIN  
    
    IF i_userid IS NULL THEN
    BEGIN
    
    v_pagelowerbound := (i_pagesize * i_pageindex) + 1;
    v_pageupperbound := i_pagesize + v_pagelowerbound - 1;
    
    OPEN o_rc1 FOR    
    SELECT *
    FROM (SELECT u.*, ROWNUM rnum 
    FROM (SELECT r.*,
        u.accountnumber,
        u.username,
        u.firstname,
        u.lastname,
        u.displayname,
        ur.userroleid,
        ur.userid,
        ur.effectivedate,
        ur.expirydate,
        ur.istrialused
      FROM {databaseOwner}scp_userroles ur
      INNER JOIN {databaseOwner}scp_vw_users u ON ur.userid = u.userid
      INNER JOIN {databaseOwner}scp_roles r ON r.roleid = ur.roleid
      WHERE r.portalid = i_portalid AND r.roleid = i_roleid
    ORDER BY accountnumber, username) u
    WHERE ROWNUM <= v_pageupperbound)
    WHERE rnum >= v_pagelowerbound;

    OPEN o_totalrecords FOR
    SELECT COUNT(*) TotalRecords 
    FROM {databaseOwner}scp_userroles ur
      INNER JOIN {databaseOwner}scp_roles r ON r.roleid = ur.roleid
      WHERE r.portalid = i_portalid AND r.roleid = i_roleid;  
      
    END;
  ELSE
    BEGIN

      IF i_roleid IS NULL THEN
        BEGIN

          OPEN o_rc1 FOR
          SELECT r.*,
            u.accountnumber,
            u.username,
            u.firstname,
            u.lastname,
            u.displayname fullname,
            ur.userroleid,
            ur.userid,
            ur.effectivedate,
            ur.expirydate,
            ur.istrialused
          FROM {databaseOwner}scp_userroles ur
          INNER JOIN {databaseOwner}scp_vw_users u ON ur.userid = u.userid
          INNER JOIN {databaseOwner}scp_roles r ON r.roleid = ur.roleid
          WHERE r.portalid = i_portalid AND u.userid = i_userid;
        END;
      ELSE
        BEGIN

          OPEN o_rc1 FOR
          SELECT r.*,          
            u.accountnumber,
            u.username,
            u.firstname,
            u.lastname,
            u.displayname fullname,
            ur.userroleid,
            ur.userid,
            ur.effectivedate,
            ur.expirydate,
            ur.istrialused
          FROM {databaseOwner}scp_userroles ur
          INNER JOIN {databaseOwner}scp_vw_users u ON ur.userid = u.userid
          INNER JOIN {databaseOwner}scp_roles r ON r.roleid = ur.roleid
          WHERE r.portalid = i_portalid 
          AND r.roleid = i_roleid AND u.userid = i_userid;
        END;
      END IF;

    END;
  END IF;

END scp_getuserrolesbyuserid;

--------------------------------------------------------
--  DDL for Procedure SCP_GETPORTALCOUNT
--------------------------------------------------------

PROCEDURE scp_getportalcount(o_count OUT number) AS

BEGIN
  SELECT COUNT(*) INTO o_count
  FROM {databaseOwner}scp_portals;
END scp_getportalcount;

--------------------------------------------------------
--  DDL for Procedure SCP_GETUSERCOUNTBYPORTAL
--------------------------------------------------------

PROCEDURE scp_getusercountbyportal(i_portalid IN NUMBER DEFAULT NULL,   o_usercount OUT NUMBER) AS
BEGIN
  SELECT COUNT(*) INTO o_usercount
  FROM {databaseOwner}scp_vw_users
  WHERE portalid = i_portalid;
END scp_getusercountbyportal;

--------------------------------------------------------
--  DDL for Procedure SCP_GETCURRENCIES
--------------------------------------------------------

PROCEDURE scp_getcurrencies(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR
  select * from dual;

  --SELECT code,
  --  description
  --FROM {databaseOwner}scp_codecurrency;
END scp_getcurrencies;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSEARCHITEMWORDPOSITION
--------------------------------------------------------

PROCEDURE scp_getsearchitemwordposition(i_searchitemwordpositionid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT searchitemwordpositionid,
    searchitemwordid,
    contentposition
  FROM {databaseOwner}scp_searchitemwordposition
  WHERE searchitemwordpositionid = i_searchitemwordpositionid;
END scp_getsearchitemwordposition;

--------------------------------------------------------
--  DDL for Procedure SCP_GETDESKTOPMODULEBYMODNAME
--------------------------------------------------------

PROCEDURE scp_getdesktopmodulebymodname(i_modulename IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_desktopmodules
  WHERE modulename = i_modulename;
END scp_getdesktopmodulebymodname;

--------------------------------------------------------
--  DDL for Procedure SCP_GETROLES
--------------------------------------------------------

PROCEDURE scp_getroles(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR
  SELECT *
  FROM {databaseOwner}scp_roles
  ORDER BY rolename;
  
END scp_getroles;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSITELOG5
--------------------------------------------------------

PROCEDURE scp_getsitelog5(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
BEGIN

  OPEN o_rc1 FOR

  SELECT
  CASE
  WHEN scp_sitelog.useragent LIKE '%MSIE 1%' THEN
    'Internet Explorer 1'
  WHEN scp_sitelog.useragent LIKE '%MSIE 2%' THEN
    'Internet Explorer 2'
  WHEN scp_sitelog.useragent LIKE '%MSIE 3%' THEN
    'Internet Explorer 3'
  WHEN scp_sitelog.useragent LIKE '%MSIE 4%' THEN
    'Internet Explorer 4'
  WHEN scp_sitelog.useragent LIKE '%MSIE 5%' THEN
    'Internet Explorer 5'
  WHEN scp_sitelog.useragent LIKE '%MSIE 6%' THEN
    'Internet Explorer 6'
  WHEN scp_sitelog.useragent LIKE '%MSIE%' THEN
    'Internet Explorer'
  WHEN scp_sitelog.useragent LIKE '%Mozilla1%' THEN
    'Netscape Navigator 1'
  WHEN scp_sitelog.useragent LIKE '%Mozilla2%' THEN
    'Netscape Navigator 2'
  WHEN scp_sitelog.useragent LIKE '%Mozilla3%' THEN
    'Netscape Navigator 3'
  WHEN scp_sitelog.useragent LIKE '%Mozilla4%' THEN
    'Netscape Navigator 4'
  WHEN scp_sitelog.useragent LIKE '%Mozilla5%' THEN
    'Netscape Navigator 6+'
  ELSE
    to_char(scp_sitelog.useragent)
  END useragent,
    COUNT(*) requests,
    MAX(datetime) lastrequest
  FROM {databaseOwner}scp_sitelog
  WHERE portalid = i_portalid
   AND scp_sitelog.datetime BETWEEN i_startdate
   AND i_enddate
  GROUP BY
  CASE
  WHEN scp_sitelog.useragent LIKE '%MSIE 1%' THEN
    'Internet Explorer 1'
  WHEN scp_sitelog.useragent LIKE '%MSIE 2%' THEN
    'Internet Explorer 2'
  WHEN scp_sitelog.useragent LIKE '%MSIE 3%' THEN
    'Internet Explorer 3'
  WHEN scp_sitelog.useragent LIKE '%MSIE 4%' THEN
    'Internet Explorer 4'
  WHEN scp_sitelog.useragent LIKE '%MSIE 5%' THEN
    'Internet Explorer 5'
  WHEN scp_sitelog.useragent LIKE '%MSIE 6%' THEN
    'Internet Explorer 6'
  WHEN scp_sitelog.useragent LIKE '%MSIE%' THEN
    'Internet Explorer'
  WHEN scp_sitelog.useragent LIKE '%Mozilla1%' THEN
    'Netscape Navigator 1'
  WHEN scp_sitelog.useragent LIKE '%Mozilla2%' THEN
    'Netscape Navigator 2'
  WHEN scp_sitelog.useragent LIKE '%Mozilla3%' THEN
    'Netscape Navigator 3'
  WHEN scp_sitelog.useragent LIKE '%Mozilla4%' THEN
    'Netscape Navigator 4'
  WHEN scp_sitelog.useragent LIKE '%Mozilla5%' THEN
    'Netscape Navigator 6+'
  ELSE
    to_char(scp_sitelog.useragent)
  END
  ORDER BY requests DESC;
END scp_getsitelog5;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSEARCHWORDS
--------------------------------------------------------

PROCEDURE scp_getsearchwords(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR
  SELECT searchwordsid,
    word,
    hitcount
  FROM {databaseOwner}scp_searchword;
  
END scp_getsearchwords;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSCHEDULEBYSCHEDULEID
--------------------------------------------------------

PROCEDURE scp_getschedulebyscheduleid(i_scheduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT s.*
  FROM {databaseOwner}scp_schedule s
  WHERE s.scheduleid = i_scheduleid;
END scp_getschedulebyscheduleid;

--------------------------------------------------------
--  DDL for Procedure SCP_GETPORTALALIASBYPORTALID
--------------------------------------------------------

PROCEDURE scp_getportalaliasbyportalid(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_portalalias
  WHERE(portalid = i_portalid OR i_portalid = -1);
END scp_getportalaliasbyportalid;

--------------------------------------------------------
--  DDL for Procedure SCP_GETALLPROFILES
--------------------------------------------------------

PROCEDURE scp_getallprofiles(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_profile;
END scp_getallprofiles;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSEARCHITEM
--------------------------------------------------------

PROCEDURE scp_getsearchitem(i_moduleid IN NUMBER DEFAULT NULL,   i_searchkey IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT searchitemid,
    title,
    description,
    author,
    pubdate,
    moduleid,
    searchkey,
    guid,
    hitcount,
    imagefileid
  FROM {databaseOwner}scp_searchitem
  WHERE moduleid = i_moduleid
   AND searchkey = i_searchkey;
END scp_getsearchitem;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSEARCHINDEXERS
--------------------------------------------------------

PROCEDURE scp_getsearchindexers(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT scp_searchindexer.*
  FROM {databaseOwner}scp_searchindexer;
END scp_getsearchindexers;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSERVICES
--------------------------------------------------------

PROCEDURE scp_getservices(i_portalid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT roleid,
    r.rolename,
    r.description,
    CASE
  WHEN ROUND(to_number(r.servicefee),   0) <> 0 THEN
    r.servicefee
  ELSE
    NULL
  END servicefee,
    CASE
  WHEN ROUND(to_number(r.servicefee),   0) <> 0 THEN
    r.billingperiod
  ELSE
    NULL
  END billingperiod,
    CASE
  WHEN ROUND(to_number(r.servicefee),   0) <> 0 THEN
    l1.text
  ELSE
    NULL
  END billingfrequency,
    CASE
  WHEN r.trialfrequency <> 'N' THEN
    r.trialfee
  ELSE
    NULL
  END trialfee,
    CASE
  WHEN r.trialfrequency <> 'N' THEN
    r.trialperiod
  ELSE
    NULL
  END trialperiod,
    CASE
  WHEN r.trialfrequency <> 'N' THEN
    l2.text
  ELSE
    NULL
  END trialfrequency,
      (SELECT expirydate
     FROM {databaseOwner}scp_userroles
     WHERE scp_userroles.roleid = r.roleid
     AND scp_userroles.userid = i_userid)
  expirydate,
      (SELECT userroleid
     FROM {databaseOwner}scp_userroles
     WHERE scp_userroles.roleid = r.roleid
     AND scp_userroles.userid = i_userid)
  subscribed
  FROM {databaseOwner}scp_roles r
  INNER JOIN {databaseOwner}scp_lists l1 ON r.billingfrequency = l1.VALUE LEFT JOIN {databaseOwner}scp_lists l2 ON r.trialfrequency = l2.VALUE
  WHERE r.portalid = i_portalid
   AND r.ispublic = 1
   AND l1.listname = 'Frequency'
   AND l2.listname = 'Frequency';
END scp_getservices;

--------------------------------------------------------
--  DDL for Procedure SCP_GETBANNERGROUPS
--------------------------------------------------------

PROCEDURE scp_getbannergroups(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT groupname
  FROM {databaseOwner}scp_banners
  INNER JOIN {databaseOwner}scp_vendors ON scp_banners.vendorid = scp_vendors.vendorid
  WHERE(scp_vendors.portalid = i_portalid) OR(i_portalid IS NULL
   AND scp_vendors.portalid IS NULL)
  GROUP BY groupname
  ORDER BY groupname;
END scp_getbannergroups;

--------------------------------------------------------
--  DDL for Procedure SCP_GETPORTALALIAS
--------------------------------------------------------

PROCEDURE scp_getportalalias(i_httpalias IN nvarchar2 DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_portalalias
  WHERE httpalias = i_httpalias
   AND portalid = i_portalid;
END scp_getportalalias;

--------------------------------------------------------
--  DDL for Procedure SCP_GETTABPERMISSIONSBYPORTAL
--------------------------------------------------------

PROCEDURE scp_gettabpermissionsbyportal(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_vw_tabpermissions tp
  WHERE portalid = i_portalid OR(i_portalid IS NULL
   AND portalid IS NULL);
END scp_gettabpermissionsbyportal;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSITELOG3
--------------------------------------------------------

PROCEDURE scp_getsitelog3(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT scp_users.firstname || ' ' || scp_users.lastname name,
    COUNT(*) requests,
    MAX(datetime) lastrequest
  FROM {databaseOwner}scp_sitelog
  INNER JOIN {databaseOwner}scp_users ON scp_sitelog.userid = scp_users.userid
  WHERE scp_sitelog.portalid = i_portalid
   AND scp_sitelog.datetime BETWEEN i_startdate
   AND i_enddate
   AND scp_sitelog.userid IS NOT NULL
  GROUP BY scp_users.firstname || ' ' || scp_users.lastname

  ORDER BY requests DESC;
END scp_getsitelog3;

--------------------------------------------------------
--  DDL for Procedure SCP_GETAFFILIATE
--------------------------------------------------------

PROCEDURE scp_getaffiliate(i_affiliateid IN NUMBER DEFAULT NULL,   i_vendorid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT scp_affiliates.affiliateid,
    scp_affiliates.vendorid,
    scp_affiliates.startdate,
    scp_affiliates.enddate,
    scp_affiliates.cpc,
    scp_affiliates.clicks,
    scp_affiliates.cpa,
    scp_affiliates.acquisitions
  FROM {databaseOwner}scp_affiliates
  INNER JOIN {databaseOwner}scp_vendors ON scp_affiliates.vendorid = scp_vendors.vendorid
  WHERE scp_affiliates.affiliateid = i_affiliateid
   AND scp_affiliates.vendorid = i_vendorid
   AND(scp_vendors.portalid = i_portalid OR(scp_vendors.portalid IS NULL
   AND i_portalid IS NULL));
END scp_getaffiliate;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSITELOG1
--------------------------------------------------------

PROCEDURE scp_getsitelog1(i_portalid IN NUMBER DEFAULT NULL,   i_portalalias IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT to_char(datetime,   'yyyy.mm.dd') "Date",
    COUNT(*) views,
    COUNT(DISTINCT scp_sitelog.userhostaddress) visitors,
    COUNT(DISTINCT scp_sitelog.userid) users
  FROM {databaseOwner}scp_sitelog
  WHERE portalid = i_portalid
   AND scp_sitelog.datetime BETWEEN i_startdate
   AND i_enddate
  GROUP BY to_char(datetime,   'yyyy.mm.dd')
  ORDER BY datetime DESC;
END scp_getsitelog1;

--------------------------------------------------------
--  DDL for Procedure SCP_GETPORTALDESKTOPMODULES
--------------------------------------------------------

PROCEDURE scp_getportaldesktopmodules(i_portalid IN NUMBER DEFAULT NULL,   i_desktopmoduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT scp_portaldesktopmodules.*,
    portalname,
    friendlyname
  FROM {databaseOwner}scp_portaldesktopmodules
  INNER JOIN {databaseOwner}scp_portals ON scp_portaldesktopmodules.portalid = scp_portals.portalid
  INNER JOIN {databaseOwner}scp_desktopmodules ON scp_portaldesktopmodules.desktopmoduleid = scp_desktopmodules.desktopmoduleid

  WHERE((scp_portaldesktopmodules.portalid = i_portalid) OR i_portalid IS NULL)
   AND((scp_portaldesktopmodules.desktopmoduleid = i_desktopmoduleid)

   OR i_desktopmoduleid IS NULL)
  ORDER BY scp_portaldesktopmodules.portalid,
    scp_portaldesktopmodules.desktopmoduleid;
END scp_getportaldesktopmodules;

--------------------------------------------------------
--  DDL for Procedure SCP_GETMODULEDEFINITIONS
--------------------------------------------------------

PROCEDURE scp_getmoduledefinitions(i_desktopmoduleid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_moduledefinitions
  WHERE desktopmoduleid = i_desktopmoduleid OR desktopmoduleid = -1;
END scp_getmoduledefinitions;

--------------------------------------------------------
--  DDL for Procedure SCP_GETDESKTOPMODULEBYNAME
--------------------------------------------------------

PROCEDURE scp_getdesktopmodulebyname(i_friendlyname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_desktopmodules
  WHERE friendlyname = i_friendlyname;
END scp_getdesktopmodulebyname;

--------------------------------------------------------
--  DDL for Procedure SCP_GETPORTALROLES
--------------------------------------------------------

PROCEDURE scp_getportalroles(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT r.roleid,
    r.portalid,
    r.rolegroupid,
    r.rolename,
    r.description,
    CASE
  WHEN ROUND(to_number(r.servicefee),   0) <> 0 THEN
    r.servicefee
  ELSE
    NULL
  END servicefee,
    CASE
  WHEN ROUND(to_number(r.servicefee),   0) <> 0 THEN
    r.billingperiod
  ELSE
    NULL
  END billingperiod,
    CASE
  WHEN ROUND(to_number(r.servicefee),   0) <> 0 THEN
    l1.text
  ELSE
    NULL
  END billingfrequency,
    CASE
  WHEN r.trialfrequency <> 'N' THEN
    r.trialfee
  ELSE
    NULL
  END trialfee,
    CASE
  WHEN r.trialfrequency <> 'N' THEN
    r.trialperiod
  ELSE
    NULL
  END trialperiod,
    CASE
  WHEN r.trialfrequency <> 'N' THEN
    l2.text
  ELSE
    NULL
  END trialfrequency,
    CASE
  WHEN r.ispublic = 1 THEN
    'True'
  ELSE
    'False'
  END ispublic,
    CASE
  WHEN r.autoassignment = 1 THEN
    'True'
  ELSE
    'False'
  END autoassignment,
    rsvpcode,
    iconfile
  FROM {databaseOwner}scp_roles r LEFT JOIN {databaseOwner}scp_lists l1 ON r.billingfrequency = l1.VALUE LEFT JOIN {databaseOwner}scp_lists l2 ON r.trialfrequency = l2.VALUE
  WHERE portalid = i_portalid OR portalid IS NULL
  ORDER BY r.rolename;
END scp_getportalroles;

--------------------------------------------------------
--  DDL for Procedure SCP_GETUSERSBYROLENAME
--------------------------------------------------------

PROCEDURE scp_getusersbyrolename(i_portalid IN NUMBER DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT u.userid,
    up.portalid,
    u.accountnumber,
    u.username,
    u.firstname,
    u.lastname,
    u.displayname,
    u.issuperuser,
    u.email,
    u.affiliateid,
    u.updatepassword
  FROM {databaseOwner}scp_userportals up RIGHT JOIN {databaseOwner}scp_userroles ur
  INNER JOIN {databaseOwner}scp_roles r ON ur.roleid = r.roleid 
  RIGHT JOIN {databaseOwner}scp_vw_users u ON ur.userid = u.userid ON up.userid = u.userid
  WHERE(up.portalid = i_portalid OR i_portalid IS NULL)
   AND(r.rolename = i_rolename)
   AND(r.portalid = i_portalid OR i_portalid IS NULL)
  ORDER BY u.accountnumber, u.username;
END scp_getusersbyrolename;

--------------------------------------------------------
--  DDL for Procedure SCP_GETALLUSERS
--------------------------------------------------------

PROCEDURE scp_getallusers(i_portalid IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_totalrecords OUT {databaseOwner}global_pkg.rct1) AS
v_pagelowerbound NUMBER(10,   0);
v_pageupperbound NUMBER(10,   0);
BEGIN
  BEGIN
    v_pagelowerbound := (i_pagesize * i_pageindex) + 1;
    v_pageupperbound := i_pagesize + v_pagelowerbound - 1;
    
    OPEN o_rc1 FOR    
    SELECT *
    FROM (SELECT u.*, ROWNUM rnum 
    FROM (SELECT *
    FROM {databaseOwner}scp_vw_users
    WHERE(portalid = i_portalid OR(i_portalid IS NULL
     AND portalid IS NULL))
    ORDER BY accountnumber, username) u
    WHERE ROWNUM <= v_pageupperbound)
    WHERE rnum >= v_pagelowerbound;

    OPEN o_totalrecords FOR
    SELECT COUNT(*) TotalRecords 
    FROM {databaseOwner}scp_vw_users
    WHERE(portalid = i_portalid OR(i_portalid IS NULL
     AND portalid IS NULL));
     
  END;
END scp_getallusers;

--------------------------------------------------------
--  DDL for Procedure SCP_GETEVENTLOGTYPE
--------------------------------------------------------

PROCEDURE scp_geteventlogtype(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_eventlogtypes;
END scp_geteventlogtype;

--------------------------------------------------------
--  DDL for Procedure SCP_GETTABS
--------------------------------------------------------

PROCEDURE scp_gettabs(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_vw_tabs
  WHERE portalid = i_portalid OR(i_portalid IS NULL
   AND portalid IS NULL)
  ORDER BY taborder,
    tabname;
END scp_gettabs;

--------------------------------------------------------
--  DDL for Procedure SCP_GETFOLDERS
--------------------------------------------------------

PROCEDURE scp_getfolders(i_portalid IN NUMBER DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   i_folderpath IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_folders
  WHERE((portalid = i_portalid) OR(i_portalid IS NULL
   AND portalid IS NULL))
   AND(folderid = i_folderid OR i_folderid = -1)
   AND(folderpath = i_folderpath OR i_folderpath IS NULL)
  ORDER BY folderpath;
END scp_getfolders;

--------------------------------------------------------
--  DDL for Procedure SCP_GETUSERS
--------------------------------------------------------

PROCEDURE scp_getusers(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_users u LEFT JOIN {databaseOwner}scp_userportals up ON u.userid = up.userid
  WHERE(up.portalid = i_portalid OR i_portalid IS NULL)
  ORDER BY u.firstname || ' ' || u.lastname;
END scp_getusers;

--------------------------------------------------------
--  DDL for Procedure SCP_GETALLTABS
--------------------------------------------------------

PROCEDURE scp_getalltabs(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_vw_tabs
  ORDER BY taborder,
    tabname;
END scp_getalltabs;

--------------------------------------------------------
--  DDL for Procedure SCP_GETTABMODULESETTING
--------------------------------------------------------

PROCEDURE scp_gettabmodulesetting(i_tabmoduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT settingname,
    settingvalue
  FROM {databaseOwner}scp_tabmodulesettings
  WHERE tabmoduleid = i_tabmoduleid
   AND settingname = i_settingname;
END scp_gettabmodulesetting;

--------------------------------------------------------
--  DDL for Procedure SCP_GETMODULEPERMISSIONSBYTAB
--------------------------------------------------------

PROCEDURE scp_getmodulepermissionsbytab(i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_vw_modulepermissions mp
  INNER JOIN {databaseOwner}scp_tabmodules tm ON mp.moduleid = tm.moduleid
  WHERE tm.tabid = i_tabid;
END scp_getmodulepermissionsbytab;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSYSTEMMESSAGE
--------------------------------------------------------

PROCEDURE scp_getsystemmessage(i_portalid IN NUMBER DEFAULT NULL,   i_messagename IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT messagevalue
  FROM {databaseOwner}scp_systemmessages
  WHERE((portalid = i_portalid) OR(i_portalid IS NULL
   AND portalid IS NULL))
   AND messagename = i_messagename;
END scp_getsystemmessage;

--------------------------------------------------------
--  DDL for Procedure SCP_GETONLINEUSERS
--------------------------------------------------------

PROCEDURE scp_getonlineusers(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT *
  FROM {databaseOwner}scp_usersonline uo
  INNER JOIN {databaseOwner}scp_vw_users u ON uo.userid = u.userid
  INNER JOIN {databaseOwner}scp_userportals up ON u.userid = up.userid
  WHERE up.portalid = i_portalid;
END scp_getonlineusers;

--------------------------------------------------------
--  DDL for Procedure SCP_GETFILES
--------------------------------------------------------

PROCEDURE scp_getfiles(i_portalid IN NUMBER DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT fileid,
    fo.portalid,
    filename,
    extension,
    size_,
    width,
    height,
    contenttype,
    f.folderid,
    folderpath folder,
    storagelocation,
    iscached
  FROM {databaseOwner}scp_files f
  INNER JOIN {databaseOwner}scp_folders fo ON f.folderid = fo.folderid
  WHERE f.folderid = i_folderid
   AND((fo.portalid = i_portalid) OR(i_portalid IS NULL
   AND fo.portalid IS NULL))
  ORDER BY filename;
END scp_getfiles;

--------------------------------------------------------
--  DDL for Procedure SCP_GETSCHEDULE
--------------------------------------------------------

PROCEDURE scp_getschedule(i_server IN VARCHAR2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT s.scheduleid,
    s.typefullname,
    s.timelapse,
    s.timelapsemeasurement,
    s.retrytimelapse,
    s.retrytimelapsemeasurement,
    s.objectdependencies,
    s.attachtoevent,
    s.retainhistorynum,
    s.catchupenabled,
    s.enabled,
    sh.nextstart,
    s.servers
  FROM {databaseOwner}scp_schedule s LEFT JOIN {databaseOwner}scp_schedulehistory sh ON s.scheduleid = sh.scheduleid
  WHERE((sh.schedulehistoryid,   1) IN
    (SELECT s1.schedulehistoryid,    row_number() over(
     ORDER BY s1.nextstart DESC)
     FROM {databaseOwner}scp_schedulehistory s1
     WHERE s1.scheduleid = s.scheduleid) OR sh.schedulehistoryid IS NULL)
  AND(i_server IS NULL OR s.servers LIKE ',%' || {databaseOwner}scpuke_pkg.FORMATSQL(i_server) || '%,' ESCAPE '\' OR s.servers IS NULL)
  GROUP BY s.scheduleid,
    s.typefullname,
    s.timelapse,
    s.timelapsemeasurement,
    s.retrytimelapse,
    s.retrytimelapsemeasurement,
    s.objectdependencies,
    s.attachtoevent,
    s.retainhistorynum,
    s.catchupenabled,
    s.enabled,
    sh.nextstart,
    s.servers;
END scp_getschedule;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEFOLDERPERMISSION
--------------------------------------------------------

PROCEDURE scp_updateaccount(i_accountid IN NUMBER DEFAULT NULL, i_accountname IN VARCHAR2 DEFAULT NULL, i_description IN NVARCHAR2 DEFAULT NULL, i_email1 IN NVARCHAR2 DEFAULT NULL, i_email2 IN NVARCHAR2 DEFAULT NULL, i_isenabled IN NUMBER DEFAULT NULL) AS
BEGIN
  UPDATE {databaseOwner}scp_accountnumbers
  SET accountname = i_accountname,
    description = i_description,
    email1 = i_email1,
    email2 = i_email2,
    isenabled = i_isenabled
  WHERE accountid = i_accountid;
    
END scp_updateaccount;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEFOLDERPERMISSION
--------------------------------------------------------

PROCEDURE scp_updatefolderpermission(i_folderpermissionid IN NUMBER DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_folderpermission
  SET folderid = i_folderid,
    permissionid = i_permissionid,
    roleid = i_roleid,
    allowaccess = i_allowaccess
  WHERE folderpermissionid = i_folderpermissionid;

END scp_updatefolderpermission;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEONLINEUSER
--------------------------------------------------------

PROCEDURE scp_updateonlineuser(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   i_lastactivedate IN DATE DEFAULT NULL) AS
v_exists NUMBER(10,   0);
BEGIN
  BEGIN

    BEGIN
      v_exists := 0;
      SELECT COUNT(*)
      INTO v_exists
      FROM dual
      WHERE EXISTS
        (SELECT userid
         FROM {databaseOwner}scp_usersonline
         WHERE userid = i_userid
         AND portalid = i_portalid);

    END;

    IF v_exists != 0 THEN

      UPDATE {databaseOwner}scp_usersonline
      SET tabid = i_tabid,
        lastactivedate = i_lastactivedate
      WHERE userid = i_userid
       AND portalid = i_portalid;

    ELSE
      INSERT
      INTO {databaseOwner}scp_usersonline(userid,   portalid,   tabid,   creationdate,   lastactivedate)
      VALUES(i_userid,   i_portalid,   i_tabid,   sysdate,   i_lastactivedate);

    END IF;

  END;
END scp_updateonlineuser;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEUSERPROFILEPROPERTY
--------------------------------------------------------

PROCEDURE scp_updateuserprofileproperty(i_profileid IN NUMBER DEFAULT NULL,   i_userid IN NUMBER DEFAULT NULL,   i_propertydefinitionid IN NUMBER DEFAULT NULL,   i_propertyvalue IN nclob DEFAULT NULL,   i_visibility IN NUMBER DEFAULT NULL,   i_lastupdateddate IN DATE DEFAULT NULL,   o_profileid OUT {databaseOwner}scp_userprofile.profileid%TYPE) AS
BEGIN

  IF i_profileid IS NULL OR i_profileid = -1 THEN

    FOR rec IN
      (SELECT profileid
       FROM {databaseOwner}scp_userprofile
       WHERE userid = i_userid
       AND propertydefinitionid = i_propertydefinitionid)
    LOOP
      o_profileid := rec.profileid;
    END LOOP;

  ELSE
    o_profileid := i_profileid;
  END IF;

  IF o_profileid IS NOT NULL THEN
    BEGIN

      UPDATE {databaseOwner}scp_userprofile
      SET propertyvalue =
      CASE
      WHEN(lengthb(to_nchar(i_propertyvalue)) > 7500) THEN
        NULL
      ELSE
        i_propertyvalue
      END,
        propertytext =
      CASE
      WHEN(lengthb(to_nchar(i_propertyvalue)) > 7500) THEN
        i_propertyvalue
      ELSE
        NULL
      END,
        visibility = i_visibility,
        lastupdateddate = i_lastupdateddate
      WHERE profileid = o_profileid;

    END;
  ELSE
    BEGIN
      INSERT
      INTO {databaseOwner}scp_userprofile(userid,   propertydefinitionid,   propertyvalue,   propertytext,   visibility,   lastupdateddate)
      VALUES(i_userid,   i_propertydefinitionid,
        CASE
      WHEN(lengthb(to_nchar(i_propertyvalue)) > 7500) THEN NULL
      ELSE i_propertyvalue
      END,
        CASE
      WHEN(lengthb(to_nchar(i_propertyvalue)) > 7500) THEN i_propertyvalue
      ELSE NULL
      END,   i_visibility,   i_lastupdateddate) returning profileid
      INTO o_profileid;

    END;
  END IF;

END scp_updateuserprofileproperty;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEEVENTLOGCONFIG
--------------------------------------------------------

PROCEDURE scp_updateeventlogconfig(i_id IN NUMBER DEFAULT NULL,   i_logtypekey IN nvarchar2 DEFAULT NULL,   i_logtypeportalid IN NUMBER DEFAULT NULL,   i_loggingisactive IN NUMBER DEFAULT NULL,   i_keepmostrecent IN NUMBER DEFAULT NULL,   i_emailnotificationisactive IN NUMBER DEFAULT NULL,   i_notificationthreshold IN NUMBER DEFAULT NULL,   i_notificationthresholdtime IN NUMBER DEFAULT NULL,   i_notificationthresholdtype IN NUMBER DEFAULT NULL,   i_mailfromaddress IN nvarchar2 DEFAULT NULL,   i_mailtoaddress IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_eventlogconfig
  SET logtypekey = i_logtypekey,
    logtypeportalid = i_logtypeportalid,
    loggingisactive = i_loggingisactive,
    keepmostrecent = i_keepmostrecent,
    emailnotificationisactive = i_emailnotificationisactive,
    notificationthreshold = i_notificationthreshold,
    notificationthresholdtime = i_notificationthresholdtime,
    notificationthresholdtimetype = i_notificationthresholdtype,
    mailfromaddress = i_mailfromaddress,
    mailtoaddress = i_mailtoaddress
  WHERE id = i_id;

END scp_updateeventlogconfig;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEUSERROLE
--------------------------------------------------------

PROCEDURE scp_updateuserrole(i_userroleid IN NUMBER DEFAULT NULL,   i_effectivedate IN DATE DEFAULT NULL,   i_expirydate IN DATE DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_userroles
  SET expirydate = i_expirydate,
    effectivedate = i_effectivedate
  WHERE userroleid = i_userroleid;

END scp_updateuserrole;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEMODULEDEFINITION
--------------------------------------------------------

PROCEDURE scp_updatemoduledefinition(i_moduledefid IN NUMBER DEFAULT NULL,   i_friendlyname IN nvarchar2 DEFAULT NULL,   i_defaultcachetime IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_moduledefinitions
  SET friendlyname = i_friendlyname,
    defaultcachetime = i_defaultcachetime
  WHERE moduledefid = i_moduledefid;

END scp_updatemoduledefinition;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEMODULECONTROL
--------------------------------------------------------

PROCEDURE scp_updatemodulecontrol(i_modulecontrolid IN NUMBER DEFAULT NULL,   i_moduledefid IN NUMBER DEFAULT NULL,   i_controlkey IN nvarchar2 DEFAULT NULL,   i_controltitle IN nvarchar2 DEFAULT NULL,   i_controlsrc IN nvarchar2 DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   i_controltype IN NUMBER DEFAULT NULL,   i_vieworder IN NUMBER DEFAULT NULL,   i_helpurl IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_modulecontrols
  SET moduledefid = i_moduledefid,
    controlkey = i_controlkey,
    controltitle = i_controltitle,
    controlsrc = i_controlsrc,
    iconfile = i_iconfile,
    controltype = i_controltype,
    vieworder = i_vieworder,
    helpurl = i_helpurl
  WHERE modulecontrolid = i_modulecontrolid;

END scp_updatemodulecontrol;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATETABORDER
--------------------------------------------------------

PROCEDURE scp_updatetaborder(i_tabid IN NUMBER DEFAULT NULL,   i_taborder IN NUMBER DEFAULT NULL,   i_level IN NUMBER DEFAULT NULL,   i_parentid IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_tabs
  SET taborder = i_taborder,
    level_ = i_level,
    parentid = i_parentid
  WHERE tabid = i_tabid;

END scp_updatetaborder;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEFILE
--------------------------------------------------------

PROCEDURE scp_updatefile(i_fileid IN NUMBER DEFAULT NULL,   i_filename IN nvarchar2 DEFAULT NULL,   i_extension IN nvarchar2 DEFAULT NULL,   i_size_ IN NUMBER DEFAULT NULL,   i_width IN NUMBER DEFAULT NULL,   i_height IN NUMBER DEFAULT NULL,   i_contenttype IN nvarchar2 DEFAULT NULL,   i_folder IN nvarchar2 DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_files
  SET filename = i_filename,
    extension = i_extension,
    size_ = i_size_,
    width = i_width,
    height = i_height,
    contenttype = i_contenttype,
    folder = i_folder,
    folderid = i_folderid
  WHERE fileid = i_fileid;

END scp_updatefile;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEEVENTLOGTYPE
--------------------------------------------------------

PROCEDURE scp_updateeventlogtype(i_logtypekey IN nvarchar2 DEFAULT NULL,   i_logtypefriendlyname IN nvarchar2 DEFAULT NULL,   i_logtypedescription IN nvarchar2 DEFAULT NULL,   i_logtypeowner IN nvarchar2 DEFAULT NULL,   i_logtypecssclass IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_eventlogtypes
  SET logtypefriendlyname = i_logtypefriendlyname,
    logtypedescription = i_logtypedescription,
    logtypeowner = i_logtypeowner,
    logtypecssclass = i_logtypecssclass
  WHERE logtypekey = i_logtypekey;

END scp_updateeventlogtype;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATESEARCHCOMMONWORD
--------------------------------------------------------

PROCEDURE scp_updatesearchcommonword(i_commonwordid IN NUMBER DEFAULT NULL,   i_commonword IN nvarchar2 DEFAULT NULL,   i_locale IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_searchcommonwords
  SET commonword = i_commonword,
    locale = i_locale
  WHERE commonwordid = i_commonwordid;

END scp_updatesearchcommonword;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATELISTSORTORDER
--------------------------------------------------------

PROCEDURE scp_updatelistsortorder(i_entryid IN NUMBER DEFAULT NULL,   i_moveup IN NUMBER DEFAULT NULL) AS
v_entrylistname nvarchar2(50);
v_parentid NUMBER(10,   0);
v_currentsortvalue NUMBER(10,   0);
v_replacesortvalue NUMBER(10,   0);
v_maxsortorder NUMBER(10,   0);
BEGIN
  FOR rec IN
    (SELECT sortorder,
       listname,
       parentid
     FROM {databaseOwner}scp_lists
     WHERE entryid = i_entryid)
  LOOP
    v_currentsortvalue := rec.sortorder;
    v_entrylistname := rec.listname;
    v_parentid := rec.parentid;

  END LOOP;

  IF(i_moveup = 1) THEN
    BEGIN

      IF(v_currentsortvalue != 1) THEN
        BEGIN
          v_replacesortvalue := v_currentsortvalue -1;

          UPDATE {databaseOwner}scp_lists
          SET sortorder = v_currentsortvalue
          WHERE sortorder = v_replacesortvalue
           AND listname = v_entrylistname
           AND parentid = v_parentid;

          UPDATE {databaseOwner}scp_lists
          SET sortorder = v_replacesortvalue
          WHERE entryid = i_entryid;

        END;
      END IF;

    END;
  ELSE
    BEGIN
      SELECT MAX(sortorder)
      INTO v_maxsortorder
      FROM {databaseOwner}scp_lists;

      IF(v_currentsortvalue < v_maxsortorder) THEN
        BEGIN
          v_replacesortvalue := v_currentsortvalue + 1;

          UPDATE {databaseOwner}scp_lists
          SET sortorder = v_currentsortvalue
          WHERE sortorder = v_replacesortvalue
           AND listname = v_entrylistname
           AND parentid = v_parentid;

          UPDATE {databaseOwner}scp_lists
          SET sortorder = v_replacesortvalue
          WHERE entryid = i_entryid;

        END;
      END IF;

    END;
  END IF;

END scp_updatelistsortorder;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEVENDOR
--------------------------------------------------------

PROCEDURE scp_updatevendor(i_vendorid IN NUMBER DEFAULT NULL,   i_vendorname IN nvarchar2 DEFAULT NULL,   i_unit IN nvarchar2 DEFAULT NULL,   i_street IN nvarchar2 DEFAULT NULL,   i_city IN nvarchar2 DEFAULT NULL,   i_region IN nvarchar2 DEFAULT NULL,   i_country IN nvarchar2 DEFAULT NULL,   i_postalcode IN nvarchar2 DEFAULT NULL,   i_telephone IN nvarchar2 DEFAULT NULL,   i_fax IN nvarchar2 DEFAULT NULL,   i_cell IN nvarchar2 DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL,   i_website IN nvarchar2 DEFAULT NULL,   i_firstname IN nvarchar2 DEFAULT NULL,   i_lastname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_logofile IN nvarchar2 DEFAULT NULL,   i_keywords IN CLOB DEFAULT NULL,   i_authorized IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_vendors
  SET vendorname = i_vendorname,
    unit = i_unit,
    street = i_street,
    city = i_city,
    region = i_region,
    country = i_country,
    postalcode = i_postalcode,
    telephone = i_telephone,
    fax = i_fax,
    cell = i_cell,
    email = i_email,
    website = i_website,
    firstname = i_firstname,
    lastname = i_lastname,
    createdbyuser = i_username,
    createddate = sysdate,
    logofile = i_logofile,
    keywords = i_keywords,
    authorized = i_authorized
  WHERE vendorid = i_vendorid;

END scp_updatevendor;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATETABMODULESETTING
--------------------------------------------------------

PROCEDURE scp_updatetabmodulesetting(i_tabmoduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL,   i_settingvalue IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_tabmodulesettings
  SET settingvalue = i_settingvalue
  WHERE tabmoduleid = i_tabmoduleid
   AND settingname = i_settingname;

END scp_updatetabmodulesetting;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEDATABASEVERSION
--------------------------------------------------------

PROCEDURE scp_updatedatabaseversion(i_major IN NUMBER DEFAULT NULL,   i_minor IN NUMBER DEFAULT NULL,   i_build IN NUMBER DEFAULT NULL) AS
BEGIN
  INSERT
  INTO {databaseOwner}scp_version(major,   minor,   build,   createddate)
  VALUES(i_major,   i_minor,   i_build,   sysdate);

END scp_updatedatabaseversion;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEURLTRACKINGSTATS
--------------------------------------------------------

PROCEDURE scp_updateurltrackingstats(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_urltracking
  SET clicks = clicks + 1,
    lastclick = sysdate
  WHERE portalid = i_portalid
   AND url = i_url
   AND((moduleid = i_moduleid) OR(i_moduleid IS NULL
   AND moduleid IS NULL));

END scp_updateurltrackingstats;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEDESKTOPMODULE
--------------------------------------------------------

PROCEDURE scp_updatedesktopmodule(i_desktopmoduleid IN NUMBER DEFAULT NULL,   i_modulename IN nvarchar2 DEFAULT NULL,   i_foldername IN nvarchar2 DEFAULT NULL,   i_friendlyname IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_version IN nvarchar2 DEFAULT NULL,   i_ispremium IN NUMBER DEFAULT NULL,   i_isadmin IN NUMBER DEFAULT NULL,   i_businesscontroller IN nvarchar2 DEFAULT NULL,   i_supportedfeatures IN NUMBER DEFAULT NULL,   i_compatibleversions IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_desktopmodules
  SET modulename = i_modulename,
    foldername = i_foldername,
    friendlyname = i_friendlyname,
    description = i_description,
    version = i_version,
    ispremium = i_ispremium,
    isadmin = i_isadmin,
    businesscontrollerclass = i_businesscontroller,
    supportedfeatures = i_supportedfeatures,
    compatibleversions = i_compatibleversions
  WHERE desktopmoduleid = i_desktopmoduleid;

END scp_updatedesktopmodule;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATETABMODULE
--------------------------------------------------------

PROCEDURE scp_updatetabmodule(i_tabid IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_moduleorder IN NUMBER DEFAULT NULL,   i_panename IN nvarchar2 DEFAULT NULL,   i_cachetime IN NUMBER DEFAULT NULL,   i_alignment IN nvarchar2 DEFAULT NULL,   i_color IN nvarchar2 DEFAULT NULL,   i_border IN nvarchar2 DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   i_visibility IN NUMBER DEFAULT NULL,   i_containersrc IN nvarchar2 DEFAULT NULL,   i_displaytitle IN NUMBER DEFAULT NULL,   i_displayprint IN NUMBER DEFAULT NULL,   i_displaysyndicate IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_tabmodules
  SET moduleorder = i_moduleorder,
    panename = i_panename,
    cachetime = i_cachetime,
    alignment = i_alignment,
    color = i_color,
    border = i_border,
    iconfile = i_iconfile,
    visibility = i_visibility,
    containersrc = i_containersrc,
    displaytitle = i_displaytitle,
    displayprint = i_displayprint,
    displaysyndicate = i_displaysyndicate
  WHERE tabid = i_tabid
   AND moduleid = i_moduleid;

END scp_updatetabmodule;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEBANNERVIEWS
--------------------------------------------------------

PROCEDURE scp_updatebannerviews(i_bannerid IN NUMBER DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_banners
  SET views = views + 1,
    startdate = i_startdate,
    enddate = i_enddate
  WHERE bannerid = i_bannerid;

END scp_updatebannerviews;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEROLE
--------------------------------------------------------

PROCEDURE scp_updaterole(i_roleid IN NUMBER DEFAULT NULL,   i_rolegroupid IN NUMBER DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_servicefee IN NUMBER DEFAULT NULL,   i_billingperiod IN NUMBER DEFAULT NULL,   i_billingfrequency IN CHAR DEFAULT NULL,   i_trialfee IN NUMBER DEFAULT NULL,   i_trialperiod IN NUMBER DEFAULT NULL,   i_trialfrequency IN CHAR DEFAULT NULL,   i_ispublic IN NUMBER DEFAULT NULL,   i_autoassignment IN NUMBER DEFAULT NULL,   i_rsvpcode IN nvarchar2 DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_roles
  SET rolegroupid = i_rolegroupid,
    description = i_description,
    servicefee = i_servicefee,
    billingperiod = i_billingperiod,
    billingfrequency = i_billingfrequency,
    trialfee = i_trialfee,
    trialperiod = i_trialperiod,
    trialfrequency = i_trialfrequency,
    ispublic = i_ispublic,
    autoassignment = i_autoassignment,
    rsvpcode = i_rsvpcode,
    iconfile = i_iconfile
  WHERE roleid = i_roleid;

END scp_updaterole;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEMODULESETTING
--------------------------------------------------------

PROCEDURE scp_updatemodulesetting(i_moduleid IN NUMBER DEFAULT NULL,   i_settingname IN nvarchar2 DEFAULT NULL,   i_settingvalue IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_modulesettings
  SET settingvalue = i_settingvalue
  WHERE moduleid = i_moduleid
   AND settingname = i_settingname;

END scp_updatemodulesetting;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEAFFILIATE
--------------------------------------------------------

PROCEDURE scp_updateaffiliate(i_affiliateid IN NUMBER DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_cpc IN FLOAT DEFAULT NULL,   i_cpa IN FLOAT DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_affiliates
  SET startdate = i_startdate,
    enddate = i_enddate,
    cpc = i_cpc,
    cpa = i_cpa
  WHERE affiliateid = i_affiliateid;

END scp_updateaffiliate;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEPORTALALIAS
--------------------------------------------------------

PROCEDURE scp_updateportalalias(i_portalaliasid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_httpalias IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_portalalias
  SET httpalias = i_httpalias
  WHERE portalid = i_portalid
   AND portalaliasid = i_portalaliasid;

END scp_updateportalalias;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEAFFILIATESTATS
--------------------------------------------------------

PROCEDURE scp_updateaffiliatestats(i_affiliateid IN NUMBER DEFAULT NULL,   i_clicks IN NUMBER DEFAULT NULL,   i_acquisitions IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_affiliates
  SET clicks = clicks + i_clicks,
    acquisitions = acquisitions + i_acquisitions
  WHERE vendorid = i_affiliateid
   AND(startdate < sysdate OR startdate IS NULL)
   AND(enddate > sysdate OR enddate IS NULL);

END scp_updateaffiliatestats;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEANONYMOUSUSER
--------------------------------------------------------

PROCEDURE scp_updateanonymoususer(i_userid IN CHAR DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   i_lastactivedate IN DATE DEFAULT NULL) AS
v_exists NUMBER(10,   0);
BEGIN
  BEGIN

    BEGIN
      v_exists := 0;
      SELECT COUNT(*)
      INTO v_exists
      FROM dual
      WHERE EXISTS
        (SELECT userid
         FROM {databaseOwner}scp_anonymoususers
         WHERE userid = i_userid
         AND portalid = i_portalid)
      ;

    END;

    IF v_exists != 0 THEN

      UPDATE {databaseOwner}scp_anonymoususers
      SET tabid = i_tabid,
        lastactivedate = i_lastactivedate
      WHERE userid = i_userid
       AND portalid = i_portalid;

    ELSE
      INSERT
      INTO {databaseOwner}scp_anonymoususers(userid,   portalid,   tabid,   creationdate,   lastactivedate)
      VALUES(i_userid,   i_portalid,   i_tabid,   sysdate,   i_lastactivedate);

    END IF;

  END;
END scp_updateanonymoususer;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEMODULE
--------------------------------------------------------

PROCEDURE scp_updatemodule(i_moduleid IN NUMBER DEFAULT NULL,   i_moduletitle IN nvarchar2 DEFAULT NULL,   i_alltabs IN NUMBER DEFAULT NULL,   i_header IN nclob DEFAULT NULL,   i_footer IN nclob DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_inheritviewpermissions IN NUMBER DEFAULT NULL,   i_isdeleted IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_modules
  SET moduletitle = i_moduletitle,
    alltabs = i_alltabs,
    header = i_header,
    footer = i_footer,
    startdate = i_startdate,
    enddate = i_enddate,
    inheritviewpermissions = i_inheritviewpermissions,
    isdeleted = i_isdeleted
  WHERE moduleid = i_moduleid;

END scp_updatemodule;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEPORTALALIASONINSTAL
--------------------------------------------------------

PROCEDURE scp_updateportalaliasoninstal(i_portalalias IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_portalalias
  SET httpalias = i_portalalias
  WHERE httpalias = '_default';

END scp_updateportalaliasoninstal;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATETABPERMISSION
--------------------------------------------------------

PROCEDURE scp_updatetabpermission(i_tabpermissionid IN NUMBER DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_tabpermission
  SET tabid = i_tabid,
    permissionid = i_permissionid,
    roleid = i_roleid,
    allowaccess = i_allowaccess
  WHERE tabpermissionid = i_tabpermissionid;

END scp_updatetabpermission;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEROLEGROUP
--------------------------------------------------------

PROCEDURE scp_updaterolegroup(i_rolegroupid IN NUMBER DEFAULT NULL,   i_rolegroupname IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_rolegroups
  SET rolegroupname = i_rolegroupname,
    description = i_description
  WHERE rolegroupid = i_rolegroupid;

END scp_updaterolegroup;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEPORTALSETUP
--------------------------------------------------------

PROCEDURE scp_updateportalsetup(i_portalid IN NUMBER DEFAULT NULL,   i_administratorid IN NUMBER DEFAULT NULL,   i_administratorroleid IN NUMBER DEFAULT NULL,   i_poweruserroleid IN NUMBER DEFAULT NULL,   i_registeredroleid IN NUMBER DEFAULT NULL,   i_splashtabid IN NUMBER DEFAULT NULL,   i_hometabid IN NUMBER DEFAULT NULL,   i_logintabid IN NUMBER DEFAULT NULL,   i_usertabid IN NUMBER DEFAULT NULL,   i_admintabid IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_portals
  SET administratorid = i_administratorid,
    administratorroleid = i_administratorroleid,
    poweruserroleid = i_poweruserroleid,
    registeredroleid = i_registeredroleid,
    splashtabid = i_splashtabid,
    hometabid = i_hometabid,
    logintabid = i_logintabid,
    usertabid = i_usertabid,
    admintabid = i_admintabid
  WHERE portalid = i_portalid;

END scp_updateportalsetup;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEFILECONTENT
--------------------------------------------------------

PROCEDURE scp_updatefilecontent(i_fileid IN NUMBER DEFAULT NULL,   content IN BLOB DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_files
  SET content = content
  WHERE fileid = i_fileid;

END scp_updatefilecontent;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATELISTENTRY
--------------------------------------------------------

PROCEDURE scp_updatelistentry(i_entryid IN NUMBER DEFAULT NULL,   i_listname IN nvarchar2 DEFAULT NULL,   i_value IN nvarchar2 DEFAULT NULL,   i_text IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_lists
  SET listname = i_listname,
    VALUE = i_value,
    text = i_text,
    description = i_description
  WHERE entryid = i_entryid;

END scp_updatelistentry;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEBANNER
--------------------------------------------------------

PROCEDURE scp_updatebanner(i_bannerid IN NUMBER DEFAULT NULL,   i_bannername IN nvarchar2 DEFAULT NULL,   i_imagefile IN nvarchar2 DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_impressions IN NUMBER DEFAULT NULL,   i_cpm IN FLOAT DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_bannertypeid IN NUMBER DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_groupname IN nvarchar2 DEFAULT NULL,   i_criteria IN NUMBER DEFAULT NULL,   i_width IN NUMBER DEFAULT NULL,   i_height IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_banners
  SET imagefile = i_imagefile,
    bannername = i_bannername,
    url = i_url,
    impressions = i_impressions,
    cpm = i_cpm,
    startdate = i_startdate,
    enddate = i_enddate,
    createdbyuser = i_username,
    createddate = sysdate,
    bannertypeid = i_bannertypeid,
    description = i_description,
    groupname = i_groupname,
    criteria = i_criteria,
    width = i_width,
    height = i_height
  WHERE bannerid = i_bannerid;

END scp_updatebanner;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATESCHEDULEHISTORY
--------------------------------------------------------

PROCEDURE scp_updateschedulehistory(i_schedulehistoryid IN NUMBER DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_succeeded IN NUMBER DEFAULT NULL,   i_lognotes IN nclob DEFAULT NULL,   i_nextstart IN DATE DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_schedulehistory
  SET enddate = i_enddate,
    succeeded = i_succeeded,
    lognotes = i_lognotes,
    nextstart = i_nextstart
  WHERE schedulehistoryid = i_schedulehistoryid;

END scp_updateschedulehistory;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEMODULEORDER
--------------------------------------------------------

PROCEDURE scp_updatemoduleorder(i_tabid IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_moduleorder IN NUMBER DEFAULT NULL,   i_panename IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_tabmodules
  SET moduleorder = i_moduleorder,
    panename = i_panename
  WHERE tabid = i_tabid
   AND moduleid = i_moduleid;

END scp_updatemoduleorder;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATETAB
--------------------------------------------------------

PROCEDURE scp_updatetab(i_tabid IN NUMBER DEFAULT NULL,   i_tabname IN nvarchar2 DEFAULT NULL,   i_isvisible IN NUMBER DEFAULT NULL,   i_disablelink IN NUMBER DEFAULT NULL,   i_parentid IN NUMBER DEFAULT NULL,   i_iconfile IN nvarchar2 DEFAULT NULL,   i_title IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_keywords IN nvarchar2 DEFAULT NULL,   i_isdeleted IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_skinsrc IN nvarchar2 DEFAULT NULL,   i_containersrc IN nvarchar2 DEFAULT NULL,   i_tabpath IN nvarchar2 DEFAULT NULL,   i_startdate IN DATE DEFAULT NULL,   i_enddate IN DATE DEFAULT NULL,   i_refreshinterval IN NUMBER DEFAULT NULL,   i_pageheadtext IN nvarchar2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_tabs
  SET tabname = i_tabname,
    isvisible = i_isvisible,
    disablelink = i_disablelink,
    parentid = i_parentid,
    iconfile = i_iconfile,
    title = i_title,
    description = i_description,
    keywords = i_keywords,
    isdeleted = i_isdeleted,
    url = i_url,
    skinsrc = i_skinsrc,
    containersrc = i_containersrc,
    tabpath = i_tabpath,
    startdate = i_startdate,
    enddate = i_enddate,
    refreshinterval = i_refreshinterval,
    pageheadtext = i_pageheadtext
  WHERE tabid = i_tabid;

END scp_updatetab;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEBANNERCLICKTHROUGH
--------------------------------------------------------

PROCEDURE scp_updatebannerclickthrough(i_bannerid IN NUMBER DEFAULT NULL,   i_vendorid IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_banners
  SET clickthroughs = clickthroughs + 1
  WHERE bannerid = i_bannerid
   AND vendorid = i_vendorid;

END scp_updatebannerclickthrough;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEPROPERTYDEFINITION
--------------------------------------------------------

PROCEDURE scp_updatepropertydefinition(i_propertydefinitionid IN NUMBER DEFAULT NULL,   i_datatype IN NUMBER DEFAULT NULL,   i_defaultvalue IN nvarchar2 DEFAULT NULL,   i_propertycategory IN nvarchar2 DEFAULT NULL,   i_propertyname IN nvarchar2 DEFAULT NULL,   i_required IN NUMBER DEFAULT NULL,   i_validationexpression IN nvarchar2 DEFAULT NULL,   i_vieworder IN NUMBER DEFAULT NULL,   i_visible IN NUMBER DEFAULT NULL,   i_length IN NUMBER DEFAULT NULL,   i_searchable IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_profilepropertydefinition
  SET datatype = i_datatype,
    defaultvalue = i_defaultvalue,
    propertycategory = i_propertycategory,
    propertyname = i_propertyname,
    required = i_required,
    validationexpression = i_validationexpression,
    vieworder = i_vieworder,
    visible = i_visible,
    length = i_length,
    searchable = i_searchable
  WHERE propertydefinitionid = i_propertydefinitionid;

END scp_updatepropertydefinition;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEHOSTSETTING
--------------------------------------------------------

PROCEDURE scp_updatehostsetting(i_settingname IN nvarchar2 DEFAULT NULL,   i_settingvalue IN nvarchar2 DEFAULT NULL,   i_settingissecure IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_hostsettings
  SET settingvalue = i_settingvalue,
    settingissecure = i_settingissecure
  WHERE settingname = i_settingname;

END scp_updatehostsetting;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATESEARCHITEM
--------------------------------------------------------

PROCEDURE scp_updatesearchitem(i_searchitemid IN NUMBER DEFAULT NULL,   i_title IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_author IN NUMBER DEFAULT NULL,   i_pubdate IN DATE DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_searchkey IN nvarchar2 DEFAULT NULL,   i_guid IN nvarchar2 DEFAULT NULL,   i_hitcount IN NUMBER DEFAULT NULL,   i_imagefileid IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_searchitem
  SET title = i_title,
    description = i_description,
    author = i_author,
    pubdate = i_pubdate,
    moduleid = i_moduleid,
    searchkey = i_searchkey,
    guid = i_guid,
    hitcount = i_hitcount,
    imagefileid = i_imagefileid
  WHERE searchitemid = i_searchitemid;

END scp_updatesearchitem;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEFOLDER
--------------------------------------------------------

PROCEDURE scp_updatefolder(i_portalid IN NUMBER DEFAULT NULL,   i_folderid IN NUMBER DEFAULT NULL,   i_folderpath IN VARCHAR2 DEFAULT NULL,   i_storagelocation IN NUMBER DEFAULT NULL,   i_isprotected IN NUMBER DEFAULT NULL,   i_iscached IN NUMBER DEFAULT NULL,   i_lastupdated IN DATE DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_folders
  SET folderpath = i_folderpath,
    storagelocation = i_storagelocation,
    isprotected = i_isprotected,
    iscached = i_iscached,
    lastupdated = i_lastupdated
  WHERE((portalid = i_portalid) OR(i_portalid IS NULL
   AND portalid IS NULL))
   AND folderid = i_folderid;

END scp_updatefolder;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEPROFILE
--------------------------------------------------------

PROCEDURE scp_updateprofile(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_profiledata IN nclob DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_profile
  SET profiledata = i_profiledata,
    createddate = sysdate
  WHERE userid = i_userid
   AND portalid = i_portalid;

END scp_updateprofile;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATESYSTEMMESSAGE
--------------------------------------------------------

PROCEDURE scp_updatesystemmessage(i_portalid IN NUMBER DEFAULT NULL,   i_messagename IN nvarchar2 DEFAULT NULL,   i_messagevalue IN nclob DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_systemmessages
  SET messagevalue = i_messagevalue
  WHERE((portalid = i_portalid) OR(i_portalid IS NULL
   AND portalid IS NULL))
   AND messagename = i_messagename;

END scp_updatesystemmessage;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATESEARCHITEMWORDPOSIT
--------------------------------------------------------

PROCEDURE scp_updatesearchitemwordposit(i_searchitemwordpositionid IN NUMBER DEFAULT NULL,   i_searchitemwordid IN NUMBER DEFAULT NULL,   i_contentposition IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_searchitemwordposition
  SET searchitemwordid = i_searchitemwordid,
    contentposition = i_contentposition
  WHERE searchitemwordpositionid = i_searchitemwordpositionid;

END scp_updatesearchitemwordposit;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATESCHEDULE
--------------------------------------------------------

PROCEDURE scp_updateschedule(i_scheduleid IN NUMBER DEFAULT NULL,   i_typefullname IN VARCHAR2 DEFAULT NULL,   i_timelapse IN NUMBER DEFAULT NULL,   i_timelapsemeasurement IN VARCHAR2 DEFAULT NULL,   i_retrytimelapse IN NUMBER DEFAULT NULL,   i_retrytimelapsemeasurement IN VARCHAR2 DEFAULT NULL,   i_retainhistorynum IN NUMBER DEFAULT NULL,   i_attachtoevent IN VARCHAR2 DEFAULT NULL,   i_catchupenabled IN NUMBER DEFAULT NULL,   i_enabled IN NUMBER DEFAULT NULL,   i_objectdependencies IN VARCHAR2 DEFAULT NULL,   i_servers IN VARCHAR2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_schedule
  SET typefullname = i_typefullname,
    timelapse = i_timelapse,
    timelapsemeasurement = i_timelapsemeasurement,
    retrytimelapse = i_retrytimelapse,
    retrytimelapsemeasurement = i_retrytimelapsemeasurement,
    retainhistorynum = i_retainhistorynum,
    attachtoevent = i_attachtoevent,
    catchupenabled = i_catchupenabled,
    enabled = i_enabled,
    objectdependencies = i_objectdependencies,
    servers = i_servers
  WHERE scheduleid = i_scheduleid;

END scp_updateschedule;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATESEARCHITEMWORD
--------------------------------------------------------

PROCEDURE scp_updatesearchitemword(i_searchitemwordid IN NUMBER DEFAULT NULL,   i_searchitemid IN NUMBER DEFAULT NULL,   i_searchwordsid IN NUMBER DEFAULT NULL,   i_occurrences IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_searchitemword
  SET searchitemid = i_searchitemid,
    searchwordsid = i_searchwordsid,
    occurrences = i_occurrences
  WHERE searchitemwordid = i_searchitemwordid;

END scp_updatesearchitemword;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEURLTRACKING
--------------------------------------------------------

PROCEDURE scp_updateurltracking(i_portalid IN NUMBER DEFAULT NULL,   i_url IN nvarchar2 DEFAULT NULL,   i_logactivity IN NUMBER DEFAULT NULL,   i_trackclicks IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_newwindow IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_urltracking
  SET logactivity = i_logactivity,
    trackclicks = i_trackclicks,
    newwindow = i_newwindow
  WHERE portalid = i_portalid
   AND url = i_url
   AND((moduleid = i_moduleid) OR(i_moduleid IS NULL
   AND moduleid IS NULL));

END scp_updateurltracking;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEUSER
--------------------------------------------------------

PROCEDURE scp_updateuser(i_userid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   i_firstname IN nvarchar2 DEFAULT NULL,   i_lastname IN nvarchar2 DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL,   i_displayname IN nvarchar2 DEFAULT NULL,   i_updatepassword IN NUMBER DEFAULT NULL,   i_authorised IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_users
  SET firstname = i_firstname,
    lastname = i_lastname,
    email = i_email,
    displayname = i_displayname,
    updatepassword = i_updatepassword
  WHERE userid = i_userid;

  UPDATE {databaseOwner}scp_userportals
  SET authorised = i_authorised
  WHERE userid = i_userid
   AND portalid = i_portalid;

END scp_updateuser;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEPERMISSION
--------------------------------------------------------

PROCEDURE scp_updatepermission(i_permissionid IN NUMBER DEFAULT NULL,   i_permissioncode IN VARCHAR2 DEFAULT NULL,   i_moduledefid IN NUMBER DEFAULT NULL,   i_permissionkey IN VARCHAR2 DEFAULT NULL,   i_permissionname IN VARCHAR2 DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_permission
  SET moduledefid = i_moduledefid,
    permissioncode = i_permissioncode,
    permissionkey = i_permissionkey,
    permissionname = i_permissionname
  WHERE permissionid = i_permissionid;

END scp_updatepermission;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEPORTALINFO
--------------------------------------------------------

PROCEDURE scp_updateportalinfo(i_portalid IN NUMBER DEFAULT NULL,   i_portalname IN nvarchar2 DEFAULT NULL,   i_logofile IN nvarchar2 DEFAULT NULL,   i_footertext IN nvarchar2 DEFAULT NULL,   i_expirydate IN DATE DEFAULT NULL,   i_userregistration IN NUMBER DEFAULT NULL,   i_banneradvertising IN NUMBER DEFAULT NULL,   i_currency IN CHAR DEFAULT NULL,   i_administratorid IN NUMBER DEFAULT NULL,   i_hostfee IN NUMBER DEFAULT NULL,   i_hostspace IN NUMBER DEFAULT NULL,   i_pagequota IN NUMBER DEFAULT NULL,   i_userquota IN NUMBER DEFAULT NULL,   i_paymentprocessor IN nvarchar2 DEFAULT NULL,   i_processoruserid IN nvarchar2 DEFAULT NULL,   i_processorpassword IN nvarchar2 DEFAULT NULL,   i_description IN nvarchar2 DEFAULT NULL,   i_keywords IN nvarchar2 DEFAULT NULL,   i_backgroundfile IN nvarchar2 DEFAULT NULL,   i_siteloghistory IN NUMBER DEFAULT NULL,   i_splashtabid IN NUMBER DEFAULT NULL,   i_hometabid IN NUMBER DEFAULT NULL,   i_logintabid IN NUMBER DEFAULT NULL,   i_usertabid IN NUMBER DEFAULT NULL,   i_defaultlanguage IN nvarchar2 DEFAULT NULL,   i_timezoneoffset IN NUMBER DEFAULT NULL,   i_homedirectory IN VARCHAR2 DEFAULT NULL,   i_adminaccountid IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_portals
  SET portalname = i_portalname,
    logofile = i_logofile,
    footertext = i_footertext,
    expirydate = i_expirydate,
    userregistration = i_userregistration,
    banneradvertising = i_banneradvertising,
    currency = i_currency,
    administratorid = i_administratorid,
    hostfee = i_hostfee,
    hostspace = i_hostspace,
    pagequota = i_pagequota,
    userquota = i_userquota,
    paymentprocessor = i_paymentprocessor,
    processoruserid = i_processoruserid,
    processorpassword = i_processorpassword,
    description = i_description,
    keywords = i_keywords,
    backgroundfile = i_backgroundfile,
    siteloghistory = i_siteloghistory,
    splashtabid = i_splashtabid,
    hometabid = i_hometabid,
    logintabid = i_logintabid,
    usertabid = i_usertabid,
    defaultlanguage = i_defaultlanguage,
    timezoneoffset = i_timezoneoffset,
    homedirectory = i_homedirectory,
    adminaccountid = i_adminaccountid
  WHERE portalid = i_portalid;

END scp_updateportalinfo;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATESEARCHWORD
--------------------------------------------------------

PROCEDURE scp_updatesearchword(i_searchwordsid IN NUMBER DEFAULT NULL,   i_word IN nvarchar2 DEFAULT NULL,   i_iscommon IN NUMBER DEFAULT NULL,   i_hitcount IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_searchword
  SET word = i_word,
    iscommon = i_iscommon,
    hitcount = i_hitcount
  WHERE searchwordsid = i_searchwordsid;

END scp_updatesearchword;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEMODULEPERMISSION
--------------------------------------------------------

PROCEDURE scp_updatemodulepermission(i_modulepermissionid IN NUMBER DEFAULT NULL,   i_moduleid IN NUMBER DEFAULT NULL,   i_permissionid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_allowaccess IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_modulepermission
  SET moduleid = i_moduleid,
    permissionid = i_permissionid,
    roleid = i_roleid,
    allowaccess = i_allowaccess
  WHERE modulepermissionid = i_modulepermissionid;

END scp_updatemodulepermission;

--------------------------------------------------------
--  DDL for Procedure SCP_UPDATEEVENTLOGPENDINGNOTI
--------------------------------------------------------

PROCEDURE scp_updateeventlogpendingnoti(i_logconfigid IN NUMBER DEFAULT NULL) AS
BEGIN

  UPDATE {databaseOwner}scp_eventlog
  SET lognotificationpending = 0
  WHERE lognotificationpending = 1
   AND logconfigid = i_logconfigid;

END scp_updateeventlogpendingnoti;

--------------------------------------------------------
--  DDL for Procedure SCP_LISTSEARCHITEMWORDPOSITIO
--------------------------------------------------------

PROCEDURE scp_listsearchitemwordpositio(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT searchitemwordpositionid,
    searchitemwordid,
    contentposition
  FROM {databaseOwner}scp_searchitemwordposition;
END scp_listsearchitemwordpositio;

--------------------------------------------------------
--  DDL for Procedure SCP_PURGEEVENTLOG
--------------------------------------------------------

PROCEDURE scp_purgeeventlog AS
BEGIN

  DELETE FROM {databaseOwner}scp_eventlog
  WHERE rowid IN
    (SELECT {databaseOwner}scp_eventlog.rowid
     FROM {databaseOwner}scp_eventlogconfig elc,
       {databaseOwner}scp_eventlog

     WHERE elc.keepmostrecent <
      (SELECT COUNT(*)
       FROM {databaseOwner}scp_eventlog el
       WHERE el.logconfigid = elc.id
       AND scp_eventlog.logtypekey = el.logtypekey
       AND el.logcreatedate >= scp_eventlog.logcreatedate)
    AND elc.keepmostrecent <> -1)
  ;

END scp_purgeeventlog;

--------------------------------------------------------
--  DDL for Procedure SCP_VERIFYPORTALTAB
--------------------------------------------------------

PROCEDURE scp_verifyportaltab(i_portalid IN NUMBER DEFAULT NULL,   i_tabid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT scp_tabs.tabid
  FROM {databaseOwner}scp_tabs LEFT JOIN {databaseOwner}scp_portals ON scp_tabs.portalid = scp_portals.portalid
  WHERE tabid = i_tabid
   AND(scp_portals.portalid = i_portalid OR scp_tabs.portalid IS NULL)
   AND isdeleted = 0;
END scp_verifyportaltab;

--------------------------------------------------------
--  DDL for Procedure SCP_FINDDATABASEVERSION
--------------------------------------------------------

PROCEDURE scp_finddatabaseversion(i_major IN NUMBER DEFAULT NULL,   i_minor IN NUMBER DEFAULT NULL,   i_build IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT COUNT(*)
  FROM {databaseOwner}scp_version
  WHERE major = i_major
   AND minor = i_minor
   AND build = i_build;
END scp_finddatabaseversion;

--------------------------------------------------------
--  DDL for Procedure SCP_LISTSEARCHITEMWORD
--------------------------------------------------------

PROCEDURE scp_listsearchitemword(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT searchitemwordid,
    searchitemid,
    searchwordsid,
    occurrences
  FROM {databaseOwner}scp_searchitemword;
END scp_listsearchitemword;

--------------------------------------------------------
--  DDL for Procedure SCP_PURGESCHEDULEHISTORY
--------------------------------------------------------

PROCEDURE scp_purgeschedulehistory AS
BEGIN

  DELETE FROM {databaseOwner}scp_schedulehistory
  WHERE rowid IN
    (SELECT {databaseOwner}scp_schedulehistory.rowid
     FROM {databaseOwner}scp_schedule s,
       {databaseOwner}scp_schedulehistory

     WHERE s.retainhistorynum <
      (SELECT COUNT(*)
       FROM {databaseOwner}scp_schedulehistory sh
       WHERE sh.scheduleid = scp_schedulehistory.scheduleid
       AND sh.scheduleid = s.scheduleid
       AND sh.startdate >= scp_schedulehistory.startdate)
    AND retainhistorynum <> -1);

END scp_purgeschedulehistory;

--------------------------------------------------------
--  DDL for Procedure SCP_FINDBANNERS
--------------------------------------------------------

PROCEDURE scp_findbanners(i_portalid IN NUMBER DEFAULT NULL,   i_bannertypeid IN NUMBER DEFAULT NULL,   i_groupname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT b.bannerid,
    b.vendorid,
    bannername,
    url,
    CASE
  WHEN SUBSTR(LOWER(imagefile),   6) = 'fileid' THEN
      (SELECT folder || filename
       FROM {databaseOwner}scp_files
       WHERE 'FileID=' || scp_files.fileid = imagefile)
  ELSE
    imagefile
  END imagefile,
    impressions,
    cpm,
    b.views,
    b.clickthroughs,
    startdate,
    enddate,
    bannertypeid,
    description,
    groupname,
    criteria,
    b.width,
    b.height
  FROM {databaseOwner}scp_banners b
  INNER JOIN {databaseOwner}scp_vendors v ON b.vendorid = v.vendorid
  WHERE(b.bannertypeid = i_bannertypeid OR i_bannertypeid IS NULL)
   AND(b.groupname = i_groupname OR i_groupname IS NULL)
   AND((v.portalid = i_portalid) OR(i_portalid IS NULL
   AND v.portalid IS NULL))
   AND v.authorized = 1
   AND(sysdate <= b.enddate OR b.enddate IS NULL)
  ORDER BY b.bannerid;
END scp_findbanners;

--------------------------------------------------------
--  DDL for Procedure SCP_VERIFYPORTAL
--------------------------------------------------------

PROCEDURE scp_verifyportal(i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT scp_tabs.tabid
  FROM {databaseOwner}scp_tabs
  INNER JOIN {databaseOwner}scp_portals ON scp_tabs.portalid = scp_portals.portalid
  WHERE scp_portals.portalid = i_portalid
   AND scp_tabs.taborder = 1;
END scp_verifyportal;

--------------------------------------------------------
--  DDL for Procedure SCP_ISUSERINROLE
--------------------------------------------------------

PROCEDURE scp_isuserinrole(i_userid IN NUMBER DEFAULT NULL,   i_roleid IN NUMBER DEFAULT NULL,   i_portalid IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT scp_userroles.userid,
    scp_userroles.roleid
  FROM {databaseOwner}scp_userroles
  INNER JOIN {databaseOwner}scp_roles ON scp_userroles.roleid = scp_roles.roleid
  WHERE scp_userroles.userid = i_userid
   AND scp_userroles.roleid = i_roleid
   AND scp_roles.portalid = i_portalid
   AND(scp_userroles.expirydate >= sysdate OR scp_userroles.expirydate IS NULL);
END scp_isuserinrole;

--------------------------------------------------------
--  DDL for Procedure SCP_LISTSEARCHITEM
--------------------------------------------------------

PROCEDURE scp_listsearchitem(o_rc1 OUT {databaseOwner}global_pkg.rct1) AS

BEGIN

  OPEN o_rc1 FOR

  SELECT searchitemid,
    title,
    description,
    author,
    pubdate,
    moduleid,
    searchkey,
    guid,
    hitcount,
    imagefileid
  FROM {databaseOwner}scp_searchitem;
END scp_listsearchitem;

END scpuke_pkg;
/

