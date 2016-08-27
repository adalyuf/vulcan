class CreateAge < ActiveRecord::Migration[5.0]
  def change
    create_table :age_brackets do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    add_index :age_brackets, :name, unique: true
    add_column :series, :age_bracket_raw, :text
    add_reference :series, :age_bracket, foreign_key: true, null: false
  end
end
