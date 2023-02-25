class Service < ApplicationRecord
  belongs_to :user
  has_many :reports, dependent: :destroy
  validates :name, presence: true
  validates :endpoint, presence: true

  def self.check_status(endpoint)
    @response = Faraday.get(endpoint)
    @response.status
  rescue StandardError => e
    puts e.message
  end

  def self.request_headers
    @response.headers
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

  def self.generate_report(service_check_interval, status_history, last_down)
    service_history_status = status_history.tally
    number_of_failures = 0

    service_history_status.each do |code, count|
      number_of_failures += count if code != '200'
    end

    total_ops_hrs_daily = 24.0 - ((number_of_failures * service_check_interval) / 60.0)
    total_ops_hrs_weekly = (24.0 * 7.0) - ((number_of_failures * service_check_interval) / 60.0)
    total_ops_hrs_monthly = (24.0 * 28.0) - ((number_of_failures * service_check_interval) / 60.0)
    total_ops_hrs_3_monthly = (24.0 * 28.0 * 3.0) - ((number_of_failures * service_check_interval) / 60.0)

    return unless number_of_failures.positive?

    mtbf_daily = total_ops_hrs_daily / number_of_failures
    mtbf_weekly = total_ops_hrs_weekly / number_of_failures
    mtbf_monthly = total_ops_hrs_monthly / number_of_failures
    mtbf_3_monthly = total_ops_hrs_3_monthly / number_of_failures

    if last_down
      next_maintenance_time_daily = last_down + (mtbf_daily - 1).hours
      next_maintenance_time_weekly = last_down + (mtbf_weekly - 1).hours
      next_maintenance_time_monthly = last_down + (mtbf_monthly - 1).hours
      next_maintenance_time_3_monthly = last_down + (mtbf_3_monthly - 1).hours
    end

    [next_maintenance_time_daily, next_maintenance_time_weekly, next_maintenance_time_monthly,
     next_maintenance_time_3_monthly]
  end

  # after_initialize do
  #   self.status ||= 200
  # end

  before_update do
    self.last_down = Time.now if status == 'DOWN'
  end
end
