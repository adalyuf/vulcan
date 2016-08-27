class CreateEmployment < ActiveRecord::Migration[5.0]
  def change
    create_table :employment_statuses do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    add_index :employment_statuses, :name, unique: true
    add_column :series, :employment_status_raw, :text
    add_reference :series, :employment_status, foreign_key: true, null: false
  end
end
