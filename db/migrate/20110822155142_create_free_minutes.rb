class CreateFreeMinutes < ActiveRecord::Migration
  def change
    create_table :free_minutes do |t|
      t.integer :user_id
      t.integer :minutes
      t.datetime :expire_on
      t.string :notes

      t.timestamps
    end
  end
end
