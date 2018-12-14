SET PAGESIZE 999

COLUMN name FORMAT A20
COLUMN Numdeps FORMAT 9999
COLUMN source_size FORMAT 9999999
COLUMN parsed_size FORMAT 9999999
COLUMN code_size FORMAT 9999999
COLUMN total_parse FORMAT 9999999
COLUMN total_code FORMAT 9999999

SELECT s.name, numdeps, 
       s.parsed_size, s.code_size
  FROM depsummary S
 WHERE s.owner = USER
   AND s.name LIKE UPPER ('&&firstparm')
 ORDER BY code_size DESC;

SELECT s.name, numdeps, 
       o.parsed_size, o.code_size, 
       s.parsed_size total_parse, s.code_size total_code
  FROM depsummary S, 
       (SELECT owner, name, -- Need GROUP BY for PACKAGE and PACKAGE BODY
               SUM (source_size) source_size,
               SUM (parsed_size) parsed_size, 
               SUM (code_size) code_size  
          FROM dba_object_size 
         GROUP BY owner, name) O
 WHERE s.owner = USER
   AND o.owner = USER
   AND s.name = o.name
   AND s.name LIKE UPPER ('&&firstparm')
 ORDER BY s.code_size DESC;
 
BEGIN
 /* Example results:
NAME                 NUMDEPS PARSED_SIZE CODE_SIZE
-------------------- ------- ----------- ---------
TE_LOCEMP_TST             15       90611    150332
TAB_EMPX                  13       80265    134250
TE_EMPLOYEE_TST           13       80265    134250
TE_LOCEMP                 14       80992    134250
TE_EMPLOYEE               12       53542     94163
SHOWEMPS                   2        6691      7530
EMPLIST_T                  1         359        56
GET_A_MESS_O_EMPS          4        1892        56
GET_A_MESS_O_EMPS80        4        1923        56

NAME                 NUMDEPS PARSED_SIZE CODE_SIZE TOTAL_PARSE TOTAL_CODE
-------------------- ------- ----------- --------- ----------- ----------
TE_LOCEMP_TST             15        1486     12450       90611     150332
TAB_EMPX                  13       19525     30558       80265     134250
TE_EMPLOYEE_TST           13        2377     23047       80265     134250
TE_LOCEMP                 14        9619     16082       80992     134250
TE_EMPLOYEE               12       26723     40087       53542      94163
SHOWEMPS                   2         569      1542        6691       7530
EMPLIST_T                  1         168         0         359         56
GET_A_MESS_O_EMPS          4        1710      1364        1892         56
GET_A_MESS_O_EMPS80        4        1353       935        1923         56
 */
 NULL;
END;
/
 