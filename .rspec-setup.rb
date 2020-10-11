# require 'database_cleaner'

RSpec.configure do |config|
  config.backtrace_exclusion_patterns << /ruby-2\.2\.1\/gems/
  config.fail_fast = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
