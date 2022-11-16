class AddLastDownToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :last_down, :date
  end
end
