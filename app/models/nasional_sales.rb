class NasionalSales < ActiveRecord::Base
  self.table_name = "sales_warehouses"
  def self.retail_nasional_this_month_total
    self.find_by_sql("SELECT lc.val_1, lc.val_2, lc.brand,
      ROUND((((lc.val_1 - lc.val_2) / lc.val_2) * 100), 0) AS percentage FROM
      (
        SELECT area_desc AS areas, brand AS brand,
          SUM(CASE WHEN dmonth IN ('9','10') THEN total_sales END) y_qty,
          SUM(CASE WHEN dmonth = '10' AND dyear = '2020' THEN total_sales END) qty_1,
          SUM(CASE WHEN dmonth = '10' AND dyear = '2020' THEN total_sales END) val_1,
          SUM(CASE WHEN dmonth = '10' AND dyear = '2020' THEN total_sales END) val1_1,
          SUM(CASE WHEN dmonth = '9' AND dyear = '2020' THEN total_sales END) val_2
          FROM foam_bybrands WHERE tanggalsj BETWEEN '2020-09-01' AND '2020-10-31' GROUP BY brand
      ) AS lc
    ")
  end

  def self.recap_bysubbrand
    find_by_sql("SELECT subbrand,
      SUM(CASE WHEN dmonth = '#{3.months.ago.month}' AND dyear = '#{3.months.ago.year}' THEN total_sales END) month3,
      SUM(CASE WHEN dmonth = '#{2.months.ago.month}' AND dyear = '#{2.months.ago.year}' THEN total_sales END) month2,
      SUM(CASE WHEN dmonth = '#{1.months.ago.month}' AND dyear = '#{1.months.ago.year}' THEN total_sales END) month1,
      SUM(CASE WHEN dmonth = '#{Date.today.month}' AND dyear = '#{Date.today.year}' THEN total_sales END) monthnow
      FROM foam_datawarehouse.foam_bysubbrands WHERE tanggalsj BETWEEN '#{3.months.ago.to_date}' AND '#{Date.today.to_date}'
      GROUP BY subbrand
    ")
  end

  def self.customer_monthly
    find_by_sql("SELECT customer_desc, salesman, kota,
      SUM(CASE WHEN dmonth = '#{3.months.ago.month}' AND dyear = '#{3.months.ago.year}' THEN total_sales END) month3,
      SUM(CASE WHEN dmonth = '#{2.months.ago.month}' AND dyear = '#{2.months.ago.year}' THEN total_sales END) month2,
      SUM(CASE WHEN dmonth = '#{1.months.ago.month}' AND dyear = '#{1.months.ago.year}' THEN total_sales END) month1,
      SUM(CASE WHEN dmonth = '#{Date.today.month}' AND dyear = '#{Date.today.year}' THEN total_sales END) monthnow
      FROM foam_datawarehouse.foam_bycusbrands WHERE tanggalsj BETWEEN '#{3.months.ago.to_date}' AND '#{Date.today.to_date}'
      GROUP BY customer_id
    ")
  end
end