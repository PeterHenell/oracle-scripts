This is the README file for sample programs in the JDBC demo directory.

It contains the following sections:
* File types and their roles
* Directory Structure
* Setting Up Schemas
* Steps to run demo programs 
* JDK version



File types and their roles :
-----------------------------

The file demo.tar contains the following file types:
* Makefile -- under each directory, except for jdbcthin, there is a
      Makefile.  It is for compiling and executing the demo programs
      under the same directory on Solaris platform.  It lists the
      features the samples demonstrate and their expected behavior.
      It also contains instructions on how to set URL, environments,
      and other preparations prior to program executions. 
* .bat -- Similar to Makefile under each directory except for jdbcthin,
      there is a rundemo.bat. It is for compiling and executing
      the demo programs under the same directory at Windows platform.
* .java -- the demo program files. Most of the filenames indicate
      the features that the programs demonstrate.
* .sql -- SQL scripts to set up some tables needed by demo programs.
      They are invoked by corresponding Makefiles.
* .htm -- A file to test Applet. It also contains instructions on how
      to run the applet program.
* .txt -- The README file.



Directory Structure :
---------------------

Untar the file demo.tar to find our samples. You will get
the following directories and files:

samples: contains the following sub-directories:

samples/generic: contains samples that generally apply to 
all our 3 JDBC drivers (thin, jdbc-oci, and jdbc-kprb). 
Please modify the connect URLs to refer to the appropriate
driver (protocol, host, port, sid, servicename, see the 
Makefiles) to use these samples. The samples demonstrates:
  * basic JDBC1.22 features, such as Select, Insert,
    Checkup.
  * JDBC2.0 features, such as Objects, Reference, LOBs,
    Collections, Connection Pooling, XA, DataSource,
    Scrollable ResultSet, and JDBC2.0 Batching.
  * JDBC3.0 features, such as transaction savepoint,
    implicit connection cache.
  * connection wrapping features: wrapping with the
    oracle.jdbc.OracleConnectionWrapper class. This can
    also be extended to create a customized wrapper.
  * Oracle 9i features, such as SQLJ Object Types,
    inheritance, and accessing nested collections 

samples/generic contains some sub directories, which 
demonstrate some Oracle 9i features. 

samples/jdbcoci: Contains samples for oci driver-specific 
features: OCI Connection Pooling, Ntier Authentication, PL/SQL
index-by tables and OCI application failover with callbacks.
Oracle 9i features, such as native-XA, are included in the sub-
directories. The JDBC oci driver should be used for these demos.
Please modify the connect URLs to refer to the appropriate driver 
(see the Makefiles for details).

samples/jdbcthin: examples of how to write applets using the thin
driver with the jdk 1.2 and newer jdk. You need to change the
connect_string in JdbcApplet.java before running this sample.

Samples-Readme.txt: this file.


NOTE: examples for kprb callins and instance methods using
Oracle 8 Object Types are provided in:
[ORACLE_HOME]/javavm/demo/demo.zip
After you unzip this file, the examples are created in:
[ORACLE_HOME]/javavm/demo/examples/jsp




Setting Up Schemas :
--------------------

It is assumed that all tables in the Oracle Sample Schema have
been set up and populated in the database prior to executing
these demos. Please refer to $ORACLE_HOME/demo/schema/README.txt
for the Sample Schema setup details.

For a quick start, you could use the SQL script mksample.sql
in the database install. Before executing the demos, start your
database, and then execute mksample.sql to create/populate all
the necessary tables.  These demo programs generally use the
HR/HR schema.



Steps to run demo programs :
----------------------------

* use .htm file
  Please refer to .htm for jdbcthin to build and execute
  applet example.

* use Makefile (Windows platform use rundemo.bat) 
  For other demo programs, please use the Makefiles under
  each directory for building and executing instructions.

  In general, each Makefile contains the targets "all, thin,
  oci, ocitns" for building and executing the demos using
  specific Oracle-JDBC drivers. Separated targets for each
  demo programs are also listed in each Makefile.
     NOTE: some demo programs need interactive inputs. 

  Makefiles provide the following information:
  -- features the demo programs under this directory
     demonstrate
  -- instructions on how to compile and execute demo
     programs under the same directory
  -- required JDK versions information and other environment
     setting information 
  -- neccessary preparations for each demo program 
  -- how to run the Makefile

  
  NOTE: 
   -- On 64 bit platforms if java has to be invoked with -d64 flag
      set USE_64FLAG to TRUE.  
   -- On 64 bit platforms which also supports
      32 bit binaries, modify JAVA_LIBRARY_PATH to point to $ORACLE_HOME/lib32
      instead of $ORACLE_HOME/lib to use 32 bit libraries.  
   -- On platforms which use LIBPATH instead of LD_LIBRARY_PATH replace 
      LD_LIBRARY_PATH by LIBPATH.

* use rundemo.bat 
  On Windows platform, please use rundemo.bat under each 
  directory for building and executing instructions.

  Targets "thin, oci, ocitns" and single_demo are supplied
  in each file. Each command file also provide additional
  information as Makefile does.

* running in Instant Client mode
  The JDBC OCI driver can also be run in the Instant Client mode.
  Operation in the Instant Client mode does not require a full
  ORACLE_HOME installation.  Instead only a selected set of files
  is needed.  Please refer to the OCI Instant Client section in
  the JDBC Developer's Guide and Reference for more information
  about the Instant Client mode.

  The JDBC OCI demo programs can be run in the Instant Client
  mode by placing the following libraries on the OS shared
  library path variable (LD_LIBRARY_PATH on Solaris or PATH
  on Windows).

  Unix                  Windows
  ---                   ------
  libclntsh.so.10.1     oci.dll
  libociei.so           oraociei10.dll
  libnnz10.so           orannzsbb10.dll
  libocijdbc10.so       oraocijdbc10.dll

  Except for libociei.so, rest of the libraries can be copied
  from $ORACL_HOME/lib in a full Oracle Client Install.  The
  libociei.so library can be copied from $ORACLE_HOME/instantclient
  directory.

  For native Xa functionality (also known as Hetero XA
  functionality), the JDBC XA library must also be copied.  On
  Unix platforms, this library, called libheteroxa10.so, is
  available in ORACLE_HOME/jdbc/lib.  On Windows, this library,
  called heteroxa10.dll, is located in ORACLE_HOME\bin.

  In addition to the above shared libraries, the JDBC class libraries
  should be placed on the CLASSPATH environment variable just as it
  is done for the non-Instant Client mode.



JDK version :
-------------

  Either Makefile (Windows command file) or comments near to
  the top of each sample program tells you which JDK version
  you should use to compile and run. In many cases, it is
  possible to modify a sample program to compile and run in a
  different JDK version if desirable. Please refer to the JDBC
  Developer's Guide and Reference for details of how to use
  Oracle JDBC drivers with different JDK versions.

                           (-: End of Readme.txt :-)
