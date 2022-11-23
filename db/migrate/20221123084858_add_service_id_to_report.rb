class AddServiceIdToReport < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :service_id, :integer
    add_index :reports, :service_id
  end
end
