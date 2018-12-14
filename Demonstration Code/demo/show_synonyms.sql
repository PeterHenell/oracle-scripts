SET serveroutput ON format wrapped

BEGIN
   Qnr.show_synonym ('QNR_TEST', 'ls_pkg');
   Qnr.show_synonym ('QNR_TEST', 'ps_pkg');
   Qnr.show_synonym ('PUBLIC', 'ps_pkg');
   Qnr.show_synonym ('QNR_TEST', 'ls_ls_pkg');
   Qnr.show_synonym ('QNR_TEST', 'ls_ps_pkg');
   Qnr.show_synonym ('QNR_TEST', 'ps_ls_pkg');
   Qnr.show_synonym ('PUBLIC', 'ps_ls_pkg');
END;
/
