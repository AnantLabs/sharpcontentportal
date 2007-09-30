/* Temp Tables for the ASPNET Provide Functions and Procedures. */
/* ASPNET_MEMBERSHIP_GETALLUSERS */
DECLARE v_exists NUMBER(10,   0);
BEGIN
  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM user_tables
  WHERE LOWER(TABLE_NAME) = LOWER('TP_PAGEINDEXFORUSERS');

  IF v_exists = 1 THEN

    EXECUTE IMMEDIATE 'DROP TABLE TP_PAGEINDEXFORUSERS';

  END IF;

END;
/

CREATE GLOBAL TEMPORARY TABLE {databaseOwner}tp_pageindexforusers(indexid NUMBER(10,   0) NOT NULL,   userid nvarchar2(51)) ON
COMMIT PRESERVE ROWS;
/
CREATE sequence sq_aspnet_indexid minvalue 0 START WITH 0 increment BY 1;
/
CREATE OR REPLACE TRIGGER tr_aspnet_indexid before INSERT ON {databaseOwner}tp_pageindexforusers FOR EACH ROW
BEGIN
  SELECT sq_aspnet_indexid.nextval
  INTO {databaseOwner}global_pkg.IDENTITY
  FROM dual;
  :new.indexid := {databaseOwner}global_pkg.IDENTITY;
END;
/

/* ASPNET_MEMBERSHIP_FINDBYNAME */
DECLARE v_exists NUMBER(10,   0);
BEGIN
  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM user_tables
  WHERE LOWER(TABLE_NAME) = LOWER('TP_PAGEINDEXFORUSERS_1');

  IF v_exists = 1 THEN

    EXECUTE IMMEDIATE 'DROP TABLE TP_PAGEINDEXFORUSERS_1';

  END IF;

END;
/

CREATE GLOBAL TEMPORARY TABLE {databaseOwner}tp_pageindexforusers_1(indexid NUMBER(10,   0) NOT NULL,   userid nvarchar2(51)) ON
COMMIT PRESERVE ROWS;
/
CREATE sequence sq_aspnet_indexid_1 minvalue 0 START WITH 0 increment BY 1;
/
CREATE OR REPLACE TRIGGER tr_aspnet_indexid_1 before INSERT ON {databaseOwner}tp_pageindexforusers_1 FOR EACH ROW
BEGIN
  SELECT sq_aspnet_indexid_1.nextval
  INTO {databaseOwner}global_pkg.IDENTITY
  FROM dual;
  :new.indexid := {databaseOwner}global_pkg.IDENTITY;
END;
/

/* ASPNET_MEMBERSHIP_FINDBYEMAIL */
DECLARE v_exists NUMBER(10,   0);
BEGIN
  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM user_tables
  WHERE LOWER(TABLE_NAME) = LOWER('TP_PAGEINDEXFORUSERS_2');

  IF v_exists = 1 THEN

    EXECUTE IMMEDIATE 'DROP TABLE TP_PAGEINDEXFORUSERS_2';

  END IF;

END;
/

CREATE GLOBAL TEMPORARY TABLE {databaseOwner}tp_pageindexforusers_2(indexid NUMBER(10,   0) NOT NULL,   userid nvarchar2(51)) ON
COMMIT PRESERVE ROWS;
/
CREATE sequence sq_aspnet_indexid_2 minvalue 0 START WITH 0 increment BY 1;
/
CREATE OR REPLACE TRIGGER tr_aspnet_indexid_2 before INSERT ON {databaseOwner}tp_pageindexforusers_2 FOR EACH ROW
BEGIN
  SELECT sq_aspnet_indexid_2.nextval
  INTO {databaseOwner}global_pkg.IDENTITY
  FROM dual;
  :new.indexid := {databaseOwner}global_pkg.IDENTITY;
END;
/

/* ASPNET_PROFILE_GETPROFILES */
DECLARE v_exists NUMBER(10,   0);
BEGIN
  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM user_tables
  WHERE LOWER(TABLE_NAME) = LOWER('TP_PAGEINDEXFORUSERS_3');

  IF v_exists = 1 THEN

    EXECUTE IMMEDIATE 'DROP TABLE TP_PAGEINDEXFORUSERS_3';

  END IF;

END;
/

CREATE GLOBAL TEMPORARY TABLE {databaseOwner}tp_pageindexforusers_3(indexid NUMBER(10,   0) NOT NULL,   userid nvarchar2(51)) ON
COMMIT PRESERVE ROWS;
/
CREATE sequence sq_aspnet_indexid_3 minvalue 0 START WITH 0 increment BY 1;
/
CREATE OR REPLACE TRIGGER tr_aspnet_indexid_3 before INSERT ON {databaseOwner}tp_pageindexforusers_3 FOR EACH ROW
BEGIN
  SELECT sq_aspnet_indexid_3.nextval
  INTO {databaseOwner}global_pkg.IDENTITY
  FROM dual;
  :new.indexid := {databaseOwner}global_pkg.IDENTITY;
END;
/

/* ASPNET_USERSINROLES_ADDTOROLES */
DECLARE v_exists NUMBER(10,   0);
BEGIN
  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM user_tables
  WHERE LOWER(TABLE_NAME) = LOWER('TP_TBNAMES');

  IF v_exists = 1 THEN

    EXECUTE IMMEDIATE 'DROP TABLE TP_TBNAMES';

  END IF;

END;
/

CREATE GLOBAL TEMPORARY TABLE {databaseOwner}tp_tbnames(name nvarchar2(256) NOT NULL PRIMARY KEY) ON
COMMIT PRESERVE ROWS;
/

DECLARE v_exists NUMBER(10,   0);
BEGIN
  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM user_tables
  WHERE LOWER(TABLE_NAME) = LOWER('TP_TBROLES');

  IF v_exists = 1 THEN

    EXECUTE IMMEDIATE 'DROP TABLE TP_TBROLES';

  END IF;

END;
/

CREATE GLOBAL TEMPORARY TABLE {databaseOwner}tp_tbroles(roleid nvarchar2(51) NOT NULL PRIMARY KEY) ON
COMMIT PRESERVE ROWS;
/

DECLARE v_exists NUMBER(10,   0);
BEGIN
  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM user_tables
  WHERE LOWER(TABLE_NAME) = LOWER('TP_TBUSERS');

  IF v_exists = 1 THEN

    EXECUTE IMMEDIATE 'DROP TABLE TP_TBUSERS';

  END IF;

END;
/

CREATE GLOBAL TEMPORARY TABLE {databaseOwner}tp_tbusers(userid nvarchar2(51) NOT NULL PRIMARY KEY) ON
COMMIT PRESERVE ROWS;
/

/* ASPNET_USERSINROLES_REMVEUSERS */
DECLARE v_exists NUMBER(10,   0);
BEGIN
  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM user_tables
  WHERE LOWER(TABLE_NAME) = LOWER('TP_TBNAMES_1');

  IF v_exists = 1 THEN

    EXECUTE IMMEDIATE 'DROP TABLE TP_TBNAMES_1';

  END IF;

END;
/

CREATE GLOBAL TEMPORARY TABLE {databaseOwner}tp_tbnames_1(name nvarchar2(256) NOT NULL PRIMARY KEY) ON
COMMIT PRESERVE ROWS;
/

DECLARE v_exists NUMBER(10,   0);
BEGIN
  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM user_tables
  WHERE LOWER(TABLE_NAME) = LOWER('TP_TBROLES_1');

  IF v_exists = 1 THEN

    EXECUTE IMMEDIATE 'DROP TABLE TP_TBROLES_1';

  END IF;

END;
/

CREATE GLOBAL TEMPORARY TABLE {databaseOwner}tp_tbroles_1(roleid nvarchar2(51) NOT NULL PRIMARY KEY) ON
COMMIT PRESERVE ROWS;
/
DECLARE v_exists NUMBER(10,   0);
BEGIN
  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM user_tables
  WHERE LOWER(TABLE_NAME) = LOWER('TP_TBUSERS_1');

  IF v_exists = 1 THEN

    EXECUTE IMMEDIATE 'DROP TABLE TP_TBUSERS_1';

  END IF;

END;
/

CREATE GLOBAL TEMPORARY TABLE {databaseOwner}tp_tbusers_1(userid nvarchar2(51) NOT NULL PRIMARY KEY) ON
COMMIT PRESERVE ROWS;
/

/* Start ASPNET Package */

