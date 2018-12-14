DECLARE
   id   INTEGER;
BEGIN
   qdb_topics_cp.ins (domain_id_in         => 1
                    , text_in              => 'The BETWEEN Clause of INDICES OF'
                    , parent_topic_id_in   => 1249
                    , sibling_pos_in       => 1
                    , topic_id_out         => id);
   DBMS_OUTPUT.put_line (id);
   qdb_topics_cp.
    ins (
      domain_id_in         => 1
    , text_in              => 'Types of expressions valid for BETWEEN Clause of INDICES OF'
    , parent_topic_id_in   => id
    , sibling_pos_in       => 1
    , topic_id_out         => id);
    DBMS_OUTPUT.put_line (id);
END;
/