# You need to create a file called secrets.rb in the root directory
# with a constant called WEBHOOK_URL which corresponds to the 
# Webhook URL for your slack workspace
load 'secrets.rb'

require 'yaml'
require 'paint'
require 'httparty'
require './lib/notifications/base_notifier.rb'
require './lib/canada_computers_response.rb'
require './lib/canada_computers_scraper.rb'
require './lib/manufacturer.rb'
require './lib/alert'
require './lib/notifications/slack_notifier.rb'