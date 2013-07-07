require 'timecop'

Given /^the date is "([^"]*)"$/ do |date_string|
  Timecop.freeze Date::strptime(date_string, "%Y-%m-%d")
end
