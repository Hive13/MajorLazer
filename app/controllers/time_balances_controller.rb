class TimeBalancesController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /time_balances
  # GET /time_balances.json
  def index
    if can? :manage, :all
      @time_balances = TimeBalance.all
    else
      @time_balances = TimeBalance.where(:user_id => current_user.id)
    end

    respond_to do |format|
      format.html # index.html.erb
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
    # Ensure no trickery with negative numbers in spending ;)
    @time_balance.minutes = -@time_balance.minutes.abs

    @time_balance.user_id = current_user.id if not @time_balance.user_id
    @time_balance.submitted_by_id = current_user.id

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
