class CreateTimeBalances < ActiveRecord::Migration
  def change
    create_table :time_balances do |t|
      t.integer :user_id
      t.integer :minutes
      t.integer :submitted_by_id
      t.datetime :transaction_time

      t.timestamps
    end
  end
end
