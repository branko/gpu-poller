task default: %w[poll_cc]

task :poll_cc do
  puts "Running rake task.."
  ruby "./pollers/cc_poller.rb"
  puts "Complete"
end

task :poll_staples do
  puts "Running rake task.."
  ruby "./pollers/staples_poller.rb"
  puts "Complete"
end