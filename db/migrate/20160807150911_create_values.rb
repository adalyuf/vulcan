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

    Frequency.where(name: "Annual", description: "Annual").first_or_create
    Frequency.where(name: "Monthly", description: "Monthly").first_or_create
    Frequency.where(name: "Quarterly", description: "Quarterly").first_or_create

    create_table :units do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    Unit.where(name: "Nominal US Dollars", description: "US Dollars, not adjusted for inflation" ).first_or_create
    Unit.where(name: "Real US Dollars", description: "US Dollars adjusted for inflation" ).first_or_create
    Unit.where(name: "Percent", description: "Typically a percent difference from a prior period").first_or_create
    Unit.where(name: "Jobs", description: "Number of jobs").first_or_create
    Unit.where(name: "Establishments", description: "Number of Establishments, primarily businesses.").first_or_create

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
      t.float :value #Should this be the raw value and calculated on the fly or stored as its true value? i.e. 14 (*million) or 14 000 000. For calculations with other series, this should be stores as true value.
      t.references :series, foreign_key: true
      t.references :indicator, foreign_key: true
      t.timestamps
    end

    add_index :indicators, :name, unique: true
    add_index :series, :name, unique: true
    add_index :values, [:raw_name, :raw_year, :raw_period, :raw_value], unique: true, name: 'index_values_on_name_year_period_value'
  end
end
