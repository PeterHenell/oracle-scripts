CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "UTLcmd"
AS import java.lang.Runtime;

public class execHostCommand
{ 
  public static void execute (String command) throws java.io.IOException
  {
   //String osName = System.getProperty("os.name");
   //if(osName.equals("Windows XP"))
       command = "cmd /c " + command;
   Runtime rt = java.lang.Runtime.getRuntime();
   rt.exec(command);
  }
}
/

CREATE OR REPLACE PACKAGE Host_Command IS
  PROCEDURE execute (cmd IN VARCHAR2) AS LANGUAGE JAVA NAME
           'execHostCommand.execute(java.lang.String)';
END;
/

/* Now suppose that I want to use this class to remove a file. */

BEGIN
   host_command.EXECUTE ('del c:\temp\temp.txt');
END;
/

/* Before this will work, I will need privileges
   granted with a block like this run from a SYSDBA schema: */
   
BEGIN
   DBMS_JAVA.grant_permission ('HR'
                             , 'SYS:java.io.FilePermission'
                             , '<<ALL FILES>>'
                             , 'execute'
                              );
   DBMS_JAVA.grant_permission ('HR'
                             , 'SYS:java.lang.RuntimePermission'
                             , 'writeFileDescriptor'
                             , ''
                              );
   DBMS_JAVA.grant_permission ('HR'
                             , 'SYS:java.lang.RuntimePermission'
                             , 'readFileDescriptor'
                             , ''
                              );
END;
/
