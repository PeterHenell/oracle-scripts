/*
| This program is a part of Qut:
| Qut - Quick Unit Tester
| Design, Generate, Run Test Code
| www.unit-test.com
| 
| Copyright, PL/Solutions, 2003-2004
| All rights reserved
*/

CREATE TABLE qu_result 
(
   universal_id         VARCHAR2(100),
   result_level         VARCHAR2(100) /* HARNESS, UNITTEST, TESTCASE, OUTCOME */,
   result_universal_id  VARCHAR2(100),
   parent_universal_id  VARCHAR2(100),
   result_status        VARCHAR2(100) /* SUCCESS or FAILURE */,
   description          VARCHAR2(4000),
   start_on             DATE,
   end_on               DATE,
   harness_guid         VARCHAR2(100),
   created_on           DATE,
   created_by           VARCHAR2(100),
   changed_on           DATE,
   changed_by           VARCHAR2(100)
)
/
