class CreateChildStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :child_statuses do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    ChildStatus.where(name: "Not specified", description: "This series does not have education level as an attribute").first_or_create
    ChildStatus.where(name: "All education levels", description: "Education level is a series attribute and all values are included").first_or_create
    ChildStatus.where(name: "No answer provided", description: "Education is a series attribute however no value was recorded").first_or_create

    #We need to refine these as more child in household definitions are encountered.
    ChildStatus.where(name: "No child present in household under 18", description: "No child present in household under 18").first_or_create
    ChildStatus.where(name: "Child under 6 present", description: "Child under 6 present").first_or_create
    ChildStatus.where(name: "Child 6-12 present", description: "Child 6-12 present").first_or_create
    ChildStatus.where(name: "Child 13-17 present", description: "Child 13-17 present").first_or_create
    ChildStatus.where(name: "Child under 18 present", description: "Child under 18 present").first_or_create
    ChildStatus.where(name: "Child under 3 present", description: "Child under 3 present").first_or_create

    add_index :child_statuses, :name, unique: true
    add_column :series, :child_status_raw, :text
    add_reference :series, :child_status, foreign_key: true, null: false
  end
end
