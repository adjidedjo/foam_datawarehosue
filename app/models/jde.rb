class Jde < ActiveRecord::Base
  establish_connection :jdeoracle

  self.table_name = "PRODDTA.F0006"
  def self.get_customer_rkb(customer)
    find_by_sql("SELECT ABALPH FROM PRODDTA.F0101 WHERE ABAN8 LIKE '%#{customer}%' AND ABAT1 = 'C'")
  end

  def self.get_sales_rkb(sales)
    find_by_sql("SELECT ABALPH FROM PRODDTA.F0101 WHERE ABAN8 LIKE '%#{sales}%' AND ABAT1 = 'E'").first
  end

  def self.pbjm_unlisted(from, to)
    fdate = date_to_julian(from.to_date).to_i
    tdate = date_to_julian(to.to_date).to_i
    find_by_sql("
      SELECT SO.*, IB.IBSRP6
        FROM(
          SELECT MAX(SDMCU) AS BRANCH_PROD, MAX(SDITM) AS ITEM, MAX(SDLITM) AS ITEM_NUMBER, SUBSTR(SDSHAN,3,3) AS SHIP_TO,
          SUM(SDUORG) AS JML,
          SUM(CASE WHEN SDVR01 LIKE 'PBJM%' THEN SDUORG END) AS PBJM_QTY,
          SUM(CASE WHEN REGEXP_LIKE(SDVR01, 'PBJO|PBJB|PBJBP') THEN SDUORG END) AS QTY
          FROM PRODDTA.F4211
          WHERE SDNXTR = '525' AND SDDRQJ BETWEEN '#{fdate}' AND '#{tdate}' AND REGEXP_LIKE(SDMCU, '11001$|11002$')
          AND SDLITM NOT LIKE '06%'
          AND REGEXP_LIKE(SUBSTR(SDSHAN,3,3), '091|092|081|082|011|012|031|032|151|152|021|022|051|052|041|042|101|102|121|122')
          GROUP BY SDITM, SDSHAN
      ) SO
      LEFT JOIN
      (
        SELECT IBSRP6, MAX(IBITM) AS IBITM FROM PRODDTA.F4102 WHERE REGEXP_LIKE(IBMCU, '11001|11002') AND IBSRP6 != ' ' GROUP BY IBITM, IBSRP6
      ) IB ON IB.IBITM = SO.ITEM
      WHERE IB.IBSRP6 IS NULL
    ")
  end

  def self.pbjm_analisis(from, to)
    fdate = date_to_julian(from.to_date).to_i
    tdate = date_to_julian(to.to_date).to_i
    find_by_sql("
      SELECT SO.SHIP_TO AS BRANCH, NVL(IB.IBSRP6, '-') AS PLANER, NVL(SUM(SO.PBJM_QTY), 0)/10000 AS PBJM,
        NVL(SUM(SO.QTY), 0)/10000 AS ORDER_, SUM(SO.JML)/10000 AS TOTAL
        FROM(
          SELECT MAX(SDMCU) AS BRANCH_PROD, MAX(SDITM) AS ITEM, MAX(SDLITM) AS ITEM_NUMBER, SUBSTR(SDSHAN,3,3) AS SHIP_TO,
          SUM(SDUORG) AS JML,
          SUM(CASE WHEN SDVR01 LIKE 'PBJM%' THEN SDUORG END) AS PBJM_QTY,
          SUM(CASE WHEN REGEXP_LIKE(SDVR01, 'PBJO|PBJB|PBJBP') THEN SDUORG END) AS QTY
          FROM PRODDTA.F4211
          WHERE SDNXTR < '999' AND SDLTTR < '980' AND SDDRQJ BETWEEN '#{fdate}' AND '#{tdate}' AND REGEXP_LIKE(SDMCU, '11001$|11002$')
          AND SDLITM NOT LIKE '06%'
          AND REGEXP_LIKE(SUBSTR(SDSHAN,3,3), '091|092|081|082|011|012|031|032|151|152|021|022|051|052|041|042|101|102|121|122')
          GROUP BY SDITM, SDSHAN
      ) SO
      LEFT JOIN
      (
        SELECT IBSRP6, MAX(IBITM) AS IBITM FROM PRODDTA.F4102 WHERE REGEXP_LIKE(IBMCU, '11001|11002') AND IBSRP6 != ' ' GROUP BY IBITM, IBSRP6
      ) IB ON IB.IBITM = SO.ITEM
      WHERE IB.IBSRP6 IS NOT NULL
      GROUP BY IB.IBSRP6, SO.SHIP_TO ORDER BY SO.SHIP_TO
    ")
  end

  def self.date_to_julian(date)
    1000*(date.year-1900)+date.yday
  end

  def self.julian_to_date(jd_date)
    if jd_date.nil? || jd_date == 0
    0
    else
      Date.parse((jd_date+1900000).to_s, 'YYYYYDDD')
    end
  end
end