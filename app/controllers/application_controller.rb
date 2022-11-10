class ApplicationController < ActionController::Base
  # before_action :set_current_user

  def routing_error
    redirect_to(root_path)
  end

  # def after_sign_out_path_for(_resource_or_scope)
  #   root_path
  # end

  # def set_current_user
  #   Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  # end
end
