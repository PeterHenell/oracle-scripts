CREATE OR REPLACE PACKAGE dbbc AS

  /*
    || This package display the current contents of the
    || Database Buffer Cache (DBBC). It allows the exclusion
    || of distinct owners, object types or objects not using a
    || miniumum number of buffers.
    ||
    || Darryl Hurley dhurley@mdsi.bc.ca
    ||
    || Requirements: access to DBA_OBJECTS and X$BH.
    ||   Should probably create this in SYS.
    ||
    || 04-FEB-1999 DRH Started
  */

  -- main procedure to show contents
  PROCEDURE show;

  -- owner maintenance
  PROCEDURE toggle_owner ( p_owner VARCHAR2 );
  PROCEDURE show_owners;

  -- obeject type maintenance
  PROCEDURE toggle_object ( p_object VARCHAR2 );
  PROCEDURE show_objects;

  -- number of buffers maintenance
  PROCEDURE set_minimum ( p_minimum INT );
  PROCEDURE show_minimum;

  -- show all current exclusion settings
  PROCEDURE show_all;

END dbbc;
/

SHO ERR

CREATE OR REPLACE PACKAGE BODY dbbc AS

  -- table of owner names to exclude
  TYPE v_owner_table_type IS TABLE OF VARCHAR2(30)
    INDEX BY BINARY_INTEGER;
  v_owner_table v_owner_table_type;

  -- table of object types to exclude
  TYPE v_object_table_type IS TABLE OF VARCHAR2(30)
    INDEX BY BINARY_INTEGER;
  v_object_table v_owner_table_type;

  -- the minimum buffer variable
  v_min_buffers INT;

  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  FUNCTION show_owner ( p_owner VARCHAR2 )
           RETURN BOOLEAN IS
  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
 
    /*
      || This function decide if an owner should be displayed
      || or not. The rule is that if they are in the table
      || then they are not displayed
    */
    v_element INT;
    v_ret_val BOOLEAN := TRUE;

  BEGIN

    v_element := v_owner_table.FIRST;
    LOOP
      EXIT WHEN v_element IS NULL;
      IF v_owner_table(v_element) = p_owner THEN
        v_ret_val := FALSE;
      END IF;
      v_element := v_owner_table.NEXT(v_element);
    END LOOP;
    RETURN(v_ret_val);

  END show_owner;

  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  PROCEDURE show_owners IS
  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/

    /*
      || This procedure lists the owners that will be excluded
    */
    v_element INT;

  BEGIN

    DBMS_OUTPUT.PUT_LINE('The following owners will be excluded:');
    v_element := v_owner_table.FIRST;
    LOOP
      EXIT WHEN v_element IS NULL;
      DBMS_OUTPUT.PUT_LINE(v_owner_table(v_element));
      v_element := v_owner_table.NEXT(v_element);
    END LOOP;

  END show_owners;

  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  PROCEDURE toggle_owner ( p_owner VARCHAR2 ) IS
  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/

    /*
      || This procedure adds an owner to the exclusion list if they
      || are not already there or removes them if the are. I am too
      || lazy to write separate functions so deal with it!
    */

    v_element    INT;
    v_found_user INT;   -- element where user was found

  BEGIN

    v_found_user := 0;
 
    -- for every owner in table...
    v_element := v_owner_table.FIRST;
    LOOP

      -- exit when no more elements
      EXIT WHEN v_element IS NULL OR v_found_user > 0;

      -- if this element is equal to the owner passed in then
      -- mark it for deletion
      IF v_owner_table(v_element) = p_owner THEN
        v_found_user := v_element;
      END IF;

      -- try the next element
      v_element := v_owner_table.NEXT(v_element);

    END LOOP;  -- every owner in table

    -- if the owner was found then remove them otherwise
    -- add them to the table
    IF v_found_user > 0 THEN
      v_owner_table.DELETE(v_found_user);
    ELSE
      IF v_owner_table.FIRST IS NULL THEN
        v_owner_table(1) := p_owner;
      ELSE
        v_owner_table(v_owner_table.LAST + 1) := p_owner;
      END IF;
    END IF;

  END toggle_owner;

  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  FUNCTION show_object ( p_object VARCHAR2 )
           RETURN BOOLEAN IS
  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
 
    /*
      || This function decide if an object type should be displayed
      || or not. The rule is that if it is in the table
      || then it is not displayed
    */
    v_element INT;
    v_ret_val BOOLEAN := TRUE;

  BEGIN

    v_element := v_object_table.FIRST;
    LOOP
      EXIT WHEN v_element IS NULL;
      IF v_object_table(v_element) = p_object THEN
        v_ret_val := FALSE;
      END IF;
      v_element := v_object_table.NEXT(v_element);
    END LOOP;
    RETURN(v_ret_val);

  END show_object;

  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  PROCEDURE show_objects IS
  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/

    /*
      || This procedure lists the object types that will be excluded
    */
    v_element INT;

  BEGIN

    DBMS_OUTPUT.PUT_LINE('The following object types will be excluded:');
    v_element := v_object_table.FIRST;
    LOOP
      EXIT WHEN v_element IS NULL;
      DBMS_OUTPUT.PUT_LINE(v_object_table(v_element));
      v_element := v_object_table.NEXT(v_element);
    END LOOP;

  END show_objects;

  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  PROCEDURE toggle_object ( p_object VARCHAR2 ) IS
  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/

    /*
      || This procedure adds an object type  to the exclusion list if they
      || are not already there or removes it if the are. I am too
      || lazy to write separate functions so deal with it!
    */

    v_element      INT;
    v_found_object INT;   -- element where user was found

  BEGIN

    v_found_object := 0;
 
    -- for every object type in table...
    v_element := v_object_table.FIRST;
    LOOP

      -- exit when no more elements
      EXIT WHEN v_element IS NULL OR v_found_object > 0;

      -- if this element is equal to the object type passed in then
      -- mark it for deletion
      IF v_object_table(v_element) = p_object THEN
        v_found_object := v_element;
      END IF;

      -- try the next element
      v_element := v_object_table.NEXT(v_element);

    END LOOP;  -- every object type in table

    -- if the object types was found then remove it otherwise
    -- add them to the table
    IF v_found_object > 0 THEN
      v_owner_table.DELETE(v_found_object);
    ELSE
      IF v_object_table.FIRST IS NULL THEN
        v_object_table(1) := p_object;
      ELSE
        v_object_table(v_object_table.LAST + 1) := p_object;
      END IF;
    END IF;

  END toggle_object;

  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  PROCEDURE set_minimum ( p_minimum INT ) IS
  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  BEGIN
    v_min_buffers := p_minimum;
  END;

  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  PROCEDURE show_minimum IS
  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  BEGIN
    DBMS_OUTPUT.PUT_LINE('The minimum buffer setting is ' || v_min_buffers);
  END;

  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  PROCEDURE show_all IS
  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    show_owners;
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    show_objects;
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    show_minimum;
  END;

  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
  PROCEDURE show IS
  /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/

    /*
      || This is the procedure that actually reveals what is in the
      || DBBC. Note that the query below uses the X$BH view which
      || is owned by SYS. This has only been run against 8.0.4 so
      || results against prior versions are unknown.
    */
    -- Get the object ID and the number of buffers it is using
    CURSOR curs_get_counts IS
    select obj,
           count(*) num_buffers
      from x$bh
    group by obj
    order by count(*) desc;

    -- Get pertinent information about the object
    CURSOR curs_get_obj ( cp_object_id NUMBER ) IS
    select owner,
           object_name,
           object_type
      from dba_objects
     where object_id = cp_object_id;
    v_obj_rec     curs_get_obj%ROWTYPE;

  BEGIN

    -- enable a big ass buffer!
    DBMS_OUTPUT.ENABLE(9999999);

    -- for every object in the cache...
    FOR v_object_rec IN curs_get_counts LOOP

      -- get info about the object and display it
      OPEN curs_get_obj(v_object_rec.obj);
      FETCH curs_get_obj INTO v_obj_rec;

      -- check if object is to be shown
      IF show_owner(v_obj_rec.owner) AND
         show_object(v_obj_rec.object_type) AND
         v_object_rec.num_buffers >= v_min_buffers THEN

        DBMS_OUTPUT.PUT_LINE(RPAD(v_obj_rec.owner || '.' || v_obj_rec.object_name,60)  || ' ' ||
                             RPAD(v_obj_rec.object_type,20)  || 
                             LPAD(v_object_rec.num_buffers,10));

      END IF;  -- object to be shown?
      CLOSE curs_get_obj;

    END LOOP;  -- every object in the cache

  END;

END dbbc;
/

exec dbbc.show;