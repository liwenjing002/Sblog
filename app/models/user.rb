class User < ActiveRecord::Base
  validates_presence_of :login_name,:message => I18n.t('login_name_null')
  validates_presence_of :password,:message => I18n.t('password_null')
  validates_presence_of :password_comfire,:message => I18n.t('password_comfire_null')
  validates_presence_of :email,:message => I18n.t('email_null')
  validates_uniqueness_of :login_name,:message => I18n.t('unique_login_name')
  validates_uniqueness_of :email,:message => I18n.t('unique_emial')
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:message => I18n.t('format_email')
  validates_format_of :login_name, :with => /^[a-zA-Z][a-zA-Z0-9_]{4,15}$/i,:message => I18n.t('format_login_name')
  validates_format_of :password, :with => /^[a-zA-Z0-9_]{5,15}$/i,:message => I18n.t('format_password')



  attr_accessor :password_comfire
  validates_confirmation_of :password,:message => "两次输入密码不一致"

  def login(session)

    u = User.find_by_login_name(self.login_name)
    if !u
      errors.add(:login_name, I18n.t('no_login_name'))
      return false
    end
    u = User.find_by_login_name_and_password(self.login_name,User.do_password_hash(self.password))
    if u
      session[:is_login] = true
      session[:login_name] = u.login_name
      session[:login_id] = u.id
    else
      errors.add(:login_name, I18n.t('wrong_password'))
      return false
    end
  end

  def self.logout(session)
    session[:is_login] = nil
  end

  def self.do_password_hash(password = nil)
    Digest::SHA1.hexdigest(password) if password
  end

  def validate#修改默认的验证
    errors.add(:password_comfire, "两次输入密码不一致") unless self.password_comfire== self.password
  end

  def before_create
    # hash the pass before creating a author
    self.password = User.do_password_hash(self.password)
  end
end
