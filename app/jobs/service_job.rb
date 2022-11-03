class ServiceJob < ApplicationJob
  queue_as :default

  def perform(service)
    service.update_status
  end
end
