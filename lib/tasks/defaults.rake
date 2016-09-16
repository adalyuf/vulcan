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
    GeoCode.destroy_all
  end

  desc "get indicators and series"
  task :setup => :environment do
    start = Time.now
    Bulkload::Bls::ImportIndicators.new.import_all
    Rails.logger.error("Time to import indicators and series: #{ Time.now - start } seconds")
  end

  desc "get values"
  task :import_values => :environment do
    start = Time.now
    Rails.logger.error("We have begun importing values, as of: #{start}")

    Bulkload::Bls::ImportValues.new.import_values("ap")
    Bulkload::Bls::ImportValues.new.import_values("bd")

    elapsed = Time.now - start
    minutes = elapsed.to_i/60
    seconds = elapsed%60
    Rails.logger.error("Time to import values: #{ elapsed } seconds, aka #{minutes} minutes and #{seconds} seconds")
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
    Source.where(name: "Bureau of Economic Analysis (BEA)", internal_name: "bureau-economic-analysis").first_or_create
    Source.where(name: "Bureau of Labor Statistics (BLS)", internal_name: "bureau-labor-statistics").first_or_create
  end

  desc "create dataset records"
  task :dataset => :environment do
    Dataset.where(name: "Average Prices", category_id: Category.find_by(name: "Business").id, internal_name: "bls-average-prices", source_id: Source.find_by(internal_name: "bureau-labor-statistics").id, description: "Average prices for goods and services in various cities").first_or_create
    Dataset.where(name: "Business Employment Dynamics", category_id: Category.find_by(name: "Business").id, internal_name: "bls-business-employment-dynamics", source_id: Source.find_by(internal_name: "bureau-labor-statistics").id , description: "Track changes in employment at the establishment level").first_or_create
  end

  desc "create frequency records"
  task :frequency => :environment do
    Frequency.where(name: "Annual", internal_name: :annual, description: "Annual").first_or_create
    Frequency.where(name: "Monthly", internal_name: :monthly, description: "Monthly").first_or_create
    Frequency.where(name: "Quarterly", internal_name: :quarterly, description: "Quarterly").first_or_create
  end

  desc "create unit records"
  task :unit => :environment do
    Unit.where(name: "Nominal US Dollars", internal_name: "nominal-us-dollars" ,description: "US Dollars, not adjusted for inflation" ).first_or_create
    Unit.where(name: "Real US Dollars", internal_name: "real-us-dollars", description: "US Dollars adjusted for inflation" ).first_or_create
    Unit.where(name: "Percent", internal_name: :percent, description: "Typically a percent difference from a prior period").first_or_create
    Unit.where(name: "Jobs", internal_name: :jobs, description: "Number of jobs").first_or_create
    Unit.where(name: "Establishments", internal_name: :establishments, description: "Number of Establishments, primarily businesses.").first_or_create
  end

  desc "create gender records"
  task :gender => :environment do
    Gender.where(name: "Not specified", internal_name: "not-specified", description: "Gender not specified or not applicable to this series").first_or_create
    Gender.where(name: "All genders", internal_name: "all-genders", description: "Both male and female genders included in this series").first_or_create
    Gender.where(name: "Male", internal_name: :male, description: "Male").first_or_create
    Gender.where(name: "Female", internal_name: :female, description: "Female").first_or_create
  end

  desc "create race records"
  task :race => :environment do
    Race.where(name: "Not specified", internal_name: "not-specified", description: "Race not specified or not applicable to this series").first_or_create
    Race.where(name: "All races", internal_name: "all-races", description: "All values for race were included in this series").first_or_create
    Race.where(name: "White", internal_name: :white, description: "White").first_or_create
    Race.where(name: "Black", internal_name: :black, description: "Black or African American").first_or_create
    Race.where(name: "Asian", internal_name: :asian, description: "Asian").first_or_create
    Race.where(name: "Hispanic", internal_name: :hispanic, description: "Hispanic. Values for this series are often reported separately and may include values from other series.").first_or_create
  end

  desc "create age bracket records"
  task :age_bracket => :environment do
    AgeBracket.where(name: "Not specified", internal_name: "not-specified", description: "Age ranges were not specified or not applicable to this series").first_or_create
    AgeBracket.where(name: "All age ranges", internal_name: "all-age-ranges", description: "All values for age ranges were included in this series").first_or_create
    AgeBracket.where(name: "No answer provided", internal_name: "no-answer-provided", description: "An age question was asked, no answer was provided").first_or_create

    AgeBracket.where(name: "20-24", internal_name: "20-24", description: "Ages 20-24 inclusive").first_or_create
    AgeBracket.where(name: "25-29", internal_name: "25-29", description: "Ages 25-29 inclusive").first_or_create
    AgeBracket.where(name: "30-34", internal_name: "30-34", description: "Ages 30-34 inclusive").first_or_create
    AgeBracket.where(name: "35-39", internal_name: "35-39", description: "Ages 35-39 inclusive").first_or_create
    AgeBracket.where(name: "40-44", internal_name: "40-44", description: "Ages 40-44 inclusive").first_or_create
    AgeBracket.where(name: "45-49", internal_name: "45-49", description: "Ages 45-49 inclusive").first_or_create
    AgeBracket.where(name: "50-54", internal_name: "50-54", description: "Ages 50-54 inclusive").first_or_create
    AgeBracket.where(name: "55-59", internal_name: "55-59", description: "Ages 55-59 inclusive").first_or_create
    AgeBracket.where(name: "60-64", internal_name: "60-64", description: "Ages 60-64 inclusive").first_or_create
    AgeBracket.where(name: "65+", internal_name: "65+", description: "Age 65 or older, includes 65").first_or_create

    AgeBracket.where(name: "16-19", internal_name: "16-19", description: "Ages 16-19 inclusive").first_or_create
    AgeBracket.where(name: "Under 16", internal_name: "under-16", description: "Less than 16 years of age, excluding 16").first_or_create
    AgeBracket.where(name: "18-24", internal_name: "18-24", description: "Ages 18-24 inclusive").first_or_create
    AgeBracket.where(name: "Under 18", internal_name: "under-18", description: "Less than 18 years of age, excluding 18").first_or_create
    AgeBracket.where(name: "Under 5", internal_name: "under-5", description: "Less than 5 years of age, excluding 5").first_or_create
    AgeBracket.where(name: "05-17", internal_name: "05-17", description: "Ages 5-17 inclusive").first_or_create

    AgeBracket.where(name: "20-29", internal_name: "20-29", description: "Ages 20-29 inclusive").first_or_create
    AgeBracket.where(name: "30-39", internal_name: "30-39", description: "Ages 30-39 inclusive").first_or_create
    AgeBracket.where(name: "40-49", internal_name: "40-49", description: "Ages 40-49 inclusive").first_or_create
    AgeBracket.where(name: "50-59", internal_name: "50-59", description: "Ages 50-59 inclusive").first_or_create
    AgeBracket.where(name: "60-69", internal_name: "60-69", description: "Ages 60-69 inclusive").first_or_create
    AgeBracket.where(name: "70+", internal_name: "70+", description: "Age 70 or older, includes 70").first_or_create

    AgeBracket.where(name: "25-34", internal_name: "25-34", description: "Ages 25-34 inclusive").first_or_create
    AgeBracket.where(name: "35-44", internal_name: "35-44", description: "Ages 35-44 inclusive").first_or_create
    AgeBracket.where(name: "45-54", internal_name: "45-54", description: "Ages 45-54 inclusive").first_or_create
    AgeBracket.where(name: "55-64", internal_name: "55-64", description: "Ages 55-64 inclusive").first_or_create
    # AgeBracket.where(name: "65+", description: "Age 65 or older, includes 65").first_or_create
  end

  desc "create marital status records"
  task :marital_status => :environment do
    MaritalStatus.where(name: "Not specified", internal_name: "not-specified", description: "Marital status not specified or not applicable to this series").first_or_create
    MaritalStatus.where(name: "All marital statuses", internal_name: "all-marital-statuses", description: "All values for marital status were included in this series").first_or_create
    MaritalStatus.where(name: "Annulled", internal_name: "annulled", description: "Marriage contract has been declared null and to not have existed").first_or_create
    MaritalStatus.where(name: "Divorced", internal_name: "divorced", description: "Marriage contract has been declared dissolved and inactive").first_or_create
    MaritalStatus.where(name: "Divorce proceeding", internal_name: "divorce-proceeding", description: "Divorce proceedings have begun but not concluded. Also called interlocutory").first_or_create
    MaritalStatus.where(name: "Legally separated", internal_name: "legally-separated", description: "Legally separated").first_or_create
    MaritalStatus.where(name: "Married", internal_name: "married", description: "A marriage contract is currently active, spouses intend to live together").first_or_create
    MaritalStatus.where(name: "Polygamous", internal_name: "polygamous", description: "More than one current spouse").first_or_create
    MaritalStatus.where(name: "Never married", internal_name: "never-married", description: "No marriage contract has ever been entered").first_or_create
    MaritalStatus.where(name: "Domestic partner", internal_name: "domestic-partner", description: "Person declared that a domestic partner relationship exists").first_or_create
    MaritalStatus.where(name: "Spouse absent", internal_name: "spouse-absent", description: "Married, but not living together").first_or_create
    MaritalStatus.where(name: "No answer provided", internal_name: "no-answer-provided", description: "The question of marital status was posed but no answer was provided").first_or_create
  end

  desc "create employment status records"
  task :employment_status => :environment do
    EmploymentStatus.where(name: "Not specified", internal_name: "not-specified", description: "This series does not have employment as an attribute").first_or_create
    EmploymentStatus.where(name: "All employment statuses", internal_name: "all-employment-statuses", description: "Employment is a series attribute and all values are included").first_or_create
    EmploymentStatus.where(name: "No answer provided", internal_name: "no-answer-provided", description: "Employment is a series attribute however no value was recorded").first_or_create

    EmploymentStatus.where(name: "Employed full time", internal_name: "employed-full-time", description: "Employed full time").first_or_create
    EmploymentStatus.where(name: "Employed part time", internal_name: "employed-part-time", description: "Employed part time").first_or_create
    EmploymentStatus.where(name: "Self employed", internal_name: "self-employed", description: "Runs their own business, not employed by others").first_or_create
    EmploymentStatus.where(name: "Retired", internal_name: "retired", description: "Retired from work").first_or_create
    EmploymentStatus.where(name: "Not employed - All Reasons", internal_name: "not-employed-all-reasons", description: "Includes all reasons for not being employed").first_or_create
    EmploymentStatus.where(name: "Not employed - Did not search", internal_name: "not-employed-did-not-search", description: "Did not search for work in previous year").first_or_create
    EmploymentStatus.where(name: "Not employed - Searched", internal_name: "not-employed-searched", description: "Searched for work in previous year").first_or_create
    EmploymentStatus.where(name: "Not employed - Discouraged", internal_name: "not-employed-discouraged", description: "Discouraged over job prospects, believe no job is available").first_or_create
    EmploymentStatus.where(name: "Not employed - Family", internal_name: "not-employed-family", description: "Family responsibilities prevent work").first_or_create
    EmploymentStatus.where(name: "Not employed - School", internal_name: "not-employed-school", description: "Currently in school or training").first_or_create
    EmploymentStatus.where(name: "Not employed - Ill", internal_name: "not-employed-ill", description: "Ill health or disability prevents work").first_or_create
    EmploymentStatus.where(name: "Not employed - Other", internal_name: "not-employed-other", description: "Other reason for not able to work, including transportation problems").first_or_create
  end

  desc "create education level records"
  task :education_level => :environment do
    EducationLevel.where(name: "Not specified", internal_name: "not-specified", description: "This series does not have education level as an attribute").first_or_create
    EducationLevel.where(name: "All education levels", internal_name: "all-education-levels", description: "Education level is a series attribute and all values are included").first_or_create
    EducationLevel.where(name: "No answer provided", internal_name: "no-answer-provided", description: "Education is a series attribute however no value was recorded").first_or_create

    EducationLevel.where(name: "Some High School or High School Graduate", internal_name: "all-high-school", description: "Some High School or High School Graduate").first_or_create
    EducationLevel.where(name: "Less than a High School diploma", internal_name: "less-than-high-school", description: "Less than a High School diploma").first_or_create
    EducationLevel.where(name: "Less than 1 year of High School", internal_name: "less-than-1-year-high-school", description: "Less than 1 year of High School").first_or_create
    EducationLevel.where(name: "4 years of High School, no diploma", internal_name: "4-year-high-school-no-diploma", description: "4 years of High School, no diploma").first_or_create
    EducationLevel.where(name: "High School graduates, no college", internal_name: "high-school-graduate-no-college", description: "High School graduates, no college").first_or_create
    EducationLevel.where(name: "Some college or associate degree", internal_name: "some-college", description: "Some college or associate degree").first_or_create
    EducationLevel.where(name: "Some college, no degree", internal_name: "some-college-no-degree", description: "Some college, no degree").first_or_create
    EducationLevel.where(name: "Associate degree", internal_name: "associate-degree", description: "Associate degree").first_or_create
    EducationLevel.where(name: "Associate degree, occupational program", internal_name: "associate-degree-occupational", description: "Associate degree, occupational program").first_or_create
    EducationLevel.where(name: "Associate degree, academic program", internal_name: "associate-degree-academic", description: "Associate degree, academic program").first_or_create
    EducationLevel.where(name: "Bachelor's degree and higher", internal_name: "bachelors-degree-and-higher", description: "Bachelor's degree and higher").first_or_create
    EducationLevel.where(name: "Bachelor's degree only", internal_name: "bachelors-degree-only", description: "Bachelor's degree only").first_or_create
    EducationLevel.where(name: "Advanced degree", internal_name: "advanced-degree", description: "Advanced degree").first_or_create
    EducationLevel.where(name: "Master's degree", internal_name: "masters-degree", description: "Master's degree").first_or_create
    EducationLevel.where(name: "Professional degree", internal_name: "professional-degree", description: "Professional degree").first_or_create
    EducationLevel.where(name: "Doctoral degree", internal_name: "doctoral-degree", description: "Doctoral degree").first_or_create
  end

  desc "create child status records"
  task :child_status => :environment do
    ChildStatus.where(name: "Not specified", internal_name: "not-specified", description: "This series does not have education level as an attribute").first_or_create
    ChildStatus.where(name: "All child statuses", internal_name: "all-child-statuses", description: "Education level is a series attribute and all values are included").first_or_create
    ChildStatus.where(name: "No answer provided", internal_name: "no-answer-provided", description: "Education is a series attribute however no value was recorded").first_or_create

    #We need to refine these as more child in household definitions are encountered.
    ChildStatus.where(name: "No child present in household under 18", internal_name: "no-child-present", description: "No child present in household under 18").first_or_create
    ChildStatus.where(name: "Child under 6 present", internal_name: "child-under-6-present", description: "Child under 6 present").first_or_create
    ChildStatus.where(name: "Child 6-12 present", internal_name: "child-6-12-present", description: "Child 6-12 present").first_or_create
    ChildStatus.where(name: "Child 13-17 present", internal_name: "child-13-17-present", description: "Child 13-17 present").first_or_create
    ChildStatus.where(name: "Child under 18 present", internal_name: "child-under-18-present", description: "Child under 18 present").first_or_create
    ChildStatus.where(name: "Child under 3 present", internal_name: "child-under-3-present", description: "Child under 3 present").first_or_create
  end

  desc "create income level records"
  task :income_level => :environment do
    IncomeLevel.where(name: "Not specified", internal_name: "not-specified", description: "This series does not have income level as an attribute").first_or_create
    IncomeLevel.where(name: "All income levels", internal_name: "all-income-levels", description: "Income level is a series attribute and all values are included").first_or_create
    IncomeLevel.where(name: "No answer provided", internal_name: "no-answer-provided", description: "Income is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

  end

  desc "create industry code records"
  task :industry_code => :environment do
    IndustryCode.where(name: "Not specified", internal_name: "not-specified", description: "This series does not have industry as an attribute").first_or_create
    IndustryCode.where(name: "All industries", internal_name: "all-industries", description: "Industry is a series attribute and all values are included").first_or_create
    IndustryCode.where(name: "No answer provided", internal_name: "no-answer-provided", description: "Industry is a series attribute however no value was recorded").first_or_create
    IndustryCode.where(name: "Not elsewhere classified", internal_name: "not-elsewhere-classified", description: "Industry is a series attribute but it does not map to our classification, see raw value for details").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples
    IndustryCode.where(name: "All private industry", internal_name: "all-private-industry", description: "Includes all private industry, excludes government").first_or_create
    IndustryCode.where(name: "All government", internal_name: "all-government", description: "Includes all government functions, excludes private industry").first_or_create

    # Goods and Services
    IndustryCode.where(name: "All goods producers", internal_name: "all-goods-producers", description: "Companies that manufacture and sell physical goods").first_or_create
    IndustryCode.where(name: "All service providers", internal_name: "all-service-providers", description: "Service providing companies").first_or_create


    #NAICS sectors
    IndustryCode.where(name: "Agriculture, Forestry, Fishing and Hunting", internal_name: "agriculture-forestry-fishing-and-hunting", industry_type: :sector, naics_code: "11").first_or_create
    IndustryCode.where(name: "Mining, Quarrying, and Oil and Gas Extraction", internal_name: "mining-quarrying-and-oil-and-gas-extraction", industry_type: :sector, naics_code: "21").first_or_create
    IndustryCode.where(name: "Utilities", internal_name: "utilities", industry_type: :sector, naics_code: "22").first_or_create
    IndustryCode.where(name: "Construction", internal_name: "construction", industry_type: :sector, naics_code: "23").first_or_create
    IndustryCode.where(name: "Manufacturing", internal_name: "manufacturing", industry_type: :sector, naics_code: "31").first_or_create
    IndustryCode.where(name: "Wholesale Trade", internal_name: "wholesale-trade", industry_type: :sector, naics_code: "42").first_or_create
    IndustryCode.where(name: "Retail Trade", internal_name: "retail-trade", industry_type: :sector, naics_code: "44").first_or_create
    IndustryCode.where(name: "Transportation and Warehousing", internal_name: "transportation-and-warehousing", industry_type: :sector, naics_code: "48").first_or_create

    IndustryCode.where(name: "Information", internal_name: "information", industry_type: :sector, naics_code: "51").first_or_create
    IndustryCode.where(name: "Finance and Insurance", internal_name: "finance-and-insurance", industry_type: :sector, naics_code: "52").first_or_create
    IndustryCode.where(name: "Real Estate and Rental and Leasing", internal_name: "real-estate-and-rental-and-leasing", industry_type: :sector, naics_code: "53").first_or_create
    IndustryCode.where(name: "Professional, Scientific, and Technical Services", internal_name: "professional-scientific-and-technical-services", industry_type: :sector, naics_code: "54").first_or_create
    IndustryCode.where(name: "Management of Companies and Enterprises", internal_name: "management-of-companies-and-enterprises", industry_type: :sector, naics_code: "55").first_or_create
    IndustryCode.where(name: "Administrative and Support and Waste Management and Remediation Services", internal_name: "administrative-and-support-and-waste-management-and-remediation-services", industry_type: :sector, naics_code: "56").first_or_create
    IndustryCode.where(name: "Educational Services", internal_name: "educational-services", industry_type: :sector, naics_code: "61").first_or_create
    IndustryCode.where(name: "Health Care and Social Assistance", internal_name: "health-care-and-social-assistance", industry_type: :sector, naics_code: "62").first_or_create
    IndustryCode.where(name: "Arts, Entertainment, and Recreation", internal_name: "arts-entertainment-and-recreation", industry_type: :sector, naics_code: "71").first_or_create
    IndustryCode.where(name: "Accommodation and Food Services", internal_name: "accommodation-and-food-services", industry_type: :sector, naics_code: "72").first_or_create
    IndustryCode.where(name: "Other Services (except Public Administration)", internal_name: "other-services-except-public-administration", industry_type: :sector, naics_code: "81").first_or_create
    IndustryCode.where(name: "Public Administration", internal_name: "public-administration", industry_type: :sector, naics_code: "92").first_or_create

    #NAICS subsectors
    IndustryCode.where(name: "Crop Production", internal_name: "crop-production", industry_type: :subsector, naics_code: "111").first_or_create
    IndustryCode.where(name: "Animal Production and Aquaculture", internal_name: "animal-production-and-aquaculture", industry_type: :subsector, naics_code: "112").first_or_create
    IndustryCode.where(name: "Forestry and Logging", internal_name: "forestry-and-logging", industry_type: :subsector, naics_code: "113").first_or_create
    IndustryCode.where(name: "Fishing, Hunting and Trapping", internal_name: "fishing-hunting-and-trapping", industry_type: :subsector, naics_code: "114").first_or_create
    IndustryCode.where(name: "Support Activities for Agriculture and Forestry", internal_name: "support-activities-for-agriculture-and-forestry", industry_type: :subsector, naics_code: "115").first_or_create
    IndustryCode.where(name: "Oil and Gas Extraction", internal_name: "oil-and-gas-extraction", industry_type: :subsector, naics_code: "211").first_or_create
    IndustryCode.where(name: "Mining (except Oil and Gas)", internal_name: "mining-except-oil-and-gas", industry_type: :subsector, naics_code: "212").first_or_create
    IndustryCode.where(name: "Support Activities for Mining", internal_name: "support-activities-for-mining", industry_type: :subsector, naics_code: "213").first_or_create
    IndustryCode.where(name: "Utilities", internal_name: "utilities", industry_type: :subsector, naics_code: "221").first_or_create
    IndustryCode.where(name: "Construction of Buildings", internal_name: "construction-of-buildings", industry_type: :subsector, naics_code: "236").first_or_create
    IndustryCode.where(name: "Heavy and Civil Engineering Construction", internal_name: "heavy-and-civil-engineering-construction", industry_type: :subsector, naics_code: "237").first_or_create
    IndustryCode.where(name: "Specialty Trade Contractors", internal_name: "specialty-trade-contractors", industry_type: :subsector, naics_code: "238").first_or_create
    IndustryCode.where(name: "Food Manufacturing", internal_name: "food-manufacturing", industry_type: :subsector, naics_code: "311").first_or_create
    IndustryCode.where(name: "Beverage and Tobacco Product Manufacturing", internal_name: "beverage-and-tobacco-product-manufacturing", industry_type: :subsector, naics_code: "312").first_or_create
    IndustryCode.where(name: "Textile Mills", internal_name: "textile-mills", industry_type: :subsector, naics_code: "313").first_or_create
    IndustryCode.where(name: "Textile Product Mills", internal_name: "textile-product-mills", industry_type: :subsector, naics_code: "314").first_or_create
    IndustryCode.where(name: "Apparel Manufacturing", internal_name: "apparel-manufacturing", industry_type: :subsector, naics_code: "315").first_or_create
    IndustryCode.where(name: "Leather and Allied Product Manufacturing", internal_name: "leather-and-allied-product-manufacturing", industry_type: :subsector, naics_code: "316").first_or_create
    IndustryCode.where(name: "Wood Product Manufacturing", internal_name: "wood-product-manufacturing", industry_type: :subsector, naics_code: "321").first_or_create
    IndustryCode.where(name: "Paper Manufacturing", internal_name: "paper-manufacturing", industry_type: :subsector, naics_code: "322").first_or_create
    IndustryCode.where(name: "Printing and Related Support Activities", internal_name: "printing-and-related-support-activities", industry_type: :subsector, naics_code: "323").first_or_create
    IndustryCode.where(name: "Petroleum and Coal Products Manufacturing", internal_name: "petroleum-and-coal-products-manufacturing", industry_type: :subsector, naics_code: "324").first_or_create
    IndustryCode.where(name: "Chemical Manufacturing", internal_name: "chemical-manufacturing", industry_type: :subsector, naics_code: "325").first_or_create
    IndustryCode.where(name: "Plastics and Rubber Products Manufacturing", internal_name: "plastics-and-rubber-products-manufacturing", industry_type: :subsector, naics_code: "326").first_or_create
    IndustryCode.where(name: "Nonmetallic Mineral Product Manufacturing", internal_name: "nonmetallic-mineral-product-manufacturing", industry_type: :subsector, naics_code: "327").first_or_create
    IndustryCode.where(name: "Primary Metal Manufacturing", internal_name: "primary-metal-manufacturing", industry_type: :subsector, naics_code: "331").first_or_create
    IndustryCode.where(name: "Fabricated Metal Product Manufacturing", internal_name: "fabricated-metal-product-manufacturing", industry_type: :subsector, naics_code: "332").first_or_create
    IndustryCode.where(name: "Machinery Manufacturing", internal_name: "machinery-manufacturing", industry_type: :subsector, naics_code: "333").first_or_create
    IndustryCode.where(name: "Computer and Electronic Product Manufacturing", internal_name: "computer-and-electronic-product-manufacturing", industry_type: :subsector, naics_code: "334").first_or_create
    IndustryCode.where(name: "Electrical Equipment, Appliance, and Component Manufacturing", internal_name: "electrical-equipment-appliance-and-component-manufacturing", industry_type: :subsector, naics_code: "335").first_or_create
    IndustryCode.where(name: "Transportation Equipment Manufacturing", internal_name: "transportation-equipment-manufacturing", industry_type: :subsector, naics_code: "336").first_or_create
    IndustryCode.where(name: "Furniture and Related Product Manufacturing", internal_name: "furniture-and-related-product-manufacturing", industry_type: :subsector, naics_code: "337").first_or_create
    IndustryCode.where(name: "Miscellaneous Manufacturing", internal_name: "miscellaneous-manufacturing", industry_type: :subsector, naics_code: "339").first_or_create
    IndustryCode.where(name: "Merchant Wholesalers, Durable Goods", internal_name: "merchant-wholesalers-durable-goods", industry_type: :subsector, naics_code: "423").first_or_create
    IndustryCode.where(name: "Merchant Wholesalers, Nondurable Goods", internal_name: "merchant-wholesalers-nondurable-goods", industry_type: :subsector, naics_code: "424").first_or_create
    IndustryCode.where(name: "Wholesale Electronic Markets and Agents and Brokers", internal_name: "wholesale-electronic-markets-and-agents-and-brokers", industry_type: :subsector, naics_code: "425").first_or_create
    IndustryCode.where(name: "Motor Vehicle and Parts Dealers", internal_name: "motor-vehicle-and-parts-dealers", industry_type: :subsector, naics_code: "441").first_or_create
    IndustryCode.where(name: "Furniture and Home Furnishings Stores", internal_name: "furniture-and-home-furnishings-stores", industry_type: :subsector, naics_code: "442").first_or_create
    IndustryCode.where(name: "Electronics and Appliance Stores", internal_name: "electronics-and-appliance-stores", industry_type: :subsector, naics_code: "443").first_or_create
    IndustryCode.where(name: "Building Material and Garden Equipment and Supplies Dealers", internal_name: "building-material-and-garden-equipment-and-supplies-dealers", industry_type: :subsector, naics_code: "444").first_or_create
    IndustryCode.where(name: "Food and Beverage Stores", internal_name: "food-and-beverage-stores", industry_type: :subsector, naics_code: "445").first_or_create
    IndustryCode.where(name: "Health and Personal Care Stores", internal_name: "health-and-personal-care-stores", industry_type: :subsector, naics_code: "446").first_or_create
    IndustryCode.where(name: "Gasoline Stations", internal_name: "gasoline-stations", industry_type: :subsector, naics_code: "447").first_or_create
    IndustryCode.where(name: "Clothing and Clothing Accessories Stores", internal_name: "clothing-and-clothing-accessories-stores", industry_type: :subsector, naics_code: "448").first_or_create
    IndustryCode.where(name: "Sporting Goods, Hobby, Musical Instrument, and Book Stores", internal_name: "sporting-goods-hobby-musical-instrument-and-book-stores", industry_type: :subsector, naics_code: "451").first_or_create
    IndustryCode.where(name: "General Merchandise Stores", internal_name: "general-merchandise-stores", industry_type: :subsector, naics_code: "452").first_or_create
    IndustryCode.where(name: "Miscellaneous Store Retailers", internal_name: "miscellaneous-store-retailers", industry_type: :subsector, naics_code: "453").first_or_create
    IndustryCode.where(name: "Nonstore Retailers", internal_name: "nonstore-retailers", industry_type: :subsector, naics_code: "454").first_or_create
    IndustryCode.where(name: "Air Transportation", internal_name: "air-transportation", industry_type: :subsector, naics_code: "481").first_or_create
    IndustryCode.where(name: "Rail Transportation", internal_name: "rail-transportation", industry_type: :subsector, naics_code: "482").first_or_create
    IndustryCode.where(name: "Water Transportation", internal_name: "water-transportation", industry_type: :subsector, naics_code: "483").first_or_create
    IndustryCode.where(name: "Truck Transportation", internal_name: "truck-transportation", industry_type: :subsector, naics_code: "484").first_or_create
    IndustryCode.where(name: "Transit and Ground Passenger Transportation", internal_name: "transit-and-ground-passenger-transportation", industry_type: :subsector, naics_code: "485").first_or_create
    IndustryCode.where(name: "Pipeline Transportation", internal_name: "pipeline-transportation", industry_type: :subsector, naics_code: "486").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation", internal_name: "scenic-and-sightseeing-transportation", industry_type: :subsector, naics_code: "487").first_or_create
    IndustryCode.where(name: "Support Activities for Transportation", internal_name: "support-activities-for-transportation", industry_type: :subsector, naics_code: "488").first_or_create
    IndustryCode.where(name: "Postal Service", internal_name: "postal-service", industry_type: :subsector, naics_code: "491").first_or_create
    IndustryCode.where(name: "Couriers and Messengers", internal_name: "couriers-and-messengers", industry_type: :subsector, naics_code: "492").first_or_create
    IndustryCode.where(name: "Warehousing and Storage", internal_name: "warehousing-and-storage", industry_type: :subsector, naics_code: "493").first_or_create
    IndustryCode.where(name: "Publishing Industries (except Internet)", internal_name: "publishing-industries-except-internet", industry_type: :subsector, naics_code: "511").first_or_create
    IndustryCode.where(name: "Motion Picture and Sound Recording Industries", internal_name: "motion-picture-and-sound-recording-industries", industry_type: :subsector, naics_code: "512").first_or_create
    IndustryCode.where(name: "Broadcasting (except Internet)", internal_name: "broadcasting-except-internet", industry_type: :subsector, naics_code: "515").first_or_create
    IndustryCode.where(name: "Telecommunications", internal_name: "telecommunications", industry_type: :subsector, naics_code: "517").first_or_create
    IndustryCode.where(name: "Data Processing, Hosting, and Related Services", internal_name: "data-processing-hosting-and-related-services", industry_type: :subsector, naics_code: "518").first_or_create
    IndustryCode.where(name: "Other Information Services", internal_name: "other-information-services", industry_type: :subsector, naics_code: "519").first_or_create
    IndustryCode.where(name: "Monetary Authorities-Central Bank", internal_name: "monetary-authorities-central-bank", industry_type: :subsector, naics_code: "521").first_or_create
    IndustryCode.where(name: "Credit Intermediation and Related Activities", internal_name: "credit-intermediation-and-related-activities", industry_type: :subsector, naics_code: "522").first_or_create
    IndustryCode.where(name: "Securities, Commodity Contracts, and Other Financial Investments and Related Activities", internal_name: "securities-commodity-contracts-and-other-financial-investments-and-related-activities", industry_type: :subsector, naics_code: "523").first_or_create
    IndustryCode.where(name: "Insurance Carriers and Related Activities", internal_name: "insurance-carriers-and-related-activities", industry_type: :subsector, naics_code: "524").first_or_create
    IndustryCode.where(name: "Funds, Trusts, and Other Financial Vehicles", internal_name: "funds-trusts-and-other-financial-vehicles", industry_type: :subsector, naics_code: "525").first_or_create
    IndustryCode.where(name: "Real Estate", internal_name: "real-estate", industry_type: :subsector, naics_code: "531").first_or_create
    IndustryCode.where(name: "Rental and Leasing Services", internal_name: "rental-and-leasing-services", industry_type: :subsector, naics_code: "532").first_or_create
    IndustryCode.where(name: "Lessors of Nonfinancial Intangible Assets (except Copyrighted Works)", internal_name: "lessors-of-nonfinancial-intangible-assets-except-copyrighted-works", industry_type: :subsector, naics_code: "533").first_or_create
    IndustryCode.where(name: "Professional, Scientific, and Technical Services Subsector", internal_name: "professional-scientific-and-technical-services-subsector", industry_type: :subsector, naics_code: "541").first_or_create
    IndustryCode.where(name: "Management of Companies and Enterprises Subsector", internal_name: "management-of-companies-and-enterprises-subsector", industry_type: :subsector, naics_code: "551").first_or_create
    IndustryCode.where(name: "Administrative and Support Services", internal_name: "administrative-and-support-services", industry_type: :subsector, naics_code: "561").first_or_create
    IndustryCode.where(name: "Waste Management and Remediation Services", internal_name: "waste-management-and-remediation-services", industry_type: :subsector, naics_code: "562").first_or_create
    IndustryCode.where(name: "Educational Services Subsector", internal_name: "educational-services-subsector", industry_type: :subsector, naics_code: "611").first_or_create
    IndustryCode.where(name: "Ambulatory Health Care Services", internal_name: "ambulatory-health-care-services", industry_type: :subsector, naics_code: "621").first_or_create
    IndustryCode.where(name: "Hospitals", internal_name: "hospitals", industry_type: :subsector, naics_code: "622").first_or_create
    IndustryCode.where(name: "Nursing and Residential Care Facilities", internal_name: "nursing-and-residential-care-facilities", industry_type: :subsector, naics_code: "623").first_or_create
    IndustryCode.where(name: "Social Assistance", internal_name: "social-assistance", industry_type: :subsector, naics_code: "624").first_or_create
    IndustryCode.where(name: "Performing Arts, Spectator Sports, and Related Industries", internal_name: "performing-arts-spectator-sports-and-related-industries", industry_type: :subsector, naics_code: "711").first_or_create
    IndustryCode.where(name: "Museums, Historical Sites, and Similar Institutions", internal_name: "museums-historical-sites-and-similar-institutions", industry_type: :subsector, naics_code: "712").first_or_create
    IndustryCode.where(name: "Amusement, Gambling, and Recreation Industries", internal_name: "amusement-gambling-and-recreation-industries", industry_type: :subsector, naics_code: "713").first_or_create
    IndustryCode.where(name: "Accommodation", internal_name: "accommodation", industry_type: :subsector, naics_code: "721").first_or_create
    IndustryCode.where(name: "Food Services and Drinking Places", internal_name: "food-services-and-drinking-places", industry_type: :subsector, naics_code: "722").first_or_create
    IndustryCode.where(name: "Repair and Maintenance", internal_name: "repair-and-maintenance", industry_type: :subsector, naics_code: "811").first_or_create
    IndustryCode.where(name: "Personal and Laundry Services", internal_name: "personal-and-laundry-services", industry_type: :subsector, naics_code: "812").first_or_create
    IndustryCode.where(name: "Religious, Grantmaking, Civic, Professional, and Similar Organizations", internal_name: "religious-grantmaking-civic-professional-and-similar-organizations", industry_type: :subsector, naics_code: "813").first_or_create
    IndustryCode.where(name: "Private Households", internal_name: "private-households", industry_type: :subsector, naics_code: "814").first_or_create
    IndustryCode.where(name: "Executive, Legislative, and Other General Government Support", internal_name: "executive-legislative-and-other-general-government-support", industry_type: :subsector, naics_code: "921").first_or_create
    IndustryCode.where(name: "Justice, Public Order, and Safety Activities", internal_name: "justice-public-order-and-safety-activities", industry_type: :subsector, naics_code: "922").first_or_create
    IndustryCode.where(name: "Administration of Human Resource Programs", internal_name: "administration-of-human-resource-programs", industry_type: :subsector, naics_code: "923").first_or_create
    IndustryCode.where(name: "Administration of Environmental Quality Programs", internal_name: "administration-of-environmental-quality-programs", industry_type: :subsector, naics_code: "924").first_or_create
    IndustryCode.where(name: "Administration of Housing Programs, Urban Planning, and Community Development", internal_name: "administration-of-housing-programs-urban-planning-and-community-development", industry_type: :subsector, naics_code: "925").first_or_create
    IndustryCode.where(name: "Administration of Economic Programs", internal_name: "administration-of-economic-programs", industry_type: :subsector, naics_code: "926").first_or_create
    IndustryCode.where(name: "Space Research and Technology", internal_name: "space-research-and-technology", industry_type: :subsector, naics_code: "927").first_or_create
    IndustryCode.where(name: "National Security and International Affairs", internal_name: "national-security-and-international-affairs", industry_type: :subsector, naics_code: "928").first_or_create

    #NAICS industry_group
    IndustryCode.where(name: "Oilseed and Grain Farming", internal_name: "oilseed-and-grain-farming", industry_type: :industry_group, naics_code: "1111").first_or_create
    IndustryCode.where(name: "Vegetable and Melon Farming", internal_name: "vegetable-and-melon-farming", industry_type: :industry_group, naics_code: "1112").first_or_create
    IndustryCode.where(name: "Fruit and Tree Nut Farming", internal_name: "fruit-and-tree-nut-farming", industry_type: :industry_group, naics_code: "1113").first_or_create
    IndustryCode.where(name: "Greenhouse, Nursery, and Floriculture Production", internal_name: "greenhouse-nursery-and-floriculture-production", industry_type: :industry_group, naics_code: "1114").first_or_create
    IndustryCode.where(name: "Other Crop Farming", internal_name: "other-crop-farming", industry_type: :industry_group, naics_code: "1119").first_or_create
    IndustryCode.where(name: "Cattle Ranching and Farming", internal_name: "cattle-ranching-and-farming", industry_type: :industry_group, naics_code: "1121").first_or_create
    IndustryCode.where(name: "Hog and Pig Farming", internal_name: "hog-and-pig-farming", industry_type: :industry_group, naics_code: "1122").first_or_create
    IndustryCode.where(name: "Poultry and Egg Production", internal_name: "poultry-and-egg-production", industry_type: :industry_group, naics_code: "1123").first_or_create
    IndustryCode.where(name: "Sheep and Goat Farming", internal_name: "sheep-and-goat-farming", industry_type: :industry_group, naics_code: "1124").first_or_create
    IndustryCode.where(name: "Aquaculture", internal_name: "aquaculture", industry_type: :industry_group, naics_code: "1125").first_or_create
    IndustryCode.where(name: "Other Animal Production", internal_name: "other-animal-production", industry_type: :industry_group, naics_code: "1129").first_or_create
    IndustryCode.where(name: "Timber Tract Operations", internal_name: "timber-tract-operations", industry_type: :industry_group, naics_code: "1131").first_or_create
    IndustryCode.where(name: "Forest Nurseries and Gathering of Forest Products", internal_name: "forest-nurseries-and-gathering-of-forest-products", industry_type: :industry_group, naics_code: "1132").first_or_create
    IndustryCode.where(name: "Logging", internal_name: "logging", industry_type: :industry_group, naics_code: "1133").first_or_create
    IndustryCode.where(name: "Fishing", internal_name: "fishing", industry_type: :industry_group, naics_code: "1141").first_or_create
    IndustryCode.where(name: "Hunting and Trapping", internal_name: "hunting-and-trapping", industry_type: :industry_group, naics_code: "1142").first_or_create
    IndustryCode.where(name: "Support Activities for Crop Production", internal_name: "support-activities-for-crop-production", industry_type: :industry_group, naics_code: "1151").first_or_create
    IndustryCode.where(name: "Support Activities for Animal Production", internal_name: "support-activities-for-animal-production", industry_type: :industry_group, naics_code: "1152").first_or_create
    IndustryCode.where(name: "Support Activities for Forestry", internal_name: "support-activities-for-forestry", industry_type: :industry_group, naics_code: "1153").first_or_create
    IndustryCode.where(name: "Oil and Gas Extraction", internal_name: "oil-and-gas-extraction", industry_type: :industry_group, naics_code: "2111").first_or_create
    IndustryCode.where(name: "Coal Mining", internal_name: "coal-mining", industry_type: :industry_group, naics_code: "2121").first_or_create
    IndustryCode.where(name: "Metal Ore Mining", internal_name: "metal-ore-mining", industry_type: :industry_group, naics_code: "2122").first_or_create
    IndustryCode.where(name: "Nonmetallic Mineral Mining and Quarrying", internal_name: "nonmetallic-mineral-mining-and-quarrying", industry_type: :industry_group, naics_code: "2123").first_or_create
    IndustryCode.where(name: "Support Activities for Mining", internal_name: "support-activities-for-mining", industry_type: :industry_group, naics_code: "2131").first_or_create
    IndustryCode.where(name: "Electric Power Generation, Transmission and Distribution", internal_name: "electric-power-generation-transmission-and-distribution", industry_type: :industry_group, naics_code: "2211").first_or_create
    IndustryCode.where(name: "Natural Gas Distribution", internal_name: "natural-gas-distribution", industry_type: :industry_group, naics_code: "2212").first_or_create
    IndustryCode.where(name: "Water, Sewage and Other Systems", internal_name: "water-sewage-and-other-systems", industry_type: :industry_group, naics_code: "2213").first_or_create
    IndustryCode.where(name: "Residential Building Construction", internal_name: "residential-building-construction", industry_type: :industry_group, naics_code: "2361").first_or_create
    IndustryCode.where(name: "Nonresidential Building Construction", internal_name: "nonresidential-building-construction", industry_type: :industry_group, naics_code: "2362").first_or_create
    IndustryCode.where(name: "Utility System Construction", internal_name: "utility-system-construction", industry_type: :industry_group, naics_code: "2371").first_or_create
    IndustryCode.where(name: "Land Subdivision", internal_name: "land-subdivision", industry_type: :industry_group, naics_code: "2372").first_or_create
    IndustryCode.where(name: "Highway, Street, and Bridge Construction", internal_name: "highway-street-and-bridge-construction", industry_type: :industry_group, naics_code: "2373").first_or_create
    IndustryCode.where(name: "Other Heavy and Civil Engineering Construction", internal_name: "other-heavy-and-civil-engineering-construction", industry_type: :industry_group, naics_code: "2379").first_or_create
    IndustryCode.where(name: "Foundation, Structure, and Building Exterior Contractors", internal_name: "foundation-structure-and-building-exterior-contractors", industry_type: :industry_group, naics_code: "2381").first_or_create
    IndustryCode.where(name: "Building Equipment Contractors", internal_name: "building-equipment-contractors", industry_type: :industry_group, naics_code: "2382").first_or_create
    IndustryCode.where(name: "Building Finishing Contractors", internal_name: "building-finishing-contractors", industry_type: :industry_group, naics_code: "2383").first_or_create
    IndustryCode.where(name: "Other Specialty Trade Contractors", internal_name: "other-specialty-trade-contractors", industry_type: :industry_group, naics_code: "2389").first_or_create
    IndustryCode.where(name: "Animal Food Manufacturing", internal_name: "animal-food-manufacturing", industry_type: :industry_group, naics_code: "3111").first_or_create
    IndustryCode.where(name: "Grain and Oilseed Milling", internal_name: "grain-and-oilseed-milling", industry_type: :industry_group, naics_code: "3112").first_or_create
    IndustryCode.where(name: "Sugar and Confectionery Product Manufacturing", internal_name: "sugar-and-confectionery-product-manufacturing", industry_type: :industry_group, naics_code: "3113").first_or_create
    IndustryCode.where(name: "Fruit and Vegetable Preserving and Specialty Food Manufacturing", internal_name: "fruit-and-vegetable-preserving-and-specialty-food-manufacturing", industry_type: :industry_group, naics_code: "3114").first_or_create
    IndustryCode.where(name: "Dairy Product Manufacturing", internal_name: "dairy-product-manufacturing", industry_type: :industry_group, naics_code: "3115").first_or_create
    IndustryCode.where(name: "Animal Slaughtering and Processing", internal_name: "animal-slaughtering-and-processing", industry_type: :industry_group, naics_code: "3116").first_or_create
    IndustryCode.where(name: "Seafood Product Preparation and Packaging", internal_name: "seafood-product-preparation-and-packaging", industry_type: :industry_group, naics_code: "3117").first_or_create
    IndustryCode.where(name: "Bakeries and Tortilla Manufacturing", internal_name: "bakeries-and-tortilla-manufacturing", industry_type: :industry_group, naics_code: "3118").first_or_create
    IndustryCode.where(name: "Other Food Manufacturing", internal_name: "other-food-manufacturing", industry_type: :industry_group, naics_code: "3119").first_or_create
    IndustryCode.where(name: "Beverage Manufacturing", internal_name: "beverage-manufacturing", industry_type: :industry_group, naics_code: "3121").first_or_create
    IndustryCode.where(name: "Tobacco Manufacturing", internal_name: "tobacco-manufacturing", industry_type: :industry_group, naics_code: "3122").first_or_create
    IndustryCode.where(name: "Fiber, Yarn, and Thread Mills", internal_name: "fiber-yarn-and-thread-mills", industry_type: :industry_group, naics_code: "3131").first_or_create
    IndustryCode.where(name: "Fabric Mills", internal_name: "fabric-mills", industry_type: :industry_group, naics_code: "3132").first_or_create
    IndustryCode.where(name: "Textile and Fabric Finishing and Fabric Coating Mills", internal_name: "textile-and-fabric-finishing-and-fabric-coating-mills", industry_type: :industry_group, naics_code: "3133").first_or_create
    IndustryCode.where(name: "Textile Furnishings Mills", internal_name: "textile-furnishings-mills", industry_type: :industry_group, naics_code: "3141").first_or_create
    IndustryCode.where(name: "Other Textile Product Mills", internal_name: "other-textile-product-mills", industry_type: :industry_group, naics_code: "3149").first_or_create
    IndustryCode.where(name: "Apparel Knitting Mills", internal_name: "apparel-knitting-mills", industry_type: :industry_group, naics_code: "3151").first_or_create
    IndustryCode.where(name: "Cut and Sew Apparel Manufacturing", internal_name: "cut-and-sew-apparel-manufacturing", industry_type: :industry_group, naics_code: "3152").first_or_create
    IndustryCode.where(name: "Apparel Accessories and Other Apparel Manufacturing", internal_name: "apparel-accessories-and-other-apparel-manufacturing", industry_type: :industry_group, naics_code: "3159").first_or_create
    IndustryCode.where(name: "Leather and Hide Tanning and Finishing", internal_name: "leather-and-hide-tanning-and-finishing", industry_type: :industry_group, naics_code: "3161").first_or_create
    IndustryCode.where(name: "Footwear Manufacturing", internal_name: "footwear-manufacturing", industry_type: :industry_group, naics_code: "3162").first_or_create
    IndustryCode.where(name: "Other Leather and Allied Product Manufacturing", internal_name: "other-leather-and-allied-product-manufacturing", industry_type: :industry_group, naics_code: "3169").first_or_create
    IndustryCode.where(name: "Sawmills and Wood Preservation", internal_name: "sawmills-and-wood-preservation", industry_type: :industry_group, naics_code: "3211").first_or_create
    IndustryCode.where(name: "Veneer, Plywood, and Engineered Wood Product Manufacturing", internal_name: "veneer-plywood-and-engineered-wood-product-manufacturing", industry_type: :industry_group, naics_code: "3212").first_or_create
    IndustryCode.where(name: "Other Wood Product Manufacturing", internal_name: "other-wood-product-manufacturing", industry_type: :industry_group, naics_code: "3219").first_or_create
    IndustryCode.where(name: "Pulp, Paper, and Paperboard Mills", internal_name: "pulp-paper-and-paperboard-mills", industry_type: :industry_group, naics_code: "3221").first_or_create
    IndustryCode.where(name: "Converted Paper Product Manufacturing", internal_name: "converted-paper-product-manufacturing", industry_type: :industry_group, naics_code: "3222").first_or_create
    IndustryCode.where(name: "Printing and Related Support Activities", internal_name: "printing-and-related-support-activities", industry_type: :industry_group, naics_code: "3231").first_or_create
    IndustryCode.where(name: "Petroleum and Coal Products Manufacturing", internal_name: "petroleum-and-coal-products-manufacturing", industry_type: :industry_group, naics_code: "3241").first_or_create
    IndustryCode.where(name: "Basic Chemical Manufacturing", internal_name: "basic-chemical-manufacturing", industry_type: :industry_group, naics_code: "3251").first_or_create
    IndustryCode.where(name: "Resin, Synthetic Rubber, and Artificial Synthetic Fibers and Filaments Manufacturing", internal_name: "resin-synthetic-rubber-and-artificial-synthetic-fibers-and-filaments-manufacturing", industry_type: :industry_group, naics_code: "3252").first_or_create
    IndustryCode.where(name: "Pesticide, Fertilizer, and Other Agricultural Chemical Manufacturing", internal_name: "pesticide-fertilizer-and-other-agricultural-chemical-manufacturing", industry_type: :industry_group, naics_code: "3253").first_or_create
    IndustryCode.where(name: "Pharmaceutical and Medicine Manufacturing", internal_name: "pharmaceutical-and-medicine-manufacturing", industry_type: :industry_group, naics_code: "3254").first_or_create
    IndustryCode.where(name: "Paint, Coating, and Adhesive Manufacturing", internal_name: "paint-coating-and-adhesive-manufacturing", industry_type: :industry_group, naics_code: "3255").first_or_create
    IndustryCode.where(name: "Soap, Cleaning Compound, and Toilet Preparation Manufacturing", internal_name: "soap-cleaning-compound-and-toilet-preparation-manufacturing", industry_type: :industry_group, naics_code: "3256").first_or_create
    IndustryCode.where(name: "Other Chemical Product and Preparation Manufacturing", internal_name: "other-chemical-product-and-preparation-manufacturing", industry_type: :industry_group, naics_code: "3259").first_or_create
    IndustryCode.where(name: "Plastics Product Manufacturing", internal_name: "plastics-product-manufacturing", industry_type: :industry_group, naics_code: "3261").first_or_create
    IndustryCode.where(name: "Rubber Product Manufacturing", internal_name: "rubber-product-manufacturing", industry_type: :industry_group, naics_code: "3262").first_or_create
    IndustryCode.where(name: "Clay Product and Refractory Manufacturing", internal_name: "clay-product-and-refractory-manufacturing", industry_type: :industry_group, naics_code: "3271").first_or_create
    IndustryCode.where(name: "Glass and Glass Product Manufacturing", internal_name: "glass-and-glass-product-manufacturing", industry_type: :industry_group, naics_code: "3272").first_or_create
    IndustryCode.where(name: "Cement and Concrete Product Manufacturing", internal_name: "cement-and-concrete-product-manufacturing", industry_type: :industry_group, naics_code: "3273").first_or_create
    IndustryCode.where(name: "Lime and Gypsum Product Manufacturing", internal_name: "lime-and-gypsum-product-manufacturing", industry_type: :industry_group, naics_code: "3274").first_or_create
    IndustryCode.where(name: "Other Nonmetallic Mineral Product Manufacturing", internal_name: "other-nonmetallic-mineral-product-manufacturing", industry_type: :industry_group, naics_code: "3279").first_or_create
    IndustryCode.where(name: "Iron and Steel Mills and Ferroalloy Manufacturing", internal_name: "iron-and-steel-mills-and-ferroalloy-manufacturing", industry_type: :industry_group, naics_code: "3311").first_or_create
    IndustryCode.where(name: "Steel Product Manufacturing from Purchased Steel", internal_name: "steel-product-manufacturing-from-purchased-steel", industry_type: :industry_group, naics_code: "3312").first_or_create
    IndustryCode.where(name: "Alumina and Aluminum Production and Processing", internal_name: "alumina-and-aluminum-production-and-processing", industry_type: :industry_group, naics_code: "3313").first_or_create
    IndustryCode.where(name: "Nonferrous Metal (except Aluminum) Production and Processing", internal_name: "nonferrous-metal-except-aluminum-production-and-processing", industry_type: :industry_group, naics_code: "3314").first_or_create
    IndustryCode.where(name: "Foundries", internal_name: "foundries", industry_type: :industry_group, naics_code: "3315").first_or_create
    IndustryCode.where(name: "Forging and Stamping", internal_name: "forging-and-stamping", industry_type: :industry_group, naics_code: "3321").first_or_create
    IndustryCode.where(name: "Cutlery and Handtool Manufacturing", internal_name: "cutlery-and-handtool-manufacturing", industry_type: :industry_group, naics_code: "3322").first_or_create
    IndustryCode.where(name: "Architectural and Structural Metals Manufacturing", internal_name: "architectural-and-structural-metals-manufacturing", industry_type: :industry_group, naics_code: "3323").first_or_create
    IndustryCode.where(name: "Boiler, Tank, and Shipping Container Manufacturing", internal_name: "boiler-tank-and-shipping-container-manufacturing", industry_type: :industry_group, naics_code: "3324").first_or_create
    IndustryCode.where(name: "Hardware Manufacturing", internal_name: "hardware-manufacturing", industry_type: :industry_group, naics_code: "3325").first_or_create
    IndustryCode.where(name: "Spring and Wire Product Manufacturing", internal_name: "spring-and-wire-product-manufacturing", industry_type: :industry_group, naics_code: "3326").first_or_create
    IndustryCode.where(name: "Machine Shops; Turned Product; and Screw, Nut, and Bolt Manufacturing", internal_name: "machine-shops;-turned-product;-and-screw-nut-and-bolt-manufacturing", industry_type: :industry_group, naics_code: "3327").first_or_create
    IndustryCode.where(name: "Coating, Engraving, Heat Treating, and Allied Activities", internal_name: "coating-engraving-heat-treating-and-allied-activities", industry_type: :industry_group, naics_code: "3328").first_or_create
    IndustryCode.where(name: "Other Fabricated Metal Product Manufacturing", internal_name: "other-fabricated-metal-product-manufacturing", industry_type: :industry_group, naics_code: "3329").first_or_create
    IndustryCode.where(name: "Agriculture, Construction, and Mining Machinery Manufacturing", internal_name: "agriculture-construction-and-mining-machinery-manufacturing", industry_type: :industry_group, naics_code: "3331").first_or_create
    IndustryCode.where(name: "Industrial Machinery Manufacturing", internal_name: "industrial-machinery-manufacturing", industry_type: :industry_group, naics_code: "3332").first_or_create
    IndustryCode.where(name: "Commercial and Service Industry Machinery Manufacturing", internal_name: "commercial-and-service-industry-machinery-manufacturing", industry_type: :industry_group, naics_code: "3333").first_or_create
    IndustryCode.where(name: "Ventilation, Heating, Air-Conditioning, and Commercial Refrigeration Equipment Manufacturing", internal_name: "ventilation-heating-air-conditioning-and-commercial-refrigeration-equipment-manufacturing", industry_type: :industry_group, naics_code: "3334").first_or_create
    IndustryCode.where(name: "Metalworking Machinery Manufacturing", internal_name: "metalworking-machinery-manufacturing", industry_type: :industry_group, naics_code: "3335").first_or_create
    IndustryCode.where(name: "Engine, Turbine, and Power Transmission Equipment Manufacturing", internal_name: "engine-turbine-and-power-transmission-equipment-manufacturing", industry_type: :industry_group, naics_code: "3336").first_or_create
    IndustryCode.where(name: "Other General Purpose Machinery Manufacturing", internal_name: "other-general-purpose-machinery-manufacturing", industry_type: :industry_group, naics_code: "3339").first_or_create
    IndustryCode.where(name: "Computer and Peripheral Equipment Manufacturing", internal_name: "computer-and-peripheral-equipment-manufacturing", industry_type: :industry_group, naics_code: "3341").first_or_create
    IndustryCode.where(name: "Communications Equipment Manufacturing", internal_name: "communications-equipment-manufacturing", industry_type: :industry_group, naics_code: "3342").first_or_create
    IndustryCode.where(name: "Audio and Video Equipment Manufacturing", internal_name: "audio-and-video-equipment-manufacturing", industry_type: :industry_group, naics_code: "3343").first_or_create
    IndustryCode.where(name: "Semiconductor and Other Electronic Component Manufacturing", internal_name: "semiconductor-and-other-electronic-component-manufacturing", industry_type: :industry_group, naics_code: "3344").first_or_create
    IndustryCode.where(name: "Navigational, Measuring, Electromedical, and Control Instruments Manufacturing", internal_name: "navigational-measuring-electromedical-and-control-instruments-manufacturing", industry_type: :industry_group, naics_code: "3345").first_or_create
    IndustryCode.where(name: "Manufacturing and Reproducing Magnetic and Optical Media", internal_name: "manufacturing-and-reproducing-magnetic-and-optical-media", industry_type: :industry_group, naics_code: "3346").first_or_create
    IndustryCode.where(name: "Electric Lighting Equipment Manufacturing", internal_name: "electric-lighting-equipment-manufacturing", industry_type: :industry_group, naics_code: "3351").first_or_create
    IndustryCode.where(name: "Household Appliance Manufacturing", internal_name: "household-appliance-manufacturing", industry_type: :industry_group, naics_code: "3352").first_or_create
    IndustryCode.where(name: "Electrical Equipment Manufacturing", internal_name: "electrical-equipment-manufacturing", industry_type: :industry_group, naics_code: "3353").first_or_create
    IndustryCode.where(name: "Other Electrical Equipment and Component Manufacturing", internal_name: "other-electrical-equipment-and-component-manufacturing", industry_type: :industry_group, naics_code: "3359").first_or_create
    IndustryCode.where(name: "Motor Vehicle Manufacturing", internal_name: "motor-vehicle-manufacturing", industry_type: :industry_group, naics_code: "3361").first_or_create
    IndustryCode.where(name: "Motor Vehicle Body and Trailer Manufacturing", internal_name: "motor-vehicle-body-and-trailer-manufacturing", industry_type: :industry_group, naics_code: "3362").first_or_create
    IndustryCode.where(name: "Motor Vehicle Parts Manufacturing", internal_name: "motor-vehicle-parts-manufacturing", industry_type: :industry_group, naics_code: "3363").first_or_create
    IndustryCode.where(name: "Aerospace Product and Parts Manufacturing", internal_name: "aerospace-product-and-parts-manufacturing", industry_type: :industry_group, naics_code: "3364").first_or_create
    IndustryCode.where(name: "Railroad Rolling Stock Manufacturing", internal_name: "railroad-rolling-stock-manufacturing", industry_type: :industry_group, naics_code: "3365").first_or_create
    IndustryCode.where(name: "Ship and Boat Building", internal_name: "ship-and-boat-building", industry_type: :industry_group, naics_code: "3366").first_or_create
    IndustryCode.where(name: "Other Transportation Equipment Manufacturing", internal_name: "other-transportation-equipment-manufacturing", industry_type: :industry_group, naics_code: "3369").first_or_create
    IndustryCode.where(name: "Household and Institutional Furniture and Kitchen Cabinet Manufacturing", internal_name: "household-and-institutional-furniture-and-kitchen-cabinet-manufacturing", industry_type: :industry_group, naics_code: "3371").first_or_create
    IndustryCode.where(name: "Office Furniture (including Fixtures) Manufacturing", internal_name: "office-furniture-including-fixtures-manufacturing", industry_type: :industry_group, naics_code: "3372").first_or_create
    IndustryCode.where(name: "Other Furniture Related Product Manufacturing", internal_name: "other-furniture-related-product-manufacturing", industry_type: :industry_group, naics_code: "3379").first_or_create
    IndustryCode.where(name: "Medical Equipment and Supplies Manufacturing", internal_name: "medical-equipment-and-supplies-manufacturing", industry_type: :industry_group, naics_code: "3391").first_or_create
    IndustryCode.where(name: "Other Miscellaneous Manufacturing", internal_name: "other-miscellaneous-manufacturing", industry_type: :industry_group, naics_code: "3399").first_or_create
    IndustryCode.where(name: "Motor Vehicle and Motor Vehicle Parts and Supplies Merchant Wholesalers", internal_name: "motor-vehicle-and-motor-vehicle-parts-and-supplies-merchant-wholesalers", industry_type: :industry_group, naics_code: "4231").first_or_create
    IndustryCode.where(name: "Furniture and Home Furnishing Merchant Wholesalers", internal_name: "furniture-and-home-furnishing-merchant-wholesalers", industry_type: :industry_group, naics_code: "4232").first_or_create
    IndustryCode.where(name: "Lumber and Other Construction Materials Merchant Wholesalers", internal_name: "lumber-and-other-construction-materials-merchant-wholesalers", industry_type: :industry_group, naics_code: "4233").first_or_create
    IndustryCode.where(name: "Professional and Commercial Equipment and Supplies Merchant Wholesalers", internal_name: "professional-and-commercial-equipment-and-supplies-merchant-wholesalers", industry_type: :industry_group, naics_code: "4234").first_or_create
    IndustryCode.where(name: "Metal and Mineral (except Petroleum) Merchant Wholesalers", internal_name: "metal-and-mineral-except-petroleum-merchant-wholesalers", industry_type: :industry_group, naics_code: "4235").first_or_create
    IndustryCode.where(name: "Household Appliances and Electrical and Electronic Goods Merchant Wholesalers", internal_name: "household-appliances-and-electrical-and-electronic-goods-merchant-wholesalers", industry_type: :industry_group, naics_code: "4236").first_or_create
    IndustryCode.where(name: "Hardware, and Plumbing and Heating Equipment and Supplies Merchant Wholesalers", internal_name: "hardware-and-plumbing-and-heating-equipment-and-supplies-merchant-wholesalers", industry_type: :industry_group, naics_code: "4237").first_or_create
    IndustryCode.where(name: "Machinery, Equipment, and Supplies Merchant Wholesalers", internal_name: "machinery-equipment-and-supplies-merchant-wholesalers", industry_type: :industry_group, naics_code: "4238").first_or_create
    IndustryCode.where(name: "Miscellaneous Durable Goods Merchant Wholesalers", internal_name: "miscellaneous-durable-goods-merchant-wholesalers", industry_type: :industry_group, naics_code: "4239").first_or_create
    IndustryCode.where(name: "Paper and Paper Product Merchant Wholesalers", internal_name: "paper-and-paper-product-merchant-wholesalers", industry_type: :industry_group, naics_code: "4241").first_or_create
    IndustryCode.where(name: "Drugs and Druggists' Sundries Merchant Wholesalers", internal_name: "drugs-and-druggists'-sundries-merchant-wholesalers", industry_type: :industry_group, naics_code: "4242").first_or_create
    IndustryCode.where(name: "Apparel, Piece Goods, and Notions Merchant Wholesalers", internal_name: "apparel-piece-goods-and-notions-merchant-wholesalers", industry_type: :industry_group, naics_code: "4243").first_or_create
    IndustryCode.where(name: "Grocery and Related Product Merchant Wholesalers", internal_name: "grocery-and-related-product-merchant-wholesalers", industry_type: :industry_group, naics_code: "4244").first_or_create
    IndustryCode.where(name: "Farm Product Raw Material Merchant Wholesalers", internal_name: "farm-product-raw-material-merchant-wholesalers", industry_type: :industry_group, naics_code: "4245").first_or_create
    IndustryCode.where(name: "Chemical and Allied Products Merchant Wholesalers", internal_name: "chemical-and-allied-products-merchant-wholesalers", industry_type: :industry_group, naics_code: "4246").first_or_create
    IndustryCode.where(name: "Petroleum and Petroleum Products Merchant Wholesalers", internal_name: "petroleum-and-petroleum-products-merchant-wholesalers", industry_type: :industry_group, naics_code: "4247").first_or_create
    IndustryCode.where(name: "Beer, Wine, and Distilled Alcoholic Beverage Merchant Wholesalers", internal_name: "beer-wine-and-distilled-alcoholic-beverage-merchant-wholesalers", industry_type: :industry_group, naics_code: "4248").first_or_create
    IndustryCode.where(name: "Miscellaneous Nondurable Goods Merchant Wholesalers", internal_name: "miscellaneous-nondurable-goods-merchant-wholesalers", industry_type: :industry_group, naics_code: "4249").first_or_create
    IndustryCode.where(name: "Wholesale Electronic Markets and Agents and Brokers", internal_name: "wholesale-electronic-markets-and-agents-and-brokers", industry_type: :industry_group, naics_code: "4251").first_or_create
    IndustryCode.where(name: "Automobile Dealers", internal_name: "automobile-dealers", industry_type: :industry_group, naics_code: "4411").first_or_create
    IndustryCode.where(name: "Other Motor Vehicle Dealers", internal_name: "other-motor-vehicle-dealers", industry_type: :industry_group, naics_code: "4412").first_or_create
    IndustryCode.where(name: "Automotive Parts, Accessories, and Tire Stores", internal_name: "automotive-parts-accessories-and-tire-stores", industry_type: :industry_group, naics_code: "4413").first_or_create
    IndustryCode.where(name: "Furniture Stores", internal_name: "furniture-stores", industry_type: :industry_group, naics_code: "4421").first_or_create
    IndustryCode.where(name: "Home Furnishings Stores", internal_name: "home-furnishings-stores", industry_type: :industry_group, naics_code: "4422").first_or_create
    IndustryCode.where(name: "Electronics and Appliance Stores", internal_name: "electronics-and-appliance-stores", industry_type: :industry_group, naics_code: "4431").first_or_create
    IndustryCode.where(name: "Building Material and Supplies Dealers", internal_name: "building-material-and-supplies-dealers", industry_type: :industry_group, naics_code: "4441").first_or_create
    IndustryCode.where(name: "Lawn and Garden Equipment and Supplies Stores", internal_name: "lawn-and-garden-equipment-and-supplies-stores", industry_type: :industry_group, naics_code: "4442").first_or_create
    IndustryCode.where(name: "Grocery Stores", internal_name: "grocery-stores", industry_type: :industry_group, naics_code: "4451").first_or_create
    IndustryCode.where(name: "Specialty Food Stores", internal_name: "specialty-food-stores", industry_type: :industry_group, naics_code: "4452").first_or_create
    IndustryCode.where(name: "Beer, Wine, and Liquor Stores", internal_name: "beer-wine-and-liquor-stores", industry_type: :industry_group, naics_code: "4453").first_or_create
    IndustryCode.where(name: "Health and Personal Care Stores", internal_name: "health-and-personal-care-stores", industry_type: :industry_group, naics_code: "4461").first_or_create
    IndustryCode.where(name: "Gasoline Stations", internal_name: "gasoline-stations", industry_type: :industry_group, naics_code: "4471").first_or_create
    IndustryCode.where(name: "Clothing Stores", internal_name: "clothing-stores", industry_type: :industry_group, naics_code: "4481").first_or_create
    IndustryCode.where(name: "Shoe Stores", internal_name: "shoe-stores", industry_type: :industry_group, naics_code: "4482").first_or_create
    IndustryCode.where(name: "Jewelry, Luggage, and Leather Goods Stores", internal_name: "jewelry-luggage-and-leather-goods-stores", industry_type: :industry_group, naics_code: "4483").first_or_create
    IndustryCode.where(name: "Sporting Goods, Hobby, and Musical Instrument Stores", internal_name: "sporting-goods-hobby-and-musical-instrument-stores", industry_type: :industry_group, naics_code: "4511").first_or_create
    IndustryCode.where(name: "Book Stores and News Dealers", internal_name: "book-stores-and-news-dealers", industry_type: :industry_group, naics_code: "4512").first_or_create
    IndustryCode.where(name: "Department Stores", internal_name: "department-stores", industry_type: :industry_group, naics_code: "4521").first_or_create
    IndustryCode.where(name: "Other General Merchandise Stores", internal_name: "other-general-merchandise-stores", industry_type: :industry_group, naics_code: "4529").first_or_create
    IndustryCode.where(name: "Florists", internal_name: "florists", industry_type: :industry_group, naics_code: "4531").first_or_create
    IndustryCode.where(name: "Office Supplies, Stationery, and Gift Stores", internal_name: "office-supplies-stationery-and-gift-stores", industry_type: :industry_group, naics_code: "4532").first_or_create
    IndustryCode.where(name: "Used Merchandise Stores", internal_name: "used-merchandise-stores", industry_type: :industry_group, naics_code: "4533").first_or_create
    IndustryCode.where(name: "Other Miscellaneous Store Retailers", internal_name: "other-miscellaneous-store-retailers", industry_type: :industry_group, naics_code: "4539").first_or_create
    IndustryCode.where(name: "Electronic Shopping and Mail-Order Houses", internal_name: "electronic-shopping-and-mail-order-houses", industry_type: :industry_group, naics_code: "4541").first_or_create
    IndustryCode.where(name: "Vending Machine Operators", internal_name: "vending-machine-operators", industry_type: :industry_group, naics_code: "4542").first_or_create
    IndustryCode.where(name: "Direct Selling Establishments", internal_name: "direct-selling-establishments", industry_type: :industry_group, naics_code: "4543").first_or_create
    IndustryCode.where(name: "Scheduled Air Transportation", internal_name: "scheduled-air-transportation", industry_type: :industry_group, naics_code: "4811").first_or_create
    IndustryCode.where(name: "Nonscheduled Air Transportation", internal_name: "nonscheduled-air-transportation", industry_type: :industry_group, naics_code: "4812").first_or_create
    IndustryCode.where(name: "Rail Transportation", internal_name: "rail-transportation", industry_type: :industry_group, naics_code: "4821").first_or_create
    IndustryCode.where(name: "Deep Sea, Coastal, and Great Lakes Water Transportation", internal_name: "deep-sea-coastal-and-great-lakes-water-transportation", industry_type: :industry_group, naics_code: "4831").first_or_create
    IndustryCode.where(name: "Inland Water Transportation", internal_name: "inland-water-transportation", industry_type: :industry_group, naics_code: "4832").first_or_create
    IndustryCode.where(name: "General Freight Trucking", internal_name: "general-freight-trucking", industry_type: :industry_group, naics_code: "4841").first_or_create
    IndustryCode.where(name: "Specialized Freight Trucking", internal_name: "specialized-freight-trucking", industry_type: :industry_group, naics_code: "4842").first_or_create
    IndustryCode.where(name: "Urban Transit Systems", internal_name: "urban-transit-systems", industry_type: :industry_group, naics_code: "4851").first_or_create
    IndustryCode.where(name: "Interurban and Rural Bus Transportation", internal_name: "interurban-and-rural-bus-transportation", industry_type: :industry_group, naics_code: "4852").first_or_create
    IndustryCode.where(name: "Taxi and Limousine Service", internal_name: "taxi-and-limousine-service", industry_type: :industry_group, naics_code: "4853").first_or_create
    IndustryCode.where(name: "School and Employee Bus Transportation", internal_name: "school-and-employee-bus-transportation", industry_type: :industry_group, naics_code: "4854").first_or_create
    IndustryCode.where(name: "Charter Bus Industry", internal_name: "charter-bus-industry", industry_type: :industry_group, naics_code: "4855").first_or_create
    IndustryCode.where(name: "Other Transit and Ground Passenger Transportation", internal_name: "other-transit-and-ground-passenger-transportation", industry_type: :industry_group, naics_code: "4859").first_or_create
    IndustryCode.where(name: "Pipeline Transportation of Crude Oil", internal_name: "pipeline-transportation-of-crude-oil", industry_type: :industry_group, naics_code: "4861").first_or_create
    IndustryCode.where(name: "Pipeline Transportation of Natural Gas", internal_name: "pipeline-transportation-of-natural-gas", industry_type: :industry_group, naics_code: "4862").first_or_create
    IndustryCode.where(name: "Other Pipeline Transportation", internal_name: "other-pipeline-transportation", industry_type: :industry_group, naics_code: "4869").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation, Land", internal_name: "scenic-and-sightseeing-transportation-land", industry_type: :industry_group, naics_code: "4871").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation, Water", internal_name: "scenic-and-sightseeing-transportation-water", industry_type: :industry_group, naics_code: "4872").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation, Other", internal_name: "scenic-and-sightseeing-transportation-other", industry_type: :industry_group, naics_code: "4879").first_or_create
    IndustryCode.where(name: "Support Activities for Air Transportation", internal_name: "support-activities-for-air-transportation", industry_type: :industry_group, naics_code: "4881").first_or_create
    IndustryCode.where(name: "Support Activities for Rail Transportation", internal_name: "support-activities-for-rail-transportation", industry_type: :industry_group, naics_code: "4882").first_or_create
    IndustryCode.where(name: "Support Activities for Water Transportation", internal_name: "support-activities-for-water-transportation", industry_type: :industry_group, naics_code: "4883").first_or_create
    IndustryCode.where(name: "Support Activities for Road Transportation", internal_name: "support-activities-for-road-transportation", industry_type: :industry_group, naics_code: "4884").first_or_create
    IndustryCode.where(name: "Freight Transportation Arrangement", internal_name: "freight-transportation-arrangement", industry_type: :industry_group, naics_code: "4885").first_or_create
    IndustryCode.where(name: "Other Support Activities for Transportation", internal_name: "other-support-activities-for-transportation", industry_type: :industry_group, naics_code: "4889").first_or_create
    IndustryCode.where(name: "Postal Service", internal_name: "postal-service", industry_type: :industry_group, naics_code: "4911").first_or_create
    IndustryCode.where(name: "Couriers and Express Delivery Services", internal_name: "couriers-and-express-delivery-services", industry_type: :industry_group, naics_code: "4921").first_or_create
    IndustryCode.where(name: "Local Messengers and Local Delivery", internal_name: "local-messengers-and-local-delivery", industry_type: :industry_group, naics_code: "4922").first_or_create
    IndustryCode.where(name: "Warehousing and Storage", internal_name: "warehousing-and-storage", industry_type: :industry_group, naics_code: "4931").first_or_create
    IndustryCode.where(name: "Newspaper, Periodical, Book, and Directory Publishers", internal_name: "newspaper-periodical-book-and-directory-publishers", industry_type: :industry_group, naics_code: "5111").first_or_create
    IndustryCode.where(name: "Software Publishers", internal_name: "software-publishers", industry_type: :industry_group, naics_code: "5112").first_or_create
    IndustryCode.where(name: "Motion Picture and Video Industries", internal_name: "motion-picture-and-video-industries", industry_type: :industry_group, naics_code: "5121").first_or_create
    IndustryCode.where(name: "Sound Recording Industries", internal_name: "sound-recording-industries", industry_type: :industry_group, naics_code: "5122").first_or_create
    IndustryCode.where(name: "Radio and Television Broadcasting", internal_name: "radio-and-television-broadcasting", industry_type: :industry_group, naics_code: "5151").first_or_create
    IndustryCode.where(name: "Cable and Other Subscription Programming", internal_name: "cable-and-other-subscription-programming", industry_type: :industry_group, naics_code: "5152").first_or_create
    IndustryCode.where(name: "Wired Telecommunications Carriers", internal_name: "wired-telecommunications-carriers", industry_type: :industry_group, naics_code: "5171").first_or_create
    IndustryCode.where(name: "Wireless Telecommunications Carriers (except Satellite)", internal_name: "wireless-telecommunications-carriers-except-satellite", industry_type: :industry_group, naics_code: "5172").first_or_create
    IndustryCode.where(name: "Satellite Telecommunications", internal_name: "satellite-telecommunications", industry_type: :industry_group, naics_code: "5174").first_or_create
    IndustryCode.where(name: "Other Telecommunications", internal_name: "other-telecommunications", industry_type: :industry_group, naics_code: "5179").first_or_create
    IndustryCode.where(name: "Data Processing, Hosting, and Related Services", internal_name: "data-processing-hosting-and-related-services", industry_type: :industry_group, naics_code: "5182").first_or_create
    IndustryCode.where(name: "Other Information Services", internal_name: "other-information-services", industry_type: :industry_group, naics_code: "5191").first_or_create
    IndustryCode.where(name: "Monetary Authorities-Central Bank", internal_name: "monetary-authorities-central-bank", industry_type: :industry_group, naics_code: "5211").first_or_create
    IndustryCode.where(name: "Depository Credit Intermediation", internal_name: "depository-credit-intermediation", industry_type: :industry_group, naics_code: "5221").first_or_create
    IndustryCode.where(name: "Nondepository Credit Intermediation", internal_name: "nondepository-credit-intermediation", industry_type: :industry_group, naics_code: "5222").first_or_create
    IndustryCode.where(name: "Activities Related to Credit Intermediation", internal_name: "activities-related-to-credit-intermediation", industry_type: :industry_group, naics_code: "5223").first_or_create
    IndustryCode.where(name: "Securities and Commodity Contracts Intermediation and Brokerage", internal_name: "securities-and-commodity-contracts-intermediation-and-brokerage", industry_type: :industry_group, naics_code: "5231").first_or_create
    IndustryCode.where(name: "Securities and Commodity Exchanges", internal_name: "securities-and-commodity-exchanges", industry_type: :industry_group, naics_code: "5232").first_or_create
    IndustryCode.where(name: "Other Financial Investment Activities", internal_name: "other-financial-investment-activities", industry_type: :industry_group, naics_code: "5239").first_or_create
    IndustryCode.where(name: "Insurance Carriers", internal_name: "insurance-carriers", industry_type: :industry_group, naics_code: "5241").first_or_create
    IndustryCode.where(name: "Agencies, Brokerages, and Other Insurance Related Activities", internal_name: "agencies-brokerages-and-other-insurance-related-activities", industry_type: :industry_group, naics_code: "5242").first_or_create
    IndustryCode.where(name: "Insurance and Employee Benefit Funds", internal_name: "insurance-and-employee-benefit-funds", industry_type: :industry_group, naics_code: "5251").first_or_create
    IndustryCode.where(name: "Other Investment Pools and Funds", internal_name: "other-investment-pools-and-funds", industry_type: :industry_group, naics_code: "5259").first_or_create
    IndustryCode.where(name: "Lessors of Real Estate", internal_name: "lessors-of-real-estate", industry_type: :industry_group, naics_code: "5311").first_or_create
    IndustryCode.where(name: "Offices of Real Estate Agents and Brokers", internal_name: "offices-of-real-estate-agents-and-brokers", industry_type: :industry_group, naics_code: "5312").first_or_create
    IndustryCode.where(name: "Activities Related to Real Estate", internal_name: "activities-related-to-real-estate", industry_type: :industry_group, naics_code: "5313").first_or_create
    IndustryCode.where(name: "Automotive Equipment Rental and Leasing", internal_name: "automotive-equipment-rental-and-leasing", industry_type: :industry_group, naics_code: "5321").first_or_create
    IndustryCode.where(name: "Consumer Goods Rental", internal_name: "consumer-goods-rental", industry_type: :industry_group, naics_code: "5322").first_or_create
    IndustryCode.where(name: "General Rental Centers", internal_name: "general-rental-centers", industry_type: :industry_group, naics_code: "5323").first_or_create
    IndustryCode.where(name: "Commercial and Industrial Machinery and Equipment Rental and Leasing", internal_name: "commercial-and-industrial-machinery-and-equipment-rental-and-leasing", industry_type: :industry_group, naics_code: "5324").first_or_create
    IndustryCode.where(name: "Lessors of Nonfinancial Intangible Assets (except Copyrighted Works)", internal_name: "lessors-of-nonfinancial-intangible-assets-except-copyrighted-works", industry_type: :industry_group, naics_code: "5331").first_or_create
    IndustryCode.where(name: "Legal Services", internal_name: "legal-services", industry_type: :industry_group, naics_code: "5411").first_or_create
    IndustryCode.where(name: "Accounting, Tax Preparation, Bookkeeping, and Payroll Services", internal_name: "accounting-tax-preparation-bookkeeping-and-payroll-services", industry_type: :industry_group, naics_code: "5412").first_or_create
    IndustryCode.where(name: "Architectural, Engineering, and Related Services", internal_name: "architectural-engineering-and-related-services", industry_type: :industry_group, naics_code: "5413").first_or_create
    IndustryCode.where(name: "Specialized Design Services", internal_name: "specialized-design-services", industry_type: :industry_group, naics_code: "5414").first_or_create
    IndustryCode.where(name: "Computer Systems Design and Related Services", internal_name: "computer-systems-design-and-related-services", industry_type: :industry_group, naics_code: "5415").first_or_create
    IndustryCode.where(name: "Management, Scientific, and Technical Consulting Services", internal_name: "management-scientific-and-technical-consulting-services", industry_type: :industry_group, naics_code: "5416").first_or_create
    IndustryCode.where(name: "Scientific Research and Development Services", internal_name: "scientific-research-and-development-services", industry_type: :industry_group, naics_code: "5417").first_or_create
    IndustryCode.where(name: "Advertising, Public Relations, and Related Services", internal_name: "advertising-public-relations-and-related-services", industry_type: :industry_group, naics_code: "5418").first_or_create
    IndustryCode.where(name: "Other Professional, Scientific, and Technical Services", internal_name: "other-professional-scientific-and-technical-services", industry_type: :industry_group, naics_code: "5419").first_or_create
    IndustryCode.where(name: "Management of Companies and Enterprises", internal_name: "management-of-companies-and-enterprises", industry_type: :industry_group, naics_code: "5511").first_or_create
    IndustryCode.where(name: "Office Administrative Services", internal_name: "office-administrative-services", industry_type: :industry_group, naics_code: "5611").first_or_create
    IndustryCode.where(name: "Facilities Support Services", internal_name: "facilities-support-services", industry_type: :industry_group, naics_code: "5612").first_or_create
    IndustryCode.where(name: "Employment Services", internal_name: "employment-services", industry_type: :industry_group, naics_code: "5613").first_or_create
    IndustryCode.where(name: "Business Support Services", internal_name: "business-support-services", industry_type: :industry_group, naics_code: "5614").first_or_create
    IndustryCode.where(name: "Travel Arrangement and Reservation Services", internal_name: "travel-arrangement-and-reservation-services", industry_type: :industry_group, naics_code: "5615").first_or_create
    IndustryCode.where(name: "Investigation and Security Services", internal_name: "investigation-and-security-services", industry_type: :industry_group, naics_code: "5616").first_or_create
    IndustryCode.where(name: "Services to Buildings and Dwellings", internal_name: "services-to-buildings-and-dwellings", industry_type: :industry_group, naics_code: "5617").first_or_create
    IndustryCode.where(name: "Other Support Services", internal_name: "other-support-services", industry_type: :industry_group, naics_code: "5619").first_or_create
    IndustryCode.where(name: "Waste Collection", internal_name: "waste-collection", industry_type: :industry_group, naics_code: "5621").first_or_create
    IndustryCode.where(name: "Waste Treatment and Disposal", internal_name: "waste-treatment-and-disposal", industry_type: :industry_group, naics_code: "5622").first_or_create
    IndustryCode.where(name: "Remediation and Other Waste Management Services", internal_name: "remediation-and-other-waste-management-services", industry_type: :industry_group, naics_code: "5629").first_or_create
    IndustryCode.where(name: "Elementary and Secondary Schools", internal_name: "elementary-and-secondary-schools", industry_type: :industry_group, naics_code: "6111").first_or_create
    IndustryCode.where(name: "Junior Colleges", internal_name: "junior-colleges", industry_type: :industry_group, naics_code: "6112").first_or_create
    IndustryCode.where(name: "Colleges, Universities, and Professional Schools", internal_name: "colleges-universities-and-professional-schools", industry_type: :industry_group, naics_code: "6113").first_or_create
    IndustryCode.where(name: "Business Schools and Computer and Management Training", internal_name: "business-schools-and-computer-and-management-training", industry_type: :industry_group, naics_code: "6114").first_or_create
    IndustryCode.where(name: "Technical and Trade Schools", internal_name: "technical-and-trade-schools", industry_type: :industry_group, naics_code: "6115").first_or_create
    IndustryCode.where(name: "Other Schools and Instruction", internal_name: "other-schools-and-instruction", industry_type: :industry_group, naics_code: "6116").first_or_create
    IndustryCode.where(name: "Educational Support Services", internal_name: "educational-support-services", industry_type: :industry_group, naics_code: "6117").first_or_create
    IndustryCode.where(name: "Offices of Physicians", internal_name: "offices-of-physicians", industry_type: :industry_group, naics_code: "6211").first_or_create
    IndustryCode.where(name: "Offices of Dentists", internal_name: "offices-of-dentists", industry_type: :industry_group, naics_code: "6212").first_or_create
    IndustryCode.where(name: "Offices of Other Health Practitioners", internal_name: "offices-of-other-health-practitioners", industry_type: :industry_group, naics_code: "6213").first_or_create
    IndustryCode.where(name: "Outpatient Care Centers", internal_name: "outpatient-care-centers", industry_type: :industry_group, naics_code: "6214").first_or_create
    IndustryCode.where(name: "Medical and Diagnostic Laboratories", internal_name: "medical-and-diagnostic-laboratories", industry_type: :industry_group, naics_code: "6215").first_or_create
    IndustryCode.where(name: "Home Health Care Services", internal_name: "home-health-care-services", industry_type: :industry_group, naics_code: "6216").first_or_create
    IndustryCode.where(name: "Other Ambulatory Health Care Services", internal_name: "other-ambulatory-health-care-services", industry_type: :industry_group, naics_code: "6219").first_or_create
    IndustryCode.where(name: "General Medical and Surgical Hospitals", internal_name: "general-medical-and-surgical-hospitals", industry_type: :industry_group, naics_code: "6221").first_or_create
    IndustryCode.where(name: "Psychiatric and Substance Abuse Hospitals", internal_name: "psychiatric-and-substance-abuse-hospitals", industry_type: :industry_group, naics_code: "6222").first_or_create
    IndustryCode.where(name: "Specialty (except Psychiatric and Substance Abuse) Hospitals", internal_name: "specialty-except-psychiatric-and-substance-abuse-hospitals", industry_type: :industry_group, naics_code: "6223").first_or_create
    IndustryCode.where(name: "Nursing Care Facilities (Skilled Nursing Facilities)", internal_name: "nursing-care-facilities-skilled-nursing-facilities", industry_type: :industry_group, naics_code: "6231").first_or_create
    IndustryCode.where(name: "Residential Intellectual and Developmental Disability, Mental Health, and Substance Abuse Facilities", internal_name: "residential-intellectual-and-developmental-disability-mental-health-and-substance-abuse-facilities", industry_type: :industry_group, naics_code: "6232").first_or_create
    IndustryCode.where(name: "Continuing Care Retirement Communities and Assisted Living Facilities for the Elderly", internal_name: "continuing-care-retirement-communities-and-assisted-living-facilities-for-the-elderly", industry_type: :industry_group, naics_code: "6233").first_or_create
    IndustryCode.where(name: "Other Residential Care Facilities", internal_name: "other-residential-care-facilities", industry_type: :industry_group, naics_code: "6239").first_or_create
    IndustryCode.where(name: "Individual and Family Services", internal_name: "individual-and-family-services", industry_type: :industry_group, naics_code: "6241").first_or_create
    IndustryCode.where(name: "Community Food and Housing, and Emergency and Other Relief Services", internal_name: "community-food-and-housing-and-emergency-and-other-relief-services", industry_type: :industry_group, naics_code: "6242").first_or_create
    IndustryCode.where(name: "Vocational Rehabilitation Services", internal_name: "vocational-rehabilitation-services", industry_type: :industry_group, naics_code: "6243").first_or_create
    IndustryCode.where(name: "Child Day Care Services", internal_name: "child-day-care-services", industry_type: :industry_group, naics_code: "6244").first_or_create
    IndustryCode.where(name: "Performing Arts Companies", internal_name: "performing-arts-companies", industry_type: :industry_group, naics_code: "7111").first_or_create
    IndustryCode.where(name: "Spectator Sports", internal_name: "spectator-sports", industry_type: :industry_group, naics_code: "7112").first_or_create
    IndustryCode.where(name: "Promoters of Performing Arts, Sports, and Similar Events", internal_name: "promoters-of-performing-arts-sports-and-similar-events", industry_type: :industry_group, naics_code: "7113").first_or_create
    IndustryCode.where(name: "Agents and Managers for Artists, Athletes, Entertainers, and Other Public Figures", internal_name: "agents-and-managers-for-artists-athletes-entertainers-and-other-public-figures", industry_type: :industry_group, naics_code: "7114").first_or_create
    IndustryCode.where(name: "Independent Artists, Writers, and Performers", internal_name: "independent-artists-writers-and-performers", industry_type: :industry_group, naics_code: "7115").first_or_create
    IndustryCode.where(name: "Museums, Historical Sites, and Similar Institutions", internal_name: "museums-historical-sites-and-similar-institutions", industry_type: :industry_group, naics_code: "7121").first_or_create
    IndustryCode.where(name: "Amusement Parks and Arcades", internal_name: "amusement-parks-and-arcades", industry_type: :industry_group, naics_code: "7131").first_or_create
    IndustryCode.where(name: "Gambling Industries", internal_name: "gambling-industries", industry_type: :industry_group, naics_code: "7132").first_or_create
    IndustryCode.where(name: "Other Amusement and Recreation Industries", internal_name: "other-amusement-and-recreation-industries", industry_type: :industry_group, naics_code: "7139").first_or_create
    IndustryCode.where(name: "Traveler Accommodation", internal_name: "traveler-accommodation", industry_type: :industry_group, naics_code: "7211").first_or_create
    IndustryCode.where(name: "RV (Recreational Vehicle) Parks and Recreational Camps", internal_name: "rv-recreational-vehicle-parks-and-recreational-camps", industry_type: :industry_group, naics_code: "7212").first_or_create
    IndustryCode.where(name: "Rooming and Boarding Houses", internal_name: "rooming-and-boarding-houses", industry_type: :industry_group, naics_code: "7213").first_or_create
    IndustryCode.where(name: "Special Food Services", internal_name: "special-food-services", industry_type: :industry_group, naics_code: "7223").first_or_create
    IndustryCode.where(name: "Drinking Places (Alcoholic Beverages)", internal_name: "drinking-places-alcoholic-beverages", industry_type: :industry_group, naics_code: "7224").first_or_create
    IndustryCode.where(name: "Restaurants and Other Eating Places", internal_name: "restaurants-and-other-eating-places", industry_type: :industry_group, naics_code: "7225").first_or_create
    IndustryCode.where(name: "Automotive Repair and Maintenance", internal_name: "automotive-repair-and-maintenance", industry_type: :industry_group, naics_code: "8111").first_or_create
    IndustryCode.where(name: "Electronic and Precision Equipment Repair and Maintenance", internal_name: "electronic-and-precision-equipment-repair-and-maintenance", industry_type: :industry_group, naics_code: "8112").first_or_create
    IndustryCode.where(name: "Commercial and Industrial Machinery and Equipment (except Automotive and Electronic) Repair and Maintenance", internal_name: "commercial-and-industrial-machinery-and-equipment-except-automotive-and-electronic-repair-and-maintenance", industry_type: :industry_group, naics_code: "8113").first_or_create
    IndustryCode.where(name: "Personal and Household Goods Repair and Maintenance", internal_name: "personal-and-household-goods-repair-and-maintenance", industry_type: :industry_group, naics_code: "8114").first_or_create
    IndustryCode.where(name: "Personal Care Services", internal_name: "personal-care-services", industry_type: :industry_group, naics_code: "8121").first_or_create
    IndustryCode.where(name: "Death Care Services", internal_name: "death-care-services", industry_type: :industry_group, naics_code: "8122").first_or_create
    IndustryCode.where(name: "Drycleaning and Laundry Services", internal_name: "drycleaning-and-laundry-services", industry_type: :industry_group, naics_code: "8123").first_or_create
    IndustryCode.where(name: "Other Personal Services", internal_name: "other-personal-services", industry_type: :industry_group, naics_code: "8129").first_or_create
    IndustryCode.where(name: "Religious Organizations", internal_name: "religious-organizations", industry_type: :industry_group, naics_code: "8131").first_or_create
    IndustryCode.where(name: "Grantmaking and Giving Services", internal_name: "grantmaking-and-giving-services", industry_type: :industry_group, naics_code: "8132").first_or_create
    IndustryCode.where(name: "Social Advocacy Organizations", internal_name: "social-advocacy-organizations", industry_type: :industry_group, naics_code: "8133").first_or_create
    IndustryCode.where(name: "Civic and Social Organizations", internal_name: "civic-and-social-organizations", industry_type: :industry_group, naics_code: "8134").first_or_create
    IndustryCode.where(name: "Business, Professional, Labor, Political, and Similar Organizations", internal_name: "business-professional-labor-political-and-similar-organizations", industry_type: :industry_group, naics_code: "8139").first_or_create
    IndustryCode.where(name: "Private Households", internal_name: "private-households", industry_type: :industry_group, naics_code: "8141").first_or_create
    IndustryCode.where(name: "Executive, Legislative, and Other General Government Support", internal_name: "executive-legislative-and-other-general-government-support", industry_type: :industry_group, naics_code: "9211").first_or_create
    IndustryCode.where(name: "Justice, Public Order, and Safety Activities", internal_name: "justice-public-order-and-safety-activities", industry_type: :industry_group, naics_code: "9221").first_or_create
    IndustryCode.where(name: "Administration of Human Resource Programs", internal_name: "administration-of-human-resource-programs", industry_type: :industry_group, naics_code: "9231").first_or_create
    IndustryCode.where(name: "Administration of Environmental Quality Programs", internal_name: "administration-of-environmental-quality-programs", industry_type: :industry_group, naics_code: "9241").first_or_create
    IndustryCode.where(name: "Administration of Housing Programs, Urban Planning, and Community Development", internal_name: "administration-of-housing-programs-urban-planning-and-community-development", industry_type: :industry_group, naics_code: "9251").first_or_create
    IndustryCode.where(name: "Administration of Economic Program", internal_name: "administration-of-economic-program", industry_type: :industry_group, naics_code: "9261").first_or_create
    IndustryCode.where(name: "Space Research and Technology", internal_name: "space-research-and-technology", industry_type: :industry_group, naics_code: "9271").first_or_create
    IndustryCode.where(name: "National Security and International Affairs", internal_name: "national-security-and-international-affairs", industry_type: :industry_group, naics_code: "9281").first_or_create

    #NAICS industry
    IndustryCode.where(name: "Soybean Farming", internal_name: "soybean-farming", industry_type: :industry, naics_code: "111110").first_or_create
    IndustryCode.where(name: "Oilseed (except Soybean) Farming", internal_name: "oilseed-except-soybean-farming", industry_type: :industry, naics_code: "111120").first_or_create
    IndustryCode.where(name: "Dry Pea and Bean Farming", internal_name: "dry-pea-and-bean-farming", industry_type: :industry, naics_code: "111130").first_or_create
    IndustryCode.where(name: "Wheat Farming", internal_name: "wheat-farming", industry_type: :industry, naics_code: "111140").first_or_create
    IndustryCode.where(name: "Corn Farming", internal_name: "corn-farming", industry_type: :industry, naics_code: "111150").first_or_create
    IndustryCode.where(name: "Rice Farming", internal_name: "rice-farming", industry_type: :industry, naics_code: "111160").first_or_create
    IndustryCode.where(name: "Oilseed and Grain Combination Farming", internal_name: "oilseed-and-grain-combination-farming", industry_type: :industry, naics_code: "111191").first_or_create
    IndustryCode.where(name: "All Other Grain Farming", internal_name: "all-other-grain-farming", industry_type: :industry, naics_code: "111199").first_or_create
    IndustryCode.where(name: "Potato Farming", internal_name: "potato-farming", industry_type: :industry, naics_code: "111211").first_or_create
    IndustryCode.where(name: "Other Vegetable (except Potato) and Melon Farming", internal_name: "other-vegetable-except-potato-and-melon-farming", industry_type: :industry, naics_code: "111219").first_or_create
    IndustryCode.where(name: "Orange Groves", internal_name: "orange-groves", industry_type: :industry, naics_code: "111310").first_or_create
    IndustryCode.where(name: "Citrus (except Orange) Groves", internal_name: "citrus-except-orange-groves", industry_type: :industry, naics_code: "111320").first_or_create
    IndustryCode.where(name: "Apple Orchards", internal_name: "apple-orchards", industry_type: :industry, naics_code: "111331").first_or_create
    IndustryCode.where(name: "Grape Vineyards", internal_name: "grape-vineyards", industry_type: :industry, naics_code: "111332").first_or_create
    IndustryCode.where(name: "Strawberry Farming", internal_name: "strawberry-farming", industry_type: :industry, naics_code: "111333").first_or_create
    IndustryCode.where(name: "Berry (except Strawberry) Farming", internal_name: "berry-except-strawberry-farming", industry_type: :industry, naics_code: "111334").first_or_create
    IndustryCode.where(name: "Tree Nut Farming", internal_name: "tree-nut-farming", industry_type: :industry, naics_code: "111335").first_or_create
    IndustryCode.where(name: "Fruit and Tree Nut Combination Farming", internal_name: "fruit-and-tree-nut-combination-farming", industry_type: :industry, naics_code: "111336").first_or_create
    IndustryCode.where(name: "Other Noncitrus Fruit Farming", internal_name: "other-noncitrus-fruit-farming", industry_type: :industry, naics_code: "111339").first_or_create
    IndustryCode.where(name: "Mushroom Production", internal_name: "mushroom-production", industry_type: :industry, naics_code: "111411").first_or_create
    IndustryCode.where(name: "Other Food Crops Grown Under Cover", internal_name: "other-food-crops-grown-under-cover", industry_type: :industry, naics_code: "111419").first_or_create
    IndustryCode.where(name: "Nursery and Tree Production", internal_name: "nursery-and-tree-production", industry_type: :industry, naics_code: "111421").first_or_create
    IndustryCode.where(name: "Floriculture Production", internal_name: "floriculture-production", industry_type: :industry, naics_code: "111422").first_or_create
    IndustryCode.where(name: "Tobacco Farming", internal_name: "tobacco-farming", industry_type: :industry, naics_code: "111910").first_or_create
    IndustryCode.where(name: "Cotton Farming", internal_name: "cotton-farming", industry_type: :industry, naics_code: "111920").first_or_create
    IndustryCode.where(name: "Sugarcane Farming", internal_name: "sugarcane-farming", industry_type: :industry, naics_code: "111930").first_or_create
    IndustryCode.where(name: "Hay Farming", internal_name: "hay-farming", industry_type: :industry, naics_code: "111940").first_or_create
    IndustryCode.where(name: "Sugar Beet Farming", internal_name: "sugar-beet-farming", industry_type: :industry, naics_code: "111991").first_or_create
    IndustryCode.where(name: "Peanut Farming", internal_name: "peanut-farming", industry_type: :industry, naics_code: "111992").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Crop Farming", internal_name: "all-other-miscellaneous-crop-farming", industry_type: :industry, naics_code: "111998").first_or_create
    IndustryCode.where(name: "Beef Cattle Ranching and Farming", internal_name: "beef-cattle-ranching-and-farming", industry_type: :industry, naics_code: "112111").first_or_create
    IndustryCode.where(name: "Cattle Feedlots", internal_name: "cattle-feedlots", industry_type: :industry, naics_code: "112112").first_or_create
    IndustryCode.where(name: "Dairy Cattle and Milk Production", internal_name: "dairy-cattle-and-milk-production", industry_type: :industry, naics_code: "112120").first_or_create
    IndustryCode.where(name: "Dual-Purpose Cattle Ranching and Farming", internal_name: "dual-purpose-cattle-ranching-and-farming", industry_type: :industry, naics_code: "112130").first_or_create
    IndustryCode.where(name: "Hog and Pig Farming", internal_name: "hog-and-pig-farming", industry_type: :industry, naics_code: "112210").first_or_create
    IndustryCode.where(name: "Chicken Egg Production", internal_name: "chicken-egg-production", industry_type: :industry, naics_code: "112310").first_or_create
    IndustryCode.where(name: "Broilers and Other Meat Type Chicken Production", internal_name: "broilers-and-other-meat-type-chicken-production", industry_type: :industry, naics_code: "112320").first_or_create
    IndustryCode.where(name: "Turkey Production", internal_name: "turkey-production", industry_type: :industry, naics_code: "112330").first_or_create
    IndustryCode.where(name: "Poultry Hatcheries", internal_name: "poultry-hatcheries", industry_type: :industry, naics_code: "112340").first_or_create
    IndustryCode.where(name: "Other Poultry Production", internal_name: "other-poultry-production", industry_type: :industry, naics_code: "112390").first_or_create
    IndustryCode.where(name: "Sheep Farming", internal_name: "sheep-farming", industry_type: :industry, naics_code: "112410").first_or_create
    IndustryCode.where(name: "Goat Farming", internal_name: "goat-farming", industry_type: :industry, naics_code: "112420").first_or_create
    IndustryCode.where(name: "Finfish Farming and Fish Hatcheries", internal_name: "finfish-farming-and-fish-hatcheries", industry_type: :industry, naics_code: "112511").first_or_create
    IndustryCode.where(name: "Shellfish Farming", internal_name: "shellfish-farming", industry_type: :industry, naics_code: "112512").first_or_create
    IndustryCode.where(name: "Other Aquaculture", internal_name: "other-aquaculture", industry_type: :industry, naics_code: "112519").first_or_create
    IndustryCode.where(name: "Apiculture", internal_name: "apiculture", industry_type: :industry, naics_code: "112910").first_or_create
    IndustryCode.where(name: "Horses and Other Equine Production", internal_name: "horses-and-other-equine-production", industry_type: :industry, naics_code: "112920").first_or_create
    IndustryCode.where(name: "Fur-Bearing Animal and Rabbit Production", internal_name: "fur-bearing-animal-and-rabbit-production", industry_type: :industry, naics_code: "112930").first_or_create
    IndustryCode.where(name: "All Other Animal Production", internal_name: "all-other-animal-production", industry_type: :industry, naics_code: "112990").first_or_create
    IndustryCode.where(name: "Timber Tract Operations", internal_name: "timber-tract-operations", industry_type: :industry, naics_code: "113110").first_or_create
    IndustryCode.where(name: "Forest Nurseries and Gathering of Forest Products", internal_name: "forest-nurseries-and-gathering-of-forest-products", industry_type: :industry, naics_code: "113210").first_or_create
    IndustryCode.where(name: "Logging", internal_name: "logging", industry_type: :industry, naics_code: "113310").first_or_create
    IndustryCode.where(name: "Finfish Fishing", internal_name: "finfish-fishing", industry_type: :industry, naics_code: "114111").first_or_create
    IndustryCode.where(name: "Shellfish Fishing", internal_name: "shellfish-fishing", industry_type: :industry, naics_code: "114112").first_or_create
    IndustryCode.where(name: "Other Marine Fishing", internal_name: "other-marine-fishing", industry_type: :industry, naics_code: "114119").first_or_create
    IndustryCode.where(name: "Hunting and Trapping", internal_name: "hunting-and-trapping", industry_type: :industry, naics_code: "114210").first_or_create
    IndustryCode.where(name: "Cotton Ginning", internal_name: "cotton-ginning", industry_type: :industry, naics_code: "115111").first_or_create
    IndustryCode.where(name: "Soil Preparation, Planting, and Cultivating", internal_name: "soil-preparation-planting-and-cultivating", industry_type: :industry, naics_code: "115112").first_or_create
    IndustryCode.where(name: "Crop Harvesting, Primarily by Machine", internal_name: "crop-harvesting-primarily-by-machine", industry_type: :industry, naics_code: "115113").first_or_create
    IndustryCode.where(name: "Postharvest Crop Activities (except Cotton Ginning)", internal_name: "postharvest-crop-activities-except-cotton-ginning", industry_type: :industry, naics_code: "115114").first_or_create
    IndustryCode.where(name: "Farm Labor Contractors and Crew Leaders", internal_name: "farm-labor-contractors-and-crew-leaders", industry_type: :industry, naics_code: "115115").first_or_create
    IndustryCode.where(name: "Farm Management Services", internal_name: "farm-management-services", industry_type: :industry, naics_code: "115116").first_or_create
    IndustryCode.where(name: "Support Activities for Animal Production", internal_name: "support-activities-for-animal-production", industry_type: :industry, naics_code: "115210").first_or_create
    IndustryCode.where(name: "Support Activities for Forestry", internal_name: "support-activities-for-forestry", industry_type: :industry, naics_code: "115310").first_or_create
    IndustryCode.where(name: "Crude Petroleum and Natural Gas Extraction", internal_name: "crude-petroleum-and-natural-gas-extraction", industry_type: :industry, naics_code: "211111").first_or_create
    IndustryCode.where(name: "Natural Gas Liquid Extraction", internal_name: "natural-gas-liquid-extraction", industry_type: :industry, naics_code: "211112").first_or_create
    IndustryCode.where(name: "Bituminous Coal and Lignite Surface Mining", internal_name: "bituminous-coal-and-lignite-surface-mining", industry_type: :industry, naics_code: "212111").first_or_create
    IndustryCode.where(name: "Bituminous Coal Underground Mining", internal_name: "bituminous-coal-underground-mining", industry_type: :industry, naics_code: "212112").first_or_create
    IndustryCode.where(name: "Anthracite Mining", internal_name: "anthracite-mining", industry_type: :industry, naics_code: "212113").first_or_create
    IndustryCode.where(name: "Iron Ore Mining", internal_name: "iron-ore-mining", industry_type: :industry, naics_code: "212210").first_or_create
    IndustryCode.where(name: "Gold Ore Mining", internal_name: "gold-ore-mining", industry_type: :industry, naics_code: "212221").first_or_create
    IndustryCode.where(name: "Silver Ore Mining", internal_name: "silver-ore-mining", industry_type: :industry, naics_code: "212222").first_or_create
    IndustryCode.where(name: "Lead Ore and Zinc Ore Mining", internal_name: "lead-ore-and-zinc-ore-mining", industry_type: :industry, naics_code: "212231").first_or_create
    IndustryCode.where(name: "Copper Ore and Nickel Ore Mining", internal_name: "copper-ore-and-nickel-ore-mining", industry_type: :industry, naics_code: "212234").first_or_create
    IndustryCode.where(name: "Uranium-Radium-Vanadium Ore Mining", internal_name: "uranium-radium-vanadium-ore-mining", industry_type: :industry, naics_code: "212291").first_or_create
    IndustryCode.where(name: "All Other Metal Ore Mining", internal_name: "all-other-metal-ore-mining", industry_type: :industry, naics_code: "212299").first_or_create
    IndustryCode.where(name: "Dimension Stone Mining and Quarrying", internal_name: "dimension-stone-mining-and-quarrying", industry_type: :industry, naics_code: "212311").first_or_create
    IndustryCode.where(name: "Crushed and Broken Limestone Mining and Quarrying", internal_name: "crushed-and-broken-limestone-mining-and-quarrying", industry_type: :industry, naics_code: "212312").first_or_create
    IndustryCode.where(name: "Crushed and Broken Granite Mining and Quarrying", internal_name: "crushed-and-broken-granite-mining-and-quarrying", industry_type: :industry, naics_code: "212313").first_or_create
    IndustryCode.where(name: "Other Crushed and Broken Stone Mining and Quarrying", internal_name: "other-crushed-and-broken-stone-mining-and-quarrying", industry_type: :industry, naics_code: "212319").first_or_create
    IndustryCode.where(name: "Construction Sand and Gravel Mining", internal_name: "construction-sand-and-gravel-mining", industry_type: :industry, naics_code: "212321").first_or_create
    IndustryCode.where(name: "Industrial Sand Mining", internal_name: "industrial-sand-mining", industry_type: :industry, naics_code: "212322").first_or_create
    IndustryCode.where(name: "Kaolin and Ball Clay Mining", internal_name: "kaolin-and-ball-clay-mining", industry_type: :industry, naics_code: "212324").first_or_create
    IndustryCode.where(name: "Clay and Ceramic and Refractory Minerals Mining", internal_name: "clay-and-ceramic-and-refractory-minerals-mining", industry_type: :industry, naics_code: "212325").first_or_create
    IndustryCode.where(name: "Potash, Soda, and Borate Mineral Mining", internal_name: "potash-soda-and-borate-mineral-mining", industry_type: :industry, naics_code: "212391").first_or_create
    IndustryCode.where(name: "Phosphate Rock Mining", internal_name: "phosphate-rock-mining", industry_type: :industry, naics_code: "212392").first_or_create
    IndustryCode.where(name: "Other Chemical and Fertilizer Mineral Mining", internal_name: "other-chemical-and-fertilizer-mineral-mining", industry_type: :industry, naics_code: "212393").first_or_create
    IndustryCode.where(name: "All Other Nonmetallic Mineral Mining", internal_name: "all-other-nonmetallic-mineral-mining", industry_type: :industry, naics_code: "212399").first_or_create
    IndustryCode.where(name: "Drilling Oil and Gas Wells", internal_name: "drilling-oil-and-gas-wells", industry_type: :industry, naics_code: "213111").first_or_create
    IndustryCode.where(name: "Support Activities for Oil and Gas Operations", internal_name: "support-activities-for-oil-and-gas-operations", industry_type: :industry, naics_code: "213112").first_or_create
    IndustryCode.where(name: "Support Activities for Coal Mining", internal_name: "support-activities-for-coal-mining", industry_type: :industry, naics_code: "213113").first_or_create
    IndustryCode.where(name: "Support Activities for Metal Mining", internal_name: "support-activities-for-metal-mining", industry_type: :industry, naics_code: "213114").first_or_create
    IndustryCode.where(name: "Support Activities for Nonmetallic Minerals (except Fuels) Mining", internal_name: "support-activities-for-nonmetallic-minerals-except-fuels-mining", industry_type: :industry, naics_code: "213115").first_or_create
    IndustryCode.where(name: "Hydroelectric Power Generation", internal_name: "hydroelectric-power-generation", industry_type: :industry, naics_code: "221111").first_or_create
    IndustryCode.where(name: "Fossil Fuel Electric Power Generation", internal_name: "fossil-fuel-electric-power-generation", industry_type: :industry, naics_code: "221112").first_or_create
    IndustryCode.where(name: "Nuclear Electric Power Generation", internal_name: "nuclear-electric-power-generation", industry_type: :industry, naics_code: "221113").first_or_create
    IndustryCode.where(name: "Solar Electric Power Generation", internal_name: "solar-electric-power-generation", industry_type: :industry, naics_code: "221114").first_or_create
    IndustryCode.where(name: "Wind Electric Power Generation", internal_name: "wind-electric-power-generation", industry_type: :industry, naics_code: "221115").first_or_create
    IndustryCode.where(name: "Geothermal Electric Power Generation", internal_name: "geothermal-electric-power-generation", industry_type: :industry, naics_code: "221116").first_or_create
    IndustryCode.where(name: "Biomass Electric Power Generation", internal_name: "biomass-electric-power-generation", industry_type: :industry, naics_code: "221117").first_or_create
    IndustryCode.where(name: "Other Electric Power Generation", internal_name: "other-electric-power-generation", industry_type: :industry, naics_code: "221118").first_or_create
    IndustryCode.where(name: "Electric Bulk Power Transmission and Control", internal_name: "electric-bulk-power-transmission-and-control", industry_type: :industry, naics_code: "221121").first_or_create
    IndustryCode.where(name: "Electric Power Distribution", internal_name: "electric-power-distribution", industry_type: :industry, naics_code: "221122").first_or_create
    IndustryCode.where(name: "Natural Gas Distribution", internal_name: "natural-gas-distribution", industry_type: :industry, naics_code: "221210").first_or_create
    IndustryCode.where(name: "Water Supply and Irrigation Systems", internal_name: "water-supply-and-irrigation-systems", industry_type: :industry, naics_code: "221310").first_or_create
    IndustryCode.where(name: "Sewage Treatment Facilities", internal_name: "sewage-treatment-facilities", industry_type: :industry, naics_code: "221320").first_or_create
    IndustryCode.where(name: "Steam and Air-Conditioning Supply", internal_name: "steam-and-air-conditioning-supply", industry_type: :industry, naics_code: "221330").first_or_create
    IndustryCode.where(name: "New Single-Family Housing Construction (except For-Sale Builders)", internal_name: "new-single-family-housing-construction-except-for-sale-builders", industry_type: :industry, naics_code: "236115").first_or_create
    IndustryCode.where(name: "New Multifamily Housing Construction (except For-Sale Builders)", internal_name: "new-multifamily-housing-construction-except-for-sale-builders", industry_type: :industry, naics_code: "236116").first_or_create
    IndustryCode.where(name: "New Housing For-Sale Builders", internal_name: "new-housing-for-sale-builders", industry_type: :industry, naics_code: "236117").first_or_create
    IndustryCode.where(name: "Residential Remodelers", internal_name: "residential-remodelers", industry_type: :industry, naics_code: "236118").first_or_create
    IndustryCode.where(name: "Industrial Building Construction", internal_name: "industrial-building-construction", industry_type: :industry, naics_code: "236210").first_or_create
    IndustryCode.where(name: "Commercial and Institutional Building Construction", internal_name: "commercial-and-institutional-building-construction", industry_type: :industry, naics_code: "236220").first_or_create
    IndustryCode.where(name: "Water and Sewer Line and Related Structures Construction", internal_name: "water-and-sewer-line-and-related-structures-construction", industry_type: :industry, naics_code: "237110").first_or_create
    IndustryCode.where(name: "Oil and Gas Pipeline and Related Structures Construction", internal_name: "oil-and-gas-pipeline-and-related-structures-construction", industry_type: :industry, naics_code: "237120").first_or_create
    IndustryCode.where(name: "Power and Communication Line and Related Structures Construction", internal_name: "power-and-communication-line-and-related-structures-construction", industry_type: :industry, naics_code: "237130").first_or_create
    IndustryCode.where(name: "Land Subdivision", internal_name: "land-subdivision", industry_type: :industry, naics_code: "237210").first_or_create
    IndustryCode.where(name: "Highway, Street, and Bridge Construction", internal_name: "highway-street-and-bridge-construction", industry_type: :industry, naics_code: "237310").first_or_create
    IndustryCode.where(name: "Other Heavy and Civil Engineering Construction", internal_name: "other-heavy-and-civil-engineering-construction", industry_type: :industry, naics_code: "237990").first_or_create
    IndustryCode.where(name: "Poured Concrete Foundation and Structure Contractors", internal_name: "poured-concrete-foundation-and-structure-contractors", industry_type: :industry, naics_code: "238110").first_or_create
    IndustryCode.where(name: "Structural Steel and Precast Concrete Contractors", internal_name: "structural-steel-and-precast-concrete-contractors", industry_type: :industry, naics_code: "238120").first_or_create
    IndustryCode.where(name: "Framing Contractors", internal_name: "framing-contractors", industry_type: :industry, naics_code: "238130").first_or_create
    IndustryCode.where(name: "Masonry Contractors", internal_name: "masonry-contractors", industry_type: :industry, naics_code: "238140").first_or_create
    IndustryCode.where(name: "Glass and Glazing Contractors", internal_name: "glass-and-glazing-contractors", industry_type: :industry, naics_code: "238150").first_or_create
    IndustryCode.where(name: "Roofing Contractors", internal_name: "roofing-contractors", industry_type: :industry, naics_code: "238160").first_or_create
    IndustryCode.where(name: "Siding Contractors", internal_name: "siding-contractors", industry_type: :industry, naics_code: "238170").first_or_create
    IndustryCode.where(name: "Other Foundation, Structure, and Building Exterior Contractors", internal_name: "other-foundation-structure-and-building-exterior-contractors", industry_type: :industry, naics_code: "238190").first_or_create
    IndustryCode.where(name: "Electrical Contractors and Other Wiring Installation Contractors", internal_name: "electrical-contractors-and-other-wiring-installation-contractors", industry_type: :industry, naics_code: "238210").first_or_create
    IndustryCode.where(name: "Plumbing, Heating, and Air-Conditioning Contractors", internal_name: "plumbing-heating-and-air-conditioning-contractors", industry_type: :industry, naics_code: "238220").first_or_create
    IndustryCode.where(name: "Other Building Equipment Contractors", internal_name: "other-building-equipment-contractors", industry_type: :industry, naics_code: "238290").first_or_create
    IndustryCode.where(name: "Drywall and Insulation Contractors", internal_name: "drywall-and-insulation-contractors", industry_type: :industry, naics_code: "238310").first_or_create
    IndustryCode.where(name: "Painting and Wall Covering Contractors", internal_name: "painting-and-wall-covering-contractors", industry_type: :industry, naics_code: "238320").first_or_create
    IndustryCode.where(name: "Flooring Contractors", internal_name: "flooring-contractors", industry_type: :industry, naics_code: "238330").first_or_create
    IndustryCode.where(name: "Tile and Terrazzo Contractors", internal_name: "tile-and-terrazzo-contractors", industry_type: :industry, naics_code: "238340").first_or_create
    IndustryCode.where(name: "Finish Carpentry Contractors", internal_name: "finish-carpentry-contractors", industry_type: :industry, naics_code: "238350").first_or_create
    IndustryCode.where(name: "Other Building Finishing Contractors", internal_name: "other-building-finishing-contractors", industry_type: :industry, naics_code: "238390").first_or_create
    IndustryCode.where(name: "Site Preparation Contractors", internal_name: "site-preparation-contractors", industry_type: :industry, naics_code: "238910").first_or_create
    IndustryCode.where(name: "All Other Specialty Trade Contractors", internal_name: "all-other-specialty-trade-contractors", industry_type: :industry, naics_code: "238990").first_or_create
    IndustryCode.where(name: "Dog and Cat Food Manufacturing", internal_name: "dog-and-cat-food-manufacturing", industry_type: :industry, naics_code: "311111").first_or_create
    IndustryCode.where(name: "Other Animal Food Manufacturing", internal_name: "other-animal-food-manufacturing", industry_type: :industry, naics_code: "311119").first_or_create
    IndustryCode.where(name: "Flour Milling", internal_name: "flour-milling", industry_type: :industry, naics_code: "311211").first_or_create
    IndustryCode.where(name: "Rice Milling", internal_name: "rice-milling", industry_type: :industry, naics_code: "311212").first_or_create
    IndustryCode.where(name: "Malt Manufacturing", internal_name: "malt-manufacturing", industry_type: :industry, naics_code: "311213").first_or_create
    IndustryCode.where(name: "Wet Corn Milling", internal_name: "wet-corn-milling", industry_type: :industry, naics_code: "311221").first_or_create
    IndustryCode.where(name: "Soybean and Other Oilseed Processing", internal_name: "soybean-and-other-oilseed-processing", industry_type: :industry, naics_code: "311224").first_or_create
    IndustryCode.where(name: "Fats and Oils Refining and Blending", internal_name: "fats-and-oils-refining-and-blending", industry_type: :industry, naics_code: "311225").first_or_create
    IndustryCode.where(name: "Breakfast Cereal Manufacturing", internal_name: "breakfast-cereal-manufacturing", industry_type: :industry, naics_code: "311230").first_or_create
    IndustryCode.where(name: "Beet Sugar Manufacturing", internal_name: "beet-sugar-manufacturing", industry_type: :industry, naics_code: "311313").first_or_create
    IndustryCode.where(name: "Cane Sugar Manufacturing", internal_name: "cane-sugar-manufacturing", industry_type: :industry, naics_code: "311314").first_or_create
    IndustryCode.where(name: "Nonchocolate Confectionery Manufacturing", internal_name: "nonchocolate-confectionery-manufacturing", industry_type: :industry, naics_code: "311340").first_or_create
    IndustryCode.where(name: "Chocolate and Confectionery Manufacturing from Cacao Beans", internal_name: "chocolate-and-confectionery-manufacturing-from-cacao-beans", industry_type: :industry, naics_code: "311351").first_or_create
    IndustryCode.where(name: "Confectionery Manufacturing from Purchased Chocolate", internal_name: "confectionery-manufacturing-from-purchased-chocolate", industry_type: :industry, naics_code: "311352").first_or_create
    IndustryCode.where(name: "Frozen Fruit, Juice, and Vegetable Manufacturing", internal_name: "frozen-fruit-juice-and-vegetable-manufacturing", industry_type: :industry, naics_code: "311411").first_or_create
    IndustryCode.where(name: "Frozen Specialty Food Manufacturing", internal_name: "frozen-specialty-food-manufacturing", industry_type: :industry, naics_code: "311412").first_or_create
    IndustryCode.where(name: "Fruit and Vegetable Canning", internal_name: "fruit-and-vegetable-canning", industry_type: :industry, naics_code: "311421").first_or_create
    IndustryCode.where(name: "Specialty Canning", internal_name: "specialty-canning", industry_type: :industry, naics_code: "311422").first_or_create
    IndustryCode.where(name: "Dried and Dehydrated Food Manufacturing", internal_name: "dried-and-dehydrated-food-manufacturing", industry_type: :industry, naics_code: "311423").first_or_create
    IndustryCode.where(name: "Fluid Milk Manufacturing", internal_name: "fluid-milk-manufacturing", industry_type: :industry, naics_code: "311511").first_or_create
    IndustryCode.where(name: "Creamery Butter Manufacturing", internal_name: "creamery-butter-manufacturing", industry_type: :industry, naics_code: "311512").first_or_create
    IndustryCode.where(name: "Cheese Manufacturing", internal_name: "cheese-manufacturing", industry_type: :industry, naics_code: "311513").first_or_create
    IndustryCode.where(name: "Dry, Condensed, and Evaporated Dairy Product Manufacturing", internal_name: "dry-condensed-and-evaporated-dairy-product-manufacturing", industry_type: :industry, naics_code: "311514").first_or_create
    IndustryCode.where(name: "Ice Cream and Frozen Dessert Manufacturing", internal_name: "ice-cream-and-frozen-dessert-manufacturing", industry_type: :industry, naics_code: "311520").first_or_create
    IndustryCode.where(name: "Animal (except Poultry) Slaughtering", internal_name: "animal-except-poultry-slaughtering", industry_type: :industry, naics_code: "311611").first_or_create
    IndustryCode.where(name: "Meat Processed from Carcasses", internal_name: "meat-processed-from-carcasses", industry_type: :industry, naics_code: "311612").first_or_create
    IndustryCode.where(name: "Rendering and Meat Byproduct Processing", internal_name: "rendering-and-meat-byproduct-processing", industry_type: :industry, naics_code: "311613").first_or_create
    IndustryCode.where(name: "Poultry Processing", internal_name: "poultry-processing", industry_type: :industry, naics_code: "311615").first_or_create
    IndustryCode.where(name: "Seafood Product Preparation and Packaging", internal_name: "seafood-product-preparation-and-packaging", industry_type: :industry, naics_code: "311710").first_or_create
    IndustryCode.where(name: "Retail Bakeries", internal_name: "retail-bakeries", industry_type: :industry, naics_code: "311811").first_or_create
    IndustryCode.where(name: "Commercial Bakeries", internal_name: "commercial-bakeries", industry_type: :industry, naics_code: "311812").first_or_create
    IndustryCode.where(name: "Frozen Cakes, Pies, and Other Pastries Manufacturing", internal_name: "frozen-cakes-pies-and-other-pastries-manufacturing", industry_type: :industry, naics_code: "311813").first_or_create
    IndustryCode.where(name: "Cookie and Cracker Manufacturing", internal_name: "cookie-and-cracker-manufacturing", industry_type: :industry, naics_code: "311821").first_or_create
    IndustryCode.where(name: "Dry Pasta, Dough, and Flour Mixes Manufacturing from Purchased Flour", internal_name: "dry-pasta-dough-and-flour-mixes-manufacturing-from-purchased-flour", industry_type: :industry, naics_code: "311824").first_or_create
    IndustryCode.where(name: "Tortilla Manufacturing", internal_name: "tortilla-manufacturing", industry_type: :industry, naics_code: "311830").first_or_create
    IndustryCode.where(name: "Roasted Nuts and Peanut Butter Manufacturing", internal_name: "roasted-nuts-and-peanut-butter-manufacturing", industry_type: :industry, naics_code: "311911").first_or_create
    IndustryCode.where(name: "Other Snack Food Manufacturing", internal_name: "other-snack-food-manufacturing", industry_type: :industry, naics_code: "311919").first_or_create
    IndustryCode.where(name: "Coffee and Tea Manufacturing", internal_name: "coffee-and-tea-manufacturing", industry_type: :industry, naics_code: "311920").first_or_create
    IndustryCode.where(name: "Flavoring Syrup and Concentrate Manufacturing", internal_name: "flavoring-syrup-and-concentrate-manufacturing", industry_type: :industry, naics_code: "311930").first_or_create
    IndustryCode.where(name: "Mayonnaise, Dressing, and Other Prepared Sauce Manufacturing", internal_name: "mayonnaise-dressing-and-other-prepared-sauce-manufacturing", industry_type: :industry, naics_code: "311941").first_or_create
    IndustryCode.where(name: "Spice and Extract Manufacturing", internal_name: "spice-and-extract-manufacturing", industry_type: :industry, naics_code: "311942").first_or_create
    IndustryCode.where(name: "Perishable Prepared Food Manufacturing", internal_name: "perishable-prepared-food-manufacturing", industry_type: :industry, naics_code: "311991").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Food Manufacturing", internal_name: "all-other-miscellaneous-food-manufacturing", industry_type: :industry, naics_code: "311999").first_or_create
    IndustryCode.where(name: "Soft Drink Manufacturing", internal_name: "soft-drink-manufacturing", industry_type: :industry, naics_code: "312111").first_or_create
    IndustryCode.where(name: "Bottled Water Manufacturing", internal_name: "bottled-water-manufacturing", industry_type: :industry, naics_code: "312112").first_or_create
    IndustryCode.where(name: "Ice Manufacturing", internal_name: "ice-manufacturing", industry_type: :industry, naics_code: "312113").first_or_create
    IndustryCode.where(name: "Breweries", internal_name: "breweries", industry_type: :industry, naics_code: "312120").first_or_create
    IndustryCode.where(name: "Wineries", internal_name: "wineries", industry_type: :industry, naics_code: "312130").first_or_create
    IndustryCode.where(name: "Distilleries", internal_name: "distilleries", industry_type: :industry, naics_code: "312140").first_or_create
    IndustryCode.where(name: "Tobacco Manufacturing", internal_name: "tobacco-manufacturing", industry_type: :industry, naics_code: "312230").first_or_create
    IndustryCode.where(name: "Fiber, Yarn, and Thread Mills", internal_name: "fiber-yarn-and-thread-mills", industry_type: :industry, naics_code: "313110").first_or_create
    IndustryCode.where(name: "Broadwoven Fabric Mills", internal_name: "broadwoven-fabric-mills", industry_type: :industry, naics_code: "313210").first_or_create
    IndustryCode.where(name: "Narrow Fabric Mills and Schiffli Machine Embroidery", internal_name: "narrow-fabric-mills-and-schiffli-machine-embroidery", industry_type: :industry, naics_code: "313220").first_or_create
    IndustryCode.where(name: "Nonwoven Fabric Mills", internal_name: "nonwoven-fabric-mills", industry_type: :industry, naics_code: "313230").first_or_create
    IndustryCode.where(name: "Knit Fabric Mills", internal_name: "knit-fabric-mills", industry_type: :industry, naics_code: "313240").first_or_create
    IndustryCode.where(name: "Textile and Fabric Finishing Mills", internal_name: "textile-and-fabric-finishing-mills", industry_type: :industry, naics_code: "313310").first_or_create
    IndustryCode.where(name: "Fabric Coating Mills", internal_name: "fabric-coating-mills", industry_type: :industry, naics_code: "313320").first_or_create
    IndustryCode.where(name: "Carpet and Rug Mills", internal_name: "carpet-and-rug-mills", industry_type: :industry, naics_code: "314110").first_or_create
    IndustryCode.where(name: "Curtain and Linen Mills", internal_name: "curtain-and-linen-mills", industry_type: :industry, naics_code: "314120").first_or_create
    IndustryCode.where(name: "Textile Bag and Canvas Mills", internal_name: "textile-bag-and-canvas-mills", industry_type: :industry, naics_code: "314910").first_or_create
    IndustryCode.where(name: "Rope, Cordage, Twine, Tire Cord, and Tire Fabric Mills", internal_name: "rope-cordage-twine-tire-cord-and-tire-fabric-mills", industry_type: :industry, naics_code: "314994").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Textile Product Mills", internal_name: "all-other-miscellaneous-textile-product-mills", industry_type: :industry, naics_code: "314999").first_or_create
    IndustryCode.where(name: "Hosiery and Sock Mills", internal_name: "hosiery-and-sock-mills", industry_type: :industry, naics_code: "315110").first_or_create
    IndustryCode.where(name: "Other Apparel Knitting Mills", internal_name: "other-apparel-knitting-mills", industry_type: :industry, naics_code: "315190").first_or_create
    IndustryCode.where(name: "Cut and Sew Apparel Contractors", internal_name: "cut-and-sew-apparel-contractors", industry_type: :industry, naics_code: "315210").first_or_create
    IndustryCode.where(name: "Men’s and Boys’ Cut and Sew Apparel Manufacturing", internal_name: "men’s-and-boys’-cut-and-sew-apparel-manufacturing", industry_type: :industry, naics_code: "315220").first_or_create
    IndustryCode.where(name: "Women’s, Girls’, and Infants’ Cut and Sew Apparel Manufacturing", internal_name: "women’s-girls’-and-infants’-cut-and-sew-apparel-manufacturing", industry_type: :industry, naics_code: "315240").first_or_create
    IndustryCode.where(name: "Other Cut and Sew Apparel Manufacturing", internal_name: "other-cut-and-sew-apparel-manufacturing", industry_type: :industry, naics_code: "315280").first_or_create
    IndustryCode.where(name: "Apparel Accessories and Other Apparel Manufacturing", internal_name: "apparel-accessories-and-other-apparel-manufacturing", industry_type: :industry, naics_code: "315990").first_or_create
    IndustryCode.where(name: "Leather and Hide Tanning and Finishing", internal_name: "leather-and-hide-tanning-and-finishing", industry_type: :industry, naics_code: "316110").first_or_create
    IndustryCode.where(name: "Footwear Manufacturing", internal_name: "footwear-manufacturing", industry_type: :industry, naics_code: "316210").first_or_create
    IndustryCode.where(name: "Women's Handbag and Purse Manufacturing", internal_name: "women's-handbag-and-purse-manufacturing", industry_type: :industry, naics_code: "316992").first_or_create
    IndustryCode.where(name: "All Other Leather Good and Allied Product Manufacturing", internal_name: "all-other-leather-good-and-allied-product-manufacturing", industry_type: :industry, naics_code: "316998").first_or_create
    IndustryCode.where(name: "Sawmills", internal_name: "sawmills", industry_type: :industry, naics_code: "321113").first_or_create
    IndustryCode.where(name: "Wood Preservation", internal_name: "wood-preservation", industry_type: :industry, naics_code: "321114").first_or_create
    IndustryCode.where(name: "Hardwood Veneer and Plywood Manufacturing", internal_name: "hardwood-veneer-and-plywood-manufacturing", industry_type: :industry, naics_code: "321211").first_or_create
    IndustryCode.where(name: "Softwood Veneer and Plywood Manufacturing", internal_name: "softwood-veneer-and-plywood-manufacturing", industry_type: :industry, naics_code: "321212").first_or_create
    IndustryCode.where(name: "Engineered Wood Member (except Truss) Manufacturing", internal_name: "engineered-wood-member-except-truss-manufacturing", industry_type: :industry, naics_code: "321213").first_or_create
    IndustryCode.where(name: "Truss Manufacturing", internal_name: "truss-manufacturing", industry_type: :industry, naics_code: "321214").first_or_create
    IndustryCode.where(name: "Reconstituted Wood Product Manufacturing", internal_name: "reconstituted-wood-product-manufacturing", industry_type: :industry, naics_code: "321219").first_or_create
    IndustryCode.where(name: "Wood Window and Door Manufacturing", internal_name: "wood-window-and-door-manufacturing", industry_type: :industry, naics_code: "321911").first_or_create
    IndustryCode.where(name: "Cut Stock, Resawing Lumber, and Planing", internal_name: "cut-stock-resawing-lumber-and-planing", industry_type: :industry, naics_code: "321912").first_or_create
    IndustryCode.where(name: "Other Millwork (including Flooring)", internal_name: "other-millwork-including-flooring", industry_type: :industry, naics_code: "321918").first_or_create
    IndustryCode.where(name: "Wood Container and Pallet Manufacturing", internal_name: "wood-container-and-pallet-manufacturing", industry_type: :industry, naics_code: "321920").first_or_create
    IndustryCode.where(name: "Manufactured Home (Mobile Home) Manufacturing", internal_name: "manufactured-home-mobile-home-manufacturing", industry_type: :industry, naics_code: "321991").first_or_create
    IndustryCode.where(name: "Prefabricated Wood Building Manufacturing", internal_name: "prefabricated-wood-building-manufacturing", industry_type: :industry, naics_code: "321992").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Wood Product Manufacturing", internal_name: "all-other-miscellaneous-wood-product-manufacturing", industry_type: :industry, naics_code: "321999").first_or_create
    IndustryCode.where(name: "Pulp Mills", internal_name: "pulp-mills", industry_type: :industry, naics_code: "322110").first_or_create
    IndustryCode.where(name: "Paper (except Newsprint) Mills", internal_name: "paper-except-newsprint-mills", industry_type: :industry, naics_code: "322121").first_or_create
    IndustryCode.where(name: "Newsprint Mills", internal_name: "newsprint-mills", industry_type: :industry, naics_code: "322122").first_or_create
    IndustryCode.where(name: "Paperboard Mills", internal_name: "paperboard-mills", industry_type: :industry, naics_code: "322130").first_or_create
    IndustryCode.where(name: "Corrugated and Solid Fiber Box Manufacturing", internal_name: "corrugated-and-solid-fiber-box-manufacturing", industry_type: :industry, naics_code: "322211").first_or_create
    IndustryCode.where(name: "Folding Paperboard Box Manufacturing", internal_name: "folding-paperboard-box-manufacturing", industry_type: :industry, naics_code: "322212").first_or_create
    IndustryCode.where(name: "Other Paperboard Container Manufacturing", internal_name: "other-paperboard-container-manufacturing", industry_type: :industry, naics_code: "322219").first_or_create
    IndustryCode.where(name: "Paper Bag and Coated and Treated Paper Manufacturing", internal_name: "paper-bag-and-coated-and-treated-paper-manufacturing", industry_type: :industry, naics_code: "322220").first_or_create
    IndustryCode.where(name: "Stationery Product Manufacturing", internal_name: "stationery-product-manufacturing", industry_type: :industry, naics_code: "322230").first_or_create
    IndustryCode.where(name: "Sanitary Paper Product Manufacturing", internal_name: "sanitary-paper-product-manufacturing", industry_type: :industry, naics_code: "322291").first_or_create
    IndustryCode.where(name: "All Other Converted Paper Product Manufacturing", internal_name: "all-other-converted-paper-product-manufacturing", industry_type: :industry, naics_code: "322299").first_or_create
    IndustryCode.where(name: "Commercial Printing (except Screen and Books)", internal_name: "commercial-printing-except-screen-and-books", industry_type: :industry, naics_code: "323111").first_or_create
    IndustryCode.where(name: "Commercial Screen Printing", internal_name: "commercial-screen-printing", industry_type: :industry, naics_code: "323113").first_or_create
    IndustryCode.where(name: "Books Printing", internal_name: "books-printing", industry_type: :industry, naics_code: "323117").first_or_create
    IndustryCode.where(name: "Support Activities for Printing", internal_name: "support-activities-for-printing", industry_type: :industry, naics_code: "323120").first_or_create
    IndustryCode.where(name: "Petroleum Refineries", internal_name: "petroleum-refineries", industry_type: :industry, naics_code: "324110").first_or_create
    IndustryCode.where(name: "Asphalt Paving Mixture and Block Manufacturing", internal_name: "asphalt-paving-mixture-and-block-manufacturing", industry_type: :industry, naics_code: "324121").first_or_create
    IndustryCode.where(name: "Asphalt Shingle and Coating Materials Manufacturing", internal_name: "asphalt-shingle-and-coating-materials-manufacturing", industry_type: :industry, naics_code: "324122").first_or_create
    IndustryCode.where(name: "Petroleum Lubricating Oil and Grease Manufacturing", internal_name: "petroleum-lubricating-oil-and-grease-manufacturing", industry_type: :industry, naics_code: "324191").first_or_create
    IndustryCode.where(name: "All Other Petroleum and Coal Products Manufacturing", internal_name: "all-other-petroleum-and-coal-products-manufacturing", industry_type: :industry, naics_code: "324199").first_or_create
    IndustryCode.where(name: "Petrochemical Manufacturing", internal_name: "petrochemical-manufacturing", industry_type: :industry, naics_code: "325110").first_or_create
    IndustryCode.where(name: "Industrial Gas Manufacturing", internal_name: "industrial-gas-manufacturing", industry_type: :industry, naics_code: "325120").first_or_create
    IndustryCode.where(name: "Synthetic Dye and Pigment Manufacturing", internal_name: "synthetic-dye-and-pigment-manufacturing", industry_type: :industry, naics_code: "325130").first_or_create
    IndustryCode.where(name: "Other Basic Inorganic Chemical Manufacturing", internal_name: "other-basic-inorganic-chemical-manufacturing", industry_type: :industry, naics_code: "325180").first_or_create
    IndustryCode.where(name: "Ethyl Alcohol Manufacturing", internal_name: "ethyl-alcohol-manufacturing", industry_type: :industry, naics_code: "325193").first_or_create
    IndustryCode.where(name: "Cyclic Crude, Intermediate, and Gum and Wood Chemical Manufacturing", internal_name: "cyclic-crude-intermediate-and-gum-and-wood-chemical-manufacturing", industry_type: :industry, naics_code: "325194").first_or_create
    IndustryCode.where(name: "All Other Basic Organic Chemical Manufacturing", internal_name: "all-other-basic-organic-chemical-manufacturing", industry_type: :industry, naics_code: "325199").first_or_create
    IndustryCode.where(name: "Plastics Material and Resin Manufacturing", internal_name: "plastics-material-and-resin-manufacturing", industry_type: :industry, naics_code: "325211").first_or_create
    IndustryCode.where(name: "Synthetic Rubber Manufacturing", internal_name: "synthetic-rubber-manufacturing", industry_type: :industry, naics_code: "325212").first_or_create
    IndustryCode.where(name: "Artificial and Synthetic Fibers and Filaments Manufacturing", internal_name: "artificial-and-synthetic-fibers-and-filaments-manufacturing", industry_type: :industry, naics_code: "325220").first_or_create
    IndustryCode.where(name: "Nitrogenous Fertilizer Manufacturing", internal_name: "nitrogenous-fertilizer-manufacturing", industry_type: :industry, naics_code: "325311").first_or_create
    IndustryCode.where(name: "Phosphatic Fertilizer Manufacturing", internal_name: "phosphatic-fertilizer-manufacturing", industry_type: :industry, naics_code: "325312").first_or_create
    IndustryCode.where(name: "Fertilizer (Mixing Only) Manufacturing", internal_name: "fertilizer-mixing-only-manufacturing", industry_type: :industry, naics_code: "325314").first_or_create
    IndustryCode.where(name: "Pesticide and Other Agricultural Chemical Manufacturing", internal_name: "pesticide-and-other-agricultural-chemical-manufacturing", industry_type: :industry, naics_code: "325320").first_or_create
    IndustryCode.where(name: "Medicinal and Botanical Manufacturing", internal_name: "medicinal-and-botanical-manufacturing", industry_type: :industry, naics_code: "325411").first_or_create
    IndustryCode.where(name: "Pharmaceutical Preparation Manufacturing", internal_name: "pharmaceutical-preparation-manufacturing", industry_type: :industry, naics_code: "325412").first_or_create
    IndustryCode.where(name: "In-Vitro Diagnostic Substance Manufacturing", internal_name: "in-vitro-diagnostic-substance-manufacturing", industry_type: :industry, naics_code: "325413").first_or_create
    IndustryCode.where(name: "Biological Product (except Diagnostic) Manufacturing", internal_name: "biological-product-except-diagnostic-manufacturing", industry_type: :industry, naics_code: "325414").first_or_create
    IndustryCode.where(name: "Paint and Coating Manufacturing", internal_name: "paint-and-coating-manufacturing", industry_type: :industry, naics_code: "325510").first_or_create
    IndustryCode.where(name: "Adhesive Manufacturing", internal_name: "adhesive-manufacturing", industry_type: :industry, naics_code: "325520").first_or_create
    IndustryCode.where(name: "Soap and Other Detergent Manufacturing", internal_name: "soap-and-other-detergent-manufacturing", industry_type: :industry, naics_code: "325611").first_or_create
    IndustryCode.where(name: "Polish and Other Sanitation Good Manufacturing", internal_name: "polish-and-other-sanitation-good-manufacturing", industry_type: :industry, naics_code: "325612").first_or_create
    IndustryCode.where(name: "Surface Active Agent Manufacturing", internal_name: "surface-active-agent-manufacturing", industry_type: :industry, naics_code: "325613").first_or_create
    IndustryCode.where(name: "Toilet Preparation Manufacturing", internal_name: "toilet-preparation-manufacturing", industry_type: :industry, naics_code: "325620").first_or_create
    IndustryCode.where(name: "Printing Ink Manufacturing", internal_name: "printing-ink-manufacturing", industry_type: :industry, naics_code: "325910").first_or_create
    IndustryCode.where(name: "Explosives Manufacturing", internal_name: "explosives-manufacturing", industry_type: :industry, naics_code: "325920").first_or_create
    IndustryCode.where(name: "Custom Compounding of Purchased Resins", internal_name: "custom-compounding-of-purchased-resins", industry_type: :industry, naics_code: "325991").first_or_create
    IndustryCode.where(name: "Photographic Film, Paper, Plate, and Chemical Manufacturing", internal_name: "photographic-film-paper-plate-and-chemical-manufacturing", industry_type: :industry, naics_code: "325992").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Chemical Product and Preparation Manufacturing", internal_name: "all-other-miscellaneous-chemical-product-and-preparation-manufacturing", industry_type: :industry, naics_code: "325998").first_or_create
    IndustryCode.where(name: "Plastics Bag and Pouch Manufacturing", internal_name: "plastics-bag-and-pouch-manufacturing", industry_type: :industry, naics_code: "326111").first_or_create
    IndustryCode.where(name: "Plastics Packaging Film and Sheet (including Laminated) Manufacturing", internal_name: "plastics-packaging-film-and-sheet-including-laminated-manufacturing", industry_type: :industry, naics_code: "326112").first_or_create
    IndustryCode.where(name: "Unlaminated Plastics Film and Sheet (except Packaging) Manufacturing", internal_name: "unlaminated-plastics-film-and-sheet-except-packaging-manufacturing", industry_type: :industry, naics_code: "326113").first_or_create
    IndustryCode.where(name: "Unlaminated Plastics Profile Shape Manufacturing", internal_name: "unlaminated-plastics-profile-shape-manufacturing", industry_type: :industry, naics_code: "326121").first_or_create
    IndustryCode.where(name: "Plastics Pipe and Pipe Fitting Manufacturing", internal_name: "plastics-pipe-and-pipe-fitting-manufacturing", industry_type: :industry, naics_code: "326122").first_or_create
    IndustryCode.where(name: "Laminated Plastics Plate, Sheet (except Packaging), and Shape Manufacturing", internal_name: "laminated-plastics-plate-sheet-except-packaging-and-shape-manufacturing", industry_type: :industry, naics_code: "326130").first_or_create
    IndustryCode.where(name: "Polystyrene Foam Product Manufacturing", internal_name: "polystyrene-foam-product-manufacturing", industry_type: :industry, naics_code: "326140").first_or_create
    IndustryCode.where(name: "Urethane and Other Foam Product (except Polystyrene) Manufacturing", internal_name: "urethane-and-other-foam-product-except-polystyrene-manufacturing", industry_type: :industry, naics_code: "326150").first_or_create
    IndustryCode.where(name: "Plastics Bottle Manufacturing", internal_name: "plastics-bottle-manufacturing", industry_type: :industry, naics_code: "326160").first_or_create
    IndustryCode.where(name: "Plastics Plumbing Fixture Manufacturing", internal_name: "plastics-plumbing-fixture-manufacturing", industry_type: :industry, naics_code: "326191").first_or_create
    IndustryCode.where(name: "All Other Plastics Product Manufacturing", internal_name: "all-other-plastics-product-manufacturing", industry_type: :industry, naics_code: "326199").first_or_create
    IndustryCode.where(name: "Tire Manufacturing (except Retreading)", internal_name: "tire-manufacturing-except-retreading", industry_type: :industry, naics_code: "326211").first_or_create
    IndustryCode.where(name: "Tire Retreading", internal_name: "tire-retreading", industry_type: :industry, naics_code: "326212").first_or_create
    IndustryCode.where(name: "Rubber and Plastics Hoses and Belting Manufacturing", internal_name: "rubber-and-plastics-hoses-and-belting-manufacturing", industry_type: :industry, naics_code: "326220").first_or_create
    IndustryCode.where(name: "Rubber Product Manufacturing for Mechanical Use", internal_name: "rubber-product-manufacturing-for-mechanical-use", industry_type: :industry, naics_code: "326291").first_or_create
    IndustryCode.where(name: "All Other Rubber Product Manufacturing", internal_name: "all-other-rubber-product-manufacturing", industry_type: :industry, naics_code: "326299").first_or_create
    IndustryCode.where(name: "Pottery, Ceramics, and Plumbing Fixture Manufacturing", internal_name: "pottery-ceramics-and-plumbing-fixture-manufacturing", industry_type: :industry, naics_code: "327110").first_or_create
    IndustryCode.where(name: "Clay Building Material and Refractories Manufacturing", internal_name: "clay-building-material-and-refractories-manufacturing", industry_type: :industry, naics_code: "327120").first_or_create
    IndustryCode.where(name: "Flat Glass Manufacturing", internal_name: "flat-glass-manufacturing", industry_type: :industry, naics_code: "327211").first_or_create
    IndustryCode.where(name: "Other Pressed and Blown Glass and Glassware Manufacturing", internal_name: "other-pressed-and-blown-glass-and-glassware-manufacturing", industry_type: :industry, naics_code: "327212").first_or_create
    IndustryCode.where(name: "Glass Container Manufacturing", internal_name: "glass-container-manufacturing", industry_type: :industry, naics_code: "327213").first_or_create
    IndustryCode.where(name: "Glass Product Manufacturing Made of Purchased Glass", internal_name: "glass-product-manufacturing-made-of-purchased-glass", industry_type: :industry, naics_code: "327215").first_or_create
    IndustryCode.where(name: "Cement Manufacturing", internal_name: "cement-manufacturing", industry_type: :industry, naics_code: "327310").first_or_create
    IndustryCode.where(name: "Ready-Mix Concrete Manufacturing", internal_name: "ready-mix-concrete-manufacturing", industry_type: :industry, naics_code: "327320").first_or_create
    IndustryCode.where(name: "Concrete Block and Brick Manufacturing", internal_name: "concrete-block-and-brick-manufacturing", industry_type: :industry, naics_code: "327331").first_or_create
    IndustryCode.where(name: "Concrete Pipe Manufacturing", internal_name: "concrete-pipe-manufacturing", industry_type: :industry, naics_code: "327332").first_or_create
    IndustryCode.where(name: "Other Concrete Product Manufacturing", internal_name: "other-concrete-product-manufacturing", industry_type: :industry, naics_code: "327390").first_or_create
    IndustryCode.where(name: "Lime Manufacturing", internal_name: "lime-manufacturing", industry_type: :industry, naics_code: "327410").first_or_create
    IndustryCode.where(name: "Gypsum Product Manufacturing", internal_name: "gypsum-product-manufacturing", industry_type: :industry, naics_code: "327420").first_or_create
    IndustryCode.where(name: "Abrasive Product Manufacturing", internal_name: "abrasive-product-manufacturing", industry_type: :industry, naics_code: "327910").first_or_create
    IndustryCode.where(name: "Cut Stone and Stone Product Manufacturing", internal_name: "cut-stone-and-stone-product-manufacturing", industry_type: :industry, naics_code: "327991").first_or_create
    IndustryCode.where(name: "Ground or Treated Mineral and Earth Manufacturing", internal_name: "ground-or-treated-mineral-and-earth-manufacturing", industry_type: :industry, naics_code: "327992").first_or_create
    IndustryCode.where(name: "Mineral Wool Manufacturing", internal_name: "mineral-wool-manufacturing", industry_type: :industry, naics_code: "327993").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Nonmetallic Mineral Product Manufacturing", internal_name: "all-other-miscellaneous-nonmetallic-mineral-product-manufacturing", industry_type: :industry, naics_code: "327999").first_or_create
    IndustryCode.where(name: "Iron and Steel Mills and Ferroalloy Manufacturing", internal_name: "iron-and-steel-mills-and-ferroalloy-manufacturing", industry_type: :industry, naics_code: "331110").first_or_create
    IndustryCode.where(name: "Iron and Steel Pipe and Tube Manufacturing from Purchased Steel", internal_name: "iron-and-steel-pipe-and-tube-manufacturing-from-purchased-steel", industry_type: :industry, naics_code: "331210").first_or_create
    IndustryCode.where(name: "Rolled Steel Shape Manufacturing", internal_name: "rolled-steel-shape-manufacturing", industry_type: :industry, naics_code: "331221").first_or_create
    IndustryCode.where(name: "Steel Wire Drawing", internal_name: "steel-wire-drawing", industry_type: :industry, naics_code: "331222").first_or_create
    IndustryCode.where(name: "Alumina Refining and Primary Aluminum Production", internal_name: "alumina-refining-and-primary-aluminum-production", industry_type: :industry, naics_code: "331313").first_or_create
    IndustryCode.where(name: "Secondary Smelting and Alloying of Aluminum", internal_name: "secondary-smelting-and-alloying-of-aluminum", industry_type: :industry, naics_code: "331314").first_or_create
    IndustryCode.where(name: "Aluminum Sheet, Plate, and Foil Manufacturing", internal_name: "aluminum-sheet-plate-and-foil-manufacturing", industry_type: :industry, naics_code: "331315").first_or_create
    IndustryCode.where(name: "Other Aluminum Rolling, Drawing, and Extruding", internal_name: "other-aluminum-rolling-drawing-and-extruding", industry_type: :industry, naics_code: "331318").first_or_create
    IndustryCode.where(name: "Nonferrous Metal (except Aluminum) Smelting and Refining", internal_name: "nonferrous-metal-except-aluminum-smelting-and-refining", industry_type: :industry, naics_code: "331410").first_or_create
    IndustryCode.where(name: "Copper Rolling, Drawing, Extruding, and Alloying", internal_name: "copper-rolling-drawing-extruding-and-alloying", industry_type: :industry, naics_code: "331420").first_or_create
    IndustryCode.where(name: "Nonferrous Metal (except Copper and Aluminum) Rolling, Drawing, and Extruding", internal_name: "nonferrous-metal-except-copper-and-aluminum-rolling-drawing-and-extruding", industry_type: :industry, naics_code: "331491").first_or_create
    IndustryCode.where(name: "Secondary Smelting, Refining, and Alloying of Nonferrous Metal (except Copper and Aluminum)", internal_name: "secondary-smelting-refining-and-alloying-of-nonferrous-metal-except-copper-and-aluminum", industry_type: :industry, naics_code: "331492").first_or_create
    IndustryCode.where(name: "Iron Foundries", internal_name: "iron-foundries", industry_type: :industry, naics_code: "331511").first_or_create
    IndustryCode.where(name: "Steel Investment Foundries", internal_name: "steel-investment-foundries", industry_type: :industry, naics_code: "331512").first_or_create
    IndustryCode.where(name: "Steel Foundries (except Investment)", internal_name: "steel-foundries-except-investment", industry_type: :industry, naics_code: "331513").first_or_create
    IndustryCode.where(name: "Nonferrous Metal Die-Casting Foundries", internal_name: "nonferrous-metal-die-casting-foundries", industry_type: :industry, naics_code: "331523").first_or_create
    IndustryCode.where(name: "Aluminum Foundries (except Die-Casting)", internal_name: "aluminum-foundries-except-die-casting", industry_type: :industry, naics_code: "331524").first_or_create
    IndustryCode.where(name: "Other Nonferrous Metal Foundries (except Die-Casting)", internal_name: "other-nonferrous-metal-foundries-except-die-casting", industry_type: :industry, naics_code: "331529").first_or_create
    IndustryCode.where(name: "Iron and Steel Forging", internal_name: "iron-and-steel-forging", industry_type: :industry, naics_code: "332111").first_or_create
    IndustryCode.where(name: "Nonferrous Forging", internal_name: "nonferrous-forging", industry_type: :industry, naics_code: "332112").first_or_create
    IndustryCode.where(name: "Custom Roll Forming", internal_name: "custom-roll-forming", industry_type: :industry, naics_code: "332114").first_or_create
    IndustryCode.where(name: "Powder Metallurgy Part Manufacturing", internal_name: "powder-metallurgy-part-manufacturing", industry_type: :industry, naics_code: "332117").first_or_create
    IndustryCode.where(name: "Metal Crown, Closure, and Other Metal Stamping (except Automotive)", internal_name: "metal-crown-closure-and-other-metal-stamping-except-automotive", industry_type: :industry, naics_code: "332119").first_or_create
    IndustryCode.where(name: "Metal Kitchen Cookware, Utensil, Cutlery, and Flatware (except Precious) Manufacturing", internal_name: "metal-kitchen-cookware-utensil-cutlery-and-flatware-except-precious-manufacturing", industry_type: :industry, naics_code: "332215").first_or_create
    IndustryCode.where(name: "Saw Blade and Handtool Manufacturing", internal_name: "saw-blade-and-handtool-manufacturing", industry_type: :industry, naics_code: "332216").first_or_create
    IndustryCode.where(name: "Prefabricated Metal Building and Component Manufacturing", internal_name: "prefabricated-metal-building-and-component-manufacturing", industry_type: :industry, naics_code: "332311").first_or_create
    IndustryCode.where(name: "Fabricated Structural Metal Manufacturing", internal_name: "fabricated-structural-metal-manufacturing", industry_type: :industry, naics_code: "332312").first_or_create
    IndustryCode.where(name: "Plate Work Manufacturing", internal_name: "plate-work-manufacturing", industry_type: :industry, naics_code: "332313").first_or_create
    IndustryCode.where(name: "Metal Window and Door Manufacturing", internal_name: "metal-window-and-door-manufacturing", industry_type: :industry, naics_code: "332321").first_or_create
    IndustryCode.where(name: "Sheet Metal Work Manufacturing", internal_name: "sheet-metal-work-manufacturing", industry_type: :industry, naics_code: "332322").first_or_create
    IndustryCode.where(name: "Ornamental and Architectural Metal Work Manufacturing", internal_name: "ornamental-and-architectural-metal-work-manufacturing", industry_type: :industry, naics_code: "332323").first_or_create
    IndustryCode.where(name: "Power Boiler and Heat Exchanger Manufacturing", internal_name: "power-boiler-and-heat-exchanger-manufacturing", industry_type: :industry, naics_code: "332410").first_or_create
    IndustryCode.where(name: "Metal Tank (Heavy Gauge) Manufacturing", internal_name: "metal-tank-heavy-gauge-manufacturing", industry_type: :industry, naics_code: "332420").first_or_create
    IndustryCode.where(name: "Metal Can Manufacturing", internal_name: "metal-can-manufacturing", industry_type: :industry, naics_code: "332431").first_or_create
    IndustryCode.where(name: "Other Metal Container Manufacturing", internal_name: "other-metal-container-manufacturing", industry_type: :industry, naics_code: "332439").first_or_create
    IndustryCode.where(name: "Hardware Manufacturing", internal_name: "hardware-manufacturing", industry_type: :industry, naics_code: "332510").first_or_create
    IndustryCode.where(name: "Spring Manufacturing", internal_name: "spring-manufacturing", industry_type: :industry, naics_code: "332613").first_or_create
    IndustryCode.where(name: "Other Fabricated Wire Product Manufacturing", internal_name: "other-fabricated-wire-product-manufacturing", industry_type: :industry, naics_code: "332618").first_or_create
    IndustryCode.where(name: "Machine Shops", internal_name: "machine-shops", industry_type: :industry, naics_code: "332710").first_or_create
    IndustryCode.where(name: "Precision Turned Product Manufacturing", internal_name: "precision-turned-product-manufacturing", industry_type: :industry, naics_code: "332721").first_or_create
    IndustryCode.where(name: "Bolt, Nut, Screw, Rivet, and Washer Manufacturing", internal_name: "bolt-nut-screw-rivet-and-washer-manufacturing", industry_type: :industry, naics_code: "332722").first_or_create
    IndustryCode.where(name: "Metal Heat Treating", internal_name: "metal-heat-treating", industry_type: :industry, naics_code: "332811").first_or_create
    IndustryCode.where(name: "Metal Coating, Engraving (except Jewelry and Silverware), and Allied Services to Manufacturers", internal_name: "metal-coating-engraving-except-jewelry-and-silverware-and-allied-services-to-manufacturers", industry_type: :industry, naics_code: "332812").first_or_create
    IndustryCode.where(name: "Electroplating, Plating, Polishing, Anodizing, and Coloring", internal_name: "electroplating-plating-polishing-anodizing-and-coloring", industry_type: :industry, naics_code: "332813").first_or_create
    IndustryCode.where(name: "Industrial Valve Manufacturing", internal_name: "industrial-valve-manufacturing", industry_type: :industry, naics_code: "332911").first_or_create
    IndustryCode.where(name: "Fluid Power Valve and Hose Fitting Manufacturing", internal_name: "fluid-power-valve-and-hose-fitting-manufacturing", industry_type: :industry, naics_code: "332912").first_or_create
    IndustryCode.where(name: "Plumbing Fixture Fitting and Trim Manufacturing", internal_name: "plumbing-fixture-fitting-and-trim-manufacturing", industry_type: :industry, naics_code: "332913").first_or_create
    IndustryCode.where(name: "Other Metal Valve and Pipe Fitting Manufacturing", internal_name: "other-metal-valve-and-pipe-fitting-manufacturing", industry_type: :industry, naics_code: "332919").first_or_create
    IndustryCode.where(name: "Ball and Roller Bearing Manufacturing", internal_name: "ball-and-roller-bearing-manufacturing", industry_type: :industry, naics_code: "332991").first_or_create
    IndustryCode.where(name: "Small Arms Ammunition Manufacturing", internal_name: "small-arms-ammunition-manufacturing", industry_type: :industry, naics_code: "332992").first_or_create
    IndustryCode.where(name: "Ammunition (except Small Arms) Manufacturing", internal_name: "ammunition-except-small-arms-manufacturing", industry_type: :industry, naics_code: "332993").first_or_create
    IndustryCode.where(name: "Small Arms, Ordnance, and Ordnance Accessories Manufacturing", internal_name: "small-arms-ordnance-and-ordnance-accessories-manufacturing", industry_type: :industry, naics_code: "332994").first_or_create
    IndustryCode.where(name: "Fabricated Pipe and Pipe Fitting Manufacturing", internal_name: "fabricated-pipe-and-pipe-fitting-manufacturing", industry_type: :industry, naics_code: "332996").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Fabricated Metal Product Manufacturing", internal_name: "all-other-miscellaneous-fabricated-metal-product-manufacturing", industry_type: :industry, naics_code: "332999").first_or_create
    IndustryCode.where(name: "Farm Machinery and Equipment Manufacturing", internal_name: "farm-machinery-and-equipment-manufacturing", industry_type: :industry, naics_code: "333111").first_or_create
    IndustryCode.where(name: "Lawn and Garden Tractor and Home Lawn and Garden Equipment Manufacturing", internal_name: "lawn-and-garden-tractor-and-home-lawn-and-garden-equipment-manufacturing", industry_type: :industry, naics_code: "333112").first_or_create
    IndustryCode.where(name: "Construction Machinery Manufacturing", internal_name: "construction-machinery-manufacturing", industry_type: :industry, naics_code: "333120").first_or_create
    IndustryCode.where(name: "Mining Machinery and Equipment Manufacturing", internal_name: "mining-machinery-and-equipment-manufacturing", industry_type: :industry, naics_code: "333131").first_or_create
    IndustryCode.where(name: "Oil and Gas Field Machinery and Equipment Manufacturing", internal_name: "oil-and-gas-field-machinery-and-equipment-manufacturing", industry_type: :industry, naics_code: "333132").first_or_create
    IndustryCode.where(name: "Food Product Machinery Manufacturing", internal_name: "food-product-machinery-manufacturing", industry_type: :industry, naics_code: "333241").first_or_create
    IndustryCode.where(name: "Semiconductor Machinery Manufacturing", internal_name: "semiconductor-machinery-manufacturing", industry_type: :industry, naics_code: "333242").first_or_create
    IndustryCode.where(name: "Sawmill, Woodworking, and Paper Machinery Manufacturing", internal_name: "sawmill-woodworking-and-paper-machinery-manufacturing", industry_type: :industry, naics_code: "333243").first_or_create
    IndustryCode.where(name: "Printing Machinery and Equipment Manufacturing", internal_name: "printing-machinery-and-equipment-manufacturing", industry_type: :industry, naics_code: "333244").first_or_create
    IndustryCode.where(name: "Other Industrial Machinery Manufacturing", internal_name: "other-industrial-machinery-manufacturing", industry_type: :industry, naics_code: "333249").first_or_create
    IndustryCode.where(name: "Optical Instrument and Lens Manufacturing", internal_name: "optical-instrument-and-lens-manufacturing", industry_type: :industry, naics_code: "333314").first_or_create
    IndustryCode.where(name: "Photographic and Photocopying Equipment Manufacturing", internal_name: "photographic-and-photocopying-equipment-manufacturing", industry_type: :industry, naics_code: "333316").first_or_create
    IndustryCode.where(name: "Other Commercial and Service Industry Machinery Manufacturing", internal_name: "other-commercial-and-service-industry-machinery-manufacturing", industry_type: :industry, naics_code: "333318").first_or_create
    IndustryCode.where(name: "Industrial and Commercial Fan and Blower and Air Purification Equipment Manufacturing", internal_name: "industrial-and-commercial-fan-and-blower-and-air-purification-equipment-manufacturing", industry_type: :industry, naics_code: "333413").first_or_create
    IndustryCode.where(name: "Heating Equipment (except Warm Air Furnaces) Manufacturing", internal_name: "heating-equipment-except-warm-air-furnaces-manufacturing", industry_type: :industry, naics_code: "333414").first_or_create
    IndustryCode.where(name: "Air-Conditioning and Warm Air Heating Equipment and Commercial and Industrial Refrigeration Equipment Manufacturing", internal_name: "air-conditioning-and-warm-air-heating-equipment-and-commercial-and-industrial-refrigeration-equipment-manufacturing", industry_type: :industry, naics_code: "333415").first_or_create
    IndustryCode.where(name: "Industrial Mold Manufacturing", internal_name: "industrial-mold-manufacturing", industry_type: :industry, naics_code: "333511").first_or_create
    IndustryCode.where(name: "Special Die and Tool, Die Set, Jig, and Fixture Manufacturing", internal_name: "special-die-and-tool-die-set-jig-and-fixture-manufacturing", industry_type: :industry, naics_code: "333514").first_or_create
    IndustryCode.where(name: "Cutting Tool and Machine Tool Accessory Manufacturing", internal_name: "cutting-tool-and-machine-tool-accessory-manufacturing", industry_type: :industry, naics_code: "333515").first_or_create
    IndustryCode.where(name: "Machine Tool Manufacturing", internal_name: "machine-tool-manufacturing", industry_type: :industry, naics_code: "333517").first_or_create
    IndustryCode.where(name: "Rolling Mill and Other Metalworking Machinery Manufacturing", internal_name: "rolling-mill-and-other-metalworking-machinery-manufacturing", industry_type: :industry, naics_code: "333519").first_or_create
    IndustryCode.where(name: "Turbine and Turbine Generator Set Units Manufacturing", internal_name: "turbine-and-turbine-generator-set-units-manufacturing", industry_type: :industry, naics_code: "333611").first_or_create
    IndustryCode.where(name: "Speed Changer, Industrial High-Speed Drive, and Gear Manufacturing", internal_name: "speed-changer-industrial-high-speed-drive-and-gear-manufacturing", industry_type: :industry, naics_code: "333612").first_or_create
    IndustryCode.where(name: "Mechanical Power Transmission Equipment Manufacturing", internal_name: "mechanical-power-transmission-equipment-manufacturing", industry_type: :industry, naics_code: "333613").first_or_create
    IndustryCode.where(name: "Other Engine Equipment Manufacturing", internal_name: "other-engine-equipment-manufacturing", industry_type: :industry, naics_code: "333618").first_or_create
    IndustryCode.where(name: "Pump and Pumping Equipment Manufacturing", internal_name: "pump-and-pumping-equipment-manufacturing", industry_type: :industry, naics_code: "333911").first_or_create
    IndustryCode.where(name: "Air and Gas Compressor Manufacturing", internal_name: "air-and-gas-compressor-manufacturing", industry_type: :industry, naics_code: "333912").first_or_create
    IndustryCode.where(name: "Measuring and Dispensing Pump Manufacturing", internal_name: "measuring-and-dispensing-pump-manufacturing", industry_type: :industry, naics_code: "333913").first_or_create
    IndustryCode.where(name: "Elevator and Moving Stairway Manufacturing", internal_name: "elevator-and-moving-stairway-manufacturing", industry_type: :industry, naics_code: "333921").first_or_create
    IndustryCode.where(name: "Conveyor and Conveying Equipment Manufacturing", internal_name: "conveyor-and-conveying-equipment-manufacturing", industry_type: :industry, naics_code: "333922").first_or_create
    IndustryCode.where(name: "Overhead Traveling Crane, Hoist, and Monorail System Manufacturing", internal_name: "overhead-traveling-crane-hoist-and-monorail-system-manufacturing", industry_type: :industry, naics_code: "333923").first_or_create
    IndustryCode.where(name: "Industrial Truck, Tractor, Trailer, and Stacker Machinery Manufacturing", internal_name: "industrial-truck-tractor-trailer-and-stacker-machinery-manufacturing", industry_type: :industry, naics_code: "333924").first_or_create
    IndustryCode.where(name: "Power-Driven Handtool Manufacturing", internal_name: "power-driven-handtool-manufacturing", industry_type: :industry, naics_code: "333991").first_or_create
    IndustryCode.where(name: "Welding and Soldering Equipment Manufacturing", internal_name: "welding-and-soldering-equipment-manufacturing", industry_type: :industry, naics_code: "333992").first_or_create
    IndustryCode.where(name: "Packaging Machinery Manufacturing", internal_name: "packaging-machinery-manufacturing", industry_type: :industry, naics_code: "333993").first_or_create
    IndustryCode.where(name: "Industrial Process Furnace and Oven Manufacturing", internal_name: "industrial-process-furnace-and-oven-manufacturing", industry_type: :industry, naics_code: "333994").first_or_create
    IndustryCode.where(name: "Fluid Power Cylinder and Actuator Manufacturing", internal_name: "fluid-power-cylinder-and-actuator-manufacturing", industry_type: :industry, naics_code: "333995").first_or_create
    IndustryCode.where(name: "Fluid Power Pump and Motor Manufacturing", internal_name: "fluid-power-pump-and-motor-manufacturing", industry_type: :industry, naics_code: "333996").first_or_create
    IndustryCode.where(name: "Scale and Balance Manufacturing", internal_name: "scale-and-balance-manufacturing", industry_type: :industry, naics_code: "333997").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous General Purpose Machinery Manufacturing", internal_name: "all-other-miscellaneous-general-purpose-machinery-manufacturing", industry_type: :industry, naics_code: "333999").first_or_create
    IndustryCode.where(name: "Electronic Computer Manufacturing", internal_name: "electronic-computer-manufacturing", industry_type: :industry, naics_code: "334111").first_or_create
    IndustryCode.where(name: "Computer Storage Device Manufacturing", internal_name: "computer-storage-device-manufacturing", industry_type: :industry, naics_code: "334112").first_or_create
    IndustryCode.where(name: "Computer Terminal and Other Computer Peripheral Equipment Manufacturing", internal_name: "computer-terminal-and-other-computer-peripheral-equipment-manufacturing", industry_type: :industry, naics_code: "334118").first_or_create
    IndustryCode.where(name: "Telephone Apparatus Manufacturing", internal_name: "telephone-apparatus-manufacturing", industry_type: :industry, naics_code: "334210").first_or_create
    IndustryCode.where(name: "Radio and Television Broadcasting and Wireless Communications Equipment Manufacturing", internal_name: "radio-and-television-broadcasting-and-wireless-communications-equipment-manufacturing", industry_type: :industry, naics_code: "334220").first_or_create
    IndustryCode.where(name: "Other Communications Equipment Manufacturing", internal_name: "other-communications-equipment-manufacturing", industry_type: :industry, naics_code: "334290").first_or_create
    IndustryCode.where(name: "Audio and Video Equipment Manufacturing", internal_name: "audio-and-video-equipment-manufacturing", industry_type: :industry, naics_code: "334310").first_or_create
    IndustryCode.where(name: "Bare Printed Circuit Board Manufacturing", internal_name: "bare-printed-circuit-board-manufacturing", industry_type: :industry, naics_code: "334412").first_or_create
    IndustryCode.where(name: "Semiconductor and Related Device Manufacturing", internal_name: "semiconductor-and-related-device-manufacturing", industry_type: :industry, naics_code: "334413").first_or_create
    IndustryCode.where(name: "Capacitor, Resistor, Coil, Transformer, and Other Inductor Manufacturing", internal_name: "capacitor-resistor-coil-transformer-and-other-inductor-manufacturing", industry_type: :industry, naics_code: "334416").first_or_create
    IndustryCode.where(name: "Electronic Connector Manufacturing", internal_name: "electronic-connector-manufacturing", industry_type: :industry, naics_code: "334417").first_or_create
    IndustryCode.where(name: "Printed Circuit Assembly (Electronic Assembly) Manufacturing", internal_name: "printed-circuit-assembly-electronic-assembly-manufacturing", industry_type: :industry, naics_code: "334418").first_or_create
    IndustryCode.where(name: "Other Electronic Component Manufacturing", internal_name: "other-electronic-component-manufacturing", industry_type: :industry, naics_code: "334419").first_or_create
    IndustryCode.where(name: "Electromedical and Electrotherapeutic Apparatus Manufacturing", internal_name: "electromedical-and-electrotherapeutic-apparatus-manufacturing", industry_type: :industry, naics_code: "334510").first_or_create
    IndustryCode.where(name: "Search, Detection, Navigation, Guidance, Aeronautical, and Nautical System and Instrument Manufacturing", internal_name: "search-detection-navigation-guidance-aeronautical-and-nautical-system-and-instrument-manufacturing", industry_type: :industry, naics_code: "334511").first_or_create
    IndustryCode.where(name: "Automatic Environmental Control Manufacturing for Residential, Commercial, and Appliance Use", internal_name: "automatic-environmental-control-manufacturing-for-residential-commercial-and-appliance-use", industry_type: :industry, naics_code: "334512").first_or_create
    IndustryCode.where(name: "Instruments and Related Products Manufacturing for Measuring, Displaying, and Controlling Industrial Process Variables", internal_name: "instruments-and-related-products-manufacturing-for-measuring-displaying-and-controlling-industrial-process-variables", industry_type: :industry, naics_code: "334513").first_or_create
    IndustryCode.where(name: "Totalizing Fluid Meter and Counting Device Manufacturing", internal_name: "totalizing-fluid-meter-and-counting-device-manufacturing", industry_type: :industry, naics_code: "334514").first_or_create
    IndustryCode.where(name: "Instrument Manufacturing for Measuring and Testing Electricity and Electrical Signals", internal_name: "instrument-manufacturing-for-measuring-and-testing-electricity-and-electrical-signals", industry_type: :industry, naics_code: "334515").first_or_create
    IndustryCode.where(name: "Analytical Laboratory Instrument Manufacturing", internal_name: "analytical-laboratory-instrument-manufacturing", industry_type: :industry, naics_code: "334516").first_or_create
    IndustryCode.where(name: "Irradiation Apparatus Manufacturing", internal_name: "irradiation-apparatus-manufacturing", industry_type: :industry, naics_code: "334517").first_or_create
    IndustryCode.where(name: "Other Measuring and Controlling Device Manufacturing", internal_name: "other-measuring-and-controlling-device-manufacturing", industry_type: :industry, naics_code: "334519").first_or_create
    IndustryCode.where(name: "Blank Magnetic and Optical Recording Media Manufacturing", internal_name: "blank-magnetic-and-optical-recording-media-manufacturing", industry_type: :industry, naics_code: "334613").first_or_create
    IndustryCode.where(name: "Software and Other Prerecorded Compact Disc, Tape, and Record Reproducing", internal_name: "software-and-other-prerecorded-compact-disc-tape-and-record-reproducing", industry_type: :industry, naics_code: "334614").first_or_create
    IndustryCode.where(name: "Electric Lamp Bulb and Part Manufacturing", internal_name: "electric-lamp-bulb-and-part-manufacturing", industry_type: :industry, naics_code: "335110").first_or_create
    IndustryCode.where(name: "Residential Electric Lighting Fixture Manufacturing", internal_name: "residential-electric-lighting-fixture-manufacturing", industry_type: :industry, naics_code: "335121").first_or_create
    IndustryCode.where(name: "Commercial, Industrial, and Institutional Electric Lighting Fixture Manufacturing", internal_name: "commercial-industrial-and-institutional-electric-lighting-fixture-manufacturing", industry_type: :industry, naics_code: "335122").first_or_create
    IndustryCode.where(name: "Other Lighting Equipment Manufacturing", internal_name: "other-lighting-equipment-manufacturing", industry_type: :industry, naics_code: "335129").first_or_create
    IndustryCode.where(name: "Small Electrical Appliance Manufacturing", internal_name: "small-electrical-appliance-manufacturing", industry_type: :industry, naics_code: "335210").first_or_create
    IndustryCode.where(name: "Household Cooking Appliance Manufacturing", internal_name: "household-cooking-appliance-manufacturing", industry_type: :industry, naics_code: "335221").first_or_create
    IndustryCode.where(name: "Household Refrigerator and Home Freezer Manufacturing", internal_name: "household-refrigerator-and-home-freezer-manufacturing", industry_type: :industry, naics_code: "335222").first_or_create
    IndustryCode.where(name: "Household Laundry Equipment Manufacturing", internal_name: "household-laundry-equipment-manufacturing", industry_type: :industry, naics_code: "335224").first_or_create
    IndustryCode.where(name: "Other Major Household Appliance Manufacturing", internal_name: "other-major-household-appliance-manufacturing", industry_type: :industry, naics_code: "335228").first_or_create
    IndustryCode.where(name: "Power, Distribution, and Specialty Transformer Manufacturing", internal_name: "power-distribution-and-specialty-transformer-manufacturing", industry_type: :industry, naics_code: "335311").first_or_create
    IndustryCode.where(name: "Motor and Generator Manufacturing", internal_name: "motor-and-generator-manufacturing", industry_type: :industry, naics_code: "335312").first_or_create
    IndustryCode.where(name: "Switchgear and Switchboard Apparatus Manufacturing", internal_name: "switchgear-and-switchboard-apparatus-manufacturing", industry_type: :industry, naics_code: "335313").first_or_create
    IndustryCode.where(name: "Relay and Industrial Control Manufacturing", internal_name: "relay-and-industrial-control-manufacturing", industry_type: :industry, naics_code: "335314").first_or_create
    IndustryCode.where(name: "Storage Battery Manufacturing", internal_name: "storage-battery-manufacturing", industry_type: :industry, naics_code: "335911").first_or_create
    IndustryCode.where(name: "Primary Battery Manufacturing", internal_name: "primary-battery-manufacturing", industry_type: :industry, naics_code: "335912").first_or_create
    IndustryCode.where(name: "Fiber Optic Cable Manufacturing", internal_name: "fiber-optic-cable-manufacturing", industry_type: :industry, naics_code: "335921").first_or_create
    IndustryCode.where(name: "Other Communication and Energy Wire Manufacturing", internal_name: "other-communication-and-energy-wire-manufacturing", industry_type: :industry, naics_code: "335929").first_or_create
    IndustryCode.where(name: "Current-Carrying Wiring Device Manufacturing", internal_name: "current-carrying-wiring-device-manufacturing", industry_type: :industry, naics_code: "335931").first_or_create
    IndustryCode.where(name: "Noncurrent-Carrying Wiring Device Manufacturing", internal_name: "noncurrent-carrying-wiring-device-manufacturing", industry_type: :industry, naics_code: "335932").first_or_create
    IndustryCode.where(name: "Carbon and Graphite Product Manufacturing", internal_name: "carbon-and-graphite-product-manufacturing", industry_type: :industry, naics_code: "335991").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Electrical Equipment and Component Manufacturing", internal_name: "all-other-miscellaneous-electrical-equipment-and-component-manufacturing", industry_type: :industry, naics_code: "335999").first_or_create
    IndustryCode.where(name: "Automobile Manufacturing", internal_name: "automobile-manufacturing", industry_type: :industry, naics_code: "336111").first_or_create
    IndustryCode.where(name: "Light Truck and Utility Vehicle Manufacturing", internal_name: "light-truck-and-utility-vehicle-manufacturing", industry_type: :industry, naics_code: "336112").first_or_create
    IndustryCode.where(name: "Heavy Duty Truck Manufacturing", internal_name: "heavy-duty-truck-manufacturing", industry_type: :industry, naics_code: "336120").first_or_create
    IndustryCode.where(name: "Motor Vehicle Body Manufacturing", internal_name: "motor-vehicle-body-manufacturing", industry_type: :industry, naics_code: "336211").first_or_create
    IndustryCode.where(name: "Truck Trailer Manufacturing", internal_name: "truck-trailer-manufacturing", industry_type: :industry, naics_code: "336212").first_or_create
    IndustryCode.where(name: "Motor Home Manufacturing", internal_name: "motor-home-manufacturing", industry_type: :industry, naics_code: "336213").first_or_create
    IndustryCode.where(name: "Travel Trailer and Camper Manufacturing", internal_name: "travel-trailer-and-camper-manufacturing", industry_type: :industry, naics_code: "336214").first_or_create
    IndustryCode.where(name: "Motor Vehicle Gasoline Engine and Engine Parts Manufacturing", internal_name: "motor-vehicle-gasoline-engine-and-engine-parts-manufacturing", industry_type: :industry, naics_code: "336310").first_or_create
    IndustryCode.where(name: "Motor Vehicle Electrical and Electronic Equipment Manufacturing", internal_name: "motor-vehicle-electrical-and-electronic-equipment-manufacturing", industry_type: :industry, naics_code: "336320").first_or_create
    IndustryCode.where(name: "Motor Vehicle Steering and Suspension Components (except Spring) Manufacturing", internal_name: "motor-vehicle-steering-and-suspension-components-except-spring-manufacturing", industry_type: :industry, naics_code: "336330").first_or_create
    IndustryCode.where(name: "Motor Vehicle Brake System Manufacturing", internal_name: "motor-vehicle-brake-system-manufacturing", industry_type: :industry, naics_code: "336340").first_or_create
    IndustryCode.where(name: "Motor Vehicle Transmission and Power Train Parts Manufacturing", internal_name: "motor-vehicle-transmission-and-power-train-parts-manufacturing", industry_type: :industry, naics_code: "336350").first_or_create
    IndustryCode.where(name: "Motor Vehicle Seating and Interior Trim Manufacturing", internal_name: "motor-vehicle-seating-and-interior-trim-manufacturing", industry_type: :industry, naics_code: "336360").first_or_create
    IndustryCode.where(name: "Motor Vehicle Metal Stamping", internal_name: "motor-vehicle-metal-stamping", industry_type: :industry, naics_code: "336370").first_or_create
    IndustryCode.where(name: "Other Motor Vehicle Parts Manufacturing", internal_name: "other-motor-vehicle-parts-manufacturing", industry_type: :industry, naics_code: "336390").first_or_create
    IndustryCode.where(name: "Aircraft Manufacturing", internal_name: "aircraft-manufacturing", industry_type: :industry, naics_code: "336411").first_or_create
    IndustryCode.where(name: "Aircraft Engine and Engine Parts Manufacturing", internal_name: "aircraft-engine-and-engine-parts-manufacturing", industry_type: :industry, naics_code: "336412").first_or_create
    IndustryCode.where(name: "Other Aircraft Parts and Auxiliary Equipment Manufacturing", internal_name: "other-aircraft-parts-and-auxiliary-equipment-manufacturing", industry_type: :industry, naics_code: "336413").first_or_create
    IndustryCode.where(name: "Guided Missile and Space Vehicle Manufacturing", internal_name: "guided-missile-and-space-vehicle-manufacturing", industry_type: :industry, naics_code: "336414").first_or_create
    IndustryCode.where(name: "Guided Missile and Space Vehicle Propulsion Unit and Propulsion Unit Parts Manufacturing", internal_name: "guided-missile-and-space-vehicle-propulsion-unit-and-propulsion-unit-parts-manufacturing", industry_type: :industry, naics_code: "336415").first_or_create
    IndustryCode.where(name: "Other Guided Missile and Space Vehicle Parts and Auxiliary Equipment Manufacturing", internal_name: "other-guided-missile-and-space-vehicle-parts-and-auxiliary-equipment-manufacturing", industry_type: :industry, naics_code: "336419").first_or_create
    IndustryCode.where(name: "Railroad Rolling Stock Manufacturing", internal_name: "railroad-rolling-stock-manufacturing", industry_type: :industry, naics_code: "336510").first_or_create
    IndustryCode.where(name: "Ship Building and Repairing", internal_name: "ship-building-and-repairing", industry_type: :industry, naics_code: "336611").first_or_create
    IndustryCode.where(name: "Boat Building", internal_name: "boat-building", industry_type: :industry, naics_code: "336612").first_or_create
    IndustryCode.where(name: "Motorcycle, Bicycle, and Parts Manufacturing", internal_name: "motorcycle-bicycle-and-parts-manufacturing", industry_type: :industry, naics_code: "336991").first_or_create
    IndustryCode.where(name: "Military Armored Vehicle, Tank, and Tank Component Manufacturing", internal_name: "military-armored-vehicle-tank-and-tank-component-manufacturing", industry_type: :industry, naics_code: "336992").first_or_create
    IndustryCode.where(name: "All Other Transportation Equipment Manufacturing", internal_name: "all-other-transportation-equipment-manufacturing", industry_type: :industry, naics_code: "336999").first_or_create
    IndustryCode.where(name: "Wood Kitchen Cabinet and Countertop Manufacturing", internal_name: "wood-kitchen-cabinet-and-countertop-manufacturing", industry_type: :industry, naics_code: "337110").first_or_create
    IndustryCode.where(name: "Upholstered Household Furniture Manufacturing", internal_name: "upholstered-household-furniture-manufacturing", industry_type: :industry, naics_code: "337121").first_or_create
    IndustryCode.where(name: "Nonupholstered Wood Household Furniture Manufacturing", internal_name: "nonupholstered-wood-household-furniture-manufacturing", industry_type: :industry, naics_code: "337122").first_or_create
    IndustryCode.where(name: "Metal Household Furniture Manufacturing", internal_name: "metal-household-furniture-manufacturing", industry_type: :industry, naics_code: "337124").first_or_create
    IndustryCode.where(name: "Household Furniture (except Wood and Metal) Manufacturing", internal_name: "household-furniture-except-wood-and-metal-manufacturing", industry_type: :industry, naics_code: "337125").first_or_create
    IndustryCode.where(name: "Institutional Furniture Manufacturing", internal_name: "institutional-furniture-manufacturing", industry_type: :industry, naics_code: "337127").first_or_create
    IndustryCode.where(name: "Wood Office Furniture Manufacturing", internal_name: "wood-office-furniture-manufacturing", industry_type: :industry, naics_code: "337211").first_or_create
    IndustryCode.where(name: "Custom Architectural Woodwork and Millwork Manufacturing", internal_name: "custom-architectural-woodwork-and-millwork-manufacturing", industry_type: :industry, naics_code: "337212").first_or_create
    IndustryCode.where(name: "Office Furniture (except Wood) Manufacturing", internal_name: "office-furniture-except-wood-manufacturing", industry_type: :industry, naics_code: "337214").first_or_create
    IndustryCode.where(name: "Showcase, Partition, Shelving, and Locker Manufacturing", internal_name: "showcase-partition-shelving-and-locker-manufacturing", industry_type: :industry, naics_code: "337215").first_or_create
    IndustryCode.where(name: "Mattress Manufacturing", internal_name: "mattress-manufacturing", industry_type: :industry, naics_code: "337910").first_or_create
    IndustryCode.where(name: "Blind and Shade Manufacturing", internal_name: "blind-and-shade-manufacturing", industry_type: :industry, naics_code: "337920").first_or_create
    IndustryCode.where(name: "Surgical and Medical Instrument Manufacturing", internal_name: "surgical-and-medical-instrument-manufacturing", industry_type: :industry, naics_code: "339112").first_or_create
    IndustryCode.where(name: "Surgical Appliance and Supplies Manufacturing", internal_name: "surgical-appliance-and-supplies-manufacturing", industry_type: :industry, naics_code: "339113").first_or_create
    IndustryCode.where(name: "Dental Equipment and Supplies Manufacturing", internal_name: "dental-equipment-and-supplies-manufacturing", industry_type: :industry, naics_code: "339114").first_or_create
    IndustryCode.where(name: "Ophthalmic Goods Manufacturing", internal_name: "ophthalmic-goods-manufacturing", industry_type: :industry, naics_code: "339115").first_or_create
    IndustryCode.where(name: "Dental Laboratories", internal_name: "dental-laboratories", industry_type: :industry, naics_code: "339116").first_or_create
    IndustryCode.where(name: "Jewelry and Silverware Manufacturing", internal_name: "jewelry-and-silverware-manufacturing", industry_type: :industry, naics_code: "339910").first_or_create
    IndustryCode.where(name: "Sporting and Athletic Goods Manufacturing", internal_name: "sporting-and-athletic-goods-manufacturing", industry_type: :industry, naics_code: "339920").first_or_create
    IndustryCode.where(name: "Doll, Toy, and Game Manufacturing", internal_name: "doll-toy-and-game-manufacturing", industry_type: :industry, naics_code: "339930").first_or_create
    IndustryCode.where(name: "Office Supplies (except Paper) Manufacturing", internal_name: "office-supplies-except-paper-manufacturing", industry_type: :industry, naics_code: "339940").first_or_create
    IndustryCode.where(name: "Sign Manufacturing", internal_name: "sign-manufacturing", industry_type: :industry, naics_code: "339950").first_or_create
    IndustryCode.where(name: "Gasket, Packing, and Sealing Device Manufacturing", internal_name: "gasket-packing-and-sealing-device-manufacturing", industry_type: :industry, naics_code: "339991").first_or_create
    IndustryCode.where(name: "Musical Instrument Manufacturing", internal_name: "musical-instrument-manufacturing", industry_type: :industry, naics_code: "339992").first_or_create
    IndustryCode.where(name: "Fastener, Button, Needle, and Pin Manufacturing", internal_name: "fastener-button-needle-and-pin-manufacturing", industry_type: :industry, naics_code: "339993").first_or_create
    IndustryCode.where(name: "Broom, Brush, and Mop Manufacturing", internal_name: "broom-brush-and-mop-manufacturing", industry_type: :industry, naics_code: "339994").first_or_create
    IndustryCode.where(name: "Burial Casket Manufacturing", internal_name: "burial-casket-manufacturing", industry_type: :industry, naics_code: "339995").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Manufacturing", internal_name: "all-other-miscellaneous-manufacturing", industry_type: :industry, naics_code: "339999").first_or_create
    IndustryCode.where(name: "Automobile and Other Motor Vehicle Merchant Wholesalers", internal_name: "automobile-and-other-motor-vehicle-merchant-wholesalers", industry_type: :industry, naics_code: "423110").first_or_create
    IndustryCode.where(name: "Motor Vehicle Supplies and New Parts Merchant Wholesalers", internal_name: "motor-vehicle-supplies-and-new-parts-merchant-wholesalers", industry_type: :industry, naics_code: "423120").first_or_create
    IndustryCode.where(name: "Tire and Tube Merchant Wholesalers", internal_name: "tire-and-tube-merchant-wholesalers", industry_type: :industry, naics_code: "423130").first_or_create
    IndustryCode.where(name: "Motor Vehicle Parts (Used) Merchant Wholesalers", internal_name: "motor-vehicle-parts-used-merchant-wholesalers", industry_type: :industry, naics_code: "423140").first_or_create
    IndustryCode.where(name: "Furniture Merchant Wholesalers", internal_name: "furniture-merchant-wholesalers", industry_type: :industry, naics_code: "423210").first_or_create
    IndustryCode.where(name: "Home Furnishing Merchant Wholesalers", internal_name: "home-furnishing-merchant-wholesalers", industry_type: :industry, naics_code: "423220").first_or_create
    IndustryCode.where(name: "Lumber, Plywood, Millwork, and Wood Panel Merchant Wholesalers", internal_name: "lumber-plywood-millwork-and-wood-panel-merchant-wholesalers", industry_type: :industry, naics_code: "423310").first_or_create
    IndustryCode.where(name: "Brick, Stone, and Related Construction Material Merchant Wholesalers", internal_name: "brick-stone-and-related-construction-material-merchant-wholesalers", industry_type: :industry, naics_code: "423320").first_or_create
    IndustryCode.where(name: "Roofing, Siding, and Insulation Material Merchant Wholesalers", internal_name: "roofing-siding-and-insulation-material-merchant-wholesalers", industry_type: :industry, naics_code: "423330").first_or_create
    IndustryCode.where(name: "Other Construction Material Merchant Wholesalers", internal_name: "other-construction-material-merchant-wholesalers", industry_type: :industry, naics_code: "423390").first_or_create
    IndustryCode.where(name: "Photographic Equipment and Supplies Merchant Wholesalers", internal_name: "photographic-equipment-and-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "423410").first_or_create
    IndustryCode.where(name: "Office Equipment Merchant Wholesalers", internal_name: "office-equipment-merchant-wholesalers", industry_type: :industry, naics_code: "423420").first_or_create
    IndustryCode.where(name: "Computer and Computer Peripheral Equipment and Software Merchant Wholesalers", internal_name: "computer-and-computer-peripheral-equipment-and-software-merchant-wholesalers", industry_type: :industry, naics_code: "423430").first_or_create
    IndustryCode.where(name: "Other Commercial Equipment Merchant Wholesalers", internal_name: "other-commercial-equipment-merchant-wholesalers", industry_type: :industry, naics_code: "423440").first_or_create
    IndustryCode.where(name: "Medical, Dental, and Hospital Equipment and Supplies Merchant Wholesalers", internal_name: "medical-dental-and-hospital-equipment-and-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "423450").first_or_create
    IndustryCode.where(name: "Ophthalmic Goods Merchant Wholesalers", internal_name: "ophthalmic-goods-merchant-wholesalers", industry_type: :industry, naics_code: "423460").first_or_create
    IndustryCode.where(name: "Other Professional Equipment and Supplies Merchant Wholesalers", internal_name: "other-professional-equipment-and-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "423490").first_or_create
    IndustryCode.where(name: "Metal Service Centers and Other Metal Merchant Wholesalers", internal_name: "metal-service-centers-and-other-metal-merchant-wholesalers", industry_type: :industry, naics_code: "423510").first_or_create
    IndustryCode.where(name: "Coal and Other Mineral and Ore Merchant Wholesalers", internal_name: "coal-and-other-mineral-and-ore-merchant-wholesalers", industry_type: :industry, naics_code: "423520").first_or_create
    IndustryCode.where(name: "Electrical Apparatus and Equipment, Wiring Supplies, and Related Equipment Merchant Wholesalers", internal_name: "electrical-apparatus-and-equipment-wiring-supplies-and-related-equipment-merchant-wholesalers", industry_type: :industry, naics_code: "423610").first_or_create
    IndustryCode.where(name: "Household Appliances, Electric Housewares, and Consumer Electronics Merchant Wholesalers", internal_name: "household-appliances-electric-housewares-and-consumer-electronics-merchant-wholesalers", industry_type: :industry, naics_code: "423620").first_or_create
    IndustryCode.where(name: "Other Electronic Parts and Equipment Merchant Wholesalers", internal_name: "other-electronic-parts-and-equipment-merchant-wholesalers", industry_type: :industry, naics_code: "423690").first_or_create
    IndustryCode.where(name: "Hardware Merchant Wholesalers", internal_name: "hardware-merchant-wholesalers", industry_type: :industry, naics_code: "423710").first_or_create
    IndustryCode.where(name: "Plumbing and Heating Equipment and Supplies (Hydronics) Merchant Wholesalers", internal_name: "plumbing-and-heating-equipment-and-supplies-hydronics-merchant-wholesalers", industry_type: :industry, naics_code: "423720").first_or_create
    IndustryCode.where(name: "Warm Air Heating and Air-Conditioning Equipment and Supplies Merchant Wholesalers", internal_name: "warm-air-heating-and-air-conditioning-equipment-and-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "423730").first_or_create
    IndustryCode.where(name: "Refrigeration Equipment and Supplies Merchant Wholesalers", internal_name: "refrigeration-equipment-and-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "423740").first_or_create
    IndustryCode.where(name: "Construction and Mining (except Oil Well) Machinery and Equipment Merchant Wholesalers", internal_name: "construction-and-mining-except-oil-well-machinery-and-equipment-merchant-wholesalers", industry_type: :industry, naics_code: "423810").first_or_create
    IndustryCode.where(name: "Farm and Garden Machinery and Equipment Merchant Wholesalers", internal_name: "farm-and-garden-machinery-and-equipment-merchant-wholesalers", industry_type: :industry, naics_code: "423820").first_or_create
    IndustryCode.where(name: "Industrial Machinery and Equipment Merchant Wholesalers", internal_name: "industrial-machinery-and-equipment-merchant-wholesalers", industry_type: :industry, naics_code: "423830").first_or_create
    IndustryCode.where(name: "Industrial Supplies Merchant Wholesalers", internal_name: "industrial-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "423840").first_or_create
    IndustryCode.where(name: "Service Establishment Equipment and Supplies Merchant Wholesalers", internal_name: "service-establishment-equipment-and-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "423850").first_or_create
    IndustryCode.where(name: "Transportation Equipment and Supplies (except Motor Vehicle) Merchant Wholesalers", internal_name: "transportation-equipment-and-supplies-except-motor-vehicle-merchant-wholesalers", industry_type: :industry, naics_code: "423860").first_or_create
    IndustryCode.where(name: "Sporting and Recreational Goods and Supplies Merchant Wholesalers", internal_name: "sporting-and-recreational-goods-and-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "423910").first_or_create
    IndustryCode.where(name: "Toy and Hobby Goods and Supplies Merchant Wholesalers", internal_name: "toy-and-hobby-goods-and-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "423920").first_or_create
    IndustryCode.where(name: "Recyclable Material Merchant Wholesalers", internal_name: "recyclable-material-merchant-wholesalers", industry_type: :industry, naics_code: "423930").first_or_create
    IndustryCode.where(name: "Jewelry, Watch, Precious Stone, and Precious Metal Merchant Wholesalers", internal_name: "jewelry-watch-precious-stone-and-precious-metal-merchant-wholesalers", industry_type: :industry, naics_code: "423940").first_or_create
    IndustryCode.where(name: "Other Miscellaneous Durable Goods Merchant Wholesalers", internal_name: "other-miscellaneous-durable-goods-merchant-wholesalers", industry_type: :industry, naics_code: "423990").first_or_create
    IndustryCode.where(name: "Printing and Writing Paper Merchant Wholesalers", internal_name: "printing-and-writing-paper-merchant-wholesalers", industry_type: :industry, naics_code: "424110").first_or_create
    IndustryCode.where(name: "Stationery and Office Supplies Merchant Wholesalers", internal_name: "stationery-and-office-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "424120").first_or_create
    IndustryCode.where(name: "Industrial and Personal Service Paper Merchant Wholesalers", internal_name: "industrial-and-personal-service-paper-merchant-wholesalers", industry_type: :industry, naics_code: "424130").first_or_create
    IndustryCode.where(name: "Drugs and Druggists' Sundries Merchant Wholesalers", internal_name: "drugs-and-druggists'-sundries-merchant-wholesalers", industry_type: :industry, naics_code: "424210").first_or_create
    IndustryCode.where(name: "Piece Goods, Notions, and Other Dry Goods Merchant Wholesalers", internal_name: "piece-goods-notions-and-other-dry-goods-merchant-wholesalers", industry_type: :industry, naics_code: "424310").first_or_create
    IndustryCode.where(name: "Men's and Boys' Clothing and Furnishings Merchant Wholesalers", internal_name: "men's-and-boys'-clothing-and-furnishings-merchant-wholesalers", industry_type: :industry, naics_code: "424320").first_or_create
    IndustryCode.where(name: "Women's, Children's, and Infants' Clothing and Accessories Merchant Wholesalers", internal_name: "women's-children's-and-infants'-clothing-and-accessories-merchant-wholesalers", industry_type: :industry, naics_code: "424330").first_or_create
    IndustryCode.where(name: "Footwear Merchant Wholesalers", internal_name: "footwear-merchant-wholesalers", industry_type: :industry, naics_code: "424340").first_or_create
    IndustryCode.where(name: "General Line Grocery Merchant Wholesalers", internal_name: "general-line-grocery-merchant-wholesalers", industry_type: :industry, naics_code: "424410").first_or_create
    IndustryCode.where(name: "Packaged Frozen Food Merchant Wholesalers", internal_name: "packaged-frozen-food-merchant-wholesalers", industry_type: :industry, naics_code: "424420").first_or_create
    IndustryCode.where(name: "Dairy Product (except Dried or Canned) Merchant Wholesalers", internal_name: "dairy-product-except-dried-or-canned-merchant-wholesalers", industry_type: :industry, naics_code: "424430").first_or_create
    IndustryCode.where(name: "Poultry and Poultry Product Merchant Wholesalers", internal_name: "poultry-and-poultry-product-merchant-wholesalers", industry_type: :industry, naics_code: "424440").first_or_create
    IndustryCode.where(name: "Confectionery Merchant Wholesalers", internal_name: "confectionery-merchant-wholesalers", industry_type: :industry, naics_code: "424450").first_or_create
    IndustryCode.where(name: "Fish and Seafood Merchant Wholesalers", internal_name: "fish-and-seafood-merchant-wholesalers", industry_type: :industry, naics_code: "424460").first_or_create
    IndustryCode.where(name: "Meat and Meat Product Merchant Wholesalers", internal_name: "meat-and-meat-product-merchant-wholesalers", industry_type: :industry, naics_code: "424470").first_or_create
    IndustryCode.where(name: "Fresh Fruit and Vegetable Merchant Wholesalers", internal_name: "fresh-fruit-and-vegetable-merchant-wholesalers", industry_type: :industry, naics_code: "424480").first_or_create
    IndustryCode.where(name: "Other Grocery and Related Products Merchant Wholesalers", internal_name: "other-grocery-and-related-products-merchant-wholesalers", industry_type: :industry, naics_code: "424490").first_or_create
    IndustryCode.where(name: "Grain and Field Bean Merchant Wholesalers", internal_name: "grain-and-field-bean-merchant-wholesalers", industry_type: :industry, naics_code: "424510").first_or_create
    IndustryCode.where(name: "Livestock Merchant Wholesalers", internal_name: "livestock-merchant-wholesalers", industry_type: :industry, naics_code: "424520").first_or_create
    IndustryCode.where(name: "Other Farm Product Raw Material Merchant Wholesalers", internal_name: "other-farm-product-raw-material-merchant-wholesalers", industry_type: :industry, naics_code: "424590").first_or_create
    IndustryCode.where(name: "Plastics Materials and Basic Forms and Shapes Merchant Wholesalers", internal_name: "plastics-materials-and-basic-forms-and-shapes-merchant-wholesalers", industry_type: :industry, naics_code: "424610").first_or_create
    IndustryCode.where(name: "Other Chemical and Allied Products Merchant Wholesalers", internal_name: "other-chemical-and-allied-products-merchant-wholesalers", industry_type: :industry, naics_code: "424690").first_or_create
    IndustryCode.where(name: "Petroleum Bulk Stations and Terminals", internal_name: "petroleum-bulk-stations-and-terminals", industry_type: :industry, naics_code: "424710").first_or_create
    IndustryCode.where(name: "Petroleum and Petroleum Products Merchant Wholesalers (except Bulk Stations and Terminals)", internal_name: "petroleum-and-petroleum-products-merchant-wholesalers-except-bulk-stations-and-terminals", industry_type: :industry, naics_code: "424720").first_or_create
    IndustryCode.where(name: "Beer and Ale Merchant Wholesalers", internal_name: "beer-and-ale-merchant-wholesalers", industry_type: :industry, naics_code: "424810").first_or_create
    IndustryCode.where(name: "Wine and Distilled Alcoholic Beverage Merchant Wholesalers", internal_name: "wine-and-distilled-alcoholic-beverage-merchant-wholesalers", industry_type: :industry, naics_code: "424820").first_or_create
    IndustryCode.where(name: "Farm Supplies Merchant Wholesalers", internal_name: "farm-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "424910").first_or_create
    IndustryCode.where(name: "Book, Periodical, and Newspaper Merchant Wholesalers", internal_name: "book-periodical-and-newspaper-merchant-wholesalers", industry_type: :industry, naics_code: "424920").first_or_create
    IndustryCode.where(name: "Flower, Nursery Stock, and Florists' Supplies Merchant Wholesalers", internal_name: "flower-nursery-stock-and-florists'-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "424930").first_or_create
    IndustryCode.where(name: "Tobacco and Tobacco Product Merchant Wholesalers", internal_name: "tobacco-and-tobacco-product-merchant-wholesalers", industry_type: :industry, naics_code: "424940").first_or_create
    IndustryCode.where(name: "Paint, Varnish, and Supplies Merchant Wholesalers", internal_name: "paint-varnish-and-supplies-merchant-wholesalers", industry_type: :industry, naics_code: "424950").first_or_create
    IndustryCode.where(name: "Other Miscellaneous Nondurable Goods Merchant Wholesalers", internal_name: "other-miscellaneous-nondurable-goods-merchant-wholesalers", industry_type: :industry, naics_code: "424990").first_or_create
    IndustryCode.where(name: "Business to Business Electronic Markets", internal_name: "business-to-business-electronic-markets", industry_type: :industry, naics_code: "425110").first_or_create
    IndustryCode.where(name: "Wholesale Trade Agents and Brokers", internal_name: "wholesale-trade-agents-and-brokers", industry_type: :industry, naics_code: "425120").first_or_create
    IndustryCode.where(name: "New Car Dealers", internal_name: "new-car-dealers", industry_type: :industry, naics_code: "441110").first_or_create
    IndustryCode.where(name: "Used Car Dealers", internal_name: "used-car-dealers", industry_type: :industry, naics_code: "441120").first_or_create
    IndustryCode.where(name: "Recreational Vehicle Dealers", internal_name: "recreational-vehicle-dealers", industry_type: :industry, naics_code: "441210").first_or_create
    IndustryCode.where(name: "Boat Dealers", internal_name: "boat-dealers", industry_type: :industry, naics_code: "441222").first_or_create
    IndustryCode.where(name: "Motorcycle, ATV, and All Other Motor Vehicle Dealers", internal_name: "motorcycle-atv-and-all-other-motor-vehicle-dealers", industry_type: :industry, naics_code: "441228").first_or_create
    IndustryCode.where(name: "Automotive Parts and Accessories Stores", internal_name: "automotive-parts-and-accessories-stores", industry_type: :industry, naics_code: "441310").first_or_create
    IndustryCode.where(name: "Tire Dealers", internal_name: "tire-dealers", industry_type: :industry, naics_code: "441320").first_or_create
    IndustryCode.where(name: "Furniture Stores", internal_name: "furniture-stores", industry_type: :industry, naics_code: "442110").first_or_create
    IndustryCode.where(name: "Floor Covering Stores", internal_name: "floor-covering-stores", industry_type: :industry, naics_code: "442210").first_or_create
    IndustryCode.where(name: "Window Treatment Stores", internal_name: "window-treatment-stores", industry_type: :industry, naics_code: "442291").first_or_create
    IndustryCode.where(name: "All Other Home Furnishings Stores", internal_name: "all-other-home-furnishings-stores", industry_type: :industry, naics_code: "442299").first_or_create
    IndustryCode.where(name: "Household Appliance Stores", internal_name: "household-appliance-stores", industry_type: :industry, naics_code: "443141").first_or_create
    IndustryCode.where(name: "Electronics Stores", internal_name: "electronics-stores", industry_type: :industry, naics_code: "443142").first_or_create
    IndustryCode.where(name: "Home Centers", internal_name: "home-centers", industry_type: :industry, naics_code: "444110").first_or_create
    IndustryCode.where(name: "Paint and Wallpaper Stores", internal_name: "paint-and-wallpaper-stores", industry_type: :industry, naics_code: "444120").first_or_create
    IndustryCode.where(name: "Hardware Stores", internal_name: "hardware-stores", industry_type: :industry, naics_code: "444130").first_or_create
    IndustryCode.where(name: "Other Building Material Dealers", internal_name: "other-building-material-dealers", industry_type: :industry, naics_code: "444190").first_or_create
    IndustryCode.where(name: "Outdoor Power Equipment Stores", internal_name: "outdoor-power-equipment-stores", industry_type: :industry, naics_code: "444210").first_or_create
    IndustryCode.where(name: "Nursery, Garden Center, and Farm Supply Stores", internal_name: "nursery-garden-center-and-farm-supply-stores", industry_type: :industry, naics_code: "444220").first_or_create
    IndustryCode.where(name: "Supermarkets and Other Grocery (except Convenience) Stores", internal_name: "supermarkets-and-other-grocery-except-convenience-stores", industry_type: :industry, naics_code: "445110").first_or_create
    IndustryCode.where(name: "Convenience Stores", internal_name: "convenience-stores", industry_type: :industry, naics_code: "445120").first_or_create
    IndustryCode.where(name: "Meat Markets", internal_name: "meat-markets", industry_type: :industry, naics_code: "445210").first_or_create
    IndustryCode.where(name: "Fish and Seafood Markets", internal_name: "fish-and-seafood-markets", industry_type: :industry, naics_code: "445220").first_or_create
    IndustryCode.where(name: "Fruit and Vegetable Markets", internal_name: "fruit-and-vegetable-markets", industry_type: :industry, naics_code: "445230").first_or_create
    IndustryCode.where(name: "Baked Goods Stores", internal_name: "baked-goods-stores", industry_type: :industry, naics_code: "445291").first_or_create
    IndustryCode.where(name: "Confectionery and Nut Stores", internal_name: "confectionery-and-nut-stores", industry_type: :industry, naics_code: "445292").first_or_create
    IndustryCode.where(name: "All Other Specialty Food Stores", internal_name: "all-other-specialty-food-stores", industry_type: :industry, naics_code: "445299").first_or_create
    IndustryCode.where(name: "Beer, Wine, and Liquor Stores", internal_name: "beer-wine-and-liquor-stores", industry_type: :industry, naics_code: "445310").first_or_create
    IndustryCode.where(name: "Pharmacies and Drug Stores", internal_name: "pharmacies-and-drug-stores", industry_type: :industry, naics_code: "446110").first_or_create
    IndustryCode.where(name: "Cosmetics, Beauty Supplies, and Perfume Stores", internal_name: "cosmetics-beauty-supplies-and-perfume-stores", industry_type: :industry, naics_code: "446120").first_or_create
    IndustryCode.where(name: "Optical Goods Stores", internal_name: "optical-goods-stores", industry_type: :industry, naics_code: "446130").first_or_create
    IndustryCode.where(name: "Food (Health) Supplement Stores", internal_name: "food-health-supplement-stores", industry_type: :industry, naics_code: "446191").first_or_create
    IndustryCode.where(name: "All Other Health and Personal Care Stores", internal_name: "all-other-health-and-personal-care-stores", industry_type: :industry, naics_code: "446199").first_or_create
    IndustryCode.where(name: "Gasoline Stations with Convenience Stores", internal_name: "gasoline-stations-with-convenience-stores", industry_type: :industry, naics_code: "447110").first_or_create
    IndustryCode.where(name: "Other Gasoline Stations", internal_name: "other-gasoline-stations", industry_type: :industry, naics_code: "447190").first_or_create
    IndustryCode.where(name: "Men's Clothing Stores", internal_name: "men's-clothing-stores", industry_type: :industry, naics_code: "448110").first_or_create
    IndustryCode.where(name: "Women's Clothing Stores", internal_name: "women's-clothing-stores", industry_type: :industry, naics_code: "448120").first_or_create
    IndustryCode.where(name: "Children's and Infants' Clothing Stores", internal_name: "children's-and-infants'-clothing-stores", industry_type: :industry, naics_code: "448130").first_or_create
    IndustryCode.where(name: "Family Clothing Stores", internal_name: "family-clothing-stores", industry_type: :industry, naics_code: "448140").first_or_create
    IndustryCode.where(name: "Clothing Accessories Stores", internal_name: "clothing-accessories-stores", industry_type: :industry, naics_code: "448150").first_or_create
    IndustryCode.where(name: "Other Clothing Stores", internal_name: "other-clothing-stores", industry_type: :industry, naics_code: "448190").first_or_create
    IndustryCode.where(name: "Shoe Stores", internal_name: "shoe-stores", industry_type: :industry, naics_code: "448210").first_or_create
    IndustryCode.where(name: "Jewelry Stores", internal_name: "jewelry-stores", industry_type: :industry, naics_code: "448310").first_or_create
    IndustryCode.where(name: "Luggage and Leather Goods Stores", internal_name: "luggage-and-leather-goods-stores", industry_type: :industry, naics_code: "448320").first_or_create
    IndustryCode.where(name: "Sporting Goods Stores", internal_name: "sporting-goods-stores", industry_type: :industry, naics_code: "451110").first_or_create
    IndustryCode.where(name: "Hobby, Toy, and Game Stores", internal_name: "hobby-toy-and-game-stores", industry_type: :industry, naics_code: "451120").first_or_create
    IndustryCode.where(name: "Sewing, Needlework, and Piece Goods Stores", internal_name: "sewing-needlework-and-piece-goods-stores", industry_type: :industry, naics_code: "451130").first_or_create
    IndustryCode.where(name: "Musical Instrument and Supplies Stores", internal_name: "musical-instrument-and-supplies-stores", industry_type: :industry, naics_code: "451140").first_or_create
    IndustryCode.where(name: "Book Stores", internal_name: "book-stores", industry_type: :industry, naics_code: "451211").first_or_create
    IndustryCode.where(name: "News Dealers and Newsstands", internal_name: "news-dealers-and-newsstands", industry_type: :industry, naics_code: "451212").first_or_create
    IndustryCode.where(name: "Department Stores (except Discount Department Stores)", internal_name: "department-stores-except-discount-department-stores", industry_type: :industry, naics_code: "452111").first_or_create
    IndustryCode.where(name: "Discount Department Stores", internal_name: "discount-department-stores", industry_type: :industry, naics_code: "452112").first_or_create
    IndustryCode.where(name: "Warehouse Clubs and Supercenters", internal_name: "warehouse-clubs-and-supercenters", industry_type: :industry, naics_code: "452910").first_or_create
    IndustryCode.where(name: "All Other General Merchandise Stores", internal_name: "all-other-general-merchandise-stores", industry_type: :industry, naics_code: "452990").first_or_create
    IndustryCode.where(name: "Florists", internal_name: "florists", industry_type: :industry, naics_code: "453110").first_or_create
    IndustryCode.where(name: "Office Supplies and Stationery Stores", internal_name: "office-supplies-and-stationery-stores", industry_type: :industry, naics_code: "453210").first_or_create
    IndustryCode.where(name: "Gift, Novelty, and Souvenir Stores", internal_name: "gift-novelty-and-souvenir-stores", industry_type: :industry, naics_code: "453220").first_or_create
    IndustryCode.where(name: "Used Merchandise Stores", internal_name: "used-merchandise-stores", industry_type: :industry, naics_code: "453310").first_or_create
    IndustryCode.where(name: "Pet and Pet Supplies Stores", internal_name: "pet-and-pet-supplies-stores", industry_type: :industry, naics_code: "453910").first_or_create
    IndustryCode.where(name: "Art Dealers", internal_name: "art-dealers", industry_type: :industry, naics_code: "453920").first_or_create
    IndustryCode.where(name: "Manufactured (Mobile) Home Dealers", internal_name: "manufactured-mobile-home-dealers", industry_type: :industry, naics_code: "453930").first_or_create
    IndustryCode.where(name: "Tobacco Stores", internal_name: "tobacco-stores", industry_type: :industry, naics_code: "453991").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Store Retailers (except Tobacco Stores)", internal_name: "all-other-miscellaneous-store-retailers-except-tobacco-stores", industry_type: :industry, naics_code: "453998").first_or_create
    IndustryCode.where(name: "Electronic Shopping", internal_name: "electronic-shopping", industry_type: :industry, naics_code: "454111").first_or_create
    IndustryCode.where(name: "Electronic Auctions", internal_name: "electronic-auctions", industry_type: :industry, naics_code: "454112").first_or_create
    IndustryCode.where(name: "Mail-Order Houses", internal_name: "mail-order-houses", industry_type: :industry, naics_code: "454113").first_or_create
    IndustryCode.where(name: "Vending Machine Operators", internal_name: "vending-machine-operators", industry_type: :industry, naics_code: "454210").first_or_create
    IndustryCode.where(name: "Fuel Dealers", internal_name: "fuel-dealers", industry_type: :industry, naics_code: "454310").first_or_create
    IndustryCode.where(name: "Other Direct Selling Establishments", internal_name: "other-direct-selling-establishments", industry_type: :industry, naics_code: "454390").first_or_create
    IndustryCode.where(name: "Scheduled Passenger Air Transportation", internal_name: "scheduled-passenger-air-transportation", industry_type: :industry, naics_code: "481111").first_or_create
    IndustryCode.where(name: "Scheduled Freight Air Transportation", internal_name: "scheduled-freight-air-transportation", industry_type: :industry, naics_code: "481112").first_or_create
    IndustryCode.where(name: "Nonscheduled Chartered Passenger Air Transportation", internal_name: "nonscheduled-chartered-passenger-air-transportation", industry_type: :industry, naics_code: "481211").first_or_create
    IndustryCode.where(name: "Nonscheduled Chartered Freight Air Transportation", internal_name: "nonscheduled-chartered-freight-air-transportation", industry_type: :industry, naics_code: "481212").first_or_create
    IndustryCode.where(name: "Other Nonscheduled Air Transportation", internal_name: "other-nonscheduled-air-transportation", industry_type: :industry, naics_code: "481219").first_or_create
    IndustryCode.where(name: "Line-Haul Railroads", internal_name: "line-haul-railroads", industry_type: :industry, naics_code: "482111").first_or_create
    IndustryCode.where(name: "Short Line Railroads", internal_name: "short-line-railroads", industry_type: :industry, naics_code: "482112").first_or_create
    IndustryCode.where(name: "Deep Sea Freight Transportation", internal_name: "deep-sea-freight-transportation", industry_type: :industry, naics_code: "483111").first_or_create
    IndustryCode.where(name: "Deep Sea Passenger Transportation", internal_name: "deep-sea-passenger-transportation", industry_type: :industry, naics_code: "483112").first_or_create
    IndustryCode.where(name: "Coastal and Great Lakes Freight Transportation", internal_name: "coastal-and-great-lakes-freight-transportation", industry_type: :industry, naics_code: "483113").first_or_create
    IndustryCode.where(name: "Coastal and Great Lakes Passenger Transportation", internal_name: "coastal-and-great-lakes-passenger-transportation", industry_type: :industry, naics_code: "483114").first_or_create
    IndustryCode.where(name: "Inland Water Freight Transportation", internal_name: "inland-water-freight-transportation", industry_type: :industry, naics_code: "483211").first_or_create
    IndustryCode.where(name: "Inland Water Passenger Transportation", internal_name: "inland-water-passenger-transportation", industry_type: :industry, naics_code: "483212").first_or_create
    IndustryCode.where(name: "General Freight Trucking, Local", internal_name: "general-freight-trucking-local", industry_type: :industry, naics_code: "484110").first_or_create
    IndustryCode.where(name: "General Freight Trucking, Long-Distance, Truckload", internal_name: "general-freight-trucking-long-distance-truckload", industry_type: :industry, naics_code: "484121").first_or_create
    IndustryCode.where(name: "General Freight Trucking, Long-Distance, Less Than Truckload", internal_name: "general-freight-trucking-long-distance-less-than-truckload", industry_type: :industry, naics_code: "484122").first_or_create
    IndustryCode.where(name: "Used Household and Office Goods Moving", internal_name: "used-household-and-office-goods-moving", industry_type: :industry, naics_code: "484210").first_or_create
    IndustryCode.where(name: "Specialized Freight (except Used Goods) Trucking, Local", internal_name: "specialized-freight-except-used-goods-trucking-local", industry_type: :industry, naics_code: "484220").first_or_create
    IndustryCode.where(name: "Specialized Freight (except Used Goods) Trucking, Long-Distance", internal_name: "specialized-freight-except-used-goods-trucking-long-distance", industry_type: :industry, naics_code: "484230").first_or_create
    IndustryCode.where(name: "Mixed Mode Transit Systems", internal_name: "mixed-mode-transit-systems", industry_type: :industry, naics_code: "485111").first_or_create
    IndustryCode.where(name: "Commuter Rail Systems", internal_name: "commuter-rail-systems", industry_type: :industry, naics_code: "485112").first_or_create
    IndustryCode.where(name: "Bus and Other Motor Vehicle Transit Systems", internal_name: "bus-and-other-motor-vehicle-transit-systems", industry_type: :industry, naics_code: "485113").first_or_create
    IndustryCode.where(name: "Other Urban Transit Systems", internal_name: "other-urban-transit-systems", industry_type: :industry, naics_code: "485119").first_or_create
    IndustryCode.where(name: "Interurban and Rural Bus Transportation", internal_name: "interurban-and-rural-bus-transportation", industry_type: :industry, naics_code: "485210").first_or_create
    IndustryCode.where(name: "Taxi Service", internal_name: "taxi-service", industry_type: :industry, naics_code: "485310").first_or_create
    IndustryCode.where(name: "Limousine Service", internal_name: "limousine-service", industry_type: :industry, naics_code: "485320").first_or_create
    IndustryCode.where(name: "School and Employee Bus Transportation", internal_name: "school-and-employee-bus-transportation", industry_type: :industry, naics_code: "485410").first_or_create
    IndustryCode.where(name: "Charter Bus Industry", internal_name: "charter-bus-industry", industry_type: :industry, naics_code: "485510").first_or_create
    IndustryCode.where(name: "Special Needs Transportation", internal_name: "special-needs-transportation", industry_type: :industry, naics_code: "485991").first_or_create
    IndustryCode.where(name: "All Other Transit and Ground Passenger Transportation", internal_name: "all-other-transit-and-ground-passenger-transportation", industry_type: :industry, naics_code: "485999").first_or_create
    IndustryCode.where(name: "Pipeline Transportation of Crude Oil", internal_name: "pipeline-transportation-of-crude-oil", industry_type: :industry, naics_code: "486110").first_or_create
    IndustryCode.where(name: "Pipeline Transportation of Natural Gas", internal_name: "pipeline-transportation-of-natural-gas", industry_type: :industry, naics_code: "486210").first_or_create
    IndustryCode.where(name: "Pipeline Transportation of Refined Petroleum Products", internal_name: "pipeline-transportation-of-refined-petroleum-products", industry_type: :industry, naics_code: "486910").first_or_create
    IndustryCode.where(name: "All Other Pipeline Transportation", internal_name: "all-other-pipeline-transportation", industry_type: :industry, naics_code: "486990").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation, Land", internal_name: "scenic-and-sightseeing-transportation-land", industry_type: :industry, naics_code: "487110").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation, Water", internal_name: "scenic-and-sightseeing-transportation-water", industry_type: :industry, naics_code: "487210").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation, Other", internal_name: "scenic-and-sightseeing-transportation-other", industry_type: :industry, naics_code: "487990").first_or_create
    IndustryCode.where(name: "Air Traffic Control", internal_name: "air-traffic-control", industry_type: :industry, naics_code: "488111").first_or_create
    IndustryCode.where(name: "Other Airport Operations", internal_name: "other-airport-operations", industry_type: :industry, naics_code: "488119").first_or_create
    IndustryCode.where(name: "Other Support Activities for Air Transportation", internal_name: "other-support-activities-for-air-transportation", industry_type: :industry, naics_code: "488190").first_or_create
    IndustryCode.where(name: "Support Activities for Rail Transportation", internal_name: "support-activities-for-rail-transportation", industry_type: :industry, naics_code: "488210").first_or_create
    IndustryCode.where(name: "Port and Harbor Operations", internal_name: "port-and-harbor-operations", industry_type: :industry, naics_code: "488310").first_or_create
    IndustryCode.where(name: "Marine Cargo Handling", internal_name: "marine-cargo-handling", industry_type: :industry, naics_code: "488320").first_or_create
    IndustryCode.where(name: "Navigational Services to Shipping", internal_name: "navigational-services-to-shipping", industry_type: :industry, naics_code: "488330").first_or_create
    IndustryCode.where(name: "Other Support Activities for Water Transportation", internal_name: "other-support-activities-for-water-transportation", industry_type: :industry, naics_code: "488390").first_or_create
    IndustryCode.where(name: "Motor Vehicle Towing", internal_name: "motor-vehicle-towing", industry_type: :industry, naics_code: "488410").first_or_create
    IndustryCode.where(name: "Other Support Activities for Road Transportation", internal_name: "other-support-activities-for-road-transportation", industry_type: :industry, naics_code: "488490").first_or_create
    IndustryCode.where(name: "Freight Transportation Arrangement", internal_name: "freight-transportation-arrangement", industry_type: :industry, naics_code: "488510").first_or_create
    IndustryCode.where(name: "Packing and Crating", internal_name: "packing-and-crating", industry_type: :industry, naics_code: "488991").first_or_create
    IndustryCode.where(name: "All Other Support Activities for Transportation", internal_name: "all-other-support-activities-for-transportation", industry_type: :industry, naics_code: "488999").first_or_create
    IndustryCode.where(name: "Postal Service", internal_name: "postal-service", industry_type: :industry, naics_code: "491110").first_or_create
    IndustryCode.where(name: "Couriers and Express Delivery Services", internal_name: "couriers-and-express-delivery-services", industry_type: :industry, naics_code: "492110").first_or_create
    IndustryCode.where(name: "Local Messengers and Local Delivery", internal_name: "local-messengers-and-local-delivery", industry_type: :industry, naics_code: "492210").first_or_create
    IndustryCode.where(name: "General Warehousing and Storage", internal_name: "general-warehousing-and-storage", industry_type: :industry, naics_code: "493110").first_or_create
    IndustryCode.where(name: "Refrigerated Warehousing and Storage", internal_name: "refrigerated-warehousing-and-storage", industry_type: :industry, naics_code: "493120").first_or_create
    IndustryCode.where(name: "Farm Product Warehousing and Storage", internal_name: "farm-product-warehousing-and-storage", industry_type: :industry, naics_code: "493130").first_or_create
    IndustryCode.where(name: "Other Warehousing and Storage", internal_name: "other-warehousing-and-storage", industry_type: :industry, naics_code: "493190").first_or_create
    IndustryCode.where(name: "Newspaper Publishers", internal_name: "newspaper-publishers", industry_type: :industry, naics_code: "511110").first_or_create
    IndustryCode.where(name: "Periodical Publishers", internal_name: "periodical-publishers", industry_type: :industry, naics_code: "511120").first_or_create
    IndustryCode.where(name: "Book Publishers", internal_name: "book-publishers", industry_type: :industry, naics_code: "511130").first_or_create
    IndustryCode.where(name: "Directory and Mailing List Publishers", internal_name: "directory-and-mailing-list-publishers", industry_type: :industry, naics_code: "511140").first_or_create
    IndustryCode.where(name: "Greeting Card Publishers", internal_name: "greeting-card-publishers", industry_type: :industry, naics_code: "511191").first_or_create
    IndustryCode.where(name: "All Other Publishers", internal_name: "all-other-publishers", industry_type: :industry, naics_code: "511199").first_or_create
    IndustryCode.where(name: "Software Publishers", internal_name: "software-publishers", industry_type: :industry, naics_code: "511210").first_or_create
    IndustryCode.where(name: "Motion Picture and Video Production", internal_name: "motion-picture-and-video-production", industry_type: :industry, naics_code: "512110").first_or_create
    IndustryCode.where(name: "Motion Picture and Video Distribution", internal_name: "motion-picture-and-video-distribution", industry_type: :industry, naics_code: "512120").first_or_create
    IndustryCode.where(name: "Motion Picture Theaters (except Drive-Ins)", internal_name: "motion-picture-theaters-except-drive-ins", industry_type: :industry, naics_code: "512131").first_or_create
    IndustryCode.where(name: "Drive-In Motion Picture Theaters", internal_name: "drive-in-motion-picture-theaters", industry_type: :industry, naics_code: "512132").first_or_create
    IndustryCode.where(name: "Teleproduction and Other Postproduction Services", internal_name: "teleproduction-and-other-postproduction-services", industry_type: :industry, naics_code: "512191").first_or_create
    IndustryCode.where(name: "Other Motion Picture and Video Industries", internal_name: "other-motion-picture-and-video-industries", industry_type: :industry, naics_code: "512199").first_or_create
    IndustryCode.where(name: "Record Production", internal_name: "record-production", industry_type: :industry, naics_code: "512210").first_or_create
    IndustryCode.where(name: "Integrated Record Production/Distribution", internal_name: "integrated-record-production/distribution", industry_type: :industry, naics_code: "512220").first_or_create
    IndustryCode.where(name: "Music Publishers", internal_name: "music-publishers", industry_type: :industry, naics_code: "512230").first_or_create
    IndustryCode.where(name: "Sound Recording Studios", internal_name: "sound-recording-studios", industry_type: :industry, naics_code: "512240").first_or_create
    IndustryCode.where(name: "Other Sound Recording Industries", internal_name: "other-sound-recording-industries", industry_type: :industry, naics_code: "512290").first_or_create
    IndustryCode.where(name: "Radio Networks", internal_name: "radio-networks", industry_type: :industry, naics_code: "515111").first_or_create
    IndustryCode.where(name: "Radio Stations", internal_name: "radio-stations", industry_type: :industry, naics_code: "515112").first_or_create
    IndustryCode.where(name: "Television Broadcasting", internal_name: "television-broadcasting", industry_type: :industry, naics_code: "515120").first_or_create
    IndustryCode.where(name: "Cable and Other Subscription Programming", internal_name: "cable-and-other-subscription-programming", industry_type: :industry, naics_code: "515210").first_or_create
    IndustryCode.where(name: "Wired Telecommunications Carriers", internal_name: "wired-telecommunications-carriers", industry_type: :industry, naics_code: "517110").first_or_create
    IndustryCode.where(name: "Wireless Telecommunications Carriers (except Satellite)", internal_name: "wireless-telecommunications-carriers-except-satellite", industry_type: :industry, naics_code: "517210").first_or_create
    IndustryCode.where(name: "Satellite Telecommunications", internal_name: "satellite-telecommunications", industry_type: :industry, naics_code: "517410").first_or_create
    IndustryCode.where(name: "Telecommunications Resellers", internal_name: "telecommunications-resellers", industry_type: :industry, naics_code: "517911").first_or_create
    IndustryCode.where(name: "All Other Telecommunications", internal_name: "all-other-telecommunications", industry_type: :industry, naics_code: "517919").first_or_create
    IndustryCode.where(name: "Data Processing, Hosting, and Related Services", internal_name: "data-processing-hosting-and-related-services", industry_type: :industry, naics_code: "518210").first_or_create
    IndustryCode.where(name: "News Syndicates", internal_name: "news-syndicates", industry_type: :industry, naics_code: "519110").first_or_create
    IndustryCode.where(name: "Libraries and Archives", internal_name: "libraries-and-archives", industry_type: :industry, naics_code: "519120").first_or_create
    IndustryCode.where(name: "Internet Publishing and Broadcasting and Web Search Portals", internal_name: "internet-publishing-and-broadcasting-and-web-search-portals", industry_type: :industry, naics_code: "519130").first_or_create
    IndustryCode.where(name: "All Other Information Services", internal_name: "all-other-information-services", industry_type: :industry, naics_code: "519190").first_or_create
    IndustryCode.where(name: "Monetary Authorities-Central Bank", internal_name: "monetary-authorities-central-bank", industry_type: :industry, naics_code: "521110").first_or_create
    IndustryCode.where(name: "Commercial Banking", internal_name: "commercial-banking", industry_type: :industry, naics_code: "522110").first_or_create
    IndustryCode.where(name: "Savings Institutions", internal_name: "savings-institutions", industry_type: :industry, naics_code: "522120").first_or_create
    IndustryCode.where(name: "Credit Unions", internal_name: "credit-unions", industry_type: :industry, naics_code: "522130").first_or_create
    IndustryCode.where(name: "Other Depository Credit Intermediation", internal_name: "other-depository-credit-intermediation", industry_type: :industry, naics_code: "522190").first_or_create
    IndustryCode.where(name: "Credit Card Issuing", internal_name: "credit-card-issuing", industry_type: :industry, naics_code: "522210").first_or_create
    IndustryCode.where(name: "Sales Financing", internal_name: "sales-financing", industry_type: :industry, naics_code: "522220").first_or_create
    IndustryCode.where(name: "Consumer Lending", internal_name: "consumer-lending", industry_type: :industry, naics_code: "522291").first_or_create
    IndustryCode.where(name: "Real Estate Credit", internal_name: "real-estate-credit", industry_type: :industry, naics_code: "522292").first_or_create
    IndustryCode.where(name: "International Trade Financing", internal_name: "international-trade-financing", industry_type: :industry, naics_code: "522293").first_or_create
    IndustryCode.where(name: "Secondary Market Financing", internal_name: "secondary-market-financing", industry_type: :industry, naics_code: "522294").first_or_create
    IndustryCode.where(name: "All Other Nondepository Credit Intermediation", internal_name: "all-other-nondepository-credit-intermediation", industry_type: :industry, naics_code: "522298").first_or_create
    IndustryCode.where(name: "Mortgage and Nonmortgage Loan Brokers", internal_name: "mortgage-and-nonmortgage-loan-brokers", industry_type: :industry, naics_code: "522310").first_or_create
    IndustryCode.where(name: "Financial Transactions Processing, Reserve, and Clearinghouse Activities", internal_name: "financial-transactions-processing-reserve-and-clearinghouse-activities", industry_type: :industry, naics_code: "522320").first_or_create
    IndustryCode.where(name: "Other Activities Related to Credit Intermediation", internal_name: "other-activities-related-to-credit-intermediation", industry_type: :industry, naics_code: "522390").first_or_create
    IndustryCode.where(name: "Investment Banking and Securities Dealing", internal_name: "investment-banking-and-securities-dealing", industry_type: :industry, naics_code: "523110").first_or_create
    IndustryCode.where(name: "Securities Brokerage", internal_name: "securities-brokerage", industry_type: :industry, naics_code: "523120").first_or_create
    IndustryCode.where(name: "Commodity Contracts Dealing", internal_name: "commodity-contracts-dealing", industry_type: :industry, naics_code: "523130").first_or_create
    IndustryCode.where(name: "Commodity Contracts Brokerage", internal_name: "commodity-contracts-brokerage", industry_type: :industry, naics_code: "523140").first_or_create
    IndustryCode.where(name: "Securities and Commodity Exchanges", internal_name: "securities-and-commodity-exchanges", industry_type: :industry, naics_code: "523210").first_or_create
    IndustryCode.where(name: "Miscellaneous Intermediation", internal_name: "miscellaneous-intermediation", industry_type: :industry, naics_code: "523910").first_or_create
    IndustryCode.where(name: "Portfolio Management", internal_name: "portfolio-management", industry_type: :industry, naics_code: "523920").first_or_create
    IndustryCode.where(name: "Investment Advice", internal_name: "investment-advice", industry_type: :industry, naics_code: "523930").first_or_create
    IndustryCode.where(name: "Trust, Fiduciary, and Custody Activities", internal_name: "trust-fiduciary-and-custody-activities", industry_type: :industry, naics_code: "523991").first_or_create
    IndustryCode.where(name: "Miscellaneous Financial Investment Activities", internal_name: "miscellaneous-financial-investment-activities", industry_type: :industry, naics_code: "523999").first_or_create
    IndustryCode.where(name: "Direct Life Insurance Carriers", internal_name: "direct-life-insurance-carriers", industry_type: :industry, naics_code: "524113").first_or_create
    IndustryCode.where(name: "Direct Health and Medical Insurance Carriers", internal_name: "direct-health-and-medical-insurance-carriers", industry_type: :industry, naics_code: "524114").first_or_create
    IndustryCode.where(name: "Direct Property and Casualty Insurance Carriers", internal_name: "direct-property-and-casualty-insurance-carriers", industry_type: :industry, naics_code: "524126").first_or_create
    IndustryCode.where(name: "Direct Title Insurance Carriers", internal_name: "direct-title-insurance-carriers", industry_type: :industry, naics_code: "524127").first_or_create
    IndustryCode.where(name: "Other Direct Insurance (except Life, Health, and Medical) Carriers", internal_name: "other-direct-insurance-except-life-health-and-medical-carriers", industry_type: :industry, naics_code: "524128").first_or_create
    IndustryCode.where(name: "Reinsurance Carriers", internal_name: "reinsurance-carriers", industry_type: :industry, naics_code: "524130").first_or_create
    IndustryCode.where(name: "Insurance Agencies and Brokerages", internal_name: "insurance-agencies-and-brokerages", industry_type: :industry, naics_code: "524210").first_or_create
    IndustryCode.where(name: "Claims Adjusting", internal_name: "claims-adjusting", industry_type: :industry, naics_code: "524291").first_or_create
    IndustryCode.where(name: "Third Party Administration of Insurance and Pension Funds", internal_name: "third-party-administration-of-insurance-and-pension-funds", industry_type: :industry, naics_code: "524292").first_or_create
    IndustryCode.where(name: "All Other Insurance Related Activities", internal_name: "all-other-insurance-related-activities", industry_type: :industry, naics_code: "524298").first_or_create
    IndustryCode.where(name: "Pension Funds", internal_name: "pension-funds", industry_type: :industry, naics_code: "525110").first_or_create
    IndustryCode.where(name: "Health and Welfare Funds", internal_name: "health-and-welfare-funds", industry_type: :industry, naics_code: "525120").first_or_create
    IndustryCode.where(name: "Other Insurance Funds", internal_name: "other-insurance-funds", industry_type: :industry, naics_code: "525190").first_or_create
    IndustryCode.where(name: "Open-End Investment Funds", internal_name: "open-end-investment-funds", industry_type: :industry, naics_code: "525910").first_or_create
    IndustryCode.where(name: "Trusts, Estates, and Agency Accounts", internal_name: "trusts-estates-and-agency-accounts", industry_type: :industry, naics_code: "525920").first_or_create
    IndustryCode.where(name: "Other Financial Vehicles", internal_name: "other-financial-vehicles", industry_type: :industry, naics_code: "525990").first_or_create
    IndustryCode.where(name: "Lessors of Residential Buildings and Dwellings", internal_name: "lessors-of-residential-buildings-and-dwellings", industry_type: :industry, naics_code: "531110").first_or_create
    IndustryCode.where(name: "Lessors of Nonresidential Buildings (except Miniwarehouses)", internal_name: "lessors-of-nonresidential-buildings-except-miniwarehouses", industry_type: :industry, naics_code: "531120").first_or_create
    IndustryCode.where(name: "Lessors of Miniwarehouses and Self-Storage Units", internal_name: "lessors-of-miniwarehouses-and-self-storage-units", industry_type: :industry, naics_code: "531130").first_or_create
    IndustryCode.where(name: "Lessors of Other Real Estate Property", internal_name: "lessors-of-other-real-estate-property", industry_type: :industry, naics_code: "531190").first_or_create
    IndustryCode.where(name: "Offices of Real Estate Agents and Brokers", internal_name: "offices-of-real-estate-agents-and-brokers", industry_type: :industry, naics_code: "531210").first_or_create
    IndustryCode.where(name: "Residential Property Managers", internal_name: "residential-property-managers", industry_type: :industry, naics_code: "531311").first_or_create
    IndustryCode.where(name: "Nonresidential Property Managers", internal_name: "nonresidential-property-managers", industry_type: :industry, naics_code: "531312").first_or_create
    IndustryCode.where(name: "Offices of Real Estate Appraisers", internal_name: "offices-of-real-estate-appraisers", industry_type: :industry, naics_code: "531320").first_or_create
    IndustryCode.where(name: "Other Activities Related to Real Estate", internal_name: "other-activities-related-to-real-estate", industry_type: :industry, naics_code: "531390").first_or_create
    IndustryCode.where(name: "Passenger Car Rental", internal_name: "passenger-car-rental", industry_type: :industry, naics_code: "532111").first_or_create
    IndustryCode.where(name: "Passenger Car Leasing", internal_name: "passenger-car-leasing", industry_type: :industry, naics_code: "532112").first_or_create
    IndustryCode.where(name: "Truck, Utility Trailer, and RV (Recreational Vehicle) Rental and Leasing", internal_name: "truck-utility-trailer-and-rv-recreational-vehicle-rental-and-leasing", industry_type: :industry, naics_code: "532120").first_or_create
    IndustryCode.where(name: "Consumer Electronics and Appliances Rental", internal_name: "consumer-electronics-and-appliances-rental", industry_type: :industry, naics_code: "532210").first_or_create
    IndustryCode.where(name: "Formal Wear and Costume Rental", internal_name: "formal-wear-and-costume-rental", industry_type: :industry, naics_code: "532220").first_or_create
    IndustryCode.where(name: "Video Tape and Disc Rental", internal_name: "video-tape-and-disc-rental", industry_type: :industry, naics_code: "532230").first_or_create
    IndustryCode.where(name: "Home Health Equipment Rental", internal_name: "home-health-equipment-rental", industry_type: :industry, naics_code: "532291").first_or_create
    IndustryCode.where(name: "Recreational Goods Rental", internal_name: "recreational-goods-rental", industry_type: :industry, naics_code: "532292").first_or_create
    IndustryCode.where(name: "All Other Consumer Goods Rental", internal_name: "all-other-consumer-goods-rental", industry_type: :industry, naics_code: "532299").first_or_create
    IndustryCode.where(name: "General Rental Centers", internal_name: "general-rental-centers", industry_type: :industry, naics_code: "532310").first_or_create
    IndustryCode.where(name: "Commercial Air, Rail, and Water Transportation Equipment Rental and Leasing", internal_name: "commercial-air-rail-and-water-transportation-equipment-rental-and-leasing", industry_type: :industry, naics_code: "532411").first_or_create
    IndustryCode.where(name: "Construction, Mining, and Forestry Machinery and Equipment Rental and Leasing", internal_name: "construction-mining-and-forestry-machinery-and-equipment-rental-and-leasing", industry_type: :industry, naics_code: "532412").first_or_create
    IndustryCode.where(name: "Office Machinery and Equipment Rental and Leasing", internal_name: "office-machinery-and-equipment-rental-and-leasing", industry_type: :industry, naics_code: "532420").first_or_create
    IndustryCode.where(name: "Other Commercial and Industrial Machinery and Equipment Rental and Leasing", internal_name: "other-commercial-and-industrial-machinery-and-equipment-rental-and-leasing", industry_type: :industry, naics_code: "532490").first_or_create
    IndustryCode.where(name: "Lessors of Nonfinancial Intangible Assets (except Copyrighted Works)", internal_name: "lessors-of-nonfinancial-intangible-assets-except-copyrighted-works", industry_type: :industry, naics_code: "533110").first_or_create
    IndustryCode.where(name: "Offices of Lawyers", internal_name: "offices-of-lawyers", industry_type: :industry, naics_code: "541110").first_or_create
    IndustryCode.where(name: "Offices of Notaries", internal_name: "offices-of-notaries", industry_type: :industry, naics_code: "541120").first_or_create
    IndustryCode.where(name: "Title Abstract and Settlement Offices", internal_name: "title-abstract-and-settlement-offices", industry_type: :industry, naics_code: "541191").first_or_create
    IndustryCode.where(name: "All Other Legal Services", internal_name: "all-other-legal-services", industry_type: :industry, naics_code: "541199").first_or_create
    IndustryCode.where(name: "Offices of Certified Public Accountants", internal_name: "offices-of-certified-public-accountants", industry_type: :industry, naics_code: "541211").first_or_create
    IndustryCode.where(name: "Tax Preparation Services", internal_name: "tax-preparation-services", industry_type: :industry, naics_code: "541213").first_or_create
    IndustryCode.where(name: "Payroll Services", internal_name: "payroll-services", industry_type: :industry, naics_code: "541214").first_or_create
    IndustryCode.where(name: "Other Accounting Services", internal_name: "other-accounting-services", industry_type: :industry, naics_code: "541219").first_or_create
    IndustryCode.where(name: "Architectural Services", internal_name: "architectural-services", industry_type: :industry, naics_code: "541310").first_or_create
    IndustryCode.where(name: "Landscape Architectural Services", internal_name: "landscape-architectural-services", industry_type: :industry, naics_code: "541320").first_or_create
    IndustryCode.where(name: "Engineering Services", internal_name: "engineering-services", industry_type: :industry, naics_code: "541330").first_or_create
    IndustryCode.where(name: "Drafting Services", internal_name: "drafting-services", industry_type: :industry, naics_code: "541340").first_or_create
    IndustryCode.where(name: "Building Inspection Services", internal_name: "building-inspection-services", industry_type: :industry, naics_code: "541350").first_or_create
    IndustryCode.where(name: "Geophysical Surveying and Mapping Services", internal_name: "geophysical-surveying-and-mapping-services", industry_type: :industry, naics_code: "541360").first_or_create
    IndustryCode.where(name: "Surveying and Mapping (except Geophysical) Services", internal_name: "surveying-and-mapping-except-geophysical-services", industry_type: :industry, naics_code: "541370").first_or_create
    IndustryCode.where(name: "Testing Laboratories", internal_name: "testing-laboratories", industry_type: :industry, naics_code: "541380").first_or_create
    IndustryCode.where(name: "Interior Design Services", internal_name: "interior-design-services", industry_type: :industry, naics_code: "541410").first_or_create
    IndustryCode.where(name: "Industrial Design Services", internal_name: "industrial-design-services", industry_type: :industry, naics_code: "541420").first_or_create
    IndustryCode.where(name: "Graphic Design Services", internal_name: "graphic-design-services", industry_type: :industry, naics_code: "541430").first_or_create
    IndustryCode.where(name: "Other Specialized Design Services", internal_name: "other-specialized-design-services", industry_type: :industry, naics_code: "541490").first_or_create
    IndustryCode.where(name: "Custom Computer Programming Services", internal_name: "custom-computer-programming-services", industry_type: :industry, naics_code: "541511").first_or_create
    IndustryCode.where(name: "Computer Systems Design Services", internal_name: "computer-systems-design-services", industry_type: :industry, naics_code: "541512").first_or_create
    IndustryCode.where(name: "Computer Facilities Management Services", internal_name: "computer-facilities-management-services", industry_type: :industry, naics_code: "541513").first_or_create
    IndustryCode.where(name: "Other Computer Related Services", internal_name: "other-computer-related-services", industry_type: :industry, naics_code: "541519").first_or_create
    IndustryCode.where(name: "Administrative Management and General Management Consulting Services", internal_name: "administrative-management-and-general-management-consulting-services", industry_type: :industry, naics_code: "541611").first_or_create
    IndustryCode.where(name: "Human Resources Consulting Services", internal_name: "human-resources-consulting-services", industry_type: :industry, naics_code: "541612").first_or_create
    IndustryCode.where(name: "Marketing Consulting Services", internal_name: "marketing-consulting-services", industry_type: :industry, naics_code: "541613").first_or_create
    IndustryCode.where(name: "Process, Physical Distribution, and Logistics Consulting Services", internal_name: "process-physical-distribution-and-logistics-consulting-services", industry_type: :industry, naics_code: "541614").first_or_create
    IndustryCode.where(name: "Other Management Consulting Services", internal_name: "other-management-consulting-services", industry_type: :industry, naics_code: "541618").first_or_create
    IndustryCode.where(name: "Environmental Consulting Services", internal_name: "environmental-consulting-services", industry_type: :industry, naics_code: "541620").first_or_create
    IndustryCode.where(name: "Other Scientific and Technical Consulting Services", internal_name: "other-scientific-and-technical-consulting-services", industry_type: :industry, naics_code: "541690").first_or_create
    IndustryCode.where(name: "Research and Development in Biotechnology", internal_name: "research-and-development-in-biotechnology", industry_type: :industry, naics_code: "541711").first_or_create
    IndustryCode.where(name: "Research and Development in the Physical, Engineering, and Life Sciences (except Biotechnology)", internal_name: "research-and-development-in-the-physical-engineering-and-life-sciences-except-biotechnology", industry_type: :industry, naics_code: "541712").first_or_create
    IndustryCode.where(name: "Research and Development in the Social Sciences and Humanities", internal_name: "research-and-development-in-the-social-sciences-and-humanities", industry_type: :industry, naics_code: "541720").first_or_create
    IndustryCode.where(name: "Advertising Agencies", internal_name: "advertising-agencies", industry_type: :industry, naics_code: "541810").first_or_create
    IndustryCode.where(name: "Public Relations Agencies", internal_name: "public-relations-agencies", industry_type: :industry, naics_code: "541820").first_or_create
    IndustryCode.where(name: "Media Buying Agencies", internal_name: "media-buying-agencies", industry_type: :industry, naics_code: "541830").first_or_create
    IndustryCode.where(name: "Media Representatives", internal_name: "media-representatives", industry_type: :industry, naics_code: "541840").first_or_create
    IndustryCode.where(name: "Outdoor Advertising", internal_name: "outdoor-advertising", industry_type: :industry, naics_code: "541850").first_or_create
    IndustryCode.where(name: "Direct Mail Advertising", internal_name: "direct-mail-advertising", industry_type: :industry, naics_code: "541860").first_or_create
    IndustryCode.where(name: "Advertising Material Distribution Services", internal_name: "advertising-material-distribution-services", industry_type: :industry, naics_code: "541870").first_or_create
    IndustryCode.where(name: "Other Services Related to Advertising", internal_name: "other-services-related-to-advertising", industry_type: :industry, naics_code: "541890").first_or_create
    IndustryCode.where(name: "Marketing Research and Public Opinion Polling", internal_name: "marketing-research-and-public-opinion-polling", industry_type: :industry, naics_code: "541910").first_or_create
    IndustryCode.where(name: "Photography Studios, Portrait", internal_name: "photography-studios-portrait", industry_type: :industry, naics_code: "541921").first_or_create
    IndustryCode.where(name: "Commercial Photography", internal_name: "commercial-photography", industry_type: :industry, naics_code: "541922").first_or_create
    IndustryCode.where(name: "Translation and Interpretation Services", internal_name: "translation-and-interpretation-services", industry_type: :industry, naics_code: "541930").first_or_create
    IndustryCode.where(name: "Veterinary Services", internal_name: "veterinary-services", industry_type: :industry, naics_code: "541940").first_or_create
    IndustryCode.where(name: "All Other Professional, Scientific, and Technical Services", internal_name: "all-other-professional-scientific-and-technical-services", industry_type: :industry, naics_code: "541990").first_or_create
    IndustryCode.where(name: "Offices of Bank Holding Companies", internal_name: "offices-of-bank-holding-companies", industry_type: :industry, naics_code: "551111").first_or_create
    IndustryCode.where(name: "Offices of Other Holding Companies", internal_name: "offices-of-other-holding-companies", industry_type: :industry, naics_code: "551112").first_or_create
    IndustryCode.where(name: "Corporate, Subsidiary, and Regional Managing Offices", internal_name: "corporate-subsidiary-and-regional-managing-offices", industry_type: :industry, naics_code: "551114").first_or_create
    IndustryCode.where(name: "Office Administrative Services", internal_name: "office-administrative-services", industry_type: :industry, naics_code: "561110").first_or_create
    IndustryCode.where(name: "Facilities Support Services", internal_name: "facilities-support-services", industry_type: :industry, naics_code: "561210").first_or_create
    IndustryCode.where(name: "Employment Placement Agencies", internal_name: "employment-placement-agencies", industry_type: :industry, naics_code: "561311").first_or_create
    IndustryCode.where(name: "Executive Search Services", internal_name: "executive-search-services", industry_type: :industry, naics_code: "561312").first_or_create
    IndustryCode.where(name: "Temporary Help Services", internal_name: "temporary-help-services", industry_type: :industry, naics_code: "561320").first_or_create
    IndustryCode.where(name: "Professional Employer Organizations", internal_name: "professional-employer-organizations", industry_type: :industry, naics_code: "561330").first_or_create
    IndustryCode.where(name: "Document Preparation Services", internal_name: "document-preparation-services", industry_type: :industry, naics_code: "561410").first_or_create
    IndustryCode.where(name: "Telephone Answering Services", internal_name: "telephone-answering-services", industry_type: :industry, naics_code: "561421").first_or_create
    IndustryCode.where(name: "Telemarketing Bureaus and Other Contact Centers", internal_name: "telemarketing-bureaus-and-other-contact-centers", industry_type: :industry, naics_code: "561422").first_or_create
    IndustryCode.where(name: "Private Mail Centers", internal_name: "private-mail-centers", industry_type: :industry, naics_code: "561431").first_or_create
    IndustryCode.where(name: "Other Business Service Centers (including Copy Shops)", internal_name: "other-business-service-centers-including-copy-shops", industry_type: :industry, naics_code: "561439").first_or_create
    IndustryCode.where(name: "Collection Agencies", internal_name: "collection-agencies", industry_type: :industry, naics_code: "561440").first_or_create
    IndustryCode.where(name: "Credit Bureaus", internal_name: "credit-bureaus", industry_type: :industry, naics_code: "561450").first_or_create
    IndustryCode.where(name: "Repossession Services", internal_name: "repossession-services", industry_type: :industry, naics_code: "561491").first_or_create
    IndustryCode.where(name: "Court Reporting and Stenotype Services", internal_name: "court-reporting-and-stenotype-services", industry_type: :industry, naics_code: "561492").first_or_create
    IndustryCode.where(name: "All Other Business Support Services", internal_name: "all-other-business-support-services", industry_type: :industry, naics_code: "561499").first_or_create
    IndustryCode.where(name: "Travel Agencies", internal_name: "travel-agencies", industry_type: :industry, naics_code: "561510").first_or_create
    IndustryCode.where(name: "Tour Operators", internal_name: "tour-operators", industry_type: :industry, naics_code: "561520").first_or_create
    IndustryCode.where(name: "Convention and Visitors Bureaus", internal_name: "convention-and-visitors-bureaus", industry_type: :industry, naics_code: "561591").first_or_create
    IndustryCode.where(name: "All Other Travel Arrangement and Reservation Services", internal_name: "all-other-travel-arrangement-and-reservation-services", industry_type: :industry, naics_code: "561599").first_or_create
    IndustryCode.where(name: "Investigation Services", internal_name: "investigation-services", industry_type: :industry, naics_code: "561611").first_or_create
    IndustryCode.where(name: "Security Guards and Patrol Services", internal_name: "security-guards-and-patrol-services", industry_type: :industry, naics_code: "561612").first_or_create
    IndustryCode.where(name: "Armored Car Services", internal_name: "armored-car-services", industry_type: :industry, naics_code: "561613").first_or_create
    IndustryCode.where(name: "Security Systems Services (except Locksmiths)", internal_name: "security-systems-services-except-locksmiths", industry_type: :industry, naics_code: "561621").first_or_create
    IndustryCode.where(name: "Locksmiths", internal_name: "locksmiths", industry_type: :industry, naics_code: "561622").first_or_create
    IndustryCode.where(name: "Exterminating and Pest Control Services", internal_name: "exterminating-and-pest-control-services", industry_type: :industry, naics_code: "561710").first_or_create
    IndustryCode.where(name: "Janitorial Services", internal_name: "janitorial-services", industry_type: :industry, naics_code: "561720").first_or_create
    IndustryCode.where(name: "Landscaping Services", internal_name: "landscaping-services", industry_type: :industry, naics_code: "561730").first_or_create
    IndustryCode.where(name: "Carpet and Upholstery Cleaning Services", internal_name: "carpet-and-upholstery-cleaning-services", industry_type: :industry, naics_code: "561740").first_or_create
    IndustryCode.where(name: "Other Services to Buildings and Dwellings", internal_name: "other-services-to-buildings-and-dwellings", industry_type: :industry, naics_code: "561790").first_or_create
    IndustryCode.where(name: "Packaging and Labeling Services", internal_name: "packaging-and-labeling-services", industry_type: :industry, naics_code: "561910").first_or_create
    IndustryCode.where(name: "Convention and Trade Show Organizers", internal_name: "convention-and-trade-show-organizers", industry_type: :industry, naics_code: "561920").first_or_create
    IndustryCode.where(name: "All Other Support Services", internal_name: "all-other-support-services", industry_type: :industry, naics_code: "561990").first_or_create
    IndustryCode.where(name: "Solid Waste Collection", internal_name: "solid-waste-collection", industry_type: :industry, naics_code: "562111").first_or_create
    IndustryCode.where(name: "Hazardous Waste Collection", internal_name: "hazardous-waste-collection", industry_type: :industry, naics_code: "562112").first_or_create
    IndustryCode.where(name: "Other Waste Collection", internal_name: "other-waste-collection", industry_type: :industry, naics_code: "562119").first_or_create
    IndustryCode.where(name: "Hazardous Waste Treatment and Disposal", internal_name: "hazardous-waste-treatment-and-disposal", industry_type: :industry, naics_code: "562211").first_or_create
    IndustryCode.where(name: "Solid Waste Landfill", internal_name: "solid-waste-landfill", industry_type: :industry, naics_code: "562212").first_or_create
    IndustryCode.where(name: "Solid Waste Combustors and Incinerators", internal_name: "solid-waste-combustors-and-incinerators", industry_type: :industry, naics_code: "562213").first_or_create
    IndustryCode.where(name: "Other Nonhazardous Waste Treatment and Disposal", internal_name: "other-nonhazardous-waste-treatment-and-disposal", industry_type: :industry, naics_code: "562219").first_or_create
    IndustryCode.where(name: "Remediation Services", internal_name: "remediation-services", industry_type: :industry, naics_code: "562910").first_or_create
    IndustryCode.where(name: "Materials Recovery Facilities", internal_name: "materials-recovery-facilities", industry_type: :industry, naics_code: "562920").first_or_create
    IndustryCode.where(name: "Septic Tank and Related Services", internal_name: "septic-tank-and-related-services", industry_type: :industry, naics_code: "562991").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Waste Management Services", internal_name: "all-other-miscellaneous-waste-management-services", industry_type: :industry, naics_code: "562998").first_or_create
    IndustryCode.where(name: "Elementary and Secondary Schools", internal_name: "elementary-and-secondary-schools", industry_type: :industry, naics_code: "611110").first_or_create
    IndustryCode.where(name: "Junior Colleges", internal_name: "junior-colleges", industry_type: :industry, naics_code: "611210").first_or_create
    IndustryCode.where(name: "Colleges, Universities, and Professional Schools", internal_name: "colleges-universities-and-professional-schools", industry_type: :industry, naics_code: "611310").first_or_create
    IndustryCode.where(name: "Business and Secretarial Schools", internal_name: "business-and-secretarial-schools", industry_type: :industry, naics_code: "611410").first_or_create
    IndustryCode.where(name: "Computer Training", internal_name: "computer-training", industry_type: :industry, naics_code: "611420").first_or_create
    IndustryCode.where(name: "Professional and Management Development Training", internal_name: "professional-and-management-development-training", industry_type: :industry, naics_code: "611430").first_or_create
    IndustryCode.where(name: "Cosmetology and Barber Schools", internal_name: "cosmetology-and-barber-schools", industry_type: :industry, naics_code: "611511").first_or_create
    IndustryCode.where(name: "Flight Training", internal_name: "flight-training", industry_type: :industry, naics_code: "611512").first_or_create
    IndustryCode.where(name: "Apprenticeship Training", internal_name: "apprenticeship-training", industry_type: :industry, naics_code: "611513").first_or_create
    IndustryCode.where(name: "Other Technical and Trade Schools", internal_name: "other-technical-and-trade-schools", industry_type: :industry, naics_code: "611519").first_or_create
    IndustryCode.where(name: "Fine Arts Schools", internal_name: "fine-arts-schools", industry_type: :industry, naics_code: "611610").first_or_create
    IndustryCode.where(name: "Sports and Recreation Instruction", internal_name: "sports-and-recreation-instruction", industry_type: :industry, naics_code: "611620").first_or_create
    IndustryCode.where(name: "Language Schools", internal_name: "language-schools", industry_type: :industry, naics_code: "611630").first_or_create
    IndustryCode.where(name: "Exam Preparation and Tutoring", internal_name: "exam-preparation-and-tutoring", industry_type: :industry, naics_code: "611691").first_or_create
    IndustryCode.where(name: "Automobile Driving Schools", internal_name: "automobile-driving-schools", industry_type: :industry, naics_code: "611692").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Schools and Instruction", internal_name: "all-other-miscellaneous-schools-and-instruction", industry_type: :industry, naics_code: "611699").first_or_create
    IndustryCode.where(name: "Educational Support Services", internal_name: "educational-support-services", industry_type: :industry, naics_code: "611710").first_or_create
    IndustryCode.where(name: "Offices of Physicians (except Mental Health Specialists)", internal_name: "offices-of-physicians-except-mental-health-specialists", industry_type: :industry, naics_code: "621111").first_or_create
    IndustryCode.where(name: "Offices of Physicians, Mental Health Specialists", internal_name: "offices-of-physicians-mental-health-specialists", industry_type: :industry, naics_code: "621112").first_or_create
    IndustryCode.where(name: "Offices of Dentists", internal_name: "offices-of-dentists", industry_type: :industry, naics_code: "621210").first_or_create
    IndustryCode.where(name: "Offices of Chiropractors", internal_name: "offices-of-chiropractors", industry_type: :industry, naics_code: "621310").first_or_create
    IndustryCode.where(name: "Offices of Optometrists", internal_name: "offices-of-optometrists", industry_type: :industry, naics_code: "621320").first_or_create
    IndustryCode.where(name: "Offices of Mental Health Practitioners (except Physicians)", internal_name: "offices-of-mental-health-practitioners-except-physicians", industry_type: :industry, naics_code: "621330").first_or_create
    IndustryCode.where(name: "Offices of Physical, Occupational and Speech Therapists, and Audiologists", internal_name: "offices-of-physical-occupational-and-speech-therapists-and-audiologists", industry_type: :industry, naics_code: "621340").first_or_create
    IndustryCode.where(name: "Offices of Podiatrists", internal_name: "offices-of-podiatrists", industry_type: :industry, naics_code: "621391").first_or_create
    IndustryCode.where(name: "Offices of All Other Miscellaneous Health Practitioners", internal_name: "offices-of-all-other-miscellaneous-health-practitioners", industry_type: :industry, naics_code: "621399").first_or_create
    IndustryCode.where(name: "Family Planning Centers", internal_name: "family-planning-centers", industry_type: :industry, naics_code: "621410").first_or_create
    IndustryCode.where(name: "Outpatient Mental Health and Substance Abuse Centers", internal_name: "outpatient-mental-health-and-substance-abuse-centers", industry_type: :industry, naics_code: "621420").first_or_create
    IndustryCode.where(name: "HMO Medical Centers", internal_name: "hmo-medical-centers", industry_type: :industry, naics_code: "621491").first_or_create
    IndustryCode.where(name: "Kidney Dialysis Centers", internal_name: "kidney-dialysis-centers", industry_type: :industry, naics_code: "621492").first_or_create
    IndustryCode.where(name: "Freestanding Ambulatory Surgical and Emergency Centers", internal_name: "freestanding-ambulatory-surgical-and-emergency-centers", industry_type: :industry, naics_code: "621493").first_or_create
    IndustryCode.where(name: "All Other Outpatient Care Centers", internal_name: "all-other-outpatient-care-centers", industry_type: :industry, naics_code: "621498").first_or_create
    IndustryCode.where(name: "Medical Laboratories", internal_name: "medical-laboratories", industry_type: :industry, naics_code: "621511").first_or_create
    IndustryCode.where(name: "Diagnostic Imaging Centers", internal_name: "diagnostic-imaging-centers", industry_type: :industry, naics_code: "621512").first_or_create
    IndustryCode.where(name: "Home Health Care Services", internal_name: "home-health-care-services", industry_type: :industry, naics_code: "621610").first_or_create
    IndustryCode.where(name: "Ambulance Services", internal_name: "ambulance-services", industry_type: :industry, naics_code: "621910").first_or_create
    IndustryCode.where(name: "Blood and Organ Banks", internal_name: "blood-and-organ-banks", industry_type: :industry, naics_code: "621991").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Ambulatory Health Care Services", internal_name: "all-other-miscellaneous-ambulatory-health-care-services", industry_type: :industry, naics_code: "621999").first_or_create
    IndustryCode.where(name: "General Medical and Surgical Hospitals", internal_name: "general-medical-and-surgical-hospitals", industry_type: :industry, naics_code: "622110").first_or_create
    IndustryCode.where(name: "Psychiatric and Substance Abuse Hospitals", internal_name: "psychiatric-and-substance-abuse-hospitals", industry_type: :industry, naics_code: "622210").first_or_create
    IndustryCode.where(name: "Specialty (except Psychiatric and Substance Abuse) Hospitals", internal_name: "specialty-except-psychiatric-and-substance-abuse-hospitals", industry_type: :industry, naics_code: "622310").first_or_create
    IndustryCode.where(name: "Nursing Care Facilities (Skilled Nursing Facilities)", internal_name: "nursing-care-facilities-skilled-nursing-facilities", industry_type: :industry, naics_code: "623110").first_or_create
    IndustryCode.where(name: "Residential Intellectual and Developmental Disability Facilities", internal_name: "residential-intellectual-and-developmental-disability-facilities", industry_type: :industry, naics_code: "623210").first_or_create
    IndustryCode.where(name: "Residential Mental Health and Substance Abuse Facilities", internal_name: "residential-mental-health-and-substance-abuse-facilities", industry_type: :industry, naics_code: "623220").first_or_create
    IndustryCode.where(name: "Continuing Care Retirement Communities", internal_name: "continuing-care-retirement-communities", industry_type: :industry, naics_code: "623311").first_or_create
    IndustryCode.where(name: "Assisted Living Facilities for the Elderly", internal_name: "assisted-living-facilities-for-the-elderly", industry_type: :industry, naics_code: "623312").first_or_create
    IndustryCode.where(name: "Other Residential Care Facilities", internal_name: "other-residential-care-facilities", industry_type: :industry, naics_code: "623990").first_or_create
    IndustryCode.where(name: "Child and Youth Services", internal_name: "child-and-youth-services", industry_type: :industry, naics_code: "624110").first_or_create
    IndustryCode.where(name: "Services for the Elderly and Persons with Disabilities", internal_name: "services-for-the-elderly-and-persons-with-disabilities", industry_type: :industry, naics_code: "624120").first_or_create
    IndustryCode.where(name: "Other Individual and Family Services", internal_name: "other-individual-and-family-services", industry_type: :industry, naics_code: "624190").first_or_create
    IndustryCode.where(name: "Community Food Services", internal_name: "community-food-services", industry_type: :industry, naics_code: "624210").first_or_create
    IndustryCode.where(name: "Temporary Shelters", internal_name: "temporary-shelters", industry_type: :industry, naics_code: "624221").first_or_create
    IndustryCode.where(name: "Other Community Housing Services", internal_name: "other-community-housing-services", industry_type: :industry, naics_code: "624229").first_or_create
    IndustryCode.where(name: "Emergency and Other Relief Services", internal_name: "emergency-and-other-relief-services", industry_type: :industry, naics_code: "624230").first_or_create
    IndustryCode.where(name: "Vocational Rehabilitation Services", internal_name: "vocational-rehabilitation-services", industry_type: :industry, naics_code: "624310").first_or_create
    IndustryCode.where(name: "Child Day Care Services", internal_name: "child-day-care-services", industry_type: :industry, naics_code: "624410").first_or_create
    IndustryCode.where(name: "Theater Companies and Dinner Theaters", internal_name: "theater-companies-and-dinner-theaters", industry_type: :industry, naics_code: "711110").first_or_create
    IndustryCode.where(name: "Dance Companies", internal_name: "dance-companies", industry_type: :industry, naics_code: "711120").first_or_create
    IndustryCode.where(name: "Musical Groups and Artists", internal_name: "musical-groups-and-artists", industry_type: :industry, naics_code: "711130").first_or_create
    IndustryCode.where(name: "Other Performing Arts Companies", internal_name: "other-performing-arts-companies", industry_type: :industry, naics_code: "711190").first_or_create
    IndustryCode.where(name: "Sports Teams and Clubs", internal_name: "sports-teams-and-clubs", industry_type: :industry, naics_code: "711211").first_or_create
    IndustryCode.where(name: "Racetracks", internal_name: "racetracks", industry_type: :industry, naics_code: "711212").first_or_create
    IndustryCode.where(name: "Other Spectator Sports", internal_name: "other-spectator-sports", industry_type: :industry, naics_code: "711219").first_or_create
    IndustryCode.where(name: "Promoters of Performing Arts, Sports, and Similar Events with Facilities", internal_name: "promoters-of-performing-arts-sports-and-similar-events-with-facilities", industry_type: :industry, naics_code: "711310").first_or_create
    IndustryCode.where(name: "Promoters of Performing Arts, Sports, and Similar Events without Facilities", internal_name: "promoters-of-performing-arts-sports-and-similar-events-without-facilities", industry_type: :industry, naics_code: "711320").first_or_create
    IndustryCode.where(name: "Agents and Managers for Artists, Athletes, Entertainers, and Other Public Figures", internal_name: "agents-and-managers-for-artists-athletes-entertainers-and-other-public-figures", industry_type: :industry, naics_code: "711410").first_or_create
    IndustryCode.where(name: "Independent Artists, Writers, and Performers", internal_name: "independent-artists-writers-and-performers", industry_type: :industry, naics_code: "711510").first_or_create
    IndustryCode.where(name: "Museums", internal_name: "museums", industry_type: :industry, naics_code: "712110").first_or_create
    IndustryCode.where(name: "Historical Sites", internal_name: "historical-sites", industry_type: :industry, naics_code: "712120").first_or_create
    IndustryCode.where(name: "Zoos and Botanical Gardens", internal_name: "zoos-and-botanical-gardens", industry_type: :industry, naics_code: "712130").first_or_create
    IndustryCode.where(name: "Nature Parks and Other Similar Institutions", internal_name: "nature-parks-and-other-similar-institutions", industry_type: :industry, naics_code: "712190").first_or_create
    IndustryCode.where(name: "Amusement and Theme Parks", internal_name: "amusement-and-theme-parks", industry_type: :industry, naics_code: "713110").first_or_create
    IndustryCode.where(name: "Amusement Arcades", internal_name: "amusement-arcades", industry_type: :industry, naics_code: "713120").first_or_create
    IndustryCode.where(name: "Casinos (except Casino Hotels)", internal_name: "casinos-except-casino-hotels", industry_type: :industry, naics_code: "713210").first_or_create
    IndustryCode.where(name: "Other Gambling Industries", internal_name: "other-gambling-industries", industry_type: :industry, naics_code: "713290").first_or_create
    IndustryCode.where(name: "Golf Courses and Country Clubs", internal_name: "golf-courses-and-country-clubs", industry_type: :industry, naics_code: "713910").first_or_create
    IndustryCode.where(name: "Skiing Facilities", internal_name: "skiing-facilities", industry_type: :industry, naics_code: "713920").first_or_create
    IndustryCode.where(name: "Marinas", internal_name: "marinas", industry_type: :industry, naics_code: "713930").first_or_create
    IndustryCode.where(name: "Fitness and Recreational Sports Centers", internal_name: "fitness-and-recreational-sports-centers", industry_type: :industry, naics_code: "713940").first_or_create
    IndustryCode.where(name: "Bowling Centers", internal_name: "bowling-centers", industry_type: :industry, naics_code: "713950").first_or_create
    IndustryCode.where(name: "All Other Amusement and Recreation Industries", internal_name: "all-other-amusement-and-recreation-industries", industry_type: :industry, naics_code: "713990").first_or_create
    IndustryCode.where(name: "Hotels (except Casino Hotels) and Motels", internal_name: "hotels-except-casino-hotels-and-motels", industry_type: :industry, naics_code: "721110").first_or_create
    IndustryCode.where(name: "Casino Hotels", internal_name: "casino-hotels", industry_type: :industry, naics_code: "721120").first_or_create
    IndustryCode.where(name: "Bed-and-Breakfast Inns", internal_name: "bed-and-breakfast-inns", industry_type: :industry, naics_code: "721191").first_or_create
    IndustryCode.where(name: "All Other Traveler Accommodation", internal_name: "all-other-traveler-accommodation", industry_type: :industry, naics_code: "721199").first_or_create
    IndustryCode.where(name: "RV (Recreational Vehicle) Parks and Campgrounds", internal_name: "rv-recreational-vehicle-parks-and-campgrounds", industry_type: :industry, naics_code: "721211").first_or_create
    IndustryCode.where(name: "Recreational and Vacation Camps (except Campgrounds)", internal_name: "recreational-and-vacation-camps-except-campgrounds", industry_type: :industry, naics_code: "721214").first_or_create
    IndustryCode.where(name: "Rooming and Boarding Houses", internal_name: "rooming-and-boarding-houses", industry_type: :industry, naics_code: "721310").first_or_create
    IndustryCode.where(name: "Food Service Contractors", internal_name: "food-service-contractors", industry_type: :industry, naics_code: "722310").first_or_create
    IndustryCode.where(name: "Caterers", internal_name: "caterers", industry_type: :industry, naics_code: "722320").first_or_create
    IndustryCode.where(name: "Mobile Food Services", internal_name: "mobile-food-services", industry_type: :industry, naics_code: "722330").first_or_create
    IndustryCode.where(name: "Drinking Places (Alcoholic Beverages)", internal_name: "drinking-places-alcoholic-beverages", industry_type: :industry, naics_code: "722410").first_or_create
    IndustryCode.where(name: "Full-Service Restaurants", internal_name: "full-service-restaurants", industry_type: :industry, naics_code: "722511").first_or_create
    IndustryCode.where(name: "Limited-Service Restaurants", internal_name: "limited-service-restaurants", industry_type: :industry, naics_code: "722513").first_or_create
    IndustryCode.where(name: "Cafeterias, Grill Buffets, and Buffets", internal_name: "cafeterias-grill-buffets-and-buffets", industry_type: :industry, naics_code: "722514").first_or_create
    IndustryCode.where(name: "Snack and Nonalcoholic Beverage Bars", internal_name: "snack-and-nonalcoholic-beverage-bars", industry_type: :industry, naics_code: "722515").first_or_create
    IndustryCode.where(name: "General Automotive Repair", internal_name: "general-automotive-repair", industry_type: :industry, naics_code: "811111").first_or_create
    IndustryCode.where(name: "Automotive Exhaust System Repair", internal_name: "automotive-exhaust-system-repair", industry_type: :industry, naics_code: "811112").first_or_create
    IndustryCode.where(name: "Automotive Transmission Repair", internal_name: "automotive-transmission-repair", industry_type: :industry, naics_code: "811113").first_or_create
    IndustryCode.where(name: "Other Automotive Mechanical and Electrical Repair and Maintenance", internal_name: "other-automotive-mechanical-and-electrical-repair-and-maintenance", industry_type: :industry, naics_code: "811118").first_or_create
    IndustryCode.where(name: "Automotive Body, Paint, and Interior Repair and Maintenance", internal_name: "automotive-body-paint-and-interior-repair-and-maintenance", industry_type: :industry, naics_code: "811121").first_or_create
    IndustryCode.where(name: "Automotive Glass Replacement Shops", internal_name: "automotive-glass-replacement-shops", industry_type: :industry, naics_code: "811122").first_or_create
    IndustryCode.where(name: "Automotive Oil Change and Lubrication Shops", internal_name: "automotive-oil-change-and-lubrication-shops", industry_type: :industry, naics_code: "811191").first_or_create
    IndustryCode.where(name: "Car Washes", internal_name: "car-washes", industry_type: :industry, naics_code: "811192").first_or_create
    IndustryCode.where(name: "All Other Automotive Repair and Maintenance", internal_name: "all-other-automotive-repair-and-maintenance", industry_type: :industry, naics_code: "811198").first_or_create
    IndustryCode.where(name: "Consumer Electronics Repair and Maintenance", internal_name: "consumer-electronics-repair-and-maintenance", industry_type: :industry, naics_code: "811211").first_or_create
    IndustryCode.where(name: "Computer and Office Machine Repair and Maintenance", internal_name: "computer-and-office-machine-repair-and-maintenance", industry_type: :industry, naics_code: "811212").first_or_create
    IndustryCode.where(name: "Communication Equipment Repair and Maintenance", internal_name: "communication-equipment-repair-and-maintenance", industry_type: :industry, naics_code: "811213").first_or_create
    IndustryCode.where(name: "Other Electronic and Precision Equipment Repair and Maintenance", internal_name: "other-electronic-and-precision-equipment-repair-and-maintenance", industry_type: :industry, naics_code: "811219").first_or_create
    IndustryCode.where(name: "Commercial and Industrial Machinery and Equipment (except Automotive and Electronic) Repair and Maintenance", internal_name: "commercial-and-industrial-machinery-and-equipment-except-automotive-and-electronic-repair-and-maintenance", industry_type: :industry, naics_code: "811310").first_or_create
    IndustryCode.where(name: "Home and Garden Equipment Repair and Maintenance", internal_name: "home-and-garden-equipment-repair-and-maintenance", industry_type: :industry, naics_code: "811411").first_or_create
    IndustryCode.where(name: "Appliance Repair and Maintenance", internal_name: "appliance-repair-and-maintenance", industry_type: :industry, naics_code: "811412").first_or_create
    IndustryCode.where(name: "Reupholstery and Furniture Repair", internal_name: "reupholstery-and-furniture-repair", industry_type: :industry, naics_code: "811420").first_or_create
    IndustryCode.where(name: "Footwear and Leather Goods Repair", internal_name: "footwear-and-leather-goods-repair", industry_type: :industry, naics_code: "811430").first_or_create
    IndustryCode.where(name: "Other Personal and Household Goods Repair and Maintenance", internal_name: "other-personal-and-household-goods-repair-and-maintenance", industry_type: :industry, naics_code: "811490").first_or_create
    IndustryCode.where(name: "Barber Shops", internal_name: "barber-shops", industry_type: :industry, naics_code: "812111").first_or_create
    IndustryCode.where(name: "Beauty Salons", internal_name: "beauty-salons", industry_type: :industry, naics_code: "812112").first_or_create
    IndustryCode.where(name: "Nail Salons", internal_name: "nail-salons", industry_type: :industry, naics_code: "812113").first_or_create
    IndustryCode.where(name: "Diet and Weight Reducing Centers", internal_name: "diet-and-weight-reducing-centers", industry_type: :industry, naics_code: "812191").first_or_create
    IndustryCode.where(name: "Other Personal Care Services", internal_name: "other-personal-care-services", industry_type: :industry, naics_code: "812199").first_or_create
    IndustryCode.where(name: "Funeral Homes and Funeral Services", internal_name: "funeral-homes-and-funeral-services", industry_type: :industry, naics_code: "812210").first_or_create
    IndustryCode.where(name: "Cemeteries and Crematories", internal_name: "cemeteries-and-crematories", industry_type: :industry, naics_code: "812220").first_or_create
    IndustryCode.where(name: "Coin-Operated Laundries and Drycleaners", internal_name: "coin-operated-laundries-and-drycleaners", industry_type: :industry, naics_code: "812310").first_or_create
    IndustryCode.where(name: "Drycleaning and Laundry Services (except Coin-Operated)", internal_name: "drycleaning-and-laundry-services-except-coin-operated", industry_type: :industry, naics_code: "812320").first_or_create
    IndustryCode.where(name: "Linen Supply", internal_name: "linen-supply", industry_type: :industry, naics_code: "812331").first_or_create
    IndustryCode.where(name: "Industrial Launderers", internal_name: "industrial-launderers", industry_type: :industry, naics_code: "812332").first_or_create
    IndustryCode.where(name: "Pet Care (except Veterinary) Services", internal_name: "pet-care-except-veterinary-services", industry_type: :industry, naics_code: "812910").first_or_create
    IndustryCode.where(name: "Photofinishing Laboratories (except One-Hour)", internal_name: "photofinishing-laboratories-except-one-hour", industry_type: :industry, naics_code: "812921").first_or_create
    IndustryCode.where(name: "One-Hour Photofinishing", internal_name: "one-hour-photofinishing", industry_type: :industry, naics_code: "812922").first_or_create
    IndustryCode.where(name: "Parking Lots and Garages", internal_name: "parking-lots-and-garages", industry_type: :industry, naics_code: "812930").first_or_create
    IndustryCode.where(name: "All Other Personal Services", internal_name: "all-other-personal-services", industry_type: :industry, naics_code: "812990").first_or_create
    IndustryCode.where(name: "Religious Organizations", internal_name: "religious-organizations", industry_type: :industry, naics_code: "813110").first_or_create
    IndustryCode.where(name: "Grantmaking Foundations", internal_name: "grantmaking-foundations", industry_type: :industry, naics_code: "813211").first_or_create
    IndustryCode.where(name: "Voluntary Health Organizations", internal_name: "voluntary-health-organizations", industry_type: :industry, naics_code: "813212").first_or_create
    IndustryCode.where(name: "Other Grantmaking and Giving Services", internal_name: "other-grantmaking-and-giving-services", industry_type: :industry, naics_code: "813219").first_or_create
    IndustryCode.where(name: "Human Rights Organizations", internal_name: "human-rights-organizations", industry_type: :industry, naics_code: "813311").first_or_create
    IndustryCode.where(name: "Environment, Conservation and Wildlife Organizations", internal_name: "environment-conservation-and-wildlife-organizations", industry_type: :industry, naics_code: "813312").first_or_create
    IndustryCode.where(name: "Other Social Advocacy Organizations", internal_name: "other-social-advocacy-organizations", industry_type: :industry, naics_code: "813319").first_or_create
    IndustryCode.where(name: "Civic and Social Organizations", internal_name: "civic-and-social-organizations", industry_type: :industry, naics_code: "813410").first_or_create
    IndustryCode.where(name: "Business Associations", internal_name: "business-associations", industry_type: :industry, naics_code: "813910").first_or_create
    IndustryCode.where(name: "Professional Organizations", internal_name: "professional-organizations", industry_type: :industry, naics_code: "813920").first_or_create
    IndustryCode.where(name: "Labor Unions and Similar Labor Organizations", internal_name: "labor-unions-and-similar-labor-organizations", industry_type: :industry, naics_code: "813930").first_or_create
    IndustryCode.where(name: "Political Organizations", internal_name: "political-organizations", industry_type: :industry, naics_code: "813940").first_or_create
    IndustryCode.where(name: "Other Similar Organizations (except Business, Professional, Labor, and Political Organizations)", internal_name: "other-similar-organizations-except-business-professional-labor-and-political-organizations", industry_type: :industry, naics_code: "813990").first_or_create
    IndustryCode.where(name: "Private Households", internal_name: "private-households", industry_type: :industry, naics_code: "814110").first_or_create
    IndustryCode.where(name: "Executive Offices", internal_name: "executive-offices", industry_type: :industry, naics_code: "921110").first_or_create
    IndustryCode.where(name: "Legislative Bodies", internal_name: "legislative-bodies", industry_type: :industry, naics_code: "921120").first_or_create
    IndustryCode.where(name: "Public Finance Activities", internal_name: "public-finance-activities", industry_type: :industry, naics_code: "921130").first_or_create
    IndustryCode.where(name: "Executive and Legislative Offices, Combined", internal_name: "executive-and-legislative-offices-combined", industry_type: :industry, naics_code: "921140").first_or_create
    IndustryCode.where(name: "American Indian and Alaska Native Tribal Governments", internal_name: "american-indian-and-alaska-native-tribal-governments", industry_type: :industry, naics_code: "921150").first_or_create
    IndustryCode.where(name: "Other General Government Support", internal_name: "other-general-government-support", industry_type: :industry, naics_code: "921190").first_or_create
    IndustryCode.where(name: "Courts", internal_name: "courts", industry_type: :industry, naics_code: "922110").first_or_create
    IndustryCode.where(name: "Police Protection", internal_name: "police-protection", industry_type: :industry, naics_code: "922120").first_or_create
    IndustryCode.where(name: "Legal Counsel and Prosecution", internal_name: "legal-counsel-and-prosecution", industry_type: :industry, naics_code: "922130").first_or_create
    IndustryCode.where(name: "Correctional Institutions", internal_name: "correctional-institutions", industry_type: :industry, naics_code: "922140").first_or_create
    IndustryCode.where(name: "Parole Offices and Probation Offices", internal_name: "parole-offices-and-probation-offices", industry_type: :industry, naics_code: "922150").first_or_create
    IndustryCode.where(name: "Fire Protection", internal_name: "fire-protection", industry_type: :industry, naics_code: "922160").first_or_create
    IndustryCode.where(name: "Other Justice, Public Order, and Safety Activities", internal_name: "other-justice-public-order-and-safety-activities", industry_type: :industry, naics_code: "922190").first_or_create
    IndustryCode.where(name: "Administration of Education Programs", internal_name: "administration-of-education-programs", industry_type: :industry, naics_code: "923110").first_or_create
    IndustryCode.where(name: "Administration of Public Health Programs", internal_name: "administration-of-public-health-programs", industry_type: :industry, naics_code: "923120").first_or_create
    IndustryCode.where(name: "Administration of Human Resource Programs (except Education, Public Health, and Veterans' Affairs Programs)", internal_name: "administration-of-human-resource-programs-except-education-public-health-and-veterans'-affairs-programs", industry_type: :industry, naics_code: "923130").first_or_create
    IndustryCode.where(name: "Administration of Veterans' Affairs", internal_name: "administration-of-veterans'-affairs", industry_type: :industry, naics_code: "923140").first_or_create
    IndustryCode.where(name: "Administration of Air and Water Resource and Solid Waste Management Programs", internal_name: "administration-of-air-and-water-resource-and-solid-waste-management-programs", industry_type: :industry, naics_code: "924110").first_or_create
    IndustryCode.where(name: "Administration of Conservation Programs", internal_name: "administration-of-conservation-programs", industry_type: :industry, naics_code: "924120").first_or_create
    IndustryCode.where(name: "Administration of Housing Programs", internal_name: "administration-of-housing-programs", industry_type: :industry, naics_code: "925110").first_or_create
    IndustryCode.where(name: "Administration of Urban Planning and Community and Rural Development", internal_name: "administration-of-urban-planning-and-community-and-rural-development", industry_type: :industry, naics_code: "925120").first_or_create
    IndustryCode.where(name: "Administration of General Economic Programs", internal_name: "administration-of-general-economic-programs", industry_type: :industry, naics_code: "926110").first_or_create
    IndustryCode.where(name: "Regulation and Administration of Transportation Programs", internal_name: "regulation-and-administration-of-transportation-programs", industry_type: :industry, naics_code: "926120").first_or_create
    IndustryCode.where(name: "Regulation and Administration of Communications, Electric, Gas, and Other Utilities", internal_name: "regulation-and-administration-of-communications-electric-gas-and-other-utilities", industry_type: :industry, naics_code: "926130").first_or_create
    IndustryCode.where(name: "Regulation of Agricultural Marketing and Commodities", internal_name: "regulation-of-agricultural-marketing-and-commodities", industry_type: :industry, naics_code: "926140").first_or_create
    IndustryCode.where(name: "Regulation, Licensing, and Inspection of Miscellaneous Commercial Sectors", internal_name: "regulation-licensing-and-inspection-of-miscellaneous-commercial-sectors", industry_type: :industry, naics_code: "926150").first_or_create
    IndustryCode.where(name: "Space Research and Technology", internal_name: "space-research-and-technology", industry_type: :industry, naics_code: "927110").first_or_create
    IndustryCode.where(name: "National Security", internal_name: "national-security", industry_type: :industry, naics_code: "928110").first_or_create
    IndustryCode.where(name: "International Affairs", internal_name: "international-affairs", industry_type: :industry, naics_code: "928120").first_or_create
  end

  desc "create occupation code records"
  task :occupation_code => :environment do
    OccupationCode.where(name: "Not specified", internal_name: "not-specified", description: "This series does not have occupation as an attribute").first_or_create
    OccupationCode.where(name: "All occupations", internal_name: "all-occupations", description: "Occupation is a series attribute and all values are included").first_or_create
    OccupationCode.where(name: "No answer provided", internal_name: "no-answer-provided", description: "Occupation is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

  end

  desc "create geo code records"
  task :geo_code => :environment do
    GeoCode::OtherGeo.where(name: "Not specified", internal_name: "not-specified", description: "This series does not have geography as an attribute").first_or_create
    # Does this ever happen? When would we not be able to get a geographic description?
    # Perhaps we use temporarily in dev then remove this and force a geographic definition explicitly
    GeoCode::OtherGeo.where(name: "All geographies", internal_name: "all-geographies", description: "Geography is a series attribute and all values are included").first_or_create
    GeoCode::OtherGeo.where(name: "No answer provided", internal_name: "no-answer-provided", description: "Geography is a series attribute however no value was recorded").first_or_create
    GeoCode::OtherGeo.where(name: "Not elsewhere classified", internal_name: "not-elsewhere-classified", description: "A geographic attribute was classified but it does not map to our system, see the raw value for details").first_or_create

    #Country
    GeoCode::Country.where(name: "United States", short_name: "USA", internal_name: "united-states").first_or_create

    #Region
    GeoCode::Region.where(name: "Northeast region", internal_name: :northeast).first_or_create
    GeoCode::Region.where(name: "Midwest region", internal_name: :midwest ).first_or_create
    GeoCode::Region.where(name: "Southeast region", internal_name: :southeast).first_or_create
    GeoCode::Region.where(name: "Westcoast region", internal_name: :westcoast).first_or_create

    #State
    GeoCode::State.where(name: 'Alabama', fips_code: 1, gnis_code: 1779775, short_name: 'AL', internal_name: :'alabama').first_or_create
    GeoCode::State.where(name: 'Alaska', fips_code: 2, gnis_code: 1785533, short_name: 'AK', internal_name: :'alaska').first_or_create
    GeoCode::State.where(name: 'Arizona', fips_code: 4, gnis_code: 1779777, short_name: 'AZ', internal_name: :'arizona').first_or_create
    GeoCode::State.where(name: 'Arkansas', fips_code: 5, gnis_code: 68085, short_name: 'AR', internal_name: :'arkansas').first_or_create
    GeoCode::State.where(name: 'California', fips_code: 6, gnis_code: 1779778, short_name: 'CA', internal_name: :'california').first_or_create
    GeoCode::State.where(name: 'Colorado', fips_code: 8, gnis_code: 1779779, short_name: 'CO', internal_name: :'colorado').first_or_create
    GeoCode::State.where(name: 'Connecticut', fips_code: 9, gnis_code: 1779780, short_name: 'CT', internal_name: :'connecticut').first_or_create
    GeoCode::State.where(name: 'Delaware', fips_code: 10, gnis_code: 1779781, short_name: 'DE', internal_name: :'delaware').first_or_create
    GeoCode::State.where(name: 'District of Columbia', fips_code: 11, gnis_code: 1702382, short_name: 'DC', internal_name: :'district-of-columbia').first_or_create
    GeoCode::State.where(name: 'Florida', fips_code: 12, gnis_code: 294478, short_name: 'FL', internal_name: :'florida').first_or_create
    GeoCode::State.where(name: 'Georgia', fips_code: 13, gnis_code: 1705317, short_name: 'GA', internal_name: :'georgia').first_or_create
    GeoCode::State.where(name: 'Hawaii', fips_code: 15, gnis_code: 1779782, short_name: 'HI', internal_name: :'hawaii').first_or_create
    GeoCode::State.where(name: 'Idaho', fips_code: 16, gnis_code: 1779783, short_name: 'ID', internal_name: :'idaho').first_or_create
    GeoCode::State.where(name: 'Illinois', fips_code: 17, gnis_code: 1779784, short_name: 'IL', internal_name: :'illinois').first_or_create
    GeoCode::State.where(name: 'Indiana', fips_code: 18, gnis_code: 448508, short_name: 'IN', internal_name: :'indiana').first_or_create
    GeoCode::State.where(name: 'Iowa', fips_code: 19, gnis_code: 1779785, short_name: 'IA', internal_name: :'iowa').first_or_create
    GeoCode::State.where(name: 'Kansas', fips_code: 20, gnis_code: 481813, short_name: 'KS', internal_name: :'kansas').first_or_create
    GeoCode::State.where(name: 'Kentucky', fips_code: 21, gnis_code: 1779786, short_name: 'KY', internal_name: :'kentucky').first_or_create
    GeoCode::State.where(name: 'Louisiana', fips_code: 22, gnis_code: 1629543, short_name: 'LA', internal_name: :'louisiana').first_or_create
    GeoCode::State.where(name: 'Maine', fips_code: 23, gnis_code: 1779787, short_name: 'ME', internal_name: :'maine').first_or_create
    GeoCode::State.where(name: 'Maryland', fips_code: 24, gnis_code: 1714934, short_name: 'MD', internal_name: :'maryland').first_or_create
    GeoCode::State.where(name: 'Massachusetts', fips_code: 25, gnis_code: 606926, short_name: 'MA', internal_name: :'massachusetts').first_or_create
    GeoCode::State.where(name: 'Michigan', fips_code: 26, gnis_code: 1779789, short_name: 'MI', internal_name: :'michigan').first_or_create
    GeoCode::State.where(name: 'Minnesota', fips_code: 27, gnis_code: 662849, short_name: 'MN', internal_name: :'minnesota').first_or_create
    GeoCode::State.where(name: 'Mississippi', fips_code: 28, gnis_code: 1779790, short_name: 'MS', internal_name: :'mississippi').first_or_create
    GeoCode::State.where(name: 'Missouri', fips_code: 29, gnis_code: 1779791, short_name: 'MO', internal_name: :'missouri').first_or_create
    GeoCode::State.where(name: 'Montana', fips_code: 30, gnis_code: 767982, short_name: 'MT', internal_name: :'montana').first_or_create
    GeoCode::State.where(name: 'Nebraska', fips_code: 31, gnis_code: 1779792, short_name: 'NE', internal_name: :'nebraska').first_or_create
    GeoCode::State.where(name: 'Nevada', fips_code: 32, gnis_code: 1779793, short_name: 'NV', internal_name: :'nevada').first_or_create
    GeoCode::State.where(name: 'New Hampshire', fips_code: 33, gnis_code: 1779794, short_name: 'NH', internal_name: :'new-hampshire').first_or_create
    GeoCode::State.where(name: 'New Jersey', fips_code: 34, gnis_code: 1779795, short_name: 'NJ', internal_name: :'new-jersey').first_or_create
    GeoCode::State.where(name: 'New Mexico', fips_code: 35, gnis_code: 897535, short_name: 'NM', internal_name: :'new-mexico').first_or_create
    GeoCode::State.where(name: 'New York', fips_code: 36, gnis_code: 1779796, short_name: 'NY', internal_name: :'new-york').first_or_create
    GeoCode::State.where(name: 'North Carolina', fips_code: 37, gnis_code: 1027616, short_name: 'NC', internal_name: :'north-carolina').first_or_create
    GeoCode::State.where(name: 'North Dakota', fips_code: 38, gnis_code: 1779797, short_name: 'ND', internal_name: :'north-dakota').first_or_create
    GeoCode::State.where(name: 'Ohio', fips_code: 39, gnis_code: 1085497, short_name: 'OH', internal_name: :'ohio').first_or_create
    GeoCode::State.where(name: 'Oklahoma', fips_code: 40, gnis_code: 1102857, short_name: 'OK', internal_name: :'oklahoma').first_or_create
    GeoCode::State.where(name: 'Oregon', fips_code: 41, gnis_code: 1155107, short_name: 'OR', internal_name: :'oregon').first_or_create
    GeoCode::State.where(name: 'Pennsylvania', fips_code: 42, gnis_code: 1779798, short_name: 'PA', internal_name: :'pennsylvania').first_or_create
    GeoCode::State.where(name: 'Rhode Island', fips_code: 44, gnis_code: 1219835, short_name: 'RI', internal_name: :'rhode island').first_or_create
    GeoCode::State.where(name: 'South Carolina', fips_code: 45, gnis_code: 1779799, short_name: 'SC', internal_name: :'south-carolina').first_or_create
    GeoCode::State.where(name: 'South Dakota', fips_code: 46, gnis_code: 1785534, short_name: 'SD', internal_name: :'south-dakota').first_or_create
    GeoCode::State.where(name: 'Tennessee', fips_code: 47, gnis_code: 1325873, short_name: 'TN', internal_name: :'tennessee').first_or_create
    GeoCode::State.where(name: 'Texas', fips_code: 48, gnis_code: 1779801, short_name: 'TX', internal_name: :'texas').first_or_create
    GeoCode::State.where(name: 'Utah', fips_code: 49, gnis_code: 1455989, short_name: 'UT', internal_name: :'utah').first_or_create
    GeoCode::State.where(name: 'Vermont', fips_code: 50, gnis_code: 1779802, short_name: 'VT', internal_name: :'vermont').first_or_create
    GeoCode::State.where(name: 'Virginia', fips_code: 51, gnis_code: 1779803, short_name: 'VA', internal_name: :'virginia').first_or_create
    GeoCode::State.where(name: 'Washington', fips_code: 53, gnis_code: 1779804, short_name: 'WA', internal_name: :'washington').first_or_create
    GeoCode::State.where(name: 'West Virginia', fips_code: 54, gnis_code: 1779805, short_name: 'WV', internal_name: :'west-virginia').first_or_create
    GeoCode::State.where(name: 'Wisconsin', fips_code: 55, gnis_code: 1779806, short_name: 'WI', internal_name: :'wisconsin').first_or_create
    GeoCode::State.where(name: 'Wyoming', fips_code: 56, gnis_code: 1779807, short_name: 'WY', internal_name: :'wyoming').first_or_create
    GeoCode::State.where(name: 'American Samoa', fips_code: 60, gnis_code: 1802701, short_name: 'AS', internal_name: :'american-samoa').first_or_create
    GeoCode::State.where(name: 'Guam', fips_code: 66, gnis_code: 1802705, short_name: 'GU', internal_name: :'guam').first_or_create
    GeoCode::State.where(name: 'Northern Mariana Islands', fips_code: 69, gnis_code: 1779809, short_name: 'MP', internal_name: :'northern-mariana-islands').first_or_create
    GeoCode::State.where(name: 'Puerto Rico', fips_code: 72, gnis_code: 1779808, short_name: 'PR', internal_name: :'puerto-rico').first_or_create
    GeoCode::State.where(name: 'U.S. Minor Outlying Islands', fips_code: 74, gnis_code: 1878752, short_name: 'UM', internal_name: :'us-minor-outlying-islands').first_or_create
    GeoCode::State.where(name: 'U.S. Virgin Islands', fips_code: 78, gnis_code: 1802710, short_name: 'VI', internal_name: :'us-virgin-islands').first_or_create

    #Combined Statistical Areas (CSA)
GeoCode::Csa.where(name: 'Cleveland-Akron-Canton, OH', short_name: 'Cleveland, OH', internal_name: 'cleveland-akron-canton-oh').first_or_create
GeoCode::Csa.where(name: 'Portland-Vancouver-Salem, OR-WA', short_name: 'Portland, OR', internal_name: 'portland-vancouver-salem-or-wa').first_or_create
GeoCode::Csa.where(name: 'Albany-Schenectady, NY', short_name: 'Albany, NY', internal_name: 'albany-schenectady-ny').first_or_create
GeoCode::Csa.where(name: 'Albuquerque-Santa Fe-Las Vegas, NM', short_name: 'Albuquerque, NM', internal_name: 'albuquerque-santa-fe-las-vegas-nm').first_or_create
GeoCode::Csa.where(name: 'New York-Newark, NY-NJ-CT-PA', short_name: 'New York, NY', internal_name: 'new-york-newark-ny-nj-ct-pa').first_or_create
GeoCode::Csa.where(name: 'Amarillo-Borger, TX', short_name: 'Amarillo, TX', internal_name: 'amarillo-borger-tx').first_or_create
GeoCode::Csa.where(name: 'Des Moines-Ames-West Des Moines, IA', short_name: 'Des Moines, IA', internal_name: 'des-moines-ames-west-des-moines-ia').first_or_create
GeoCode::Csa.where(name: 'Detroit-Warren-Ann Arbor, MI', short_name: 'Detroit, MI', internal_name: 'detroit-warren-ann-arbor-mi').first_or_create
GeoCode::Csa.where(name: 'Appleton-Oshkosh-Neenah, WI', short_name: 'Appleton, WI', internal_name: 'appleton-oshkosh-neenah-wi').first_or_create
GeoCode::Csa.where(name: 'San Juan-Carolina, PR', short_name: 'San Juan, PR', internal_name: 'san-juan-carolina-pr').first_or_create
GeoCode::Csa.where(name: 'Asheville-Brevard, NC', short_name: 'Asheville, NC', internal_name: 'asheville-brevard-nc').first_or_create
GeoCode::Csa.where(name: 'Atlanta--Athens-Clarke County--Sandy Springs, GA', short_name: 'Atlanta, GA', internal_name: 'atlanta--athens-clarke-county--sandy-springs-ga').first_or_create
GeoCode::Csa.where(name: 'Philadelphia-Reading-Camden, PA-NJ-DE-MD', short_name: 'Philadelphia, PA', internal_name: 'philadelphia-reading-camden-pa-nj-de-md').first_or_create
GeoCode::Csa.where(name: 'Columbus-Auburn-Opelika, GA-AL', short_name: 'Columbus, GA', internal_name: 'columbus-auburn-opelika-ga-al').first_or_create
GeoCode::Csa.where(name: 'Washington-Baltimore-Arlington, DC-MD-VA-WV-PA', short_name: 'Washington, DC', internal_name: 'washington-baltimore-arlington-dc-md-va-wv-pa').first_or_create
GeoCode::Csa.where(name: 'Boston-Worcester-Providence, MA-RI-NH-CT', short_name: 'Boston, MA', internal_name: 'boston-worcester-providence-ma-ri-nh-ct').first_or_create
GeoCode::Csa.where(name: 'Kalamazoo-Battle Creek-Portage, MI', short_name: 'Kalamazoo, MI', internal_name: 'kalamazoo-battle-creek-portage-mi').first_or_create
GeoCode::Csa.where(name: 'Saginaw-Midland-Bay City, MI', short_name: 'Saginaw, MI', internal_name: 'saginaw-midland-bay-city-mi').first_or_create
GeoCode::Csa.where(name: 'Bend-Redmond-Prineville, OR', short_name: 'Bend, OR', internal_name: 'bend-redmond-prineville-or').first_or_create
GeoCode::Csa.where(name: 'Birmingham-Hoover-Talladega, AL', short_name: 'Birmingham, AL', internal_name: 'birmingham-hoover-talladega-al').first_or_create
GeoCode::Csa.where(name: 'Bloomington-Pontiac, IL', short_name: 'Bloomington, IL', internal_name: 'bloomington-pontiac-il').first_or_create
GeoCode::Csa.where(name: 'Bloomington-Bedford, IN', short_name: 'Bloomington, IN', internal_name: 'bloomington-bedford-in').first_or_create
GeoCode::Csa.where(name: 'Bloomsburg-Berwick-Sunbury, PA', short_name: 'Bloomsburg, PA', internal_name: 'bloomsburg-berwick-sunbury-pa').first_or_create
GeoCode::Csa.where(name: 'Boise City-Mountain Home-Ontario, ID-OR', short_name: 'Boise City, ID', internal_name: 'boise-city-mountain-home-ontario-id-or').first_or_create
GeoCode::Csa.where(name: 'Denver-Aurora, CO', short_name: 'Denver, CO', internal_name: 'denver-aurora-co').first_or_create
GeoCode::Csa.where(name: 'Bowling Green-Glasgow, KY', short_name: 'Bowling Green, KY', internal_name: 'bowling-green-glasgow-ky').first_or_create
GeoCode::Csa.where(name: 'Seattle-Tacoma, WA', short_name: 'Seattle, WA', internal_name: 'seattle-tacoma-wa').first_or_create
GeoCode::Csa.where(name: 'Brownsville-Harlingen-Raymondville, TX', short_name: 'Brownsville, TX', internal_name: 'brownsville-harlingen-raymondville-tx').first_or_create
GeoCode::Csa.where(name: 'Buffalo-Cheektowaga, NY', short_name: 'Buffalo, NY', internal_name: 'buffalo-cheektowaga-ny').first_or_create
GeoCode::Csa.where(name: 'Greensboro--Winston-Salem--High Point, NC', short_name: 'Greensboro, NC', internal_name: 'greensboro--winston-salem--high-point-nc').first_or_create
GeoCode::Csa.where(name: 'Cape Coral-Fort Myers-Naples, FL', short_name: 'Cape Coral, FL', internal_name: 'cape-coral-fort-myers-naples-fl').first_or_create
GeoCode::Csa.where(name: 'Cape Girardeau-Sikeston, MO-IL', short_name: 'Cape Girardeau, MO', internal_name: 'cape-girardeau-sikeston-mo-il').first_or_create
GeoCode::Csa.where(name: 'Reno-Carson City-Fernley, NV', short_name: 'Reno, NV', internal_name: 'reno-carson-city-fernley-nv').first_or_create
GeoCode::Csa.where(name: 'Cedar Rapids-Iowa City, IA', short_name: 'Cedar Rapids, IA', internal_name: 'cedar-rapids-iowa-city-ia').first_or_create
GeoCode::Csa.where(name: 'Charleston-Huntington-Ashland, WV-OH-KY', short_name: 'Charleston, WV', internal_name: 'charleston-huntington-ashland-wv-oh-ky').first_or_create
GeoCode::Csa.where(name: 'Charlotte-Concord, NC-SC', short_name: 'Charlotte, NC', internal_name: 'charlotte-concord-nc-sc').first_or_create
GeoCode::Csa.where(name: 'Chattanooga-Cleveland-Dalton, TN-GA-AL', short_name: 'Chattanooga, TN', internal_name: 'chattanooga-cleveland-dalton-tn-ga-al').first_or_create
GeoCode::Csa.where(name: 'Chicago-Naperville, IL-IN-WI', short_name: 'Chicago, IL', internal_name: 'chicago-naperville-il-in-wi').first_or_create
GeoCode::Csa.where(name: 'Cincinnati-Wilmington-Maysville, OH-KY-IN', short_name: 'Cincinnati, OH', internal_name: 'cincinnati-wilmington-maysville-oh-ky-in').first_or_create
GeoCode::Csa.where(name: 'Spokane-Spokane Valley-Coeur dAlene, WA-ID', short_name: 'Spokane, WA', internal_name: 'spokane-spokane-valley-coeur-dalene-wa-id').first_or_create
GeoCode::Csa.where(name: 'Columbia-Moberly-Mexico, MO', short_name: 'Columbia, MO', internal_name: 'columbia-moberly-mexico-mo').first_or_create
GeoCode::Csa.where(name: 'Columbia-Orangeburg-Newberry, SC', short_name: 'Columbia, SC', internal_name: 'columbia-orangeburg-newberry-sc').first_or_create
GeoCode::Csa.where(name: 'Indianapolis-Carmel-Muncie, IN', short_name: 'Indianapolis, IN', internal_name: 'indianapolis-carmel-muncie-in').first_or_create
GeoCode::Csa.where(name: 'Columbus-Marion-Zanesville, OH', short_name: 'Columbus, OH', internal_name: 'columbus-marion-zanesville-oh').first_or_create
GeoCode::Csa.where(name: 'Corpus Christi-Kingsville-Alice, TX', short_name: 'Corpus Christi, TX', internal_name: 'corpus-christi-kingsville-alice-tx').first_or_create
GeoCode::Csa.where(name: 'Dallas-Fort Worth, TX-OK', short_name: 'Dallas, TX', internal_name: 'dallas-fort-worth-tx-ok').first_or_create
GeoCode::Csa.where(name: 'Mobile-Daphne-Fairhope, AL', short_name: 'Mobile, AL', internal_name: 'mobile-daphne-fairhope-al').first_or_create
GeoCode::Csa.where(name: 'Davenport-Moline, IA-IL', short_name: 'Davenport, IA', internal_name: 'davenport-moline-ia-il').first_or_create
GeoCode::Csa.where(name: 'Dayton-Springfield-Sidney, OH', short_name: 'Dayton, OH', internal_name: 'dayton-springfield-sidney-oh').first_or_create
GeoCode::Csa.where(name: 'Huntsville-Decatur-Albertville, AL', short_name: 'Huntsville, AL', internal_name: 'huntsville-decatur-albertville-al').first_or_create
GeoCode::Csa.where(name: 'Orlando-Deltona-Daytona Beach, FL', short_name: 'Orlando, FL', internal_name: 'orlando-deltona-daytona-beach-fl').first_or_create
GeoCode::Csa.where(name: 'Dothan-Enterprise-Ozark, AL', short_name: 'Dothan, AL', internal_name: 'dothan-enterprise-ozark-al').first_or_create
GeoCode::Csa.where(name: 'Raleigh-Durham-Chapel Hill, NC', short_name: 'Raleigh, NC', internal_name: 'raleigh-durham-chapel-hill-nc').first_or_create
GeoCode::Csa.where(name: 'Eau Claire-Menomonie, WI', short_name: 'Eau Claire, WI', internal_name: 'eau-claire-menomonie-wi').first_or_create
GeoCode::Csa.where(name: 'Louisville-Jefferson County--Elizabethtown--Madison, KY-IN', short_name: 'Louisville, KY', internal_name: 'louisville-jefferson-county--elizabethtown--madison-ky-in').first_or_create
GeoCode::Csa.where(name: 'South Bend-Elkhart-Mishawaka, IN-MI', short_name: 'South Bend, IN', internal_name: 'south-bend-elkhart-mishawaka-in-mi').first_or_create
GeoCode::Csa.where(name: 'Elmira-Corning, NY', short_name: 'Elmira, NY', internal_name: 'elmira-corning-ny').first_or_create
GeoCode::Csa.where(name: 'El Paso-Las Cruces, TX-NM', short_name: 'El Paso, TX', internal_name: 'el-paso-las-cruces-tx-nm').first_or_create
GeoCode::Csa.where(name: 'Erie-Meadville, PA', short_name: 'Erie, PA', internal_name: 'erie-meadville-pa').first_or_create
GeoCode::Csa.where(name: 'Fargo-Wahpeton, ND-MN', short_name: 'Fargo, ND', internal_name: 'fargo-wahpeton-nd-mn').first_or_create
GeoCode::Csa.where(name: 'Fayetteville-Lumberton-Laurinburg, NC', short_name: 'Fayetteville, NC', internal_name: 'fayetteville-lumberton-laurinburg-nc').first_or_create
GeoCode::Csa.where(name: 'Fort Wayne-Huntington-Auburn, IN', short_name: 'Fort Wayne, IN', internal_name: 'fort-wayne-huntington-auburn-in').first_or_create
GeoCode::Csa.where(name: 'Fresno-Madera, CA', short_name: 'Fresno, CA', internal_name: 'fresno-madera-ca').first_or_create
GeoCode::Csa.where(name: 'Gainesville-Lake City, FL', short_name: 'Gainesville, FL', internal_name: 'gainesville-lake-city-fl').first_or_create
GeoCode::Csa.where(name: 'Harrisburg-York-Lebanon, PA', short_name: 'Harrisburg, PA', internal_name: 'harrisburg-york-lebanon-pa').first_or_create
GeoCode::Csa.where(name: 'Grand Rapids-Wyoming-Muskegon, MI', short_name: 'Grand Rapids, MI', internal_name: 'grand-rapids-wyoming-muskegon-mi').first_or_create
GeoCode::Csa.where(name: 'Medford-Grants Pass, OR', short_name: 'Medford, OR', internal_name: 'medford-grants-pass-or').first_or_create
GeoCode::Csa.where(name: 'Green Bay-Shawano, WI', short_name: 'Green Bay, WI', internal_name: 'green-bay-shawano-wi').first_or_create
GeoCode::Csa.where(name: 'Greenville-Washington, NC', short_name: 'Greenville, NC', internal_name: 'greenville-washington-nc').first_or_create
GeoCode::Csa.where(name: 'Greenville-Spartanburg-Anderson, SC', short_name: 'Greenville, SC', internal_name: 'greenville-spartanburg-anderson-sc').first_or_create
GeoCode::Csa.where(name: 'New Orleans-Metairie-Hammond, LA-MS', short_name: 'New Orleans, LA', internal_name: 'new-orleans-metairie-hammond-la-ms').first_or_create
GeoCode::Csa.where(name: 'Visalia-Porterville-Hanford, CA', short_name: 'Visalia, CA', internal_name: 'visalia-porterville-hanford-ca').first_or_create
GeoCode::Csa.where(name: 'Harrisonburg-Staunton-Waynesboro, VA', short_name: 'Harrisonburg, VA', internal_name: 'harrisonburg-staunton-waynesboro-va').first_or_create
GeoCode::Csa.where(name: 'Hartford-West Hartford, CT', short_name: 'Hartford, CT', internal_name: 'hartford-west-hartford-ct').first_or_create
GeoCode::Csa.where(name: 'Hickory-Lenoir, NC', short_name: 'Hickory, NC', internal_name: 'hickory-lenoir-nc').first_or_create
GeoCode::Csa.where(name: 'Savannah-Hinesville-Statesboro, GA', short_name: 'Savannah, GA', internal_name: 'savannah-hinesville-statesboro-ga').first_or_create
GeoCode::Csa.where(name: 'Hot Springs-Malvern, AR', short_name: 'Hot Springs, AR', internal_name: 'hot-springs-malvern-ar').first_or_create
GeoCode::Csa.where(name: 'Houston-The Woodlands, TX', short_name: 'Houston, TX', internal_name: 'houston-the-woodlands-tx').first_or_create
GeoCode::Csa.where(name: 'Idaho Falls-Rexburg-Blackfoot, ID', short_name: 'Idaho Falls, ID', internal_name: 'idaho-falls-rexburg-blackfoot-id').first_or_create
GeoCode::Csa.where(name: 'Ithaca-Cortland, NY', short_name: 'Ithaca, NY', internal_name: 'ithaca-cortland-ny').first_or_create
GeoCode::Csa.where(name: 'Jackson-Vicksburg-Brookhaven, MS', short_name: 'Jackson, MS', internal_name: 'jackson-vicksburg-brookhaven-ms').first_or_create
GeoCode::Csa.where(name: 'Jacksonville-St. Marys-Palatka, FL-GA', short_name: 'Jacksonville, FL', internal_name: 'jacksonville-st-marys-palatka-fl-ga').first_or_create
GeoCode::Csa.where(name: 'Madison-Janesville-Beloit, WI', short_name: 'Madison, WI', internal_name: 'madison-janesville-beloit-wi').first_or_create
GeoCode::Csa.where(name: 'Johnson City-Kingsport-Bristol, TN-VA', short_name: 'Johnson City, TN', internal_name: 'johnson-city-kingsport-bristol-tn-va').first_or_create
GeoCode::Csa.where(name: 'Johnstown-Somerset, PA', short_name: 'Johnstown, PA', internal_name: 'johnstown-somerset-pa').first_or_create
GeoCode::Csa.where(name: 'Jonesboro-Paragould, AR', short_name: 'Jonesboro, AR', internal_name: 'jonesboro-paragould-ar').first_or_create
GeoCode::Csa.where(name: 'Joplin-Miami, MO-OK', short_name: 'Joplin, MO', internal_name: 'joplin-miami-mo-ok').first_or_create
GeoCode::Csa.where(name: 'Kansas City-Overland Park-Kansas City, MO-KS', short_name: 'Kansas City, MO', internal_name: 'kansas-city-overland-park-kansas-city-mo-ks').first_or_create
GeoCode::Csa.where(name: 'Knoxville-Morristown-Sevierville, TN', short_name: 'Knoxville, TN', internal_name: 'knoxville-morristown-sevierville-tn').first_or_create
GeoCode::Csa.where(name: 'Kokomo-Peru, IN', short_name: 'Kokomo, IN', internal_name: 'kokomo-peru-in').first_or_create
GeoCode::Csa.where(name: 'Lafayette-Opelousas-Morgan City, LA', short_name: 'Lafayette, LA', internal_name: 'lafayette-opelousas-morgan-city-la').first_or_create
GeoCode::Csa.where(name: 'Lafayette-West Lafayette-Frankfort, IN', short_name: 'Lafayette, IN', internal_name: 'lafayette-west-lafayette-frankfort-in').first_or_create
GeoCode::Csa.where(name: 'Las Vegas-Henderson, NV-AZ', short_name: 'Las Vegas, NV', internal_name: 'las-vegas-henderson-nv-az').first_or_create
GeoCode::Csa.where(name: 'Lansing-East Lansing-Owosso, MI', short_name: 'Lansing, MI', internal_name: 'lansing-east-lansing-owosso-mi').first_or_create
GeoCode::Csa.where(name: 'Portland-Lewiston-South Portland, ME', short_name: 'Portland, ME', internal_name: 'portland-lewiston-south-portland-me').first_or_create
GeoCode::Csa.where(name: 'Lexington-Fayette--Richmond--Frankfort, KY', short_name: 'Lexington, KY', internal_name: 'lexington-fayette--richmond--frankfort-ky').first_or_create
GeoCode::Csa.where(name: 'Lima-Van Wert-Celina, OH', short_name: 'Lima, OH', internal_name: 'lima-van-wert-celina-oh').first_or_create
GeoCode::Csa.where(name: 'Lincoln-Beatrice, NE', short_name: 'Lincoln, NE', internal_name: 'lincoln-beatrice-ne').first_or_create
GeoCode::Csa.where(name: 'Little Rock-North Little Rock, AR', short_name: 'Little Rock, AR', internal_name: 'little-rock-north-little-rock-ar').first_or_create
GeoCode::Csa.where(name: 'Longview-Marshall, TX', short_name: 'Longview, TX', internal_name: 'longview-marshall-tx').first_or_create
GeoCode::Csa.where(name: 'Los Angeles-Long Beach, CA', short_name: 'Los Angeles, CA', internal_name: 'los-angeles-long-beach-ca').first_or_create
GeoCode::Csa.where(name: 'Lubbock-Levelland, TX', short_name: 'Lubbock, TX', internal_name: 'lubbock-levelland-tx').first_or_create
GeoCode::Csa.where(name: 'Macon-Warner Robins, GA', short_name: 'Macon, GA', internal_name: 'macon-warner-robins-ga').first_or_create
GeoCode::Csa.where(name: 'Manhattan-Junction City, KS', short_name: 'Manhattan, KS', internal_name: 'manhattan-junction-city-ks').first_or_create
GeoCode::Csa.where(name: 'Mankato-New Ulm-North Mankato, MN', short_name: 'Mankato, MN', internal_name: 'mankato-new-ulm-north-mankato-mn').first_or_create
GeoCode::Csa.where(name: 'Mansfield-Ashland-Bucyrus, OH', short_name: 'Mansfield, OH', internal_name: 'mansfield-ashland-bucyrus-oh').first_or_create
GeoCode::Csa.where(name: 'Mayagüez-San Germán, PR', short_name: 'Mayaguez, PR', internal_name: 'mayaguez-san-german-pr').first_or_create
GeoCode::Csa.where(name: 'McAllen-Edinburg, TX', short_name: 'McAllen, TX', internal_name: 'mcallen-edinburg-tx').first_or_create
GeoCode::Csa.where(name: 'Memphis-Forrest City, TN-MS-AR', short_name: 'Memphis, TN', internal_name: 'memphis-forrest-city-tn-ms-ar').first_or_create
GeoCode::Csa.where(name: 'Modesto-Merced, CA', short_name: 'Modesto, CA', internal_name: 'modesto-merced-ca').first_or_create
GeoCode::Csa.where(name: 'Miami-Fort Lauderdale-Port St. Lucie, FL', short_name: 'Miami, FL', internal_name: 'miami-fort-lauderdale-port-st-lucie-fl').first_or_create
GeoCode::Csa.where(name: 'Midland-Odessa, TX', short_name: 'Midland, TX', internal_name: 'midland-odessa-tx').first_or_create
GeoCode::Csa.where(name: 'Milwaukee-Racine-Waukesha, WI', short_name: 'Milwaukee, WI', internal_name: 'milwaukee-racine-waukesha-wi').first_or_create
GeoCode::Csa.where(name: 'Minneapolis-St. Paul, MN-WI', short_name: 'Minneapolis, MN', internal_name: 'minneapolis-st-paul-mn-wi').first_or_create
GeoCode::Csa.where(name: 'Monroe-Ruston-Bastrop, LA', short_name: 'Monroe, LA', internal_name: 'monroe-ruston-bastrop-la').first_or_create
GeoCode::Csa.where(name: 'Morgantown-Fairmont, WV', short_name: 'Morgantown, WV', internal_name: 'morgantown-fairmont-wv').first_or_create
GeoCode::Csa.where(name: 'Myrtle Beach-Conway, SC-NC', short_name: 'Myrtle Beach, SC', internal_name: 'myrtle-beach-conway-sc-nc').first_or_create
GeoCode::Csa.where(name: 'San Jose-San Francisco-Oakland, CA', short_name: 'San Francisco, CA', internal_name: 'san-jose-san-francisco-oakland-ca').first_or_create
GeoCode::Csa.where(name: 'Nashville-Davidson--Murfreesboro, TN', short_name: 'Nashville, TN', internal_name: 'nashville-davidson--murfreesboro-tn').first_or_create
GeoCode::Csa.where(name: 'New Bern-Morehead City, NC', short_name: 'New Bern, NC', internal_name: 'new-bern-morehead-city-nc').first_or_create
GeoCode::Csa.where(name: 'North Port-Sarasota, FL', short_name: 'North Port, FL', internal_name: 'north-port-sarasota-fl').first_or_create
GeoCode::Csa.where(name: 'Salt Lake City-Provo-Orem, UT', short_name: 'Salt Lake City, UT', internal_name: 'salt-lake-city-provo-orem-ut').first_or_create
GeoCode::Csa.where(name: 'Oklahoma City-Shawnee, OK', short_name: 'Oklahoma City, OK', internal_name: 'oklahoma-city-shawnee-ok').first_or_create
GeoCode::Csa.where(name: 'Omaha-Council Bluffs-Fremont, NE-IA', short_name: 'Omaha, NE', internal_name: 'omaha-council-bluffs-fremont-ne-ia').first_or_create
GeoCode::Csa.where(name: 'Parkersburg-Marietta-Vienna, WV-OH', short_name: 'Parkersburg, WV', internal_name: 'parkersburg-marietta-vienna-wv-oh').first_or_create
GeoCode::Csa.where(name: 'Peoria-Canton, IL', short_name: 'Peoria, IL', internal_name: 'peoria-canton-il').first_or_create
GeoCode::Csa.where(name: 'Pittsburgh-New Castle-Weirton, PA-OH-WV', short_name: 'Pittsburgh, PA', internal_name: 'pittsburgh-new-castle-weirton-pa-oh-wv').first_or_create
GeoCode::Csa.where(name: 'Ponce-Coamo-Santa Isabel, PR', short_name: 'Ponce, PR', internal_name: 'ponce-coamo-santa-isabel-pr').first_or_create
GeoCode::Csa.where(name: 'Pueblo-Cañon City, CO', short_name: 'Pueblo, CO', internal_name: 'pueblo-canon-city-co').first_or_create
GeoCode::Csa.where(name: 'Rapid City-Spearfish, SD', short_name: 'Rapid City, SD', internal_name: 'rapid-city-spearfish-sd').first_or_create
GeoCode::Csa.where(name: 'Redding-Red Bluff, CA', short_name: 'Redding, CA', internal_name: 'redding-red-bluff-ca').first_or_create
GeoCode::Csa.where(name: 'Rochester-Austin, MN', short_name: 'Rochester, MN', internal_name: 'rochester-austin-mn').first_or_create
GeoCode::Csa.where(name: 'Rochester-Batavia-Seneca Falls, NY', short_name: 'Rochester, NY', internal_name: 'rochester-batavia-seneca-falls-ny').first_or_create
GeoCode::Csa.where(name: 'Rockford-Freeport-Rochelle, IL', short_name: 'Rockford, IL', internal_name: 'rockford-freeport-rochelle-il').first_or_create
GeoCode::Csa.where(name: 'Rocky Mount-Wilson-Roanoke Rapids, NC', short_name: 'Rocky Mount, NC', internal_name: 'rocky-mount-wilson-roanoke-rapids-nc').first_or_create
GeoCode::Csa.where(name: 'Rome-Summerville, GA', short_name: 'Rome, GA', internal_name: 'rome-summerville-ga').first_or_create
GeoCode::Csa.where(name: 'Sacramento-Roseville, CA', short_name: 'Sacramento, CA', internal_name: 'sacramento-roseville-ca').first_or_create
GeoCode::Csa.where(name: 'St. Louis-St. Charles-Farmington, MO-IL', short_name: 'St. Louis, MO', internal_name: 'st-louis-st-charles-farmington-mo-il').first_or_create
GeoCode::Csa.where(name: 'Sioux City-Vermillion, IA-SD-NE', short_name: 'Sioux City, IA', internal_name: 'sioux-city-vermillion-ia-sd-ne').first_or_create
GeoCode::Csa.where(name: 'Springfield-Jacksonville-Lincoln, IL', short_name: 'Springfield, IL', internal_name: 'springfield-jacksonville-lincoln-il').first_or_create
GeoCode::Csa.where(name: 'Springfield-Greenfield Town, MA', short_name: 'Springfield, MA', internal_name: 'springfield-greenfield-town-ma').first_or_create
GeoCode::Csa.where(name: 'Springfield-Branson, MO', short_name: 'Springfield, MO', internal_name: 'springfield-branson-mo').first_or_create
GeoCode::Csa.where(name: 'State College-DuBois, PA', short_name: 'State College, PA', internal_name: 'state-college-dubois-pa').first_or_create
GeoCode::Csa.where(name: 'Syracuse-Auburn, NY', short_name: 'Syracuse, NY', internal_name: 'syracuse-auburn-ny').first_or_create
GeoCode::Csa.where(name: 'Tallahassee-Bainbridge, FL-GA', short_name: 'Tallahassee, FL', internal_name: 'tallahassee-bainbridge-fl-ga').first_or_create
GeoCode::Csa.where(name: 'Toledo-Port Clinton, OH', short_name: 'Toledo, OH', internal_name: 'toledo-port-clinton-oh').first_or_create
GeoCode::Csa.where(name: 'Tucson-Nogales, AZ', short_name: 'Tucson, AZ', internal_name: 'tucson-nogales-az').first_or_create
GeoCode::Csa.where(name: 'Tulsa-Muskogee-Bartlesville, OK', short_name: 'Tulsa, OK', internal_name: 'tulsa-muskogee-bartlesville-ok').first_or_create
GeoCode::Csa.where(name: 'Tyler-Jacksonville, TX', short_name: 'Tyler, TX', internal_name: 'tyler-jacksonville-tx').first_or_create
GeoCode::Csa.where(name: 'Victoria-Port Lavaca, TX', short_name: 'Victoria, TX', internal_name: 'victoria-port-lavaca-tx').first_or_create
GeoCode::Csa.where(name: 'Virginia Beach-Norfolk, VA-NC', short_name: 'Virginia Beach, VA', internal_name: 'virginia-beach-norfolk-va-nc').first_or_create
GeoCode::Csa.where(name: 'Wausau-Stevens Point-Wisconsin Rapids, WI', short_name: 'Wausau, WI', internal_name: 'wausau-stevens-point-wisconsin-rapids-wi').first_or_create
GeoCode::Csa.where(name: 'Wichita-Arkansas City-Winfield, KS', short_name: 'Wichita, KS', internal_name: 'wichita-arkansas-city-winfield-ks').first_or_create
GeoCode::Csa.where(name: 'Williamsport-Lock Haven, PA', short_name: 'Williamsport, PA', internal_name: 'williamsport-lock-haven-pa').first_or_create
GeoCode::Csa.where(name: 'Youngstown-Warren, OH-PA', short_name: 'Youngstown, OH', internal_name: 'youngstown-warren-oh-pa').first_or_create
  end

end
