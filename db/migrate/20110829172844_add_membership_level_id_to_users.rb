class AddMembershipLevelIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :membership_level_id, :integer
  end
end
