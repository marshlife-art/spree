module Marsh
  module StoreControllerDecorator
    def self.prepended(base)
      base.skip_before_action :require_login, only: [:cart_link]
    end
  end

  module UserSessionsDecorator
    def self.prepended(base)
      base.skip_before_action :require_login, only: [:new]
    end
  end

  module UserRegistrationsDecorator
    def self.prepended(base)
      base.skip_before_action :require_login, only: [:new, :create]
    end
  end

  module UserPasswordsDecorator
    def self.prepended(base)
      base.skip_before_action :require_login, only: [:new, :create, :update]
    end
  end

end

Spree::StoreController.prepend Marsh::StoreControllerDecorator
Spree::UserSessionsController.prepend Marsh::UserSessionsDecorator
Spree::UserRegistrationsController.prepend Marsh::UserRegistrationsDecorator
Spree::UserPasswordsController.prepend Marsh::UserPasswordsDecorator
