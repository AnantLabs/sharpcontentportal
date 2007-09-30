CREATE OR REPLACE VIEW {databaseOwner}vw_aspnet_applications AS
SELECT aspnet_applications.applicationname,
  aspnet_applications.loweredapplicationname,
  aspnet_applications.applicationid,
  aspnet_applications.description
FROM {databaseOwner}aspnet_applications
/

CREATE OR REPLACE VIEW {databaseOwner}vw_aspnet_membershipusers AS
SELECT aspnet_membership.userid,
  aspnet_membership.passwordformat,
  aspnet_membership.mobilepin,
  aspnet_membership.email,
  aspnet_membership.loweredemail,
  aspnet_membership.passwordquestion,
  aspnet_membership.passwordanswer,
  aspnet_membership.isapproved,
  aspnet_membership.islockedout,
  aspnet_membership.createdate,
  aspnet_membership.lastlogindate,
  aspnet_membership.lastpwdchangeddate,
  aspnet_membership.lastlockoutdate,
  aspnet_membership.failedpwdattemptcount,
  aspnet_membership.failedpwdattemptwinstart,
  aspnet_membership.failedpwdanswerattemptcount,
  aspnet_membership.failedpwdanswerattemptwinstart,
  aspnet_membership.comment_,
  aspnet_users.applicationid,
  aspnet_users.username,
  aspnet_users.mobilealias,
  aspnet_users.isanonymous,
  aspnet_users.lastactivitydate
FROM {databaseOwner}aspnet_membership
INNER JOIN aspnet_users ON aspnet_membership.userid = aspnet_users.userid
/

CREATE OR REPLACE force VIEW {databaseOwner}vw_aspnet_profiles AS
SELECT aspnet_profile.userid,
  aspnet_profile.lastupdateddate,
  lengthb(aspnet_profile.propertynames) + lengthb(aspnet_profile.propertyvaluesstring) + lengthb(aspnet_profile.propertyvaluesbinary) datasize
FROM {databaseOwner}aspnet_profile
/

CREATE OR REPLACE force VIEW {databaseOwner}vw_aspnet_roles AS
SELECT aspnet_roles.applicationid,
  aspnet_roles.roleid,
  aspnet_roles.rolename,
  aspnet_roles.loweredrolename,
  aspnet_roles.description
FROM {databaseOwner}aspnet_roles
/

CREATE OR REPLACE force VIEW {databaseOwner}vw_aspnet_users AS
SELECT aspnet_users.applicationid,
  aspnet_users.userid,
  aspnet_users.username,
  aspnet_users.loweredusername,
  aspnet_users.mobilealias,
  aspnet_users.isanonymous,
  aspnet_users.lastactivitydate
FROM {databaseOwner}aspnet_users
/

CREATE OR REPLACE force VIEW {databaseOwner}vw_aspnet_usersinroles AS
SELECT aspnet_usersinroles.userid,
  aspnet_usersinroles.roleid
FROM {databaseOwner}aspnet_usersinroles
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
	{databaseOwner}aspnet_RegisterSchemaVersion('Views', '1', 1, 1);
END;
/

DROP PROCEDURE {databaseOwner}aspnet_RegisterSchemaVersion;
/

