class AddLongDescriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :series, :description_long, :text
    add_column :indicators, :description_long, :text
  end
end
