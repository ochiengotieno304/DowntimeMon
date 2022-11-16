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
    status_history.append(status_code)
    save
  end

  after_save_commit do
    ServiceJob.set(wait: interval.minutes).perform_later(self) if interval_previously_changed?
  end

  def self.generate_report(service_check_interval, _created_at, status_history, report_period)
    service_history_status = status_history.tally
    number_of_failures = 0

    service_history_status.each do |code, count|
      number_of_failures += count if code != '200'
    end

    total_operational_hours_daily = (report_period * 24.0) - ((number_of_failures * service_check_interval) / 60.0)
    total_operational_hours_weekly = (report_period * 24.0 * 7.0) - ((number_of_failures * service_check_interval) / 60.0)
    total_operational_hours_monthly = (report_period * 24.0 * 28.0) - ((number_of_failures * service_check_interval) / 60.0)
    total_operational_hours_3_monthly = (report_period * 24.0 * 28.0 * 3) - ((number_of_failures * service_check_interval) / 60.0)

    return unless number_of_failures.positive?

    mean_time_between_failures_daily = total_operational_hours_daily / number_of_failures
    mean_time_between_failures_weekly = total_operational_hours_weekly / number_of_failures
    mean_time_between_failures_monthly = total_operational_hours_monthly / number_of_failures
    mean_time_between_failures_3_monthly = total_operational_hours_3_monthly / number_of_failures

    next_maintenance_time_daily = Time.now + (mean_time_between_failures_daily - 1).hours
    next_maintenance_time_weekly = Time.now + (mean_time_between_failures_weekly - 1).hours
    next_maintenance_time_monthly = Time.now + (mean_time_between_failures_monthly - 1).hours
    next_maintenance_time_3_monthly = Time.now + (mean_time_between_failures_3_monthly - 1).hours

    maintenance_times = [next_maintenance_time_daily, next_maintenance_time_weekly, next_maintenance_time_monthly,
                         next_maintenance_time_3_monthly]
  end

  # after_initialize do
  #   self.status ||= 200
  # end
end
