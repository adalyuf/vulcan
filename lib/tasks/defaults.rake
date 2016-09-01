namespace :defaults do

  #For internal names the syntax for SEO and uniqueness should be to prefix with source, lowercase, use full names, separated by hyphens
  # bls-average-prices

  desc "destroy defaults"
  task :destroy => :environment do
    Category.destroy_all
    Frequency.destroy_all
    Unit.destroy_all
    Gender.destroy_all
    Race.destroy_all
    AgeBracket.destroy_all
    MaritalStatus.destroy_all
    EmploymentStatus.destroy_all
    EducationLevel.destroy_all
    ChildStatus.destroy_all
    IncomeLevel.destroy_all
    IndustryCode.destroy_all
    OccupationCode.destroy_all
    GeoCode.destroy_all
  end

  desc "crate defaults"
  task :create => [:category, :source, :dataset,:frequency, :unit, :gender, :race, :age_bracket, :marital_status, :employment_status, :education_level, :child_status, :income_level, :industry_code, :occupation_code, :geo_code]

  desc "create category records"
  task :category => :environment do
    Category.where(name: "Business", internal_name: :business, description: "Includes agriculture, manufacturing, finance, energy, and trade").first_or_create
    Category.where(name: "Environment", internal_name: :environment, description: "Includes climate, ecosystems, and ocean statistics").first_or_create
    Category.where(name: "Education", internal_name: :education, description: "Education statistics").first_or_create
    Category.where(name: "Health", internal_name: :health, description: "Health statistics").first_or_create
    Category.where(name: "Government", internal_name: :government, description: "Government statistics").first_or_create
    Category.where(name: "Science", internal_name: :science, description: "Science statistics").first_or_create
    Category.where(name: "Safety", internal_name: :safety, description: "Safety statistics, includes crime and disasters").first_or_create
    Category.where(name: "People", internal_name: :people, description: "Includes population, family, housing, and income statistics").first_or_create
  end

  desc "create source records"
  task :source => :environment do
    Source.where(name: "Bureau of Economic Analysis (BEA)", internal_name: :"bureau-economic-analysis").first_or_create
    Source.where(name: "Bureau of Labor Statistics (BLS)", internal_name: :"bureau-labor-statistics").first_or_create
  end

  desc "create dataset records"
  task :dataset => :environment do
    Dataset.where(name: "Average Prices", category_id: Category.find_by(name: "Business").id, internal_name: :"bls-average-prices", source_id: Source.find_by(internal_name: :"bureau-labor-statistics").id, description: "Average prices for goods and services in various cities").first_or_create
    Dataset.where(name: "Business Employment Dynamics", category_id: Category.find_by(name: "Business").id, internal_name: :"bls-business-employment-dynamics", source_id: Source.find_by(internal_name: :"bureau-labor-statistics").id , description: "Track changes in employment at the establishment level").first_or_create
  end

  desc "create frequency records"
  task :frequency => :environment do
    Frequency.where(name: "Annual", internal_name: :annual, description: "Annual").first_or_create
    Frequency.where(name: "Monthly", internal_name: :monthly, description: "Monthly").first_or_create
    Frequency.where(name: "Quarterly", internal_name: :quarterly, description: "Quarterly").first_or_create
  end

  desc "create unit records"
  task :unit => :environment do
    Unit.where(name: "Nominal US Dollars", internal_name: :"nominal-us-dollars" ,description: "US Dollars, not adjusted for inflation" ).first_or_create
    Unit.where(name: "Real US Dollars", internal_name: :"real-us-dollars", description: "US Dollars adjusted for inflation" ).first_or_create
    Unit.where(name: "Percent", internal_name: :percent, description: "Typically a percent difference from a prior period").first_or_create
    Unit.where(name: "Jobs", internal_name: :jobs, description: "Number of jobs").first_or_create
    Unit.where(name: "Establishments", internal_name: :establishments, description: "Number of Establishments, primarily businesses.").first_or_create
  end

  desc "create gender records"
  task :gender => :environment do
    Gender.where(name: "Not specified", internal_name: :"not-specified", description: "Gender not specified or not applicable to this series").first_or_create
    Gender.where(name: "All genders", internal_name: :"all-genders", description: "Both male and female genders included in this series").first_or_create
    Gender.where(name: "Male", internal_name: :male, description: "Male").first_or_create
    Gender.where(name: "Female", internal_name: :female, description: "Female").first_or_create
  end

  desc "create race records"
  task :race => :environment do
    Race.where(name: "Not specified", internal_name: :"not-specified", description: "Race not specified or not applicable to this series").first_or_create
    Race.where(name: "All races", internal_name: :"all-races", description: "All values for race were included in this series").first_or_create
    Race.where(name: "White", internal_name: :white, description: "White").first_or_create
    Race.where(name: "Black", internal_name: :black, description: "Black or African American").first_or_create
    Race.where(name: "Asian", internal_name: :asian, description: "Asian").first_or_create
    Race.where(name: "Hispanic", internal_name: :hispanic, description: "Hispanic. Values for this series are often reported separately and may include values from other series.").first_or_create
  end

  desc "create age bracket records"
  task :age_bracket => :environment do
    AgeBracket.where(name: "Not specified", internal_name: :"not-specified", description: "Age ranges were not specified or not applicable to this series").first_or_create
    AgeBracket.where(name: "All age ranges", internal_name: :"all-age-ranges", description: "All values for age ranges were included in this series").first_or_create
    AgeBracket.where(name: "No answer provided", internal_name: :"no-answer-provided", description: "An age question was asked, no answer was provided").first_or_create

    AgeBracket.where(name: "20-24", internal_name: :"20-24", description: "Ages 20-24 inclusive").first_or_create
    AgeBracket.where(name: "25-29", internal_name: :"25-29", description: "Ages 25-29 inclusive").first_or_create
    AgeBracket.where(name: "30-34", internal_name: :"30-34", description: "Ages 30-34 inclusive").first_or_create
    AgeBracket.where(name: "35-39", internal_name: :"35-39", description: "Ages 35-39 inclusive").first_or_create
    AgeBracket.where(name: "40-44", internal_name: :"40-44", description: "Ages 40-44 inclusive").first_or_create
    AgeBracket.where(name: "45-49", internal_name: :"45-49", description: "Ages 45-49 inclusive").first_or_create
    AgeBracket.where(name: "50-54", internal_name: :"50-54", description: "Ages 50-54 inclusive").first_or_create
    AgeBracket.where(name: "55-59", internal_name: :"55-59", description: "Ages 55-59 inclusive").first_or_create
    AgeBracket.where(name: "60-64", internal_name: :"60-64", description: "Ages 60-64 inclusive").first_or_create
    AgeBracket.where(name: "65+", internal_name: :"65+", description: "Age 65 or older, includes 65").first_or_create

    AgeBracket.where(name: "16-19", internal_name: :"16-19", description: "Ages 16-19 inclusive").first_or_create
    AgeBracket.where(name: "Under 16", internal_name: :"under-16", description: "Less than 16 years of age, excluding 16").first_or_create
    AgeBracket.where(name: "18-24", internal_name: :"18-24", description: "Ages 18-24 inclusive").first_or_create
    AgeBracket.where(name: "Under 18", internal_name: :"under-18", description: "Less than 18 years of age, excluding 18").first_or_create
    AgeBracket.where(name: "Under 5", internal_name: :"under-5", description: "Less than 5 years of age, excluding 5").first_or_create
    AgeBracket.where(name: "05-17", internal_name: :"05-17", description: "Ages 5-17 inclusive").first_or_create

    AgeBracket.where(name: "20-29", internal_name: :"20-29", description: "Ages 20-29 inclusive").first_or_create
    AgeBracket.where(name: "30-39", internal_name: :"30-39", description: "Ages 30-39 inclusive").first_or_create
    AgeBracket.where(name: "40-49", internal_name: :"40-49", description: "Ages 40-49 inclusive").first_or_create
    AgeBracket.where(name: "50-59", internal_name: :"50-59", description: "Ages 50-59 inclusive").first_or_create
    AgeBracket.where(name: "60-69", internal_name: :"60-69", description: "Ages 60-69 inclusive").first_or_create
    AgeBracket.where(name: "70+", internal_name: :"70+", description: "Age 70 or older, includes 70").first_or_create

    AgeBracket.where(name: "25-34", internal_name: :"25-34", description: "Ages 25-34 inclusive").first_or_create
    AgeBracket.where(name: "35-44", internal_name: :"35-44", description: "Ages 35-44 inclusive").first_or_create
    AgeBracket.where(name: "45-54", internal_name: :"45-54", description: "Ages 45-54 inclusive").first_or_create
    AgeBracket.where(name: "55-64", internal_name: :"55-64", description: "Ages 55-64 inclusive").first_or_create
    # AgeBracket.where(name: "65+", description: "Age 65 or older, includes 65").first_or_create
  end

  desc "create marital status records"
  task :marital_status => :environment do
    MaritalStatus.where(name: "Not specified", internal_name: :"not-specified", description: "Marital status not specified or not applicable to this series").first_or_create
    MaritalStatus.where(name: "All marital statuses", internal_name: :"all-marital-statuses", description: "All values for marital status were included in this series").first_or_create
    MaritalStatus.where(name: "Annulled", internal_name: :"annulled", description: "Marriage contract has been declared null and to not have existed").first_or_create
    MaritalStatus.where(name: "Divorced", internal_name: :"divorced", description: "Marriage contract has been declared dissolved and inactive").first_or_create
    MaritalStatus.where(name: "Divorce proceeding", internal_name: :"divorce-proceeding", description: "Divorce proceedings have begun but not concluded. Also called interlocutory").first_or_create
    MaritalStatus.where(name: "Legally separated", internal_name: :"legally-separated", description: "Legally separated").first_or_create
    MaritalStatus.where(name: "Married", internal_name: :"married", description: "A marriage contract is currently active, spouses intend to live together").first_or_create
    MaritalStatus.where(name: "Polygamous", internal_name: :"polygamous", description: "More than one current spouse").first_or_create
    MaritalStatus.where(name: "Never married", internal_name: :"never-married", description: "No marriage contract has ever been entered").first_or_create
    MaritalStatus.where(name: "Domestic partner", internal_name: :"domestic-partner", description: "Person declared that a domestic partner relationship exists").first_or_create
    MaritalStatus.where(name: "Spouse absent", internal_name: :"spouse-absent", description: "Married, but not living together").first_or_create
    MaritalStatus.where(name: "No answer provided", internal_name: :"no-answer-provided", description: "The question of marital status was posed but no answer was provided").first_or_create
  end

  desc "create employment status records"
  task :employment_status => :environment do
    EmploymentStatus.where(name: "Not specified", internal_name: :"not-specified", description: "This series does not have employment as an attribute").first_or_create
    EmploymentStatus.where(name: "All employment statuses", internal_name: :"all-employment-statuses", description: "Employment is a series attribute and all values are included").first_or_create
    EmploymentStatus.where(name: "No answer provided", internal_name: :"no-answer-provided", description: "Employment is a series attribute however no value was recorded").first_or_create

    EmploymentStatus.where(name: "Employed full time", internal_name: :"employed-full-time", description: "Employed full time").first_or_create
    EmploymentStatus.where(name: "Employed part time", internal_name: :"employed-part-time", description: "Employed part time").first_or_create
    EmploymentStatus.where(name: "Self employed", internal_name: :"self-employed", description: "Runs their own business, not employed by others").first_or_create
    EmploymentStatus.where(name: "Retired", internal_name: :"retired", description: "Retired from work").first_or_create
    EmploymentStatus.where(name: "Not employed - All Reasons", internal_name: :"not-employed-all-reasons", description: "Includes all reasons for not being employed").first_or_create
    EmploymentStatus.where(name: "Not employed - Did not search", internal_name: :"not-employed-did-not-search", description: "Did not search for work in previous year").first_or_create
    EmploymentStatus.where(name: "Not employed - Searched", internal_name: :"not-employed-searched", description: "Searched for work in previous year").first_or_create
    EmploymentStatus.where(name: "Not employed - Discouraged", internal_name: :"not-employed-discouraged", description: "Discouraged over job prospects, believe no job is available").first_or_create
    EmploymentStatus.where(name: "Not employed - Family", internal_name: :"not-employed-family", description: "Family responsibilities prevent work").first_or_create
    EmploymentStatus.where(name: "Not employed - School", internal_name: :"not-employed-school", description: "Currently in school or training").first_or_create
    EmploymentStatus.where(name: "Not employed - Ill", internal_name: :"not-employed-ill", description: "Ill health or disability prevents work").first_or_create
    EmploymentStatus.where(name: "Not employed - Other", internal_name: :"not-employed-other", description: "Other reason for not able to work, including transportation problems").first_or_create
  end

  desc "create education level records"
  task :education_level => :environment do
    EducationLevel.where(name: "Not specified", internal_name: :"not-specified", description: "This series does not have education level as an attribute").first_or_create
    EducationLevel.where(name: "All education levels", internal_name: :"all-education-levels", description: "Education level is a series attribute and all values are included").first_or_create
    EducationLevel.where(name: "No answer provided", internal_name: :"no-answer-provided", description: "Education is a series attribute however no value was recorded").first_or_create

    EducationLevel.where(name: "Some High School or High School Graduate", internal_name: :"all-high-school", description: "Some High School or High School Graduate").first_or_create
    EducationLevel.where(name: "Less than a High School diploma", internal_name: :"less-than-high-school", description: "Less than a High School diploma").first_or_create
    EducationLevel.where(name: "Less than 1 year of High School", internal_name: :"less-than-1-year-high-school", description: "Less than 1 year of High School").first_or_create
    EducationLevel.where(name: "4 years of High School, no diploma", internal_name: :"4-year-high-school-no-diploma", description: "4 years of High School, no diploma").first_or_create
    EducationLevel.where(name: "High School graduates, no college", internal_name: :"high-school-graduate-no-college", description: "High School graduates, no college").first_or_create
    EducationLevel.where(name: "Some college or associate degree", internal_name: :"some-college", description: "Some college or associate degree").first_or_create
    EducationLevel.where(name: "Some college, no degree", internal_name: :"some-college-no-degree", description: "Some college, no degree").first_or_create
    EducationLevel.where(name: "Associate degree", internal_name: :"associate-degree", description: "Associate degree").first_or_create
    EducationLevel.where(name: "Associate degree, occupational program", internal_name: :"associate-degree-occupational", description: "Associate degree, occupational program").first_or_create
    EducationLevel.where(name: "Associate degree, academic program", internal_name: :"associate-degree-academic", description: "Associate degree, academic program").first_or_create
    EducationLevel.where(name: "Bachelor's degree and higher", internal_name: :"bachelors-degree-and-higher", description: "Bachelor's degree and higher").first_or_create
    EducationLevel.where(name: "Bachelor's degree only", internal_name: :"bachelors-degree-only", description: "Bachelor's degree only").first_or_create
    EducationLevel.where(name: "Advanced degree", internal_name: :"advanced-degree", description: "Advanced degree").first_or_create
    EducationLevel.where(name: "Master's degree", internal_name: :"masters-degree", description: "Master's degree").first_or_create
    EducationLevel.where(name: "Professional degree", internal_name: :"professional-degree", description: "Professional degree").first_or_create
    EducationLevel.where(name: "Doctoral degree", internal_name: :"doctoral-degree", description: "Doctoral degree").first_or_create
  end

  desc "create child status records"
  task :child_status => :environment do
    ChildStatus.where(name: "Not specified", internal_name: :"not-specified", description: "This series does not have education level as an attribute").first_or_create
    ChildStatus.where(name: "All child statuses", internal_name: :"all-child-statuses", description: "Education level is a series attribute and all values are included").first_or_create
    ChildStatus.where(name: "No answer provided", internal_name: :"no-answer-provided", description: "Education is a series attribute however no value was recorded").first_or_create

    #We need to refine these as more child in household definitions are encountered.
    ChildStatus.where(name: "No child present in household under 18", internal_name: :"no-child-present", description: "No child present in household under 18").first_or_create
    ChildStatus.where(name: "Child under 6 present", internal_name: :"child-under-6-present", description: "Child under 6 present").first_or_create
    ChildStatus.where(name: "Child 6-12 present", internal_name: :"child-6-12-present", description: "Child 6-12 present").first_or_create
    ChildStatus.where(name: "Child 13-17 present", internal_name: :"child-13-17-present", description: "Child 13-17 present").first_or_create
    ChildStatus.where(name: "Child under 18 present", internal_name: :"child-under-18-present", description: "Child under 18 present").first_or_create
    ChildStatus.where(name: "Child under 3 present", internal_name: :"child-under-3-present", description: "Child under 3 present").first_or_create
  end

  desc "create income level records"
  task :income_level => :environment do
    IncomeLevel.where(name: "Not specified", internal_name: :"not-specified", description: "This series does not have income level as an attribute").first_or_create
    IncomeLevel.where(name: "All income levels", internal_name: :"all-income-levels", description: "Income level is a series attribute and all values are included").first_or_create
    IncomeLevel.where(name: "No answer provided", internal_name: :"no-answer-provided", description: "Income is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

  end

  desc "create industry code records"
  task :industry_code => :environment do
    IndustryCode.where(name: "Not specified", internal_name: :"not-specified", description: "This series does not have industry as an attribute").first_or_create
    IndustryCode.where(name: "All industries", internal_name: :"all-industries", description: "Industry is a series attribute and all values are included").first_or_create
    IndustryCode.where(name: "No answer provided", internal_name: :"no-answer-provided", description: "Industry is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples
  end

  desc "create occupation code records"
  task :occupation_code => :environment do
    OccupationCode.where(name: "Not specified", internal_name: :"not-specified", description: "This series does not have occupation as an attribute").first_or_create
    OccupationCode.where(name: "All occupations", internal_name: :"all-occupations", description: "Occupation is a series attribute and all values are included").first_or_create
    OccupationCode.where(name: "No answer provided", internal_name: :"no-answer-provided", description: "Occupation is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

  end

  desc "create geo code records"
  task :geo_code => :environment do
    GeoCode.where(name: "Not specified", internal_name: :"not-specified", description: "This series does not have geography as an attribute").first_or_create
    # Does this ever happen? When would we not be able to get a geographic description?
    # Perhaps we use temporarily in dev then remove this and force a geographic definition explicitly
    GeoCode.where(name: "All geographies", internal_name: :"all-geographies", description: "Geography is a series attribute and all values are included").first_or_create
    GeoCode.where(name: "No answer provided", internal_name: :"no-answer-provided", description: "Geography is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

  end

end
