module ParamdatesConcern
  include ApplicationHelper
  extend ActiveSupport::Concern
  
  class_methods do
    def two_months_month
      2.months.ago.beginning_of_month.to_date.month
    end
  
    def two_months_date
      2.months.ago.beginning_of_month.to_date
    end
  
    def two_months_year
      2.months.ago.beginning_of_month.to_date.year
    end
  
    def last_month_date
      1.month.ago.beginning_of_month.to_date
    end
  
    def last_month_month
      1.month.ago.beginning_of_month.to_date.month
    end
  
    def last_month_year
      1.month.ago.beginning_of_month.to_date.year
    end
  
    def this_month_date
      6.days.ago.end_of_month.to_date
    end
  
    def this_month_month
      6.days.ago.end_of_month.to_date.month
    end
  
    def this_month_year
      6.days.ago.end_of_month.to_date.year
    end
  end
########## END CHANNEL
end