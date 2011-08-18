class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  def index
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
