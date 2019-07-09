Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  if Rails.env.development?
    require 'resque/server'
    mount Resque::Server, at: '/jobs'

    #or if you would like to protect this with Devise
    # devise_for :users
    # authenticate :user do
    #   mount Resque::Server, at: '/jobs'
    # end
  end

end

Spree::Core::Engine.routes.prepend do
  namespace :admin do

    resources :reports, only: [:index] do
      collection do
        get   :item_report
        post  :item_report
      end
    end

  end
end
