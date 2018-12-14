CURSOR csr_results (p_formula_id hxc_tcr_tbb_results_f.formula_id%TYPE)
       IS
          SELECT result_type (tbb_rslt.TYPE,
                              tbb_rslt.measure,
                              tbb_rslt.start_time,
                              tbb_rslt.stop_time,
                              CAST (MULTISET (SELECT attr_rslt.bld_blk_info_type,
                                                     attr_rslt.CATEGORY,
                                                     CAST (MULTISET (SELECT app_attr_rslt.attribute_name,
                                                                            app_attr_rslt.attribute_value,
                                                                            app_attr_rslt.attribute_result_name,
                                                                            app_attr_rslt.SEGMENT
                                                                       FROM hxc_tcr_app_attr_results_f app_attr_rslt
                                                                      WHERE app_attr_rslt.tcr_attr_result_id =
                                                                               attr_rslt.tcr_attr_result_id) AS app_attribute_type_table
                                                          )
                                                FROM hxc_tcr_attr_results_f attr_rslt
                                               WHERE tbb_rslt.tcr_tbb_result_id =
                                                        attr_rslt.tcr_tbb_result_id) AS attribute_type_table
                                   )
                             )
            FROM hxc_tcr_tbb_results_f tbb_rslt
           WHERE tbb_rslt.formula_id = p_formula_id;