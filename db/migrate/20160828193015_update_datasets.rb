class UpdateDatasets < ActiveRecord::Migration[5.0]
  def change
    change_column :datasets, :name,  :text
    change_column :datasets, :internal_name, :text
    add_column :datasets, :description, :text

    add_index :datasets, :name, unique: true
    add_index :datasets, :internal_name, unique: true
    add_reference :indicators, :dataset, foreign_key: true, null: false
  end
end
