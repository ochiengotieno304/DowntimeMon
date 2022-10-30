class AddIntervalToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :interval, :integer
  end
end
