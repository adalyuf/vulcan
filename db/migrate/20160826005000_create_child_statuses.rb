class CreateChildStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :child_statuses do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    add_index :child_statuses, :name, unique: true
    add_column :series, :child_status_raw, :text
    add_reference :series, :child_status, foreign_key: true, null: false
  end
end
