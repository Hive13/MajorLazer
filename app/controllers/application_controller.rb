class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  def check_admin
    raise CanCan::AccessDenied unless can? :manage, :all
  end

end
