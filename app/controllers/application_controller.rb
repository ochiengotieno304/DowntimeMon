class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def routing_error
    redirect_to(root_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :phone) }

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:name, :email, :phone, :password, :current_password)
    end
  end
end
