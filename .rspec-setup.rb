# require 'database_cleaner'

RSpec.configure do |config|
  config.backtrace_exclusion_patterns << /gems/
  config.fail_fast = true
end
