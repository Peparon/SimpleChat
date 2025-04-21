class AddFriendIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :friend_id, :string
    add_index :users, :friend_id, unique: true
  end
end
