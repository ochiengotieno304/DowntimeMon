class ApplicationController < ActionController::Base
  def routing_error
    redirect_to(root_path)
  end
end
