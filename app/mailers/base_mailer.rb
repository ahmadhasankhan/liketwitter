class BaseMailer < ActionMailer::Base
 default :from => "no_reply@indiatechdreams.com"
  default_url_options[:host] = "localhost:3000"

  helper :application
  layout "mailer"
end
