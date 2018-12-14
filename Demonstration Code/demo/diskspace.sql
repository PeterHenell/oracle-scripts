/* External procedure to show Windows NT disk space
*/
CONNECT SYSTEM/MANAGER
GRANT CREATE LIBRARY TO SCOTT;

CONNECT SCOTT/TIGER

CREATE OR REPLACE LIBRARY nt_kernel
AS
   'C:\winnt\system32\kernel32.dll';
/

PAUSE

CREATE OR REPLACE PACKAGE disk_util
AS
   FUNCTION get_disk_free_space
     (root_path IN VARCHAR2,
      sectors_per_cluster OUT PLS_INTEGER,
      bytes_per_sector OUT PLS_INTEGER,
      number_of_free_clusters OUT PLS_INTEGER,
      total_number_of_clusters OUT PLS_INTEGER)
   RETURN PLS_INTEGER;

   PRAGMA RESTRICT_REFERENCES (get_disk_free_space,
      WNPS, RNPS, WNDS, RNDS);

   FUNCTION megs (root_path IN VARCHAR2) RETURN NUMBER;
   
   PRAGMA RESTRICT_REFERENCES (megs,
      WNPS, RNPS, WNDS, RNDS);
      
END disk_util;
/

PAUSE

CREATE OR REPLACE PACKAGE BODY disk_util
AS
   FUNCTION get_disk_free_space
     (root_path IN VARCHAR2,
      sectors_per_cluster OUT PLS_INTEGER,
      bytes_per_sector OUT PLS_INTEGER,
      number_of_free_clusters OUT pls_integer,
      total_number_of_clusters OUT PLS_INTEGER)
   RETURN PLS_INTEGER
   IS EXTERNAL
      LIBRARY nt_kernel
      NAME "GetDiskFreeSpaceA"
      LANGUAGE C
      CALLING STANDARD PASCAL
      PARAMETERS
         (root_path STRING,
          sectors_per_cluster BY REFERENCE LONG,
          bytes_per_sector BY REFERENCE LONG,
          number_of_free_clusters BY REFERENCE LONG,
          total_number_of_clusters BY REFERENCE LONG,
          RETURN LONG);
          
   FUNCTION megs (root_path IN VARCHAR2) RETURN NUMBER
   IS
      lsectors_per_cluster INTEGER;
      lbytes_per_sector INTEGER;
      lnumber_of_free_clusters INTEGER;
      ltotal_number_of_clusters INTEGER;
      return_code INTEGER;
      free_meg NUMBER;
   BEGIN
      return_code := disk_util.get_disk_free_space (root_path,
         lsectors_per_cluster, lbytes_per_sector,
         lnumber_of_free_clusters, ltotal_number_of_clusters);

      free_meg := lsectors_per_cluster * lbytes_per_sector *
                  lnumber_of_free_clusters / 1024 / 1024;

      RETURN (free_meg);
   END;
          
END disk_util;
/

PAUSE

SET SERVEROUTPUT ON SIZE 100000 TIMING ON
DECLARE
   lroot_path VARCHAR2(3) := 'C:\';
   lsectors_per_cluster INTEGER;
   lbytes_per_sector INTEGER;
   lnumber_of_free_clusters INTEGER;
   ltotal_number_of_clusters INTEGER;
   return_code INTEGER;
   free_meg NUMBER;
BEGIN
   return_code := disk_util.get_disk_free_space (lroot_path,
      lsectors_per_cluster, lbytes_per_sector,
      lnumber_of_free_clusters, ltotal_number_of_clusters);

   free_meg := lsectors_per_cluster * lbytes_per_sector *
               lnumber_of_free_clusters / 1024 / 1024;

   DBMS_OUTPUT.PUT_LINE('free disk space, Mb = ' || free_meg);
END;
/

SET TIMING OFF


REM  Copyright (c) 1999 DataCraft, Inc. and William L. Pribyl
REM  All Rights Reserved
