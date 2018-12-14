DECLARE
	/* Create the cursor type. */
	TYPE emp_curtype IS REF CURSOR RETURN emp%ROWTYPE;

	/* Declare a cursor variable of that type. */
	emp_curvar emp_curtype;

	/* Declare a record with same structure as cursor variable. */
	emp_rec emp%ROWTYPE;
BEGIN
	/* Open the cursor variable, associating with it a SQL statement. */
	OPEN emp_curvar FOR SELECT * FROM emp;

	/* Fetch from the cursor variable. */
	FETCH emp_curvar INTO emp_rec;

    p.l(emp_rec.ename);

	/* Close the cursor object associated with variable. */
	CLOSE emp_curvar;
END;
/
DECLARE 
	TYPE emp_curtype IS REF CURSOR;
	emp_curvar emp_curtype;
BEGIN
	OPEN emp_curvar FOR SELECT * FROM emp;
	OPEN emp_curvar FOR SELECT empno FROM emp;
	OPEN emp_curvar FOR SELECT deptno FROM dept;
END;
/
CREATE TABLE home_properties
   (name VARCHAR2(100),
    address VARCHAR2(200));

CREATE TABLE commercial_properties
   (name VARCHAR2(100),
    address VARCHAR2(200));

create package  cv
is
	TYPE building_curtype IS REF CURSOR;
	PROCEDURE open_site_list 
		(address_in IN VARCHAR2, 
		 site_cur_inout IN OUT building_curtype);
	PROCEDURE show_home_site (home_rec_in IN home_properties%ROWTYPE);
	PROCEDURE show_commercial_site  (comm_rec_in IN commerical_properties%ROWTYPE);
end;
/
create package body cv
is
PROCEDURE open_site_list 
	(address_in IN VARCHAR2, 
	 site_cur_inout IN OUT building_curtype)
IS
	home_type CONSTANT INTEGER := 1;
	commercial_type CONSTANT INTEGER := 2;
	
	/* A static cursor to get building type. */
	CURSOR site_type_cur IS
		SELECT site_type FROM property_master
		 WHERE address = address_in;
	site_type_rec site_type_cur%ROWTYPE;

BEGIN
	/* Get the building type for this address. */
	OPEN site_type_cur;
	FETCH site_type_cur INTO site_type_rec;
	CLOSE site_type_cur;

	IF site_type_rec.site_type =  home_type
	THEN
		/* Use the home properties table. */
		OPEN site_cur_inout FOR 
			SELECT * FROM home_properties
			 WHERE address LIKE '%' || address_in || '%';

	ELSIF site_type_rec.site_type =  commerical_type
	THEN
		/* Use the commerical properties table. */
		OPEN site_cur_inout FOR 
			SELECT * FROM commercial_properties
			 WHERE address LIKE '%' || address_in || '%';
	END IF;
END open_site_list;
end cv;
/
DECLARE
	/* Declare a cursor variable. */
	building_curvar cv.building_curtype;

	/* Define record structures for two different tables. */
	home_rec home_properties%ROWTYPE;
	commerical_rec commerical_properties%ROWTYPE;

    address_string VARCHAR2(200) := '&&firstparm';
BEGIN
	/* Assign a query to the cursor variable based on the address. */
	open_site_list (address_string, building_curvar);

	/* Fetch a row into the home record. */
	FETCH building_curvar INTO home_rec;

	/* If I got here, the site was a home, so display it. */
	cv.show_home_site (home_rec);
EXCEPTION
	/* If the first record was not a home... */
	WHEN ROWTYPE_MISMATCH
	THEN
		/* Fetch that same 1st row into the commerical record. */
		FETCH building_curvar INTO commerical_rec;

		/* Show the commercial site info. */
		cv.show_commerical_site (commerical_rec);
END;
/
drop TABLE commercial_properties;
drop TABLE home_properties;
drop package cv;
