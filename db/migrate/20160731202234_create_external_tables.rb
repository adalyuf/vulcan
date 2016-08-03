class CreateExternalTables < ActiveRecord::Migration[5.0]
  def change
    create_table :sources do |t|
      t.string :name
      t.string :internal_name
      t.timestamps
    end

    create_table :datasets do |t|
      t.string :name
      t.string :internal_name
      t.references :source
      t.timestamps
    end

    create_table :external_tables do |t|
      t.integer :external_id
      t.string :external_name
      t.references :dataset
      t.timestamps
    end
  end
end
