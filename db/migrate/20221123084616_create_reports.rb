class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.text :reason
      t.string :maintainer
      t.string :duration
      t.datetime :last_downtime

      t.timestamps
    end
  end
end
