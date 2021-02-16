### Entry point

`poller.rb` is the entry point. For slack to work: add a `secrets.rb` with a `WEBHOOK_URL` and `SLACK_USER_ID` in the form of `@ASDFASDF`

The `whenever` gem is used to schedule a cron to run every minute and poll the site (and posting to slack). That schedule is in `config/schedule.rb`
