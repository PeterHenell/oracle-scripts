/* Formatted on 2002/01/30 07:34 (Formatter Plus v4.6.0) */
DECLARE
   c_context            CONSTANT VARCHAR2 (30) := 'patient_restriction';
   c_person_type_attr   CONSTANT VARCHAR2 (30) := 'person_type';
   c_person_id_attr     CONSTANT VARCHAR2 (30) := 'person_id';
   c_patient            CONSTANT CHAR (7)      := 'PATIENT';
   c_doctor             CONSTANT CHAR (6)      := 'DOCTOR';
   c_regulator          CONSTANT CHAR (9)      := 'REGULATOR';
BEGIN
   DBMS_SESSION.set_context (c_context, c_person_type_attr, 'abc');
END;
