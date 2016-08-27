namespace :defaults do

  desc "crate defaults"
  task :create => [:frequency, :unit, :gender, :race, :age_bracket, :marital_status, :employment_status, :education_level, :child_status, :income_level, :industry_code, :occupation_code, :geo_code]

  desc "create frequency records"
  task :frequency => :environment do
    Frequency.where(name: "Annual", description: "Annual").first_or_create
    Frequency.where(name: "Monthly", description: "Monthly").first_or_create
    Frequency.where(name: "Quarterly", description: "Quarterly").first_or_create
  end

  desc "create unit records"
  task :unit => :environment do
    Unit.where(name: "Nominal US Dollars", description: "US Dollars, not adjusted for inflation" ).first_or_create
    Unit.where(name: "Real US Dollars", description: "US Dollars adjusted for inflation" ).first_or_create
    Unit.where(name: "Percent", description: "Typically a percent difference from a prior period").first_or_create
    Unit.where(name: "Jobs", description: "Number of jobs").first_or_create
    Unit.where(name: "Establishments", description: "Number of Establishments, primarily businesses.").first_or_create
  end

  desc "create gender records"
  task :gender => :environment do
    Gender.where(name: "Not specified", description: "Gender not specified or not applicable to this series").first_or_create
    Gender.where(name: "All genders", description: "Both male and female genders included in this series").first_or_create
    Gender.where(name: "Male", description: "Male").first_or_create
    Gender.where(name: "Female", description: "Female").first_or_create
  end

  desc "create race records"
  task :race => :environment do
    Race.where(name: "Not specified", description: "Race not specified or not applicable to this series").first_or_create
    Race.where(name: "All races", description: "All values for race were included in this series").first_or_create
    Race.where(name: "White", description: "White").first_or_create
    Race.where(name: "Black", description: "Black or African American").first_or_create
    Race.where(name: "Asian", description: "Asian").first_or_create
    Race.where(name: "Hispanic", description: "Hispanic. Values for this series are often reported separately and may include values from other series.").first_or_create
  end

  desc "create age bracket records"
  task :age_bracket => :environment do
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
  end

  desc "create marital status records"
  task :marital_status => :environment do
    MaritalStatus.where(name: "Not specified", description: "Marital status not specified or not applicable to this series").first_or_create
    MaritalStatus.where(name: "All marital statuses", description: "All values for marital status were included in this series").first_or_create
    MaritalStatus.where(name: "Annulled", description: "Marriage contract has been declared null and to not have existed").first_or_create
    MaritalStatus.where(name: "Divorced", description: "Marriage contract has been declared dissolved and inactive").first_or_create
    MaritalStatus.where(name: "Divorce proceeding", description: "Divorce proceedings have begun but not concluded. Also called interlocutory").first_or_create
    MaritalStatus.where(name: "Legally separated", description: "Legally separated").first_or_create
    MaritalStatus.where(name: "Married", description: "A marriage contract is currently active, spouses intend to live together").first_or_create
    MaritalStatus.where(name: "Polygamous", description: "More than one current spouse").first_or_create
    MaritalStatus.where(name: "Never married", description: "No marriage contract has ever been entered").first_or_create
    MaritalStatus.where(name: "Domestic partner", description: "Person declared that a domestic partner relationship exists").first_or_create
    MaritalStatus.where(name: "Spouse absent", description: "Married, but not living together").first_or_create
    MaritalStatus.where(name: "Answer not given", description: "The question of marital status was posed but no answer was provided").first_or_create
  end

  desc "create employment status records"
  task :employment_status => :environment do
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
  end

  desc "create education level records"
  task :education_level => :environment do
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
  end

  desc "create child status records"
  task :child_status => :environment do
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
  end

  desc "create income level records"
  task :income_level => :environment do
    IncomeLevel.where(name: "Not specified", description: "This series does not have income level as an attribute").first_or_create
    IncomeLevel.where(name: "All income levels", description: "Income level is a series attribute and all values are included").first_or_create
    IncomeLevel.where(name: "No answer provided", description: "Income is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

  end

  desc "create industry code records"
  task :industry_code => :environment do
    IndustryCode.where(name: "Not specified", description: "This series does not have industry as an attribute").first_or_create
    IndustryCode.where(name: "All industries", description: "Industry is a series attribute and all values are included").first_or_create
    IndustryCode.where(name: "No answer provided", description: "Industry is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples
  end

  desc "create occupation code records"
  task :occupation_code => :environment do
    OccupationCode.where(name: "Not specified", description: "This series does not have occupation as an attribute").first_or_create
    OccupationCode.where(name: "All occupations", description: "Occupation is a series attribute and all values are included").first_or_create
    OccupationCode.where(name: "No answer provided", description: "Occupation is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

  end

  desc "create geo code records"
  task :geo_code => :environment do
    GeoCode.where(name: "Not specified", description: "This series does not have geography as an attribute").first_or_create
    # Does this ever happen? When would we not be able to get a geographic description?
    # Perhaps we use temporarily in dev then remove this and force a geographic definition explicitly
    GeoCode.where(name: "All geographies", description: "Geography is a series attribute and all values are included").first_or_create
    GeoCode.where(name: "No answer provided", description: "Geography is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

  end

end
