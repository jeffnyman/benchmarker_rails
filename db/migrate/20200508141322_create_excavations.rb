class CreateExcavations < ActiveRecord::Migration[6.0]
  def change
    create_table :excavations do |t|
      t.string :name
      t.date :ideal_finish_date

      t.timestamps
    end
  end
end
