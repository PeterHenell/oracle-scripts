/* session state quiz: when do you get -4068? Only if state. */

CONNECT hr/hr

CREATE OR REPLACE PACKAGE plch_pkg
IS
   c_language   CONSTANT VARCHAR2 (6) := 'PL/SQL';

   FUNCTION language_vendor
      RETURN VARCHAR2;
END plch_pkg;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   FUNCTION language_vendor
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'Oracle Corporation';
   END language_vendor;
END plch_pkg;
/

GRANT EXECUTE ON plch_pkg TO scott
/

/* Run this in a separate window and keep open */

CONNECT scott/tiger

BEGIN
   DBMS_OUTPUT.put_line (hr.plch_pkg.language_vendor);
END;
/

/* Now change the package definition in HR:
     - Change value and add function.
 */

CONNECT hr/hr

CREATE OR REPLACE PACKAGE plch_pkg
IS
   c_language   CONSTANT VARCHAR2 (13) := 'Oracle PL/SQL';

   FUNCTION language_vendor
      RETURN VARCHAR2;

   FUNCTION vendor_city
      RETURN VARCHAR2;
END plch_pkg;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   FUNCTION language_vendor
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'Oracle Corporation';
   END language_vendor;

   FUNCTION vendor_city
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'Redwood Shores';
   END vendor_city;
END plch_pkg;
/

/* Go back to Scott and try to display language vendor again 

ERROR at line 1:
ORA-04068: existing state of packages has been discarded
ORA-04061: existing state of package "HR.PLCH_PKG" has been invalidated
ORA-04065: not executed, altered or dropped package "HR.PLCH_PKG"
ORA-06508: PL/SQL: could not find program unit being called: "HR.PLCH_PKG"
ORA-06512: at line 2

*/

CONNECT scott/tiger

BEGIN
   DBMS_OUTPUT.put_line (hr.plch_pkg.language_vendor);
END;
/

/* In HR, separate out the "state" from the original package */

CONNECT hr/hr

CREATE OR REPLACE PACKAGE plch_pkg_constant
IS
   c_language   CONSTANT VARCHAR2 (6) := 'PL/SQL';
END plch_pkg_constant;
/

CREATE OR REPLACE PACKAGE plch_pkg
IS
   FUNCTION language_vendor
      RETURN VARCHAR2;
END plch_pkg;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   FUNCTION language_vendor
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'Oracle Corporation';
   END language_vendor;
END plch_pkg;
/

GRANT EXECUTE ON plch_pkg TO scott
/

GRANT EXECUTE ON plch_pkg_constant TO scott
/

/* Now repeat steps: including making a change to the package. 
   Try to run from scott, then change value, then 
   run it again. */

CREATE OR REPLACE PACKAGE plch_pkg
IS
   c_language   CONSTANT VARCHAR2 (13) := 'Oracle PL/SQL';

   FUNCTION language_vendor
      RETURN VARCHAR2;

   FUNCTION vendor_city
      RETURN VARCHAR2;
END plch_pkg;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   FUNCTION language_vendor
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'Oracle Corporation';
   END language_vendor;

   FUNCTION vendor_city
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'Redwood Shores';
   END vendor_city;
END plch_pkg;
/