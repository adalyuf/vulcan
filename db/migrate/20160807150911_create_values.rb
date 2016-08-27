class CreateValues < ActiveRecord::Migration[5.0]
  def change
    create_table :indicators do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    create_table :frequencies do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    create_table :units do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    create_table :series do |t|
      t.text :name
      t.text :description
      t.integer :multiplier
      t.boolean :seasonally_adjusted
      t.references :indicator, foreign_key: true
      t.references :frequency, foreign_key: true
      t.references :unit, foreign_key: true
      t.timestamps
    end

    create_table :values do |t|
      t.text :raw_name
      t.integer :raw_year
      t.text :raw_period
      t.text :raw_value
      t.date :date #By convention the first day of the relevant period
      t.float :value
      t.references :series, foreign_key: true
      t.references :indicator, foreign_key: true
      t.timestamps
    end

    add_index :indicators, :name, unique: true
    add_index :series, :name, unique: true
    add_index :values, [:raw_name, :raw_year, :raw_period, :raw_value], unique: true, name: 'index_values_on_name_year_period_value'
  end
end
