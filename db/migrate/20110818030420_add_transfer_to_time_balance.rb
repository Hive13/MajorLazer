class AddTransferToTimeBalance < ActiveRecord::Migration
  def change
    add_column :time_balances, :transfer, :boolean
  end
end
