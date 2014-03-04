pages = {
    'home' => '/',
    'sign in' => '/user/sign_in',
    'team' => '/teams',
    'dashboard' => '/dashboard/index'
}

def page_template(page_name, id)
   pages_for_id = {
     'team' => "/teams/#{team_slug_from_name(id)}",
     'edit team' => "/teams/#{team_slug_from_name(id)}/edit",
     'player' => "/players/#{player_id_from_name(id)}",
     'team registration' => "/teams/#{team_slug_from_name(id.split(/\s+and\s+/)[0])}/tournaments/#{id.split(/\s+and\s+/)[1]}"
   }[page_name]
end

def player_id_from_name(name)
  names = name.upcase.split /\s+/
  player = Player.find_by_first_name_and_last_name(names[0], names[1])
  player.nil? ? nil : player.id
end

def team_slug_from_name(name)
  Team.find_by_name(name).slug
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

def page_check_for(page_name, id)
  { 'new registration' =>
        lambda{ |slug| "Register for Tournament: #{Tournament.find_by_slug(slug).name}" },
    'player' =>
        lambda{ |name| "Player Page for #{name}" },
    'team' => lambda{ |name| "#{name} Team Roster" },
    'new player' => lambda{ |name| "Add Player To #{name} Team Roster" }
  }[page_name][id]
end

Then /^I should see (?:the|my) (.*) page$/ do |page_name|
  expected_content = page_check[page_name]
  raise "#{page_name} has no testing content associated with it" unless expected_content
  expect(page).to have_content expected_content
end

Then /^I should see the (.*) page for (.*)$/ do |page_name, id|
  expect(page).to have_content page_check_for(page_name, id)
end