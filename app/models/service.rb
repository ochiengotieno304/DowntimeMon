class Service < ApplicationRecord
  belongs_to :user
  include HTTParty

  def self.check_status(endpoint)
    response = HTTParty.get(endpoint)
    response.code
  rescue StandardError => e
    puts e.message
  end

  def update_status
    status_code = Service.check_status(endpoint)
    if status_code == 200
      self.status = 'OK'
    else
      self.status = 'DOWN'
      ServiceDownMailer.with(service: self).service_down_email(user).deliver_later
    end
    # self.status = Service.check_status(endpoint)
    # status_history.append(status)
    status_history.append(status_code)
    save
  end

  after_save_commit do
    ServiceJob.set(wait: interval.minutes).perform_later(self) if interval_previously_changed?
  end

  # after_initialize do
  #   self.status ||= 200
  # end
end
