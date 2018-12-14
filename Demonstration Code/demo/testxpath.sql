/* Formatted on 2001/06/23 08:37 (RevealNet Formatter v4.4.0) */
SET SERVEROUTPUT ON
DECLARE
   doc         xmldom.domdocument;
   approvers   xmldom.domnodelist;

   PROCEDURE parse_document (
      file_in   IN   VARCHAR2,
      doc_out   OUT  xmldom.domdocument
   )
   IS
      prsr   xmlparser.parser;
   BEGIN
      prsr := xmlparser.newparser;
      xmlparser.parse (prsr, file_in);
      doc_out := xmlparser.getdocument (prsr);
      xmlparser.freeparser (prsr);
   END parse_document;

   PROCEDURE p (msg VARCHAR2, nl BOOLEAN := TRUE) IS
   BEGIN
      DBMS_OUTPUT.put_line (msg);
      IF nl THEN DBMS_OUTPUT.put (CHR (10)); END IF;
   END;
   
   FUNCTION yn (b BOOLEAN ) RETURN VARCHAR2 IS
      BEGIN IF b THEN RETURN 'Yes'; ELSE RETURN 'No'; END IF; END;

BEGIN
   parse_document ('d:\demo-seminar\claim77804.xml', doc);
   p ('What is the value of the Policy number for this claim?');
   p (xpath.valueof (doc, '/Claim/Policy'));
   p ('Any settlement payments over $500 approved by JCOX?');
   p (
      yn (
         xpath.test (
            doc,
            '//Settlements/Payment[. > 500 and @Approver="JCOX"]'
         )
      )
   );

   p (xpath.extract (doc, '/Claim/DamageReport'));
   
   p ('Who approved settlement payments for this claim?');
   
   approvers :=
       xpath.selectnodes (doc, '/Claim/Settlements/Payment');

   FOR appr_indx IN 1 .. xmldom.getlength (approvers)
   LOOP
      p (
         xpath.valueof (
            xmldom.item (approvers,   appr_indx
                                    - 1),
            '@Approver'
         ),
         nl    => FALSE
      );
   END LOOP;

   xmldom.freedocument (doc);
END;
/

