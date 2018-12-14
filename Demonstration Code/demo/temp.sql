CREATE OR REPLACE PACKAGE qcto_test
IS
   TYPE two_values_rt IS RECORD
   (
      text          VARCHAR2 (100),
      last_change   DATE,
      amount        NUMBER
   );

   TYPE two_values_list_t
      IS TABLE OF two_values_rt
      INDEX BY PLS_INTEGER;

   PROCEDURE process_data (
      text_in             IN     VARCHAR2,
      last_change_in      IN     DATE,
      amount_in           IN     NUMBER,
      two_values_in       IN     two_values_rt,
      list_in             IN     two_values_list_t,
      total_amount_out       OUT NUMBER,
      combined_text_out      OUT VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY qcto_test
IS
   PROCEDURE process_data (
      text_in             IN     VARCHAR2,
      last_change_in      IN     DATE,
      amount_in           IN     NUMBER,
      two_values_in       IN     two_values_rt,
      list_in             IN     two_values_list_t,
      total_amount_out       OUT NUMBER,
      combined_text_out      OUT VARCHAR2)
   IS
   BEGIN
      total_amount_out :=
         amount_in + two_values_in.amount;
      combined_text_out :=
         text_in || two_values_in.text;
   END;
END;
/