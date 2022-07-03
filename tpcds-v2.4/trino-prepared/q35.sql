select
  ca_state "_col_1",
  cd_gender "_col_2",
  cd_marital_status "_col_3",
  cd_dep_count "_col_4",
  count(*) "_col_5",
  min(cd_dep_count) "_col_6",
  max(cd_dep_count) "_col_7",
  avg(cd_dep_count) "_col_8",
  cd_dep_employed_count "_col_9",
  count(*) "_col_10",
  min(cd_dep_employed_count) "_col_11",
  max(cd_dep_employed_count) "_col_12",
  avg(cd_dep_employed_count) "_col_13",
  cd_dep_college_count "_col_14",
  count(*) "_col_15",
  min(cd_dep_college_count) "_col_16",
  max(cd_dep_college_count) "_col_17",
  avg(cd_dep_college_count) "_col_18"
 from
  customer c,customer_address ca,customer_demographics
 where
  c.c_current_addr_sk = ca.ca_address_sk and
  cd_demo_sk = c.c_current_cdemo_sk and
  exists (select * from store_sales, date_dim
          where c.c_customer_sk = ss_customer_sk and
                ss_sold_date_sk = d_date_sk and
                d_year = 2002 and
                d_qoy < 4) and
   (exists (select * from web_sales, date_dim
            where c.c_customer_sk = ws_bill_customer_sk and
                  ws_sold_date_sk = d_date_sk and
                  d_year = 2002 and
                  d_qoy < 4) or
    exists (select * from catalog_sales, date_dim
            where c.c_customer_sk = cs_ship_customer_sk and
                  cs_sold_date_sk = d_date_sk and
                  d_year = 2002 and
                  d_qoy < 4))
 group by ca_state, cd_gender, cd_marital_status, cd_dep_count,
          cd_dep_employed_count, cd_dep_college_count
 order by ca_state, cd_gender, cd_marital_status, cd_dep_count,
          cd_dep_employed_count, cd_dep_college_count
 limit 100

