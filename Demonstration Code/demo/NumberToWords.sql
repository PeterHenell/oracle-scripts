set echo on
set feedback on

/**********************************************************************************************************/
/*                                                                                                        */
/* Procedure:   NumberToWords                                                                             */
/* Description: This package provides a function NumberToWords converting numbers to their                */
/*		English equivalent and returns it as a string.                                            */
/*                                                                                                        */
/* Version:    	1.0.0                                                                                     */
/*                                                                                                        */
/* Required:	Oracle Server Version 7.3 or higher.                                                      */
/*                                                                                                        */
/* Example:                                                                                               */
/*                                                                                                        */
/*    SELECT NumberToWords.NumberToWords(1234567890) FROM DUAL;                                           */
/*                                                                                                        */
/* Written by: 	Material Dreams                                                                           */
/* EMail:       info@materialdreams.com                                                                   */
/* WWW:         http://www.materialdreams.com/oracle                                                      */
/*                                                                                                        */
/* License:     This script can be freely distributed as long as this header will not be removed and      */
/*              improvements and changes to this script will be reported to the author.                   */
/*                                                                                                        */
/*              Copyright (c) 1995-2004 by Material Dreams. All Rights Reserved.                          */
/*                                                                                                        */
/**********************************************************************************************************/

/* Create the package header */
CREATE OR REPLACE
PACKAGE NumberToWords IS
	FUNCTION NumberToWords(theValue IN NUMBER) RETURN VARCHAR2;
END NumberToWords;
/

/* Create the package body */
CREATE OR REPLACE
PACKAGE BODY NumberToWords IS

	TYPE NXR IS RECORD (Name VARCHAR2(60), Value INTEGER);
	TYPE NXT IS TABLE OF NXR INDEX BY BINARY_INTEGER;
	TYPE DMT IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;

	numarr	NXT;
	denom	DMT;

	FUNCTION CVT2(theValue IN INTEGER) RETURN VARCHAR2;
	FUNCTION CVT3(theValue IN INTEGER) RETURN VARCHAR2;

FUNCTION NumberToWords(theValue IN NUMBER) RETURN VARCHAR2
IS
	val		NUMBER	:= theValue;
	tri		INTEGER	:= 0;		--	last tree digits
	place	INTEGER := 0;		--	which power of 10 we are on
	neg		BOOLEAN := FALSE;	--	sign holder
	temp	VARCHAR2(255);
	word	VARCHAR2(255);
	phrase	VARCHAR2(255);
BEGIN
	-- check for 0
	IF (val = 0) THEN
		word := 'zero';
		RETURN word;
	END IF;

	-- check for negative int
	IF (val < 0) THEN
		neg	:= TRUE;
		val	:= -val;
	END IF;

	--	what we do now is break it up into sets of three, and add the appropriate denominations to each
	WHILE (val > 0) LOOP
		phrase	:= NULL;
		tri		:= MOD(val, 1000);		--	last tree digits
		val		:= FLOOR(val / 1000);	--	base 10 shift by 3
		IF (tri > 0) THEN
			phrase := phrase || CVT3(tri) || ' ';
		END IF;
		IF ((place > 0) AND (tri > 0)) THEN
			phrase := phrase || denom(place+1);
		END IF;
		place := place + 1;
		
		--	got the phrase, now put in the string
		temp := word;
		IF ((val > 0) AND (tri > 0)) THEN
			word := ', ' || phrase;
		ELSE
			word := phrase;
		END IF;
		word := word || temp;
	END LOOP;

	--	remember that minus sign
	IF (neg) THEN
		word := 'negative ' || word;
	END IF;

	RETURN word;		
END NumberToWords;

FUNCTION CVT2(theValue IN INTEGER) RETURN VARCHAR2
IS
	v	NUMBER	:= theValue;
	i	PLS_INTEGER	:= 0;
	s	VARCHAR2(80);
BEGIN
	i := 1;
	WHILE (numarr(i).Value <= v) LOOP
		i := i + 1;
	END LOOP;

	s	:= numarr(i-1).Name;
	v	:= v - numarr(i-1).Value;

	IF (v > 0) THEN
		s := s || '-' || numarr(v+1).Name;
	END IF;
	
	RETURN s;
