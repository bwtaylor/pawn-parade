
When(/^I execute it with arguments "(.*?)"$/) do |arguments|
  cmdline = @command + ' ' +  arguments
  system cmdline
end

Then /^the output should contain '([^']*)'$/ do |expected|
  assert_partial_output(expected, all_output)
end