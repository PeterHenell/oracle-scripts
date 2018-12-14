CREATE OR REPLACE PACKAGE longops
IS
   /*
   || Enhances DBMS_APPLICATION_INFO.SET_SESSION_LONGOPS
   || by allowing individual columns to be updated without
   || passing all parameter values.
   ||
   || Author:  John Beresniewicz, Savant Corp
   || Created: 09/08/97
   ||
   || Compilation Requirements:
   || SELECT on SYS.V_$SESSION_LONGOPS
   ||
   || Execution Requirements:
   ||
   ||
   */

   /* returns a new V$SESSION_LONGOPS row index */
   FUNCTION new_row RETURN BINARY_INTEGER;

   /* returns the last row index used */
   FUNCTION current_row RETURN BINARY_INTEGER;

   /* makes a new row the current row */
   PROCEDURE set_current_row
      (row_idx_IN IN BINARY_INTEGER);

   /* 
   || Covers DBMS_APPLICATION_INFO.SET_SESSION_LONGOPS
   */
   PROCEDURE set_row
      (hint_IN IN BINARY_INTEGER
      ,context_IN IN NUMBER DEFAULT 0
      ,stepid_IN IN NUMBER DEFAULT 0
      ,stepsofar_IN IN NUMBER DEFAULT 0
      ,steptotal_IN IN NUMBER DEFAULT 0
      ,sofar_IN IN NUMBER DEFAULT 0
      ,totalwork_IN IN NUMBER DEFAULT 0
      ,appdata1_IN IN NUMBER DEFAULT 0
      ,appdata2_IN IN NUMBER DEFAULT 0
      ,appdata3_IN IN NUMBER DEFAULT 0);

   /*
   || Updates a single row in V$SESSION_LONGOPS
   || preserving values in columns corresponding
   || to parameters passed as NULL.
   */
   PROCEDURE update_row
      (hint_IN IN BINARY_INTEGER DEFAULT current_row
      ,context_IN IN NUMBER DEFAULT NULL
      ,stepid_IN IN NUMBER DEFAULT NULL
      ,stepsofar_IN IN NUMBER DEFAULT NULL
      ,steptotal_IN IN NUMBER DEFAULT NULL
      ,sofar_IN IN NUMBER DEFAULT NULL
      ,totalwork_IN IN NUMBER DEFAULT NULL
      ,appdata1_IN IN NUMBER DEFAULT NULL
      ,appdata2_IN IN NUMBER DEFAULT NULL
      ,appdata3_IN IN NUMBER DEFAULT NULL);

END longops;
/

