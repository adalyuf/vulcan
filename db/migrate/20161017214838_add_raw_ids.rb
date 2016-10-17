class AddRawIds < ActiveRecord::Migration[5.0]
  def change
    add_column :series, :gender_raw_id, :text
    add_column :series, :race_raw_id, :text
    add_column :series, :marital_status_raw_id, :text
    add_column :series, :age_bracket_raw_id, :text
    add_column :series, :employment_status_raw_id, :text
    add_column :series, :education_level_raw_id, :text
    add_column :series, :child_status_raw_id, :text
    add_column :series, :income_level_raw_id, :text
    add_column :series, :industry_code_raw_id, :text
    add_column :series, :occupation_code_raw_id, :text
    add_column :series, :geo_code_raw_id, :text
    add_column :series, :unit_raw_id, :text
    add_column :series, :unit_raw, :text
  end
end
