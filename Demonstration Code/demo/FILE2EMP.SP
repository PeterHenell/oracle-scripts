CREATE OR REPLACE PROCEDURE file2emp 
   (loc IN VARCHAR2, file IN VARCHAR2, delim IN VARCHAR2 := ',')
IS
   emprec emp%ROWTYPE;
   fid UTL_FILE.FILE_TYPE;
   line VARCHAR2(2000);
   v_currloc INTEGER := 1;
   v_delimloc INTEGER := 0;
   v_colnum INTEGER := 1;
BEGIN
   fid := UTL_FILE.FOPEN (loc, file, 'R');
   LOOP
      BEGIN
         UTL_FILE.GET_LINE (fid, line);
         /* Parse the line */
         LOOP
            v_delimloc := INSTR (line, delim, v_currloc);
            v_numchars := v_delimloc - v_currloc + 1;
            v_colval := SUBSTR (line, v_currloc, v_numchars)
            IF    v_colnum = 1
            THEN  emprec.empno := TO_NUMBER (v_colval);
            ELSIF v_colnum = 2
            THEN  emprec.ename := v_colval;
            ELSIF v_colnum = 3
            THEN emprec.job := TO_NUMBER (v_colval);
            ELSIF v_colnum = 4
            THEN emprec.mgr := TO_NUMBER (v_colval);
            ELSIF v_colnum = 5
            THEN emprec.hiredate := TO_DATE (v_colval);
            ELSIF v_colnum = 6
            THEN emprec.sal := TO_NUMBER (v_colval);
            ELSIF v_colnum = 7
            THEN emprec.comm := TO_NUMBER (v_colval);
            ELSIF v_colnum = 8
            THEN emprec.deptno := TO_NUMBER (v_colval);
            END IF;            
            EXIT WHEN v_colnum = 8;
            v_currloc := v_delimloc;
            v_colnum := v_colnum + 1;   
         END LOOP;
         INSERT INTO emp VALUES
            (emprec.empno, emprec.ename, emprec.job, emprec.mgr,
             emprec.hiredate, emprec.sal, emprec.comm, emprec.deptno);
       EXCEPTION 
         WHEN NO_DATA_FOUND
         THEN
            EXIT;
      END;
   END LOOP;
   UTL_FILE.FCLOSE (fid);
END;
/
