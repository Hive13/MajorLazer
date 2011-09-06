class TimeBalancesController < ApplicationController
  autocomplete :user, :username, :full => true
  before_filter :authenticate_user!
  
  # GET /time_balances
  # GET /time_balances.json
  def index
    if can? :manage, :all
      @target_id = params[:target_id]
      if @target_id then
        @time_balances = TimeBalance.where(:user_id => @target_id).order("created_at desc" ).page params[:page]
      else
        @time_balances = TimeBalance.order("created_at desc" ).page params[:page]
      end
    else
      @time_balances = TimeBalance.where(:user_id => current_user.id).order("created_at desc").page params[:page]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render :json => @time_balances }
    end
  end

  # GET /time_balances/1
  # GET /time_balances/1.json
  def show
    @time_balance = TimeBalance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @time_balance }
    end
  end

  # GET /time_balances/new
  # GET /time_balances/new.json
  def new
    @time_balance = TimeBalance.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @time_balance }
    end
  end

  def add
    check_admin
    @user = User.find(params[:id])
    @time_balances = TimeBalance.new
  end

  def spend
    @time_balance = TimeBalance.new(params[:time_balance])
    # Only admins can spend other users time
    if cannot? :manage, :all
      @time_balance.user_id = current_user.id
    end
    @time_balance.user_id = current_user.id if not @time_balance.user_id

    # Ensure no trickery with negative numbers in spending ;)
    @time_balance.minutes = -@time_balance.minutes.abs

    if current_user.free_balance > 0 then
      free_balance = FreeMinute.new
      if current_user.free_balance >= @time_balance.minutes.abs
        free_balance.minutes = @time_balance.minutes
        @time_balance.minutes = 0
      else
        free_balance.minutes = -current_user.free_balance
        @time_balance.minutes += current_user.free_balance
      end
      free_balance.user_id = @time_balance.user_id
      free_balance.notes = @time_balance.notes
      @time_balance.notes = "#{@time_balance.notes} (#{free_balance.minutes.abs} Free minutes used)"
      free_balance.expire_on = current_user.last_free_minute.expire_on
      free_balance.save!
    end

    @time_balance.user_id = current_user.id if not @time_balance.user_id
    @time_balance.submitted_by_id = current_user.id
    @time_balance.minutes = 0 if not @time_balance.minutes or @time_balance.minutes == nil

    respond_to do |format|
      if @time_balance.save
        format.html { redirect_to @time_balance, :notice => 'Time balance was successfully created.' }
        format.json { render :json => @time_balance, :status => :created, :location => @time_balance }
      else
        format.html { render :action => "new" }
        format.json { render :json => @time_balance.errors, :status => :unprocessable_entity }
      end
    end

  end

  # GET /time_balances/1/edit
  def edit
    check_admin
    @time_balance = TimeBalance.find(params[:id])
  end

  # POST /time_balances
  # POST /time_balances.json
  def create
    @time_balance = TimeBalance.new(params[:time_balance])
    @time_balance.minutes = 0 if not @time_balance.minutes or @time_balance.minutes == nil

    respond_to do |format|
      if @time_balance.save
        Notifier.new_minutes(@time_balance).deliver
        format.html { redirect_to @time_balance, :notice => 'Time balance was successfully created.' }
        format.json { render :json => @time_balance, :status => :created, :location => @time_balance }
      else
        format.html { render :action => "new" }
        format.json { render :json => @time_balance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /time_balances/1
  # PUT /time_balances/1.json
  def update
    check_admin
    @time_balance = TimeBalance.find(params[:id])

    respond_to do |format|
      if @time_balance.update_attributes(params[:time_balance])
        format.html { redirect_to @time_balance, :notice => 'Time balance was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @time_balance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /time_balances/1
  # DELETE /time_balances/1.json
  def destroy
    check_admin
    @time_balance = TimeBalance.find(params[:id])
    @time_balance.destroy

    respond_to do |format|
      format.html { redirect_to time_balances_url }
      format.json { head :ok }
    end
  end
end
