class ServiceJob < ApplicationJob
  queue_as :default
  RUN_EVERY = 1.minute

  def perform(service)
    service.update_status
  end

  after_perform do |job|
    self.class.set(wait: job.arguments.first.interval.minutes).perform_later(job.arguments.first)
  end
end
