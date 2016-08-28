class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    add_index :categories, :name, unique: true
    add_reference :indicators, :category, foreign_key: true, null: false
  end
end
