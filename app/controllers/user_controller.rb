class UserController < ApplicationController

  def login
    @user_login = User.new(params[:user])
    @user = User.new()
    return unless request.post?
    if @user_login.email&& @user_login.email!= ''
      return redirect_to :action=>"forget_password",:email=> @user_login.email
    end
    if @user_login.login(session)
      flash[:notice] = "Hello! #{@user_login.alias_name||@user_login.login_name},"+ I18n.t('welcome_word')
      return redirect_back_or_default('/home')
    end
  end

  def logout
    User.logout(session)
    redirect_back_or_default ('/home')
  end

  def signup
    redirect_to :action=>"login" if !request.post?
    @user = User.new(params[:user])
     @user_login = User.new()
    if @user.save
      session[:is_login] = true
      session[:login_name] = @user.login_name
      flash[:notice] = "Hello! #{@user.alias_name||@user.login_name},"+ I18n.t('welcome_word')
      Mailer.delay.deliver_signup_send(@user)
      redirect_to :controller => "home"
    else
      @signup= true
      render :action=> "login"
    end
  end

  def forget_password
    user = User.find_by_email(params[:email])
    if user
      Mailer.delay.deliver_get_password(user)
      flash[:notice] = I18n.t('password_send')
    else
      flash[:notice] = I18n.t('no_email')
    end
    @user = User.new()
    render :action=> "login"
  end




end
