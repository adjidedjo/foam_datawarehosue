class Penjualan::Nasional::RecapsController < ApplicationController
  include RolesHelper
  #before_action :authorize_bm, :checking_params
  #before_action :authorize_bm, only: :recap

  def recap
    @branch = "NASIONAL"
    @bybrand = NasionalSales.recap_bybrand
    @customer = NasionalSales.customer_monthly
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