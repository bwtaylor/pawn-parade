
Then(/^I should see the (.+) table matching$/) do |table_id, expected_table|
  html_table = table_at(".#{table_id}").to_a
  html_table.map! { |r| r.map! { |c| c.gsub(/<.+?>/, '').gsub(/[\n\t\r]/, '') } }
  expected_table.diff!(html_table)
end

Then(/^I should see content matching$/) do |expected_table|
  expected_table.raw.flatten.each do |expected_text|
    expect(page).to have_content expected_text
  end
end
