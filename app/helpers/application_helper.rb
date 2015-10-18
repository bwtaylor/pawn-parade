module ApplicationHelper

  def error_messages_for(object)
    render :partial => 'shared/error_messages', :locals => {:object => object}
  end

  def format_email_list(emails,separator)
    case separator
      when 'semicolon'
        sep = '; '
      when 'semicolon-break'
        sep = ";\n"
      when 'break'
        sep = "\n"
      when 'comma'
        sep = ', '
      when 'comma-break'
        sep = ",\n"
      else
        sep = ",\n"
    end
    emails.reject{|email| !(User::EMAIL_REGEX =~ email) }.join(sep)

  end

end
