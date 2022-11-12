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
    self.status = Service.check_status(endpoint)
    status_history.append(status)
    save
  end

  after_save_commit do
    ServiceJob.set(wait: interval.minutes).perform_later(self) if interval_previously_changed?
  end

  # after_initialize do
  #   self.status ||= 200
  # end
end
