class UpdateExternalTables < ActiveRecord::Migration[5.0]
  def change
    change_column :external_tables, :external_id,  :string
  end
end
