class Penjualan::Wholesale::WholesalesController < ApplicationController
  include RolesHelper
  before_action :checking_params
  #before_action :authorize_bm, only: :recap

  def recap
    channel = "WHS"
    @summary = WhsSale.total_revenue_channel_whs(@date, channel)
    @monthnas_summary = WhsSale.whs_channel_this_month_total(@date, channel)
    @foam_naschannel = ChannelSales.foam_channel_total(@date, channel)
    @bybrand = ChannelSales.recap_bysubbrand_channel(@date, channel)
    @customer = WhsSale.customer_channel_monthly(@date, channel)
    @products = NasionalSales.product_monthly(@date)
    render template: "penjualan/wholesale/recap"
  end
  
  private

  def checking_params
    if params[:date].nil?
      date = '1/'+Date.today.month.to_s+'/'+Date.today.year.to_s
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