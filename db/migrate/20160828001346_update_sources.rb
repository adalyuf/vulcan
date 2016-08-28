class UpdateSources < ActiveRecord::Migration[5.0]
  def change
    change_column :sources, :name,  :text
    change_column :sources, :internal_name, :text

    add_index :sources, :name, unique: true
    add_index :sources, :internal_name, unique: true
    add_reference :indicators, :source, foreign_key: true, null: false
  end
end
