class AddRace < ActiveRecord::Migration[5.0]
  def change
    create_table :races do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    add_index :races, :name, unique: true
    add_column :series, :race_raw, :text
    add_reference :series, :race, foreign_key: true, null: false
    change_column_null(:series, :gender_raw, true)
  end
end
