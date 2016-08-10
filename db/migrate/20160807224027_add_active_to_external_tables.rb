class AddActiveToExternalTables < ActiveRecord::Migration[5.0]
  def change
    add_column :external_tables, :active, :boolean, default: true
  end
end
