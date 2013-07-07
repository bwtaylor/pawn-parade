  
  def table_at(selector) # see https://gist.github.com/1149139
    Nokogiri::HTML(page.body).css(selector).map do |table|
      table.css('tr').map do |tr|
        tr.css('th, td').map { |td| td.text }
      end
    end[0].reject(&:empty?)
  end

Then(/^I should see the (.+) table matching$/) do |table_id, expected_table|
  html_table = table_at(".#{table_id}").to_a
  html_table.map! { |r| r.map! { |c| c.gsub(/<.+?>/, '').gsub(/[\n\t\r]/, '') } }
  expected_table.diff!(html_table)
end
