class AddUserIdToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :user_id, :integer
    add_index :services, :user_id
  end
end
