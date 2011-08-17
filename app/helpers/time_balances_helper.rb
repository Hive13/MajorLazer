module TimeBalancesHelper

  def get_balance
    return "0m" if not current_user
    bal = current_user.balance
    if bal > 0
      return "<font color=green>#{bal}</font>m"
    elsif bal < 0
      return "<font color=red>#{bal}</font>m"
    end
    return "#{current_user.balance}m"
  end
end
