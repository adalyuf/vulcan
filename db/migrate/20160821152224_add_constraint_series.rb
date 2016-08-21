class AddConstraintSeries < ActiveRecord::Migration[5.0]
  def change
    change_column_null(:series, :indicator_id, false)
    change_column_null(:series, :frequency_id, false)
    change_column_null(:series, :unit_id, false)
  end
end
