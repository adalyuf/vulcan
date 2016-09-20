class AddDashboards < ActiveRecord::Migration[5.0]
  def change
    create_table :dashboards do |t|
      t.text :name
      t.text :description
      t.references :user, null:false
      t.timestamps
    end
  end
end
