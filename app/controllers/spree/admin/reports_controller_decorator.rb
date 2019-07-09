module Marsh
  module ReportsControllerDecorator
    def self.prepended(base)
      base.before_action :add_marsh_reports, only: [:index]
    end
    def item_report
        params[:q] = {} unless params[:q]

        params[:q][:completed_at_gt] = if params[:q][:completed_at_gt].blank?
          Time.zone.now.beginning_of_month
        else
          begin
            Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day
          rescue StandardError
            Time.zone.now.beginning_of_month
          end
        end

        if params[:q] && !params[:q][:completed_at_lt].blank?
          params[:q][:completed_at_lt] = begin
            Time.zone.parse(params[:q][:completed_at_lt]).end_of_day
          rescue StandardError
            ''
          end
        end

        params[:q][:s] ||= 'completed_at desc'

        @search = Spree::Order.complete.ransack(params[:q])
        @orders = @search.result

        # @totals = {}
        # @orders.each do |order|
        #   @totals[order.currency] = { item_total: ::Money.new(0, order.currency), adjustment_total: ::Money.new(0, order.currency), sales_total: ::Money.new(0, order.currency) } unless @totals[order.currency]
        #   @totals[order.currency][:item_total] += order.display_item_total.money
        #   @totals[order.currency][:adjustment_total] += order.display_adjustment_total.money
        #   @totals[order.currency][:sales_total] += order.display_total.money
        # end


        respond_to do |format|
          format.html
        end
      end
      
      def add_marsh_reports
        Spree::Admin::ReportsController.add_available_report! :item_report
      end
  end
end

Spree::Admin::ReportsController.prepend Marsh::ReportsControllerDecorator




# Spree::Admin::ReportsController.class_eval do
#   before_action :add_marsh_reports, only: [:index]

#   def earnings
#     @supplier_earnings = get_supplier_earnings
#     respond_to do |format|
#       format.html
#       format.csv { send_data earnings_csv }
#     end
#   end



#   def earnings_csv
#     header1 = ["Supplier Earnings"]
#     header2 = ["Supplier", "Earnings", "Paypal Email"]

#     CSV.generate do |csv|
#       csv << header1
#       csv << []
#       csv << header2
#       @supplier_earnings.each do |se|
#         csv << ["#{se[:name]}", "#{se[:earnings].to_html}", "#{se[:paypal_email]}"]
#       end
#     end
#   end

#   private

#   def add_marsh_reports
#     marketplace_reports.each do |report|
#       Spree::Admin::ReportsController.add_available_report! report
#     end
#   end

#   def marketplace_reports
#     [:earnings]
#   end

#   def get_supplier_earnings
#     grouped_supplier_earnings.each do |se|
#       se[:earnings] = se[:earnings].inject(Spree::Money.new(0)){ |e, c| c + e }
#     end
#   end

#   def grouped_supplier_earnings
#     params[:q] = search_params
#     @search = Spree::Order.complete.ransack(params[:q])
#     @orders = @search.result

#     supplier_earnings_map = @orders.map { |o| o.supplier_earnings_map }
#     grouped_suppliers_map = supplier_earnings_map.flatten.group_by { |e| e[:name] }.values
#     grouped_earnings = grouped_suppliers_map.map do |gs|
#       h = {}
#       h[:name] = nil
#       h[:paypal_email] = nil
#       h[:earnings] = []
#       gs.each do |s|
#         h[:name] = s[:name] if h[:name].nil?
#         h[:paypal_email] = s[:paypal_email] if h[:paypal_email].nil?
#         h[:earnings] << s[:earnings]
#       end
#       h
#     end
#     grouped_earnings
#   end

# end