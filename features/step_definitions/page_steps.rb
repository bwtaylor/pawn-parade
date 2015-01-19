
Given(/^schedule (.*) has no associated page$/) do |slug|
  schedule = Schedule.find_by_slug(slug)
  Raise "schedule #{slug} has a page id=#{schedule.page.id}" unless schedule.page.nil?
end

Given( /^(.*) (.*) has the associated page:$/) do |page_type, slug, table|
  table.hashes.each do |page|
    Page.new(:page_type=>page_type, :slug=>slug, :syntax=>page[:syntax], :source=>page[:source]).save!
  end
end

When( /^I reload the page for (.*) (.*)$/ ) do |page_type, slug|
  page = Page.find_by_page_type_and_slug(page_type,slug)
  page.reload!
end
