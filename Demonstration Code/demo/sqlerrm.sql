BEGIN
   RAISE TOO_MANY_ROWS;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLERRM);
END;
/

BEGIN
   DBMS_OUTPUT.put_line (SQLERRM (-1422));
END;
/

/*  -1422: non-ORACLE exception  */

BEGIN
   DBMS_OUTPUT.put_line (SQLERRM (1422));
END;
/

BEGIN
   RAISE TOO_MANY_ROWS;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_stack);
END;
/

/* PLS-00306: wrong number or types of arguments in call to 'FORMAT_ERROR_STACK' */

BEGIN
   DBMS_OUTPUT.put_line (
      DBMS_UTILITY.format_error_stack (-1422));
END;
/

BEGIN
   DBMS_OUTPUT.put_line (
      DBMS_UTILITY.format_error_stack (1422));
END;
/