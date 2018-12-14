CREATE OR REPLACE FUNCTION getpets_like
   (petlist IN Pettab_t, like_str IN VARCHAR2)
   RETURN pettab_t
IS
   list_to_return Pettab_t := Pettab_t();
   onepet Pet_t;
   counter PLS_INTEGER := 1;
BEGIN
   IF UTL_COLL.IS_LOCATOR (petlist)
   THEN
      FOR theRec IN
         (SELECT VALUE(petList) apet
           FROM TABLE(CAST(petlist AS Pettab_t)) petList
          WHERE petList.name LIKE like_str)
      LOOP
         list_to_return.EXTEND;
         list_to_return(counter) := theRec.apet;
         counter := counter + 1;
      END LOOP;
   ELSE
      FOR i IN 1..petlist.COUNT
      LOOP
         IF petlist(i).name LIKE like_str
         THEN
            list_to_return.EXTEND;
            list_to_return(i) := petlist(i);
         END IF;
      END LOOP;
   END IF;
   RETURN list_to_return;
END;
/
