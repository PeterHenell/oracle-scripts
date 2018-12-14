/* Formatted on 2002/04/01 00:44 (Formatter Plus v4.5.2) */
-- Start of DDL Script for Package ROHANB.DSF_ASSERT_IFS
-- Generated 18-Feb-2002 9:12:20 from ROHANB@DHDBDEV.WORLD

CREATE OR REPLACE PACKAGE dsf_assert_ifs
IS
   
-- Sub-Program Unit Declarations
/* Condition is True  assertion routine */
   PROCEDURE istrue (
      i_condition     IN   BOOLEAN,
      i_exception     IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   );

   
/* Value is not null assertion routine for numbers */
   PROCEDURE isnotnull (
      i_value         IN   NUMBER,
      i_err_msg_par   IN   VARCHAR2 := NULL
   );

   
/* Value is not null assertion routine for characters */
   PROCEDURE isnotnull (
      i_value         IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   );

   
/* Value is null assertion for characters */
   PROCEDURE isnull (
      i_value         IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   );

   
/* Value is null assertion for numbers */
   PROCEDURE isnull (
      i_value         IN   NUMBER,
      i_err_msg_par   IN   VARCHAR2 := NULL
   );

   
/* Status must be in use assertion routine */
   PROCEDURE isin_use (
      i_value         IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   );

   
/* 'Element  must be a Compound' assertion routine */
   PROCEDURE iscompound (
      i_value         IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   );

   
/* Compound lookup must be set use assertion routine */
   PROCEDURE islookup_allowed (
      i_value         IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   );

   
/* 'Element  must be a Primitive' assertion routine */
   PROCEDURE isprimitive (
      i_value         IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   );

   
/* To check that a compound element is a core element. */
   PROCEDURE iscore (
      i_category         VARCHAR2,
      i_long_name   IN   VARCHAR2
   );
END dsf_assert_ifs;
/



-- End of DDL Script for Package ROHANB.DSF_ASSERT_IFS

