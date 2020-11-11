class Penjualan::Nasional::RecapsController < ApplicationController
  include RolesHelper
  before_action :checking_params
  #before_action :authorize_bm, only: :recap

  def recap
    @branch = "NASIONAL"
    @summary = NasionalSales.total_revenue_foam(@date)
    @monthnas_summary = NasionalSales.foam_nasional_this_month_total(@date)
    @foam_naschannel = NasionalSales.foam_nasional_channel_total(@date)
    @bybrand = NasionalSales.recap_bysubbrand(@date)
    @customer = NasionalSales.customer_monthly(@date)
    render template: "penjualan/nasional/recap"
  end
  
  private

  def checking_params
    if params[:date].nil?
      date = '1/'+Date.yesterday.month.to_s+'/'+Date.yesterday.year.to_s
      @date = (date.to_date + Date.today.strftime('%d').to_i) - 1
    else
      date = '1/'+params[:date][:month].to_s+'/'+params[:date][:year].to_s
      @date = (date.to_date + Date.today.strftime('%d').to_i) - 1
    end
  end
  
  def authorize_bm
    render template: "pages/notfound" unless general_manager(current_user) || nsm(current_user, initialize_brand) || 
    bm_customers(current_user, initialize_brach_id)
  end
end