SELECT (1 - (SUM (getmisses) / 
              (SUM (gets) + SUM (getmisses))))
        * 100 "Hit Rate"
  FROM V$ROWCACHE
 WHERE gets + getmisses != 0;        