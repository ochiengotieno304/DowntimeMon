class AddStatusHistoryToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :status_history, :string, array: true, default:[]
  end
end
