-- https://petesdbablog.wordpress.com/2013/04/06/disable-oracle-diagnostic-pack-tuning-pack/

col name format A30
col detected format 9999
col samples format 9999
col used format A5
col interval format 9999999

SELECT name,
       detected_usages detected,
                 total_samples   samples,
                 currently_used  used,
                 to_char(last_sample_date,'MMDDYYYY:HH24:MI') last_sample,
                 sample_interval interval
FROM dba_feature_usage_statistics
WHERE name = 'Automatic Workload Repository';
	
	
-- query to see the use of the tuning packs
col name format A31
col detected format 9999
col samples format 9999
col used format A5
col interval format 9999999

SELECT name,       
       detected_usages detected,
       total_samples   samples,
       currently_used  used,
       to_char(last_sample_date,'MMDDYYYY:HH24:MI') last_sample,
       sample_interval interval
  FROM dba_feature_usage_statistics
 WHERE name = 'Automatic Workload Repository'     OR  name like 'SQL%';
 
 
 COLUMN name  FORMAT A60
COLUMN detected_usages FORMAT 999999999999

SELECT u1.name,
       u1.detected_usages,
       u1.currently_used,
       u1.version
FROM   dba_feature_usage_statistics u1
WHERE  u1.version = (SELECT MAX(u2.version)
                     FROM   dba_feature_usage_statistics u2
                     WHERE  u2.name = u1.name)
AND    u1.detected_usages > 0
AND    u1.dbid = (SELECT dbid FROM v$database)
ORDER BY name;
 
-- 11g and forward
show parameter control_management_pack_access;

--The possible values are:
--NONE – disable all management packs.
--DIAGNOSTIC – Nur DIAGNOSTIC Pack available.
--DIAGNOSTIC+TUNING – DIAGNOSTIC and TUNING Pack available.