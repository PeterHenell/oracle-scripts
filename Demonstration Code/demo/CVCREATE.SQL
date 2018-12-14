/*
@cvdrop.sql

CREATE TABLE home_properties
   (name VARCHAR2(100),
    address VARCHAR2(200));
INSERT INTO home_properties VALUES ('Steven', '6759 North');
INSERT INTO home_properties VALUES ('Debby', '90 Sherman');

CREATE TABLE commercial_properties
   (name VARCHAR2(100),
    address VARCHAR2(200));
INSERT INTO commercial_properties VALUES ('Oracle', 'Redwood Shores');
INSERT INTO commercial_properties VALUES ('SSC', 'Chicago');

CREATE TABLE property_master
   (site_type INTEGER,
    address VARCHAR2(200));
INSERT INTO property_master VALUES (1, '6759 North');
INSERT INTO property_master VALUES (1, '90 Sherman');
INSERT INTO property_master VALUES (2, 'Redwood Shores');
INSERT INTO property_master VALUES (2, 'Chicago');

create or replace  package  cv
is
	TYPE building_curtype IS REF CURSOR;
	PROCEDURE open_site_list 
		(address_in IN VARCHAR2, 
		 site_cur_inout IN OUT building_curtype);
	PROCEDURE show_home_site (home_rec_in IN home_properties%ROWTYPE);
	PROCEDURE show_commercial_site  (comm_rec_in IN commercial_properties%ROWTYPE);
end;
/
*/
create or replace package body cv
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

		ELSIF site_type_rec.site_type =  commercial_type
		THEN
			/* Use the commercial properties table. */
			OPEN site_cur_inout FOR 
				SELECT * FROM commercial_properties
				 WHERE address LIKE '%' || address_in || '%';
		END IF;
	END open_site_list;

	PROCEDURE show_home_site (home_rec_in IN home_properties%ROWTYPE)
	IS
	BEGIN
	   p.l ('Home Property');
	   p.l (home_rec_in.name);
	   p.l (home_rec_in.address);
	END;

	PROCEDURE show_commercial_site  (comm_rec_in IN commercial_properties%ROWTYPE)
	IS
	BEGIN
	   p.l ('Commercial Property');
	   p.l (comm_rec_in.name);
	   p.l (comm_rec_in.address);
	END;

end cv;
/
