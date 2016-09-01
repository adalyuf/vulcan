class AddInternalNames < ActiveRecord::Migration[5.0]
  def change
    #Syntax for SEO and uniqueness: prefix with source, lowercase, full name, separated by hyphens
    # bls-average-prices
    add_column :categories, :internal_name, :text, null:false
    add_column :frequencies, :internal_name, :text, null:false
    add_column :units, :internal_name, :text, null:false
    add_column :genders, :internal_name, :text, null:false
    add_column :races, :internal_name, :text, null:false
    add_column :age_brackets, :internal_name, :text, null:false
    add_column :marital_statuses, :internal_name, :text, null:false
    add_column :employment_statuses, :internal_name, :text, null:false
    add_column :education_levels, :internal_name, :text, null:false
    add_column :child_statuses, :internal_name, :text, null:false
    add_column :income_levels, :internal_name, :text, null:false
    add_column :industry_codes, :internal_name, :text, null:false
    add_column :occupation_codes, :internal_name, :text, null:false
    add_column :geo_codes, :internal_name, :text, null:false
  end
end
