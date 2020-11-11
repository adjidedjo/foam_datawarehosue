module ParamdatesConcern
  include ApplicationHelper
  extend ActiveSupport::Concern
  
  class_methods do
    def two_months_month(date)
      ((date.to_date - 6) - 60).beginning_of_month.to_date.month
    end
  
    def two_months_date(date)
      ((date.to_date - 6) - 60).beginning_of_month.to_date
    end
  
    def two_months_year(date)
      ((date.to_date - 6) - 60).beginning_of_month.to_date.year
    end
  
    def last_month_date(date)
      ((date.to_date - 6) - 30).beginning_of_month.to_date
    end
  
    def last_month_month(date)
      ((date.to_date - 6) - 30).beginning_of_month.to_date.month
    end
  
    def last_month_year(date)
      ((date.to_date - 6) - 30).beginning_of_month.to_date.year
    end
  
    def this_month_date(date)
      (date.to_date - 6).end_of_month.to_date
    end
  
    def this_month_month(date)
      (date.to_date - 6).end_of_month.to_date.month
    end
  
    def this_month_year(date)
      (date.to_date - 6).end_of_month.to_date.year
    end
  end
########## END CHANNEL
end