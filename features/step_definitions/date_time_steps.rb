require 'timecop'

Given /^the date is "([^"]*)"$/ do |date_string|
  Timecop.travel Date::strptime(date_string, "%Y-%m-%d")
end
