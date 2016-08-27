class CreateGeoCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :geo_codes do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    GeoCode.where(name: "Not specified", description: "This series does not have geography as an attribute").first_or_create
    # Does this ever happen? When would we not be able to get a geographic description?
    # Perhaps we use temporarily in dev then remove this and force a geographic definition explicitly
    GeoCode.where(name: "All geographies", description: "Geography is a series attribute and all values are included").first_or_create
    GeoCode.where(name: "No answer provided", description: "Geography is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

    add_index :geo_codes, :name, unique: true
    add_column :series, :geo_code_raw, :text
    add_reference :series, :geo_code, foreign_key: true, null: false
  end
end
