### Entry point

`poller.rb` is the entry point

The `whenever` gem is used to schedule a cron to run every minute and poll the site (and posting to slack). That schedule is in `config/schedule.rb`
