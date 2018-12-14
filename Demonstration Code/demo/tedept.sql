/**************************************************************************
<Application Name>

(c) COPYRIGHT <Company>. <Year>.  All rights reserved.  No part of this
copyrighted work may be reproduced, modified, or distributed in any form or
by any means without the prior written permission of <Company>.
**************************************************************************/

/**************************************************************************
Script Name    : <tablename>.sps
Programmer     : <programmer name>
Started On     : <date>
Object Name    : <apppre>_<tablename>
Synopsis       : Package specification for <tablename> table functions
Description    : This package specification provides the interface for
                 the basic operations on the <tablename> table
**************************************************************************/

CREATE OR REPLACE PACKAGE <apppre>_<tablename>
AS

   /* Define the PL/SQL table type to be used to define variables. */
   TYPE plsql_type IS TABLE OF <tablename>%ROWTYPE
     INDEX BY BINARY_INTEGER;

   /* Define the new and old package variables to hold PL/SQL tables. */
   new_tab plsql_type;
   old_tab plsql_type;

   FUNCTION clear_rec
      RETURN <tablename>%ROWTYPE;

   PROCEDURE delete_pk
      (<ac_pkcolumns> IN <tablename>.<pkcolumns>%TYPE,
       ai_row_count OUT INTEGER);

   FUNCTION exists_pk
      (<ac_pkcolumns> IN <tablename>.<pkcolumns>%TYPE)
      RETURN BOOLEAN;

   FUNCTION get_pk
      (<ac_pkcolumns> IN <tablename>.<pkcolumns>%TYPE)
      RETURN <tablename>%ROWTYPE;

   PROCEDURE insert_row
      (ac_<pkcolumns> IN <tablename>.<pkcolumns>%TYPE);

END <apppre>_<tablename>;

/**************************************************************************
* Modification History:
*
**************************************************************************/
/

/**************************************************************************
Script Name    : <tablename>.spb
Programmer     : <programmer name>
Started On     : <date>
Object Name    : <apppre>_<tablename>
Message Prefix : <message prefix>
Synopsis       : Package body for <tablename> table functions
Description    : This package body provides the functions for the basic
                 operations on the <tablename> table
**************************************************************************/

