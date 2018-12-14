/* Formatted on 2002/02/19 01:44 (Formatter Plus v4.6.0) */
-- Start of DDL Script for Package Body ROHANB.DSF_ERR_IFS
-- Generated 18-Feb-2002 9:11:10 from ROHANB@DHDBDEV.WORLD

CREATE OR REPLACE PACKAGE BODY dsf_err_ifs
IS
   -- PL/SQL Private Declaration
   /*******************************************************************************
  *
  * Company Name: TENIX DEFENCE PTY LTD Electronic Systems Division (copyright 2001)
  * Project     : SEA 1430           Contract Number : C438801
  * Platform    : UNIX
  *
  * Workset File Name  : PDSFQA_ERR_pkb.sql
  * Item Revision      : 5
  * Item Specification : DHDB:PDSFQA_ERR_PKB SQL.A-SRC;5
  * Description :
  *    Persistence Dataset Full CSU interface.
  *    Contains error handling routines and exceptions.
  *
  *******************************************************************************/
   -- Sub-Program Units
   /* Generically Raises Exception */
   /*******************************************************************************
  * Name:        RAISE_EXCEPTION
  * Description: Processes a specified exception.
  *
  *******************************************************************************/
   PROCEDURE raise_exception (
      i_exception        IN   VARCHAR2,
      i_err_msg_par      IN   VARCHAR2 := NULL,
      i_err_cause_par    IN   VARCHAR2 := NULL,
      i_err_action_par   IN   VARCHAR2 := NULL
   )
   IS
   -- PL/SQL Block
   BEGIN
      IF i_err_msg_par IS NOT NULL
      THEN
         
-------------------------------------------------
-- Set the substitution parameter for the user
-- defined (-20nnn) error message.
-------------------------------------------------
         com_exception_proc_ifs.set_dynamic_desc (
            i_err_msg_par
         );
         com_exception_proc_ifs.set_dynamic_cause (
            i_err_cause_par
         );
         com_exception_proc_ifs.set_dynamic_action (
            i_err_action_par
         );
      END IF;

      
----------------------------------------------------
-- Raise the exception as the assumption is not true
----------------------------------------------------
      EXECUTE IMMEDIATE    'BEGIN RAISE '
                        || i_exception
                        || '; END;';
   END raise_exception;

   /* Places the error (with parameter substituton) on the error text array */
   PROCEDURE set_error_text (
      io_meta_errors   IN OUT NOCOPY   long_text_coltype,
      i_exception      IN              VARCHAR2,
      i_err_msg_par    IN              VARCHAR2
            := NULL
   )
   IS
      -- PL/SQL Specification
      /*******************************************************************************
     * Name:        SET_ERROR_TEXT
     * Description: Places the error (with parameter substitution) on the error text collection
     *
     *******************************************************************************/
      l_error_desc     com_dhdb_exceptions.error_desc%TYPE;
      l_error_cause    com_dhdb_exceptions.error_cause%TYPE;
      l_error_action   com_dhdb_exceptions.error_action%TYPE;
   -- PL/SQL Block
   BEGIN
      dsf_err_ifs.raise_exception (
         i_exception,
         i_err_msg_par
      );
   EXCEPTION
      WHEN OTHERS
      THEN
         com_exception_proc_ifs.get_exception_info (
            SQLCODE,
            l_error_desc,
            l_error_cause,
            l_error_action
         );

         IF (io_meta_errors IS NULL)
         THEN
            io_meta_errors :=
                             long_text_coltype ();
         END IF;

         io_meta_errors.EXTEND;
         io_meta_errors (io_meta_errors.LAST) :=
            long_text_objtype (
                  l_error_desc
               || ' ('
               || TO_CHAR (SQLCODE)
               || ')'
            );
   END set_error_text;
-- PL/SQL Block
END dsf_err_ifs;
/


-- End of DDL Script for Package Body ROHANB.DSF_ERR_IFS

