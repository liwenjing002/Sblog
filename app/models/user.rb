class User < ActiveRecord::Base
  validates_presence_of :login_name,:message => "登录名不为空"
  validates_presence_of :password,:message => "密码不为空"
  validates_presence_of :password_comfire,:message => "密码重复不为空"
  validates_presence_of :email,:message => "邮箱地址不为空"
  validates_uniqueness_of :login_name,:message => "登录名已经被使用"
  validates_uniqueness_of :email,:message => "邮箱已经被使用"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:message => "请输入正确的邮箱格式"
  validates_format_of :login_name, :with => /^[a-zA-Z][a-zA-Z0-9_]{4,15}$/i,:message => "登录名格式:字母开头，允许5-16字节，允许字母数字下划线"
  validates_format_of :password, :with => /^[a-zA-Z0-9_]{5,15}$/i,:message => "密码格式:允许6-16字节，允许字母数字下划线"



  attr_accessor :password_comfire
  validates_confirmation_of :password,:message => "两次输入密码不一致"

  def login(session)
    u = User.find_by_login_name_and_password(self.login_name,User.do_password_hash(self.password))
    if u
      session[:is_login] = true
      session[:login_name] = u.login_name
      session[:login_id] = u.id
    else
      errors.add(:login_name, "用户名密码错误")
      return false
    end
  end

  def self.logout(session)
    session[:is_login] = nil
  end

  def self.do_password_hash(password = nil)
    Digest::SHA1.hexdigest(password) if password
  end

  def before_create
    # hash the pass before creating a author
    self.password = User.do_password_hash(self.password)
  end
end
