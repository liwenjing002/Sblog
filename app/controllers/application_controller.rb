# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :set_locale,:is_login,:init_blogs

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] || I18n.default_locale
    locale_path = "#{LOCALES_DIRECTORY}#{I18n.locale}.yml"
    unless I18n.load_path.include? locale_path
      I18n.load_path << locale_path
      I18n.backend.send(:init_translations)
    end
  rescue Exception => err
    logger.error err
    flash.now[:notice] = "#{I18n.locale} translation not available"
    I18n.load_path -= [locale_path]
    I18n.locale = session[:locale] = I18n.default_locale
  end

  def redirect_back_or_default default
    if session[:return_to] &&
        session[:return_to] != "/home" &&
        session[:return_to] != "#{request.request_uri}" &&
        !session[:return_to].include?( request.path)
      redirect_to(session[:return_to])
      session[:return_to] = nil
      return
    else
      redirect_to(default)
      return
    end
  end

  def is_login
    if session[:is_login]==nil &&request.request_uri!= "/user/login"&&
        request.parameters[:controller] != "home" && session[:return_to] != "/"&&
        request.parameters[:controller] !='user'&&
        request.parameters[:controller]!= "about"&&
        (request.parameters[:action]!='blog_detail')
      session[:return_to] = request.request_uri
      redirect_to :controller=>"user",:action=>"login"
    end
  end


#  rescue_from Exception, :with => :error

def error
  render :file => "error/exception_error",:layout => "temp2"
end

protected
 def rescue_action(exception)
     if RAILS_ENV == 'production'
       title = "[Exception Notify] from sblog"
       Mailer.deliver_system_exception title, exception
       from =  APP_CONFIG["my_email"]
      subject = "[Exception Notify] from sblog"
      message = exception
      to =  APP_CONFIG["my_email"]
       Mailer.delay.deliver_send(from,to ,subject, message) if DELAY_JOB
       Mailer.deliver_send(from,to ,subject, message) if !DELAY_JOB
     end
     super exception  #super
   end


#初始化一些博客，由于右边的工具栏，几乎一直存在导致每个页面都需要@blogs对象和时间列表@date_list
def init_blogs
  @blogs =Blog.paginate :per_page => 5, :page => 1

   @date_list = Blog.find_by_sql("select to_char(updated_at,'YYYY-MM') as dates \
                    from blogs  group by dates order by dates asc limit 10")
end


end
