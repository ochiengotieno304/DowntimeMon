class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.mailer[:admin_email]
  layout 'mailer'
end
