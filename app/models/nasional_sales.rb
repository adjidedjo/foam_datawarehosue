class NasionalSales < ActiveRecord::Base
  self.table_name = "sales_warehouses"
  include ParamdatesConcern
  def self.total_revenue_foam(date)
    self.find_by_sql("SELECT lc.monthnow, lc.month1,
      ROUND((((lc.monthnow - lc.month1) / lc.month1) * 100), 0) AS percentage FROM
      (
        SELECT 'total',
        SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales END) month2,
        SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) month1,
        SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) monthnow
        FROM foam_datawarehouse.foam_bybrands WHERE tanggalsj BETWEEN '#{two_months_date(date)}'
        AND '#{this_month_date(date)}'
      ) AS lc
    ")
  end

  def self.foam_nasional_channel_total(date)
    self.find_by_sql("SELECT lc.val_1, lc.val_2, lc.channel,
      ROUND((((lc.val_1 - lc.val_2) / lc.val_2) * 100), 0) AS percentage FROM
      (
        SELECT area_desc AS areas, channel AS channel,
          SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) val_2,
          SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) val_1
          FROM foam_bychannel WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}'
          GROUP BY channel
      ) AS lc
    ")
  end

  def self.foam_nasional_this_month_total(date)
    self.find_by_sql("SELECT lc.val_1, lc.val_2, lc.brand,
      ROUND((((lc.val_1 - lc.val_2) / lc.val_2) * 100), 0) AS percentage FROM
      (
        SELECT area_desc AS areas, brand AS brand,
          SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) val_2,
          SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) val_1
          FROM foam_bybrands WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}' GROUP BY brand
      ) AS lc
    ")
  end

  def self.recap_bysubbrand(date)
    find_by_sql("SELECT subbrand,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales END) month2,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) month1,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) monthnow
      FROM foam_datawarehouse.foam_bysubbrands WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}'
      GROUP BY subbrand
    ")
  end

  def self.customer_monthly(date)
    find_by_sql("SELECT channel, customer_desc, salesman, kota,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales END) month2,
      SUM(CASE WHEN dmonth = '#{two_months_month(date)}' AND dyear = '#{two_months_year(date)}' THEN total_sales_usd END) month2_usd,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales END) month1,
      SUM(CASE WHEN dmonth = '#{last_month_month(date)}' AND dyear = '#{last_month_year(date)}' THEN total_sales_usd END) month1_usd,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales END) monthnow,
      SUM(CASE WHEN dmonth = '#{this_month_month(date)}' AND dyear = '#{this_month_year(date)}' THEN total_sales_usd END) monthnow_usd
      FROM foam_datawarehouse.foam_bycusbrands WHERE tanggalsj BETWEEN '#{two_months_date(date)}' AND '#{this_month_date(date)}'
      GROUP BY customer_id
    ")
  end
end