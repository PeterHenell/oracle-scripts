/*
Keep track of inventory of contents of building.

We have rooms in the building. [Parent Table]

We have contents of the rooms. [Child Table]

*/

DROP TABLE room_contents
/
DROP TABLE rooms
/
CREATE TABLE rooms (
   room_key NUMBER PRIMARY KEY,
   NAME VARCHAR2(100)
)
/
CREATE TABLE room_contents (
   contents_key NUMBER PRIMARY KEY,
   room_key NUMBER,
   NAME VARCHAR2(100)
)
/

/* Foreign key to rooms. Note: this is not a CASCADE DELETE
   key. Child data is NOT removed when the parent is
   removed.
*/

ALTER TABLE room_contents ADD CONSTRAINT
   fk_rooms FOREIGN KEY (room_key)
   REFERENCES rooms (room_key)
/

BEGIN
   DELETE FROM room_contents;
   DELETE FROM rooms;

   /* Add rooms; the last three, all starting with B, will not
      have any contents. */
   INSERT INTO rooms VALUES (1, 'Dining Room');
   INSERT INTO rooms VALUES (2, 'Living Room');
   INSERT INTO rooms VALUES (3, 'Office');
   INSERT INTO rooms VALUES (4, 'Bathroom');
   INSERT INTO rooms VALUES (5, 'Bedroom');

   /* Add contents for first three rooms */
   INSERT INTO room_contents VALUES (1, 1, 'Table');
   INSERT INTO room_contents VALUES (2, 1, 'Hutch');
   INSERT INTO room_contents VALUES (3, 1, 'Chair');
   INSERT INTO room_contents VALUES (4, 2, 'Sofa');
   INSERT INTO room_contents VALUES (5, 2, 'Lamp');
   INSERT INTO room_contents VALUES (6, 3, 'Desk');
   INSERT INTO room_contents VALUES (7, 3, 'Chair');
   INSERT INTO room_contents VALUES (8, 3, 'Computer');
   INSERT INTO room_contents VALUES (9, 3, 'Whiteboard');

   COMMIT;
END;
/