require 'open-uri'

class Page < ActiveRecord::Base
  attr_accessible :content, :page_type, :slug, :source, :syntax

  validates_inclusion_of :syntax, :in => %w(asciidoc markdown)
  validates_inclusion_of :page_type, :in => %w(tournament schedule page)

  def reload!
    unless source.nil?
      io_stream = open(self.source)
      raise 'content cannot exceed 4000 characters' if io_stream.size > 4000
      self.content = io_stream.read(4000)
      self.save
    end
  end

  def render
    case self.syntax
      when 'asciidoc'
        ::Asciidoctor.render(self.content).html_safe
      when 'markdown'
        'NOT YET SUPPORTED'
      else
        ''
    end
  end

end
