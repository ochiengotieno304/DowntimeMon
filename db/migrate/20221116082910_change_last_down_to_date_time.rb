class ChangeLastDownToDateTime < ActiveRecord::Migration[7.0]
  def change
    change_column :services, :last_down, :datetime
  end
end
