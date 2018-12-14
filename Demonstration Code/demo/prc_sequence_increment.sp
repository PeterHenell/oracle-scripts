CREATE OR REPLACE PROCEDURE prc_sequence_increment (
   p_in_seq_nm      IN     VARCHAR2
 , p_in_increment   IN     NUMBER
 , p_out_start         OUT NUMBER
 , p_out_end           OUT NUMBER)
AS
   v_nbr1      PLS_INTEGER := 0;
   v_nbr2      PLS_INTEGER := 0;
   v_cmd       VARCHAR2 (32767);
   v_hold_id   PLS_INTEGER := 0;
BEGIN
   EXECUTE IMMEDIATE   'alter sequence '
                    || p_in_seq_nm
                    || ' increment by '
                    || p_in_increment;

   EXECUTE IMMEDIATE 'select ' || p_in_seq_nm || '.nextval from dual '
      INTO v_hold_id;

   p_out_end := v_hold_id;
   p_out_start := p_out_end - p_in_increment + 1;

   EXECUTE IMMEDIATE 'alter sequence ' || p_in_seq_nm || ' increment by 1 ';
END;
/