with cs_ui as
  (select cs_item_sk
         ,sum(cs_ext_list_price) as sale,sum(cr_refunded_cash+cr_reversed_charge+cr_store_credit) as refund
   from catalog_sales
       ,catalog_returns
   where cs_item_sk = cr_item_sk
     and cs_order_number = cr_order_number
   group by cs_item_sk
   having sum(cs_ext_list_price)>2*sum(cr_refunded_cash+cr_reversed_charge+cr_store_credit)),
 cross_sales as
  (select i_product_name product_name, i_item_sk item_sk, s_store_name store_name, s_zip store_zip,
          ad1.ca_street_number b_street_number, ad1.ca_street_name b_streen_name, ad1.ca_city b_city,
          ad1.ca_zip b_zip, ad2.ca_street_number c_street_number, ad2.ca_street_name c_street_name,
          ad2.ca_city c_city, ad2.ca_zip c_zip, d1.d_year as syear, d2.d_year as fsyear, d3.d_year s2year,
          count(*) cnt, sum(ss_wholesale_cost) s1, sum(ss_list_price) s2, sum(ss_coupon_amt) s3
   FROM store_sales, store_returns, cs_ui, date_dim d1, date_dim d2, date_dim d3,
        store, customer, customer_demographics cd1, customer_demographics cd2,
        promotion, household_demographics hd1, household_demographics hd2,
        customer_address ad1, customer_address ad2, income_band ib1, income_band ib2, item
   WHERE  ss_store_sk = s_store_sk AND
          ss_sold_date_sk = d1.d_date_sk AND
          ss_customer_sk = c_customer_sk AND
          ss_cdemo_sk= cd1.cd_demo_sk AND
          ss_hdemo_sk = hd1.hd_demo_sk AND
          ss_addr_sk = ad1.ca_address_sk and
          ss_item_sk = i_item_sk and
          ss_item_sk = sr_item_sk and
          ss_ticket_number = sr_ticket_number and
          ss_item_sk = cs_ui.cs_item_sk and
          c_current_cdemo_sk = cd2.cd_demo_sk AND
          c_current_hdemo_sk = hd2.hd_demo_sk AND
          c_current_addr_sk = ad2.ca_address_sk and
          c_first_sales_date_sk = d2.d_date_sk and
          c_first_shipto_date_sk = d3.d_date_sk and
          ss_promo_sk = p_promo_sk and
          hd1.hd_income_band_sk = ib1.ib_income_band_sk and
          hd2.hd_income_band_sk = ib2.ib_income_band_sk and
          cd1.cd_marital_status <> cd2.cd_marital_status and
          i_color in ('purple','burlywood','indian','spring','floral','medium') and
          i_current_price between 64 and 64 + 10 and
          i_current_price between 64 + 1 and 64 + 15
 group by i_product_name, i_item_sk, s_store_name, s_zip, ad1.ca_street_number,
          ad1.ca_street_name, ad1.ca_city, ad1.ca_zip, ad2.ca_street_number,
          ad2.ca_street_name, ad2.ca_city, ad2.ca_zip, d1.d_year, d2.d_year, d3.d_year
 )
 select cs1.product_name "_col_1", cs1.store_name "_col_2", cs1.store_zip "_col_3", cs1.b_street_number "_col_4",
        cs1.b_streen_name "_col_5", cs1.b_city "_col_6", cs1.b_zip "_col_7", cs1.c_street_number "_col_8", cs1.c_street_name "_col_9",
        cs1.c_city "_col_10", cs1.c_zip "_col_11", cs1.syear "_col_12", cs1.cnt "_col_13", cs1.s1 "_col_14", cs1.s2 "_col_15", cs1.s3 "_col_16", cs2.s1 "_col_17",
        cs2.s2 "_col_18", cs2.s3 "_col_19", cs2.syear "_col_20", cs2.cnt "_col_21"
 from cross_sales cs1,cross_sales cs2
 where cs1.item_sk=cs2.item_sk and
      cs1.syear = 1999 and
      cs2.syear = 1999 + 1 and
      cs2.cnt <= cs1.cnt and
      cs1.store_name = cs2.store_name and
      cs1.store_zip = cs2.store_zip
 order by cs1.product_name, cs1.store_name, cs2.cnt

