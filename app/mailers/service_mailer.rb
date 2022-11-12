class ServiceMailer < ApplicationMailer
  def new_service_email(user)
    @service = params[:service]

    mail(to: user.email, subject: "New Service Added")
  end
end
