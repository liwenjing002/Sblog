class BlogController < ApplicationController
  def list
p params[:type]
 render :layout => false
  end
end
