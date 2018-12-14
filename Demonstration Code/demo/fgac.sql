/* 
   Year 2010, National Healthcare System!
   Doctors can only see those patients who are assigned to their clinic. 
   Regulators can only see those patients who reside in the same state.
   Patients can only see information about themselves. 
   
   NOTE: if your SYSTEM logon trigger fails after creation, you will find
         yourself unable to log in. Instead you will get this error:
         
         ORA-04045: errors during recompilation/revalidation of SYSTEM.SET_ID_ON_LOGON
         
         In this case, connect INTERNAL (default password ORACLE) and then
         drop the trigger:
         
         DROP TRIGGER SYSTEM.SET_ID_ON_LOGON;
*/      

CONNECT sys/sys as sysdba;
/* Avoid recursive errors on login. */
DROP TRIGGER SYSTEM.set_id_on_logon;

CONNECT sys/sys as sysdba;

/* Let SCOTT create system contexts. */
GRANT CREATE ANY CONTEXT TO SCOTT;
GRANT CREATE PUBLIC SYNONYM TO SCOTT;
GRANT EXECUTE_CATALOG_ROLE TO SCOTT;

DROP CONTEXT patient_restriction;

DROP USER csilva;
DROP USER efeuerstein;
DROP USER mfwalsh;
DROP USER ddeurso;
DROP USER swallace;
DROP USER rgoldmisal;
DROP USER arodriguez;
DROP USER png;
DROP USER jhalloway;
DROP USER shaximo;

DROP PUBLIC SYNONYM patient;
DROP PUBLIC SYNONYM doctor;
DROP PUBLIC SYNONYM regulator;
DROP PUBLIC SYNONYM clinic;

DROP PUBLIC SYNONYM nhc_pkg;
   
CONNECT scott/tiger

DROP TABLE patient;
DROP TABLE doctor;
DROP TABLE regulator;
DROP TABLE clinic;

DROP PACKAGE nhc_pkg;

CREATE TABLE patient  (
   patient_id NUMBER,
   schema_name VARCHAR2(30),
   last_name VARCHAR2(100),
   first_name VARCHAR2(100),
   dob DATE,
   home_clinic_id INTEGER,
   state CHAR(2)
   ); 

CREATE TABLE doctor (
   doctor_id NUMBER,
   schema_name VARCHAR2(30),
   last_name VARCHAR2(100),
   first_name VARCHAR2(100),
   home_clinic_id INTEGER
   );
   
CREATE TABLE regulator (
   regulator_id NUMBER,
   schema_name VARCHAR2(30),
   last_name VARCHAR2(100),
   first_name VARCHAR2(100),
   state CHAR(2)
   );

CREATE TABLE clinic (
   clinic_id INTEGER,
   name VARCHAR2(100),
   state CHAR(2)
   );

GRANT ALL ON patient TO PUBLIC;
GRANT ALL ON doctor TO PUBLIC;
GRANT ALL ON regulator TO PUBLIC;
GRANT ALL ON clinic TO PUBLIC;
CREATE PUBLIC SYNONYM patient FOR patient;
CREATE PUBLIC SYNONYM doctor FOR doctor;
CREATE PUBLIC SYNONYM regulator FOR regulator;
CREATE PUBLIC SYNONYM clinic FOR clinic;
   
INSERT INTO clinic VALUES (10, 'Argyle Health Center', 'IL');
INSERT INTO clinic VALUES (15, 'Rogers Park Health Center', 'IL');
INSERT INTO clinic VALUES (12, 'Queens Health Center', 'NY');
INSERT INTO clinic VALUES (13, 'Somers Health Center', 'NY');
   
INSERT INTO patient VALUES (
   100, 'CSILVA', 'Silva', 'Chris', '20-MAR-72', 10, 'IL');   
INSERT INTO patient VALUES (
   100, 'VSILVA', 'Silva', 'Veva', '10-JUN-56', 10, 'IL');   
INSERT INTO patient VALUES (
   101, 'EFEUERSTEIN', 'Feuerstein', 'Eli', '01-OCT-86', 15, 'IL');   
INSERT INTO patient VALUES (
   105, 'MFWALSH', 'Walsh', 'Markus Finnbar', '24-APR-98', 12, 'NY');   
INSERT INTO patient VALUES (
   112, 'DDEURSO', 'DeUrso', 'Danielle', '01-JAN-94', 13, 'NY'); 
INSERT INTO doctor VALUES ( 
   1060, 'SWALLACE', 'Wallace', 'Sandira', 10);    
INSERT INTO doctor VALUES ( 
   2134, 'RGOLDMISAL', 'Goldmisal', 'Rijard', 15);    
