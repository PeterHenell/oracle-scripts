CREATE OR REPLACE PACKAGE constant
/*
|| Package of constants for use throughout code.
||
|| Author: Steven Feuerstein, 9/95
||
*/
IS
   c_max_iri_weeks CONSTANT INTEGER := 54;

   /* Set to TRUE if NOT using Pro*C replacement for this code. */
   build_with_plsql BOOLEAN := FALSE;

   c_update CONSTANT CHAR(1) := 'U';
   c_delete CONSTANT CHAR(1) := 'D';
   c_insert CONSTANT CHAR(1) := 'I';
   c_transferred CONSTANT CHAR(1) := 'T';
   c_remove_record CONSTANT CHAR(1) := 'R';
   c_noaction CONSTANT CHAR(1) := NULL;

   c_update_full CONSTANT CHAR(6) := 'UPDATE';
   c_delete_full CONSTANT CHAR(6) := 'DELETE';
   c_insert_full CONSTANT CHAR(6) := 'INSERT';

   c_active CONSTANT CHAR(1) := 'A';
   c_inactive CONSTANT CHAR(1) := 'I';

   c_positive CONSTANT CHAR(1) := 'Y';
   c_negative CONSTANT CHAR(1) := 'N';

   c_unknown CONSTANT CHAR(7) := 'unknown';
   c_automatic CONSTANT CHAR(1) := 'A';
   c_add_plural CONSTANT CHAR(1) := c_positive;
   c_noadd_plural CONSTANT CHAR(1) := c_negative;
   c_not_available CONSTANT CHAR(19) := 'value-not-available';

   c_english CONSTANT INTEGER := 1;
       /* keycat_language.lang%TYPE := 1; */
   c_usa CONSTANT INTEGER := 1;
       /* keycat_language.cntry%TYPE := 1; */
   c_namerica CONSTANT VARCHAR2(2) := 'N';
       /* brand.continent%TYPE := 'N'; */

   c_keycat   CONSTANT link.attribute%TYPE := 'keycat-name';
   c_fcat     CONSTANT link.attribute%TYPE := 'fcat';
   c_brand    CONSTANT link.attribute%TYPE := 'brand';
   c_major_brand CONSTANT link.attribute%TYPE := 'major-brand';
   c_minor_brand CONSTANT link.attribute%TYPE := 'minor-brand';
   c_product_type CONSTANT link.attribute%TYPE := 'product-type';

   c_keycat_col CONSTANT link.attribute%TYPE := 'keycat_na';
   c_brand_col CONSTANT link.attribute%TYPE := 'brand_';
   c_major_brand_col CONSTANT link.attribute%TYPE := 'major_brand';
   c_minor_brand_col CONSTANT link.attribute%TYPE := 'minor_brand';
   c_product_type_col CONSTANT link.attribute%TYPE := 'product_t';

   c_upc CONSTANT CHAR(4) := 'upcs';
   c_link CONSTANT CHAR(4) := 'link';

END constant;
/
