
def table_at(selector) # see https://gist.github.com/1149139
  Nokogiri::HTML(page.body).css(selector).map do |table|
    table.css('tr').map do |tr|
      tr.css('th, td').map { |td| td.text }
    end
  end[0].reject(&:empty?)
end

def enter_or_select(field, value, form=nil)
  verb, field = "select", field[8..-1] if field.start_with? 'select: '
  verb, field = "date", field[6..-1] if field.start_with? 'date: '
  field = "#{form}_#{field}" if form
  case verb
    when 'select'
      step "I select \"#{value}\" for #{field}"
    when 'date'
      value.split(/[-,\s]+/).each_with_index do |part, index|
        step "I select \"#{part}\" for #{field}_#{index+1}i"
      end
    else
      step %{I fill in #{field} with "#{value}"}
  end
end
  

