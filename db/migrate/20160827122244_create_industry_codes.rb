class CreateIndustryCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :industry_codes do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    add_index :industry_codes, :name, unique: true
    add_column :series, :industry_code_raw, :text
    add_reference :series, :industry_code, foreign_key: true, null: false
  end
end
