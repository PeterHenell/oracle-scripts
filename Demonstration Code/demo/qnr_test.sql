SET serveroutput on size 1000000 format wrapped

BEGIN
   qnr.show ('u1.emp');
   qnr.show ('u1.dept');
   qnr.show ('u1.vemp');
   qnr.show ('u1.pkg');
   qnr.show ('u1.func');
   qnr.show ('u1.proc');
   qnr.show ('u1.objt');
   qnr.show ('u1.ls_emp');
   qnr.show ('u1.ls_dept');
   qnr.show ('u1.ls_pkg');
   qnr.show ('u1.ls_proc');
   qnr.show ('u1.ls_func');
   qnr.show ('u1.ls_objt');
   qnr.show ('ps_emp');
   qnr.show ('ps_dept');
   qnr.show ('ps_pkg');
   qnr.show ('ps_proc');
   qnr.show ('ps_func');
   qnr.show ('ps_objt');
   qnr.show ('ps_ls_emp');
   qnr.show ('ps_ls_dept');
   qnr.show ('ps_ls_pkg');
   qnr.show ('ps_ls_proc');
   qnr.show ('ps_ls_func');
   qnr.show ('ps_ls_objt');
   qnr.show ('ps_ps_emp');
   qnr.show ('ps_ps_dept');
   qnr.show ('ps_ps_pkg');
   qnr.show ('ps_ps_proc');
   qnr.show ('ps_ps_func');
   qnr.show ('ps_ps_objt');

   IF USER = 'U1'
   THEN
      qnr.show ('u1.ls_ls_emp');
      qnr.show ('u1.ls_ls_dept');
      qnr.show ('u1.ls_ls_pkg');
      qnr.show ('u1.ls_ls_proc');
      qnr.show ('u1.ls_ls_func');
      qnr.show ('u1.ls_ls_objt');
      qnr.show ('u1.ls_ps_emp');
      qnr.show ('u1.ls_ps_dept');
      qnr.show ('u1.ls_ps_pkg');
      qnr.show ('u1.ls_ps_proc');
      qnr.show ('u1.ls_ps_func');
      qnr.show ('u1.ls_ps_objt');
   END IF;
END;
/