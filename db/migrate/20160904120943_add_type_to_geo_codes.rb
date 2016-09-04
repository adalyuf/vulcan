class AddTypeToGeoCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :geo_codes, :type, :text
    add_column :geo_codes, :fips_code, :integer
    add_column :geo_codes, :short_name, :text
    add_column :geo_codes, :gnis_code, :integer

    remove_index :geo_codes, column: :name
    add_index :geo_codes, [:type, :internal_name], unique: true

  end
end
