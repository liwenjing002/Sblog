class Mailer < ActionMailer::Base
  def signup_send(user)
    @subject = I18n.t('welcome_signup')
    @recipients = user.email
    @sent_on = Time.now
    @body["login_name"] = user.login_name
    @body["email"] = user.email
    @body["alias_name"] = user.alias_name
    @body["title"] =I18n.t('welcome_word')
    @body["signup_message"] =I18n.t('signup_message')
    @content_type="text/html"
  end

  def get_password(user)
    @subject = I18n.t('funnything_password')
    @recipients = user.email
    @sent_on = Time.now
    @body["login_name"] = user.login_name
    @body["email"] = user.email
    @body["alias_name"] = user.alias_name
    @body["password"] = user.password
    @body["title"] =I18n.t('funnything_password')
    @body["signup_message"] =I18n.t('signup_message')
    @content_type="text/html"
  end


  def send(from,to,subject, message)
    @subject = subject
    @recipients = to
    @sent_on = Time.now
    @body["from"] =from
    @body["message"] =message
    @content_type="text/html"
  end
end
