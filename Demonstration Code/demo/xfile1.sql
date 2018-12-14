/* Compile, load, create, and call Java stored procedure
   Written by Bill Pribyl, Datacraft
*/

REM Must have Java compiler installed somewhere

host javac JFile1.java

host loadjava -user scott/tiger -oci8 -resolve JFile1.class

@xfile1.pkg
