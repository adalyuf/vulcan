class AddDescriptionToDatasets < ActiveRecord::Migration[5.0]
  def change
      add_column :datasets, :description, :text
  end
end
