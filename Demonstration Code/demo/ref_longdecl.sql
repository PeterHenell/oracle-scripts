Step 1 Reduce excessively long declaration sections. (PL/SQL refactoring)

Step 1 in the refactoring of topic "Reduce excessively long declaration section
ns." Look for groups of related elements. Can you move them into records or obj
ject types or collections? Are there patterns in the naming of variables that m
might suggest the use of dynamic SQL or reusable code to avoid the repetition?

Once you have identified some changes you think you can make, start analyzing t
the body of code. What would be the impact of your change? When you are comfort
table with the impact, make your change - but do so one at a time, and then com
mpile. Don't make too many changes at once. 

In this step, we replace many of the declarations with records, and then update
e the body of code. 

Universal ID = {4294B5E6-7766-409A-B5DF-922B449F66AC}

CREATE OR REPLACE PROCEDURE review_account (id_in IN INTEGER)
IS
   l_account       sg_account%ROWTYPE;      
   l_application   SA_APPLICATION%ROWTYPE;
   
   v_item_template_1       INTEGER                                   := 600;
   v_item_template_2       INTEGER                                   := 433;
   v_item_template_3       INTEGER                                   := 434;
   v_item_template_4       NUMBER                                    := 1016;
 
   TYPE item_tt IS TABLE OF INTEGER
      INDEX BY BINARY_INTEGER;
 
   l_item_list             item_tt;
 
   TYPE list_tabtype IS TABLE OF VARCHAR2 (2000)
      INDEX BY BINARY_INTEGER;
 
   names                   list_tabtype;
   v_name                  VARCHAR2 (2000)
                            := accounts_rp.min_balance_account_name (SYSDATE);
   v_first_name            VARCHAR2 (2000);
   no_application_needed   EXCEPTION;
BEGIN
   IF account_rp.balance_too_low (id_in)
   THEN
      v_first_name := v_name;
 
      /* Fill up the table and use it. */
      LOOP
         EXIT WHEN v_name IS NULL;
         names (NVL (names.LAST, 0) + 1) := v_name;
      END LOOP;
 
      process_names (names);
   ELSE
      l_account.name := accounts_qp.name_for_id (id_in);
      l_account.description := accounts_qp.description_for_id (id_in);
      initialize_application (id_in, l_application.id);
 
      IF l_application.id IS NOT NULL
      THEN
         l_application.name := 'TO BE SET';
      ELSE
         RAISE no_application_needed;
      END IF;
 
      get_outstanding_items (id_in, l_app_id, l_item_list);
 
      FOR indx IN 1 .. l_item_list.COUNT
      LOOP
         IF indx = 1
         THEN
            IF v_item_template_2 = l_item_list (indx).item#
            THEN
               process_as_template1 (l_item_list (indx));
            ELSE
               process_new (l_item_list (indx));
            END IF;
         ELSIF indx = 2
         THEN
            IF v_item_template_2 = l_item_list (indx).item#
            THEN
               process_as_template2 (l_item_list (indx));
            ELSE
               process_new (l_item_list (indx));
            END IF;
         ELSIF indx = 3
         THEN
            IF v_item_template_3 = l_item_list (indx).item#
            THEN
               process_as_template3 (l_item_list (indx));
            ELSE
               process_new (l_item_list (indx));
            END IF;
         ELSIF indx = 4
         THEN
            IF v_item_template_4 = l_item_list (indx).item#
            THEN
               process_as_template4 (l_item_list (indx));
            ELSE
               process_new (l_item_list (indx));
            END IF;
         END IF;
      END LOOP;
 
      process_items;
   END IF;
EXCEPTION
   WHEN no_application_needed
   THEN
      -- Bunch more logic here....
      process_without_app (id_in);
END;
================================================================================
Step 2 Reduce excessively long declaration sections. (PL/SQL refactoring)

Step 2 in the refactoring of topic "Reduce excessively long declaration section
ns."

Look for variables that are declared at the top level, but are perhaps only use
ed in a particular section of code and under limited circumstances. In this cas
se, you can move that logic into its own local module, and move the declaration
ns it requires into that same module. This way, the memory and CPU needed to in
nitialize them will only be used when the program is run -- and the declaration
n section gets smaller and more manageable.

Universal ID = {BE4CBDE4-1B34-4F00-AFAF-5EA1ADDD012E}

CREATE OR REPLACE PROCEDURE review_account (id_in IN INTEGER)
IS
   l_account       sg_account%ROWTYPE;        
   l_application   SA_APPLICATION%ROWTYPE;
   v_item_template_1       INTEGER                                   := 600;
   v_item_template_2       INTEGER                                   := 433;
   v_item_template_3       INTEGER                                   := 434;
   v_item_template_4       NUMBER                                    := 1016;
 
   TYPE item_tt IS TABLE OF INTEGER
      INDEX BY BINARY_INTEGER;
 
   l_item_list             item_tt;
 
   PROCEDURE handle_too_low_scenario
   IS
      TYPE list_tabtype IS TABLE OF VARCHAR2 (2000)
         INDEX BY BINARY_INTEGER;
 
      names          list_tabtype;
      v_name         VARCHAR2 (2000) := min_balance_account (SYSDATE);
      v_first_name   VARCHAR2 (2000);
   BEGIN
      v_first_name := v_name;
 
      /* Fill up the table and use it. */
      LOOP
         EXIT WHEN v_name IS NULL;
         names (NVL (names.LAST, 0) + 1) := v_name;
      END LOOP;
 
      process_names (names);
   END handle_too_low_scenario;
