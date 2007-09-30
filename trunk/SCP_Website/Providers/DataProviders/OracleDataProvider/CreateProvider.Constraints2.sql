CREATE INDEX {databaseOwner}aspnet_applications_idx ON {databaseOwner}aspnet_applications(loweredapplicationname) TABLESPACE CSWS_DBO_INDEX01_128K;
/

ALTER TABLE {databaseOwner}aspnet_applications ADD(CONSTRAINT pk_aspnet_applications PRIMARY KEY(applicationid) USING INDEX TABLESPACE CSWS_DBO_INDEX01_128K);
/

ALTER TABLE {databaseOwner}aspnet_applications ADD(CONSTRAINT uq_aspnet_apps_appname UNIQUE(applicationname) USING INDEX TABLESPACE CSWS_DBO_INDEX01_128K);
/

ALTER TABLE {databaseOwner}aspnet_applications ADD(CONSTRAINT uq_aspnet_apps_lowappname UNIQUE(loweredapplicationname) USING INDEX TABLESPACE CSWS_DBO_INDEX01_128K);
/

CREATE UNIQUE INDEX {databaseOwner}aspnet_users_index ON {databaseOwner}aspnet_users(applicationid,   loweredusername) TABLESPACE CSWS_DBO_INDEX01_128K;
/

ALTER TABLE {databaseOwner}aspnet_users ADD(CONSTRAINT pk_aspnet_users PRIMARY KEY(userid) USING INDEX TABLESPACE CSWS_DBO_INDEX01_128K);
/

CREATE INDEX {databaseOwner}aspnet_users_index2 ON {databaseOwner}aspnet_users(applicationid,   lastactivitydate) TABLESPACE CSWS_DBO_INDEX01_128K;
/

ALTER TABLE {databaseOwner}aspnet_users ADD(CONSTRAINT fk_aspnet_us_applicationid FOREIGN KEY(applicationid) REFERENCES {databaseOwner}aspnet_applications(applicationid) ON DELETE cascade);
/

CREATE INDEX {databaseOwner}aspnet_membership_index ON {databaseOwner}aspnet_membership(applicationid,   loweredemail) TABLESPACE CSWS_DBO_INDEX01_128K;
/

ALTER TABLE {databaseOwner}aspnet_membership ADD(CONSTRAINT pk_aspnet_membership PRIMARY KEY(userid) USING INDEX TABLESPACE CSWS_DBO_INDEX01_128K);
/

ALTER TABLE {databaseOwner}aspnet_membership ADD(CONSTRAINT fk_aspnet_me_applicationid FOREIGN KEY(applicationid) REFERENCES {databaseOwner}aspnet_applications(applicationid) ON DELETE cascade);
/

ALTER TABLE {databaseOwner}aspnet_membership ADD(CONSTRAINT fk_aspnet_me_userid FOREIGN KEY(userid) REFERENCES {databaseOwner}aspnet_users(userid) ON DELETE cascade);
/

CREATE UNIQUE INDEX {databaseOwner}aspnet_roles_index ON {databaseOwner}aspnet_roles(applicationid,   loweredrolename) TABLESPACE CSWS_DBO_INDEX01_128K;
/

ALTER TABLE {databaseOwner}aspnet_roles ADD(CONSTRAINT pk_aspnet_roles PRIMARY KEY(roleid) USING INDEX TABLESPACE CSWS_DBO_INDEX01_128K);
/

ALTER TABLE {databaseOwner}aspnet_roles ADD(CONSTRAINT fk_aspnet_ro_applicationid FOREIGN KEY(applicationid) REFERENCES {databaseOwner}aspnet_applications(applicationid) ON DELETE cascade);
/

CREATE INDEX {databaseOwner}aspnet_usersinroles_index ON {databaseOwner}aspnet_usersinroles(roleid) TABLESPACE CSWS_DBO_INDEX01_128K;
/

ALTER TABLE {databaseOwner}aspnet_usersinroles ADD(CONSTRAINT pk_aspnet_usersinroles PRIMARY KEY(userid,   roleid) USING INDEX TABLESPACE CSWS_DBO_INDEX01_128K);
/

ALTER TABLE {databaseOwner}aspnet_profile ADD(CONSTRAINT pk_aspnet_profile PRIMARY KEY(userid) USING INDEX TABLESPACE CSWS_DBO_INDEX01_128K);
/

ALTER TABLE {databaseOwner}aspnet_profile ADD(CONSTRAINT fk_aspnet_pr_userid FOREIGN KEY(userid) REFERENCES {databaseOwner}aspnet_users(userid) ON DELETE cascade);
/

ALTER TABLE {databaseOwner}aspnet_usersinroles ADD(CONSTRAINT fk_aspnet_us_roleid FOREIGN KEY(roleid) REFERENCES {databaseOwner}aspnet_roles(roleid) ON DELETE cascade);
/

ALTER TABLE {databaseOwner}aspnet_usersinroles ADD(CONSTRAINT fk_aspnet_us_userid FOREIGN KEY(userid) REFERENCES {databaseOwner}aspnet_users(userid) ON DELETE cascade);
/

ALTER TABLE {databaseOwner}aspnet_schemaversions ADD(CONSTRAINT pk_aspnet_schemaversions PRIMARY KEY(feature,   compatibleschemaversion) USING INDEX TABLESPACE CSWS_DBO_INDEX01_128K);
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
	{databaseOwner}aspnet_RegisterSchemaVersion('Constraints', '1', 1, 1);
END;
/

DROP PROCEDURE {databaseOwner}aspnet_RegisterSchemaVersion;
/