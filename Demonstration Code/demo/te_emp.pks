CREATE OR REPLACE PACKAGE te_emp
--//-----------------------------------------------------------------------
--//  ** PL/Generator Table Encapsulator for "EMP"
--//-----------------------------------------------------------------------
--//  (c) COPYRIGHT  2003.
--//               All rights reserved.
--//
--//  No part of this copyrighted work may be reproduced, modified,
--//  or distributed in any form or by any means without the prior
--//  written permission of .
--//-----------------------------------------------------------------------
--//  This software was generated by Quest Software's PL/Generator (TM).
--//
--//  For more information, visit www.Quest Software.com or call 1.800.REVEAL4
--//-----------------------------------------------------------------------
--//  Stored In:  te_emp.pks
--//  Created On: May       09, 2003 16:31:38
--//  Created By: SCOTT
--//  PL/Generator Version: PRO-2000.2.8
--//-----------------------------------------------------------------------
IS
--// Data Structures //--
   TYPE pky_rt IS RECORD (
      empno EMP.EMPNO%TYPE
      );

   TYPE cv_t IS REF CURSOR;

--// Cursors //--

   CURSOR allbypky_cur
   IS
      SELECT
         EMPNO,
         ENAME,
         JOB,
         MGR,
         HIREDATE,
         SAL,
         COMM,
         DEPTNO
        FROM EMP
       ORDER BY
         EMPNO
      ;

   CURSOR allforpky_cur (
      empno_in IN EMP.EMPNO%TYPE
      )
   IS
      SELECT
         EMPNO,
         ENAME,
         JOB,
         MGR,
         HIREDATE,
         SAL,
         COMM,
         DEPTNO
        FROM EMP
       WHERE
         EMPNO = allforpky_cur.empno_in
      ;

   --// Specified columns, all rows for this foreign key. //--
   CURSOR fk_deptno_all_cur (
      deptno_in IN EMP.DEPTNO%TYPE
      )
   IS
      SELECT
         EMPNO,
         ENAME,
         JOB,
         MGR,
         HIREDATE,
         SAL,
         COMM,
         DEPTNO
        FROM EMP
       WHERE
          DEPTNO = fk_deptno_all_cur.deptno_in
      ;

--// Cursor management procedures //--

   --// Open the cursors with some options. //--
   PROCEDURE open_allforpky_cur (
      empno_in IN EMP.EMPNO%TYPE,
      close_if_open IN BOOLEAN := TRUE
      );

   PROCEDURE open_allbypky_cur (
      close_if_open IN BOOLEAN := TRUE
      );

   PROCEDURE open_fk_deptno_all_cur (
      deptno_in IN EMP.DEPTNO%TYPE,
      close_if_open IN BOOLEAN := TRUE
      );

   --// Close the cursors if they are open. //--
   PROCEDURE close_allforpky_cur;
   PROCEDURE close_allbypky_cur;
   PROCEDURE close_fk_deptno_all_cur;
   PROCEDURE closeall;

--// Analyze presence of primary key: is it NOT NULL? //--

   FUNCTION isnullpky (
      rec_in IN EMP%ROWTYPE
      )
   RETURN BOOLEAN;

   FUNCTION isnullpky (
      rec_in IN pky_rt
      )
   RETURN BOOLEAN;

--// Emulate aggregate-level record operations. //--

   FUNCTION recseq (rec1 IN EMP%ROWTYPE, rec2 IN EMP%ROWTYPE)
   RETURN BOOLEAN;

   FUNCTION recseq (rec1 IN pky_rt, rec2 IN pky_rt)
   RETURN BOOLEAN;

--// Fetch Data //--

   --// Fetch one row of data for a primary key. //--
   FUNCTION onerow (
      empno_in IN EMP.EMPNO%TYPE
      )
   RETURN EMP%ROWTYPE;


   --// Count of all rows in table and for each foreign key. //--
   FUNCTION rowcount RETURN INTEGER;
   FUNCTION pkyrowcount (
      empno_in IN EMP.EMPNO%TYPE
      )
      RETURN INTEGER;
   FUNCTION fk_deptnorowcount (
      deptno_in IN EMP.DEPTNO%TYPE
      )
      RETURN INTEGER;
