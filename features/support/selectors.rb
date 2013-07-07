module HtmlSelectorsHelpers
  
  def table_at(selector) # see https://gist.github.com/1149139
    Nokogiri::HTML(page.body).css(selector).map do |table|
      table.css('tr').map do |tr|
        tr.css('th, td').map { |td| td.text }
      end
    end[0].reject(&:empty?)
  end
  
end
