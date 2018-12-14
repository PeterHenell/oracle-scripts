DECLARE
   TYPE phone_rectype IS RECORD
   (
      area_code    PLS_INTEGER,
      exchange     PLS_INTEGER,
      phn_number   PLS_INTEGER,
      extension    PLS_INTEGER
   );

   TYPE contact_rectype IS RECORD
   (
      day_phone#    phone_rectype,
      eve_phone#    phone_rectype,
      cell_phone#   phone_rectype
   );

   sales_rep_info_rec   contact_rectype;

   myvar               VARCHAR2 (14)
                          := 7774655132;

   FUNCTION rec_from_string (
      str IN VARCHAR2)
      RETURN phone_rectype
   IS
      retval   phone_rectype;
   BEGIN
      retval.area_code :=
         SUBSTR (str, 1, 3);
      retval.exchange :=
         SUBSTR (str, 4, 3);
      retval.phn_number :=
         SUBSTR (str, 8, 4);
      retval.extension :=
         SUBSTR (str, 13);
      RETURN retval;
   END;
BEGIN
   /* right way */
   auth_rep_info_rec.day_phone# :=
      rec_from_string (myvar);

   /* wrong way */
   auth_rep_info_rec.day_phone#.area_code :=
      SUBSTR (myvar, 1, 3);
   auth_rep_info_rec.day_phone#.exchange :=
      SUBSTR (myvar, 4, 3);
   auth_rep_info_rec.day_phone#.phn_number :=
      SUBSTR (myvar, 8, 4);
   auth_rep_info_rec.day_phone#.extension :=
      SUBSTR (myvar, 13);
END;
/