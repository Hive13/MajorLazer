class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, :unique => true
    add_column :users, :member, :boolean
    add_column :users, :last_payment, :datetime
  end
end
