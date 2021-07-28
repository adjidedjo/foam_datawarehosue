class WhsSale < ActiveRecord::Base
  self.table_name = "WHS1BRAND"
  include ParamdatesConcern
  def self.total_revenue_channel_whs(date, channel)
    self.find_by_sql("SELECT a.month1, a.monthnow, ROUND((((a.monthnow - a.month1) / a.month1) * 100), 0) AS percentage FROM
      (
        SELECT 'Total',
        SUM(CASE WHEN fiscal_month = '5' AND fiscal_year = '2021' THEN sales_amount END) month2,
        SUM(CASE WHEN fiscal_month = '6' AND fiscal_year = '2021' THEN sales_amount END) month1,
        SUM(CASE WHEN fiscal_month = '7' AND fiscal_year = '2021' THEN sales_amount END) monthnow
        FROM foam_datawarehouse.WHS1BRAND WHERE fiscal_month BETWEEN '5' AND '7' AND fiscal_year BETWEEN '2021' AND '2021'
       ) AS a
    ")
  end

  def self.whs_channel_this_month_total(date, channel)
    self.find_by_sql("SELECT lc.val_1, lc.val_2, lc.brand,
      ROUND((((lc.val_1 - lc.val_2) / lc.val_2) * 100), 0) AS percentage FROM
      (
        SELECT area_desc AS areas, brand AS brand,
        SUM(CASE WHEN fiscal_month = '5' AND fiscal_year = '2021' THEN sales_amount END) month2,
        SUM(CASE WHEN fiscal_month = '6' AND fiscal_year = '2021' THEN sales_amount END) month1,
        SUM(CASE WHEN fiscal_month = '7' AND fiscal_year = '2021' THEN sales_amount END) monthnow
        FROM foam_datawarehouse.WHS1BRAND WHERE fiscal_month BETWEEN '5' AND '7' AND fiscal_year BETWEEN '2021' AND '2021'
        GROUP BY brand
      ) AS lc
    ")
  end

  def self.foam_channel_total(date, channel)
    self.find_by_sql("SELECT lc.val_1, lc.val_2, lc.channel,
      ROUND((((lc.val_1 - lc.val_2) / lc.val_2) * 100), 0) AS percentage FROM
      (
        SELECT area_desc AS areas, channel AS channel,
          SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) val_2,
          SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) val_1
          FROM foam_bychannel WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}' AND
          channel = '#{channel}'
          GROUP BY channel
      ) AS lc
    ")
  end

  def self.recap_bysubbrand_channel(date, channel)
    find_by_sql("SELECT rb.subbrand, rb.month1, rb.monthnow,
      ROUND((((rb.monthnow - rb.month1) / rb.month1) * 100), 0) AS percentage FROM
      ( SELECT subbrand,
        SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) month1,
        SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) monthnow
        FROM foam_datawarehouse.foam_bysubbrands WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}'
        AND channel = '#{channel}' GROUP BY subbrand
      ) AS rb
    ")
  end

  def self.customer_channel_monthly(date, channel)
    find_by_sql("SELECT channel, customer_id, customer_desc, salesman, kota,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales END) month2,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales_usd END) month2_usd,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) month1,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales_usd END) month1_usd,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) monthnow,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales_usd END) monthnow_usd
      FROM foam_datawarehouse.foam_bycusbrands WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}'
      AND channel = '#{channel}' GROUP BY customer_id
    ")
  end

  def self.customer_channel_subbrand_monthly(date, channel)
    find_by_sql("SELECT channel, customer_id, customer_desc, salesman, subbrand,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales END) month2,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales_usd END) month2_usd,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) month1,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales_usd END) month1_usd,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) monthnow,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales_usd END) monthnow_usd
      FROM foam_datawarehouse.foam_bycusbrands WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}'
      AND channel = '#{channel}' GROUP BY customer_id, subbrand
    ")
  end
end