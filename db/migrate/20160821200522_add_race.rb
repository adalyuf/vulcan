class AddRace < ActiveRecord::Migration[5.0]
  def change
    create_table :races do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    Race.where(name: "Not specified", description: "Race not specified or not applicable to this series").first_or_create
    Race.where(name: "All races", description: "All values for race were included in this series").first_or_create
    Race.where(name: "White", description: "White").first_or_create
    Race.where(name: "Black", description: "Black or African American").first_or_create
    Race.where(name: "Asian", description: "Asian").first_or_create
    Race.where(name: "Hispanic", description: "Hispanic. Values for this series are often reported separately and may include values from other series.").first_or_create

    add_index :races, :name, unique: true
    add_column :series, :race_raw, :text
    add_reference :series, :race, foreign_key: true, null: false
    change_column_null(:series, :gender_raw, true)
  end
end
