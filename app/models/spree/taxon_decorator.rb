module Marsh
  module TaxonDecorator
    # def self.prepended(base)
    #   base.before_action :add_marsh_reports, only: [:index]
    # end

    # Creates permalink base for friendly_id
    def set_permalink
      if parent.present?
        self.permalink = [parent.permalink, (permalink.blank? ? name.to_url : permalink.split('/').last)].join('/')
      else
        self.permalink = name.to_url if permalink.blank?
      end
      # MARSH JULY-10-2019 adding this to avoid invisible admin interface errorz
      existing_taxons_with_this_permalink = Spree::Taxon.where(permalink: self.permalink).count
      if existing_taxons_with_this_permalink > 0
        self.permalink = self.permalink + existing_taxons_with_this_permalink
      end
    end

  end
end

Spree::Taxon.prepend Marsh::TaxonDecorator
