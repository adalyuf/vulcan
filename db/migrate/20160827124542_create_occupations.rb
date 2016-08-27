class CreateOccupations < ActiveRecord::Migration[5.0]
  def change
    create_table :occupations do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    Occupation.where(name: "Not specified", description: "This series does not have occupation as an attribute").first_or_create
    Occupation.where(name: "All occupations", description: "Occupation is a series attribute and all values are included").first_or_create
    Occupation.where(name: "No answer provided", description: "Occupation is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

    add_index :occupations, :name, unique: true
    add_column :series, :occupation_raw, :text
    add_reference :series, :occupation, foreign_key: true, null: false
  end
end
