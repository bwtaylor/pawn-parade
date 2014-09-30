require 'erb'

class TemplateMailer < ActionMailer::Base

  def mail_template(email, template_name, model)

    @model = model

    template = Template.find_by_name(template_name)
    email_body = ERB.new(template.body).result(binding)

    mail(to: email, body: email_body, content_type: template.content_type, subject: 'Test', from: 'nospam@rackspacechess.com')

  end

end
