CREATE OR REPLACE PACKAGE crossref_collection
/*
/ File name: crossref_collection.pkg
/
/ Overview: Simple package to provide ability to delete from and find
/           elements in a collection by both the integer index and
/           the element value.
/
/ Author(s): Steven Feuerstein
/
/ Modification History:
/   Date        Who         What
/  3-Nov-2007   SF          Created package in response to question from
/                           Kees Witmans
STDHDR*/
IS
   PROCEDURE append_element (value_in IN VARCHAR2);

   PROCEDURE del_element (value_in IN VARCHAR2);

   PROCEDURE del_element (index_in IN PLS_INTEGER);

   FUNCTION element_value (index_in IN PLS_INTEGER)
      RETURN VARCHAR2;

   FUNCTION element_index (value_in IN VARCHAR2)
      RETURN PLS_INTEGER;
END crossref_collection;
/

CREATE OR REPLACE PACKAGE BODY crossref_collection
/*
/ File name: crossref_collection.pkg
/
/ Overview: Simple package to provide ability to delete from and find
/           elements in a collection by both the integer index and
/           the element value.
/
/ Author(s): Steven Feuerstein
/
/ Modification History:
/   Date        Who         What
/  3-Nov-2007   SF          Created package in response to question from
/                           Kees Witmans
STDHDR*/
IS
   TYPE data_aat IS TABLE OF VARCHAR2 (32767)
      INDEX BY PLS_INTEGER;

   g_data    data_aat;

   TYPE index_aat IS TABLE OF PLS_INTEGER
      INDEX BY VARCHAR2 (32767);

   g_index   index_aat;

   PROCEDURE append_element (value_in IN VARCHAR2)
   IS
   BEGIN
      g_data (g_data.COUNT + 1) := value_in;
      g_index (value_in) := g_data.COUNT;
   END append_element;

   PROCEDURE del_element (value_in IN VARCHAR2)
   IS
   BEGIN
      g_data.DELETE (g_index (value_in));
      g_index.DELETE (value_in);
   END del_element;

   PROCEDURE del_element (index_in IN PLS_INTEGER)
   IS
      l_value   VARCHAR2 (32767);
   BEGIN
      l_value := g_data (index_in);
      g_data.DELETE (index_in);
      g_index.DELETE (l_value);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         /* We do nothing because that's what happens when you try to
            delete an element in a collection for an undefined index.
            Nothing. */
         NULL;
   END del_element;

   FUNCTION element_value (index_in IN PLS_INTEGER)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_data (index_in);
   END element_value;

   FUNCTION element_index (value_in IN VARCHAR2)
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN g_index (value_in);
   END element_index;
END crossref_collection;
/