class AddParentIdToGeo < ActiveRecord::Migration[5.0]
  def change
    add_column :geo_codes, :parent_id, :integer
  end
end
