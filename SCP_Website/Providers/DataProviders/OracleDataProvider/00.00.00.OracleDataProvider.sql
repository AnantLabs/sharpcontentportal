/************************************************************/
/*****              Initialization Script               *****/
/*****                                                  *****/
/*****                                                  *****/
/***** Note: To manually execute this script you must   *****/
/*****       perform a search and replace operation     *****/
/*****       for {databaseOwner}                        *****/
/*****                                                  *****/
/************************************************************/

DECLARE 
  v_exists NUMBER(1,0);
BEGIN

  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM user_objects
  WHERE OBJECT_TYPE = 'PACKAGE' 
  AND LOWER(OBJECT_NAME) = LOWER('GLOBAL_PKG');

  IF v_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE PACKAGE "GLOBAL_PKG" AUTHID CURRENT_USER AS
                          IDENTITY INTEGER;
                          type rct1 IS ref CURSOR;
                       END global_pkg;';
  END IF;
END;
/

DECLARE 
  v_exists NUMBER(1,0);
BEGIN

  v_exists := 0;
  SELECT COUNT(*)
  INTO v_exists
  FROM user_tables
  WHERE LOWER(TABLE_NAME) = LOWER('scp_Version');

  IF v_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE {databaseOwner}SCP_VERSION (
	  VersionId   number(10,0) NOT NULL,
  	  Major       number(10,0) NOT NULL,
	  Minor       number(10,0) NOT NULL,
	  Build       number(10,0) NOT NULL,
	  CreatedDate date         NOT NULL)';
    EXECUTE IMMEDIATE 'ALTER TABLE {databaseOwner}scp_Version ADD (CONSTRAINT PK_SCP_VERSION PRIMARY KEY (VersionId))';
    EXECUTE IMMEDIATE 'ALTER TABLE {databaseOwner}SCP_VERSION ADD (CONSTRAINT IX_SCP_VERSION UNIQUE (Major, Minor, Build))';
  END IF;

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
        EXECUTE IMMEDIATE 'CREATE TRIGGER {databaseOwner}TR_SQ_SCP_VERSION BEFORE INSERT ON {databaseOwner}SCP_VERSION
        FOR EACH ROW WHEN (new.VERSIONID IS NULL) BEGIN SELECT {databaseOwner}SQ_SCP_VERSION.nextval
        INTO {databaseOwner}global_Pkg.identity FROM dual; :new.VERSIONID:={databaseOwner}global_Pkg.identity; END;';
      END IF;
  END IF;
END;
/

CREATE OR REPLACE PACKAGE {databaseOwner}SCPUKE_PKG AUTHID CURRENT_USER AS
procedure scp_GetDatabaseVersion (
  o_rc1 out {databaseOwner}global_pkg.rct1
);
procedure scp_FindDatabaseVersion (
  i_Major  in number,
  i_Minor  in number,
  i_Build  in number,
  o_Found  out number
);
procedure scp_UpdateDatabaseVersion (
  i_Major  in number,
  i_Minor  in number,
  i_Build  in number
);

END SCPUKE_PKG;
/

CREATE OR REPLACE PACKAGE BODY {databaseOwner}SCPUKE_PKG AS

procedure scp_GetDatabaseVersion (
  o_rc1 out {databaseOwner}global_pkg.rct1
)
as
begin

open o_rc1 for
select Major,
       Minor,
       Build
from   scp_Version 
where  VersionId = ( select max(VersionId) from {databaseOwner}scp_Version );

end scp_GetDatabaseVersion;

procedure scp_FindDatabaseVersion (
  i_Major  in number,
  i_Minor  in number,
  i_Build  in number,
  o_Found  out number
)
as
begin

select 1 into o_found
from   {databaseOwner}scp_Version
where  Major = i_Major
and    Minor = i_Minor
and    Build = i_Build;

end scp_FindDatabaseVersion;

procedure scp_UpdateDatabaseVersion (
  i_Major  in number,
  i_Minor  in number,
  i_Build  in number
)
as
begin

insert into {databaseOwner}scp_Version (
  Major,
  Minor,
  Build,
  CreatedDate
)
values (
  i_Major,
  i_Minor,
  i_Build,
  sysdate
);

end scp_UpdateDatabaseVersion;

end SCPUKE_PKG;
