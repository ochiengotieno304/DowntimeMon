class Service < ApplicationRecord
  include Concurrent::Async
  include HTTParty

  def self.check_status(endpoint)
    response = HTTParty.get(endpoint)

    response.code
  end
end
