DECLARE
	/* Declare a cursor variable. */
	building_curvar cv.building_curtype;

	/* Define record structures for two different tables. */
	home_rec home_properties%ROWTYPE;
	commercial_rec commercial_properties%ROWTYPE;

    address_string VARCHAR2(200) := '&&firstparm';
BEGIN
	/* Assign a query to the cursor variable based on the address. */
	cv.open_site_list (address_string, building_curvar);

	/* Fetch a row into the home record. */
	FETCH building_curvar INTO home_rec;

	/* If I got here, the site was a home, so display it. */
	cv.show_home_site (home_rec);
EXCEPTION
	/* If the first record was not a home... */
	WHEN ROWTYPE_MISMATCH
	THEN
		/* Fetch that same 1st row into the commercial record. */
		FETCH building_curvar INTO commercial_rec;

		/* Show the commercial site info. */
		cv.show_commercial_site (commercial_rec);
END;
/
