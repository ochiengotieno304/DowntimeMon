require 'test_helper'

class ServiceMailerTest < ActionMailer::TestCase
  test 'new service email' do
    # Set up an service based on the fixture
    service = service(:one)

    # Set up an email using the service contents
    email = ServiceMailer.with(service:).new_service_email

    # Check if the email is sent
    assert_emails 1 do
      email.deliver_now
    end

    # Check the contents are correct
    assert_equal Rails.application.credentials.mailer[:admin_email], email.from
    assert_equal Rails.application.credentials.mailer[:admin_email], email.to
    assert_equal 'You got a new service!', email.subject
    assert_match service.name, email.html_part.body.encoded
    assert_match service.name, email.text_part.body.encoded
    assert_match service.interval, email.html_part.body.encoded
    assert_match service.interval, email.text_part.body.encoded
    assert_match service.endpoint, email.html_part.body.encoded
    assert_match service.endpoint, email.text_part.body.encoded
  end
end
