
Then /^I should see the (.+) table matching$/ do |table_id, expected_table|
  html_table = table_at(".#{table_id}").to_a
  html_table.map! { |r| r.map! { |c| c.gsub(/<.+?>/, '').gsub(/[\n\t\r]/, '') } }
  expected_table.diff!(html_table)
end

Then /^I should see content (?:matching|containing)$/ do |expected_table|
  expected_table.raw.flatten.each do |expected_text|
    expect(page).to have_content expected_text
  end
end

Then /^I should see text (?:matching|containing)$/ do |expected_table|
  expected_table.raw.flatten.each do |expected_text|
    page.should have_text expected_text
  end
end

Then /^I should see a list entry with text (?:matching|containing)$/ do |expected_table|
  the_page = page
  selected = page.all('ul.search_hits')
  list_items = page.all('ul.search_hits li').map(&:text)
  expected_table.raw.flatten.each do |expected_text|
    list_items.should include expected_text
  end
end

Then /^I should see text "(.*)"$/ do |expected_text|
  page.should have_text expected_text
end

Then /^I should not see text "(.*)"$/ do |expected_text|
  page.should_not have_text expected_text
end

Then /^I should see content "(.*)"$/ do |expected_text|
  #expect(page).to have_content expected_text
  page.should have_text expected_text
end

Then /^I should not see content "(.*)"$/ do |expected_text|
  page.should_not have_content expected_text
end

Then /^I should see "(.*)" selected for (.*)$/ do |value, field|
  page.should have_select(field.gsub(' ', '_'), selected: value)
end

Then /^I should not see "(.*)" selected for (.*)$/ do |value, field|
  page.should_not have_select(field.gsub(' ', '_'), selected: value)
end


