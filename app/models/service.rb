class Service < ApplicationRecord
  @services = Service.all

  include HTTParty

  def self.check_status(endpoint)
    response = HTTParty.get(endpoint)

    response.code
  rescue StandardError => e
    puts e.message
  end

  def update_all_status
    @services.each do |service|
      service.status = '500'
      service.save
    end
  end

  def update_status
    self.status = Service.check_status(endpoint)
    save
  end

  after_save_commit do
    ServiceJob.set(wait: interval.minutes).perform_later(self) if interval_previously_changed?
  end

  after_initialize do
    self.status ||= update_status
  end
end
