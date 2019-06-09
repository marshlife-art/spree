module Marsh
  module StoreControllerDecorator
    def self.prepended(base)
      # base.before_action :check_for_user #, except: [:login]
      base.skip_before_action :require_login, only: [:cart_link]

    end

    # def check_for_user
    #   unless spree_current_user
    #     redirect_to login_url and return
    #   end
    # end
  end

  module UserSessionsDecorator
    def self.prepended(base)
      # base.before_action :check_for_user #, except: [:login]
      base.skip_before_action :require_login, only: [:new]
    end
  end

end



Spree::StoreController.prepend Marsh::StoreControllerDecorator


Spree::UserSessionsController.prepend Marsh::UserSessionsDecorator