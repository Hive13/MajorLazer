class TimeBalancesController < ApplicationController
  # GET /time_balances
  # GET /time_balances.json
  def index
    @time_balances = TimeBalance.all

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

  # GET /time_balances/1/edit
  def edit
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
    @time_balance = TimeBalance.find(params[:id])
    @time_balance.destroy

    respond_to do |format|
      format.html { redirect_to time_balances_url }
      format.json { head :ok }
    end
  end
end
