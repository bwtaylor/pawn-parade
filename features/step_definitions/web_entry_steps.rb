When /^I fill in (.*) with "(.*)"$/ do |field, value|
  fill_in(field.gsub(' ', '_'), :with => value)
end

When /^I (?:fill in|enter) "(.*)" (?:for|to|into) (?:the)? (.*) (?:field|data element|box)$/ do |value, field|
  fill_in(field.gsub(' ', '_'), :with => value)
end

When /^I (?:fill in|enter) the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    enter_or_select(name, value)
  end
end

When /^I select "(.*)" (?:for|from) (.*)$/ do |value, field|
  select(value, :from => field.gsub(' ', '_'))
end

Then /^Submitting (.*) form data as follows should give the expected message:$/ do |form, table|
  table.hashes.each do |row|
    expected_message = row['expected_message']
    row.except!('expected_message').each do |field, value|
      enter_or_select(field, value, form)
    end
    step 'I click the "Submit" button'
    step %{I should see content "#{expected_message}"}
  end
end