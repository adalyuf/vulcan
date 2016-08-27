class CreateIncomeLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :income_levels do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    add_index :income_levels, :name, unique: true
    add_column :series, :income_level_raw, :text
    add_reference :series, :income_level, foreign_key: true, null: false
  end
end