INSERT INTO doctor VALUES ( 
   6478, 'ARODRIGUEZ', 'Rodriguez', 'Angel', 12);    
INSERT INTO doctor VALUES ( 
   9024, 'PNG', 'Ng', 'Paula', 13);    
INSERT INTO regulator VALUES ( 
   540, 'JHALLOWAY', 'Halloway', 'John', 'IL');    
INSERT INTO regulator VALUES ( 
   542, 'SHAXIMO', 'Maximo', 'Suni', 'NY');   
   
CREATE CONTEXT patient_restriction USING nhc_pkg;

@@nhc.pkg

BEGIN
  DBMS_RLS.DROP_POLICY (
    'SCOTT', 'patient', 'patient_privacy');
END;
/

/* Define a policy that invokes the predicate. */   
BEGIN
   DBMS_RLS.ADD_POLICY (
      OBJECT_SCHEMA    => 'SCOTT',
      OBJECT_NAME      => 'patient',
      POLICY_NAME      => 'patient_privacy',
      FUNCTION_SCHEMA  => 'SCOTT',
      POLICY_FUNCTION  => 'nhc_pkg.person_predicate',
      STATEMENT_TYPES  => 'SELECT,UPDATE,DELETE,INSERT',
	  UPDATE_CHECK     => TRUE);
END;  
/

CONNECT system/system

/* Create a LOGON trigger that automatically sets
   the NHC privacy attributes. */
   
CREATE OR REPLACE TRIGGER set_id_on_logon
AFTER logon ON DATABASE
BEGIN
   nhc_pkg.set_context;
EXCEPTION
   WHEN OTHERS 
   THEN
      DBMS_OUTPUT.PUT_LINE (
         'Error ' || SQLCODE || ' setting context for ' || USER);
END;
/

/* Create test schemas. */
CONNECT system/system

CREATE USER csilva  IDENTIFIED BY      csilva;
CREATE USER efeuerstein IDENTIFIED BY  efeuerstein;
CREATE USER mfwalsh IDENTIFIED BY      mfwalsh;
CREATE USER ddeurso IDENTIFIED BY      ddeurso;
CREATE USER swallace  IDENTIFIED BY    swallace;
CREATE USER rgoldmisal IDENTIFIED BY   rgoldmisal; 
CREATE USER arodriguez IDENTIFIED BY   arodriguez; 
CREATE USER png IDENTIFIED BY          png;
CREATE USER jhalloway IDENTIFIED BY    jhalloway;
CREATE USER shaximo IDENTIFIED BY      shaximo;

GRANT CONNECT,RESOURCE TO csilva;
GRANT CONNECT,RESOURCE TO efeuerstein IDENTIFIED BY  efeuerstein;
GRANT CONNECT,RESOURCE TO mfwalsh IDENTIFIED BY      mfwalsh;
GRANT CONNECT,RESOURCE TO ddeurso IDENTIFIED BY      ddeurso;
GRANT CONNECT,RESOURCE TO swallace  IDENTIFIED BY    swallace;
GRANT CONNECT,RESOURCE TO rgoldmisal IDENTIFIED BY   rgoldmisal; 
GRANT CONNECT,RESOURCE TO arodriguez IDENTIFIED BY   arodriguez; 
GRANT CONNECT,RESOURCE TO png IDENTIFIED BY          png;
GRANT CONNECT,RESOURCE TO jhalloway IDENTIFIED BY    jhalloway;
GRANT CONNECT,RESOURCE TO shaximo IDENTIFIED BY      shaximo;

CONNECT csilva/csilva
@@ssoo
PROMPT
PROMPT Connected as CSILVA - A Patient
PROMPT
@@showpatients

CONNECT swallace/swallace
@@ssoo
PROMPT
PROMPT Connected as SWALLACE - A Doctor
PROMPT
@@showpatients

BEGIN
   -- Try to insert a patient in another clinic.
   -- SWALLACE practices in IL, clinic 12 is in NY, 10 in IL.
   BEGIN
      INSERT INTO patient
           VALUES (1901, 'BRILEY', 'Riley', 'Brillo', '01-OCT-86', 12, 'NY');
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (   'NY: '
                               || SQLERRM);
   END;

   INSERT INTO patient
        VALUES (1901, 'BRILEY', 'Riley', 'Brillo', '01-OCT-86', 10, 'IL');

   DBMS_OUTPUT.put_line ('IL: Brillo added!');
END;

/

CONNECT shaximo/shaximo
@@ssoo
PROMPT
PROMPT Connected as SHAXIMO - A Regulator
PROMPT
@@showpatients

CONNECT scott/tiger
@@ssoo
SET FEEDBACK OFF
PROMPT
PROMPT Connected as SCOTT - A Former HMO CEO
PROMPT
@@showpatients
