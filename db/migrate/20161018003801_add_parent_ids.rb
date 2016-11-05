class AddParentIds < ActiveRecord::Migration[5.0]
  def change
    add_column :industry_codes, :parent_id, :integer
  end
end
