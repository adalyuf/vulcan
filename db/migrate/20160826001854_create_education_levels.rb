class CreateEducationLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :education_levels do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    add_index :education_levels, :name, unique: true
    add_column :series, :education_level_raw, :text
    add_reference :series, :education_level, foreign_key: true, null: false
  end
end
