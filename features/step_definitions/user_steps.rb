
include Warden::Test::Helpers

Given(/^no user (.*?) exists$/) do  |user_email|
  User.delete_all(["email = ?", user_email] )
end

Given(/^user (.*?) exists with password "(.*?)"$/) do |email_address, starting_password|
  User.create!(:email=>email_address, :password=>starting_password)
end

Given(/^I have an authenticated session as (.*) with password "(.*)"$/) do |user_email, password|
  step "user #{user_email} exists with password \"#{password}\""
  user = User.find_by_email(user_email)
  login_as(user, :scope=>:user)
end

Given(/^I authenticate as (.*)$/) do |user_email|
  user = User.find_by_email(user_email)
  login_as(user, :scope=>:user)
end


Given(/^I have an authenticated session$/) do
  user_email = 'testuser@example.com'
  password = 'testpassword'
  step "I have an authenticated session as #{user_email} with password \"#{password}\""
end

Given(/^I have no authenticated session$/) do
  user_email = 'testuser@example.com'
  password = 'testpassword'
  step "user #{user_email} exists with password \"#{password}\""
  user = User.find_by_email(user_email)
  logout user
end

When (/^I logout as (.*)$/) do |user_email|
  logout User.find_by_email(user_email)
end

When(/^I sign up and login as (.*)$/) do |user_email|
  step "user #{user_email} exists with password \"password\""
  user = User.find_by_email(user_email)
  login_as(user, :scope=>:user)
end

Then(/^the user (.*?) should exist exactly once$/) do |user_email|
  User.find_all_by_email(user_email).length.should be 1
end

Then(/^(.*?) can authenticate with password "(.*?)"$/) do |user_email, password|
  user = User.find_by_email(user_email)
  user.valid_password?(password).should be true
end

Given(/^user (.*?) is not an admin$/) do |user_email|
  user = User.find_by_email(user_email)
  user.admin?.should be false
end

Then(/^user (.*?) is an admin$/) do |user_email|
  user = User.find_by_email(user_email)
  user.admin?.should be true
end