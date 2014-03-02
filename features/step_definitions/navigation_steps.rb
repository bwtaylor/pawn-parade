pages = {
    'home' => '/',
    'sign in' => '/user/sign_in',
    'team' => '/teams',
    'dashboard' => '/dashboard/index'
}

def page_template(page_name, id)
   pages_for_id = {
     'team' => "/teams/#{id}",
     'edit team' => "/teams/#{id}/edit"
   }[page_name]
end

When(/^I navigate to "(.*?)"$/) do |uri_path|
  visit(uri_path)
end

When(/^I navigate to the (.*?) page$/) do |page_name|
  uri_path = pages[page_name]
  raise "#{page_name} has no testing uri_path associated with it" unless uri_path
  visit(uri_path)
end

When(/^I navigate to the (.*?) page for (.*)$/) do |page_name, id|
  page =  page_template(page_name, id)
  page ? visit(page) : raise("#{page_name} has no testing uri_path template associated with it")
end


When(/^I click the "(.*)" (?:link or button|button or link|link|button)$/) do |button_name|
  click_link_or_button(button_name)
end

Then(/^there is a "(.*)" link or button$/) do |button_name|
  page.should have_selector(:link_or_button, button_name)
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

page_check = {
    'sign in' => 'Sign in',
    'home' => 'Why Rackspace Supports Scholastic Chess',
    'personal home' => 'Dashboard for',
    'team' => 'Listing teams'
}

Then(/^I should see (?:the|my) (.*) page$/) do |page_name|
  expected_content = page_check[page_name]
  raise "#{page_name} has no testing content associated with it" unless expected_content
  expect(page).to have_content expected_content
end

