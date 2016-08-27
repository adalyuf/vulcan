class CreateIndustryCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :industry_codes do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    IndustryCode.where(name: "Not specified", description: "This series does not have industry as an attribute").first_or_create
    IndustryCode.where(name: "All industries", description: "Industry is a series attribute and all values are included").first_or_create
    IndustryCode.where(name: "No answer provided", description: "Industry is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

    add_index :industry_codes, :name, unique: true
    add_column :series, :industry_code_raw, :text
    add_reference :series, :industry_code, foreign_key: true, null: false
  end
end
