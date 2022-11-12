# Preview all emails at http://localhost:3000/rails/mailers/service_mailer
class ServiceMailerPreview < ActionMailer::Preview
  def new_service_email
    # Set up a temporary service for the preview
    service = Service.new(name: 'Google', interval: '1', status: '200', endpoint: 'http://google.com')

    ServiceMailer.with(service:).new_service_email
  end
end
