module Marsh
  module TaxonomiesControllerDecorator
    # def self.prepended(base)
    #   base.before_action :add_marsh_reports, only: [:index]
    # end
    def location_after_save
      edit_admin_taxonomy_url(@taxonomy)
    end
    
    
  end
end

Spree::Admin::TaxonomiesController.prepend Marsh::TaxonomiesControllerDecorator
