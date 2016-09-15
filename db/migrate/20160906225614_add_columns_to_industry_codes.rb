class AddColumnsToIndustryCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :industry_codes, :industry_type, :text
    add_column :industry_codes, :naics_code, :integer
  end
end
