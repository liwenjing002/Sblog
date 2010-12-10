class AboutController < ApplicationController
  layout "temp2"
  def msg

  end


  def contact
    @my_email= "liwenjingabc@gmail.com"
    @action= 'connect_us'
    return unless request.post?
    email = params[:email]
    from = email["from"]
    subject = email["subject"]
    message = email["message"]
    to =  email["recipients"]
    Mailer.delay.deliver_send(from,to ,subject, message) 
    
  end
end
