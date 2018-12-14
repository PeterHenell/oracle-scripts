DELETE FROM envreport;

SELECT * FROM envreport;

BEGIN
  loadreport('d:\demo-seminar','envReport.xml');
END;
/

SELECT * FROM envreport;
