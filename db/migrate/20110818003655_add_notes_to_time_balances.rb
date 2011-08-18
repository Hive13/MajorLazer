class AddNotesToTimeBalances < ActiveRecord::Migration
  def change
    add_column :time_balances, :notes, :string
  end
end
