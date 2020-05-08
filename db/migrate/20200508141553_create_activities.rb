class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.references :excavation, null: false, foreign_key: true
      t.string :name
      t.integer :cost
      t.datetime :completed

      t.timestamps
    end
  end
end
