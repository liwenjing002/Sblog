class EmailerController < ApplicationController
  def sendemail
    email = params[:email]
    from = email["from"]
    subject = email["subject"]
    message = email["message"]
    Mailer.delay.deliver_send(from, subject, message)
    return if request.xhr?
    render :text => 'Message sent successfully'
  end

  def connect_us
    @my_email= "liwenjingabc@gmail.com"
    @action= 'connect_us'
    return unless request.post?
    email = params[:email]
    from = email["from"]
    subject = email["subject"]
    message = email["message"]
    to =  email["recipients"]
    Mailer.delay.deliver_send(from,to ,subject, message)
    flash[:notice] =I18n.t('email send')
  end
end
