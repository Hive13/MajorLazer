class AdminController < ApplicationController
  before_filter :check_admin

  def index
    @users = User.order("last_sign_in_at desc").page params[:page]
  end

  def edit_user
    @user = User.find(params[:id])
  end

  def edited_user

    new_info = params[:user]
    @user = User.find(new_info["id"])
    member_level = params[:membership_level]["name"].to_i

    if new_info["certified"] then
      if new_info["certified"] == "1" then
        @user.certified = true
      else
        @user.certified = false
      end
    end
    if member_level then
      if member_level > 1 then
        @user.member = true
      else
        @user.member = false
      end
      @user.membership_level_id = member_level
    end

    respond_to do |format|
      if @user.update_attributes(:certified => @user.certified, :meber => @user.member, :mebership_level_id => @user.membership_level_id)
        format.html { redirect_to admin_index_path, :notice => 'User updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end

  end

end