BEGIN
   IF account_rp.balance_too_low (id_in)
   THEN
      handle_too_low_scenario;
   ELSE
      l_account.name := accounts_qp.name_for_id (id_in);
      l_account.description := accounts_qp.description_for_id (id_in);
      initialize_application (id_in, l_application.id);
 
      IF l_application.id IS NOT NULL
      THEN
         l_application.name := 'TO BE SET';
      ELSE
         RAISE no_application_needed;
      END IF;
 
      get_outstanding_items (id_in, l_application.id, l_item_list);
 
      FOR indx IN 1 .. l_item_list.COUNT
      LOOP
         IF indx = 1
         THEN
            IF v_item_template_2 = l_item_list (indx).item#
            THEN
               process_as_template1 (l_item_list (indx));
            ELSE
               process_new (l_item_list (indx));
            END IF;
         ELSIF indx = 2
         THEN
            IF v_item_template_2 = l_item_list (indx).item#
            THEN
               process_as_template2 (l_item_list (indx));
            ELSE
               process_new (l_item_list (indx));
            END IF;
         ELSIF indx = 3
         THEN
            IF v_item_template_3 = l_item_list (indx).item#
            THEN
               process_as_template3 (l_item_list (indx));
            ELSE
               process_new (l_item_list (indx));
            END IF;
         ELSIF indx = 4
         THEN
            IF v_item_template_4 = l_item_list (indx).item#
            THEN
               process_as_template4 (l_item_list (indx));
            ELSE
               process_new (l_item_list (indx));
            END IF;
         END IF;
      END LOOP;
 
      process_items;
   END IF;
EXCEPTION
   WHEN no_application_needed
   THEN
      -- Bunch more logic here....
      process_without_app (id_in);
END;
================================================================================
Step 0: Problematic code for  Reduce excessively long declaration sections. (PL/SQL refactoring) 

The problematic code for that demonstrates "Reduce excessively long declaration
n sections. (PL/SQL refactoring)"

Universal ID = {A05A93AC-73CA-4FBA-845B-3BF84C603552}

CREATE OR REPLACE PROCEDURE review_account (id_in IN INTEGER)
IS
   l_id                    sg_account.ID%TYPE;
   l_acc_name              sg_account.NAME%TYPE;
   l_description           sg_account.description%TYPE;
   l_driver_type_id        sg_account.driver_type_id%TYPE;
   l_engine_type_id        sg_account.engine_type_id%TYPE;
   l_output_type_id        sg_account.output_type_id%TYPE;
   l_is_static             sg_account.is_static%TYPE;
   l_sa_object_type_id     sg_account.sa_object_type_id%TYPE;
   l_author                sg_account.author%TYPE;
   l_column_position       sg_account.column_position%TYPE;
   l_output_prefix         sg_account.output_prefix%TYPE;
   l_output_suffix         sg_account.output_suffix%TYPE;
   l_file_extension        sg_account.file_extension%TYPE;
   l_source_file_name      sg_account.source_file_name%TYPE;
   l_created_on            sg_account.created_on%TYPE;
   l_created_by            sg_account.created_by%TYPE;
   l_changed_on            sg_account.changed_on%TYPE;
   l_changed_by            sg_account.changed_by%TYPE;
   l_in_context_name       sg_account.in_context_name%TYPE;
   l_is_locked             sg_account.is_locked%TYPE;
   l_locked_by             sg_account.locked_by%TYPE;
   l_locked_password       sg_account.locked_password%TYPE;
   l_universal_id          sg_account.universal_id%TYPE;
   l_is_top_level          sg_account.is_top_level%TYPE;
   l_app_id                SA_APPLICATION.ID%TYPE;
   l_app_name              SA_APPLICATION.NAME%TYPE;
   l_app_description       SA_APPLICATION.description%TYPE;
   l_refresh_frequency     SA_APPLICATION.refresh_frequency%TYPE;
   l_def_roadmap_dir       SA_APPLICATION.def_roadmap_dir%TYPE;
   l_def_script_dir        SA_APPLICATION.def_script_dir%TYPE;
   l_def_code_dir          SA_APPLICATION.def_code_dir%TYPE;
   l_def_sequence_prefix   SA_APPLICATION.def_sequence_prefix%TYPE;
   l_def_sequence_suffix   SA_APPLICATION.def_sequence_suffix%TYPE;
   l_def_pky_column_name   SA_APPLICATION.def_pky_column_name%TYPE;
   l_rae_error_code        SA_APPLICATION.rae_error_code%TYPE;
   l_deploy_dir            SA_APPLICATION.deploy_dir%TYPE;
   l_use_qda               SA_APPLICATION.use_qda%TYPE;
   v_item_template_1       INTEGER                                   := 600;
   v_item_template_2       INTEGER                                   := 433;
   v_item_template_3       INTEGER                                   := 434;
   v_item_template_4       NUMBER                                    := 1016;
 
   TYPE item_tt IS TABLE OF INTEGER
      INDEX BY BINARY_INTEGER;
 
   l_item_list             item_tt;
 
   TYPE list_tabtype IS TABLE OF VARCHAR2 (2000)
      INDEX BY BINARY_INTEGER;
 
   names                   list_tabtype;
   v_name                  VARCHAR2 (2000)
                            := accounts_rp.min_balance_account_name (SYSDATE);
   v_first_name            VARCHAR2 (2000);
   no_application_needed   EXCEPTION;
