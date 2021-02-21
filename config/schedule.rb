set :output, "./cron_log.log"

every 1.minute do
  rake 'poll_stock'
end
