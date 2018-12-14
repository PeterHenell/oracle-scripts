Step 1 Use SUBTYPEs and anchored types for all VARCHAR2 declarations. (PL/SQL refactoring)

Step 1 in the refactoring of topic "Use SUBTYPEs and anchored types for all VAR
RCHAR2 declarations."

Universal ID = {61740103-E5F7-42EE-9EBD-8E9C20FACE1B}

CREATE OR REPLACE PACKAGE plsql_types
IS
   SUBTYPE max_varchar2_t IS VARCHAR2 (32767);
 
   SUBTYPE max_db_varchar2_t IS VARCHAR2 (4000);
END plsql_types;
/
 
CREATE OR REPLACE PACKAGE employee_types
IS
   SUBTYPE full_name_t IS VARCHAR2 (200);
END employee_types;
/
================================================================================
Step 2 Use SUBTYPEs and anchored types for all VARCHAR2 declarations. (PL/SQL refactoring)

Step 2 in the refactoring of topic "Use SUBTYPEs and anchored types for all VAR
RCHAR2 declarations."

A cuautionary tale about anchoring the declarations of parameters:

"I wanted to give you the downside of using anchored types. I have put into pla
ace a requirement here that we remove anchored types in procedure definitions a
as we touch old code and have prohibited its use in the future. For us, the dra
awbacks are much larger than the advantages. We have found that we virtually ne
ever change the data type of a column. Occasionally a varchar column will get l
longer, but anchored types have no advantage there. On the other hand, we regul
larly add columns and change indices and constraints. When using anchored types
s the package headers become invalid on ANY tiny change to ANY part of a refere
enced table definition, even if no column was touched. Header invalidations cas
scade as you know to invalidate other objects. This has caused us outages in th
he past when a small index tweak has caused our running system to go into deadl
lock (at least up to 8i Oracle does not recover on its own from a compilation i
induced deadlock). So, for us, no advantage, huge risk."

Universal ID = {227F4C55-E3B8-4D25-9DCF-67563BF6DC32}

DECLARE
   l_company_name   company.name%TYPE;
   l_description    plsql_types.max_varchar2_t;
   l_summary        plsql_types.max_db_varchar2_t;
   l_full_name      employee_types.full_name_t;
BEGIN
================================================================================
Step 0: Problematic code for  Use SUBTYPEs and anchored types for all VARCHAR2 declarations. (PL/SQL refactoring) 

The problematic code for that demonstrates "Use SUBTYPEs and anchored types for
r all VARCHAR2 declarations. (PL/SQL refactoring)"

Universal ID = {BD8274C4-6840-4441-BA31-2FD0A226BB6E}

DECLARE
   l_company_name   VARCHAR2 (100);
   l_description    VARCHAR2 (32767);
   l_summary        VARCHAR2 (2000);
   l_full_name      VARCHAR2 (200);
BEGIN
================================================================================
