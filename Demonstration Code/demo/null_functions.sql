/*
Demonstrations of various NULL functions available in PL/SQL

COALESCE - returns the first non-null expr in the expression list.
NULLIF   - compares expr1 and expr2. If they are equal, then the function returns null. If they are not equal, then the function returns expr1. 
NVL      - If expr1 is null, then NVL returns expr2. If expr1 is not null, then NVL returns expr1.

Only in SQL....
LNNVL - Takes as an argument a condition and returns TRUE if the condition is FALSE or UNKNOWN and FALSE if the condition is TRUE.
NVL2  - If expr1 is not null, then NVL2 returns expr2. If expr1 is null, then NVL2 returns expr3.

*/

DECLARE
   l_var1   NUMBER := NULL;
   l_var2   NUMBER := NULL;
   l_var3   NUMBER := 3;
BEGIN
   IF COALESCE (l_var1, l_var2, l_var3) = 3
   THEN
      DBMS_OUTPUT.put_line ('COALESCE: first non-NULL is third variable');
   END IF;

   IF COALESCE (l_var1, l_var2) IS NULL
   THEN
      DBMS_OUTPUT.put_line ('COALESCE: all NULL returns NULL');
   END IF;
END;
/

DECLARE
   l_var1    VARCHAR2 (100) := 'NULLIF: NE -> l_var1';
   l_var2    VARCHAR2 (100) := 2;
   l_null1   VARCHAR2 (100);
   l_null2   VARCHAR2 (100);
BEGIN
   DBMS_OUTPUT.put_line (NVL (NULLIF (l_var1, l_var1), 'NULLIF: EQ -> NULL'));
   DBMS_OUTPUT.put_line (NULLIF (l_var1, l_var2));
   DBMS_OUTPUT.put_line (
      NVL (NULLIF (l_null1, l_null2), 'NULLIF: Both NULL -> NULL')
   );
END;
/

DECLARE
   l_var1    VARCHAR2 (100) := 'NOT NULL so we see this one';
   l_var2    VARCHAR2 (100) := NULL;
   l_var3    VARCHAR2 (100) := '2 IS NULL so we see this one';
   l_null1   VARCHAR2 (100);
   l_null2   VARCHAR2 (100);
BEGIN
   DBMS_OUTPUT.put_line ('NVL: ' || NVL (l_var1, l_var2));
   DBMS_OUTPUT.put_line ('NVL: ' || NVL (l_var2, l_var3));
   DBMS_OUTPUT.put_line (
      'NVL: ' || NVL (NVL (l_null1, l_null2), 'Both NULL returns NULL')
   );
END;
/

/* Only in SQL...
DECLARE
   l_var1        VARCHAR2 (100) := 'NOT NULL';
   l_var2        VARCHAR2 (100) := 'l_var1 is not null so we see l_var2';
   l_var1_null   VARCHAR2 (100) := NULL;
   l_var3        VARCHAR2 (100) := 'l_var1_null is not null so we see l_var3';
   l_null1       VARCHAR2 (100);
   l_null2       VARCHAR2 (100);
BEGIN
   DBMS_OUTPUT.put_line ('NVL2: ' || NVL2 (l_var1, l_var2, l_var3));
   DBMS_OUTPUT.put_line ('NVL2: ' || NVL2 (l_var1_null, l_var2, l_var3));
   DBMS_OUTPUT.put_line('NVL2: '
                        || NVL (NVL (l_null1, l_null2, l_var1)
                              , 'All NULL returns NULL'
                               ));
END;
*/