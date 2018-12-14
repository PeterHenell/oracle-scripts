SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK OFF
SET PAGESIZE 0
PROMPT
PROMPT ************************************************************************
PROMPT *                  Adjusting Sequence Next Value                       *
PROMPT ************************************************************************
PROMPT

ACCEPT Seq CHAR PROMPT 'Please    Enter    Sequence    Name: '
ACCEPT Tbl CHAR PROMPT 'Please Enter  Associated Table Name: '
ACCEPT Col CHAR PROMPT 'Please Enter Associated Column Name: '
COLUMN IncrementBy NEW_VALUE IncrementBy NOPRINT
COLUMN QuoteOrNull NEW_VALUE QuoteOrNull NOPRINT
COLUMN Hide NEW_VALUE Hide NOPRINT

SELECT  NVL(MAX(&&Col),1) IncrementBy,
	DECODE(MAX(&&Col),NULL,'''','') QuoteOrNull
  FROM  &&Tbl
/
ALTER SEQUENCE &&Seq
  INCREMENT BY	&&IncrementBy
/
SELECT &&QuoteOrNull.&&Seq..NEXTVAL&&QuoteOrNull Hide
  FROM dual
/
ALTER SEQUENCE &&Seq
  INCREMENT BY	1
/
SELECT LTRIM(DECODE('&&QuoteOrNull.&&QuoteOrNull','''',1,&&IncrementBy + 1)) Hide
  FROM dual
/
PROMPT Sequence &&Seq Is Now Adjusted. Sequence Next Value Is &&Hide..
