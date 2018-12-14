REM
REM Author: Bill Pribyl (with content drawn from other tuning tools)
REM October 1999
REM
REM Will not work for parallel server installation which uses multiple freelist groups
REM

SET LINESIZE 132
SET SERVEROUTPUT ON SIZE 100000
DECLARE

   v_db_block_size_value NUMBER := &&db_block_size;
   v_db_block_size NATURAL;
   v_now VARCHAR2(20) := TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
   v_total_blocks NUMBER;
   v_total_bytes NUMBER;
   v_unused_blocks NUMBER;
   v_unused_bytes NUMBER; 
   v_last_used_extent_file_id NUMBER;
   v_last_used_extent_block_id NUMBER;
   v_last_used_block NUMBER;
   v_used_bytes NUMBER;
   v_free_blks NUMBER;
   v_free_bytes NUMBER;

/*
   CURSOR getbsize IS
      SELECT value FROM v$parameter
       WHERE name = 'db_block_size';
*/

   TYPE stat_t IS RECORD (
      tablespace_name user_tablespaces.tablespace_name%TYPE,
      cluster_name user_clusters.cluster_name%TYPE,
      pct_free NUMBER,
      pct_used NUMBER,
      ini_trans NUMBER,
      max_trans NUMBER,
      initial_extent NUMBER,
      next_extent NUMBER,
      min_extents NUMBER,
      max_extents NUMBER,
      pct_increase NUMBER,
      freelists NUMBER,
      freelist_groups NUMBER,
      cluster_type user_clusters.cluster_type%TYPE
   );

   TYPE seg_stat_t IS RECORD (
      extents NUMBER,
      blocks NUMBER);

   v_object_stats stat_t;

   v_segment_stats seg_stat_t;

   PROCEDURE get_object_segment_data (
      object_name_in IN VARCHAR2,
      object_type_in IN VARCHAR2,
      seg_stat OUT seg_stat_t)
   IS
      CURSOR segCur IS
         SELECT extents, blocks
           FROM user_segments
          WHERE segment_name = object_name_in
            AND segment_type = object_type_in;
   BEGIN
      OPEN segCur;
      FETCH segCur INTO seg_stat;
      CLOSE segCur;
   END;

   PROCEDURE get_object_stats (
      object_name_in IN VARCHAR2, 
      object_type_in IN VARCHAR2, 
      obj_stat OUT stat_t)
   IS
      
   BEGIN
      IF object_type_in = 'TABLE'
      THEN
         DECLARE
            CURSOR tabCur IS
               SELECT  tablespace_name, cluster_name, pct_free, pct_used,
                       ini_trans, max_trans, initial_extent, next_extent,
                       min_extents, max_extents, pct_increase, freelists,
                       freelist_groups, NULL
                 FROM user_tables
                WHERE table_name = object_name_in;
         BEGIN
            OPEN tabCur;
            FETCH tabCur INTO obj_stat;
            CLOSE tabCur;
         END;
      ELSIF object_type_in = 'INDEX'
      THEN
         DECLARE
            CURSOR indCur IS
               SELECT  tablespace_name, NULL, pct_free, NULL,
                       ini_trans, max_trans, initial_extent, next_extent,
                       min_extents, max_extents, pct_increase, freelists,
                       freelist_groups, NULL
                 FROM user_indexes
                WHERE index_name = object_name_in;
         BEGIN
            OPEN indCur;
            FETCH indCur INTO obj_stat;
            CLOSE indCur;
         END;
      ELSIF object_type_in = 'CLUSTER'
      THEN
         DECLARE
            CURSOR cluCur IS
               SELECT  tablespace_name, cluster_name, pct_free, pct_used,
                       ini_trans, max_trans, initial_extent, next_extent,
                       min_extents, max_extents, pct_increase, freelists,
                       freelist_groups, cluster_type
                 FROM user_clusters
                WHERE cluster_name = object_name_in;
         BEGIN
            OPEN cluCur;
            FETCH cluCur INTO obj_stat;
            CLOSE cluCur;
         END;
      END IF;
   END;
         
BEGIN

   v_db_block_size := v_db_block_size_value;

/*
   DBMS_OUTPUT.PUT_LINE('segment,type,usedBytes,unusedBytes,totalBytes,' ||
      'tablespace,cluster,pctfree,pctused,initrans,maxtrans,iniextent,nextextent,' ||
      'minextents,maxextents,pctinc,freelists,freelistGrps,clusterType,freeBytes');
*/
   FOR theSeg IN
      (SELECT segment_name, segment_type
         FROM USER_SEGMENTS
        WHERE segment_name not in ('_default_auditing_options_')
          AND segment_name LIKE '&&segment_name_pattern'
          AND segment_type in ('TABLE','INDEX','CLUSTER')
        ORDER BY segment_name)
   LOOP

      SYS.DBMS_SPACE.UNUSED_SPACE(segment_owner => UPPER(USER),
              segment_name => UPPER(theSeg.segment_name),
              segment_type => UPPER(theSeg.segment_type),
              total_blocks => v_total_blocks,
              total_bytes => v_total_bytes,
              unused_blocks => v_unused_blocks,
              unused_bytes => v_unused_bytes,
              last_used_extent_file_id => v_last_used_extent_file_id,
              last_used_extent_block_id => v_last_used_extent_block_id,
              last_used_block => v_last_used_block);

      v_used_bytes := v_total_bytes - v_unused_bytes;

      SYS.DBMS_SPACE.FREE_BLOCKS(segment_owner => UPPER(USER),
              segment_name => UPPER(theSeg.segment_name),
              segment_type => UPPER(theSeg.segment_type),
              freelist_group_id => 0,
              free_blks => v_free_blks);

      v_free_bytes := v_db_block_size * v_free_blks;

      get_object_stats (theSeg.segment_name, theSeg.segment_type, v_object_stats);

      get_object_segment_data (theSeg.segment_name, theSeg.segment_type, v_segment_stats);

/*
      DBMS_OUTPUT.PUT_LINE(
           v_now ||','
        || theSeg.segment_name || ','
        || theSeg.segment_type || ','
        || v_used_bytes || ','
        || v_unused_bytes || ','
        || v_total_bytes || ','
        || v_object_stats.tablespace_name ||','
        || v_object_stats.cluster_name||','
        || v_object_stats.pct_free||','
        || v_object_stats.pct_used||','
        || v_object_stats.ini_trans||','
        || v_object_stats.max_trans||','
        || v_object_stats.initial_extent||','
        || v_object_stats.next_extent||','
        || v_object_stats.min_extents||','
        || v_object_stats.max_extents||','
        || v_object_stats.pct_increase||','
        || v_object_stats.freelists||','
        || v_object_stats.freelist_groups||','
        || v_object_stats.cluster_type||','
        || v_segment_stats.extents||','
        || v_segment_stats.blocks||','
        || v_free_bytes);
*/
      DBMS_OUTPUT.PUT_LINE('Data in ' || ' ' || theSeg.segment_name || ' occupies ' || 
         v_used_bytes || ' bytes ');
   END LOOP;
END;
/
