PROCEDURE del_scenario (scenario_in IN INTEGER)
IS
   new_pl_seq_nu fin_v1plovrd.pl_ovrd_seq_nu%TYPE;

   CURSOR imp_cur 
   IS
      SELECT DISTINCT reg_cd, 
             pjtn_site_pl_dt,
             pl_ovrd_seq_nu,
             pjtn_site_prft_dt, 
             prft_ovrd_seq_nu
       FROM fin_v1prjsim;

   prev_imp_rec imp_cur%ROWTYPE;

   CURSOR siteprof_cur
      (pl_date_in IN fin_v1prjsim.pjtn_site_pl_dt%TYPE)
   IS
      SELECT prft_t12_bas_am,
             t12_bas_sls_am,
             t12_eff_rent_pc,
             t12_serv_fee_pc
      FROM fin_v1rstprf
       WHERE reg_cd = :GLOBAL.reg_cd
        AND prft_perd_end_dt = pl_date_in;

   siteprof_rec siteprof_cur%ROWTYPE;

   CURSOR provrd_cur
      (reg_cd_in IN fin_v1provrd.reg_cd%TYPE,
       prft_date_in IN fin_v1provrd.prft_perd_end_dt%TYPE,
       prft_seq_in IN fin_v1provrd.prft_ovrd_seq_nu%TYPE)
   IS
      SELECT prft_t12_bas_am,
             t12_bas_sls_am,
             t12_eff_rent_pc,
             t12_serv_fee_pc
      FROM fin_v1rstprf
       WHERE reg_cd = :GLOBAL.reg_cd
        AND prft_perd_end_dt = prft_date_in
        AND prft_ovrd_seq_nu = prft_seq_in;

   CURSOR ovrd_left_cur
   IS
      SELECT reg_cd, prft_perd_end_dt, pl_ovrd_seq_nu
       FROM fin_v1plovrd
      MINUS
     SELECT reg_cd, pjtn_site_pl_date, pl_ovrd_seq_nu
       FROM fin_v1prjsim;

   TYPE key_rectype IS RECORD
      (reg_cd fin_v1prjsim.reg_cd%TYPE,
      pl_date fin_v1prjsim.pjtn_site_pl_dt%TYPE,
      pl_seq_nu fin_v1prjsim.pl_ovrd_seq_nu%TYPE,
      prft_date fin_v1prjsim.pjtn_site_prft_dt%TYPE,
      prft_seq_nu fin_v1prjsim.prft_ovrd_seq_nu%TYPE);
   
   TYPE li_rectype IS RECORD
      (prft_t12_bas_am fin_v1rstprf.prft_t12_bas_am%TYPE,
       t12_bas_sls_am fin_v1rstprf.t12_bas_sls_am%TYPE,
       t12_eff_rent_pc fin_v1rstprf.t12_eff_rent_pc%TYPE,
       t12_serv_fee_pc fin_v1rstprf.t12_serv_fee_pc%TYPE,
      pl_date fin_v1prjsim.pjtn_site_pl_dt%TYPE,
      pl_seq_nu fin_v1prjsim.pl_ovrd_seq_nu%TYPE);
   li_rec li_rectype%ROWTYPE;

   PROCEDURE get_site_prof_data
      (imp_rec_in IN imp_cur%ROWTYPE,
       li_rec_out OUT li_rectype)
   IS
   BEGIN
      OPEN siteprof_cur
         (:GLOBAL.reg_cd,
          imp_rec_in.pl_date);  -- ? Use pl or prft date? 

     FETCH siteprof_cur INTO siteprof_rec;

     IF siteprof_cur%NOTFOUND
     THEN
        RAISE site_prof_data_missing;
     ELSE
        li_rec_out.t12_bas_sls_am := siteprof_cur.t12_bas_sls_am;
        li_rec_out.prft_t12_bas_am := siteprof_cur.prft_t12_bas_am;
       li_rec_out.t12_serv_fee_pc := siteprof_cur.t12_serv_fee_pc;
       li_rec_out.t12_eff_rent_pc := siteprof_cur.t12_eff_rent_pc;
       li_rec_out.reg_cd = :GLOBAL.reg_cd;
       li_rec_out.pl_date := siteprof_rec.prft_perd_end_dt;
       li_rec_out.pl_seq_nu := imp_rec_in.pl_ovrd_seq_nu;
     END IF;

      CLOSE siteprof_cur;
   END;

   PROCEDURE get_pl_override_data
      (imp_rec_in IN imp_cur%ROWTYPE,
       li_rec_out OUT li_rectype)
   IS
   BEGIN
      OPEN provrd_cur
         (:GLOBAL.reg_cd,
          imp_rec_in.pl_date, -- ? Use pl or prft date?
          imp_rec_in.pl_seq_nu);  -- ? Use pl or prft seq?

     FETCH provrd_cur INTO provrd_rec;

     IF provrd_cur%NOTFOUND
     THEN
        RAISE provrd_data_missing;
     ELSE
        li_rec_out.t12_bas_sls_am := provrd_cur.t12_bas_sls_am;
        li_rec_out.prft_t12_bas_am := provrd_cur.prft_t12_bas_am;
       li_rec_out.t12_serv_fee_pc := provrd_cur.t12_serv_fee_pc;
       li_rec_out.t12_eff_rent_pc := provrd_cur.t12_eff_rent_pc;
       li_rec_out.reg_cd = :GLOBAL.reg_cd;
       li_rec_out.pl_date := imp_rec_in.pl_date;
       li_rec_out.pl_seq_nu := imp_rec_in.pl_ovrd_seq_nu;
     END IF;

      CLOSE provrd_cur;
   END;

   PROCEDURE insert_line_001 (li_rec_in IN li_rectype)
   IS
   BEGIN
      INSERT INTO fin_v1plovli
        (reg_cd, prft_perd_end_dt, pl_ovrd_seq_nu,
        pl_ln_itm_cd, t12_ln_itm_am, t12_ln_itm_sls_pc)
      VALUES
        (li_rec_in.reg_cd,
        li_rec_in.pl_date, 
        li_rec_in.pl_seq_nu,
        '001', 
        li_rec_in.t12_bas_sls_am,
        100);
   END;

   PROCEDURE insert_line_062 (li_rec_in IN li_rectype)
   IS
   BEGIN
      INSERT INTO fin_v1plovli
        (reg_cd, prft_perd_end_dt, pl_ovrd_seq_nu,
        pl_ln_itm_cd, t12_ln_itm_am, t12_ln_itm_sls_pc)
      VALUES
        (li_rec_in.reg_cd,
        li_rec_in.pl_date, 
        li_rec_in.pl_seq_nu,
        '062', 
        li_rec_in.t12_bas_sls_am);
        li_rec_in.prft_t12_sls_am *
           (li_rec_in.t12_eff_rent_pc + li_rec_in.t12_serv_fee_pc));
   END;

   FUNCTION duplicate_pl_site (imp_rec_in IN imp_cur%ROWTYPE)
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN 
        (:GLOBAL.reg_cd = prev_imp_rec.reg_cd AND
        (imp_rec_in.pl_ovrd_seq_nu = prev_imp_rec.pl_ovrd_seq_nu AND
        (imp_rec_in.pjtn_site_pl_dt = prev_imp_rec.pjtn_site_pl_dt);
   END;
        
   PROCEDURE create_new_override
      (imp_rec_in IN imp_cur%ROWTYPE,
      li_rec_in IN li_rectype%ROWTYPE,
       seq_nu_out OUT fin_v1plovrd.pl_ovrd_seq_nu%TYPE)
   IS
    v_li_rec li_rectype%ROWTYPE := li_rec_in;
   BEGIN
      /* Create a header record and line items for new override. */
     SELECT MAX (pl_ovrd_seq_nu) + 1
       INTO v_li_rec.pl_seq_nu
       FROM fin_v1plovrd
      WHERE reg_cd = :GLOBAL.reg_cd
        AND prft_perd_end_dt = imp_rec_in.pjtn_site_prft_dt; -- pl dt?

      INSERT INTO fin_v1plovrd
        SELECT reg_cd, prft_perd_end_dt, v_li_rec.pl_seq_nu,
              pl_ovrd_ds || ' (copy-seq' || TO_CHAR (v_li_rec.pl_seq_nu), 
              updt_ts, user_id_cd
         FROM fin_v1plovrd
          WHERE reg_cd = :GLOBAL.reg_cd
           AND prft_perd_end_dt = imp_rec_in.pjtn_site_prft_dt -- ?pl dt?
         AND pl_ovrd_seq_nu = v_li_rec.pl_seq_nu - 1; -- ? which seq?

     INSERT INTO fin_v1plovli
        SELECT reg_cd, prft_perd_end_dt, v_li_rec.pl_seq_nu,
              pl_ln_itm_cd, t12_ln_itm_am, t12_ln_itm_sls_pc
         FROM fin_v1plovli
          WHERE reg_cd = :GLOBAL.reg_cd
           AND prft_perd_end_dt = imp_rec_in.pjtn_site_prft_dt -- ?pl dt?
         AND pl_ovrd_seq_nu = v_li_rec.pl_seq_nu - 1; -- ? which seq?

     DELETE FROM scenario
      WHERE scenario_id = scenario_in
        AND reg_cd = :GLOBAL.reg_cd;

     insert_line_001 (v_li_rec);
     insert_line_062 (v_li_rec);

     seq_nu_out := v_li_rec.pl_seq_nu;

   END;

BEGIN /* Main */

   IF :GLOBAL.reg_cd = '0'
   THEN
     OPEN siteprof_cur
         (ovrd_rec_in.reg_cd,
          ovrd_rec_in.prft_perd_end_dt); 

     FETCH siteprof_cur INTO siteprof_rec;

     IF siteprof_cur%NOTFOUND
     THEN
        RAISE site_prof_data_missing;
     ELSE
        li_rec.t12_bas_sls_am := siteprof_cur.t12_bas_sls_am;
        li_rec.prft_t12_bas_am := siteprof_cur.prft_t12_bas_am;
        li_rec.t12_serv_fee_pc := siteprof_cur.t12_serv_fee_pc;
        li_rec.t12_eff_rent_pc := siteprof_cur.t12_eff_rent_pc;
        li_rec.reg_cd = :GLOBAL.reg_cd;
        li_rec.pl_date := siteprof_rec.prft_perd_end_dt;
        li_rec.pl_seq_nu := ovrd_rec_in.pl_ovrd_seq_nu;

         insert_line_001 (li_rec);
         insert_line_062 (li_rec);
      END IF;

      CLOSE siteprof_cur;
   END IF;

   FOR imp_rec IN imp_cur
   LOOP
      IF NVL (imp_rec.prft_ovrd_seq_nu, 0) = 0
     THEN
        get_site_prof_data (imp_rec, li_rec);
     ELSE
        get_pl_override_data (imp_rec, li_rec);
     END IF;

      insert_line_001 (li_rec);
      insert_line_062 (li_rec);

      IF duplicate_pl_site (imp_rec)
     THEN
        create_new_override (imp_rec, li_rec, new_pl_seq_nu);

       UPDATE fin_v1prjsim
          SET pl_ovrd_seq_nu = new_pl_seq_nu
          WHERE reg_cd = :GLOBAL.reg_cd
            AND pjtn_site_pl_date = imp_rec_in.pjtn_site_pl_date
            AND pl_ovrd_seq_nu = imp_rec_in.pl_ovrd_seq_nu
            AND pjtn_site_prft_dt = imp_rec_in.pjtn_site_prft_dt
            AND prft_ovrd_seq_nu = imp_rec_in.prft_ovrd_seq_nu;
     ELSE
        prev_imp_rec := imp_rec;
     END IF;

   END LOOP;

   FOR ovrd_left_rec IN ovrd_left_cur
   LOOP
      update_line_items (ovrd_left_rec);
   END LOOP;

END convert_overrides;
/