END CVT2;

FUNCTION CVT3(theValue IN INTEGER) RETURN VARCHAR2
IS
	v	NUMBER	:= theValue;
	r	INTEGER;
	m	INTEGER;
	s	VARCHAR2(80);
BEGIN
	m	:= MOD(v, 100);
	r	:= FLOOR(v / 100);

	IF (r > 0) THEN
		s := s || numarr(r+1).Name;
		s := s || ' hundred';
		IF (m > 0) THEN
			s := s || ' ';
		END IF;
	END IF;

	IF (m > 0) THEN
		s := s || CVT2(m);
	END IF;
	
	RETURN s;
END CVT3;

BEGIN
	--	initialize the arrays
	numarr(01).Name	:= 'zero';		numarr(1).Value		:= 0;
	numarr(02).Name	:= 'one';		numarr(2).Value		:= 1;
	numarr(03).Name	:= 'two';		numarr(3).Value		:= 2;
	numarr(04).Name	:= 'three';		numarr(4).Value		:= 3;
	numarr(05).Name	:= 'four';		numarr(5).Value		:= 4;
	numarr(06).Name	:= 'five';		numarr(6).Value		:= 5;
	numarr(07).Name	:= 'six';		numarr(7).Value		:= 6;
	numarr(08).Name	:= 'seven';		numarr(8).Value		:= 7;
	numarr(09).Name	:= 'eight';		numarr(9).Value		:= 8;
	numarr(10).Name	:= 'nine';		numarr(10).Value	:= 9;
	numarr(11).Name	:= 'ten';		numarr(11).Value	:= 10;
	numarr(12).Name	:= 'eleven';		numarr(12).Value	:= 11;
	numarr(13).Name	:= 'twelve';		numarr(13).Value	:= 12;
	numarr(14).Name	:= 'thirteen';		numarr(14).Value	:= 13;
	numarr(15).Name	:= 'fourteen';		numarr(15).Value	:= 14;
	numarr(16).Name	:= 'fifteen';		numarr(16).Value	:= 15;
	numarr(17).Name	:= 'sixteen';		numarr(17).Value	:= 16;
	numarr(18).Name	:= 'seventeen';		numarr(18).Value	:= 17;
	numarr(19).Name	:= 'eighteen';		numarr(19).Value	:= 18;
	numarr(20).Name	:= 'nineteen';		numarr(20).Value	:= 19;
	numarr(21).Name	:= 'twenty';		numarr(21).Value	:= 20;
	numarr(22).Name	:= 'thirty';		numarr(22).Value	:= 30;
	numarr(23).Name	:= 'forty';		numarr(23).Value	:= 40;
	numarr(24).Name	:= 'fifty';		numarr(24).Value	:= 50;
	numarr(25).Name	:= 'sixty';		numarr(25).Value	:= 60;
	numarr(26).Name	:= 'seventy';		numarr(26).Value	:= 70;
	numarr(27).Name	:= 'eighty';		numarr(27).Value	:= 80;
	numarr(28).Name	:= 'ninety';		numarr(28).Value	:= 90;
	numarr(29).Name	:= '';			numarr(29).Value	:= 999;
	
	denom(01)	:= '';
	denom(02)	:= 'thousand';
	denom(03)	:= 'million';
	denom(04)	:= 'billion';
	denom(05)	:= 'trillion';
	denom(06)	:= 'quadrillion';
	denom(07)	:= 'quintillion';
	denom(08)	:= 'sextillion';
	denom(10)	:= 'septillion';
	denom(11)	:= 'octillion';
	denom(12)	:= 'nonillion';
	denom(13)	:= 'decillion';
	denom(14)	:= 'undecillion';
	denom(15)	:= 'duodecillion';
	denom(16)	:= 'tredecillion';
	denom(17)	:= 'quattuordecillion';
	denom(18)	:= 'sexdecillion';
	denom(19)	:= 'septendecillion';
	denom(20)	:= 'octodecillion';
	denom(21)	:= 'novemdecillion';
	denom(22)	:= 'vigintillion';

END NumberToWords;
/

/* Example */
SELECT NumberToWords.NumberToWords(1234567890) FROM DUAL;
/
