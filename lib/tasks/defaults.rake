namespace :defaults do

  #For internal names the syntax for SEO and uniqueness should be to prefix with source, lowercase, use full names, separated by hyphens
  # bls-average-prices

  desc "destroy defaults"
  task :destroy => :environment do
    Bulkload::Bls::ImportIndicators.reset
    Dataset.destroy_all
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
    State.destroy_all
  end

  desc "get indicators and series"
  task :setup => :environment do
    Bulkload::Bls::ImportIndicators.new.import_all
  end

  desc "get values"
  task :import_values => :environment do
    Bulkload::Bls::ImportValues.new.import_values("ap")
    Bulkload::Bls::ImportValues.new.import_values("bd")
  end

  desc "create defaults"
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
    OtherGeo.where(name: "Not specified", internal_name: :"not-specified", description: "This series does not have geography as an attribute").first_or_create
    # Does this ever happen? When would we not be able to get a geographic description?
    # Perhaps we use temporarily in dev then remove this and force a geographic definition explicitly
    OtherGeo.where(name: "All geographies", internal_name: :"all-geographies", description: "Geography is a series attribute and all values are included").first_or_create
    OtherGeo.where(name: "No answer provided", internal_name: :"no-answer-provided", description: "Geography is a series attribute however no value was recorded").first_or_create
    OtherGeo.where(name: "Not elsewhere classified", internal_name: :"not-elsewhere-classified", description: "A geographic attribute was classified but it does not map to our system, see the raw value for details").first_or_create

    #Country
    Country.where(name: "United States", short_name: "USA", internal_name: :"united-states").first_or_create

    #Region
    Region.where(name: "Northeast region", internal_name: :northeast).first_or_create
    Region.where(name: "Midwest region", internal_name: :midwest ).first_or_create
    Region.where(name: "Southeast region", internal_name: :southeast).first_or_create
    Region.where(name: "Westcoast region", internal_name: :westcoast).first_or_create

    #State
    State.where(name: 'Alabama', fips_code: 1, gnis_code: 1779775, short_name: 'AL', internal_name: :'alabama').first_or_create
    State.where(name: 'Alaska', fips_code: 2, gnis_code: 1785533, short_name: 'AK', internal_name: :'alaska').first_or_create
    State.where(name: 'Arizona', fips_code: 4, gnis_code: 1779777, short_name: 'AZ', internal_name: :'arizona').first_or_create
    State.where(name: 'Arkansas', fips_code: 5, gnis_code: 68085, short_name: 'AR', internal_name: :'arkansas').first_or_create
    State.where(name: 'California', fips_code: 6, gnis_code: 1779778, short_name: 'CA', internal_name: :'california').first_or_create
    State.where(name: 'Colorado', fips_code: 8, gnis_code: 1779779, short_name: 'CO', internal_name: :'colorado').first_or_create
    State.where(name: 'Connecticut', fips_code: 9, gnis_code: 1779780, short_name: 'CT', internal_name: :'connecticut').first_or_create
    State.where(name: 'Delaware', fips_code: 10, gnis_code: 1779781, short_name: 'DE', internal_name: :'delaware').first_or_create
    State.where(name: 'District of Columbia', fips_code: 11, gnis_code: 1702382, short_name: 'DC', internal_name: :'district-of-columbia').first_or_create
    State.where(name: 'Florida', fips_code: 12, gnis_code: 294478, short_name: 'FL', internal_name: :'florida').first_or_create
    State.where(name: 'Georgia', fips_code: 13, gnis_code: 1705317, short_name: 'GA', internal_name: :'georgia').first_or_create
    State.where(name: 'Hawaii', fips_code: 15, gnis_code: 1779782, short_name: 'HI', internal_name: :'hawaii').first_or_create
    State.where(name: 'Idaho', fips_code: 16, gnis_code: 1779783, short_name: 'ID', internal_name: :'idaho').first_or_create
    State.where(name: 'Illinois', fips_code: 17, gnis_code: 1779784, short_name: 'IL', internal_name: :'illinois').first_or_create
    State.where(name: 'Indiana', fips_code: 18, gnis_code: 448508, short_name: 'IN', internal_name: :'indiana').first_or_create
    State.where(name: 'Iowa', fips_code: 19, gnis_code: 1779785, short_name: 'IA', internal_name: :'iowa').first_or_create
    State.where(name: 'Kansas', fips_code: 20, gnis_code: 481813, short_name: 'KS', internal_name: :'kansas').first_or_create
    State.where(name: 'Kentucky', fips_code: 21, gnis_code: 1779786, short_name: 'KY', internal_name: :'kentucky').first_or_create
    State.where(name: 'Louisiana', fips_code: 22, gnis_code: 1629543, short_name: 'LA', internal_name: :'louisiana').first_or_create
    State.where(name: 'Maine', fips_code: 23, gnis_code: 1779787, short_name: 'ME', internal_name: :'maine').first_or_create
    State.where(name: 'Maryland', fips_code: 24, gnis_code: 1714934, short_name: 'MD', internal_name: :'maryland').first_or_create
    State.where(name: 'Massachusetts', fips_code: 25, gnis_code: 606926, short_name: 'MA', internal_name: :'massachusetts').first_or_create
    State.where(name: 'Michigan', fips_code: 26, gnis_code: 1779789, short_name: 'MI', internal_name: :'michigan').first_or_create
    State.where(name: 'Minnesota', fips_code: 27, gnis_code: 662849, short_name: 'MN', internal_name: :'minnesota').first_or_create
    State.where(name: 'Mississippi', fips_code: 28, gnis_code: 1779790, short_name: 'MS', internal_name: :'mississippi').first_or_create
    State.where(name: 'Missouri', fips_code: 29, gnis_code: 1779791, short_name: 'MO', internal_name: :'missouri').first_or_create
    State.where(name: 'Montana', fips_code: 30, gnis_code: 767982, short_name: 'MT', internal_name: :'montana').first_or_create
    State.where(name: 'Nebraska', fips_code: 31, gnis_code: 1779792, short_name: 'NE', internal_name: :'nebraska').first_or_create
    State.where(name: 'Nevada', fips_code: 32, gnis_code: 1779793, short_name: 'NV', internal_name: :'nevada').first_or_create
    State.where(name: 'New Hampshire', fips_code: 33, gnis_code: 1779794, short_name: 'NH', internal_name: :'new-hampshire').first_or_create
    State.where(name: 'New Jersey', fips_code: 34, gnis_code: 1779795, short_name: 'NJ', internal_name: :'new-jersey').first_or_create
    State.where(name: 'New Mexico', fips_code: 35, gnis_code: 897535, short_name: 'NM', internal_name: :'new-mexico').first_or_create
    State.where(name: 'New York', fips_code: 36, gnis_code: 1779796, short_name: 'NY', internal_name: :'new-york').first_or_create
    State.where(name: 'North Carolina', fips_code: 37, gnis_code: 1027616, short_name: 'NC', internal_name: :'north-carolina').first_or_create
    State.where(name: 'North Dakota', fips_code: 38, gnis_code: 1779797, short_name: 'ND', internal_name: :'north-dakota').first_or_create
    State.where(name: 'Ohio', fips_code: 39, gnis_code: 1085497, short_name: 'OH', internal_name: :'ohio').first_or_create
    State.where(name: 'Oklahoma', fips_code: 40, gnis_code: 1102857, short_name: 'OK', internal_name: :'oklahoma').first_or_create
    State.where(name: 'Oregon', fips_code: 41, gnis_code: 1155107, short_name: 'OR', internal_name: :'oregon').first_or_create
    State.where(name: 'Pennsylvania', fips_code: 42, gnis_code: 1779798, short_name: 'PA', internal_name: :'pennsylvania').first_or_create
    State.where(name: 'Rhode Island', fips_code: 44, gnis_code: 1219835, short_name: 'RI', internal_name: :'rhode island').first_or_create
    State.where(name: 'South Carolina', fips_code: 45, gnis_code: 1779799, short_name: 'SC', internal_name: :'south-carolina').first_or_create
    State.where(name: 'South Dakota', fips_code: 46, gnis_code: 1785534, short_name: 'SD', internal_name: :'south-dakota').first_or_create
    State.where(name: 'Tennessee', fips_code: 47, gnis_code: 1325873, short_name: 'TN', internal_name: :'tennessee').first_or_create
    State.where(name: 'Texas', fips_code: 48, gnis_code: 1779801, short_name: 'TX', internal_name: :'texas').first_or_create
    State.where(name: 'Utah', fips_code: 49, gnis_code: 1455989, short_name: 'UT', internal_name: :'utah').first_or_create
    State.where(name: 'Vermont', fips_code: 50, gnis_code: 1779802, short_name: 'VT', internal_name: :'vermont').first_or_create
    State.where(name: 'Virginia', fips_code: 51, gnis_code: 1779803, short_name: 'VA', internal_name: :'virginia').first_or_create
    State.where(name: 'Washington', fips_code: 53, gnis_code: 1779804, short_name: 'WA', internal_name: :'washington').first_or_create
    State.where(name: 'West Virginia', fips_code: 54, gnis_code: 1779805, short_name: 'WV', internal_name: :'west-virginia').first_or_create
    State.where(name: 'Wisconsin', fips_code: 55, gnis_code: 1779806, short_name: 'WI', internal_name: :'wisconsin').first_or_create
    State.where(name: 'Wyoming', fips_code: 56, gnis_code: 1779807, short_name: 'WY', internal_name: :'wyoming').first_or_create
    State.where(name: 'American Samoa', fips_code: 60, gnis_code: 1802701, short_name: 'AS', internal_name: :'american-samoa').first_or_create
    State.where(name: 'Guam', fips_code: 66, gnis_code: 1802705, short_name: 'GU', internal_name: :'guam').first_or_create
    State.where(name: 'Northern Mariana Islands', fips_code: 69, gnis_code: 1779809, short_name: 'MP', internal_name: :'northern-mariana-islands').first_or_create
    State.where(name: 'Puerto Rico', fips_code: 72, gnis_code: 1779808, short_name: 'PR', internal_name: :'puerto-rico').first_or_create
    State.where(name: 'U.S. Minor Outlying Islands', fips_code: 74, gnis_code: 1878752, short_name: 'UM', internal_name: :'us-minor-outlying-islands').first_or_create
    State.where(name: 'U.S. Virgin Islands', fips_code: 78, gnis_code: 1802710, short_name: 'VI', internal_name: :'us-virgin-islands').first_or_create

  end

end
