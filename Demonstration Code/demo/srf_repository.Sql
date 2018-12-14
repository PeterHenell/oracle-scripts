DROP TABLE srf_col_repository;
DROP TABLE srf_tab_repository;
DROP TABLE srf_repository;

CREATE TABLE srf_repository (
   query_mechanism CHAR(1), -- E - explicit, I - implicit
   cache_data CHAR(1),      -- Y = cache, N = no caching
   nrf_value VARCHAR2(100),
   too_many_rows_code VARCHAR2(2000),
   when_others_code VARCHAR2(2000));
   
CREATE TABLE srf_tab_repository (
   owner VARCHAR2(30),
   table_name VARCHAR2(30),
   query_mechanism CHAR(1), -- E - explicit, I - implicit
   cache_data CHAR(1),      -- Y = cache, N = no caching
   nrf_value VARCHAR2(100),
   too_many_rows_code VARCHAR2(2000),
   when_others_code VARCHAR2(2000));

ALTER table srf_tab_repository add CONSTRAINT srf_tab_repository_pk
   primary KEY (owner, table_name);  

CREATE TABLE srf_col_repository (
   owner VARCHAR2(30),
   table_name VARCHAR2(30),
   column_name VARCHAR2(30),     -- or name for expression
   column_list VARCHAR2(2000),   -- NOT USED if > 1 involved
   code VARCHAR2(2000),          -- Code used to return value
   data_type VARCHAR2(30),       -- If computed, use this for a subtype
   nrf_value VARCHAR2(100));
   
ALTER table srf_col_repository add (
  CONSTRAINT srf_col_repository_fk
   FOREIGN KEY (owner, table_name) 
   REFERENCES srf_tab_repository (owner, table_name) ON DELETE CASCADE);
      