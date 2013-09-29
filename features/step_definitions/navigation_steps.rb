
When(/^I navigate to "(.*?)"$/) do |uri_path|
  visit(uri_path)
end

When(/^I click the "(.*)" (?:link or button|button or link|link|button)$/) do |button_name|
  click_link_or_button(button_name)
end

Then(/^there is no "(.*)" link or button$/) do |button_name|
  page.should_not have_selector(:link_or_button, button_name)
end

When(/^I (?:sleep|wait) (?:for)? (\d+) seconds?$/) do |digit_string|
  sleep digit_string.to_i
end

When(/^I (?:sleep|wait) (?:for)? (\d+) milliseconds?$/) do |digit_string|
  sleep digit_string.to_i / 1000.0
end

