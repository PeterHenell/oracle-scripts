col module format a15
col action format a15
 
SELECT  module
       ,action
       ,SUM(buffer_gets)    buffer_gets
       ,SUM(rows_processed) rows
       ,SUM(disk_reads)     disk_reads
       ,SUM(buffer_gets)/SUM(rows_processed)
                            buff_per_row
  FROM  
        sys.v_$sql
 WHERE 
       module IS NOT NULL
   AND action IS NOT NULL
 GROUP BY module, action;
