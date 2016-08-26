class CreateGender < ActiveRecord::Migration[5.0]
  def change
    create_table :genders do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    Gender.where(name: "Not specified", description: "Gender not specified or not applicable to this series").first_or_create
    Gender.where(name: "All genders", description: "Both male and female genders included in this series").first_or_create
    Gender.where(name: "Male", description: "Male").first_or_create
    Gender.where(name: "Female", description: "Female").first_or_create

    add_index :genders, :name, unique: true
    add_column :series, :gender_raw, :text, null: false
    add_reference :series, :gender, foreign_key: true, null: false
  end
end