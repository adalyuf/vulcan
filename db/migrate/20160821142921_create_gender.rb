class CreateGender < ActiveRecord::Migration[5.0]
  def change
    create_table :genders do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    Gender.where(name: "All genders", description: "Both male and female or not specified").first_or_create
    Gender.where(name: "Male", description: "Male").first_or_create
    Gender.where(name: "Female", description: "Female").first_or_create

    add_index :genders, :name, unique: true
    add_column :series, :raw_gender, :text, null: false
    add_reference :series, :gender, foreign_key: true, null: false
  end
end
