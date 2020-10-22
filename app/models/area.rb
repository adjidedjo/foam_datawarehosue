class Area < ActiveRecord::Base
  has_many :brand_value, class_name: 'Marketshare::BrandValue'
  def self.pbjm_group_with_quotas(pbjm)
    @pbjm_a = []
    pbjm.each do |p|
      p.branch = get_area(p.branch)
      @pbjm_a << p
    end
    return @pbjm_a
  end

  def self.get_area(cabang)
    find(find_area(cabang.to_s)).area
  end

  def self.get_quotas_all(planer)
    find_by_sql("
      SELECT SUM(quantity) AS qty FROM production.BRANCH_QUOTAS2 WHERE planner = '#{planer}' GROUP BY planner").first.qty
  end

  def self.get_quotas(cabang, planer)
    find_by_sql("
      SELECT * FROM production.BRANCH_QUOTAS2 WHERE branch_id = '#{find_area(cabang.to_s)}'
      AND planner = '#{planer}'").first.quantity
  end

  def self.find_area(cabang)
    if cabang == "011" || cabang == "012"
    2
    elsif cabang == "001" || cabang == "002"
    1
    elsif cabang == "031" || cabang == "032"
    23
    elsif cabang == "151" || cabang == "152"
    3
    elsif cabang == "081" || cabang == "082"
    5
    elsif cabang == "021" || cabang == "022"
    9
    elsif cabang == "051" || cabang == "052"
    8
    elsif cabang == "041" || cabang == "042"
    10
    elsif cabang == "091" || cabang == "092"
    11
    elsif cabang == "101" || cabang == "102"
    13
    elsif cabang == "121" || cabang == "122"
    20
    end
  end
end