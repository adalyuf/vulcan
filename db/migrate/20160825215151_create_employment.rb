class CreateEmployment < ActiveRecord::Migration[5.0]
  def change
    create_table :employment_statuses do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    EmploymentStatus.where(name: "Not specified", description: "This series does not have employment as an attribute").first_or_create
    EmploymentStatus.where(name: "All age ranges", description: "Employment is a series attribute and all values are included").first_or_create
    EmploymentStatus.where(name: "No answer provided", description: "Employment is a series attribute however no value was recorded").first_or_create

    EmploymentStatus.where(name: "Employed full time", description: "Employed full time").first_or_create
    EmploymentStatus.where(name: "Employed part time", description: "Employed part time").first_or_create
    EmploymentStatus.where(name: "Self employed", description: "Runs their own business, not employed by others").first_or_create
    EmploymentStatus.where(name: "Retired", description: "Retired from work").first_or_create
    EmploymentStatus.where(name: "Not employed - All", description: "Includes all reasons for not being employed").first_or_create
    EmploymentStatus.where(name: "Not employed - Did not search", description: "Did not search for work in previous year").first_or_create
    EmploymentStatus.where(name: "Not employed - Searched", description: "Searched for work in previous year").first_or_create
    EmploymentStatus.where(name: "Not employed - Discouraged", description: "Discouraged over job prospects, believe no job is available").first_or_create
    EmploymentStatus.where(name: "Not employed - Family", description: "Family responsibilities prevent work").first_or_create
    EmploymentStatus.where(name: "Not employed - School", description: "Currently in school or training").first_or_create
    EmploymentStatus.where(name: "Not employed - Ill", description: "Ill health or disability prevents work").first_or_create
    EmploymentStatus.where(name: "Not employed - Other", description: "Other reason for not able to work, including transportation problems").first_or_create

    add_index :employment_statuses, :name, unique: true
    add_column :series, :employment_status_raw, :text
    add_reference :series, :employment_status, foreign_key: true, null: false
  end
end
