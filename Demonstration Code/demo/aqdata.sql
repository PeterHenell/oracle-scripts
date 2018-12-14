/* Create an object type to hold a message. */

CREATE TYPE message_type AS OBJECT
   (title VARCHAR2(30),
    text VARCHAR2(2000));
/
