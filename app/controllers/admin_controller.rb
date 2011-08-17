class AdminController < ApplicationController
  before_filter :check_admin

  def check_admin
    raise CanCan::AccessDenied unless can? :manage, :all
  end

  def index
  end

end
