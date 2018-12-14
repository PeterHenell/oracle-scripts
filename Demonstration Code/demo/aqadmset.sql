/* Set up account to administrate Oracle/AQ */

GRANT AQ_ADMINISTRATOR_ROLE TO &&firstparm;

EXECUTE DBMS_AQADM.GRANT_TYPE_ACCESS ('&&firstparm');