CREATE OR REPLACE PACKAGE BODY longops
IS
   current_row_   BINARY_INTEGER;

   TYPE longops_tabtype IS TABLE OF sys.v_$session_longops%ROWTYPE
      INDEX BY BINARY_INTEGER;

   my_longops_tab longops_tabtype;

   FUNCTION current_row RETURN BINARY_INTEGER
   IS
   BEGIN
      RETURN current_row_;
   END current_row;

   PROCEDURE set_current_row
      (row_idx_IN IN BINARY_INTEGER)
   IS
   BEGIN
      current_row_ := row_idx_IN;
   END set_current_row;


   FUNCTION new_row RETURN BINARY_INTEGER
   IS

      temp_idx  BINARY_INTEGER:=
            DBMS_APPLICATION_INFO.set_session_longops_nohint;
   BEGIN
      -- get row index
      DBMS_APPLICATION_INFO.SET_SESSION_LONGOPS
         (hint=>temp_idx);
      
      -- initialize row in my_longops_tab
      my_longops_tab(temp_idx).context := 0;
      my_longops_tab(temp_idx).stepid := 0;
      my_longops_tab(temp_idx).stepsofar := 0;
      my_longops_tab(temp_idx).steptotal := 0;
      my_longops_tab(temp_idx).sofar := 0;
      my_longops_tab(temp_idx).totalwork := 0;
      my_longops_tab(temp_idx).application_data_1 := 0;
      my_longops_tab(temp_idx).application_data_2 := 0;
      my_longops_tab(temp_idx).application_data_3 := 0;

      RETURN temp_idx;
   END new_row;

   PROCEDURE set_row
      (hint_IN IN BINARY_INTEGER
      ,context_IN IN NUMBER DEFAULT 0
      ,stepid_IN IN NUMBER DEFAULT 0
      ,stepsofar_IN IN NUMBER DEFAULT 0
      ,steptotal_IN IN NUMBER DEFAULT 0
      ,sofar_IN IN NUMBER DEFAULT 0
      ,totalwork_IN IN NUMBER DEFAULT 0
      ,appdata1_IN IN NUMBER DEFAULT 0
      ,appdata2_IN IN NUMBER DEFAULT 0
      ,appdata3_IN IN NUMBER DEFAULT 0)
   IS
   BEGIN
      update_row
         (hint_IN
         ,context_IN
         ,stepid_IN
         ,stepsofar_IN
         ,steptotal_IN
         ,sofar_IN
         ,totalwork_IN
         ,appdata1_IN
         ,appdata2_IN
         ,appdata3_IN);

   END set_row;

   PROCEDURE update_row
      (hint_IN IN BINARY_INTEGER DEFAULT current_row
      ,context_IN IN NUMBER DEFAULT NULL
      ,stepid_IN IN NUMBER DEFAULT NULL
      ,stepsofar_IN IN NUMBER DEFAULT NULL
      ,steptotal_IN IN NUMBER DEFAULT NULL
      ,sofar_IN IN NUMBER DEFAULT NULL
      ,totalwork_IN IN NUMBER DEFAULT NULL
      ,appdata1_IN IN NUMBER DEFAULT NULL
      ,appdata2_IN IN NUMBER DEFAULT NULL
      ,appdata3_IN IN NUMBER DEFAULT NULL)
   IS
      temp_hint_IN BINARY_INTEGER := hint_IN;
   BEGIN
      /*
      || First update saved row in my_longops_tab, any 
      || parameters which are NULL will not change the
      || saved row.
      */
      my_longops_tab(hint_IN).context := NVL(context_IN,
               my_longops_tab(hint_IN).context);
      my_longops_tab(hint_IN).stepid := NVL(stepid_IN,
               my_longops_tab(hint_IN).stepid);
      my_longops_tab(hint_IN).stepsofar := NVL(stepsofar_IN,
               my_longops_tab(hint_IN).stepsofar);
      my_longops_tab(hint_IN).steptotal := NVL(steptotal_IN,
               my_longops_tab(hint_IN).steptotal);
      my_longops_tab(hint_IN).sofar := NVL(sofar_IN,
               my_longops_tab(hint_IN).sofar);
      my_longops_tab(hint_IN).totalwork := NVL(totalwork_IN,
               my_longops_tab(hint_IN).totalwork);
      my_longops_tab(hint_IN).application_data_1 := NVL(appdata1_IN,
               my_longops_tab(hint_IN).application_data_1);
      my_longops_tab(hint_IN).application_data_2 := NVL(appdata2_IN,
               my_longops_tab(hint_IN).application_data_2);
      my_longops_tab(hint_IN).application_data_3 := NVL(appdata3_IN,
               my_longops_tab(hint_IN).application_data_3);

      /*
      || Now call DBMS_APPLICATION_INFO.SET_SESSION_LONGOPS
      || passing all parameters from the row in my_longops_tab.
      */
      DBMS_APPLICATION_INFO.SET_SESSION_LONGOPS
         (hint=>temp_hint_IN
         ,context=>my_longops_tab(hint_IN).context
         ,stepid=>my_longops_tab(hint_IN).stepid
         ,stepsofar=>my_longops_tab(hint_IN).stepsofar
         ,steptotal=>my_longops_tab(hint_IN).steptotal
         ,sofar=>my_longops_tab(hint_IN).sofar
         ,totalwork=>my_longops_tab(hint_IN).totalwork
         ,application_data_1=>
                  my_longops_tab(hint_IN).application_data_1
         ,application_data_2=>
                  my_longops_tab(hint_IN).application_data_2
         ,application_data_3=>
                  my_longops_tab(hint_IN).application_data_3
         );

      /* set the current row */
      set_current_row(hint_IN);

   END update_row;

END longops;
/

