class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  def index
    # TODO - Make this a DB entry
    reset_at = '2011-10-22'
    minutes_spent = TimeBalance.where("minutes < 0 and created_at > '#{reset_at}'")
    free_spent = FreeMinute.where("minutes < 0 and created_at > '#{reset_at}'")
    @total_spent = 0
    @last_spent = 0
    last_date = reset_at
    minutes_spent.each do |min|
      @total_spent += min.minutes.abs
      if min.created_at > last_date then
        @last_spent = min.minutes.abs 
        last_date = min.created_at
      end
    end
    free_spent.each do |min|
      @total_spent += min.minutes.abs
      if min.created_at > last_date then
        @last_spent = min.minutes.abs 
        last_date = min.created_at
      end
    end
  end

  def transfer_setup 
    @time_balance = TimeBalance.new
  end

  def transfer
    @time_balance = TimeBalance.new(params[:time_balance])
    @time_balance.minutes = 0 if not @time_balance.minutes or @time_balance.minutes == nil
    @time_balance.transfer = true
    @time_balance.submitted_by_id = current_user.id
    reciever = User.find(@time_balance.user_id)

    if @time_balance.minutes.abs > current_user.balance
      redirect_to home_transfer_setup, :notice => 'You do not have enough minutes.' 
    elsif @time_balance.minutes == 0
      redirect_to home_transfer_setup, :notice => 'You can not transfer 0 minutes...douche.' 
    end

    @time_balance.notes = "Transfer from #{current_user.name} to #{reciever.name}"
    @time_balance.minutes = @time_balance.minutes.abs

    withdrawl = TimeBalance.new
    withdrawl.user_id = current_user.id
    withdrawl.minutes = -@time_balance.minutes.abs
    withdrawl.submitted_by_id = current_user.id
    withdrawl.notes = @time_balance.notes
    withdrawl.transfer = true

    TimeBalance.transaction do
     withdrawl.save!
     @time_balance.save!
    end

    respond_to do |format|
      Notifier.new_minutes(@time_balance).deliver
      format.html { redirect_to time_balances_path, :notice => 'Transfer was successful.' }
      format.json { render :json => time_balances_path, :status => :created, :location => @time_balance }
    end
  end

end
