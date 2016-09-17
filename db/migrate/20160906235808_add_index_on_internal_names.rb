class AddIndexOnInternalNames < ActiveRecord::Migration[5.0]
  def change
    add_index :categories, :internal_name, unique: true
    add_index :frequencies, :internal_name, unique: true
    add_index :units, :internal_name, unique: true
    add_index :genders, :internal_name, unique: true
    add_index :races, :internal_name, unique: true
    add_index :age_brackets, :internal_name, unique: true
    add_index :marital_statuses, :internal_name, unique: true
    add_index :employment_statuses, :internal_name, unique: true
    add_index :education_levels, :internal_name, unique: true
    add_index :child_statuses, :internal_name, unique: true
    add_index :income_levels, :internal_name, unique: true
    add_index :industry_codes, :internal_name, unique: true
    add_index :occupation_codes, :internal_name, unique: true
    add_index :geo_codes, :internal_name, unique: true
    add_index :indicators, :internal_name, unique: true
    add_index :series, :internal_name, unique: true
  end
end
