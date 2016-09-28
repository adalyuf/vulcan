class CreateDashboardItems < ActiveRecord::Migration[5.0]
  def change
    create_table :dashboard_items do |t|
      t.references :dashboard, null:false
      t.references :user, null: false
      t.references :indicator, null: false
      t.references :series
      t.integer :sort_order
    end
  end
end
