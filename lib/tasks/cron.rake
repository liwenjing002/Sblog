desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
 if Time.now.hour  == 12 # run every four hours
   puts "send email to everyone"
    users = User.find(:all)
    users.each{|user|
    from = APP_CONFIG["my_email"]
    subject = "test emmial everyday"
    message = "test email everyday"
    to =  user.email
    Mailer.delay.deliver_send(from,to ,subject, message)
    }

   puts "done."
 end

end
