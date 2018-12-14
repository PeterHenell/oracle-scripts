/* Formatted on 2002/04/01 00:42 (Formatter Plus v4.5.2) */
-- Start of DDL Script for Package ROHANB.DSF_ERR_IFS
-- Generated 18-Feb-2002 9:09:34 from ROHANB@DHDBDEV.WORLD

CREATE OR REPLACE PACKAGE dsf_err_ifs
IS
   
-- Program Data
   ref_must_have_defn        EXCEPTION;
   PRAGMA EXCEPTION_INIT (ref_must_have_defn,  -20167);
   domain_not_for_assoc      EXCEPTION;
   PRAGMA EXCEPTION_INIT (domain_not_for_assoc,  -20165);
   
/* An Association cannot be made with Data Element <x> as it has a Domain that is a 'List' or 'Table Reference'. */
   assoc_and_lookup          EXCEPTION;
   PRAGMA EXCEPTION_INIT (assoc_and_lookup,  -20138);
   elem_must_have_domain     EXCEPTION;
   PRAGMA EXCEPTION_INIT (elem_must_have_domain,  -20075);
   VALUE_ERROR               EXCEPTION;
   PRAGMA EXCEPTION_INIT (VALUE_ERROR,  -20069);
   invalid_integer           EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_integer,  -20201);
   element_in_use            EXCEPTION;
   PRAGMA EXCEPTION_INIT (element_in_use,  -20136);
   mecv_does_not_match       EXCEPTION;
   PRAGMA EXCEPTION_INIT (mecv_does_not_match,  -20200);
   prim_not_basic            EXCEPTION;
   PRAGMA EXCEPTION_INIT (prim_not_basic,  -20180);
   invalid_date_format       EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_date_format,  -20077);
   free_flag_not_n           EXCEPTION;
   PRAGMA EXCEPTION_INIT (free_flag_not_n,  -20169);
   addit_domain_type         EXCEPTION;
   PRAGMA EXCEPTION_INIT (addit_domain_type,  -20170);
   defn_in_txf               EXCEPTION;
   PRAGMA EXCEPTION_INIT (defn_in_txf,  -20160);
   compound_has_no_lookup    EXCEPTION;
   PRAGMA EXCEPTION_INIT (compound_has_no_lookup,  -20123);
   domain_not_list           EXCEPTION;
   PRAGMA EXCEPTION_INIT (domain_not_list,  -20068);
   
/* An Association cannot be made with Data Element <x> as it has Additional Value(s) assigned. */
   no_addit_domain           EXCEPTION;
   PRAGMA EXCEPTION_INIT (no_addit_domain,  -20137);
   withdraw_flex_only        EXCEPTION;
   PRAGMA EXCEPTION_INIT (withdraw_flex_only,  -20135);
   invalid_value             EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_value,  -20078);
   dml_not_allowed           EXCEPTION;
   PRAGMA EXCEPTION_INIT (dml_not_allowed,  -20061);
   
/* An Association cannot be made between the Data Elements <x and y> as they have no common value. */
   no_common_value           EXCEPTION;
   PRAGMA EXCEPTION_INIT (no_common_value,  -20139);
   
