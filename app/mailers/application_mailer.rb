class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@glbrc.wisc.edu'
  default to: 'helpdesk@glbrc.wisc.edu'
  layout 'mailer'
end
