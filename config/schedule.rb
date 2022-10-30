set :output, 'log/cron.log'

# set :environment, 'development'

every 1.minute do
  runner 'Service.update_all_status'
end
