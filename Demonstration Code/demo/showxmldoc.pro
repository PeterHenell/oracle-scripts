/* Formatted by PL/Formatter v3.1.2.1 on 2001/03/10 17:48 */

CREATE OR REPLACE PROCEDURE showxmldoc (
   dir       VARCHAR2,
   inpfile   VARCHAR2
)
-- Original version by Steve Muench, Building Oracle XML Applications
--    http://www.oreilly.com/catalog/orxmlapp/
--
-- Modified by Steven Feuerstein, steven@stevenfeuerstein.com
--
-- This file demonstates a simple use of the parser and DOM API.
-- The XML file that is given to the application is parsed and the
-- elements and attributes in the document are printed.
-- The use of setting the parser options is demonstrated.
IS
   doc   xmldom.domdocument;

   FUNCTION parsed_document (
      dir       IN   VARCHAR2,
      inpfile   IN   VARCHAR2
   )
      RETURN xmldom.domdocument
   IS
      p        xmlparser.parser;
      retval   xmldom.domdocument;
   BEGIN
      -- create a new XML parser
      p := xmlparser.newparser;
      -- Parse the XML document found in the file
      xmlparser.parse (p, dir || '/' || inpfile);
      -- Retrieve a navigable document tree
      retval := xmlparser.getdocument (p);
      RETURN retval;
   END;

   PROCEDURE display_element (node IN xmldom.domnode)
   IS
      one_element   xmldom.domelement;
      value_node    xmldom.domnode;
   BEGIN
      one_element := xmldom.makeelement (node);
      DBMS_OUTPUT.put_line ('Element: ' ||
                               xmldom.gettagname (one_element
                               )
      );
      value_node := xmldom.getfirstchild (node);
      DBMS_OUTPUT.put_line ('  Value: ' ||
                               xmldom.getnodevalue (value_node
                               )
      );
   END;

   PROCEDURE display_attribute (
      node_map     IN   xmldom.domnamednodemap,
      attr_index   IN   PLS_INTEGER
   )
   IS
      one_node   xmldom.domnode;
      attrname   VARCHAR2 (100);
      attrval    VARCHAR2 (100);
   BEGIN
      one_node := xmldom.item (node_map, attr_index);
      attrname := xmldom.getnodename (one_node);
      attrval := xmldom.getnodevalue (one_node);
      DBMS_OUTPUT.put_line ('   ' || attrname || ' = ' ||
                               attrval
      );
   END;

-- prints the attributes of each element in a document
   PROCEDURE traverse_and_display (doc xmldom.domdocument)
   IS
      nodes      xmldom.domnodelist;
      one_node   xmldom.domnode;
      node_map   xmldom.domnamednodemap;
   BEGIN
      -- get all elements
      nodes := xmldom.getelementsbytagname (doc, '*');

      -- loop through elements
      FOR node_index IN 0 .. xmldom.getlength (nodes) - 1
      LOOP
         one_node := xmldom.item (nodes, node_index);
         display_element (one_node);
         -- get all attributes of element
         node_map := xmldom.getattributes (one_node);

         FOR attr_index IN 0 .. xmldom.getlength (node_map) -
                                   1
         LOOP
            display_attribute (node_map, attr_index);
         END LOOP;
      END LOOP;
   END traverse_and_display;
BEGIN
   doc := parsed_document (dir, inpfile);
   traverse_and_display (doc);
   xmldom.freedocument (doc);
EXCEPTION
   WHEN xmldom.index_size_err
   THEN
      raise_application_error (-20120, 'Index Size error');
   WHEN xmldom.domstring_size_err
   THEN
      raise_application_error (-20120, 'String Size error');
   WHEN xmldom.hierarchy_request_err
   THEN
      raise_application_error (-20120,
         'Hierarchy request error'
      );
   WHEN xmldom.wrong_document_err
   THEN
      raise_application_error (-20120, 'Wrong doc error');
   WHEN xmldom.invalid_character_err
   THEN
      raise_application_error (-20120, 'Invalid Char error');
   WHEN xmldom.no_data_allowed_err
   THEN
      raise_application_error (-20120,
         'Nod data allowed error'
      );
   WHEN xmldom.no_modification_allowed_err
   THEN
      raise_application_error (-20120,
         'No mod allowed error'
      );
   WHEN xmldom.not_found_err
   THEN
      raise_application_error (-20120, 'Not found error');
   WHEN xmldom.not_supported_err
   THEN
      raise_application_error (-20120,
         'Not supported error'
      );
   WHEN xmldom.inuse_attribute_err
   THEN
      raise_application_error (-20120, 'In use attr error');
END showxmldoc;
/








