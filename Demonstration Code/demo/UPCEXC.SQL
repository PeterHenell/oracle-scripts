CREATE OR REPLACE PACKAGE upcexc
/*
||   File: afcexc.sql
|| Author: Steven Feuerstein
||   Date: 9/95
||
|| Package to provide generic exception handling and error logging
|| for AFC concurrency process.
*/
IS
   /* Types of exception handling to perform. */

   upc_update_failure EXCEPTION;
   c_errno_update_upc CONSTANT INTEGER := -20000;
   c_errmsg_update_upc CONSTANT VARCHAR2(100) := 
      'Unable to Update upc with new value.';

   no_reg_center EXCEPTION;
   c_errno_no_reg_center CONSTANT INTEGER := -20003;
   c_errmsg_no_reg_center CONSTANT VARCHAR2(100) := 
      'Regional Center has not been set, but is required.'; 

   /* Contexts for exception handling. */

   c_synch_upc_deletes CONSTANT VARCHAR2(3) := 'SUD';
   c_synch_upc_inserts CONSTANT VARCHAR2(3) := 'SUI';
   c_synch_upc_updates CONSTANT VARCHAR2(3) := 'SUU';

   c_log_upc_deletes CONSTANT VARCHAR2(3) := 'LUD';
   c_log_upc_inserts CONSTANT VARCHAR2(3) := 'LUI';
   c_log_upc_updates CONSTANT VARCHAR2(3) := 'LUU';

   PROCEDURE handle
      (context_in IN VARCHAR2,
       err_code_in IN INTEGER,
       handle_action_in IN VARCHAR2,
       upc_in IN upc.upc%TYPE,
       desc_in IN upc.description%TYPE);

   PROCEDURE handle
      (context_in IN VARCHAR2,
       err_code_in IN INTEGER,
       handle_action_in IN VARCHAR2,
       upc_in IN attribute.upc%TYPE,
       attribute_in IN attribute.attribute%TYPE,
       value_in IN attribute.value%TYPE);

   PROCEDURE validate_rows_affected;

END upcexc;
/
show errors
CREATE OR REPLACE PACKAGE BODY upcexc
IS
   /*------------------ Public Modules ------------------*/

   PROCEDURE handle
      (context_in IN VARCHAR2,
       err_code_in IN INTEGER,
       handle_action_in IN VARCHAR2,
       upc_in IN upc.upc%TYPE,
       desc_in IN upc.description%TYPE)
   IS
   BEGIN
      ps_exception.handle
         (context_in, err_code_in, handle_action_in,
          'UPC=' || upc_in || ' DESC=' || desc_in);
   END;

   PROCEDURE handle
      (context_in IN VARCHAR2,
       err_code_in IN INTEGER,
       handle_action_in IN VARCHAR2,
       upc_in IN attribute.upc%TYPE,
       attribute_in IN attribute.attribute%TYPE,
       value_in IN attribute.value%TYPE)
   IS
   BEGIN
      ps_exception.handle
         (context_in, err_code_in, handle_action_in,
          'UPC=' || upc_in || 
          ' ATTRIBUTE=' || attribute_in || 
          ' VALUE=' || value_in);
   END;

   PROCEDURE validate_rows_affected IS
   BEGIN
      IF SQL%ROWCOUNT = 0
      THEN
         RAISE no_data_modified;
      END IF;
   END;

END upcexc;
/
show errors
