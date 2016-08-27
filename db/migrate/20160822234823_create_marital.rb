class CreateMarital < ActiveRecord::Migration[5.0]
  def change
    create_table :marital_statuses do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    add_index :marital_statuses, :name, unique: true
    add_column :series, :marital_status_raw, :text
    add_reference :series, :marital_status, foreign_key: true, null: false
  end
end