CREATE OR REPLACE PACKAGE BODY <apppre>_<tablename>
AS

   /************************************************************************
                                Package Variables
   ************************************************************************/

   /* Class of the trace. */
   pc_trc_class <apppre>_common.pct_trc_class%TYPE;

   /* Text message to be used in tracing. */
   pc_trc_msg <apppre>_common.pct_msg%TYPE;


   /************************************************************************
                                 Private Modules
   ************************************************************************/

   /************************************************************************
   Programmer  : <programmer name>
   Started On  : <date>
   Object Name : insert_row
   Synopsis    : Insert a <tablename> table row
   Description : This procedure inserts a new row into the <tablename> table
                 using the arguments passed in.
   ************************************************************************/

   PROCEDURE insert_row
      (ac_<pkcolumns> IN <tablename>.<pkcolumns>%TYPE)
   AS
      /* Name of the procedure or function used in tracing. */
      lc_proc_name <apppre>_common.pct_object_name%TYPE := 'insert_row';

   BEGIN

      pc_trc_class := <apppre>_trc.pc_DB_INSERT;
      IF <apppre>_trc.is_on(pc_trc_class, lc_proc_name) THEN
         pc_trc_msg :=
            'Inserting into <tablename> for primary key: <pkcolumns>=' ||
            ac_<tablename>.<pkcolumns>;
            <apppre>_trc.trace(lc_proc_name, pc_trc_class, pc_trc_msg);
      END IF;

      <apppre>_exc.set_err_context('<message prefix>007', ar_<tablename>.<pkcolumns>);
         -- Message template is "Error inserting into <tablename> for <pkcolumns> %s"

      INSERT INTO <tablename>
                  (<columns>)
           VALUES (ar_<tablename>.<columns>);

      <apppre>_exc.clr_err_context;

   EXCEPTION
      WHEN OTHERS
      THEN
         <apppre>_exc.recNbail('<message prefix>008', <ac_pkcolumns>);
            -- Message template is "General exception inserting into <tablename> for <pkcolumns> %s"
   END insert_row;

   /************************************************************************
                                 Public Modules
   ************************************************************************/

   /************************************************************************
   Programmer  : <programmer name>
   Started On  : <date>
   Object Name : clear_rec
   Synopsis    : Return an empty record for the <tablename> table
   Description : This function returns an empty record defined like the
                 structure of the <tablename> table.
   ************************************************************************/

   FUNCTION clear_rec
      RETURN <tablename>%ROWTYPE
   AS
      /* Declare a record variable like the <tablename> table */
      lr_<tablename> <tablename>%ROWTYPE := NULL;

   BEGIN
      /*
      || By returning the record without setting any of its values,
      || it is returning an "empty" record.
      */
      RETURN lr_<tablename>;
   END clear_rec;


   /************************************************************************
   Programmer  : <programmer name>
   Started On  : <date>
   Object Name : delete_pk
   Synopsis    : Delete a <tablename> table row given a primary key
   Description : This procedure deletes the row from the <tablename> table
                 with the corresponding primary key.
   ************************************************************************/

   PROCEDURE delete_pk
      (<ac_pkcolumns> IN <tablename>.<pkcolumns>%TYPE,
       ai_row_count OUT INTEGER)
   AS
      /* Name of the procedure or function used in tracing. */
      lc_proc_name <apppre>_common.pct_object_name%TYPE := 'delete_pk';

   BEGIN

      pc_trc_class := <apppre>_trc.pc_DB_DELETE;
      IF <apppre>_trc.is_on(pc_trc_class, lc_proc_name) THEN
         pc_trc_msg :=
            'Deleting from <tablename> for primary key: <pkcolumns>=' ||
            <ac_pkcolumns>;
            <apppre>_trc.trace(lc_proc_name, pc_trc_class, pc_trc_msg);
      END IF;

      <apppre>_exc.set_err_context('<message prefix>001', <ac_pkcolumns>);
         -- Message template is "Error deleting from <tablename> for primary key with <pkcolumns> %s"

      DELETE FROM <tablename>
            WHERE <pkcolumns> = <ac_pkcolumns>;
      ai_row_count := SQL%ROWCOUNT;

      <apppre>_exc.clr_err_context;

   EXCEPTION
      WHEN OTHERS
      THEN
         <apppre>_exc.recNbail('<message prefix>002', <ac_pkcolumns>);
            -- Message template is "General exception deleting from <tablename> for primary key with <pkcolumns> %s"
   END delete_pk;


   /************************************************************************
   Programmer  : <programmer name>
   Started On  : <date>
   Object Name : exists_pk
   Synopsis    : Check for the existence of a <tablename> table row
   Description : This function checks to see if a particular row in the
                 <tablename> table exists given the primary key.  It
                 returns TRUE if it exists and false if does not.
   ************************************************************************/

   FUNCTION exists_pk
      (<ac_pkcolumns> IN <tablename>.<pkcolumns>%TYPE)
      RETURN BOOLEAN
   AS
      /* The return value that specifies whether the row exists */
      lb_exists BOOLEAN;

      /* Dummy place holder for the select statement results */
      lc_char   CHAR(1);

      /* Name of the procedure or function used in tracing. */
      lc_proc_name <apppre>_common.pct_object_name%TYPE := 'exists_pk';

   BEGIN
      BEGIN

         pc_trc_class := <apppre>_trc.pc_DB_READ;
         IF <apppre>_trc.is_on(pc_trc_class, lc_proc_name) THEN
            pc_trc_msg :=
               'Selecting from <tablename> for primary key: <pkcolumns>=' ||
               <ac_pkcolumns>;
            <apppre>_trc.trace(lc_proc_name, pc_trc_class, pc_trc_msg);
         END IF;

         <apppre>_exc.set_err_context('<message prefix>003', <ac_pkcolumns>);
            --  Message template is "Error determining existence of <tablename> for <pkcolumns> %s"

         /*
         || This is selecting 'x' as a dummy just to check whether the
         || record exists since the actual data selected is irrelevant.
         */
         SELECT 'x'
           INTO lc_char
           FROM <tablename>
          WHERE <pkcolumns> = <ac_pkcolumns>;

         <apppre>_exc.clr_err_context;

         lb_exists := TRUE;

      /*
      || This is a special case exception handler just to see if the
      || record does not exist and based off of that, return a value
      || of FALSE.
      */
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lb_exists := FALSE;

            <apppre>_exc.clr_err_context;

            pc_trc_class := <apppre>_trc.pc_DB_READ;
            IF <apppre>_trc.is_on(pc_trc_class, lc_proc_name) THEN
               pc_trc_msg :=
                  '<tablename> record does not exist for primary key: ' ||
                  '<pkcolumns>=' || <ac_pkcolumns>;
               <apppre>_trc.trace(lc_proc_name, pc_trc_class, pc_trc_msg);
            END IF;
      END;

      RETURN lb_exists;

   EXCEPTION
      WHEN OTHERS
      THEN
         <apppre>_exc.recNbail('<message prefix>004', <ac_pkcolumns>);
            --  Message template is "General exception determining existence of <tablename> for <pkcolumns> %s"
   END exists_pk;


   /************************************************************************
   Programmer  : <programmer name>
   Started On  : <date>
   Object Name : get_pk
   Synopsis    : Return a <tablename> table row given a primary key
   Description : This function returns all columns for the corresponding
                 record in the <tablename> table for this primary key
                 combination.
   ************************************************************************/

   FUNCTION get_pk
      (<ac_pkcolumns> IN <tablename>.<pkcolumns>%TYPE)
      RETURN <tablename>%ROWTYPE
   AS
      /* Name of the procedure or function used in tracing. */
      lc_proc_name <apppre>_common.pct_object_name%TYPE := 'get_pk';

      /* Return value for this function. */
      lr_<tablename> <tablename>%ROWTYPE;

      /* A cursor to select all columns from <tablename> for a primary key */
      CURSOR l_<tablename>_cur
      IS
         SELECT *
           FROM <tablename>
          WHERE <pkcolumns> = <ac_pkcolumns>;

   BEGIN

      pc_trc_class := <apppre>_trc.pc_DB_READ;
      IF <apppre>_trc.is_on(pc_trc_class, lc_proc_name) THEN
         pc_trc_msg :=
            'Selecting from <tablename> for primary key: <pkcolumns>=' ||
            <ac_pkcolumns>;
            <apppre>_trc.trace(lc_proc_name, pc_trc_class, pc_trc_msg);
      END IF;

      <apppre>_exc.set_err_context('<message prefix>005', <ac_pkcolumns>);
         -- Message template is "Error selecting <tablename> record by primary key for <pkcolumns> %s"

      OPEN l_<tablename>_cur;
      FETCH l_<tablename>_cur INTO lr_<tablename>;
      CLOSE l_<tablename>_cur;

      <apppre>_exc.clr_err_context;

      RETURN lr_<tablename>;

   EXCEPTION
      WHEN OTHERS
      THEN
         <apppre>_exc.recNbail('<message prefix>006', <ac_pkcolumns>);
            -- Message template is "General exception selecting <tablename> record by primary key for <pkcolumns> %s"
   END get_pk;


END <apppre>_<tablename>;

/**************************************************************************
* Modification History:
*
**************************************************************************/
/
