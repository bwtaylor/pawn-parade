
When(/^I execute it with arguments "(.*?)"$/) do |arguments|
  cmdline = @command + ' ' +  arguments
  system cmdline
end
