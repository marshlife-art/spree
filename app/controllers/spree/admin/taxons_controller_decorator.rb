module Marsh
  module TaxonsControllerDecorator
    # def self.prepended(base)
    #   base.before_action :add_marsh_reports, only: [:index]
    # end
    def index
      @taxons = Spree::Taxon.page(params[:page]).per(500)
    end
    
    def update_taxons

    end
     
  end
end

Spree::Admin::TaxonsController.prepend Marsh::TaxonsControllerDecorator
