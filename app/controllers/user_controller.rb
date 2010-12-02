class UserController < ApplicationController

  def login
    @user = User.new(params[:user])
    return unless request.post?
    if @user.email&& @user.email!= ''
      return redirect_to :action=>"forget_password",:email=> @user.email
    end
    if @user.login(session)
      flash[:notice] = "Hello! #{@user.alias_name||@user.login_name},"+ I18n.t('welcome_word')
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
