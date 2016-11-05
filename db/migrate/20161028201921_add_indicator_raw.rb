class AddIndicatorRaw < ActiveRecord::Migration[5.0]
  def change
    add_column :series, :indicator_raw_id, :text
    add_column :series, :indicator_raw, :text
  end
end
