class CreateOccupations < ActiveRecord::Migration[5.0]
  def change
    create_table :occupation_codes do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    add_index :occupation_codes, :name, unique: true
    add_column :series, :occupation_code_raw, :text
    add_reference :series, :occupation_code, foreign_key: true, null: false
  end
end