BEGIN
   IF account_rp.balance_too_low (id_in)
   THEN
      v_first_name := v_name;
 
      /* Fill up the table and use it. */
      LOOP
         EXIT WHEN v_name IS NULL;
         names (NVL (names.LAST, 0) + 1) := v_name;
      END LOOP;
 
      process_names (names);
   ELSE
      l_acc_name := accounts_qp.name_for_id (id_in);
      l_acc_description := accounts_qp.description_for_id (id_in);
      initialize_application (id_in, l_app_id);
 
      IF l_app_id IS NOT NULL
      THEN
         l_app_name := 'TO BE SET';
      ELSE
         RAISE no_application_needed;
      END IF;
 
      get_outstanding_items (id_in, l_app_id, l_item_list);
 
      FOR indx IN 1 .. l_item_list.COUNT
      LOOP
         IF indx = 1
         THEN
            IF v_item_template_2 = l_item_list (indx).item#
            THEN
               process_as_template1 (l_item_list (indx));
            ELSE
               process_new (l_item_list (indx));
            END IF;
         ELSIF indx = 2
         THEN
            IF v_item_template_2 = l_item_list (indx).item#
            THEN
               process_as_template2 (l_item_list (indx));
            ELSE
               process_new (l_item_list (indx));
            END IF;  
         ELSIF indx = 3
         THEN
            IF v_item_template_3 = l_item_list (indx).item#
            THEN
               process_as_template3 (l_item_list (indx));
            ELSE
               process_new (l_item_list (indx));
            END IF;
         ELSIF indx = 4
         THEN
            IF v_item_template_4 = l_item_list (indx).item#
            THEN
               process_as_template4 (l_item_list (indx));
            ELSE
               process_new (l_item_list (indx));
            END IF;
         END IF;
      END LOOP;
 
      process_items;
   END IF;
EXCEPTION
   WHEN no_application_needed
   THEN
      -- Bunch more logic here....
      process_without_app (id_in);
END;
================================================================================
Step 3 Reduce excessively long declaration sections. (PL/SQL refactoring)

Step 23 in the refactoring of topic "Reduce excessively long declaration sectio
ons."

Review declarations section, look for substantial chunks of related declaration
ns. Examine the code in the body to see how they are used: spread out all over 
 the program? Isolated to one section? Is there too much detail exposed in this
s program? Should it all be off-loaded to another program?

In this example, I grow weary just looking at all the complicated logic related
d to items. My feeling is that there should almost certainly be a separate pack
kage for item-related activity. Let's assume that and make the changes in this 
 prorgram.

While I am at it, I am also going to restructure a bit get rid of that dangling
g exception section, which contained business logic. This is generally a bad id
dea. See "Avoid placing business logic in exception sections. (PL/SQL refactori
ing)"

Universal ID = {F89D7C17-9392-41E9-9921-D8A9F34FE4EB}

CREATE OR REPLACE PROCEDURE review_account (id_in IN INTEGER)
IS
   l_account       sg_account%ROWTYPE;
   l_application   SA_APPLICATION%ROWTYPE;  
   l_item_list  item_mgt_pkg.item_list_tt;
 
   PROCEDURE handle_too_low_scenario
   IS
      TYPE list_tabtype IS TABLE OF VARCHAR2 (2000)
         INDEX BY BINARY_INTEGER;
 
      names          list_tabtype;
      v_name         VARCHAR2 (2000) := min_balance_account (SYSDATE);
      v_first_name   VARCHAR2 (2000);
   BEGIN
      v_first_name := v_name;
 
      /* Fill up the table and use it. */
      LOOP
         EXIT WHEN v_name IS NULL;
         names (NVL (names.LAST, 0) + 1) := v_name;
      END LOOP;
 
      process_names (names);
   END handle_too_low_scenario;
BEGIN
   IF account_rp.balance_too_low (id_in)
   THEN
      handle_too_low_scenario;
   ELSE
      l_account.name := accounts_qp.name_for_id (id_in);
      l_account.description := accounts_qp.description_for_id (id_in);
      initialize_application (id_in, l_application.id);
 
      IF l_application.id IS NOT NULL
      THEN
         l_application.name := 'TO BE SET';
 
         item_mgt_pkg.get_items (id_in, l_application.id, l_item_list);
         item_mgt_pkg.process_items (l_item_list); 
      END IF;
   END IF;
END;
================================================================================
