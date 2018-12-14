/* Formatted on 2002/04/01 00:43 (Formatter Plus v4.5.2) */
-- Start of DDL Script for Package Body ROHANB.DSF_ASSERT_IFS
-- Generated 18-Feb-2002 9:12:02 from ROHANB@DHDBDEV.WORLD

CREATE OR REPLACE PACKAGE BODY dsf_assert_ifs
IS
   
-- PL/SQL Private Declaration
/*******************************************************************************
*
* Company Name: TENIX DEFENCE PTY LTD Electronic Systems Division (copyright 2001)
* Project     : SEA 1430           Contract Number : C438801
* Platform    : UNIX
*
* Workset File Name  : PDSFQA_ASSERT_pkb.sql
* Item Revision      : 6
* Item Specification : DHDB:PDSFQA_ASSERT_PKB SQL.A-SRC;6
* Description :
*    Persistence Dataset Full CSU interface.
*    Assertion (assumption validation) procedures and functions for DSF
*
*******************************************************************************/
-- Sub-Program Units
/* Condition is True  assertion routine */
   PROCEDURE istrue (
      i_condition     IN   BOOLEAN,
      i_exception     IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   )
   IS
   
-- PL/SQL Specification
/*******************************************************************************
* Name:        ISTRUE
* Description: Tests the assertion that a specified expression is TRUE.
*
*******************************************************************************/

-- PL/SQL Block
   BEGIN
      IF    NOT i_condition
         OR i_condition IS NULL
      THEN
         dsf_err_ifs.raise_exception (
            i_exception,
            i_err_msg_par
         );
      END IF;
   END istrue;

   
/* Value is not null assertion routine for numbers */
   PROCEDURE isnotnull (
      i_value         IN   NUMBER,
      i_err_msg_par   IN   VARCHAR2 := NULL
   )
   IS
   
-- PL/SQL Specification
/*******************************************************************************
* Name:        ISNOTNULL
* Description: Tests the assertion that a specified numeric value is not NULL.
*
*******************************************************************************/

-- PL/SQL Block
   BEGIN
      istrue (
         i_value IS NOT NULL,
         'dsf_err_ifs.must_be_entered',
         i_err_msg_par
      );
   END isnotnull;

   
/* Value is not null assertion routine for characters */
   PROCEDURE isnotnull (
      i_value         IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   )
   IS
   
-- PL/SQL Specification
/*******************************************************************************
* Name:        ISNOTNULL
* Description: Tests the assertion that a specified string value is not NULL.
*
*******************************************************************************/

-- PL/SQL Block
   BEGIN
      istrue (
         i_value IS NOT NULL,
         'dsf_err_ifs.must_be_entered',
         i_err_msg_par
      );
   END isnotnull;

   
/* Value is null assertion for characters */
   PROCEDURE isnull (
      i_value         IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   )
   IS
   
-- PL/SQL Specification
/*******************************************************************************
* Name:        ISNULL
* Description: Tests the assertion that a specified string value is NULL.
*
*******************************************************************************/

-- PL/SQL Block
   BEGIN
      istrue (
         i_value IS NULL,
         'dsf_err_ifs.must_not_be_entered',
         i_err_msg_par
      );
   END isnull;

   
/* Value is null assertion for characters */
   PROCEDURE isnull (
      i_value         IN   NUMBER,
      i_err_msg_par   IN   VARCHAR2 := NULL
   )
   IS
   
-- PL/SQL Specification
/*******************************************************************************
* Name:        ISNULL
* Description: Tests the assertion that a specified string value is NULL.
*
*******************************************************************************/

-- PL/SQL Block
   BEGIN
      istrue (
         i_value IS NULL,
         'dsf_err_ifs.must_not_be_entered',
         i_err_msg_par
      );
   END isnull;

   
/* Status must be in use assertion routine */
   PROCEDURE isin_use (
      i_value         IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   )
   IS
   
-- PL/SQL Specification
/*******************************************************************************
* Name:        ISIN_USE
* Description: Test the assertion that a Metadata Element is IN_USE.
*
*******************************************************************************/

-- PL/SQL Block
   BEGIN
      istrue (
         i_value = 'IN_USE',
         'dsf_err_ifs.element_withdrawn',
         i_err_msg_par
      );
   END isin_use;

   
/* 'Element  must be a Compound' assertion routine */
   PROCEDURE iscompound (
      i_value         IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   )
   IS
   
-- PL/SQL Specification
/*******************************************************************************
* Name:        ISCOMPOUND
* Description: Test the assertion that a Metadata Element is a Compound.
*
*******************************************************************************/

-- PL/SQL Block
   BEGIN
      istrue (
         i_value = 'COMPOUND',
         'dsf_err_ifs.elem_must_be_compound',
         i_err_msg_par
      );
   END iscompound;

   
/* Compound lookup must be set use assertion routine */
   PROCEDURE islookup_allowed (
      i_value         IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   )
   IS
   
-- PL/SQL Specification
/*******************************************************************************
* Name:        ISLOOKUP_ALLOWED
* Description: Tests the assertion that a Lookup List is allowed for a Metadata
*              Compound Element.
*
*******************************************************************************/

-- PL/SQL Block
   BEGIN
      istrue (
         i_value = 'Y',
         'dsf_err_ifs.compound_has_no_lookup',
         i_err_msg_par
      );
   END islookup_allowed;

   
/* 'Element  must be a Primitive' assertion routine */
   PROCEDURE isprimitive (
      i_value         IN   VARCHAR2,
      i_err_msg_par   IN   VARCHAR2 := NULL
   )
   IS
   
-- PL/SQL Specification
/*******************************************************************************
* Name:        ISPRIMITIVE
* Description: Tests the assertion that a specified Metadata Element is a Primitive.
*
*******************************************************************************/

-- PL/SQL Block
   BEGIN
      istrue (
         i_value = 'PRIMITIVE',
         'dsf_err_ifs.elem_must_be_primitive',
         i_err_msg_par
      );
   END isprimitive;

   
/* To check that a compound element is a core element. */
   PROCEDURE iscore (
      i_category         VARCHAR2,
      i_long_name   IN   VARCHAR2
   )
   IS
   
-- PL/SQL Specification
/*******************************************************************************
* Name:        ISCORE
* Description: Test the requirement that the category of a compound
*              Metadata Element is Core.
*
*******************************************************************************/

-- PL/SQL Block
   BEGIN
      istrue (
         i_category = 'CORE',
         'dsf_err_ifs.category_not_core',
         i_long_name
      );
   END iscore;
-- PL/SQL Block
END dsf_assert_ifs;
/



-- End of DDL Script for Package Body ROHANB.DSF_ASSERT_IFS

