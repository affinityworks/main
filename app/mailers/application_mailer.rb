class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@affinity.works'
  layout 'mailer'
end
