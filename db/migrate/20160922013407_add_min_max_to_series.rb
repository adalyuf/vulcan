class AddMinMaxToSeries < ActiveRecord::Migration[5.0]
  def change
    add_column :series, :min_date, :date
    add_column :series, :max_date, :date
  end
end
