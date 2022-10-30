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
end
