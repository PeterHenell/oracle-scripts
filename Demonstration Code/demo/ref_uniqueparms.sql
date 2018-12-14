Step 1 Use unique names for parameters and variables in local modules. (PL/SQL refactoring)

I know I will be write lots more code, so I decide to start moving code into lo
ocal modules right away.

I don't bother passing in parameters, because the code is simple enough; there 
 is no need and therefore I know that the parameters and variables are properly
y referenced.

Notice, however, that my local module mixes "global" references to the script n
name and id, but they are different structures (parameter ID and script name fr
rom the record which was retrieved by ID). 

Universal ID = {1F3F7D89-EC8F-4869-BEB2-DBF4B7E02A74}

PROCEDURE process_script (script_id_in IN Sg_Script_Tp.id_t)
IS
   l_script   Sg_Script_Tp.sg_script_rt;
 
   PROCEDURE delete_or_purge
   IS
   BEGIN
      IF l_script.NAME LIKE '%RUNTIME%'
      THEN
         delete_runtime_script (script_id_in);
      ELSE
         purge_results (script_id_in);  
         reset_script (script_id_in); 
      END IF;
   END delete_or_purge;
BEGIN
   l_script := Sg_Script_Qp.onerow (script_id_in);
   delete_or_purge;
END process_script;
================================================================================
Step 2 Use unique names for parameters and variables in local modules. (PL/SQL refactoring)

I realize that I also need to do the same processing for the scripts that this 
 script depends on. I add the loop against the required scripts (the scanning W
WHILE loop is generated courtesy of "Scan forward - basic WHILE loop").

This has some obvious problems, though. I want to call delete_or_purge for each
h of the required scripts, but that local program references the parameter. It 
 also references the script name; we will assume that the requirements for this
s program is that the required scripts are always purged if the main script is 
 a "runtime" script. 

OK - so I need to add a parameter to the delete_or_purge program. 

Universal ID = {2DCFE85E-92F1-4F3E-BE8D-FED677619F8B}

PROCEDURE process_script (script_id_in IN Sg_Script_Tp.id_t)
IS
   l_script     Sg_Script_Tp.sg_script_rt;
   l_required   Sg_Script_Tp.id_tc;
   l_row        PLS_INTEGER;
 
   PROCEDURE delete_or_purge
   IS
   BEGIN
      IF l_script.NAME LIKE '%RUNTIME%'
      THEN
         delete_runtime_script (script_id_in);
      ELSE
         purge_results (script_id_in);
         reset_script (script_id_in); 
      END IF;
   END delete_or_purge;
BEGIN
   l_script := Sg_Script_Qp.onerow (script_id_in);
   delete_or_purge;
   l_row := l_required.FIRST;
 
   WHILE (l_row IS NOT NULL)
   LOOP
      delete_or_purge;
      l_row := l_required.NEXT (l_row);
   END LOOP;
END process_script;
================================================================================
Step 0: Problematic code for  Use unique names for parameters and variables in local modules. (PL/SQL refactoring) 

The problematic code for that demonstrates "Use unique names for parameters and
d variables in local modules. (PL/SQL refactoring)"

The logic starts out simply enough. For a given script ID, either delete the ru
untime script or purge the script results. The problem is that is soon gets mor
re complicated....

Universal ID = {A7980153-6342-4A9A-9AD2-77D3A53BC1D8}

PROCEDURE process_script (script_id_in IN Sg_Script_Tp.id_t)
IS
   l_script   Sg_Script_Tp.sg_script_rt;
BEGIN
   l_script := Sg_Script_Qp.onerow (script_id_in);
 
   IF l_script.NAME LIKE '%RUNTIME%'
   THEN
      delete_runtime_script (script_id_in);
   ELSE
      purge_results (script_id_in);   
      reset_script (script_id_in); 
   END IF;
END process_script;
================================================================================
Step 3 Use unique names for parameters and variables in local modules. (PL/SQL refactoring)

I realize that I also need to do the same processing for the scripts that this 
 script depends on. I add the loop against the required scripts (the scanning W
WHILE loop is generated courtesy of "Scan forward - basic WHILE loop").

This has some obvious problems, though. I want to call delete_or_purge for each
h of the required scripts, but that local program references the parameter. It 
 also references the script name; we will assume that the requirements for this
s program is that the required scripts are always purged if the main script is 
 a "runtime" script. 

OK - so I need to add a parameter to the delete_or_purge program. 

Universal ID = {64065120-3A4B-4ED6-B0A6-A6CA3386727D}

PROCEDURE process_script (script_id_in IN Sg_Script_Tp.id_t)
IS
   l_script     Sg_Script_Tp.sg_script_rt;
   l_required   Sg_Script_Tp.id_tc;
   l_row        PLS_INTEGER;
 
   PROCEDURE delete_or_purge (script_id_in IN Sg_Script_Tp.id_t)
   IS
   BEGIN
      IF l_script.NAME LIKE '%RUNTIME%'
      THEN
         delete_runtime_script (script_id_in);
      ELSE
         purge_results (script_id_in);
         reset_script (script_id_in); 
      END IF;
   END delete_or_purge;
BEGIN
   l_script := Sg_Script_Qp.onerow (script_id_in);
   delete_or_purge (script_id_in)
   l_row := l_required.FIRST;
 
   WHILE (l_row IS NOT NULL)
   LOOP
      delete_or_purge (l_required(l_row));
      l_row := l_required.NEXT (l_row);
   END LOOP;
END process_script;
================================================================================
Step 4 Use unique names for parameters and variables in local modules. (PL/SQL refactoring)

To fix this problem, I will change the name of the inner parameter and VERY CAR
REFULLY do a search and replace of this code. A manual S & R is best; the chanc
ce of a bug is small. This is ANOTHER motivator for keeping your blocks small. 

Universal ID = {C0AEA0C9-29EF-4CFC-9F58-4F71984CFF0E}

PROCEDURE process_script (script_id_in IN Sg_Script_Tp.id_t)
IS
   l_script     Sg_Script_Tp.sg_script_rt;
   l_required   Sg_Script_Tp.id_tc;
   l_row        PLS_INTEGER;
 
   PROCEDURE delete_or_purge (dp_script_id_in IN Sg_Script_Tp.id_t)
   IS
   BEGIN
      IF l_script.NAME LIKE '%RUNTIME%'
      THEN
         delete_runtime_script (dp_script_id_in);
      ELSE
         purge_results (dp_script_id_in);
         reset_script (script_id_in); 
      END IF;
   END delete_or_purge;
BEGIN
   l_script := Sg_Script_Qp.onerow (script_id_in);
   delete_or_purge (script_id_in)
   l_row := l_required.FIRST;
 
   WHILE (l_row IS NOT NULL)
   LOOP
      delete_or_purge (l_required(l_row));
      l_row := l_required.NEXT (l_row);
   END LOOP;
END process_script;
================================================================================
