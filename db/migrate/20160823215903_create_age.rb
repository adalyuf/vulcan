class CreateAge < ActiveRecord::Migration[5.0]
  def change
    create_table :age_brackets do |t|
      t.text :name
      t.text :description
      t.timestamps
    end

    AgeBracket.where(name: "Not specified", description: "Age ranges were not specified or not applicable to this series").first_or_create
    AgeBracket.where(name: "All age ranges", description: "All values for age ranges were included in this series").first_or_create
    AgeBracket.where(name: "No answer provided", description: "An age question was asked, no answer was provided").first_or_create

    AgeBracket.where(name: "20-24", description: "Ages 20-24 inclusive").first_or_create
    AgeBracket.where(name: "25-29", description: "Ages 25-29 inclusive").first_or_create
    AgeBracket.where(name: "30-34", description: "Ages 30-34 inclusive").first_or_create
    AgeBracket.where(name: "35-39", description: "Ages 35-39 inclusive").first_or_create
    AgeBracket.where(name: "40-44", description: "Ages 40-44 inclusive").first_or_create
    AgeBracket.where(name: "45-49", description: "Ages 45-49 inclusive").first_or_create
    AgeBracket.where(name: "50-54", description: "Ages 50-54 inclusive").first_or_create
    AgeBracket.where(name: "55-59", description: "Ages 55-59 inclusive").first_or_create
    AgeBracket.where(name: "60-64", description: "Ages 60-64 inclusive").first_or_create
    AgeBracket.where(name: "65+", description: "Age 65 or older, includes 65").first_or_create

    AgeBracket.where(name: "16-19", description: "Ages 16-19 inclusive").first_or_create
    AgeBracket.where(name: "Under 16", description: "Less than 16 years of age, excluding 16").first_or_create
    AgeBracket.where(name: "18-24", description: "Ages 18-24 inclusive").first_or_create
    AgeBracket.where(name: "Under 18", description: "Less than 18 years of age, excluding 18").first_or_create
    AgeBracket.where(name: "Under 5", description: "Less than 5 years of age, excluding 5").first_or_create
    AgeBracket.where(name: "05-17", description: "Ages 5-17 inclusive").first_or_create

    AgeBracket.where(name: "20-29", description: "Ages 20-29 inclusive").first_or_create
    AgeBracket.where(name: "30-39", description: "Ages 30-39 inclusive").first_or_create
    AgeBracket.where(name: "40-49", description: "Ages 40-49 inclusive").first_or_create
    AgeBracket.where(name: "50-59", description: "Ages 50-59 inclusive").first_or_create
    AgeBracket.where(name: "60-69", description: "Ages 60-69 inclusive").first_or_create
    AgeBracket.where(name: "70+", description: "Age 70 or older, includes 70").first_or_create

    AgeBracket.where(name: "25-34", description: "Ages 25-34 inclusive").first_or_create
    AgeBracket.where(name: "35-44", description: "Ages 35-44 inclusive").first_or_create
    AgeBracket.where(name: "45-54", description: "Ages 45-54 inclusive").first_or_create
    AgeBracket.where(name: "55-64", description: "Ages 55-64 inclusive").first_or_create
    # AgeBracket.where(name: "65+", description: "Age 65 or older, includes 65").first_or_create

    add_index :age_brackets, :name, unique: true
    add_column :series, :age_bracket_raw, :text
    add_reference :series, :age_bracket, foreign_key: true, null: false
  end
end
