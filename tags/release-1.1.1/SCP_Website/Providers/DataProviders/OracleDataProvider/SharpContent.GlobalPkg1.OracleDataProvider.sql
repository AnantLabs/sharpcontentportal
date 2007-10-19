
CREATE OR REPLACE PACKAGE {databaseOwner}GLOBAL_PKG AUTHID CURRENT_USER AS

  IDENTITY INTEGER;
  trancount INTEGER := 0;
  type rct1 IS ref CURSOR;
  PROCEDURE inctrancount;
  PROCEDURE dectrancount;
  
END global_pkg;
/

CREATE OR REPLACE PACKAGE BODY {databaseOwner}GLOBAL_PKG AS
 
  PROCEDURE inctrancount IS
  BEGIN
    trancount := trancount + 1;
  END inctrancount;
  PROCEDURE dectrancount IS
  BEGIN
    trancount := trancount -1;
  END dectrancount;
  
END global_pkg;
/