Step 1 Move repeated logic into separate, perhaps local, modules. (PL/SQL refactoring)

Step 1 in the refactoring of topic "Move repeated logic into separate, perhaps 
 local, modules."

Finally, I "give up" and take the time to write small, simple programs that do 
 nothing but hide the structure of the names.

This code is taken from the sw_apply package body.

Universal ID = {713750F8-6080-451D-8C8B-DB3B412E0935}

   FUNCTION rt_name (user_in IN VARCHAR2 DEFAULT NULL)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN Sw_Qnxo.c_qnxo_playground || '-' || NVL (user_in, USER);
   END rt_name;
 
   FUNCTION rt_objects_name (user_in IN VARCHAR2 DEFAULT NULL)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN rt_name (user_in) || ' objects';
   END rt_objects_name;
 
   FUNCTION rt_script_grp_name (user_in IN VARCHAR2 DEFAULT NULL)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN rt_name (user_in) || ' script grp';
   END rt_script_grp_name;
 
   FUNCTION rt_roadmap_name (user_in IN VARCHAR2 DEFAULT NULL)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN rt_name (user_in) || ' roadmap';
   END rt_roadmap_name;
 
   FUNCTION rt_roadmap_grp_name (user_in IN VARCHAR2 DEFAULT NULL)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN rt_name (user_in) || ' roadmap group';
   END rt_roadmap_grp_name;
 
   FUNCTION rt_task_name (user_in IN VARCHAR2 DEFAULT NULL)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN rt_name (user_in) || ' task';
   END rt_task_name;
 
   FUNCTION rt_task_grp_name (user_in IN VARCHAR2 DEFAULT NULL)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN rt_name (user_in) || ' task group';
   END rt_task_grp_name;
 
   FUNCTION is_rt_name (NAME_IN IN VARCHAR2)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN NAME_IN LIKE Sw_Qnxo.c_qnxo_playground || '%';
   END is_rt_name;
================================================================================
Step 2 Move repeated logic into separate, perhaps local, modules. (PL/SQL refactoring)

Step 2 in the refactoring of topic "Move repeated logic into separate, perhaps 
 local, modules."

Now I can go into my programs full of redundant name assignments and call the p
programs instead.

Universal ID = {AC28BC68-915A-4E3B-8884-7AED1309DEAD}

PROCEDURE create_rt_script_group (id_out OUT Sg_Script_Grp_Tp.id_t)
IS
    l_script_grp   Sg_Script_Grp_Tp.sg_script_grp_rt;
    l_rows         PLS_INTEGER;
BEGIN
    l_script_grp :=
       Sg_Script_Grp_Qp.or_un_sg_script_grp_name
                                          (NAME_IN      => rt_script_grp_name);
 
    IF l_script_grp.ID IS NULL
    THEN
       Sg_Script_Grp_Cp.ins (NAME_IN      => rt_script_grp_name
                            ,id_out       => l_script_grp.ID
                            );
    END IF;
 
    -- Clean out all the scripts in the group.
    Sg_Script_Int_Cp.del_fk_si_hdr_id (hdr_id_in      => l_script_grp.ID
                                      ,rows_out       => l_rows
                                      );
    id_out := l_script_grp.ID;
END create_rt_script_group;
 
-- And ANOTHER reference soon pops up in the cleanup program!  
 
PROCEDURE playground_cleanup (
   user_in             IN   VARCHAR2 DEFAULT NULL
  ,starting_point_in   IN   PLS_INTEGER DEFAULT NULL
)
IS
   l_rows         PLS_INTEGER;
   l_check_ints   BOOLEAN;
BEGIN
   Sa_Application_Xp.del_runtime_app;
   Sg_Script_Grp_Xp.del
      (id_in              => Sg_Script_Grp_Qp.id_for_name
                                               (rt_script_grp_name (user_in)
                                               )
      ,rows_out           => l_rows
      ,check_ints_in      => FALSE
      );
================================================================================
Step 0: Problematic code for  Move repeated logic into separate, perhaps local, modules. (PL/SQL refactoring) 

The problematic code for that demonstrates "Move repeated logic into separate, 
 perhaps local, modules. (PL/SQL refactoring)"

Here is an example from Qnxo itself. I need to create "on the fly" script group
ps, roadmaps, tasks etc. (all the way up the hierarchy) to allow you to dynamic
cally run whatever script you want (without assigning it to a task first). I wa
anted to standardize names to keep them separate from your own elements.

It started out with one simple repetition of the name, and I really didn't see 
 the point of bothering with a local program simply to return the concatenation
n. But within an hour, it got MUCH more complicated - I needed to add the USER 
 name to the string, and I needed to use the same format at all levels of the s
structure.

Universal ID = {ABAF4F13-7BF5-4034-9375-3FFB4AC99C35}

-- Just this one place, repetition right next to each other.
PROCEDURE create_pg_script_group (id_out OUT Sg_Script_Grp_Tp.id_t)
IS
   l_script_grp   Sg_Script_Grp_Tp.sg_script_grp_rt;
   l_rows         PLS_INTEGER;
BEGIN
   l_script_grp :=
      Sg_Script_Grp_Qp.or_un_sg_script_grp_name
           (NAME_IN  => c_app_name || ' script group');
 
   IF l_script_grp.ID IS NULL
   THEN
      Sg_Script_Grp_Cp.ins (NAME_IN      => c_app_name || ' script group'
                           ,id_out       => l_script_grp.ID
                           );
   END IF;
 
   -- Clean out all the scripts in the group.
   Sg_Script_Int_Cp.del_fk_si_hdr_id (hdr_id_in      => l_script_grp.ID
                                     ,rows_out       => l_rows
                                     );
   id_out := l_script_.ID;
END create_pg_script_group;
 
================================================================================
