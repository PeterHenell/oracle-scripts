set feedback off
set verify off
exec PLVvu.code ('&&firstparm', NVL (&&secondparm, 1), NVL (&&thirdparm, NULL));
set feedback on

