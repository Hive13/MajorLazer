module TimeBalancesHelper

  def get_balance
    return "0" if not current_user
    bal = current_user.balance
    if bal > 0
      return "<font color=green>#{bal}</font>"
    elsif bal < 0
      return "<font color=red>#{bal}</font>"
    end
    return current_user.balance
  end
end
