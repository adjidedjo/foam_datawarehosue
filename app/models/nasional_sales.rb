class NasionalSales < ActiveRecord::Base
  self.table_name = "sales_warehouses"
  def self.recap_bybrand
    find_by_sql("SELECT subbrand,
      SUM(CASE WHEN dmonth = '#{3.months.ago.month}' AND dyear = '#{3.months.ago.year}' THEN total_sales END) month3,
      SUM(CASE WHEN dmonth = '#{2.months.ago.month}' AND dyear = '#{2.months.ago.year}' THEN total_sales END) month2,
      SUM(CASE WHEN dmonth = '#{1.months.ago.month}' AND dyear = '#{1.months.ago.year}' THEN total_sales END) month1,
      SUM(CASE WHEN dmonth = '#{Date.today.month}' AND dyear = '#{Date.today.year}' THEN total_sales END) monthnow
      FROM foam_datawarehouse.foam_bybrands WHERE tanggalsj BETWEEN '#{3.months.ago.to_date}' AND '#{Date.today.to_date}'
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