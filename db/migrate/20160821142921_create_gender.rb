class CreateGender < ActiveRecord::Migration[5.0]
  def change
    create_table :genders do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    add_index :genders, :name, unique: true
    add_column :series, :gender_raw, :text, null: false
    add_reference :series, :gender, foreign_key: true, null: false
  end
end
