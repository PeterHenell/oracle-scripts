/* The data layer, table definitions */

--@@hr_schema_install.sql

/* Generic utilities with an example of string utilities. */

@@tb_strings.pkg
@@tb_string_tracker.pkg

/* 
   Infrastucture: implemented in the QCGU error management framework:
     The qu_runtime package
*/

/* The data access layer */

@@employees_tp.pks
@@employees_qp.pks
@@employees_cp.pks
--@@employees_xp.pks
@@employees_qp.pkb
@@employees_cp.pkb

CREATE OR REPLACE PROCEDURE bad_layering_xp
IS
   l_text   employee_rp.fullname_t;
BEGIN
   hr_compensation.adjust_salaries (1);
END;
/

/* The business rule layer */

@@employees_rp.pks
@@employees_rp.pkb

/* The application code layer */

@@hr_compensation.pkg

DECLARE
   l_layers   layer_validator.layer_patterns_aat;

   PROCEDURE add_layer (layer_in IN PLS_INTEGER, patterns_in IN VARCHAR2)
   IS
      l_list       tb_strings.item_tt;
      l_patterns   layer_validator.patterns_aat;
   BEGIN
      l_list := tb_strings.string_to_list (patterns_in);

      FOR indx IN 1 .. l_list.COUNT
      LOOP
         l_patterns (l_patterns.COUNT + 1) := l_list (indx);
      END LOOP;

      l_layers (layer_in) := l_patterns;
   END add_layer;
BEGIN
   layer_validator.set_trace (FALSE);
   add_layer (0, 'TB_%');
   add_layer (1, '%_CP,%_QP,%_TP,%_XP');
   add_layer (2, '%_RP');
   add_layer (3, 'HR_%');
   layer_validator.validate_program (USER, 'HR_COMPENSATION', l_layers);
   layer_validator.validate_program (USER, 'EMPLOYEE_RP', l_layers);
   layer_validator.validate_program (USER, 'BAD_LAYERING_XP', l_layers);
   --
   DBMS_OUTPUT.put_line (   CHR (10)
                         || 'NOW VALIDATE ALL CODE IN SCHEMA'
                         || CHR (10)
                        );
   layer_validator.validate_schema (USER, l_layers);
END;
/