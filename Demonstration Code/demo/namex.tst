@ssoo
exec namex.trc
DECLARE
   newstr VARCHAR2(1000);
BEGIN
   newstr := namex.tojava ('LINEITEMID');
   newstr := namex.tojava ('affiliateacceptscampaigndisplay');
   newstr := namex.tojava ('orderstatusid');
END;
/
   
