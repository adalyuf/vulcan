class CreateGeoCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :geo_codes do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    add_index :geo_codes, :name, unique: true
    add_column :series, :geo_code_raw, :text
    add_reference :series, :geo_code, foreign_key: true, null: false
  end
end
