class ServiceDownMailer < ApplicationMailer
  def service_down_email(user)
    @service = params[:service]

    mail(to: user.email, subject: 'Service Experiencing Downtime')
  end
end