/* A recursive metadata insertion error. */
   recursive_placement       EXCEPTION;
   PRAGMA EXCEPTION_INIT (recursive_placement,  -20134);
   defn_for_ref_only         EXCEPTION;
   PRAGMA EXCEPTION_INIT (defn_for_ref_only,  -20131);
   already_exists            EXCEPTION;
   PRAGMA EXCEPTION_INIT (already_exists,  -20125);
   compound_has_lookup       EXCEPTION;
   PRAGMA EXCEPTION_INIT (compound_has_lookup,  -20122);
   update_not_allowed        EXCEPTION;
   PRAGMA EXCEPTION_INIT (update_not_allowed,  -20066);
   invalid_number_format     EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_number_format,  -20070);
   negative_range            EXCEPTION;
   PRAGMA EXCEPTION_INIT (negative_range,  -20162);
   incorrect_domain          EXCEPTION;
   PRAGMA EXCEPTION_INIT (incorrect_domain,  -20126);
   invalid_parent            EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_parent,  -20060);
   must_be_entered           EXCEPTION;
   PRAGMA EXCEPTION_INIT (must_be_entered,  -20065);
   delete_not_allowed        EXCEPTION;
   PRAGMA EXCEPTION_INIT (delete_not_allowed,  -20062);
   max_length_exceeded       EXCEPTION;
   PRAGMA EXCEPTION_INIT (max_length_exceeded,  -20064);
   not_addit_datatype        EXCEPTION;
   PRAGMA EXCEPTION_INIT (not_addit_datatype,  -20163);
   non_char_datatype         EXCEPTION;
   PRAGMA EXCEPTION_INIT (non_char_datatype,  -20161);
   invalid_mdata_structure   EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_mdata_structure,  -20074);
   no_input_data             EXCEPTION;
   PRAGMA EXCEPTION_INIT (no_input_data,  -20206);
   invalid_spec_drivers      EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_spec_drivers,  -20203);
   invalid_decimal           EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_decimal,  -20202);
   part_of_uk                EXCEPTION;
   PRAGMA EXCEPTION_INIT (part_of_uk,  -20174);
   value_not_in_domain       EXCEPTION;
   PRAGMA EXCEPTION_INIT (value_not_in_domain,  -20173);
   domain_not_for_av         EXCEPTION;
   PRAGMA EXCEPTION_INIT (domain_not_for_av,  -20164);
   mismatched_hierarchy      EXCEPTION;
   PRAGMA EXCEPTION_INIT (mismatched_hierarchy,  -20205);
   mecv_does_not_exist       EXCEPTION;
   PRAGMA EXCEPTION_INIT (mecv_does_not_exist,  -20179);
   category_not_core         EXCEPTION;
   PRAGMA EXCEPTION_INIT (category_not_core,  -20176);
   too_few_iterations        EXCEPTION;
   PRAGMA EXCEPTION_INIT (too_few_iterations,  -20072);
   xor_violation             EXCEPTION;
   PRAGMA EXCEPTION_INIT (xor_violation,  -20204);
   lookup_not_allowed        EXCEPTION;
   PRAGMA EXCEPTION_INIT (lookup_not_allowed,  -20063);
   invalid_restriction       EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_restriction,  -20133);
   defn_cur_not_open         EXCEPTION;
   PRAGMA EXCEPTION_INIT (defn_cur_not_open,  -20127);
   too_many_iterations       EXCEPTION;
   PRAGMA EXCEPTION_INIT (too_many_iterations,  -20073);
   element_withdrawn         EXCEPTION;
   PRAGMA EXCEPTION_INIT (element_withdrawn,  -20067);
   null_rule_insert          EXCEPTION;
   PRAGMA EXCEPTION_INIT (null_rule_insert,  -20175);
   free_flag_not_y           EXCEPTION;
   PRAGMA EXCEPTION_INIT (free_flag_not_y,  -20168);
   invalid_datatype          EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_datatype,  -20177);
   not_addit_domain_type     EXCEPTION;
   PRAGMA EXCEPTION_INIT (not_addit_domain_type,  -20171);
   scale_required            EXCEPTION;
   PRAGMA EXCEPTION_INIT (scale_required,  -20132);
   assoc_not_restriction     EXCEPTION;
   PRAGMA EXCEPTION_INIT (assoc_not_restriction,  -20079);
   does_not_exist            EXCEPTION;
   PRAGMA EXCEPTION_INIT (does_not_exist,  -20071);
   dom_datatype_mismatch     EXCEPTION;
   PRAGMA EXCEPTION_INIT (dom_datatype_mismatch,  -20172);
   not_assoc_datatype        EXCEPTION;
   PRAGMA EXCEPTION_INIT (not_assoc_datatype,  -20166);
   must_not_be_entered       EXCEPTION;
   PRAGMA EXCEPTION_INIT (must_not_be_entered,  -20128);
   domain_too_long           EXCEPTION;
   PRAGMA EXCEPTION_INIT (domain_too_long,  -20076);
   elem_must_be_compound     EXCEPTION;
   PRAGMA EXCEPTION_INIT (elem_must_be_compound,  -20124);
   must_be_in_list           EXCEPTION;
   PRAGMA EXCEPTION_INIT (must_be_in_list,  -20130);
   elem_must_be_primitive    EXCEPTION;
   PRAGMA EXCEPTION_INIT (elem_must_be_primitive,  -20129);
   not_found                 EXCEPTION;
   PRAGMA EXCEPTION_INIT (not_found,  -20178);

   
-- Sub-Program Unit Declarations
/* Generically Raises Exception */
   PROCEDURE raise_exception (
      i_exception        IN   VARCHAR2,
      i_err_msg_par      IN   VARCHAR2 := NULL,
      i_err_cause_par    IN   VARCHAR2 := 'NULL',
      i_err_action_par   IN   VARCHAR2 := 'NULL'
   );

   
/* Places the error (with parameter substituton) on the error text array */
   PROCEDURE set_error_text (
      io_meta_errors   IN OUT NOCOPY   long_text_coltype,
      i_exception      IN              VARCHAR2,
      i_err_msg_par    IN              VARCHAR2
            := NULL
   );
END dsf_err_ifs;
/



-- End of DDL Script for Package ROHANB.DSF_ERR_IFS

