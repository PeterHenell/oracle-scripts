/* Formatted by PL/Formatter v3.1.2.1 on 2001/05/22 15:12 */

CREATE OR REPLACE PROCEDURE Loadreport (
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
   doc                            Xmldom.domdocument;
   c_incorrect_element   CONSTANT PLS_INTEGER
            := -20700;
   c_viol_index          CONSTANT PLS_INTEGER        := 3;
   c_inc_index           CONSTANT PLS_INTEGER        := 4;
   c_envreport           CONSTANT VARCHAR2 (9)       := 'envReport';
   c_reportid            CONSTANT VARCHAR2 (8)       := 'reportID';
   c_source              CONSTANT VARCHAR2 (6)       := 'source';
   c_incident            CONSTANT VARCHAR2 (8)       := 'Incident';
   c_violations          CONSTANT VARCHAR2 (10)
            := 'Violations';

   PROCEDURE parse_document (
      file_in   IN       VARCHAR2,
      doc_out   OUT      Xmldom.domdocument
   )
   IS
      prsr   Xmlparser.parser;
   BEGIN
      prsr := Xmlparser.newparser;
      Xmlparser.parse (prsr, file_in);
      doc_out := Xmlparser.getdocument (prsr);
      Xmlparser.freeparser (prsr);
   END parse_document;

   FUNCTION element_name (
      nodes_in        IN   Xmldom.domnodelist,
      node_index_in   IN   PLS_INTEGER
   )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN (
                Xmldom.gettagname (Xmldom.makeelement (Xmldom.item (nodes_in,
                                                          node_index_in
                                                       )
                                   )
                )
             );
   END;

   PROCEDURE check_element (
      node      IN   Xmldom.domnode,
      NAME_IN   IN   VARCHAR2
   )
   IS
      one_element   Xmldom.domelement;
      value_node    Xmldom.domnode;
   BEGIN
      one_element := Xmldom.makeelement (node);

      IF UPPER (Xmldom.gettagname (one_element)) !=
                                  UPPER (NAME_IN)
      THEN
         RAISE_APPLICATION_ERROR (c_incorrect_element,
            'Expected "' || NAME_IN ||
               '" and got "' ||
               Xmldom.gettagname (one_element)
         );
      END IF;
   END;

   PROCEDURE get_and_set_element (
      node        IN       Xmldom.domnode,
      NAME_IN     IN       VARCHAR2,
      value_out   OUT      VARCHAR2
   )
   IS
      one_element   Xmldom.domelement;
      value_node    Xmldom.domnode;
   BEGIN
      check_element (node, NAME_IN);
      one_element := Xmldom.makeelement (node);
      value_node := Xmldom.getfirstchild (node);
      value_out :=
                 Xmldom.getnodevalue (value_node);
   END;

   PROCEDURE get_and_set_attr (
      node_map     IN       Xmldom.domnamednodemap,
      attr_index   IN       PLS_INTEGER,
      attr_value   OUT      VARCHAR2
   )
   IS
      one_node   Xmldom.domnode;
   BEGIN
      one_node :=
               Xmldom.item (node_map, attr_index);
      attr_value :=
                   Xmldom.getnodevalue (one_node);
   END;

   PROCEDURE get_and_set_attr (
      node_map     IN       Xmldom.domnamednodemap,
      attr_index   IN       PLS_INTEGER,
      attr_value   OUT      DATE
   )
   IS
      one_node   Xmldom.domnode;
   BEGIN
      one_node :=
               Xmldom.item (node_map, attr_index);
      attr_value :=
         TO_DATE (Xmldom.getnodevalue (one_node),
            'MM/DD/YYYY'
         );
   END;

   PROCEDURE get_and_set_attr (
      node_map     IN       Xmldom.domnamednodemap,
      attr_index   IN       PLS_INTEGER,
      attr_value   OUT      NUMBER
   )
   IS
      one_node   Xmldom.domnode;
   BEGIN
      one_node :=
               Xmldom.item (node_map, attr_index);
      attr_value :=
                   Xmldom.getnodevalue (one_node);
   END;

   PROCEDURE add_header_info (
      nodes          IN       Xmldom.domnodelist,
      reportid_out   OUT      ENVREPORT.reportid%TYPE
   )
   IS
      er_rec   ENVREPORT%ROWTYPE;
   BEGIN
      -- First three elements should be: envReport, reportID and source.
      check_element (Xmldom.item (nodes, 0),
         c_envreport
      );
      get_and_set_element (Xmldom.item (nodes, 1),
         c_reportid,
         er_rec.reportid
      );
      get_and_set_element (Xmldom.item (nodes, 2),
         c_source,
         er_rec.source
      );

      INSERT INTO ENVREPORT
                  (reportid, source)
           VALUES (
              er_rec.reportid,
              er_rec.source
           );

      reportid_out := er_rec.reportid;
   END add_header_info;

   PROCEDURE add_violation_info (
      reportid_in   IN   ENVREPORT.reportid%TYPE,
      node_in       IN   Xmldom.domnode
   )
   IS
      node_map   Xmldom.domnamednodemap;
      viol_rec   VIOLATIONS%ROWTYPE;
   BEGIN
      get_and_set_element (node_in,
         'incident',
         viol_rec.incident
      );
      node_map := Xmldom.getattributes (node_in);
      get_and_set_attr (node_map,
         0,
         viol_rec.reportedon
      );
      get_and_set_attr (node_map,
         1,
         viol_rec.reportedby
      );

      INSERT INTO VIOLATIONS
                  (
                     reportid,
                     reportedon,
                     reportedby,
                     incident
                  )
           VALUES (
              reportid_in,
              viol_rec.reportedon,
              viol_rec.reportedby,
              viol_rec.incident
           );
   END add_violation_info;

-- prints the attributes of each element in a document
   PROCEDURE scan_and_load (doc Xmldom.domdocument)
   IS
      nodes        Xmldom.domnodelist;
      l_index      PLS_INTEGER;
      l_reportid   ENVREPORT.reportid%TYPE;
   BEGIN
      -- get all elements
      nodes :=
            Xmldom.getelementsbytagname (doc, '*');
      add_header_info (nodes, l_reportid);

      IF element_name (nodes, c_viol_index) =
                                     c_violations
      THEN
         l_index := c_inc_index;

         LOOP
            EXIT WHEN element_name (nodes,
                         l_index
                      ) != c_incident;
            add_violation_info (l_reportid,
               Xmldom.item (nodes, l_index)
            );
            l_index := l_index + 1;
         END LOOP;
      END IF;
   END scan_and_load;

   PROCEDURE cleanup (doc IN Xmldom.domdocument)
   IS
   BEGIN
      Xmldom.freedocument (doc);
   END;
BEGIN
   parse_document (dir || '/' || inpfile, doc);
   scan_and_load (doc);
   cleanup (doc);
EXCEPTION
   WHEN Xmldom.index_size_err
   THEN
      RAISE_APPLICATION_ERROR (-20120,
         'Index Size error'
      );
   WHEN Xmldom.domstring_size_err
   THEN
      RAISE_APPLICATION_ERROR (-20120,
         'String Size error'
      );
   WHEN Xmldom.hierarchy_request_err
   THEN
      RAISE_APPLICATION_ERROR (-20120,
         'Hierarchy request error'
      );
   WHEN Xmldom.wrong_document_err
   THEN
      RAISE_APPLICATION_ERROR (-20120,
         'Wrong doc error'
      );
   WHEN Xmldom.invalid_character_err
   THEN
      RAISE_APPLICATION_ERROR (-20120,
         'Invalid Char error'
      );
   WHEN Xmldom.no_data_allowed_err
   THEN
      RAISE_APPLICATION_ERROR (-20120,
         'Nod data allowed error'
      );
   WHEN Xmldom.no_modification_allowed_err
   THEN
      RAISE_APPLICATION_ERROR (-20120,
         'No mod allowed error'
      );
   WHEN Xmldom.not_found_err
   THEN
      RAISE_APPLICATION_ERROR (-20120,
         'Not found error'
      );
   WHEN Xmldom.not_supported_err
   THEN
      RAISE_APPLICATION_ERROR (-20120,
         'Not supported error'
      );
   WHEN Xmldom.inuse_attribute_err
   THEN
      RAISE_APPLICATION_ERROR (-20120,
         'In use attr error'
      );
END Loadreport;
/





















