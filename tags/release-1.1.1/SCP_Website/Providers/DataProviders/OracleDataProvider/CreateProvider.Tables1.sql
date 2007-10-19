CREATE TABLE {databaseOwner}aspnet_users(applicationid nvarchar2(51) NOT NULL,   userid nvarchar2(51) NOT NULL,   username nvarchar2(256) NOT NULL,   loweredusername nvarchar2(256) NOT NULL,   mobilealias nvarchar2(16),   isanonymous NUMBER(1,   0) NOT NULL,   lastactivitydate DATE NOT NULL) TABLESPACE CSWS_DBO_DATA01_128K;
/
ALTER TABLE {databaseOwner}aspnet_users modify(mobilealias DEFAULT(NULL));
/
ALTER TABLE {databaseOwner}aspnet_users modify(isanonymous DEFAULT(0));
/

CREATE TABLE {databaseOwner}aspnet_roles(applicationid nvarchar2(51) NOT NULL,   roleid nvarchar2(51) NOT NULL,   rolename nvarchar2(256) NOT NULL,   loweredrolename nvarchar2(256) NOT NULL,   description nvarchar2(256)) TABLESPACE CSWS_DBO_DATA01_128K;
/

CREATE TABLE {databaseOwner}aspnet_usersinroles(userid nvarchar2(51) NOT NULL,   roleid nvarchar2(51) NOT NULL) TABLESPACE CSWS_DBO_DATA01_128K;
/

CREATE TABLE {databaseOwner}aspnet_schemaversions(feature nvarchar2(128) NOT NULL,   compatibleschemaversion nvarchar2(128) NOT NULL,   iscurrentversion NUMBER(1,   0) NOT NULL) TABLESPACE CSWS_DBO_DATA01_128K;
/

CREATE TABLE {databaseOwner}aspnet_membership(applicationid nvarchar2(51) NOT NULL,   userid nvarchar2(51) NOT NULL,   password nvarchar2(128) NOT NULL,   passwordformat NUMBER(10,   0) NOT NULL,   passwordsalt nvarchar2(128) NOT NULL,   mobilepin nvarchar2(16),   email nvarchar2(256),   loweredemail nvarchar2(256),   passwordquestion nvarchar2(256),   passwordanswer nvarchar2(128),   isapproved NUMBER(1,   0) NOT NULL,   islockedout NUMBER(1,   0),   createdate DATE NOT NULL,   lastlogindate DATE NOT NULL,   lastpwdchangeddate DATE NOT NULL,   lastlockoutdate DATE NOT NULL,   failedpwdattemptcount NUMBER(10,   0) NOT NULL,   failedpwdattemptwinstart DATE NOT NULL,   failedpwdanswerattemptcount NUMBER(10,   0) NOT NULL,   failedpwdanswerattemptwinstart DATE NOT NULL,   comment_ nclob) TABLESPACE CSWS_DBO_DATA01_128K;
/
ALTER TABLE {databaseOwner}aspnet_membership modify(passwordformat DEFAULT(0));
/

CREATE TABLE {databaseOwner}aspnet_applications(applicationname nvarchar2(256) NOT NULL,   loweredapplicationname nvarchar2(256) NOT NULL,   applicationid nvarchar2(51) DEFAULT sys_guid() NOT NULL,   description nvarchar2(256)) TABLESPACE CSWS_DBO_DATA01_128K;
/

CREATE TABLE {databaseOwner}aspnet_profile(userid nvarchar2(51) NOT NULL,   propertynames nclob NOT NULL,   propertyvaluesstring nclob NOT NULL,   propertyvaluesbinary BLOB NOT NULL,   lastupdateddate DATE NOT NULL) TABLESPACE CSWS_DBO_DATA01_128K;
/

CREATE OR REPLACE PROCEDURE {databaseOwner}aspnet_registerschemaversion(i_feature IN nvarchar2 DEFAULT NULL,   i_compatibleschemaversion IN nvarchar2 DEFAULT NULL,   i_iscurrentversion IN NUMBER DEFAULT NULL,   i_removeincompatibleschema IN NUMBER DEFAULT NULL) AS
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
/

BEGIN
	{databaseOwner}aspnet_RegisterSchemaVersion('Table', '1', 1, 1);
END;
/

DROP PROCEDURE {databaseOwner}aspnet_RegisterSchemaVersion;
/
