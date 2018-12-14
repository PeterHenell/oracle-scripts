DECLARE
   mytab psemp.emp_tabtype;
BEGIN
   p.l (mytab.COUNT);
   p.l (psemp.emp_tab.COUNT);
END;
/

DECLARE
   v_row PLS_INTEGER := psemp.emp_tab.FIRST;
BEGIN
   psemp.emp_tab (1000000).ename := 'Steven';
   p.l (psemp.emp_tab.COUNT);
   
   LOOP
      EXIT WHEN v_row IS NULL;
      p.l (psemp.emp_tab(v_row).ename, v_row);
      v_row := psemp.emp_tab.NEXT (v_row);
   END LOOP;
END;
/

