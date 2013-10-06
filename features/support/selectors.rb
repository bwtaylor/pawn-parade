
def table_at(selector) # see https://gist.github.com/1149139
  Nokogiri::HTML(page.body).css(selector).map do |table|
    table.css('tr').map do |tr|
      tr.css('th, td').map { |td| td.text }
    end
  end[0].reject(&:empty?)
end

def enter_or_select(field, value, form=nil)
  verb, field = "select", field[8..-1] if field.start_with? 'select: '
  field = "#{form}_#{field}" if form
  case verb
    when 'select'
      step "I select \"#{value}\" for #{field}"
    else
      step %{I fill in #{field} with "#{value}"}
  end
end
  

