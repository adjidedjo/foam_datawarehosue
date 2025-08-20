class ChannelSales < ActiveRecord::Base
  self.table_name = "sales_warehouses"
  include ParamdatesConcern
  def self.total_revenue_channel_foam(date, channel)
    self.find_by_sql("SELECT lc.area_id, lc.area_desc, lc.monthnow, lc.month1, lc.kubikasinow, lc.kubikasi1,
      ROUND((((lc.monthnow - lc.month1) / lc.month1) * 100), 0) AS percentage FROM
      (
        SELECT 'total', area_id, area_desc,
        SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) month1,
        SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN kubikasi END) kubikasi1,
        SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) monthnow,
        SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN kubikasi END) kubikasinow
        FROM foam_datawarehouse.foam_bybrands WHERE tanggalsj BETWEEN '#{last_month_date(date)}'
        AND '#{this_month_date(date)}' AND channel = '#{channel}' GROUP BY area_id
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

  def self.foam_channel_this_month_total(date, channel)
    self.find_by_sql("SELECT lc.val_1, lc.val_2, lc.brand, lc.kubikasi1, lc.kubikasi2,
      ROUND((((lc.val_1 - lc.val_2) / lc.val_2) * 100), 0) AS percentage FROM
      (
        SELECT area_desc AS areas, brand AS brand,
          SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) val_2,
          SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN kubikasi END) kubikasi2,
          SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) val_1,
          SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN kubikasi END) kubikasi1
          FROM foam_bybrands WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}'
          AND channel = '#{channel}' GROUP BY brand
      ) AS lc
    ")
  end

  def self.recap_bysubbrand_channel(date, channel)
    find_by_sql("SELECT rb.subbrand, rb.month1, rb.monthnow, rb.kubikasi1, rb.kubikasinow,
      ROUND((((rb.monthnow - rb.month1) / rb.month1) * 100), 0) AS percentage FROM
      ( SELECT subbrand,
        SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) month1,
        SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN kubikasi END) kubikasi1,
        SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) monthnow,
        SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN kubikasi END) kubikasinow
        FROM foam_datawarehouse.foam_bysubbrands WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}'
        AND channel = '#{channel}' GROUP BY subbrand
      ) AS rb
    ")
  end

  def self.quality_channel_monthly(date, channel)
    find_by_sql("SELECT densityid, densitydesc, area_desc, subbrand, channel,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales END) month2,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN kubikasi END) kubikasi2,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) month1,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN kubikasi END) kubikasi1,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) monthnow,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN kubikasi END) kubikasinow
      FROM foam_datawarehouse.foam_byquality WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}'
      AND channel = '#{channel}' GROUP BY densityid, area_id, subbrand
    ")
  end

  def self.customer_channel_monthly(date, channel)
    find_by_sql("SELECT channel, customer_id, customer_desc, salesman, kota,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales END) month2,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales_usd END) month2_usd,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN kubikasi END) kubikasi2,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) month1,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales_usd END) month1_usd,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN kubikasi END) kubikasi1,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) monthnow,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales_usd END) monthnow_usd,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN kubikasi END) kubikasinow
      FROM foam_datawarehouse.foam_bycusbrands WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}'
      AND channel = '#{channel}' GROUP BY customer_id
    ")
  end

  def self.customer_channel_subbrand_monthly(date, channel)
    find_by_sql("SELECT channel, customer_id, customer_desc, salesman, subbrand,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales END) month2,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales_usd END) month2_usd,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales_usd END) kubikasi2,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) month1,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales_usd END) month1_usd,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales_usd END) kubikasi1,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) monthnow,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales_usd END) monthnow_usd,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales_usd END) kubikasinow
      FROM foam_datawarehouse.foam_bycusbrands WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}'
      AND channel = '#{channel}' GROUP BY customer_id, subbrand
    ")
  end
end