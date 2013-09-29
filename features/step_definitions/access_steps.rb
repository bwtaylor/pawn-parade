
Given(/^I have local shell access to execute "(.*?)" in the project directory$/) do |cmd|
  @command = Rails.root.to_s + "/" + cmd
  File.executable?(@command)
end

