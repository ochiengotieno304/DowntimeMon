class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.mailer[:address]
  layout 'mailer'
end
