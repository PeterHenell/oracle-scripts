/* Set up account to use Oracle/AQ with the ability to perform some
   administrative options like Create Queue Table and Create Queue. */

GRANT AQ_USER_ROLE TO &&firstparm;

EXECUTE DBMS_ADADM.GRANT_TYPE_ACCESS ('&&firstparm');