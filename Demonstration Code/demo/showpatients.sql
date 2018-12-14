BEGIN
   nhc_pkg.show_context;
   
   DBMS_OUTPUT.PUT_LINE (
      'Patients Visible to "' || USER || '":');
   FOR rec IN 
        (SELECT schema_name, 
                first_name || ' ' || last_name name, 
                state
           FROM patient) -- Unqualified query against base table
   LOOP
      DBMS_OUTPUT.PUT_LINE (
         rec.schema_name || ' - ' || rec.name || ' - ' || rec.state);
   END LOOP;
END;
/   