--// Update Processing //--

   PROCEDURE reset$frc;

   --// Force setting of NULL values //--

   FUNCTION ename$frc
      (ename_in IN EMP.ENAME%TYPE DEFAULT NULL)
      RETURN EMP.ENAME%TYPE;

   FUNCTION job$frc
      (job_in IN EMP.JOB%TYPE DEFAULT NULL)
      RETURN EMP.JOB%TYPE;

   FUNCTION mgr$frc
      (mgr_in IN EMP.MGR%TYPE DEFAULT NULL)
      RETURN EMP.MGR%TYPE;

   FUNCTION hiredate$frc
      (hiredate_in IN EMP.HIREDATE%TYPE DEFAULT NULL)
      RETURN EMP.HIREDATE%TYPE;

   FUNCTION sal$frc
      (sal_in IN EMP.SAL%TYPE DEFAULT NULL)
      RETURN EMP.SAL%TYPE;

   FUNCTION comm$frc
      (comm_in IN EMP.COMM%TYPE DEFAULT NULL)
      RETURN EMP.COMM%TYPE;

   FUNCTION deptno$frc
      (deptno_in IN EMP.DEPTNO%TYPE DEFAULT NULL)
      RETURN EMP.DEPTNO%TYPE;

   PROCEDURE upd (
      empno_in IN EMP.EMPNO%TYPE,
      ename_in IN EMP.ENAME%TYPE DEFAULT NULL,
      job_in IN EMP.JOB%TYPE DEFAULT NULL,
      mgr_in IN EMP.MGR%TYPE DEFAULT NULL,
      hiredate_in IN EMP.HIREDATE%TYPE DEFAULT NULL,
      sal_in IN EMP.SAL%TYPE DEFAULT NULL,
      comm_in IN EMP.COMM%TYPE DEFAULT NULL,
      deptno_in IN EMP.DEPTNO%TYPE DEFAULT NULL,
      rowcount_out OUT INTEGER,
      reset_in IN BOOLEAN DEFAULT TRUE
      );

   --// Record-based Update //--

   PROCEDURE upd (rec_in IN EMP%ROWTYPE,
      rowcount_out OUT INTEGER,
      reset_in IN BOOLEAN DEFAULT TRUE);

--// Insert Processing //--

   --// Initialize record with default values. //--
   FUNCTION initrec (allnull IN BOOLEAN := FALSE) RETURN EMP%ROWTYPE;

   --// Initialize record with default values. //--
   PROCEDURE initrec (
      rec_inout IN OUT EMP%ROWTYPE,
      allnull IN BOOLEAN := FALSE);

   PROCEDURE ins (
      empno_in IN EMP.EMPNO%TYPE,
      ename_in IN EMP.ENAME%TYPE DEFAULT NULL,
      job_in IN EMP.JOB%TYPE DEFAULT NULL,
      mgr_in IN EMP.MGR%TYPE DEFAULT NULL,
      hiredate_in IN EMP.HIREDATE%TYPE DEFAULT NULL,
      sal_in IN EMP.SAL%TYPE DEFAULT NULL,
      comm_in IN EMP.COMM%TYPE DEFAULT NULL,
      deptno_in IN EMP.DEPTNO%TYPE DEFAULT NULL,
      upd_on_dup IN BOOLEAN := FALSE
      );

   --// Record-based insert //--
   PROCEDURE ins (rec_in IN EMP%ROWTYPE,
      upd_on_dup IN BOOLEAN := FALSE
      );

--// Delete Processing //--
   PROCEDURE del (
      empno_in IN EMP.EMPNO%TYPE,
      rowcount_out OUT INTEGER);

   --// Record-based delete //--
   PROCEDURE del (rec_in IN pky_rt,
      rowcount_out OUT INTEGER);

   PROCEDURE del (rec_in IN EMP%ROWTYPE,
      rowcount_out OUT INTEGER);

   --// Delete all records for this FK_DEPTNO foreign key. //--
   PROCEDURE delby_fk_deptno (
      deptno_in IN EMP.DEPTNO%TYPE,
      rowcount_out OUT INTEGER
      );

   --// Program called by database initialization script to pin the package. //--
   PROCEDURE pinme;
END te_emp;
/
