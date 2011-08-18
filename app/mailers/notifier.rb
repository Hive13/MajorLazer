class Notifier < ActionMailer::Base
  default :from => "no-reply@hive13.org"

  def new_minutes(time_balance)
    @account = User.find(time_balance.user_id)
    @submitter = User.find(time_balance.submitted_by_id)
    @minutes = time_balance.minutes
    @notes = time_balance.notes
    mail(:to => @account.email) do |format|
      format.text
      format.html
    end
  end
end
