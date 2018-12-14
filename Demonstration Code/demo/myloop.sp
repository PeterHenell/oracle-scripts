CREATE OR REPLACE PROCEDURE my_loop (
   p_tab           IN   tab_t,
   p_lower_bound   IN   PLS_INTEGER,
   p_upper_bound   IN   PLS_INTEGER
)
/*
Bryn Llewellyn

Template to loop through contents of a collection.

*/
IS
   v_lower_bound   PLS_INTEGER := p_lower_bound;
   v_upper_bound   PLS_INTEGER := p_upper_bound;
   j               PLS_INTEGER := p_tab.FIRST ();
BEGIN
   IF (v_lower_bound IS NULL) AND (v_upper_bound IS NULL)
   THEN
      v_lower_bound := p_tab.FIRST ();
      v_upper_bound := p_tab.LAST ();
   ELSIF v_lower_bound IS NULL
   THEN
      v_lower_bound := LEAST (p_tab.FIRST (), p_upper_bound);
   ELSIF v_upper_bound IS NULL
   THEN
      v_upper_bound := GREATEST (p_tab.LAST (), p_lower_bound);
   END IF;

   IF v_lower_bound > v_upper_bound
   THEN
      raise_application_error (-20000, 'v_lower_bound > v_upper_bound');
   END IF;

   LOOP
      EXIT WHEN (j >= v_lower_bound) OR (j IS NULL);
      j := p_tab.NEXT (j);
   END LOOP;

   IF j IS NOT NULL
   THEN
      LOOP
         EXIT WHEN (j > v_upper_bound) OR (j IS NULL);
		 --<ACTION HERE>
         --DBMS_OUTPUT.put_line (p_tab (j));
         j := p_tab.NEXT (j);
      END LOOP;
   END IF;
END my_loop;