CREATE OR REPLACE PACKAGE {databaseOwner}ASPNET_PROVIDER AUTHID CURRENT_USER AS
  PROCEDURE aspnet_checkschemaversion(i_feature IN nvarchar2 DEFAULT NULL,   i_compatibleschemaversion IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_membership_userexists(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_membership_emailexists(i_applicationname IN nvarchar2 DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_membership_usrkeyexists(i_applicationname IN nvarchar2 DEFAULT NULL,   i_userkey IN NVARCHAR2 DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_membership_changequest(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_newpasswordquestion IN nvarchar2 DEFAULT NULL,   i_newpasswordanswer IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_membership_updateuser(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL, i_email IN nvarchar2 DEFAULT NULL, i_requiresuniqueemail IN number DEFAULT 0, i_comment IN nclob DEFAULT NULL, i_isapproved IN NUMBER DEFAULT NULL, i_lastlogindate IN DATE DEFAULT NULL, i_lastactivitydate IN DATE DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_membership_createuser(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_password IN nvarchar2 DEFAULT NULL,   i_passwordsalt IN nvarchar2 DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL,   i_passwordquestion IN nvarchar2 DEFAULT NULL,   i_passwordanswer IN nvarchar2 DEFAULT NULL,   i_isapproved IN NUMBER DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   i_createdate IN DATE DEFAULT NULL,   i_uniqueemail IN NUMBER DEFAULT 0,   i_passwordformat IN NUMBER DEFAULT 0, o_userid OUT NVARCHAR2, o_returnvalue OUT integer);
  PROCEDURE aspnet_membership_findbyemail(i_applicationname IN nvarchar2 DEFAULT NULL,   i_emailtomatch IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_membership_findbyname(i_applicationname IN nvarchar2 DEFAULT NULL,   i_usernametomatch IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_membership_getallusers(i_applicationname IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_membership_getbyemail(i_applicationname IN nvarchar2 DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_membership_getbyname(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   i_updatelastactivity IN NUMBER DEFAULT 0,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_membership_getbyuseid(i_userid IN NVARCHAR2 DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   i_updatelastactivity IN NUMBER DEFAULT 0,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_membership_getnumonline(i_applicationname IN nvarchar2 DEFAULT NULL,   i_minutessincelastinactive IN NUMBER DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_membership_getanswer(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE aspnet_membership_getpassword(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE aspnet_membership_getpwdw4mat(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_updatelastloginactivitydate IN NUMBER DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_membership_resetpwd(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_newpassword IN nvarchar2 DEFAULT NULL,   i_maxinvalidpasswordattempts IN NUMBER DEFAULT NULL,   i_passwordattemptwindow IN NUMBER DEFAULT NULL,   i_passwordsalt IN nvarchar2 DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   i_passwordformat IN NUMBER DEFAULT 0,   o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_membership_setpassword(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_newpassword IN nvarchar2 DEFAULT NULL,   i_passwordsalt IN nvarchar2 DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   i_passwordformat IN NUMBER DEFAULT 0, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_membership_setpwdqanda(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_newpasswordquestion IN nvarchar2 DEFAULT NULL,   i_passwordanswer IN nvarchar2 DEFAULT NULL,   o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_membership_unlockuser(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_membership_updateinfo(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_updatepwdattempts IN NUMBER DEFAULT NULL,   i_iscorrect IN NUMBER DEFAULT NULL,   i_updatelastloginactivitydate IN NUMBER DEFAULT NULL,   i_maxinvalidattempts IN NUMBER DEFAULT NULL,   i_attemptwindow IN NUMBER DEFAULT NULL,   i_currenttime IN DATE DEFAULT NULL,   i_lastlogindate IN DATE DEFAULT NULL,   i_lastactivitydate IN DATE DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_profile_deleteprofiles(i_applicationname IN nvarchar2 DEFAULT NULL,   i_usernames IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_profile_setproperties(i_applicationname IN nvarchar2 DEFAULT NULL,   i_propertynames IN nclob DEFAULT NULL,   i_propertyvaluesstring IN nclob DEFAULT NULL,   i_propertyvaluesbinary IN BLOB DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_isuseranonymous IN NUMBER DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_roles_createrole(i_applicationname IN nvarchar2 DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_roles_deleterole(i_applicationname IN nvarchar2 DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL,   i_deleteonlyifroleisempty IN NUMBER DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_roles_roleexists(i_applicationname IN nvarchar2 DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_usersinroles_addtoroles(i_applicationname IN nvarchar2 DEFAULT NULL,   i_usernames IN nvarchar2 DEFAULT NULL,   i_rolenames IN nvarchar2 DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_usersinroles_findinrole(i_applicationname IN nvarchar2 DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL,   i_usernametomatch IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_usersinroles_getroles(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_usersinroles_getusers(i_applicationname IN nvarchar2 DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_usersinroles_isinrole(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_usersinroles_remveusers(i_applicationname IN nvarchar2 DEFAULT NULL,   i_usernames IN nvarchar2 DEFAULT NULL,   i_rolenames IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer);
  PROCEDURE aspnet_users_createuser(i_applicationid IN NVARCHAR2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_isuseranonymous IN NUMBER DEFAULT NULL,   i_lastactivitydate IN DATE DEFAULT NULL,   o_userid OUT NVARCHAR2, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_users_deleteuser(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_tablestodeletefrom IN NUMBER DEFAULT NULL,   o_numtablesdeletedfrom OUT NUMBER, o_returnvalue OUT INTEGER);
  PROCEDURE aspnet_applications_getappid(i_applicationname IN nvarchar2 DEFAULT NULL, o_returnvalue OUT NVARCHAR2);
  PROCEDURE aspnet_anydataintables(i_tablestocheck IN NUMBER DEFAULT NULL,   o_table OUT VARCHAR2);
  PROCEDURE aspnet_applications_createapp(i_applicationname IN nvarchar2 DEFAULT NULL,   o_applicationid OUT NVARCHAR2);
  PROCEDURE aspnet_profile_delinactprofile(i_applicationname IN nvarchar2 DEFAULT NULL,   i_profileauthoptions IN NUMBER DEFAULT NULL,   i_inactivesincedate IN DATE DEFAULT NULL,   o_rowcount OUT INTEGER);
  PROCEDURE aspnet_profile_getnuminactprof(i_applicationname IN nvarchar2 DEFAULT NULL,   i_profileauthoptions IN NUMBER DEFAULT NULL,   i_inactivesincedate IN DATE DEFAULT NULL,   o_rowcount OUT INTEGER);
  PROCEDURE aspnet_profile_getprofiles(i_applicationname IN nvarchar2 DEFAULT NULL,   i_profileauthoptions IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   i_usernametomatch IN nvarchar2 DEFAULT NULL,   i_inactivesincedate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1,   o_rowcount OUT INTEGER);
  PROCEDURE aspnet_profile_getproperties(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE aspnet_registerschemaversion(i_feature IN nvarchar2 DEFAULT NULL,   i_compatibleschemaversion IN nvarchar2 DEFAULT NULL,   i_iscurrentversion IN NUMBER DEFAULT NULL,   i_removeincompatibleschema IN NUMBER DEFAULT NULL);
  PROCEDURE aspnet_roles_getallroles(i_applicationname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1);
  PROCEDURE aspnet_unregisterschemaversion(i_feature IN nvarchar2 DEFAULT NULL,   i_compatibleschemaversion IN nvarchar2 DEFAULT NULL);
  FUNCTION dateadd(interval VARCHAR2,   adding NUMBER,   entry_date DATE) RETURN DATE;
END aspnet_provider;
/

CREATE OR REPLACE PACKAGE BODY {databaseOwner}ASPNET_PROVIDER AS

	--------------------------------------------------------
	--  DDL for Function ASPNET_CHECKSCHEMAVERSION
	--------------------------------------------------------

	PROCEDURE aspnet_checkschemaversion(i_feature IN nvarchar2 DEFAULT NULL,   i_compatibleschemaversion IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_count INTEGER;
	BEGIN

	v_count := 0;
	SELECT COUNT(*)
	INTO v_count
	FROM dual
	WHERE(EXISTS
	(SELECT *
	FROM {databaseOwner}aspnet_schemaversions
	WHERE feature = LOWER(i_feature)
	AND compatibleschemaversion = i_compatibleschemaversion))
	;

	IF v_count != 0 THEN
	o_returnvalue := 0;
	ELSE
	o_returnvalue := 1;
	END IF;    

	END aspnet_checkschemaversion;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_USEREXISTS
	--------------------------------------------------------

	PROCEDURE aspnet_membership_userexists(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_count number(10,0);
	BEGIN

	v_count := 0;
	SELECT COUNT(*)
	INTO v_count
	FROM {databaseOwner}aspnet_users u, {databaseOwner}aspnet_applications a
	WHERE u.LoweredUserName = LOWER(i_username)
	AND u.ApplicationId = a.ApplicationId
	AND a.LoweredApplicationName = LOWER(i_applicationname);

	IF v_count > 0 THEN
	o_returnvalue := 1;
	ELSE
	o_returnvalue := 0;
	END IF;

	END aspnet_membership_userexists;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_NONUNIQUEEMAIL
	--------------------------------------------------------

	PROCEDURE aspnet_membership_emailexists(i_applicationname IN nvarchar2 DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_count number(10,0);
	BEGIN

	v_count := 0;
	SELECT COUNT(*)
	INTO v_count
	FROM {databaseOwner}aspnet_Membership, {databaseOwner}aspnet_Applications
	WHERE LOWER(aspnet_Membership.Email) = LOWER(i_email)
	AND aspnet_Membership.ApplicationId = aspnet_Applications.ApplicationId
	AND aspnet_Applications.LoweredApplicationName = LOWER(i_applicationname);

	IF v_count > 0 THEN
	o_returnvalue := 1;
	ELSE
	o_returnvalue := 0;
	END IF;

	END aspnet_membership_emailexists;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_USRKEYEXISTS
	--------------------------------------------------------  

	PROCEDURE aspnet_membership_usrkeyexists(i_applicationname IN nvarchar2 DEFAULT NULL,   i_userkey IN NVARCHAR2 DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_count number(10,0);
	BEGIN

	v_count := 0;
	SELECT COUNT(*)
	INTO v_count
	FROM {databaseOwner}aspnet_Membership, {databaseOwner}aspnet_Applications
	WHERE aspnet_Membership.UserId = i_userkey
	AND aspnet_Membership.ApplicationId = aspnet_Applications.ApplicationId
	AND aspnet_Applications.LoweredApplicationName = LOWER(i_applicationname);

	IF v_count > 0 THEN
	o_returnvalue := 1;
	ELSE
	o_returnvalue := 0;
	END IF;
	END aspnet_membership_usrkeyexists;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_CHANGEQUEST
	--------------------------------------------------------

	PROCEDURE aspnet_membership_changequest(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_newpasswordquestion IN nvarchar2 DEFAULT NULL,   i_newpasswordanswer IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_userid nvarchar2(51);
	BEGIN

	v_userid := NULL;

	FOR rec IN
	(SELECT u.userid
	FROM {databaseOwner}aspnet_membership m,
	 {databaseOwner}aspnet_users u,
	 {databaseOwner}aspnet_applications a
	WHERE loweredusername = LOWER(i_username)
	AND u.applicationid = a.applicationid
	AND LOWER(i_applicationname) = a.loweredapplicationname
	AND u.userid = m.userid)
	LOOP
	v_userid := rec.userid;
	END LOOP;

	IF(v_userid IS NULL) THEN
	BEGIN
	o_returnvalue := 1;
	RETURN;
	END;
	END IF;

	UPDATE {databaseOwner}aspnet_membership
	SET passwordquestion = i_newpasswordquestion,
	passwordanswer = i_newpasswordanswer
	WHERE userid = v_userid;

	o_returnvalue := 0;
	RETURN;

	END aspnet_membership_changequest;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_UPDATEUSER
	--------------------------------------------------------

	PROCEDURE aspnet_membership_updateuser(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL, i_email IN nvarchar2 DEFAULT NULL, i_requiresuniqueemail IN number DEFAULT 0, i_comment IN nclob DEFAULT NULL, i_isapproved IN NUMBER DEFAULT NULL, i_lastlogindate IN DATE DEFAULT NULL, i_lastactivitydate IN DATE DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_exists number(1,0);
	v_transtarted NUMBER(1,0);
	v_errorcode number(10,0);
	e_exception EXCEPTION;
	BEGIN

	IF({databaseOwner}global_pkg.trancount = 0) THEN
	BEGIN
	{databaseOwner}global_pkg.inctrancount();
	v_transtarted := 1;
	END;
	ELSE
	v_transtarted := 0;
	END IF;

	IF (i_username IS NULL OR i_applicationname IS NULL) THEN
	v_errorcode := 1;
	RAISE e_exception;
	END IF;
	IF (i_email IS NULL AND i_requiresuniqueemail = 1) THEN
	v_errorcode := 2;
	RAISE e_exception;
	END IF;

	BEGIN        
	UPDATE {databaseOwner}aspnet_membership m
	SET m.email = i_email,
		m.comment_ = i_comment,
		m.isapproved = i_isapproved,
		m.lastlogindate = i_lastlogindate
	WHERE m.ApplicationId = (
		SELECT applicationid FROM {databaseOwner}aspnet_applications a
		WHERE a.loweredapplicationname = LOWER(i_applicationname))
	  AND m.userid = (
		SELECT u.userid FROM {databaseOwner}aspnet_users u
		JOIN {databaseOwner}aspnet_applications a1 ON 
		u.ApplicationId = a1.ApplicationId
		WHERE u.LoweredUserName = LOWER(i_username));
	END;

	BEGIN
	UPDATE {databaseOwner}aspnet_users u
	SET u.lastactivitydate = i_lastactivitydate
	WHERE u.ApplicationId = (
	SELECT applicationid FROM {databaseOwner}aspnet_Applications a
	WHERE a.loweredapplicationname = LOWER(i_applicationname))
	AND u.LoweredUserName = LOWER(i_username);        
	END;

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;

	IF {databaseOwner}global_pkg.trancount = 1 THEN
	  COMMIT WORK;
	END IF;

	IF {databaseOwner}global_pkg.trancount > 0 THEN
	  {databaseOwner}global_pkg.dectrancount();
	  COMMIT WORK;
	END IF;

	END;
	END IF;

	o_returnvalue := 0;

	EXCEPTION 
	WHEN e_exception THEN
	IF(v_transtarted = 1) THEN
	BEGIN
	  v_transtarted := 0;
	  {databaseOwner}global_pkg.trancount := 0;
	  ROLLBACK WORK;
	END;
	END IF;
	o_returnvalue := v_errorcode;
	WHEN OTHERS THEN
	IF(v_transtarted = 1) THEN
	BEGIN
	  v_transtarted := 0;
	  {databaseOwner}global_pkg.trancount := 0;
	  ROLLBACK WORK;
	END;
	END IF;
	o_returnvalue := -1;
	END aspnet_membership_updateuser;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_CREATEUSER
	--------------------------------------------------------

	PROCEDURE aspnet_membership_createuser(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_password IN nvarchar2 DEFAULT NULL,   i_passwordsalt IN nvarchar2 DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL,   i_passwordquestion IN nvarchar2 DEFAULT NULL,   i_passwordanswer IN nvarchar2 DEFAULT NULL,   i_isapproved IN NUMBER DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   i_createdate IN DATE DEFAULT NULL,   i_uniqueemail IN NUMBER DEFAULT 0,   i_passwordformat IN NUMBER DEFAULT 0,   o_userid OUT NVARCHAR2, o_returnvalue OUT integer) AS
	v_applicationid nvarchar2(51);
	v_newuserid nvarchar2(51);
	v_islockedout NUMBER(1,   0);
	v_lastlockoutdate DATE;
	v_failedpwdattemptcount NUMBER(10,   0);
	v_failedpwdattemptwindowstart DATE;
	v_failedpwdanswerattemptcount NUMBER(10,   0);
	v_failedpwdanwrattemptwinstart DATE;
	v_newusercreated NUMBER(1,   0);
	v_returnvalue NUMBER(10,   0);
	v_errorcode NUMBER(10,   0);
	v_transtarted NUMBER(1,   0);
	v_createdate DATE;
	v_exists NUMBER(1,   0);
	e_exception EXCEPTION;
	BEGIN

	v_applicationid := NULL;
	v_newuserid := NULL;
	v_islockedout := 0;
	v_lastlockoutdate := to_date('17540101',   'yyyymmdd');
	v_failedpwdattemptcount := 0;
	v_failedpwdattemptwindowstart := to_date('17540101',   'yyyymmdd');
	v_failedpwdanswerattemptcount := 0;
	v_failedpwdanwrattemptwinstart := to_date('17540101',   'yyyymmdd');
	v_returnvalue := 0;
	v_errorcode := 0;
	v_transtarted := 0;

	IF({databaseOwner}global_pkg.trancount = 0) THEN
	BEGIN
	{databaseOwner}global_pkg.inctrancount();
	v_transtarted := 1;
	END;
	ELSE
	v_transtarted := 0;
	END IF;

	{databaseOwner}aspnet_provider.aspnet_applications_createapp(i_applicationname,   v_applicationid);

	v_createdate := i_currenttimeutc;

	FOR rec IN
	(SELECT userid
	FROM {databaseOwner}aspnet_users
	WHERE LOWER(i_username) = loweredusername
	AND applicationid = v_applicationid)
	LOOP
	v_newuserid := rec.userid;
	END LOOP;

	IF(v_newuserid IS NULL) THEN
	BEGIN
	v_newuserid := o_userid;

	{databaseOwner}aspnet_provider.aspnet_users_createuser(v_applicationid,   i_username,   0,   v_createdate,   v_newuserid, v_returnvalue);

	v_newusercreated := 1;
	END;
	ELSE
	BEGIN
	v_newusercreated := 0;

	IF(v_newuserid <> o_userid
	 AND o_userid IS NOT NULL) THEN
	  BEGIN
		v_errorcode := 6;
		RAISE e_exception;
	  END;
	END IF;

	END;
	END IF;

	IF(v_returnvalue = -1) THEN
	BEGIN
	v_errorcode := 10;
	RAISE e_exception;
	END;
	END IF;

	BEGIN
	BEGIN
	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE(EXISTS
	  (SELECT userid
	   FROM {databaseOwner}aspnet_membership
	   WHERE v_newuserid = userid));

	END;

	IF v_exists != 0 THEN
	BEGIN
	  v_errorcode := 6;
	  RAISE e_exception;
	END;
	END IF;

	END;
	o_userid := v_newuserid;

	IF(i_uniqueemail = 1) THEN
	BEGIN
	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE(EXISTS
	  (SELECT *
	   FROM {databaseOwner}aspnet_membership m
	   WHERE applicationid = applicationid
	   AND loweredemail = LOWER(email)));

	END;

	IF v_exists != 0 THEN
	BEGIN
	  v_errorcode := 7;
	  RAISE e_exception;
	END;
	END IF;

	END IF;

	IF(v_newusercreated = 0) THEN
	BEGIN

	UPDATE {databaseOwner}aspnet_users
	SET lastactivitydate = v_createdate
	WHERE userid = userid;

	END;
	END IF;

	INSERT
	INTO {databaseOwner}aspnet_membership(applicationid,   userid,   password,   passwordsalt,   email,   loweredemail,   passwordquestion,   passwordanswer,   passwordformat,   isapproved,   islockedout,   createdate,   lastlogindate,   lastpwdchangeddate,   lastlockoutdate,   failedpwdattemptcount,   failedpwdattemptwinstart,   failedpwdanswerattemptcount,   failedpwdanswerattemptwinstart)
	VALUES(v_applicationid,   o_userid,   i_password,   i_passwordsalt,   i_email,   LOWER(i_email),   i_passwordquestion,   i_passwordanswer,   i_passwordformat,   i_isapproved,   v_islockedout,   v_createdate,   v_createdate,   v_createdate,   v_lastlockoutdate,   v_failedpwdattemptcount,   v_failedpwdattemptwindowstart,   v_failedpwdanswerattemptcount,   v_failedpwdanwrattemptwinstart);

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;

	IF {databaseOwner}global_pkg.trancount = 1 THEN
	  COMMIT WORK;
	END IF;

	IF {databaseOwner}global_pkg.trancount > 0 THEN
	  {databaseOwner}global_pkg.dectrancount();
	  COMMIT WORK;
	END IF;

	END;
	END IF;

	o_returnvalue := 0;
	RETURN;

	EXCEPTION
	WHEN e_exception THEN
	v_errorcode := -1;

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	END;
	END IF;

	o_returnvalue := v_errorcode;RETURN;
	WHEN others THEN

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	END;
	END IF;

	o_returnvalue := v_errorcode;RETURN;

	END aspnet_membership_createuser;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_FINDBYEMAIL
	--------------------------------------------------------

	PROCEDURE aspnet_membership_findbyemail(i_applicationname IN nvarchar2 DEFAULT NULL,   i_emailtomatch IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_applicationid nvarchar2(51);
	v_pagelowerbound NUMBER(10,   0);
	v_pageupperbound NUMBER(10,   0);
	v_totalrecords NUMBER(10,   0);
	BEGIN
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	(SELECT applicationid
	 FROM {databaseOwner}aspnet_applications
	 WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_applicationid := rec.applicationid;
	END LOOP;

	IF(v_applicationid IS NULL) THEN
	o_returnvalue := 0;RETURN;

	END IF;

	v_pagelowerbound := i_pagesize *i_pageindex;
	v_pageupperbound := i_pagesize -1 + v_pagelowerbound;

	DELETE FROM {databaseOwner}tp_pageindexforusers_2;

	IF(i_emailtomatch IS NULL) THEN
	INSERT
	INTO {databaseOwner}tp_pageindexforusers_2(userid)
	SELECT u.userid
	FROM {databaseOwner}aspnet_users u,
	  {databaseOwner}aspnet_membership m
	WHERE u.applicationid = v_applicationid
	 AND m.userid = u.userid
	 AND m.email IS NULL
	ORDER BY m.loweredemail;

	ELSE
	INSERT
	INTO {databaseOwner}tp_pageindexforusers_2(userid)
	SELECT u.userid
	FROM {databaseOwner}aspnet_users u,
	  {databaseOwner}aspnet_membership m
	WHERE u.applicationid = v_applicationid
	 AND m.userid = u.userid
	 AND m.loweredemail LIKE LOWER(i_emailtomatch)
	ORDER BY m.loweredemail;

	END IF;

	OPEN o_rc1 FOR

	SELECT u.username,
	m.email,
	m.passwordquestion,
	m.comment_,
	m.isapproved,
	m.createdate,
	m.lastlogindate,
	u.lastactivitydate,
	m.lastpwdchangeddate,
	u.userid,
	m.islockedout,
	m.lastlockoutdate
	FROM {databaseOwner}aspnet_membership m,
	{databaseOwner}aspnet_users u,
	{databaseOwner}tp_pageindexforusers_2 p
	WHERE u.userid = p.userid
	AND u.userid = m.userid
	AND p.indexid >= v_pagelowerbound
	AND p.indexid <= v_pageupperbound
	ORDER BY m.loweredemail;

	SELECT COUNT(*)
	INTO v_totalrecords
	FROM {databaseOwner}tp_pageindexforusers_2;

	o_returnvalue := v_totalrecords;RETURN;

	END;
	END aspnet_membership_findbyemail;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_FINDBYNAME
	--------------------------------------------------------

	PROCEDURE aspnet_membership_findbyname(i_applicationname IN nvarchar2 DEFAULT NULL,   i_usernametomatch IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_applicationid nvarchar2(51);
	v_pagelowerbound NUMBER(10,   0);
	v_pageupperbound NUMBER(10,   0);
	v_totalrecords NUMBER(10,   0);
	BEGIN
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	(SELECT applicationid
	 FROM {databaseOwner}aspnet_applications
	 WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_applicationid := rec.applicationid;
	END LOOP;

	IF(v_applicationid IS NULL) THEN
	o_returnvalue := 0;RETURN;

	END IF;

	v_pagelowerbound := i_pagesize *i_pageindex;
	v_pageupperbound := i_pagesize -1 + v_pagelowerbound;

	DELETE FROM {databaseOwner}tp_pageindexforusers_1;
	INSERT
	INTO {databaseOwner}tp_pageindexforusers_1(userid)
	SELECT u.userid
	FROM {databaseOwner}aspnet_users u,
	{databaseOwner}aspnet_membership m
	WHERE u.applicationid = v_applicationid
	AND m.userid = u.userid
	AND u.loweredusername LIKE LOWER(i_usernametomatch)
	ORDER BY u.username;

	OPEN o_rc1 FOR

	SELECT u.username,
	m.email,
	m.passwordquestion,
	m.comment_,
	m.isapproved,
	m.createdate,
	m.lastlogindate,
	u.lastactivitydate,
	m.lastpwdchangeddate,
	u.userid,
	m.islockedout,
	m.lastlockoutdate
	FROM {databaseOwner}aspnet_membership m,
	{databaseOwner}aspnet_users u,
	{databaseOwner}tp_pageindexforusers_1 p
	WHERE u.userid = p.userid
	AND u.userid = m.userid
	AND p.indexid >= v_pagelowerbound
	AND p.indexid <= v_pageupperbound
	ORDER BY u.username;

	SELECT COUNT(*)
	INTO v_totalrecords
	FROM {databaseOwner}tp_pageindexforusers_1;

	o_returnvalue := v_totalrecords;RETURN;

	END;
	END aspnet_membership_findbyname;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_GETALLUSERS
	--------------------------------------------------------

	PROCEDURE aspnet_membership_getallusers(i_applicationname IN nvarchar2 DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_applicationid nvarchar2(51);
	v_pagelowerbound NUMBER(10,   0);
	v_pageupperbound NUMBER(10,   0);
	v_totalrecords NUMBER(10,   0);
	BEGIN
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	(SELECT applicationid
	 FROM {databaseOwner}aspnet_applications
	 WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_applicationid := rec.applicationid;

	END LOOP;

	IF(v_applicationid IS NULL) THEN
	o_returnvalue := 0;RETURN;

	END IF;

	v_pagelowerbound := i_pagesize *i_pageindex;
	v_pageupperbound := i_pagesize -1 + v_pagelowerbound;

	DELETE FROM {databaseOwner}tp_pageindexforusers;
	INSERT
	INTO {databaseOwner}tp_pageindexforusers(userid)
	SELECT u.userid
	FROM {databaseOwner}aspnet_membership m,
	{databaseOwner}aspnet_users u
	WHERE u.applicationid = v_applicationid
	AND u.userid = m.userid
	ORDER BY u.username;

	v_totalrecords := SQL % rowcount;

	OPEN o_rc1 FOR

	SELECT u.username,
	m.email,
	m.passwordquestion,
	m.comment_,
	m.isapproved,
	m.createdate,
	m.lastlogindate,
	u.lastactivitydate,
	m.lastpwdchangeddate,
	u.userid,
	m.islockedout,
	m.lastlockoutdate
	FROM {databaseOwner}aspnet_membership m,
	{databaseOwner}aspnet_users u,
	{databaseOwner}tp_pageindexforusers p
	WHERE u.userid = p.userid
	AND u.userid = m.userid
	AND p.indexid >= v_pagelowerbound
	AND p.indexid <= v_pageupperbound
	ORDER BY u.username;
	o_returnvalue := v_totalrecords;RETURN;

	END;
	END aspnet_membership_getallusers;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_GETBYEMAIL
	--------------------------------------------------------

	PROCEDURE aspnet_membership_getbyemail(i_applicationname IN nvarchar2 DEFAULT NULL,   i_email IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_exists NUMBER(1,   0);
	BEGIN

	IF(i_email IS NULL) THEN

	OPEN o_rc1 FOR

	SELECT u.username
	FROM {databaseOwner}aspnet_applications a,
		{databaseOwner}aspnet_users u,
		{databaseOwner}aspnet_membership m
	WHERE LOWER(i_applicationname) = a.loweredapplicationname

	AND u.applicationid = a.applicationid
	AND u.userid = m.userid
	AND m.loweredemail IS NULL;
	ELSE

	OPEN o_rc1 FOR

	SELECT u.username
	FROM {databaseOwner}aspnet_applications a,
	{databaseOwner}aspnet_users u,
	{databaseOwner}aspnet_membership m
	WHERE LOWER(i_applicationname) = a.loweredapplicationname

	AND u.applicationid = a.applicationid
	AND u.userid = m.userid
	AND LOWER(i_email) = m.loweredemail;
	BEGIN

	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE EXISTS
	  (SELECT u.username
	   FROM {databaseOwner}aspnet_applications a,
		{databaseOwner}aspnet_users u,
		{databaseOwner}aspnet_membership m
	   WHERE LOWER(i_applicationname) = a.loweredapplicationname
	   AND u.applicationid = a.applicationid
	   AND u.userid = m.userid
	   AND LOWER(i_email) = m.loweredemail)
	;

	END;
	END IF;

	IF(v_exists = 0) THEN
	o_returnvalue := 1;RETURN;

	END IF;

	o_returnvalue := 0;RETURN;


	END aspnet_membership_getbyemail;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_GETBYNAME
	--------------------------------------------------------

	PROCEDURE aspnet_membership_getbyname(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   i_updatelastactivity IN NUMBER DEFAULT 0,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_userid nvarchar2(51);
	v_exists NUMBER(1,   0);
	BEGIN
	BEGIN

	IF(i_updatelastactivity = 1) THEN
	BEGIN

	  OPEN o_rc1 FOR
	  SELECT *
	  FROM
		(SELECT u.username,
		   u.userid,
		   m.email,
		   m.passwordquestion,
		   m.comment_,
		   m.isapproved,
		   m.islockedout,
		   m.createdate,
		   m.lastlogindate,
		   u.lastactivitydate,
		   m.lastpwdchangeddate,
		   m.lastlockoutdate,
           a.loweredapplicationname
		 FROM {databaseOwner}aspnet_applications a,
		   {databaseOwner}aspnet_users u,
		   {databaseOwner}aspnet_membership m
		 WHERE LOWER(i_applicationname) = a.loweredapplicationname

		 AND u.applicationid = a.applicationid
		 AND LOWER(i_username) = u.loweredusername
		 AND u.userid = m.userid)
	  WHERE rownum <= 1;
	  BEGIN
		v_exists := 0;
		SELECT COUNT(*)
		INTO v_exists
		FROM dual
		WHERE EXISTS
		  (SELECT u.username,
			 m.email,
			 m.passwordquestion,
			 m.comment_,
			 m.isapproved,
			 m.createdate,
			 m.lastlogindate,
			 i_currenttimeutc,
			 m.lastpwdchangeddate,
			 u.userid,
			 m.islockedout,
			 m.lastlockoutdate
		   FROM {databaseOwner}aspnet_applications a,
			 {databaseOwner}aspnet_users u,
			 {databaseOwner}aspnet_membership m
		   WHERE LOWER(i_applicationname) = a.loweredapplicationname

		   AND u.applicationid = a.applicationid
		   AND LOWER(i_username) = u.loweredusername
		   AND u.userid = m.userid);

	  END;

	  IF(v_exists = 0) THEN
		o_returnvalue := -1;
		RETURN;
	  END IF;

	  UPDATE {databaseOwner}aspnet_users
	  SET lastactivitydate = i_currenttimeutc
	  WHERE userid = v_userid;

	END;
	ELSE
	BEGIN

	  OPEN o_rc1 FOR
	  SELECT *
	  FROM
		(SELECT u.username,
		   u.userid,
		   m.email,
		   m.passwordquestion,
		   m.comment_,
		   m.isapproved,
		   m.islockedout,
		   m.createdate,
		   m.lastlogindate,
		   u.lastactivitydate,
		   m.lastpwdchangeddate,
		   m.lastlockoutdate,
           a.loweredapplicationname
		 FROM {databaseOwner}aspnet_applications a,
		   {databaseOwner}aspnet_users u,
		   {databaseOwner}aspnet_membership m
		 WHERE LOWER(i_applicationname) = a.loweredapplicationname

		 AND u.applicationid = a.applicationid
		 AND LOWER(i_username) = u.loweredusername
		 AND u.userid = m.userid)
	  WHERE rownum <= 1;
	  BEGIN

		SELECT count(*)
		INTO v_exists
		FROM dual
		WHERE EXISTS
		  (SELECT u.username, 
			 m.email,
			 m.passwordquestion,
			 m.comment_,
			 m.isapproved,
			 m.createdate,
			 m.lastlogindate,
			 u.lastactivitydate,
			 m.lastpwdchangeddate,
			 u.userid,
			 m.islockedout,
			 m.lastlockoutdate
		   FROM {databaseOwner}aspnet_applications a,
			 {databaseOwner}aspnet_users u,
			 {databaseOwner}aspnet_membership m
		   WHERE LOWER(i_applicationname) = a.loweredapplicationname

		   AND u.applicationid = a.applicationid
		   AND LOWER(i_username) = u.loweredusername
		   AND u.userid = m.userid);

	  END;

	  IF(v_exists = 0) THEN
		o_returnvalue := -1;
		RETURN;
	  END IF;

	END;
	END IF;

	o_returnvalue := 0;RETURN;

	END;
	END aspnet_membership_getbyname;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_GETBYUSEID
	--------------------------------------------------------

	PROCEDURE aspnet_membership_getbyuseid(i_userid IN NVARCHAR2 DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   i_updatelastactivity IN NUMBER DEFAULT 0,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_rowcount NUMBER(10,   0);
	BEGIN

	v_rowcount := 0;

	IF(i_updatelastactivity = 1) THEN
	BEGIN

	UPDATE {databaseOwner}aspnet_users
	SET lastactivitydate = i_currenttimeutc
	WHERE userid = i_userid;

	v_rowcount := SQL % rowcount;

	IF(v_rowcount = 0) THEN
	  o_returnvalue := -1;RETURN;

	END IF;

	END;
	END IF;

	OPEN o_rc1 FOR

	SELECT m.email,
	m.passwordquestion,
	m.comment_,
	m.isapproved,
	m.createdate,
	m.lastlogindate,
	u.lastactivitydate,
	m.lastpwdchangeddate,
	u.username,
	m.islockedout,
	m.lastlockoutdate
	FROM {databaseOwner}aspnet_users u,
	{databaseOwner}aspnet_membership m
	WHERE i_userid = u.userid
	AND u.userid = m.userid;
	BEGIN

	SELECT COUNT(*)
	INTO v_rowcount
	FROM dual
	WHERE EXISTS
	(SELECT m.email,
	   m.passwordquestion,
	   m.comment_,
	   m.isapproved,
	   m.createdate,
	   m.lastlogindate,
	   u.lastactivitydate,
	   m.lastpwdchangeddate,
	   u.username,
	   m.islockedout,
	   m.lastlockoutdate
	 FROM {databaseOwner}aspnet_users u,
	   {databaseOwner}aspnet_membership m
	 WHERE i_userid = u.userid
	 AND u.userid = m.userid)
	;

	END;

	IF(v_rowcount = 0) THEN
	o_returnvalue := -1;RETURN;

	END IF;

	o_returnvalue := 0;RETURN;


	END aspnet_membership_getbyuseid;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_GETNUMONLINE
	--------------------------------------------------------

	PROCEDURE aspnet_membership_getnumonline(i_applicationname IN nvarchar2 DEFAULT NULL,   i_minutessincelastinactive IN NUMBER DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_dateactive DATE;
	v_numonline NUMBER(10,   0);
	BEGIN

	v_dateactive := dateadd('MI',   -(i_minutessincelastinactive),   i_currenttimeutc);

	SELECT COUNT(*)
	INTO v_numonline
	FROM {databaseOwner}aspnet_users u,
	{databaseOwner}aspnet_applications a,
	{databaseOwner}aspnet_membership m
	WHERE u.applicationid = a.applicationid
	AND lastactivitydate > v_dateactive
	AND a.loweredapplicationname = LOWER(i_applicationname)
	AND u.userid = m.userid;

	o_returnvalue := v_numonline;

	END aspnet_membership_getnumonline;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_GETPASSWORD
	--------------------------------------------------------

	PROCEDURE aspnet_membership_getpassword(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL, o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
	v_userid nvarchar2(51);
	v_passwordformat NUMBER(10,   0);
	v_passwordsalt nvarchar2(128);
	v_password nvarchar2(128);
	BEGIN

	FOR rec IN
		(SELECT u.userid,
		 m.password,
		 m.passwordsalt,
		 m.passwordformat
		FROM {databaseOwner}aspnet_applications a,
		 {databaseOwner}aspnet_users u,
		 {databaseOwner}aspnet_membership m
		WHERE LOWER(i_applicationname) = a.loweredapplicationname
		AND u.applicationid = a.applicationid
		AND u.userid = m.userid
		AND LOWER(i_username) = u.loweredusername)
	LOOP
		v_userid := rec.userid;
		v_password := rec.password;
		v_passwordsalt := rec.passwordsalt;
		v_passwordformat := rec.passwordformat;
	END LOOP;

	IF(v_userid IS NOT NULL) THEN
	BEGIN
		OPEN o_rc1 FOR
		SELECT 
			v_password,
			v_passwordsalt,
			v_passwordformat
		FROM dual;
	END;
	END IF;
	
	END aspnet_membership_getpassword;
	
	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_GETANSWER
	--------------------------------------------------------

	PROCEDURE aspnet_membership_getanswer(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
	v_userid nvarchar2(51);
	v_passwordformat NUMBER(10,   0);
	v_passwordsalt nvarchar2(128);
	v_passans nvarchar2(128);
	BEGIN

	FOR rec IN
		(SELECT u.userid,
		 m.passwordsalt,
		 m.passwordformat,         
		 m.passwordanswer
		FROM {databaseOwner}aspnet_applications a,
		 {databaseOwner}aspnet_users u,
		 {databaseOwner}aspnet_membership m
		WHERE LOWER(i_applicationname) = a.loweredapplicationname
		AND u.applicationid = a.applicationid
		AND u.userid = m.userid
		AND LOWER(i_username) = u.loweredusername)
	LOOP
		v_userid := rec.userid;
		v_passwordsalt := rec.passwordsalt;
		v_passans := rec.passwordanswer;
		v_passwordformat := rec.passwordformat;
	END LOOP;

	IF(v_userid IS NOT NULL) THEN
	BEGIN
		OPEN o_rc1 FOR
		SELECT 
			v_passans,
			v_passwordsalt,
			v_passwordformat
		FROM dual;		
	END;
	END IF;	

	END aspnet_membership_getanswer;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_GETPWDW4MAT
	--------------------------------------------------------

	PROCEDURE aspnet_membership_getpwdw4mat(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_updatelastloginactivitydate IN NUMBER DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_islockedout NUMBER(1,   0);
	v_userid nvarchar2(51);
	v_password nvarchar2(128);
	v_passwordsalt nvarchar2(128);
	v_passwordformat NUMBER(10,   0);
	v_failedpwdattemptcount NUMBER(10,   0);
	v_failedpwdanswerattptcount NUMBER(10,   0);
	v_isapproved NUMBER(1,   0);
	v_lastactivitydate DATE;
	v_lastlogindate DATE;
	BEGIN
	BEGIN

	v_userid := NULL;

	FOR rec IN
	(SELECT u.userid,
	   m.islockedout,
	   password,
	   passwordformat,
	   passwordsalt,
	   failedpwdattemptcount,
	   failedpwdanswerattemptcount,
	   isapproved,
	   lastactivitydate,
	   lastlogindate
	 FROM {databaseOwner}aspnet_applications a,
	   {databaseOwner}aspnet_users u,
	   {databaseOwner}aspnet_membership m
	 WHERE LOWER(i_applicationname) = a.loweredapplicationname

	 AND u.applicationid = a.applicationid
	 AND u.userid = m.userid
	 AND LOWER(i_username) = u.loweredusername)
	LOOP
	v_userid := rec.userid;
	v_islockedout := rec.islockedout;
	v_password := rec.password;
	v_passwordformat := rec.passwordformat;
	v_passwordsalt := rec.passwordsalt;

	v_failedpwdattemptcount := rec.failedpwdattemptcount;
	v_failedpwdanswerattptcount := rec.failedpwdanswerattemptcount;
	v_isapproved := rec.isapproved;
	v_lastactivitydate := rec.lastactivitydate;

	v_lastlogindate := rec.lastlogindate;

	END LOOP;

	IF(v_userid IS NULL) THEN
	o_returnvalue := 1;RETURN;
	END IF;

	IF(v_islockedout = 1) THEN
	o_returnvalue := 99;RETURN;
	END IF;

	OPEN o_rc1 FOR
	SELECT v_password,
	v_passwordformat,
	v_passwordsalt,
	v_failedpwdattemptcount,
	v_failedpwdanswerattptcount,
	v_isapproved,
	v_lastlogindate,
	v_lastactivitydate
	FROM dual;

	IF(i_updatelastloginactivitydate = 1
	AND v_isapproved = 1) THEN
	BEGIN

	  UPDATE {databaseOwner}aspnet_membership
	  SET lastlogindate = i_currenttimeutc
	  WHERE userid = v_userid;

	  UPDATE {databaseOwner}aspnet_users
	  SET lastactivitydate = i_currenttimeutc
	  WHERE userid = v_userid;

	END;
	END IF;

	o_returnvalue := 0;RETURN;

	END;
	END aspnet_membership_getpwdw4mat;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_RESETPWD
	--------------------------------------------------------

	PROCEDURE aspnet_membership_resetpwd(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_newpassword IN nvarchar2 DEFAULT NULL,   i_maxinvalidpasswordattempts IN NUMBER DEFAULT NULL,   i_passwordattemptwindow IN NUMBER DEFAULT NULL,   i_passwordsalt IN nvarchar2 DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   i_passwordformat IN NUMBER DEFAULT 0,   o_returnvalue OUT INTEGER) AS
	v_userid nvarchar2(51);
	BEGIN
		BEGIN

		v_userid := NULL;

		FOR rec IN
		(SELECT u.userid
		 FROM {databaseOwner}aspnet_users u,
		   {databaseOwner}aspnet_applications a,
		   {databaseOwner}aspnet_membership m
		 WHERE loweredusername = LOWER(i_username)
		 AND u.applicationid = a.applicationid
		 AND LOWER(i_applicationname) = a.loweredapplicationname

		 AND u.userid = m.userid)
		LOOP
		v_userid := rec.userid;

		END LOOP;

		IF(v_userid IS NULL) THEN
		o_returnvalue := 0;
		RETURN;
		END IF;

		UPDATE {databaseOwner}aspnet_membership
		SET password = i_newpassword,
		passwordformat = i_passwordformat,
		passwordsalt = i_passwordsalt,
		failedpwdattemptcount = 0,
		failedpwdattemptwinstart = to_date('17540101',   'yyyymmdd'),
		lastpwdchangeddate = i_currenttimeutc
		WHERE userid = v_userid;

		o_returnvalue := 1;
		
		END;
	END aspnet_membership_resetpwd;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_SETPASSWORD
	--------------------------------------------------------

	PROCEDURE aspnet_membership_setpassword(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_newpassword IN nvarchar2 DEFAULT NULL,   i_passwordsalt IN nvarchar2 DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   i_passwordformat IN NUMBER DEFAULT 0, o_returnvalue OUT INTEGER) AS
	v_userid nvarchar2(51);
	BEGIN
		BEGIN

		v_userid := NULL;

		FOR rec IN
		(SELECT u.userid
		 FROM {databaseOwner}aspnet_users u,
		   {databaseOwner}aspnet_applications a,
		   {databaseOwner}aspnet_membership m
		 WHERE loweredusername = LOWER(i_username)
		 AND u.applicationid = a.applicationid
		 AND LOWER(i_applicationname) = a.loweredapplicationname

		 AND u.userid = m.userid)
		LOOP
		v_userid := rec.userid;

		END LOOP;

		IF(v_userid IS NULL) THEN
			o_returnvalue := 0;
			RETURN;
		END IF;

		UPDATE {databaseOwner}aspnet_membership
		SET password = i_newpassword,
		passwordformat = i_passwordformat,
		passwordsalt = i_passwordsalt,
		failedpwdanswerattemptcount = 0,
		failedpwdanswerattemptwinstart = to_date('17540101',   'yyyymmdd'),
		lastpwdchangeddate = i_currenttimeutc
		WHERE userid = v_userid;

		o_returnvalue := 1;
		
		END;
	END aspnet_membership_setpassword;
	
	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_SETPWDQANDA
	--------------------------------------------------------

	PROCEDURE aspnet_membership_setpwdqanda(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_newpasswordquestion IN nvarchar2 DEFAULT NULL,   i_passwordanswer IN nvarchar2 DEFAULT NULL,   o_returnvalue OUT INTEGER) AS
	v_userid nvarchar2(51);
	BEGIN
	BEGIN

	v_userid := NULL;

	FOR rec IN
	(SELECT u.userid
	 FROM {databaseOwner}aspnet_users u,
	   {databaseOwner}aspnet_applications a,
	   {databaseOwner}aspnet_membership m
	 WHERE loweredusername = LOWER(i_username)
	 AND u.applicationid = a.applicationid
	 AND LOWER(i_applicationname) = a.loweredapplicationname

	 AND u.userid = m.userid)
	LOOP
	v_userid := rec.userid;

	END LOOP;

	IF(v_userid IS NULL) THEN
	o_returnvalue := 0;
	RETURN;
	END IF;

	UPDATE {databaseOwner}aspnet_membership
	SET passwordquestion = i_newpasswordquestion,
	passwordanswer = i_passwordanswer,
	failedpwdanswerattemptcount = 0,
        failedpwdanswerattemptwinstart = to_date('17540101',   'yyyymmdd')
	WHERE userid = v_userid;

	o_returnvalue := 1;
	END;
	END aspnet_membership_setpwdqanda;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_UNLOCKUSER
	--------------------------------------------------------

	PROCEDURE aspnet_membership_unlockuser(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_userid nvarchar2(51);
	BEGIN
	BEGIN

	v_userid := NULL;

	FOR rec IN
	(SELECT u.userid
	 FROM {databaseOwner}aspnet_users u,
	   {databaseOwner}aspnet_applications a,
	   {databaseOwner}aspnet_membership m
	 WHERE loweredusername = LOWER(i_username)
	 AND u.applicationid = a.applicationid
	 AND LOWER(i_applicationname) = a.loweredapplicationname
	 AND u.userid = m.userid)
	LOOP
	v_userid := rec.userid;
	END LOOP;

	IF(v_userid IS NULL) THEN
	o_returnvalue := 0;
	RETURN;
	END IF;

	UPDATE {databaseOwner}aspnet_membership
	SET islockedout = 0,
	failedpwdattemptcount = 0,
	failedpwdattemptwinstart = to_date('17540101',   'yyyymmdd'),
	failedpwdanswerattemptcount = 0,
	failedpwdanswerattemptwinstart = to_date('17540101',   'yyyymmdd'),
	lastlockoutdate = to_date('17540101',   'yyyymmdd')
	WHERE userid = v_userid;

	o_returnvalue := 1;
	END;
	END aspnet_membership_unlockuser;

	--------------------------------------------------------
	--  DDL for Function ASPNET_MEMBERSHIP_UPDATEINFO
	--------------------------------------------------------

	PROCEDURE aspnet_membership_updateinfo(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_updatepwdattempts IN NUMBER DEFAULT NULL,   i_iscorrect IN NUMBER DEFAULT NULL,   i_updatelastloginactivitydate IN NUMBER DEFAULT NULL,   i_maxinvalidattempts IN NUMBER DEFAULT NULL,   i_attemptwindow IN NUMBER DEFAULT NULL,   i_currenttime IN DATE DEFAULT NULL,   i_lastlogindate IN DATE DEFAULT NULL,   i_lastactivitydate IN DATE DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_userid nvarchar2(51);
	v_isapproved NUMBER(1,   0);
	v_islockedout NUMBER(1,   0);
	v_lastlockoutdate DATE;
	v_failedattemptcount NUMBER(10,   0);
	v_failedattemptwinstart DATE;
	v_updatesql NVARCHAR2(1000);
	v_errorcode NUMBER(10,   0);
	v_transtarted NUMBER(1,   0);
	e_exception EXCEPTION;
	BEGIN

	v_errorcode := 0;
	v_transtarted := 0;

	IF({databaseOwner}global_pkg.trancount = 0) THEN
	BEGIN
	{databaseOwner}global_pkg.trancount := {databaseOwner}global_pkg.trancount + 1;
	v_transtarted := 1;
	END;
	ELSE
	v_transtarted := 0;
	END IF;

	FOR rec IN
		(SELECT u.userid,
		 m.isapproved,
		 m.islockedout,
		 m.lastlockoutdate,
		 m.failedpwdattemptcount,
		 m.failedpwdattemptwinstart,
		 m.failedpwdanswerattemptcount,
		 m.failedpwdanswerattemptwinstart
		FROM {databaseOwner}aspnet_applications a,
		{databaseOwner}aspnet_users u,
		{databaseOwner}aspnet_membership m
		WHERE LOWER(i_applicationname) = a.loweredapplicationname
		AND u.applicationid = a.applicationid
		AND u.userid = m.userid
		AND LOWER(i_username) = u.loweredusername)
	LOOP
		v_userid := rec.userid;
		v_isapproved := rec.isapproved;
		v_islockedout := rec.islockedout;
		v_lastlockoutdate := rec.lastlockoutdate;
		IF(i_updatepwdattempts = 1) THEN
			v_failedattemptcount := rec.failedpwdattemptcount;
			v_failedattemptwinstart := rec.failedpwdattemptwinstart;
		ELSE
			v_failedattemptcount := rec.failedpwdanswerattemptcount;
			v_failedattemptwinstart := rec.failedpwdanswerattemptwinstart;
		END IF;
	END LOOP;

	IF(v_userid IS NULL) THEN
	BEGIN
		v_errorcode := 1;
		RAISE e_exception;
	END;
	END IF;

	IF(v_islockedout = 1) THEN
	BEGIN
		v_errorcode := 2;
		RAISE e_exception;
	END;
	END IF;

	IF(i_iscorrect = 0) THEN
	BEGIN

	IF(i_currenttime > dateadd('MI',   i_attemptwindow,   v_failedattemptwinstart)) THEN
	  BEGIN
		v_failedattemptwinstart := i_currenttime;
		v_failedattemptcount := 1;
	  END;
	ELSE
	  BEGIN
		v_failedattemptwinstart := i_currenttime;
		v_failedattemptcount := v_failedattemptcount + 1;
	  END;
	END IF;

	BEGIN

	  IF(v_failedattemptcount >= i_maxinvalidattempts) THEN
		BEGIN
		  v_islockedout := 1;
		  v_lastlockoutdate := i_currenttime;
		END;
	  END IF;

	END;
	END;
	ELSE
	BEGIN

	IF(v_failedattemptcount > 0) THEN
	  BEGIN
		v_failedattemptcount := 0;
		v_failedattemptwinstart := to_date('17540101',   'yyyymmdd');
		v_lastlockoutdate := to_date('17540101',   'yyyymmdd');
	  END;
	END IF;

	END;
	END IF;

	IF(i_updatelastloginactivitydate = 1) THEN
	BEGIN

		UPDATE {databaseOwner}aspnet_users
		SET lastactivitydate = i_lastactivitydate
		WHERE userid = v_userid;

		UPDATE {databaseOwner}aspnet_membership
		SET lastlogindate = i_lastlogindate
		WHERE userid = v_userid;

	END;
	END IF;
	
	IF(i_updatepwdattempts = 1) THEN
          UPDATE {databaseOwner}aspnet_membership 
          SET islockedout = v_islockedout,
          lastlockoutdate = v_lastlockoutdate,
          failedpwdattemptcount = v_failedattemptcount, 
          failedpwdattemptwinstart = v_failedattemptwinstart
          WHERE userid = v_userid;
        ELSE
          UPDATE {databaseOwner}aspnet_membership 
          SET islockedout = v_islockedout, 
          lastlockoutdate = v_lastlockoutdate,
          failedpwdanswerattemptcount = v_failedattemptcount, 
          failedpwdanswerattemptwinstart = v_failedattemptwinstart
          WHERE userid = v_userid;
	END IF;

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;

	IF {databaseOwner}global_pkg.trancount = 1 THEN
	  COMMIT WORK;
	END IF;

	IF {databaseOwner}global_pkg.trancount > 0 THEN
	  {databaseOwner}global_pkg.trancount := {databaseOwner}global_pkg.trancount -1;
	END IF;

	END;
	END IF;

	o_returnvalue := v_errorcode;

	EXCEPTION
	WHEN e_exception THEN

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	END;
	END IF;
	o_returnvalue := v_errorcode;
	WHEN others THEN

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	END;
	END IF;
	o_returnvalue := v_errorcode;
	END aspnet_membership_updateinfo;

	--------------------------------------------------------
	--  DDL for Function ASPNET_PROFILE_DELETEPROFILES
	--------------------------------------------------------

	PROCEDURE aspnet_profile_deleteprofiles(i_applicationname IN nvarchar2 DEFAULT NULL,   i_usernames IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_username nvarchar2(256);
	v_currentpos NUMBER(10,   0);
	v_nextpos NUMBER(10,   0);
	v_numdeleted NUMBER(10,   0);
	v_deleteduser NUMBER(10,   0);
	v_transtarted NUMBER(1,   0);
	v_errorcode NUMBER(10,   0);
	v_dummy_var_integer INTEGER;
	BEGIN

	v_errorcode := 0;
	v_currentpos := 1;
	v_numdeleted := 0;
	v_transtarted := 0;

	IF({databaseOwner}global_pkg.trancount = 0) THEN
	BEGIN
	{databaseOwner}global_pkg.inctrancount;
	v_transtarted := 1;
	END;
	ELSE
	v_transtarted := 0;
	END IF;

	WHILE(v_currentpos <= LENGTH(i_usernames))
	LOOP
	BEGIN

	v_nextpos := instr(i_usernames,   ',',   v_currentpos);

	IF(v_nextpos = 0 OR v_nextpos IS NULL) THEN

	  v_nextpos := LENGTH(i_usernames) + 1;

	END IF;

	v_username := SUBSTR(i_usernames,   v_currentpos,   v_nextpos -v_currentpos);

	v_currentpos := v_nextpos + 1;

	IF(LENGTH(v_username) > 0) THEN
	  BEGIN

		v_deleteduser := 0;

		{databaseOwner}aspnet_provider.aspnet_users_deleteuser(i_applicationname,   v_username,   4,   v_deleteduser, v_dummy_var_integer);

		IF(v_deleteduser <> 0) THEN

		  v_numdeleted := v_numdeleted + 1;

		END IF;

	  END;
	END IF;

	END;
	END LOOP;

	OPEN o_rc1 FOR
	SELECT v_numdeleted
	FROM dual;

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;

	IF {databaseOwner}global_pkg.trancount = 1 THEN
	  COMMIT WORK;
	END IF;

	IF {databaseOwner}global_pkg.trancount > 0 THEN
	  {databaseOwner}global_pkg.dectrancount;
	END IF;

	END;
	END IF;

	v_transtarted := 0;
	o_returnvalue := 0;RETURN;


	EXCEPTION
	WHEN others THEN

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	END;
	END IF;

	o_returnvalue := v_errorcode;RETURN;


	END aspnet_profile_deleteprofiles;

	--------------------------------------------------------
	--  DDL for Function ASPNET_PROFILE_SETPROPERTIES
	--------------------------------------------------------

	PROCEDURE aspnet_profile_setproperties(i_applicationname IN nvarchar2 DEFAULT NULL,   i_propertynames IN nclob DEFAULT NULL,   i_propertyvaluesstring IN nclob DEFAULT NULL,   i_propertyvaluesbinary IN BLOB DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_isuseranonymous IN NUMBER DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_applicationid nvarchar2(51);
	v_errorcode NUMBER(10,   0);
	v_transtarted NUMBER(1,   0);
	v_userid nvarchar2(51);
	v_lastactivitydate DATE;
	v_dummy_var_integer INTEGER;
	v_exists NUMBER(1,   0);
	BEGIN

	v_applicationid := NULL;
	v_errorcode := 0;
	v_transtarted := 0;

	IF({databaseOwner}global_pkg.trancount = 0) THEN
	BEGIN
	{databaseOwner}global_pkg.trancount := {databaseOwner}global_pkg.trancount + 1;
	v_transtarted := 1;
	END;
	ELSE
	v_transtarted := 0;
	END IF;

	{databaseOwner}aspnet_provider.aspnet_applications_createapp(i_applicationname,   v_applicationid);

	v_userid := NULL;
	v_lastactivitydate := i_currenttimeutc;

	FOR rec IN
	(SELECT userid
	FROM {databaseOwner}aspnet_users
	WHERE applicationid = v_applicationid
	AND loweredusername = LOWER(i_username))
	LOOP
	v_userid := rec.userid;
	END LOOP;

	IF(v_userid IS NULL) THEN

	{databaseOwner}aspnet_provider.aspnet_users_createuser(v_applicationid,   i_username,   i_isuseranonymous,   v_lastactivitydate,   v_userid, v_dummy_var_integer);

	END IF;

	UPDATE {databaseOwner}aspnet_users
	SET lastactivitydate = i_currenttimeutc
	WHERE userid = v_userid;

	BEGIN
	BEGIN
	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE(EXISTS
	  (SELECT *
	   FROM {databaseOwner}aspnet_profile
	   WHERE userid = v_userid))
	;

	END;

	IF v_exists != 0 THEN

	UPDATE {databaseOwner}aspnet_profile
	SET propertynames = i_propertynames,
	  propertyvaluesstring = i_propertyvaluesstring,
	  propertyvaluesbinary = i_propertyvaluesbinary,
	  lastupdateddate = i_currenttimeutc
	WHERE userid = v_userid;

	ELSE
	INSERT
	INTO {databaseOwner}aspnet_profile(userid,   propertynames,   propertyvaluesstring,   propertyvaluesbinary,   lastupdateddate)
	VALUES(v_userid,   i_propertynames,   i_propertyvaluesstring,   i_propertyvaluesbinary,   i_currenttimeutc);

	END IF;

	END;

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;

	IF {databaseOwner}global_pkg.trancount = 1 THEN
	  COMMIT WORK;
	END IF;

	IF {databaseOwner}global_pkg.trancount > 0 THEN
	  {databaseOwner}global_pkg.trancount := {databaseOwner}global_pkg.trancount -1;
	END IF;

	END;
	END IF;

	o_returnvalue := 0;

	EXCEPTION
	WHEN others THEN
	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	END;
	END IF;
	o_returnvalue := v_errorcode;
	END aspnet_profile_setproperties;

	--------------------------------------------------------
	--  DDL for Function ASPNET_ROLES_CREATEROLE
	--------------------------------------------------------

	PROCEDURE aspnet_roles_createrole(i_applicationname IN nvarchar2 DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_applicationid nvarchar2(51);
	v_errorcode NUMBER(10,   0);
	v_transtarted NUMBER(1,   0);
	v_exists NUMBER(1,   0);
	e_exception

	EXCEPTION;
	BEGIN

	v_applicationid := NULL;

	v_errorcode := 0;
	v_transtarted := 0;

	IF({databaseOwner}global_pkg.trancount = 0) THEN
	BEGIN
	{databaseOwner}global_pkg.inctrancount;
	v_transtarted := 1;
	END;
	ELSE
	v_transtarted := 0;
	END IF;

	{databaseOwner}aspnet_provider.aspnet_applications_createapp(i_applicationname,   v_applicationid);

	BEGIN
	BEGIN
	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE(EXISTS
	  (SELECT roleid
	   FROM {databaseOwner}aspnet_roles
	   WHERE loweredrolename = LOWER(i_rolename)
	   AND applicationid = v_applicationid))
	;

	END;

	IF v_exists != 0 THEN
	BEGIN
	  v_errorcode := 1;
	  RAISE e_exception;
	END;
	END IF;

	END;
	INSERT
	INTO {databaseOwner}aspnet_roles(applicationid,   rolename,   loweredrolename)
	VALUES(v_applicationid,   i_rolename,   LOWER(i_rolename));

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;

	IF {databaseOwner}global_pkg.trancount = 1 THEN
	  COMMIT WORK;
	END IF;

	IF {databaseOwner}global_pkg.trancount > 0 THEN
	  {databaseOwner}global_pkg.dectrancount;
	END IF;

	END;
	END IF;

	o_returnvalue := 0;

	EXCEPTION
	WHEN e_exception THEN
	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	END;
	END IF;
	o_returnvalue := v_errorcode;
	WHEN others THEN
	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	END;
	END IF;
	o_returnvalue := v_errorcode;
	END aspnet_roles_createrole;

	--------------------------------------------------------
	--  DDL for Function ASPNET_ROLES_DELETEROLE
	--------------------------------------------------------

	PROCEDURE aspnet_roles_deleterole(i_applicationname IN nvarchar2 DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL,   i_deleteonlyifroleisempty IN NUMBER DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_applicationid nvarchar2(51);
	v_errorcode NUMBER(10,   0);
	v_transtarted NUMBER(1,   0);
	v_roleid nvarchar2(51);
	v_exists NUMBER(1,   0);
	e_exception

	EXCEPTION;
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	(SELECT applicationid
	FROM {databaseOwner}aspnet_applications
	WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_applicationid := rec.applicationid;

	END LOOP;

	IF(v_applicationid IS NULL) THEN
	o_returnvalue := 1;
	RETURN;
	END IF;

	v_errorcode := 0;
	v_transtarted := 0;

	IF({databaseOwner}global_pkg.trancount = 0) THEN
	BEGIN
	{databaseOwner}global_pkg.trancount := {databaseOwner}global_pkg.trancount + 1;
	v_transtarted := 1;
	END;
	ELSE
	v_transtarted := 0;
	END IF;

	v_roleid := NULL;

	FOR rec IN
	(SELECT roleid
	FROM {databaseOwner}aspnet_roles
	WHERE loweredrolename = LOWER(i_rolename)
	AND applicationid = v_applicationid)
	LOOP
	v_roleid := rec.roleid;

	END LOOP;

	IF(v_roleid IS NULL) THEN
	BEGIN

	v_errorcode := 1;

	RAISE e_exception;
	END;
	END IF;

	IF(i_deleteonlyifroleisempty <> 0) THEN
	BEGIN

	BEGIN
	  BEGIN
		v_exists := 0;
		SELECT COUNT(*)
		INTO v_exists
		FROM dual
		WHERE(EXISTS
		  (SELECT roleid
		   FROM {databaseOwner}aspnet_usersinroles
		   WHERE roleid = v_roleid))
		;

	  END;

	  IF v_exists != 0 THEN
		BEGIN
		  v_errorcode := 2;
		  RAISE e_exception;
		END;
	  END IF;

	END;
	END;
	END IF;

	DELETE FROM {databaseOwner}aspnet_usersinroles
	WHERE roleid = v_roleid;

	DELETE FROM {databaseOwner}aspnet_roles
	WHERE roleid = v_roleid
	AND applicationid = v_applicationid;

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;

	IF {databaseOwner}global_pkg.trancount = 1 THEN
	  COMMIT WORK;
	END IF;

	IF {databaseOwner}global_pkg.trancount > 0 THEN
	  {databaseOwner}global_pkg.trancount := {databaseOwner}global_pkg.trancount -1;
	END IF;

	END;
	END IF;

	o_returnvalue := 0;

	EXCEPTION
	WHEN e_exception THEN
	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	END;
	END IF;
	o_returnvalue := v_errorcode;
	WHEN others THEN
	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	END;
	END IF;
	o_returnvalue := v_errorcode;
	END aspnet_roles_deleterole;

	--------------------------------------------------------
	--  DDL for Function ASPNET_ROLES_ROLEEXISTS
	--------------------------------------------------------

	PROCEDURE aspnet_roles_roleexists(i_applicationname IN nvarchar2 DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_applicationid nvarchar2(51);
	v_exists NUMBER(1,   0);
	BEGIN
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	(SELECT applicationid
	 FROM {databaseOwner}aspnet_applications
	 WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_applicationid := rec.applicationid;

	END LOOP;

	IF(v_applicationid IS NULL) THEN
	o_returnvalue := 0;
	RETURN;
	END IF;

	BEGIN
	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE(EXISTS
	  (SELECT rolename
	   FROM {databaseOwner}aspnet_roles
	   WHERE LOWER(i_rolename) = loweredrolename
	   AND applicationid = v_applicationid))
	;

	END;

	IF v_exists != 0 THEN
	o_returnvalue := 1;
	ELSE
	o_returnvalue := 0;
	END IF;

	END;
	END aspnet_roles_roleexists;

	--------------------------------------------------------
	--  DDL for Function ASPNET_USERSINROLES_ADDTOROLES
	--------------------------------------------------------

	PROCEDURE aspnet_usersinroles_addtoroles(i_applicationname IN nvarchar2 DEFAULT NULL,   i_usernames IN nvarchar2 DEFAULT NULL,   i_rolenames IN nvarchar2 DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_appid nvarchar2(51);
	v_transtarted NUMBER(1,   0);
	v_num NUMBER;
	v_pos NUMBER;
	v_nextpos NUMBER;
	v_name nvarchar2(50);
	v_exists NUMBER(1,   0);
	BEGIN

	v_appid := NULL;

	FOR rec IN
	(SELECT applicationid
	FROM {databaseOwner}aspnet_applications
	WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_appid := rec.applicationid;
	END LOOP;

	IF(v_appid IS NULL) THEN
	o_returnvalue := 2;RETURN;

	END IF;

	v_transtarted := 0;

	IF({databaseOwner}global_pkg.trancount = 0) THEN
	BEGIN
	{databaseOwner}global_pkg.inctrancount;
	v_transtarted := 1;
	END;
	END IF;

	DELETE FROM {databaseOwner}tp_tbnames;

	DELETE FROM {databaseOwner}tp_tbroles;

	DELETE FROM {databaseOwner}tp_tbusers;

	v_num := 0;
	v_pos := 1;

	WHILE(v_pos <= LENGTH(i_rolenames))
	LOOP
	BEGIN

	v_nextpos := instr(i_rolenames,   ',',   v_pos);

	IF(v_nextpos = 0 OR v_nextpos IS NULL) THEN

	  v_nextpos := LENGTH(i_rolenames) + 1;

	END IF;

	v_name := TRIM(SUBSTR(i_rolenames,   v_pos,   v_nextpos -v_pos));

	v_pos := v_nextpos + 1;

	INSERT
	INTO {databaseOwner}tp_tbnames
	VALUES(v_name);

	v_num := v_num + 1;
	END;
	END LOOP;

	INSERT
	INTO {databaseOwner}tp_tbroles
	SELECT roleid
	FROM {databaseOwner}aspnet_roles ar,
	{databaseOwner}tp_tbnames t
	WHERE LOWER(t.name) = ar.loweredrolename
	AND ar.applicationid = v_appid;

	IF(SQL % rowcount <> v_num) THEN
	BEGIN

	OPEN o_rc1 FOR
	SELECT *
	FROM
	  (SELECT name
	   FROM {databaseOwner}tp_tbnames
	   WHERE LOWER(v_name) NOT IN
		(SELECT ar.loweredrolename
		 FROM {databaseOwner}aspnet_roles ar,
		   {databaseOwner}tp_tbroles r
		 WHERE r.roleid = ar.roleid)
	  )
	WHERE rownum <= 1;

	IF(v_transtarted = 1) THEN
	  {databaseOwner}global_pkg.trancount := 0;
	  ROLLBACK WORK;
	END IF;

	o_returnvalue := 2;RETURN;

	END;
	END IF;

	DELETE FROM {databaseOwner}tp_tbnames
	WHERE 1 = 1;

	v_num := 0;
	v_pos := 1;

	WHILE(v_pos <= LENGTH(i_usernames))
	LOOP
	BEGIN

	v_nextpos := instr(i_usernames,   ',',   v_pos);

	IF(v_nextpos = 0 OR v_nextpos IS NULL) THEN

	  v_nextpos := LENGTH(i_usernames) + 1;

	END IF;

	v_name := TRIM(SUBSTR(i_usernames,   v_pos,   v_nextpos -v_pos));

	v_pos := v_nextpos + 1;

	INSERT
	INTO {databaseOwner}tp_tbnames
	VALUES(v_name);

	v_num := v_num + 1;
	END;
	END LOOP;

	INSERT
	INTO {databaseOwner}tp_tbusers
	SELECT userid
	FROM {databaseOwner}aspnet_users ar,
	{databaseOwner}tp_tbnames t
	WHERE LOWER(t.name) = ar.loweredusername
	AND ar.applicationid = v_appid;

	IF(SQL % rowcount <> v_num) THEN
	BEGIN

	DELETE FROM {databaseOwner}tp_tbnames
	WHERE LOWER(v_name) IN
	  (SELECT loweredusername
	   FROM {databaseOwner}aspnet_users au,
		 {databaseOwner}tp_tbusers u
	   WHERE au.userid = u.userid)
	;

	INSERT
	INTO {databaseOwner}aspnet_users(applicationid,   userid,   username,   loweredusername,   isanonymous,   lastactivitydate)
	SELECT v_appid,
	  sys_guid(),
	  name,
	  LOWER(name),
	  0,
	  i_currenttimeutc
	FROM {databaseOwner}tp_tbnames;

	INSERT
	INTO {databaseOwner}tp_tbusers
	SELECT userid
	FROM {databaseOwner}aspnet_users au,
	  {databaseOwner}tp_tbnames t
	WHERE LOWER(t.name) = au.loweredusername
	 AND au.applicationid = v_appid;

	END;
	END IF;

	BEGIN
	BEGIN
	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE(EXISTS
	  (SELECT *
	   FROM {databaseOwner}aspnet_usersinroles ur,    {databaseOwner}tp_tbusers tu,    {databaseOwner}tp_tbroles tr
	   WHERE tu.userid = ur.userid
	   AND tr.roleid = ur.roleid))
	;

	END;

	IF v_exists != 0 THEN
	BEGIN

	  OPEN o_rc1 FOR
	  SELECT *
	  FROM
		(SELECT username,
		   rolename
		 FROM {databaseOwner}aspnet_usersinroles ur,
		   {databaseOwner}tp_tbusers tu,
		   {databaseOwner}tp_tbroles tr,
		   {databaseOwner}aspnet_users u,
		   {databaseOwner}aspnet_roles r
		 WHERE u.userid = tu.userid
		 AND r.roleid = tr.roleid
		 AND tu.userid = ur.userid
		 AND tr.roleid = ur.roleid)
	  WHERE rownum <= 1;

	  IF(v_transtarted = 1) THEN
		{databaseOwner}global_pkg.trancount := 0;
		ROLLBACK WORK;
	  END IF;

	  o_returnvalue := 3;RETURN;

	END;
	END IF;

	END;
	INSERT
	INTO {databaseOwner}aspnet_usersinroles(userid,   roleid)
	SELECT userid,
	roleid
	FROM {databaseOwner}tp_tbusers,
	{databaseOwner}tp_tbroles;

	IF(v_transtarted = 1) THEN

	IF {databaseOwner}global_pkg.trancount = 1 THEN
	COMMIT WORK;
	END IF;

	IF {databaseOwner}global_pkg.trancount > 0 THEN
	{databaseOwner}global_pkg.dectrancount;
	END IF;

	END IF;

	o_returnvalue := 0;RETURN;


	END aspnet_usersinroles_addtoroles;

	--------------------------------------------------------
	--  DDL for Function ASPNET_USERSINROLES_FINDINROLE
	--------------------------------------------------------

	PROCEDURE aspnet_usersinroles_findinrole(i_applicationname IN nvarchar2 DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL,   i_usernametomatch IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_applicationid nvarchar2(51);
	v_roleid nvarchar2(51);
	BEGIN
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	(SELECT applicationid
	 FROM {databaseOwner}aspnet_applications
	 WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_applicationid := rec.applicationid;
	END LOOP;

	IF(v_applicationid IS NULL) THEN
	o_returnvalue := 1;RETURN;
	END IF;

	v_roleid := NULL;

	FOR rec IN
	(SELECT roleid
	 FROM {databaseOwner}aspnet_roles
	 WHERE LOWER(i_rolename) = loweredrolename
	 AND applicationid = v_applicationid)
	LOOP
	v_roleid := rec.roleid;
	END LOOP;

	IF(v_roleid IS NULL) THEN
	o_returnvalue := 1;RETURN;

	END IF;

	OPEN o_rc1 FOR

	SELECT u.username
	FROM {databaseOwner}aspnet_users u,
	{databaseOwner}aspnet_usersinroles ur
	WHERE u.userid = ur.userid
	AND v_roleid = ur.roleid
	AND u.applicationid = v_applicationid
	AND loweredusername LIKE LOWER(i_usernametomatch)
	ORDER BY u.username;

	o_returnvalue := 0;RETURN;

	END;
	END aspnet_usersinroles_findinrole;

	--------------------------------------------------------
	--  DDL for Function ASPNET_USERSINROLES_GETROLES
	--------------------------------------------------------

	PROCEDURE aspnet_usersinroles_getroles(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_applicationid nvarchar2(51);
	v_userid nvarchar2(51);
	BEGIN
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	(SELECT applicationid
	 FROM {databaseOwner}aspnet_applications
	 WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_applicationid := rec.applicationid;
	END LOOP;

	IF(v_applicationid IS NULL) THEN
	o_returnvalue := 1;RETURN;

	END IF;

	v_userid := NULL;

	FOR rec IN
	(SELECT userid
	 FROM {databaseOwner}aspnet_users
	 WHERE loweredusername = LOWER(i_username)
	 AND applicationid = v_applicationid)
	LOOP
	v_userid := rec.userid;
	END LOOP;

	IF(v_userid IS NULL) THEN
	o_returnvalue := 1;RETURN;

	END IF;

	OPEN o_rc1 FOR

	SELECT r.rolename
	FROM {databaseOwner}aspnet_roles r,
	{databaseOwner}aspnet_usersinroles ur
	WHERE r.roleid = ur.roleid
	AND r.applicationid = v_applicationid
	AND ur.userid = v_userid
	ORDER BY r.rolename;
	o_returnvalue := 0;RETURN;

	END;
	END aspnet_usersinroles_getroles;

	--------------------------------------------------------
	--  DDL for Function ASPNET_USERSINROLES_GETUSERS
	--------------------------------------------------------

	PROCEDURE aspnet_usersinroles_getusers(i_applicationname IN nvarchar2 DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_applicationid nvarchar2(51);
	v_roleid nvarchar2(51);
	BEGIN
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	(SELECT applicationid
	 FROM {databaseOwner}aspnet_applications
	 WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_applicationid := rec.applicationid;

	END LOOP;

	IF(v_applicationid IS NULL) THEN
	o_returnvalue := 1;RETURN;

	END IF;

	v_roleid := NULL;

	FOR rec IN
	(SELECT roleid
	 FROM {databaseOwner}aspnet_roles
	 WHERE LOWER(i_rolename) = loweredrolename
	 AND applicationid = v_applicationid)
	LOOP
	v_roleid := rec.roleid;

	END LOOP;

	IF(v_roleid IS NULL) THEN
	o_returnvalue := 1;RETURN;
	END IF;

	OPEN o_rc1 FOR

	SELECT u.username
	FROM {databaseOwner}aspnet_users u,
	{databaseOwner}aspnet_usersinroles ur
	WHERE u.userid = ur.userid
	AND v_roleid = ur.roleid
	AND u.applicationid = v_applicationid
	ORDER BY u.username;
	o_returnvalue := 0;RETURN;
	END;
	END aspnet_usersinroles_getusers;

	--------------------------------------------------------
	--  DDL for Function ASPNET_USERSINROLES_ISINROLE
	--------------------------------------------------------

	PROCEDURE aspnet_usersinroles_isinrole(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_rolename IN nvarchar2 DEFAULT NULL, o_returnvalue OUT INTEGER) AS
	v_applicationid nvarchar2(51);
	v_userid nvarchar2(51);
	v_roleid nvarchar2(51);
	v_exists NUMBER(1,   0);
	BEGIN
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	(SELECT applicationid
	 FROM {databaseOwner}aspnet_applications
	 WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_applicationid := rec.applicationid;
	END LOOP;

	IF(v_applicationid IS NULL) THEN
	o_returnvalue := 2;
	RETURN;
	END IF;

	v_userid := NULL;
	v_roleid := NULL;

	FOR rec IN
	(SELECT userid
	 FROM {databaseOwner}aspnet_users
	 WHERE loweredusername = LOWER(i_username)
	 AND applicationid = v_applicationid)
	LOOP
	v_userid := rec.userid;
	END LOOP;

	IF(v_userid IS NULL) THEN
	o_returnvalue := 2;
	RETURN;
	END IF;

	FOR rec IN
	(SELECT roleid
	 FROM {databaseOwner}aspnet_roles
	 WHERE loweredrolename = LOWER(i_rolename)
	 AND applicationid = v_applicationid)
	LOOP
	v_roleid := rec.roleid;

	END LOOP;

	IF(v_roleid IS NULL) THEN
	o_returnvalue := 3;
	RETURN;
	END IF;

	BEGIN
	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE(EXISTS
	  (SELECT *
	   FROM {databaseOwner}aspnet_usersinroles
	   WHERE userid = v_userid
	   AND roleid = v_roleid))
	;

	END;

	IF v_exists != 0 THEN
	o_returnvalue := 1;
	ELSE
	o_returnvalue := 0;
	END IF;

	END;
	END aspnet_usersinroles_isinrole;

	--------------------------------------------------------
	--  DDL for Function ASPNET_USERSINROLES_REMVEUSERS
	--------------------------------------------------------

	PROCEDURE aspnet_usersinroles_remveusers(i_applicationname IN nvarchar2 DEFAULT NULL,   i_usernames IN nvarchar2 DEFAULT NULL,   i_rolenames IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_returnvalue OUT integer) AS
	v_appid nvarchar2(51);
	v_transtarted NUMBER(1,   0);
	v_num NUMBER;
	v_pos NUMBER;
	v_nextpos NUMBER;
	v_name nvarchar2(50);
	v_countall NUMBER;
	v_countu NUMBER;
	v_countr NUMBER;
	v_exists NUMBER(1,   0);
	BEGIN

	v_appid := NULL;

	FOR rec IN
	(SELECT applicationid
	FROM {databaseOwner}aspnet_applications
	WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_appid := rec.applicationid;
	END LOOP;

	IF(v_appid IS NULL) THEN
	o_returnvalue := 2;RETURN;

	END IF;

	v_transtarted := 0;

	IF({databaseOwner}global_pkg.trancount = 0) THEN
	BEGIN
	{databaseOwner}global_pkg.inctrancount;
	v_transtarted := 1;
	END;
	END IF;

	DELETE FROM {databaseOwner}tp_tbnames_1;

	DELETE FROM {databaseOwner}tp_tbroles_1;

	DELETE FROM {databaseOwner}tp_tbusers_1;
	v_num := 0;
	v_pos := 1;

	WHILE(v_pos <= LENGTH(i_rolenames))
	LOOP
	BEGIN

	v_nextpos := instr(i_rolenames,   ',',   v_pos);

	IF(v_nextpos = 0 OR v_nextpos IS NULL) THEN

	  v_nextpos := LENGTH(i_rolenames) + 1;

	END IF;

	v_name := TRIM(SUBSTR(i_rolenames,   v_pos,   v_nextpos -v_pos));

	v_pos := v_nextpos + 1;

	INSERT
	INTO {databaseOwner}tp_tbnames_1
	VALUES(v_name);
	v_num := v_num + 1;

	END;
	END LOOP;

	INSERT
	INTO {databaseOwner}tp_tbroles_1
	SELECT roleid
	FROM {databaseOwner}aspnet_roles ar,
	{databaseOwner}tp_tbnames_1 t
	WHERE LOWER(t.name) = ar.loweredrolename
	AND ar.applicationid = v_appid;

	v_countr := SQL % rowcount;

	IF(v_countr <> v_num) THEN
	BEGIN

	OPEN o_rc1 FOR
	SELECT *
	FROM
	  (SELECT '',
		 name
	   FROM {databaseOwner}tp_tbnames_1
	   WHERE LOWER(name) NOT IN
		(SELECT ar.loweredrolename
		 FROM {databaseOwner}aspnet_roles ar,
		   {databaseOwner}tp_tbroles_1 r
		 WHERE r.roleid = ar.roleid)
	  )
	WHERE rownum <= 1;

	IF(v_transtarted = 1) THEN
	  {databaseOwner}global_pkg.trancount := 0;
	  ROLLBACK WORK;
	END IF;

	o_returnvalue := 2;RETURN;
	END;
	END IF;

	DELETE FROM {databaseOwner}tp_tbnames_1
	WHERE 1 = 1;
	v_num := 0;
	v_pos := 1;

	WHILE(v_pos <= LENGTH(i_usernames))
	LOOP
	BEGIN

	v_nextpos := instr(i_usernames,   ',',   v_pos);

	IF(v_nextpos = 0 OR v_nextpos IS NULL) THEN

	  v_nextpos := LENGTH(i_usernames) + 1;

	END IF;

	v_name := TRIM(SUBSTR(i_usernames,   v_pos,   v_nextpos -v_pos));

	v_pos := v_nextpos + 1;

	INSERT
	INTO {databaseOwner}tp_tbnames_1
	VALUES(v_name);

	v_num := v_num + 1;

	END;
	END LOOP;

	INSERT
	INTO {databaseOwner}tp_tbusers_1
	SELECT userid
	FROM {databaseOwner}aspnet_users ar,
	{databaseOwner}tp_tbnames_1 t
	WHERE LOWER(t.name) = ar.loweredusername
	AND ar.applicationid = v_appid;

	v_countu := SQL % rowcount;

	IF(v_countu <> v_num) THEN
	BEGIN

	OPEN o_rc1 FOR
	SELECT *
	FROM
	  (SELECT name,
		 ''
	   FROM {databaseOwner}tp_tbnames_1
	   WHERE LOWER(name) NOT IN
		(SELECT au.loweredusername
		 FROM {databaseOwner}aspnet_users au,
		   {databaseOwner}tp_tbusers_1 u
		 WHERE u.userid = au.userid)
	  )
	WHERE rownum <= 1;

	IF(v_transtarted = 1) THEN
	  {databaseOwner}global_pkg.trancount := 0;
	  ROLLBACK WORK;
	END IF;

	o_returnvalue := 1;RETURN;

	END;
	END IF;

	SELECT COUNT(*)
	INTO v_countall
	FROM {databaseOwner}aspnet_usersinroles ur,
	{databaseOwner}tp_tbusers_1 u,
	{databaseOwner}tp_tbroles_1 r
	WHERE ur.userid = u.userid
	AND ur.roleid = r.roleid;

	IF(v_countall <> v_countu *v_countr) THEN
	BEGIN

	OPEN o_rc1 FOR
	SELECT *
	FROM
	  (SELECT username,
		 rolename
	   FROM {databaseOwner}tp_tbusers_1 tu,
		 {databaseOwner}tp_tbroles_1 tr,
		 {databaseOwner}aspnet_users u,
		 {databaseOwner}aspnet_roles r
	   WHERE u.userid = tu.userid
	   AND r.roleid = tr.roleid
	   AND tu.userid NOT IN
		(SELECT ur.userid
		 FROM {databaseOwner}aspnet_usersinroles ur
		 WHERE ur.roleid = tr.roleid)
	  AND tr.roleid NOT IN
		(SELECT ur.roleid
		 FROM {databaseOwner}aspnet_usersinroles ur
		 WHERE ur.userid = tu.userid)
	  )
	WHERE rownum <= 1;

	IF(v_transtarted = 1) THEN
	  {databaseOwner}global_pkg.trancount := 0;
	  ROLLBACK WORK;
	END IF;

	o_returnvalue := 3;RETURN;

	END;
	END IF;

	DELETE FROM {databaseOwner}aspnet_usersinroles
	WHERE userid IN
	(SELECT userid
	FROM {databaseOwner}tp_tbusers_1)
	AND roleid IN
	(SELECT roleid
	FROM {databaseOwner}tp_tbroles_1)
	;

	IF(v_transtarted = 1) THEN

	IF {databaseOwner}global_pkg.trancount = 1 THEN
	COMMIT WORK;
	END IF;

	IF {databaseOwner}global_pkg.trancount > 0 THEN
	{databaseOwner}global_pkg.trancount := {databaseOwner}global_pkg.trancount -1;
	END IF;

	END IF;

	o_returnvalue := 0;RETURN;


	END aspnet_usersinroles_remveusers;

	--------------------------------------------------------
	--  DDL for Function ASPNET_USERS_CREATEUSER
	--------------------------------------------------------

	PROCEDURE aspnet_users_createuser(i_applicationid IN NVARCHAR2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_isuseranonymous IN NUMBER DEFAULT NULL,   i_lastactivitydate IN DATE DEFAULT NULL,   o_userid OUT NVARCHAR2, o_returnvalue OUT INTEGER) AS
	v_exists NUMBER(1,   0);
	BEGIN

	IF(o_userid IS NULL) THEN
	o_userid := sys_guid();
	ELSE
	BEGIN

	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE(EXISTS
	  (SELECT userid
	   FROM {databaseOwner}aspnet_users
	   WHERE userid = o_userid))
	;

	IF v_exists != 0 THEN
	  o_returnvalue := -1;
	  RETURN;
	END IF;

	END;
	END IF;

	INSERT
	INTO {databaseOwner}aspnet_users(applicationid,   userid,   username,   loweredusername,   isanonymous,   lastactivitydate)
	VALUES(i_applicationid,   o_userid,   i_username,   LOWER(i_username),   i_isuseranonymous,   i_lastactivitydate);
	o_returnvalue := 0;

	END aspnet_users_createuser;

	--------------------------------------------------------
	--  DDL for Function ASPNET_USERS_DELETEUSER
	--------------------------------------------------------

	PROCEDURE aspnet_users_deleteuser(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_tablestodeletefrom IN NUMBER DEFAULT NULL,   o_numtablesdeletedfrom OUT NUMBER, o_returnvalue OUT INTEGER) AS
	v_tablestodeletefrom NUMBER(10,   0);
	v_userid NVARCHAR2(51);
	v_transtarted NUMBER(1,   0);
	v_errorcode NUMBER(10,   0);
	v_rowcount NUMBER(10,   0);
	v_exists NUMBER(1,   0);
	e_exception

	EXCEPTION;
	BEGIN

	v_userid := NULL;
	
	IF(i_tablestodeletefrom IS NULL) THEN
		v_tablestodeletefrom := 15;
    ELSE
		v_tablestodeletefrom := i_tablestodeletefrom;
    END IF;

	o_numtablesdeletedfrom := 0;

	v_transtarted := 0;

	IF({databaseOwner}global_pkg.trancount = 0) THEN
	BEGIN
	{databaseOwner}global_pkg.trancount := {databaseOwner}global_pkg.trancount + 1;
	v_transtarted := 1;
	END;
	ELSE
	v_transtarted := 0;
	END IF;

	v_errorcode := 0;
	v_rowcount := 0;

	FOR rec IN
	(SELECT u.userid
	FROM {databaseOwner}aspnet_users u,
	{databaseOwner}aspnet_applications a
	WHERE u.loweredusername = LOWER(i_username)
	AND u.applicationid = a.applicationid
	AND LOWER(i_applicationname) = a.loweredapplicationname)
	LOOP
	v_userid := rec.userid;

	END LOOP;

	IF(v_userid IS NULL) THEN
	BEGIN
	RAISE e_exception;
	END;
	END IF;

	BEGIN
	BEGIN
	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE((bitand(v_tablestodeletefrom,   1)) <> 0
	 AND(EXISTS
	  (SELECT object_name
	   FROM user_objects
	   WHERE(LOWER(object_name) = LOWER('vw_aspnet_MembershipUsers'))
	   AND(object_type = 'VIEW'))))
	;

	END;

	IF v_exists != 0 THEN
	BEGIN

	  DELETE FROM {databaseOwner}aspnet_membership
	  WHERE userid = v_userid;

	  v_errorcode := SQLCODE;

	  v_rowcount := SQL % rowcount;

	  IF(v_errorcode <> 0) THEN
		RAISE e_exception;
	  END IF;

	  IF(v_rowcount <> 0) THEN

		o_numtablesdeletedfrom := o_numtablesdeletedfrom + 1;

	  END IF;

	END;
	END IF;

	END;

	BEGIN
	BEGIN
	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE((bitand(v_tablestodeletefrom,   2)) <> 0
	 AND(EXISTS
	  (SELECT object_name
	   FROM user_objects
	   WHERE(LOWER(object_name) = LOWER('vw_aspnet_UsersInRoles'))
	   AND(object_type = 'VIEW'))))
	;

	END;

	IF v_exists != 0 THEN
	BEGIN

	  DELETE FROM {databaseOwner}aspnet_usersinroles
	  WHERE userid = v_userid;

	  v_errorcode := SQLCODE;

	  v_rowcount := SQL % rowcount;

	  IF(v_errorcode <> 0) THEN
		RAISE e_exception;
	  END IF;

	  IF(v_rowcount <> 0) THEN

		o_numtablesdeletedfrom := o_numtablesdeletedfrom + 1;

	  END IF;

	END;
	END IF;

	END;

	BEGIN
	BEGIN
	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE((bitand(v_tablestodeletefrom,   4)) <> 0
	 AND(EXISTS
	  (SELECT object_name
	   FROM user_objects
	   WHERE(LOWER(object_name) = LOWER('vw_aspnet_Profiles'))
	   AND(object_type = 'VIEW'))))
	;

	END;

	IF v_exists != 0 THEN
	BEGIN

	  DELETE FROM {databaseOwner}aspnet_profile
	  WHERE userid = v_userid;

	  v_errorcode := SQLCODE;

	  v_rowcount := SQL % rowcount;

	  IF(v_errorcode <> 0) THEN
		RAISE e_exception;
	  END IF;

	  IF(v_rowcount <> 0) THEN

		o_numtablesdeletedfrom := o_numtablesdeletedfrom + 1;

	  END IF;

	END;
	END IF;

	END;

	BEGIN
	BEGIN
	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE((bitand(v_tablestodeletefrom,   8)) <> 0
	 AND(EXISTS
	  (SELECT object_name
	   FROM user_objects
	   WHERE(LOWER(object_name) = LOWER('vw_aspnet_WebPartState_User'))
	   AND(object_type = 'VIEW'))))
	;

	END;

	IF v_exists != 0 THEN
	BEGIN
	  EXECUTE IMMEDIATE 'DELETE FROM {databaseOwner}aspnet_PersonalizationPerUser WHERE UserId = ' || v_userid;

	  v_errorcode := SQLCODE;

	  v_rowcount := SQL % rowcount;

	  IF(v_errorcode <> 0) THEN
		RAISE e_exception;
	  END IF;

	  IF(v_rowcount <> 0) THEN

		o_numtablesdeletedfrom := o_numtablesdeletedfrom + 1;

	  END IF;

	END;
	END IF;

	END;

	BEGIN
	BEGIN
	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE((bitand(v_tablestodeletefrom,   1)) <> 0
	 AND(bitand(v_tablestodeletefrom,   2)) <> 0
	 AND(bitand(v_tablestodeletefrom,   4)) <> 0
	 AND(bitand(v_tablestodeletefrom,   8)) <> 0
	 AND(EXISTS
	  (SELECT userid
	   FROM {databaseOwner}aspnet_users
	   WHERE userid = v_userid)))
	;

	END;

	IF v_exists != 0 THEN
	BEGIN

	  DELETE FROM {databaseOwner}aspnet_users
	  WHERE userid = v_userid;

	  v_errorcode := SQLCODE;

	  v_rowcount := SQL % rowcount;

	  IF(v_errorcode <> 0) THEN
		RAISE e_exception;
	  END IF;

	  IF(v_rowcount <> 0) THEN

		o_numtablesdeletedfrom := o_numtablesdeletedfrom + 1;

	  END IF;

	END;
	END IF;

	END;

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;

	IF {databaseOwner}global_pkg.trancount = 1 THEN
	  COMMIT WORK;
	END IF;

	IF {databaseOwner}global_pkg.trancount > 0 THEN
	  {databaseOwner}global_pkg.trancount := {databaseOwner}global_pkg.trancount -1;
	END IF;

	END;
	END IF;

	o_returnvalue := 0;

	EXCEPTION
	WHEN e_exception THEN
	o_numtablesdeletedfrom := 0;

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	END;
	END IF;

	o_returnvalue := v_errorcode;

	WHEN others THEN
	o_numtablesdeletedfrom := 0;

	IF(v_transtarted = 1) THEN
	BEGIN
	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	END;
	END IF;

	o_returnvalue := v_errorcode;

	END aspnet_users_deleteuser;

	--------------------------------------------------------
	--  DDL for Function ASPNET_APPLICATIONS_GETAPPID
	--------------------------------------------------------

	PROCEDURE aspnet_applications_getappid(i_applicationname IN nvarchar2 DEFAULT NULL, o_returnvalue OUT NVARCHAR2) AS
	v_appid nvarchar2(51);
	BEGIN

	SELECT ApplicationId INTO v_appid FROM {databaseOwner}aspnet_Applications 
						WHERE aspnet_Applications.LoweredApplicationName = 
						LOWER(i_applicationname);
	o_returnvalue := v_appid;
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN
		o_returnvalue := NULL;
	                    
	END aspnet_applications_getappid;

	--------------------------------------------------------
	--  DDL for Procedure ASPNET_ANYDATAINTABLES
	--------------------------------------------------------

	PROCEDURE aspnet_anydataintables(i_tablestocheck IN NUMBER DEFAULT NULL,   o_table OUT VARCHAR2) AS
	v_exists NUMBER(10,   0);
	BEGIN

	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE(bitand(2,   1) <> 0)
	AND EXISTS
	(SELECT object_name
	 FROM user_objects
	 WHERE(LOWER(object_name) = LOWER('vw_aspnet_MembershipUsers'))
	 AND(object_type = 'VIEW'))
	;

	IF v_exists != 0 THEN
	BEGIN
	  v_exists := 0;
	  SELECT COUNT(*)
	  INTO v_exists
	  FROM dual
	  WHERE(EXISTS
		(SELECT *
		 FROM
		  (SELECT userid
		   FROM {databaseOwner}aspnet_membership)
		   WHERE rownum <= 1)
		)
	  ;
	END;

	IF v_exists != 0 THEN
	  BEGIN

		SELECT 'aspnet_Membership'
		INTO o_table
		FROM dual;
		RETURN;

	  END;
	END IF;

	END IF;

	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE(bitand(i_tablestocheck,   2) <> 0)
	AND EXISTS
	(SELECT object_name
	 FROM user_objects
	 WHERE(LOWER(object_name) = LOWER('vw_aspnet_Roles'))
	 AND(object_type = 'VIEW'))
	;

	IF v_exists != 0 THEN
	BEGIN
	  v_exists := 0;
	  SELECT COUNT(*)
	  INTO v_exists
	  FROM dual
	  WHERE(EXISTS
		(SELECT *
		 FROM
		  (SELECT roleid
		   FROM {databaseOwner}aspnet_roles)
		   WHERE rownum <= 1)
		)
	  ;

	END;

	IF v_exists != 0 THEN
	  BEGIN

		SELECT 'aspnet_Roles'
		INTO o_table
		FROM dual;
		RETURN;

	  END;
	END IF;

	END IF;

	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE((bitand(i_tablestocheck,   4)) <> 0
	AND(EXISTS
	(SELECT object_name
	 FROM user_objects
	 WHERE(LOWER(object_name) = LOWER('vw_aspnet_Profiles'))
	 AND(object_type = 'VIEW'))))
	;

	IF v_exists != 0 THEN
	BEGIN
	  v_exists := 0;
	  SELECT COUNT(*)
	  INTO v_exists
	  FROM dual
	  WHERE(EXISTS
		(SELECT *
		 FROM
		  (SELECT userid
		   FROM {databaseOwner}aspnet_profile)
		   WHERE rownum <= 1)
		)
	  ;

	END;

	IF v_exists != 0 THEN
	  BEGIN

		SELECT 'aspnet_Profile'
		INTO o_table
		FROM dual;
		RETURN;

	  END;
	END IF;

	END IF;

	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE((bitand(i_tablestocheck,   8)) <> 0
	AND(EXISTS
	(SELECT object_name
	 FROM user_objects
	 WHERE(LOWER(object_name) = LOWER('vw_aspnet_WebPartState_User'))
	 AND(object_type = 'VIEW'))))
	;

	IF v_exists != 0 THEN
	BEGIN
	  v_exists := 0;
	  EXECUTE IMMEDIATE 'SELECT COUNT(*) INTO v_exists
	FROM dual
	WHERE(EXISTS
	(SELECT *
	FROM
	(SELECT userid
	FROM {databaseOwner}aspnet_personalizationperuser)
	WHERE rownum <= 1))';

	END;

	IF v_exists != 0 THEN
	  BEGIN

		SELECT 'aspnet_PersonalizationPerUser'
		INTO o_table
		FROM dual;
		RETURN;

	  END;
	END IF;

	END IF;

	v_exists := 0;
	EXECUTE IMMEDIATE 'SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE((bitand(i_tablestocheck,   16)) <> 0
	AND EXISTS
	(SELECT object_name
	FROM sysobjects
	WHERE(LOWER(object_name) = LOWER(''aspnet_WebEvent_LogEvent''))
	AND(object_type = ''PROCEDURE'')))';

	IF v_exists != 0 THEN
	BEGIN

	  v_exists := 0;
	  EXECUTE IMMEDIATE 'SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE(EXISTS
	(SELECT *
	FROM
	(SELECT *
	FROM {databaseOwner}aspnet_webevent_events)
	WHERE rownum <= 1))';

	END;

	IF v_exists != 0 THEN
	  BEGIN

		SELECT 'aspnet_WebEvent_Events'
		INTO o_table
		FROM dual;
		RETURN;

	  END;
	END IF;

	END IF;

	IF((bitand(i_tablestocheck,   1)) <> 0
	AND(bitand(i_tablestocheck,   2)) <> 0
	AND(bitand(i_tablestocheck,   4)) <> 0
	AND(bitand(i_tablestocheck,   8)) <> 0
	AND(bitand(i_tablestocheck,   32)) <> 0
	AND(bitand(i_tablestocheck,   128)) <> 0
	AND(bitand(i_tablestocheck,   256)) <> 0
	AND(bitand(i_tablestocheck,   512)) <> 0
	AND(bitand(i_tablestocheck,   1024)) <> 0) THEN
	BEGIN

	  v_exists := 0;
	  SELECT COUNT(*)
	  INTO v_exists
	  FROM dual
	  WHERE(EXISTS
		(SELECT *
		 FROM
		  (SELECT userid
		   FROM {databaseOwner}aspnet_users)
		   WHERE rownum <= 1)
		)
	  ;

	END;

	IF v_exists != 0 THEN
	  BEGIN

		SELECT 'aspnet_Users'
		INTO o_table
		FROM dual;
		RETURN;

	  END;
	END IF;

	v_exists := 0;
	SELECT COUNT(*)
	INTO v_exists
	FROM dual
	WHERE(EXISTS
	  (SELECT *
	   FROM
		(SELECT applicationid
		 FROM {databaseOwner}aspnet_applications)
		 WHERE rownum <= 1)
	  )
	;

	IF v_exists != 0 THEN
	  BEGIN

		SELECT 'aspnet_Applications'
		INTO o_table
		FROM dual;
		RETURN;

	  END;
	END IF;

	END IF;

	END aspnet_anydataintables;

	--------------------------------------------------------
	--  DDL for Procedure ASPNET_APPLICATIONS_CREATEAPP
	--------------------------------------------------------

	PROCEDURE aspnet_applications_createapp(i_applicationname IN nvarchar2 DEFAULT NULL,   o_applicationid OUT NVARCHAR2) AS
	v_transtarted NUMBER(1,   0);
	BEGIN
	FOR rec IN
	(SELECT applicationid
	 FROM {databaseOwner}aspnet_applications
	 WHERE loweredapplicationname = LOWER(i_applicationname))
	LOOP
	o_applicationid := rec.applicationid;
	END LOOP;

	IF(o_applicationid IS NULL) THEN
	BEGIN
	  v_transtarted := 0;

	  IF({databaseOwner}global_pkg.trancount = 0) THEN
		BEGIN
		  {databaseOwner}global_pkg.trancount := {databaseOwner}global_pkg.trancount + 1;
		  v_transtarted := 1;
		END;
	  ELSE
		v_transtarted := 0;
	  END IF;

	  FOR rec IN
		(SELECT applicationid
		 FROM {databaseOwner}aspnet_applications
		 WHERE loweredapplicationname = LOWER(i_applicationname) FOR UPDATE OF applicationid)
	  LOOP
		o_applicationid := rec.applicationid;
	  END LOOP;

	  IF(o_applicationid IS NULL) THEN
		BEGIN

		  INSERT
		  INTO {databaseOwner}aspnet_applications(applicationid,   applicationname,   loweredapplicationname)
		  VALUES(sys_guid(),   i_applicationname,   LOWER(i_applicationname)) returning applicationid
		  INTO o_applicationid;

		END;
	  END IF;

	  IF(v_transtarted = 1) THEN
		BEGIN

		  v_transtarted := 0;

		  IF {databaseOwner}global_pkg.trancount = 1 THEN
			COMMIT WORK;
		  END IF;

		  IF {databaseOwner}global_pkg.trancount > 0 THEN
			{databaseOwner}global_pkg.trancount := {databaseOwner}global_pkg.trancount -1;
		  END IF;

		END;
	  END IF;

	END;
	END IF;

	EXCEPTION
	WHEN others THEN

	v_transtarted := 0;
	{databaseOwner}global_pkg.trancount := 0;
	ROLLBACK WORK;
	DBMS_OUTPUT.PUT_LINE('There has been an error!');

	END aspnet_applications_createapp;

	--------------------------------------------------------
	--  DDL for Procedure ASPNET_PROFILE_DELINACTPROFILE
	--------------------------------------------------------

	PROCEDURE aspnet_profile_delinactprofile(i_applicationname IN nvarchar2 DEFAULT NULL,   i_profileauthoptions IN NUMBER DEFAULT NULL,   i_inactivesincedate IN DATE DEFAULT NULL,   o_rowcount OUT INTEGER) AS
	v_applicationid nvarchar2(51);
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	(SELECT applicationid
	 FROM {databaseOwner}aspnet_applications
	 WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_applicationid := rec.applicationid;
	END LOOP;

	IF(v_applicationid IS NULL) THEN
	BEGIN

	  o_rowcount := 0;
	  RETURN;

	END;
	END IF;

	DELETE FROM {databaseOwner}aspnet_profile
	WHERE userid IN
	(SELECT userid
	 FROM {databaseOwner}aspnet_users u
	 WHERE applicationid = v_applicationid
	 AND(lastactivitydate <= i_inactivesincedate)
	 AND((i_profileauthoptions = 2) OR(i_profileauthoptions = 0
	 AND isanonymous = 1) OR(i_profileauthoptions = 1
	 AND isanonymous = 0)))
	;

	o_rowcount := SQL % rowcount;

	END aspnet_profile_delinactprofile;

	--------------------------------------------------------
	--  DDL for Procedure ASPNET_PROFILE_GETNUMINACTPROF
	--------------------------------------------------------

	PROCEDURE aspnet_profile_getnuminactprof(i_applicationname IN nvarchar2 DEFAULT NULL,   i_profileauthoptions IN NUMBER DEFAULT NULL,   i_inactivesincedate IN DATE DEFAULT NULL,   o_rowcount OUT INTEGER) AS
	v_applicationid nvarchar2(51);
	BEGIN
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	  (SELECT applicationid
	   FROM {databaseOwner}aspnet_applications
	   WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	  v_applicationid := rec.applicationid;
	END LOOP;

	IF(v_applicationid IS NULL) THEN
	  BEGIN

		o_rowcount := 0;
		RETURN;

	  END;
	END IF;

	SELECT COUNT(*)
	INTO o_rowcount
	FROM {databaseOwner}aspnet_users u,
	  {databaseOwner}aspnet_profile p
	WHERE applicationid = v_applicationid
	 AND u.userid = p.userid
	 AND(lastactivitydate <= i_inactivesincedate)
	 AND((i_profileauthoptions = 2) OR(i_profileauthoptions = 0
	 AND isanonymous = 1) OR(i_profileauthoptions = 1
	 AND isanonymous = 0));
	END;
	END aspnet_profile_getnuminactprof;

	--------------------------------------------------------
	--  DDL for Procedure ASPNET_PROFILE_GETPROFILES
	--------------------------------------------------------

	PROCEDURE aspnet_profile_getprofiles(i_applicationname IN nvarchar2 DEFAULT NULL,   i_profileauthoptions IN NUMBER DEFAULT NULL,   i_pageindex IN NUMBER DEFAULT NULL,   i_pagesize IN NUMBER DEFAULT NULL,   i_usernametomatch IN nvarchar2 DEFAULT NULL,   i_inactivesincedate IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1, o_rowcount OUT INTEGER) AS
	v_applicationid nvarchar2(51);
	v_pagelowerbound NUMBER(10,   0);
	v_pageupperbound NUMBER(10,   0);
	BEGIN
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	  (SELECT applicationid
	   FROM {databaseOwner}aspnet_applications
	   WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	  v_applicationid := rec.applicationid;

	END LOOP;

	IF(v_applicationid IS NULL) THEN
	  RETURN;
	END IF;

	v_pagelowerbound := i_pagesize *i_pageindex;
	v_pageupperbound := i_pagesize -1 + v_pagelowerbound;

	DELETE FROM {databaseOwner}tp_pageindexforusers_3;
	INSERT
	INTO {databaseOwner}tp_pageindexforusers_3(userid)
	SELECT u.userid
	FROM {databaseOwner}aspnet_users u,
	  {databaseOwner}aspnet_profile p
	WHERE applicationid = v_applicationid
	 AND u.userid = p.userid
	 AND(i_inactivesincedate IS NULL OR lastactivitydate <= i_inactivesincedate)
	 AND((i_profileauthoptions = 2) OR(i_profileauthoptions = 0
	 AND isanonymous = 1) OR(i_profileauthoptions = 1
	 AND isanonymous = 0))
	 AND(i_usernametomatch IS NULL OR loweredusername LIKE LOWER(i_usernametomatch))
	ORDER BY username;

	OPEN o_rc1 FOR
	SELECT u.username,
	  u.isanonymous,
	  u.lastactivitydate,
	  p.lastupdateddate,
	  lengthb(p.propertynames) + lengthb(p.propertyvaluesstring) + lengthb(p.propertyvaluesbinary)
	FROM {databaseOwner}aspnet_users u,
	  {databaseOwner}aspnet_profile p,
	  {databaseOwner}tp_pageindexforusers_3 i
	WHERE u.userid = p.userid
	 AND p.userid = i.userid
	 AND i.indexid >= v_pagelowerbound
	 AND i.indexid <= v_pageupperbound;

	SELECT COUNT(*)
	INTO o_rowcount
	FROM {databaseOwner}tp_pageindexforusers_3;

	NULL;
	END;
	END aspnet_profile_getprofiles;

	--------------------------------------------------------
	--  DDL for Procedure ASPNET_PROFILE_GETPROPERTIES
	--------------------------------------------------------

	PROCEDURE aspnet_profile_getproperties(i_applicationname IN nvarchar2 DEFAULT NULL,   i_username IN nvarchar2 DEFAULT NULL,   i_currenttimeutc IN DATE DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
	v_applicationid nvarchar2(51);
	v_userid nvarchar2(51);
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	(SELECT applicationid
	 FROM {databaseOwner}aspnet_applications
	 WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	v_applicationid := rec.applicationid;
	END LOOP;

	IF(v_applicationid IS NULL) THEN
	RETURN;
	END IF;

	v_userid := NULL;

	FOR rec IN
	(SELECT userid
	 FROM {databaseOwner}aspnet_users
	 WHERE applicationid = v_applicationid
	 AND loweredusername = LOWER(i_username))
	LOOP
	v_userid := rec.userid;
	END LOOP;

	IF(v_userid IS NULL) THEN
	RETURN;
	END IF;

	OPEN o_rc1 FOR
	SELECT *
	FROM
	(SELECT propertynames,
	   propertyvaluesstring,
	   propertyvaluesbinary
	 FROM {databaseOwner}aspnet_profile
	 WHERE userid = v_userid)
	WHERE rownum <= 1;

	IF(o_rc1 % rowcount > 0) THEN
	BEGIN

	  UPDATE {databaseOwner}aspnet_users
	  SET lastactivitydate = i_currenttimeutc
	  WHERE userid = v_userid;

	END;
	END IF;

	END aspnet_profile_getproperties;

	--------------------------------------------------------
	--  DDL for Procedure ASPNET_REGISTERSCHEMAVERSION
	--------------------------------------------------------

	PROCEDURE aspnet_registerschemaversion(i_feature IN nvarchar2 DEFAULT NULL,   i_compatibleschemaversion IN nvarchar2 DEFAULT NULL,   i_iscurrentversion IN NUMBER DEFAULT NULL,   i_removeincompatibleschema IN NUMBER DEFAULT NULL) AS
	BEGIN
	BEGIN

	IF(i_removeincompatibleschema = 1) THEN
	  BEGIN

		DELETE FROM {databaseOwner}aspnet_schemaversions
		WHERE feature = LOWER(i_feature);

	  END;
	ELSE
	  BEGIN

		IF(i_iscurrentversion = 1) THEN
		  BEGIN

			UPDATE {databaseOwner}aspnet_schemaversions
			SET iscurrentversion = 0
			WHERE feature = LOWER(i_feature);

		  END;
		END IF;

	  END;
	END IF;

	INSERT
	INTO {databaseOwner}aspnet_schemaversions(feature,   compatibleschemaversion,   iscurrentversion)
	VALUES(LOWER(i_feature),   i_compatibleschemaversion,   i_iscurrentversion);

	END;
	END aspnet_registerschemaversion;

	--------------------------------------------------------
	--  DDL for Procedure ASPNET_ROLES_GETALLROLES
	--------------------------------------------------------

	PROCEDURE aspnet_roles_getallroles(i_applicationname IN nvarchar2 DEFAULT NULL,   o_rc1 OUT {databaseOwner}global_pkg.rct1) AS
	v_applicationid nvarchar2(51);
	BEGIN
	BEGIN

	v_applicationid := NULL;

	FOR rec IN
	  (SELECT applicationid
	   FROM {databaseOwner}aspnet_applications
	   WHERE LOWER(i_applicationname) = loweredapplicationname)
	LOOP
	  v_applicationid := rec.applicationid;
	END LOOP;

	IF(v_applicationid IS NULL) THEN

	  OPEN o_rc1 FOR
	  SELECT rolename
	  FROM {databaseOwner}aspnet_roles
	  WHERE applicationid = v_applicationid
	  ORDER BY rolename;
	  RETURN;
	END IF;

	END;
	END aspnet_roles_getallroles;

	--------------------------------------------------------
	--  DDL for Procedure ASPNET_UNREGISTERSCHEMAVERSION
	--------------------------------------------------------

	PROCEDURE aspnet_unregisterschemaversion(i_feature IN nvarchar2 DEFAULT NULL,   i_compatibleschemaversion IN nvarchar2 DEFAULT NULL) AS
	BEGIN
	BEGIN

	DELETE FROM {databaseOwner}aspnet_schemaversions
	WHERE feature = LOWER(i_feature)
	 AND compatibleschemaversion = i_compatibleschemaversion;

	END;
	END aspnet_unregisterschemaversion;

	--------------------------------------------------------
	--  DDL for Function DATEADD
	--------------------------------------------------------

	FUNCTION dateadd(INTERVAL VARCHAR2,   adding NUMBER,   entry_date DATE) RETURN DATE AS
	result DATE;
	BEGIN

	--days--
	IF(UPPER(INTERVAL) = 'D') OR(UPPER(INTERVAL) = 'Y') OR(UPPER(INTERVAL) = 'W') OR(UPPER(INTERVAL) = 'DD') OR(UPPER(INTERVAL) = 'DDD') OR(UPPER(INTERVAL) = 'DAY') THEN
	result := entry_date + adding;
	ELSIF

	--weeks--
	(UPPER(INTERVAL) = 'WW') OR(UPPER(INTERVAL) = 'IW') OR(UPPER(INTERVAL) = 'WEEK') THEN
	result := entry_date +(adding *7);
	ELSIF

	--years--
	(UPPER(INTERVAL) = 'YYYY') OR(UPPER(INTERVAL) = 'YEAR') THEN
	result := add_months(entry_date,   adding *12);
	ELSIF

	--quarters--
	(UPPER(INTERVAL) = 'Q') OR(UPPER(INTERVAL) = 'QUARTER') THEN
	result := add_months(entry_date,   adding *3);
	ELSIF

	--months--
	(UPPER(INTERVAL) = 'M') OR(UPPER(INTERVAL) = 'MM') OR(UPPER(INTERVAL) = 'MONTH') THEN
	result := add_months(entry_date,   adding);
	ELSIF

	--hours--
	(UPPER(INTERVAL) = 'H') OR(UPPER(INTERVAL) = 'HH') OR(UPPER(INTERVAL) = 'HOUR') THEN
	result := entry_date +(adding / 24);
	ELSIF

	--minutes--
	(UPPER(INTERVAL) = 'N') OR(UPPER(INTERVAL) = 'MI') OR(UPPER(INTERVAL) = 'MINUTE') THEN
	result := entry_date +(adding / 24 / 60);
	ELSIF

	--seconds--
	(UPPER(INTERVAL) = 'S') OR(UPPER(INTERVAL) = 'SS') OR(UPPER(INTERVAL) = 'SECOND') THEN
	result := entry_date +(adding / 24 / 60 / 60);
	END IF;

	RETURN result;

	EXCEPTION
	WHEN others THEN
	raise_application_error('-20000',   sqlerrm);
	return null;
	END dateadd;

END aspnet_provider;
/

BEGIN
	{databaseOwner}aspnet_provider.aspnet_RegisterSchemaVersion('Provider Package', '1', 1, 1);
END;
/