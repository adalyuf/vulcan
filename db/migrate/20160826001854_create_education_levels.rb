class CreateEducationLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :education_levels do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    EducationLevel.where(name: "Not specified", description: "This series does not have education level as an attribute").first_or_create
    EducationLevel.where(name: "All education levels", description: "Education level is a series attribute and all values are included").first_or_create
    EducationLevel.where(name: "No answer provided", description: "Education is a series attribute however no value was recorded").first_or_create

    EducationLevel.where(name: "Some High School or High School Graduate", description: "Some High School or High School Graduate").first_or_create
    EducationLevel.where(name: "Less than a High School diploma", description: "Less than a High School diploma").first_or_create
    EducationLevel.where(name: "Less than 1 year of High School", description: "Less than 1 year of High School").first_or_create
    EducationLevel.where(name: "4 years of High School, no diploma", description: "4 years of High School, no diploma").first_or_create
    EducationLevel.where(name: "High School graduates, no college", description: "High School graduates, no college").first_or_create
    EducationLevel.where(name: "Some college or associate degree", description: "Some college or associate degree").first_or_create
    EducationLevel.where(name: "Some college, no degree", description: "Some college, no degree").first_or_create
    EducationLevel.where(name: "Associate degree", description: "Associate degree").first_or_create
    EducationLevel.where(name: "Associate degree, occupational program", description: "Associate degree, occupational program").first_or_create
    EducationLevel.where(name: "Associate degree, academic program", description: "Associate degree, academic program").first_or_create
    EducationLevel.where(name: "Bachelor's degree and higher", description: "Bachelor's degree and higher").first_or_create
    EducationLevel.where(name: "Bachelor's degree only", description: "Bachelor's degree only").first_or_create
    EducationLevel.where(name: "Advanced degree", description: "Advanced degree").first_or_create
    EducationLevel.where(name: "Master's degree", description: "Master's degree").first_or_create
    EducationLevel.where(name: "Professional degree", description: "Professional degree").first_or_create
    EducationLevel.where(name: "Doctoral degree", description: "Doctoral degree").first_or_create


    add_index :education_levels, :name, unique: true
    add_column :series, :education_level_raw, :text
    add_reference :series, :education_level, foreign_key: true, null: false
  end
end
