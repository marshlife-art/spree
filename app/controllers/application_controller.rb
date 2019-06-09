class ApplicationController < ActionController::Base

  before_action :require_login

  private

  def require_login
    unless spree_current_user
      flash[:error] = "Please Login or Sign Up"
      redirect_to spree_login_path
    end
  end

end
