set :output, "./cron_log.log"

every 1.minute do
  puts 'hey!'
  rake 'poll_stock'
end
