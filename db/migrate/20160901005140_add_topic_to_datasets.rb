class AddTopicToDatasets < ActiveRecord::Migration[5.0]
  def change
    add_reference :datasets, :category, foreign_key: true, null: false
  end
end
