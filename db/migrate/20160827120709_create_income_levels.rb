class CreateIncomeLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :income_levels do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    IncomeLevel.where(name: "Not specified", description: "This series does not have income level as an attribute").first_or_create
    IncomeLevel.where(name: "All income levels", description: "Income level is a series attribute and all values are included").first_or_create
    IncomeLevel.where(name: "No answer provided", description: "Income is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

    add_index :income_levels, :name, unique: true
    add_column :series, :income_level_raw, :text
    add_reference :series, :income_level, foreign_key: true, null: false
  end
end
