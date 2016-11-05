namespace :defaults do

  #For internal names the syntax for SEO and uniqueness should be to prefix with source, lowercase, use full names, separated by hyphens
  # bls_average_prices

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
    Rails.logger.error("Time to import indicators and series: #{ Time.now _ start } seconds")
  end

  desc "get values"
  task :import_values => :environment do
    start = Time.now
    Rails.logger.error("We have begun importing values, as of: #{start}")

    Bulkload::Bls::ImportValues.new.import_values("ap")
    Bulkload::Bls::ImportValues.new.import_values("bd")

    elapsed = Time.now _ start
    minutes = elapsed.to_i/60
    seconds = elapsed%60
    Rails.logger.error("Time to import values: #{ elapsed } seconds, aka #{minutes} minutes and #{seconds} seconds")
  end

  desc "create defaults"
  task :create => [:category, :source, :dataset,:frequency, :unit, :gender, :race, :age_bracket, :marital_status, :employment_status, :education_level, :child_status, :income_level, :industry_code, :occupation_code, :geo_code, :industry_hierarchy]

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
    Source.where(name: "Bureau of Economic Analysis (BEA)", internal_name: "bureau_economic_analysis").first_or_create
    Source.where(name: "Bureau of Labor Statistics (BLS)", internal_name: "bureau_labor_statistics").first_or_create
  end

  desc "create dataset records"
  task :dataset => :environment do
    Dataset.where(name: "Average Prices", category_id: Category.find_by(name: "Business").id, internal_name: "bls_average_prices", source_id: Source.find_by(internal_name: "bureau_labor_statistics").id, description: "Average prices for goods and services in various cities").first_or_create
    Dataset.where(name: "Business Employment Dynamics", category_id: Category.find_by(name: "Business").id, internal_name: "bls_business_employment_dynamics", source_id: Source.find_by(internal_name: "bureau_labor_statistics").id , description: "Track changes in employment at the establishment level").first_or_create
  end

  desc "create frequency records"
  task :frequency => :environment do
    Frequency.where(name: "Annual", internal_name: :annual, description: "Annual").first_or_create
    Frequency.where(name: "Monthly", internal_name: :monthly, description: "Monthly").first_or_create
    Frequency.where(name: "Quarterly", internal_name: :quarterly, description: "Quarterly").first_or_create
  end

  desc "create unit records"
  task :unit => :environment do
    Unit.where(name: "Nominal US Dollars", internal_name: "nominal_us_dollars" ,description: "US Dollars, not adjusted for inflation" ).first_or_create
    Unit.where(name: "Real US Dollars", internal_name: "real_us_dollars", description: "US Dollars adjusted for inflation" ).first_or_create
    Unit.where(name: "Percent", internal_name: :percent, description: "Typically a percent difference from a prior period").first_or_create
    Unit.where(name: "Jobs or Employees", internal_name: "jobs_or_employees", description: "Number of jobs or employees").first_or_create
    Unit.where(name: "Establishments", internal_name: :establishments, description: "Number of Establishments, primarily businesses.").first_or_create
    Unit.where(name: "Hours", internal_name: "hours", description: "Number of hours").first_or_create
    Unit.where(name: "Index", internal_name: "indexes", description: "Index to a reference value").first_or_create
    Unit.where(name: "Ratio", internal_name: "ratios", description: "Ratio of value to another value").first_or_create
  end

  desc "create gender records"
  task :gender => :environment do
    Gender.where(name: "Not specified", internal_name: "not_specified", description: "Gender not specified or not applicable to this series").first_or_create
    Gender.where(name: "All genders", internal_name: "all_genders", description: "Both male and female genders included in this series").first_or_create
    Gender.where(name: "Male", internal_name: :male, description: "Male").first_or_create
    Gender.where(name: "Female", internal_name: :female, description: "Female").first_or_create
  end

  desc "create race records"
  task :race => :environment do
    Race.where(name: "Not specified", internal_name: "not_specified", description: "Race not specified or not applicable to this series").first_or_create
    Race.where(name: "All races", internal_name: "all_races", description: "All values for race were included in this series").first_or_create
    Race.where(name: "White", internal_name: :white, description: "White").first_or_create
    Race.where(name: "Black", internal_name: :black, description: "Black or African American").first_or_create
    Race.where(name: "Asian", internal_name: :asian, description: "Asian").first_or_create
    Race.where(name: "Hispanic", internal_name: :hispanic, description: "Hispanic. Values for this series are often reported separately and may include values from other series.").first_or_create
  end

  desc "create age bracket records"
  task :age_bracket => :environment do
    AgeBracket.where(name: "Not specified", internal_name: "not_specified", description: "Age ranges were not specified or not applicable to this series").first_or_create
    AgeBracket.where(name: "All age ranges", internal_name: "all_age_ranges", description: "All values for age ranges were included in this series").first_or_create
    AgeBracket.where(name: "No answer provided", internal_name: "no_answer_provided", description: "An age question was asked, no answer was provided").first_or_create

    AgeBracket.where(name: "20_24", internal_name: "20_24", description: "Ages 20_24 inclusive").first_or_create
    AgeBracket.where(name: "25_29", internal_name: "25_29", description: "Ages 25_29 inclusive").first_or_create
    AgeBracket.where(name: "30_34", internal_name: "30_34", description: "Ages 30_34 inclusive").first_or_create
    AgeBracket.where(name: "35_39", internal_name: "35_39", description: "Ages 35_39 inclusive").first_or_create
    AgeBracket.where(name: "40_44", internal_name: "40_44", description: "Ages 40_44 inclusive").first_or_create
    AgeBracket.where(name: "45_49", internal_name: "45_49", description: "Ages 45_49 inclusive").first_or_create
    AgeBracket.where(name: "50_54", internal_name: "50_54", description: "Ages 50_54 inclusive").first_or_create
    AgeBracket.where(name: "55_59", internal_name: "55_59", description: "Ages 55_59 inclusive").first_or_create
    AgeBracket.where(name: "60_64", internal_name: "60_64", description: "Ages 60_64 inclusive").first_or_create
    AgeBracket.where(name: "65+", internal_name: "65+", description: "Age 65 or older, includes 65").first_or_create

    AgeBracket.where(name: "16_19", internal_name: "16_19", description: "Ages 16_19 inclusive").first_or_create
    AgeBracket.where(name: "Under 16", internal_name: "under_16", description: "Less than 16 years of age, excluding 16").first_or_create
    AgeBracket.where(name: "18_24", internal_name: "18_24", description: "Ages 18_24 inclusive").first_or_create
    AgeBracket.where(name: "Under 18", internal_name: "under_18", description: "Less than 18 years of age, excluding 18").first_or_create
    AgeBracket.where(name: "Under 5", internal_name: "under_5", description: "Less than 5 years of age, excluding 5").first_or_create
    AgeBracket.where(name: "05_17", internal_name: "05_17", description: "Ages 5_17 inclusive").first_or_create

    AgeBracket.where(name: "20_29", internal_name: "20_29", description: "Ages 20_29 inclusive").first_or_create
    AgeBracket.where(name: "30_39", internal_name: "30_39", description: "Ages 30_39 inclusive").first_or_create
    AgeBracket.where(name: "40_49", internal_name: "40_49", description: "Ages 40_49 inclusive").first_or_create
    AgeBracket.where(name: "50_59", internal_name: "50_59", description: "Ages 50_59 inclusive").first_or_create
    AgeBracket.where(name: "60_69", internal_name: "60_69", description: "Ages 60_69 inclusive").first_or_create
    AgeBracket.where(name: "70+", internal_name: "70+", description: "Age 70 or older, includes 70").first_or_create

    AgeBracket.where(name: "25_34", internal_name: "25_34", description: "Ages 25_34 inclusive").first_or_create
    AgeBracket.where(name: "35_44", internal_name: "35_44", description: "Ages 35_44 inclusive").first_or_create
    AgeBracket.where(name: "45_54", internal_name: "45_54", description: "Ages 45_54 inclusive").first_or_create
    AgeBracket.where(name: "55_64", internal_name: "55_64", description: "Ages 55_64 inclusive").first_or_create
    # AgeBracket.where(name: "65+", description: "Age 65 or older, includes 65").first_or_create
  end

  desc "create marital status records"
  task :marital_status => :environment do
    MaritalStatus.where(name: "Not specified", internal_name: "not_specified", description: "Marital status not specified or not applicable to this series").first_or_create
    MaritalStatus.where(name: "All marital statuses", internal_name: "all_marital_statuses", description: "All values for marital status were included in this series").first_or_create
    MaritalStatus.where(name: "Annulled", internal_name: "annulled", description: "Marriage contract has been declared null and to not have existed").first_or_create
    MaritalStatus.where(name: "Divorced", internal_name: "divorced", description: "Marriage contract has been declared dissolved and inactive").first_or_create
    MaritalStatus.where(name: "Divorce proceeding", internal_name: "divorce_proceeding", description: "Divorce proceedings have begun but not concluded. Also called interlocutory").first_or_create
    MaritalStatus.where(name: "Legally separated", internal_name: "legally_separated", description: "Legally separated").first_or_create
    MaritalStatus.where(name: "Married", internal_name: "married", description: "A marriage contract is currently active, spouses intend to live together").first_or_create
    MaritalStatus.where(name: "Polygamous", internal_name: "polygamous", description: "More than one current spouse").first_or_create
    MaritalStatus.where(name: "Never married", internal_name: "never_married", description: "No marriage contract has ever been entered").first_or_create
    MaritalStatus.where(name: "Domestic partner", internal_name: "domestic_partner", description: "Person declared that a domestic partner relationship exists").first_or_create
    MaritalStatus.where(name: "Spouse absent", internal_name: "spouse_absent", description: "Married, but not living together").first_or_create
    MaritalStatus.where(name: "No answer provided", internal_name: "no_answer_provided", description: "The question of marital status was posed but no answer was provided").first_or_create
  end

  desc "create employment status records"
  task :employment_status => :environment do
    EmploymentStatus.where(name: "Not specified", internal_name: "not_specified", description: "This series does not have employment as an attribute").first_or_create
    EmploymentStatus.where(name: "All employment statuses", internal_name: "all_employment_statuses", description: "Employment is a series attribute and all values are included").first_or_create
    EmploymentStatus.where(name: "No answer provided", internal_name: "no_answer_provided", description: "Employment is a series attribute however no value was recorded").first_or_create

    EmploymentStatus.where(name: "Employed full time", internal_name: "employed_full_time", description: "Employed full time").first_or_create
    EmploymentStatus.where(name: "Employed part time", internal_name: "employed_part_time", description: "Employed part time").first_or_create
    EmploymentStatus.where(name: "Self employed", internal_name: "self_employed", description: "Runs their own business, not employed by others").first_or_create
    EmploymentStatus.where(name: "Retired", internal_name: "retired", description: "Retired from work").first_or_create
    EmploymentStatus.where(name: "Not employed - All Reasons", internal_name: "not_employed_all_reasons", description: "Includes all reasons for not being employed").first_or_create
    EmploymentStatus.where(name: "Not employed - Did not search", internal_name: "not_employed_did_not_search", description: "Did not search for work in previous year").first_or_create
    EmploymentStatus.where(name: "Not employed - Searched", internal_name: "not_employed_searched", description: "Searched for work in previous year").first_or_create
    EmploymentStatus.where(name: "Not employed - Discouraged", internal_name: "not_employed_discouraged", description: "Discouraged over job prospects, believe no job is available").first_or_create
    EmploymentStatus.where(name: "Not employed - Family", internal_name: "not_employed_family", description: "Family responsibilities prevent work").first_or_create
    EmploymentStatus.where(name: "Not employed - School", internal_name: "not_employed_school", description: "Currently in school or training").first_or_create
    EmploymentStatus.where(name: "Not employed - Ill", internal_name: "not_employed_ill", description: "Ill health or disability prevents work").first_or_create
    EmploymentStatus.where(name: "Not employed - Other", internal_name: "not_employed_other", description: "Other reason for not able to work, including transportation problems").first_or_create
  end

  desc "create education level records"
  task :education_level => :environment do
    EducationLevel.where(name: "Not specified", internal_name: "not_specified", description: "This series does not have education level as an attribute").first_or_create
    EducationLevel.where(name: "All education levels", internal_name: "all_education_levels", description: "Education level is a series attribute and all values are included").first_or_create
    EducationLevel.where(name: "No answer provided", internal_name: "no_answer_provided", description: "Education is a series attribute however no value was recorded").first_or_create

    EducationLevel.where(name: "Some High School or High School Graduate", internal_name: "all_high_school", description: "Some High School or High School Graduate").first_or_create
    EducationLevel.where(name: "Less than a High School diploma", internal_name: "less_than_high_school", description: "Less than a High School diploma").first_or_create
    EducationLevel.where(name: "Less than 1 year of High School", internal_name: "less_than_1_year_high_school", description: "Less than 1 year of High School").first_or_create
    EducationLevel.where(name: "4 years of High School, no diploma", internal_name: "4_year_high_school_no_diploma", description: "4 years of High School, no diploma").first_or_create
    EducationLevel.where(name: "High School graduates, no college", internal_name: "high_school_graduate_no_college", description: "High School graduates, no college").first_or_create
    EducationLevel.where(name: "Some college or associate degree", internal_name: "some_college", description: "Some college or associate degree").first_or_create
    EducationLevel.where(name: "Some college, no degree", internal_name: "some_college_no_degree", description: "Some college, no degree").first_or_create
    EducationLevel.where(name: "Associate degree", internal_name: "associate_degree", description: "Associate degree").first_or_create
    EducationLevel.where(name: "Associate degree, occupational program", internal_name: "associate_degree_occupational", description: "Associate degree, occupational program").first_or_create
    EducationLevel.where(name: "Associate degree, academic program", internal_name: "associate_degree_academic", description: "Associate degree, academic program").first_or_create
    EducationLevel.where(name: "Bachelor's degree and higher", internal_name: "bachelors_degree_and_higher", description: "Bachelor's degree and higher").first_or_create
    EducationLevel.where(name: "Bachelor's degree only", internal_name: "bachelors_degree_only", description: "Bachelor's degree only").first_or_create
    EducationLevel.where(name: "Advanced degree", internal_name: "advanced_degree", description: "Advanced degree").first_or_create
    EducationLevel.where(name: "Master's degree", internal_name: "masters_degree", description: "Master's degree").first_or_create
    EducationLevel.where(name: "Professional degree", internal_name: "professional_degree", description: "Professional degree").first_or_create
    EducationLevel.where(name: "Doctoral degree", internal_name: "doctoral_degree", description: "Doctoral degree").first_or_create
  end

  desc "create child status records"
  task :child_status => :environment do
    ChildStatus.where(name: "Not specified", internal_name: "not_specified", description: "This series does not have education level as an attribute").first_or_create
    ChildStatus.where(name: "All child statuses", internal_name: "all_child_statuses", description: "Education level is a series attribute and all values are included").first_or_create
    ChildStatus.where(name: "No answer provided", internal_name: "no_answer_provided", description: "Education is a series attribute however no value was recorded").first_or_create

    #We need to refine these as more child in household definitions are encountered.
    ChildStatus.where(name: "No child present in household under 18", internal_name: "no_child_present", description: "No child present in household under 18").first_or_create
    ChildStatus.where(name: "Child under 6 present", internal_name: "child_under_6_present", description: "Child under 6 present").first_or_create
    ChildStatus.where(name: "Child 6_12 present", internal_name: "child_6_12_present", description: "Child 6_12 present").first_or_create
    ChildStatus.where(name: "Child 13_17 present", internal_name: "child_13_17_present", description: "Child 13_17 present").first_or_create
    ChildStatus.where(name: "Child under 18 present", internal_name: "child_under_18_present", description: "Child under 18 present").first_or_create
    ChildStatus.where(name: "Child under 3 present", internal_name: "child_under_3_present", description: "Child under 3 present").first_or_create
  end

  desc "create income level records"
  task :income_level => :environment do
    IncomeLevel.where(name: "Not specified", internal_name: "not_specified", description: "This series does not have income level as an attribute").first_or_create
    IncomeLevel.where(name: "All income levels", internal_name: "all_income_levels", description: "Income level is a series attribute and all values are included").first_or_create
    IncomeLevel.where(name: "No answer provided", internal_name: "no_answer_provided", description: "Income is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

  end

  desc "create industry code records"
  task :industry_code => :environment do
    IndustryCode.where(name: "Not specified", internal_name: "not_specified", description: "This series does not have industry as an attribute").first_or_create
    IndustryCode.where(name: "All industries", internal_name: "all_industries", description: "Industry is a series attribute and all values are included").first_or_create
    IndustryCode.where(name: "No answer provided", internal_name: "no_answer_provided", description: "Industry is a series attribute however no value was recorded").first_or_create
    IndustryCode.where(name: "Not elsewhere classified", internal_name: "not_elsewhere_classified", description: "Industry is a series attribute but it does not map to our classification, see raw value for details").first_or_create

    #Alternative groupings of industries, not typically specified in NAICS
    IndustryCode.where(name: "All private industry", internal_name: "all_private_industry", description: "Includes all private industry, excludes government").first_or_create
    IndustryCode.where(name: "All government", internal_name: "all_government", description: "Includes all government functions, excludes private industry").first_or_create
    IndustryCode.where(name: "Federal government", internal_name: "federal_government", description: "Includes federal government functions").first_or_create
    IndustryCode.where(name: "Federal government except postal service", internal_name: "federal_government_except_postal_service", description: "Includes federal government functions except the USPS").first_or_create
    IndustryCode.where(name: "Federal hospitals", internal_name: "federal_hospitals", description: "Includes federal hospitals").first_or_create
    IndustryCode.where(name: "Department of Defense", internal_name: "department_of_defense", description: "Department of Defense").first_or_create
    IndustryCode.where(name: "US Postal Service", internal_name: "us_postal_service", description: "Includes U.S. postal service").first_or_create
    IndustryCode.where(name: "State government", internal_name: "state_government", description: "Includes all state government functions").first_or_create
    IndustryCode.where(name: "State education", internal_name: "state_education", description: "Includes state government funded education programs").first_or_create
    IndustryCode.where(name: "State hospitals", internal_name: "state_hospitals", description: "Includes state government funded hospitals").first_or_create
    IndustryCode.where(name: "State administration", internal_name: "state_administration", description: "Includes state government general administrative costs").first_or_create
    IndustryCode.where(name: "Local government", internal_name: "local_government", description: "Includes all local government functions").first_or_create
    IndustryCode.where(name: "Local education", internal_name: "local_education", description: "Includes local government education programs").first_or_create
    IndustryCode.where(name: "Local utilities", internal_name: "local_utilities", description: "Includes local government utility programs").first_or_create
    IndustryCode.where(name: "Local transportation", internal_name: "local_transportation", description: "Includes local government transportation programs").first_or_create
    IndustryCode.where(name: "Local hospitals", internal_name: "local_hospitals", description: "Includes local government hospitals").first_or_create
    IndustryCode.where(name: "Local administration", internal_name: "local_administration", description: "Includes local government general and administrative functions").first_or_create

    # Goods and Services
    IndustryCode.where(name: "All goods producers", internal_name: "all_goods_producers", description: "Companies that manufacture and sell physical goods").first_or_create
    IndustryCode.where(name: "All service providers", internal_name: "all_service_providers", description: "Service providing companies").first_or_create
    IndustryCode.where(name: "Private service providers", internal_name: "private_service_providers", description: "Private service providing companies").first_or_create
    IndustryCode.where(name: "Durable goods", internal_name: "durable_goods", description: "Companies that manufacture and sell durable goods").first_or_create
    IndustryCode.where(name: "Nondurable goods", internal_name: "nondurable_goods", description: "Companies that manufacture and sell nondurable goods").first_or_create
    IndustryCode.where(name: "Trade, Transportation, and Utilities", internal_name: "trade_transportation_and_utilities", description: "All industries in trade, transportation, and utilities.").first_or_create


    #NAICS sectors
    IndustryCode.where(name: "Agriculture, Forestry, Fishing and Hunting", internal_name: "agriculture_forestry_fishing_and_hunting", industry_type: :sector, naics_code: "11").first_or_create
    IndustryCode.where(name: "Mining, Quarrying, and Oil and Gas Extraction", internal_name: "mining_quarrying_and_oil_and_gas_extraction", industry_type: :sector, naics_code: "21").first_or_create
    IndustryCode.where(name: "Utilities", internal_name: "utilities", industry_type: :sector, naics_code: "22").first_or_create
    IndustryCode.where(name: "Construction", internal_name: "construction", industry_type: :sector, naics_code: "23").first_or_create
    IndustryCode.where(name: "Manufacturing", internal_name: "manufacturing", industry_type: :sector, naics_code: "31").first_or_create
    IndustryCode.where(name: "Wholesale Trade", internal_name: "wholesale_trade", industry_type: :sector, naics_code: "42").first_or_create
    IndustryCode.where(name: "Retail Trade", internal_name: "retail_trade", industry_type: :sector, naics_code: "44").first_or_create
    IndustryCode.where(name: "Transportation and Warehousing", internal_name: "transportation_and_warehousing", industry_type: :sector, naics_code: "48").first_or_create

    IndustryCode.where(name: "Information", internal_name: "information", industry_type: :sector, naics_code: "51").first_or_create
    IndustryCode.where(name: "Finance and Insurance", internal_name: "finance_and_insurance", industry_type: :sector, naics_code: "52").first_or_create
    IndustryCode.where(name: "Real Estate and Rental and Leasing", internal_name: "real_estate_and_rental_and_leasing", industry_type: :sector, naics_code: "53").first_or_create
    IndustryCode.where(name: "Professional, Scientific, and Technical Services", internal_name: "professional_scientific_and_technical_services", industry_type: :sector, naics_code: "54").first_or_create
    IndustryCode.where(name: "Management of Companies and Enterprises", internal_name: "management_of_companies_and_enterprises", industry_type: :sector, naics_code: "55").first_or_create
    IndustryCode.where(name: "Administrative and Support and Waste Management and Remediation Services", internal_name: "administrative_and_support_and_waste_management_and_remediation_services", industry_type: :sector, naics_code: "56").first_or_create
    IndustryCode.where(name: "Educational Services", internal_name: "educational_services", industry_type: :sector, naics_code: "61").first_or_create
    IndustryCode.where(name: "Health Care and Social Assistance", internal_name: "health_care_and_social_assistance", industry_type: :sector, naics_code: "62").first_or_create
    IndustryCode.where(name: "Arts, Entertainment, and Recreation", internal_name: "arts_entertainment_and_recreation", industry_type: :sector, naics_code: "71").first_or_create
    IndustryCode.where(name: "Accommodation and Food Services", internal_name: "accommodation_and_food_services", industry_type: :sector, naics_code: "72").first_or_create
    IndustryCode.where(name: "Other Services (except Public Administration)", internal_name: "other_services_except_public_administration", industry_type: :sector, naics_code: "81").first_or_create
    IndustryCode.where(name: "Public Administration", internal_name: "public_administration", industry_type: :sector, naics_code: "92").first_or_create

    #NAICS subsectors
    IndustryCode.where(name: "Crop Production", internal_name: "crop_production", industry_type: :subsector, naics_code: "111").first_or_create
    IndustryCode.where(name: "Animal Production and Aquaculture", internal_name: "animal_production_and_aquaculture", industry_type: :subsector, naics_code: "112").first_or_create
    IndustryCode.where(name: "Forestry and Logging", internal_name: "forestry_and_logging", industry_type: :subsector, naics_code: "113").first_or_create
    IndustryCode.where(name: "Fishing, Hunting and Trapping", internal_name: "fishing_hunting_and_trapping", industry_type: :subsector, naics_code: "114").first_or_create
    IndustryCode.where(name: "Support Activities for Agriculture and Forestry", internal_name: "support_activities_for_agriculture_and_forestry", industry_type: :subsector, naics_code: "115").first_or_create
    IndustryCode.where(name: "Oil and Gas Extraction", internal_name: "oil_and_gas_extraction", industry_type: :subsector, naics_code: "211").first_or_create
    IndustryCode.where(name: "Mining (except Oil and Gas)", internal_name: "mining_except_oil_and_gas", industry_type: :subsector, naics_code: "212").first_or_create
    IndustryCode.where(name: "Support Activities for Mining", internal_name: "support_activities_for_mining", industry_type: :subsector, naics_code: "213").first_or_create
    IndustryCode.where(name: "Utilities", internal_name: "utilities", industry_type: :subsector, naics_code: "221").first_or_create
    IndustryCode.where(name: "Construction of Buildings", internal_name: "construction_of_buildings", industry_type: :subsector, naics_code: "236").first_or_create
    IndustryCode.where(name: "Heavy and Civil Engineering Construction", internal_name: "heavy_and_civil_engineering_construction", industry_type: :subsector, naics_code: "237").first_or_create
    IndustryCode.where(name: "Specialty Trade Contractors", internal_name: "specialty_trade_contractors", industry_type: :subsector, naics_code: "238").first_or_create
    IndustryCode.where(name: "Food Manufacturing", internal_name: "food_manufacturing", industry_type: :subsector, naics_code: "311").first_or_create
    IndustryCode.where(name: "Beverage and Tobacco Product Manufacturing", internal_name: "beverage_and_tobacco_product_manufacturing", industry_type: :subsector, naics_code: "312").first_or_create
    IndustryCode.where(name: "Textile Mills", internal_name: "textile_mills", industry_type: :subsector, naics_code: "313").first_or_create
    IndustryCode.where(name: "Textile Product Mills", internal_name: "textile_product_mills", industry_type: :subsector, naics_code: "314").first_or_create
    IndustryCode.where(name: "Apparel Manufacturing", internal_name: "apparel_manufacturing", industry_type: :subsector, naics_code: "315").first_or_create
    IndustryCode.where(name: "Leather and Allied Product Manufacturing", internal_name: "leather_and_allied_product_manufacturing", industry_type: :subsector, naics_code: "316").first_or_create
    IndustryCode.where(name: "Wood Product Manufacturing", internal_name: "wood_product_manufacturing", industry_type: :subsector, naics_code: "321").first_or_create
    IndustryCode.where(name: "Paper Manufacturing", internal_name: "paper_manufacturing", industry_type: :subsector, naics_code: "322").first_or_create
    IndustryCode.where(name: "Printing and Related Support Activities", internal_name: "printing_and_related_support_activities", industry_type: :subsector, naics_code: "323").first_or_create
    IndustryCode.where(name: "Petroleum and Coal Products Manufacturing", internal_name: "petroleum_and_coal_products_manufacturing", industry_type: :subsector, naics_code: "324").first_or_create
    IndustryCode.where(name: "Chemical Manufacturing", internal_name: "chemical_manufacturing", industry_type: :subsector, naics_code: "325").first_or_create
    IndustryCode.where(name: "Plastics and Rubber Products Manufacturing", internal_name: "plastics_and_rubber_products_manufacturing", industry_type: :subsector, naics_code: "326").first_or_create
    IndustryCode.where(name: "Nonmetallic Mineral Product Manufacturing", internal_name: "nonmetallic_mineral_product_manufacturing", industry_type: :subsector, naics_code: "327").first_or_create
    IndustryCode.where(name: "Primary Metal Manufacturing", internal_name: "primary_metal_manufacturing", industry_type: :subsector, naics_code: "331").first_or_create
    IndustryCode.where(name: "Fabricated Metal Product Manufacturing", internal_name: "fabricated_metal_product_manufacturing", industry_type: :subsector, naics_code: "332").first_or_create
    IndustryCode.where(name: "Machinery Manufacturing", internal_name: "machinery_manufacturing", industry_type: :subsector, naics_code: "333").first_or_create
    IndustryCode.where(name: "Computer and Electronic Product Manufacturing", internal_name: "computer_and_electronic_product_manufacturing", industry_type: :subsector, naics_code: "334").first_or_create
    IndustryCode.where(name: "Electrical Equipment, Appliance, and Component Manufacturing", internal_name: "electrical_equipment_appliance_and_component_manufacturing", industry_type: :subsector, naics_code: "335").first_or_create
    IndustryCode.where(name: "Transportation Equipment Manufacturing", internal_name: "transportation_equipment_manufacturing", industry_type: :subsector, naics_code: "336").first_or_create
    IndustryCode.where(name: "Furniture and Related Product Manufacturing", internal_name: "furniture_and_related_product_manufacturing", industry_type: :subsector, naics_code: "337").first_or_create
    IndustryCode.where(name: "Miscellaneous Manufacturing", internal_name: "miscellaneous_manufacturing", industry_type: :subsector, naics_code: "339").first_or_create
    IndustryCode.where(name: "Merchant Wholesalers, Durable Goods", internal_name: "merchant_wholesalers_durable_goods", industry_type: :subsector, naics_code: "423").first_or_create
    IndustryCode.where(name: "Merchant Wholesalers, Nondurable Goods", internal_name: "merchant_wholesalers_nondurable_goods", industry_type: :subsector, naics_code: "424").first_or_create
    IndustryCode.where(name: "Wholesale Electronic Markets and Agents and Brokers", internal_name: "wholesale_electronic_markets_and_agents_and_brokers", industry_type: :subsector, naics_code: "425").first_or_create
    IndustryCode.where(name: "Motor Vehicle and Parts Dealers", internal_name: "motor_vehicle_and_parts_dealers", industry_type: :subsector, naics_code: "441").first_or_create
    IndustryCode.where(name: "Furniture and Home Furnishings Stores", internal_name: "furniture_and_home_furnishings_stores", industry_type: :subsector, naics_code: "442").first_or_create
    IndustryCode.where(name: "Electronics and Appliance Stores", internal_name: "electronics_and_appliance_stores", industry_type: :subsector, naics_code: "443").first_or_create
    IndustryCode.where(name: "Building Material and Garden Equipment and Supplies Dealers", internal_name: "building_material_and_garden_equipment_and_supplies_dealers", industry_type: :subsector, naics_code: "444").first_or_create
    IndustryCode.where(name: "Food and Beverage Stores", internal_name: "food_and_beverage_stores", industry_type: :subsector, naics_code: "445").first_or_create
    IndustryCode.where(name: "Health and Personal Care Stores", internal_name: "health_and_personal_care_stores", industry_type: :subsector, naics_code: "446").first_or_create
    IndustryCode.where(name: "Gasoline Stations", internal_name: "gasoline_stations", industry_type: :subsector, naics_code: "447").first_or_create
    IndustryCode.where(name: "Clothing and Clothing Accessories Stores", internal_name: "clothing_and_clothing_accessories_stores", industry_type: :subsector, naics_code: "448").first_or_create
    IndustryCode.where(name: "Sporting Goods, Hobby, Musical Instrument, and Book Stores", internal_name: "sporting_goods_hobby_musical_instrument_and_book_stores", industry_type: :subsector, naics_code: "451").first_or_create
    IndustryCode.where(name: "General Merchandise Stores", internal_name: "general_merchandise_stores", industry_type: :subsector, naics_code: "452").first_or_create
    IndustryCode.where(name: "Miscellaneous Store Retailers", internal_name: "miscellaneous_store_retailers", industry_type: :subsector, naics_code: "453").first_or_create
    IndustryCode.where(name: "Nonstore Retailers", internal_name: "nonstore_retailers", industry_type: :subsector, naics_code: "454").first_or_create
    IndustryCode.where(name: "Air Transportation", internal_name: "air_transportation", industry_type: :subsector, naics_code: "481").first_or_create
    IndustryCode.where(name: "Rail Transportation", internal_name: "rail_transportation", industry_type: :subsector, naics_code: "482").first_or_create
    IndustryCode.where(name: "Water Transportation", internal_name: "water_transportation", industry_type: :subsector, naics_code: "483").first_or_create
    IndustryCode.where(name: "Truck Transportation", internal_name: "truck_transportation", industry_type: :subsector, naics_code: "484").first_or_create
    IndustryCode.where(name: "Transit and Ground Passenger Transportation", internal_name: "transit_and_ground_passenger_transportation", industry_type: :subsector, naics_code: "485").first_or_create
    IndustryCode.where(name: "Pipeline Transportation", internal_name: "pipeline_transportation", industry_type: :subsector, naics_code: "486").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation", internal_name: "scenic_and_sightseeing_transportation", industry_type: :subsector, naics_code: "487").first_or_create
    IndustryCode.where(name: "Support Activities for Transportation", internal_name: "support_activities_for_transportation", industry_type: :subsector, naics_code: "488").first_or_create
    IndustryCode.where(name: "Postal Service", internal_name: "postal_service", industry_type: :subsector, naics_code: "491").first_or_create
    IndustryCode.where(name: "Couriers and Messengers", internal_name: "couriers_and_messengers", industry_type: :subsector, naics_code: "492").first_or_create
    IndustryCode.where(name: "Warehousing and Storage", internal_name: "warehousing_and_storage", industry_type: :subsector, naics_code: "493").first_or_create
    IndustryCode.where(name: "Publishing Industries (except Internet)", internal_name: "publishing_industries_except_internet", industry_type: :subsector, naics_code: "511").first_or_create
    IndustryCode.where(name: "Motion Picture and Sound Recording Industries", internal_name: "motion_picture_and_sound_recording_industries", industry_type: :subsector, naics_code: "512").first_or_create
    IndustryCode.where(name: "Broadcasting (except Internet)", internal_name: "broadcasting_except_internet", industry_type: :subsector, naics_code: "515").first_or_create
    IndustryCode.where(name: "Telecommunications", internal_name: "telecommunications", industry_type: :subsector, naics_code: "517").first_or_create
    IndustryCode.where(name: "Data Processing, Hosting, and Related Services", internal_name: "data_processing_hosting_and_related_services", industry_type: :subsector, naics_code: "518").first_or_create
    IndustryCode.where(name: "Other Information Services", internal_name: "other_information_services", industry_type: :subsector, naics_code: "519").first_or_create
    IndustryCode.where(name: "Monetary Authorities_Central Bank", internal_name: "monetary_authorities_central_bank", industry_type: :subsector, naics_code: "521").first_or_create
    IndustryCode.where(name: "Credit Intermediation and Related Activities", internal_name: "credit_intermediation_and_related_activities", industry_type: :subsector, naics_code: "522").first_or_create
    IndustryCode.where(name: "Securities, Commodity Contracts, and Other Financial Investments and Related Activities", internal_name: "securities_commodity_contracts_and_other_financial_investments_and_related_activities", industry_type: :subsector, naics_code: "523").first_or_create
    IndustryCode.where(name: "Insurance Carriers and Related Activities", internal_name: "insurance_carriers_and_related_activities", industry_type: :subsector, naics_code: "524").first_or_create
    IndustryCode.where(name: "Funds, Trusts, and Other Financial Vehicles", internal_name: "funds_trusts_and_other_financial_vehicles", industry_type: :subsector, naics_code: "525").first_or_create
    IndustryCode.where(name: "Real Estate", internal_name: "real_estate", industry_type: :subsector, naics_code: "531").first_or_create
    IndustryCode.where(name: "Rental and Leasing Services", internal_name: "rental_and_leasing_services", industry_type: :subsector, naics_code: "532").first_or_create
    IndustryCode.where(name: "Lessors of Nonfinancial Intangible Assets (except Copyrighted Works)", internal_name: "lessors_of_nonfinancial_intangible_assets_except_copyrighted_works", industry_type: :subsector, naics_code: "533").first_or_create
    IndustryCode.where(name: "Professional, Scientific, and Technical Services Subsector", internal_name: "professional_scientific_and_technical_services_subsector", industry_type: :subsector, naics_code: "541").first_or_create
    IndustryCode.where(name: "Management of Companies and Enterprises Subsector", internal_name: "management_of_companies_and_enterprises_subsector", industry_type: :subsector, naics_code: "551").first_or_create
    IndustryCode.where(name: "Administrative and Support Services", internal_name: "administrative_and_support_services", industry_type: :subsector, naics_code: "561").first_or_create
    IndustryCode.where(name: "Waste Management and Remediation Services", internal_name: "waste_management_and_remediation_services", industry_type: :subsector, naics_code: "562").first_or_create
    IndustryCode.where(name: "Educational Services Subsector", internal_name: "educational_services_subsector", industry_type: :subsector, naics_code: "611").first_or_create
    IndustryCode.where(name: "Ambulatory Health Care Services", internal_name: "ambulatory_health_care_services", industry_type: :subsector, naics_code: "621").first_or_create
    IndustryCode.where(name: "Hospitals", internal_name: "hospitals", industry_type: :subsector, naics_code: "622").first_or_create
    IndustryCode.where(name: "Nursing and Residential Care Facilities", internal_name: "nursing_and_residential_care_facilities", industry_type: :subsector, naics_code: "623").first_or_create
    IndustryCode.where(name: "Social Assistance", internal_name: "social_assistance", industry_type: :subsector, naics_code: "624").first_or_create
    IndustryCode.where(name: "Performing Arts, Spectator Sports, and Related Industries", internal_name: "performing_arts_spectator_sports_and_related_industries", industry_type: :subsector, naics_code: "711").first_or_create
    IndustryCode.where(name: "Museums, Historical Sites, and Similar Institutions", internal_name: "museums_historical_sites_and_similar_institutions", industry_type: :subsector, naics_code: "712").first_or_create
    IndustryCode.where(name: "Amusement, Gambling, and Recreation Industries", internal_name: "amusement_gambling_and_recreation_industries", industry_type: :subsector, naics_code: "713").first_or_create
    IndustryCode.where(name: "Accommodation", internal_name: "accommodation", industry_type: :subsector, naics_code: "721").first_or_create
    IndustryCode.where(name: "Food Services and Drinking Places", internal_name: "food_services_and_drinking_places", industry_type: :subsector, naics_code: "722").first_or_create
    IndustryCode.where(name: "Repair and Maintenance", internal_name: "repair_and_maintenance", industry_type: :subsector, naics_code: "811").first_or_create
    IndustryCode.where(name: "Personal and Laundry Services", internal_name: "personal_and_laundry_services", industry_type: :subsector, naics_code: "812").first_or_create
    IndustryCode.where(name: "Religious, Grantmaking, Civic, Professional, and Similar Organizations", internal_name: "religious_grantmaking_civic_professional_and_similar_organizations", industry_type: :subsector, naics_code: "813").first_or_create
    IndustryCode.where(name: "Private Households", internal_name: "private_households", industry_type: :subsector, naics_code: "814").first_or_create
    IndustryCode.where(name: "Executive, Legislative, and Other General Government Support", internal_name: "executive_legislative_and_other_general_government_support", industry_type: :subsector, naics_code: "921").first_or_create
    IndustryCode.where(name: "Justice, Public Order, and Safety Activities", internal_name: "justice_public_order_and_safety_activities", industry_type: :subsector, naics_code: "922").first_or_create
    IndustryCode.where(name: "Administration of Human Resource Programs", internal_name: "administration_of_human_resource_programs", industry_type: :subsector, naics_code: "923").first_or_create
    IndustryCode.where(name: "Administration of Environmental Quality Programs", internal_name: "administration_of_environmental_quality_programs", industry_type: :subsector, naics_code: "924").first_or_create
    IndustryCode.where(name: "Administration of Housing Programs, Urban Planning, and Community Development", internal_name: "administration_of_housing_programs_urban_planning_and_community_development", industry_type: :subsector, naics_code: "925").first_or_create
    IndustryCode.where(name: "Administration of Economic Programs", internal_name: "administration_of_economic_programs", industry_type: :subsector, naics_code: "926").first_or_create
    IndustryCode.where(name: "Space Research and Technology", internal_name: "space_research_and_technology", industry_type: :subsector, naics_code: "927").first_or_create
    IndustryCode.where(name: "National Security and International Affairs", internal_name: "national_security_and_international_affairs", industry_type: :subsector, naics_code: "928").first_or_create

    #NAICS industry_group
    IndustryCode.where(name: "Oilseed and Grain Farming", internal_name: "oilseed_and_grain_farming", industry_type: :industry_group, naics_code: "1111").first_or_create
    IndustryCode.where(name: "Vegetable and Melon Farming", internal_name: "vegetable_and_melon_farming", industry_type: :industry_group, naics_code: "1112").first_or_create
    IndustryCode.where(name: "Fruit and Tree Nut Farming", internal_name: "fruit_and_tree_nut_farming", industry_type: :industry_group, naics_code: "1113").first_or_create
    IndustryCode.where(name: "Greenhouse, Nursery, and Floriculture Production", internal_name: "greenhouse_nursery_and_floriculture_production", industry_type: :industry_group, naics_code: "1114").first_or_create
    IndustryCode.where(name: "Other Crop Farming", internal_name: "other_crop_farming", industry_type: :industry_group, naics_code: "1119").first_or_create
    IndustryCode.where(name: "Cattle Ranching and Farming", internal_name: "cattle_ranching_and_farming", industry_type: :industry_group, naics_code: "1121").first_or_create
    IndustryCode.where(name: "Hog and Pig Farming", internal_name: "hog_and_pig_farming", industry_type: :industry_group, naics_code: "1122").first_or_create
    IndustryCode.where(name: "Poultry and Egg Production", internal_name: "poultry_and_egg_production", industry_type: :industry_group, naics_code: "1123").first_or_create
    IndustryCode.where(name: "Sheep and Goat Farming", internal_name: "sheep_and_goat_farming", industry_type: :industry_group, naics_code: "1124").first_or_create
    IndustryCode.where(name: "Aquaculture", internal_name: "aquaculture", industry_type: :industry_group, naics_code: "1125").first_or_create
    IndustryCode.where(name: "Other Animal Production", internal_name: "other_animal_production", industry_type: :industry_group, naics_code: "1129").first_or_create
    IndustryCode.where(name: "Timber Tract Operations", internal_name: "timber_tract_operations", industry_type: :industry_group, naics_code: "1131").first_or_create
    IndustryCode.where(name: "Forest Nurseries and Gathering of Forest Products", internal_name: "forest_nurseries_and_gathering_of_forest_products", industry_type: :industry_group, naics_code: "1132").first_or_create
    IndustryCode.where(name: "Logging", internal_name: "logging", industry_type: :industry_group, naics_code: "1133").first_or_create
    IndustryCode.where(name: "Fishing", internal_name: "fishing", industry_type: :industry_group, naics_code: "1141").first_or_create
    IndustryCode.where(name: "Hunting and Trapping", internal_name: "hunting_and_trapping", industry_type: :industry_group, naics_code: "1142").first_or_create
    IndustryCode.where(name: "Support Activities for Crop Production", internal_name: "support_activities_for_crop_production", industry_type: :industry_group, naics_code: "1151").first_or_create
    IndustryCode.where(name: "Support Activities for Animal Production", internal_name: "support_activities_for_animal_production", industry_type: :industry_group, naics_code: "1152").first_or_create
    IndustryCode.where(name: "Support Activities for Forestry", internal_name: "support_activities_for_forestry", industry_type: :industry_group, naics_code: "1153").first_or_create
    IndustryCode.where(name: "Oil and Gas Extraction", internal_name: "oil_and_gas_extraction", industry_type: :industry_group, naics_code: "2111").first_or_create
    IndustryCode.where(name: "Coal Mining", internal_name: "coal_mining", industry_type: :industry_group, naics_code: "2121").first_or_create
    IndustryCode.where(name: "Metal Ore Mining", internal_name: "metal_ore_mining", industry_type: :industry_group, naics_code: "2122").first_or_create
    IndustryCode.where(name: "Nonmetallic Mineral Mining and Quarrying", internal_name: "nonmetallic_mineral_mining_and_quarrying", industry_type: :industry_group, naics_code: "2123").first_or_create
    IndustryCode.where(name: "Support Activities for Mining", internal_name: "support_activities_for_mining", industry_type: :industry_group, naics_code: "2131").first_or_create
    IndustryCode.where(name: "Electric Power Generation, Transmission and Distribution", internal_name: "electric_power_generation_transmission_and_distribution", industry_type: :industry_group, naics_code: "2211").first_or_create
    IndustryCode.where(name: "Natural Gas Distribution", internal_name: "natural_gas_distribution", industry_type: :industry_group, naics_code: "2212").first_or_create
    IndustryCode.where(name: "Water, Sewage and Other Systems", internal_name: "water_sewage_and_other_systems", industry_type: :industry_group, naics_code: "2213").first_or_create
    IndustryCode.where(name: "Residential Building Construction", internal_name: "residential_building_construction", industry_type: :industry_group, naics_code: "2361").first_or_create
    IndustryCode.where(name: "Nonresidential Building Construction", internal_name: "nonresidential_building_construction", industry_type: :industry_group, naics_code: "2362").first_or_create
    IndustryCode.where(name: "Utility System Construction", internal_name: "utility_system_construction", industry_type: :industry_group, naics_code: "2371").first_or_create
    IndustryCode.where(name: "Land Subdivision", internal_name: "land_subdivision", industry_type: :industry_group, naics_code: "2372").first_or_create
    IndustryCode.where(name: "Highway, Street, and Bridge Construction", internal_name: "highway_street_and_bridge_construction", industry_type: :industry_group, naics_code: "2373").first_or_create
    IndustryCode.where(name: "Other Heavy and Civil Engineering Construction", internal_name: "other_heavy_and_civil_engineering_construction", industry_type: :industry_group, naics_code: "2379").first_or_create
    IndustryCode.where(name: "Foundation, Structure, and Building Exterior Contractors", internal_name: "foundation_structure_and_building_exterior_contractors", industry_type: :industry_group, naics_code: "2381").first_or_create
    IndustryCode.where(name: "Building Equipment Contractors", internal_name: "building_equipment_contractors", industry_type: :industry_group, naics_code: "2382").first_or_create
    IndustryCode.where(name: "Building Finishing Contractors", internal_name: "building_finishing_contractors", industry_type: :industry_group, naics_code: "2383").first_or_create
    IndustryCode.where(name: "Other Specialty Trade Contractors", internal_name: "other_specialty_trade_contractors", industry_type: :industry_group, naics_code: "2389").first_or_create
    IndustryCode.where(name: "Animal Food Manufacturing", internal_name: "animal_food_manufacturing", industry_type: :industry_group, naics_code: "3111").first_or_create
    IndustryCode.where(name: "Grain and Oilseed Milling", internal_name: "grain_and_oilseed_milling", industry_type: :industry_group, naics_code: "3112").first_or_create
    IndustryCode.where(name: "Sugar and Confectionery Product Manufacturing", internal_name: "sugar_and_confectionery_product_manufacturing", industry_type: :industry_group, naics_code: "3113").first_or_create
    IndustryCode.where(name: "Fruit and Vegetable Preserving and Specialty Food Manufacturing", internal_name: "fruit_and_vegetable_preserving_and_specialty_food_manufacturing", industry_type: :industry_group, naics_code: "3114").first_or_create
    IndustryCode.where(name: "Dairy Product Manufacturing", internal_name: "dairy_product_manufacturing", industry_type: :industry_group, naics_code: "3115").first_or_create
    IndustryCode.where(name: "Animal Slaughtering and Processing", internal_name: "animal_slaughtering_and_processing", industry_type: :industry_group, naics_code: "3116").first_or_create
    IndustryCode.where(name: "Seafood Product Preparation and Packaging", internal_name: "seafood_product_preparation_and_packaging", industry_type: :industry_group, naics_code: "3117").first_or_create
    IndustryCode.where(name: "Bakeries and Tortilla Manufacturing", internal_name: "bakeries_and_tortilla_manufacturing", industry_type: :industry_group, naics_code: "3118").first_or_create
    IndustryCode.where(name: "Other Food Manufacturing", internal_name: "other_food_manufacturing", industry_type: :industry_group, naics_code: "3119").first_or_create
    IndustryCode.where(name: "Beverage Manufacturing", internal_name: "beverage_manufacturing", industry_type: :industry_group, naics_code: "3121").first_or_create
    IndustryCode.where(name: "Tobacco Manufacturing", internal_name: "tobacco_manufacturing", industry_type: :industry_group, naics_code: "3122").first_or_create
    IndustryCode.where(name: "Fiber, Yarn, and Thread Mills", internal_name: "fiber_yarn_and_thread_mills", industry_type: :industry_group, naics_code: "3131").first_or_create
    IndustryCode.where(name: "Fabric Mills", internal_name: "fabric_mills", industry_type: :industry_group, naics_code: "3132").first_or_create
    IndustryCode.where(name: "Textile and Fabric Finishing and Fabric Coating Mills", internal_name: "textile_and_fabric_finishing_and_fabric_coating_mills", industry_type: :industry_group, naics_code: "3133").first_or_create
    IndustryCode.where(name: "Textile Furnishings Mills", internal_name: "textile_furnishings_mills", industry_type: :industry_group, naics_code: "3141").first_or_create
    IndustryCode.where(name: "Other Textile Product Mills", internal_name: "other_textile_product_mills", industry_type: :industry_group, naics_code: "3149").first_or_create
    IndustryCode.where(name: "Apparel Knitting Mills", internal_name: "apparel_knitting_mills", industry_type: :industry_group, naics_code: "3151").first_or_create
    IndustryCode.where(name: "Cut and Sew Apparel Manufacturing", internal_name: "cut_and_sew_apparel_manufacturing", industry_type: :industry_group, naics_code: "3152").first_or_create
    IndustryCode.where(name: "Apparel Accessories and Other Apparel Manufacturing", internal_name: "apparel_accessories_and_other_apparel_manufacturing", industry_type: :industry_group, naics_code: "3159").first_or_create
    IndustryCode.where(name: "Leather and Hide Tanning and Finishing", internal_name: "leather_and_hide_tanning_and_finishing", industry_type: :industry_group, naics_code: "3161").first_or_create
    IndustryCode.where(name: "Footwear Manufacturing", internal_name: "footwear_manufacturing", industry_type: :industry_group, naics_code: "3162").first_or_create
    IndustryCode.where(name: "Other Leather and Allied Product Manufacturing", internal_name: "other_leather_and_allied_product_manufacturing", industry_type: :industry_group, naics_code: "3169").first_or_create
    IndustryCode.where(name: "Sawmills and Wood Preservation", internal_name: "sawmills_and_wood_preservation", industry_type: :industry_group, naics_code: "3211").first_or_create
    IndustryCode.where(name: "Veneer, Plywood, and Engineered Wood Product Manufacturing", internal_name: "veneer_plywood_and_engineered_wood_product_manufacturing", industry_type: :industry_group, naics_code: "3212").first_or_create
    IndustryCode.where(name: "Other Wood Product Manufacturing", internal_name: "other_wood_product_manufacturing", industry_type: :industry_group, naics_code: "3219").first_or_create
    IndustryCode.where(name: "Pulp, Paper, and Paperboard Mills", internal_name: "pulp_paper_and_paperboard_mills", industry_type: :industry_group, naics_code: "3221").first_or_create
    IndustryCode.where(name: "Converted Paper Product Manufacturing", internal_name: "converted_paper_product_manufacturing", industry_type: :industry_group, naics_code: "3222").first_or_create
    IndustryCode.where(name: "Printing and Related Support Activities", internal_name: "printing_and_related_support_activities", industry_type: :industry_group, naics_code: "3231").first_or_create
    IndustryCode.where(name: "Petroleum and Coal Products Manufacturing", internal_name: "petroleum_and_coal_products_manufacturing", industry_type: :industry_group, naics_code: "3241").first_or_create
    IndustryCode.where(name: "Basic Chemical Manufacturing", internal_name: "basic_chemical_manufacturing", industry_type: :industry_group, naics_code: "3251").first_or_create
    IndustryCode.where(name: "Resin, Synthetic Rubber, and Artificial Synthetic Fibers and Filaments Manufacturing", internal_name: "resin_synthetic_rubber_and_artificial_synthetic_fibers_and_filaments_manufacturing", industry_type: :industry_group, naics_code: "3252").first_or_create
    IndustryCode.where(name: "Pesticide, Fertilizer, and Other Agricultural Chemical Manufacturing", internal_name: "pesticide_fertilizer_and_other_agricultural_chemical_manufacturing", industry_type: :industry_group, naics_code: "3253").first_or_create
    IndustryCode.where(name: "Pharmaceutical and Medicine Manufacturing", internal_name: "pharmaceutical_and_medicine_manufacturing", industry_type: :industry_group, naics_code: "3254").first_or_create
    IndustryCode.where(name: "Paint, Coating, and Adhesive Manufacturing", internal_name: "paint_coating_and_adhesive_manufacturing", industry_type: :industry_group, naics_code: "3255").first_or_create
    IndustryCode.where(name: "Soap, Cleaning Compound, and Toilet Preparation Manufacturing", internal_name: "soap_cleaning_compound_and_toilet_preparation_manufacturing", industry_type: :industry_group, naics_code: "3256").first_or_create
    IndustryCode.where(name: "Other Chemical Product and Preparation Manufacturing", internal_name: "other_chemical_product_and_preparation_manufacturing", industry_type: :industry_group, naics_code: "3259").first_or_create
    IndustryCode.where(name: "Plastics Product Manufacturing", internal_name: "plastics_product_manufacturing", industry_type: :industry_group, naics_code: "3261").first_or_create
    IndustryCode.where(name: "Rubber Product Manufacturing", internal_name: "rubber_product_manufacturing", industry_type: :industry_group, naics_code: "3262").first_or_create
    IndustryCode.where(name: "Clay Product and Refractory Manufacturing", internal_name: "clay_product_and_refractory_manufacturing", industry_type: :industry_group, naics_code: "3271").first_or_create
    IndustryCode.where(name: "Glass and Glass Product Manufacturing", internal_name: "glass_and_glass_product_manufacturing", industry_type: :industry_group, naics_code: "3272").first_or_create
    IndustryCode.where(name: "Cement and Concrete Product Manufacturing", internal_name: "cement_and_concrete_product_manufacturing", industry_type: :industry_group, naics_code: "3273").first_or_create
    IndustryCode.where(name: "Lime and Gypsum Product Manufacturing", internal_name: "lime_and_gypsum_product_manufacturing", industry_type: :industry_group, naics_code: "3274").first_or_create
    IndustryCode.where(name: "Other Nonmetallic Mineral Product Manufacturing", internal_name: "other_nonmetallic_mineral_product_manufacturing", industry_type: :industry_group, naics_code: "3279").first_or_create
    IndustryCode.where(name: "Iron and Steel Mills and Ferroalloy Manufacturing", internal_name: "iron_and_steel_mills_and_ferroalloy_manufacturing", industry_type: :industry_group, naics_code: "3311").first_or_create
    IndustryCode.where(name: "Steel Product Manufacturing from Purchased Steel", internal_name: "steel_product_manufacturing_from_purchased_steel", industry_type: :industry_group, naics_code: "3312").first_or_create
    IndustryCode.where(name: "Alumina and Aluminum Production and Processing", internal_name: "alumina_and_aluminum_production_and_processing", industry_type: :industry_group, naics_code: "3313").first_or_create
    IndustryCode.where(name: "Nonferrous Metal (except Aluminum) Production and Processing", internal_name: "nonferrous_metal_except_aluminum_production_and_processing", industry_type: :industry_group, naics_code: "3314").first_or_create
    IndustryCode.where(name: "Foundries", internal_name: "foundries", industry_type: :industry_group, naics_code: "3315").first_or_create
    IndustryCode.where(name: "Forging and Stamping", internal_name: "forging_and_stamping", industry_type: :industry_group, naics_code: "3321").first_or_create
    IndustryCode.where(name: "Cutlery and Handtool Manufacturing", internal_name: "cutlery_and_handtool_manufacturing", industry_type: :industry_group, naics_code: "3322").first_or_create
    IndustryCode.where(name: "Architectural and Structural Metals Manufacturing", internal_name: "architectural_and_structural_metals_manufacturing", industry_type: :industry_group, naics_code: "3323").first_or_create
    IndustryCode.where(name: "Boiler, Tank, and Shipping Container Manufacturing", internal_name: "boiler_tank_and_shipping_container_manufacturing", industry_type: :industry_group, naics_code: "3324").first_or_create
    IndustryCode.where(name: "Hardware Manufacturing", internal_name: "hardware_manufacturing", industry_type: :industry_group, naics_code: "3325").first_or_create
    IndustryCode.where(name: "Spring and Wire Product Manufacturing", internal_name: "spring_and_wire_product_manufacturing", industry_type: :industry_group, naics_code: "3326").first_or_create
    IndustryCode.where(name: "Machine Shops; Turned Product; and Screw, Nut, and Bolt Manufacturing", internal_name: "machine_shops;_turned_product;_and_screw_nut_and_bolt_manufacturing", industry_type: :industry_group, naics_code: "3327").first_or_create
    IndustryCode.where(name: "Coating, Engraving, Heat Treating, and Allied Activities", internal_name: "coating_engraving_heat_treating_and_allied_activities", industry_type: :industry_group, naics_code: "3328").first_or_create
    IndustryCode.where(name: "Other Fabricated Metal Product Manufacturing", internal_name: "other_fabricated_metal_product_manufacturing", industry_type: :industry_group, naics_code: "3329").first_or_create
    IndustryCode.where(name: "Agriculture, Construction, and Mining Machinery Manufacturing", internal_name: "agriculture_construction_and_mining_machinery_manufacturing", industry_type: :industry_group, naics_code: "3331").first_or_create
    IndustryCode.where(name: "Industrial Machinery Manufacturing", internal_name: "industrial_machinery_manufacturing", industry_type: :industry_group, naics_code: "3332").first_or_create
    IndustryCode.where(name: "Commercial and Service Industry Machinery Manufacturing", internal_name: "commercial_and_service_industry_machinery_manufacturing", industry_type: :industry_group, naics_code: "3333").first_or_create
    IndustryCode.where(name: "Ventilation, Heating, Air_Conditioning, and Commercial Refrigeration Equipment Manufacturing", internal_name: "ventilation_heating_air_conditioning_and_commercial_refrigeration_equipment_manufacturing", industry_type: :industry_group, naics_code: "3334").first_or_create
    IndustryCode.where(name: "Metalworking Machinery Manufacturing", internal_name: "metalworking_machinery_manufacturing", industry_type: :industry_group, naics_code: "3335").first_or_create
    IndustryCode.where(name: "Engine, Turbine, and Power Transmission Equipment Manufacturing", internal_name: "engine_turbine_and_power_transmission_equipment_manufacturing", industry_type: :industry_group, naics_code: "3336").first_or_create
    IndustryCode.where(name: "Other General Purpose Machinery Manufacturing", internal_name: "other_general_purpose_machinery_manufacturing", industry_type: :industry_group, naics_code: "3339").first_or_create
    IndustryCode.where(name: "Computer and Peripheral Equipment Manufacturing", internal_name: "computer_and_peripheral_equipment_manufacturing", industry_type: :industry_group, naics_code: "3341").first_or_create
    IndustryCode.where(name: "Communications Equipment Manufacturing", internal_name: "communications_equipment_manufacturing", industry_type: :industry_group, naics_code: "3342").first_or_create
    IndustryCode.where(name: "Audio and Video Equipment Manufacturing", internal_name: "audio_and_video_equipment_manufacturing", industry_type: :industry_group, naics_code: "3343").first_or_create
    IndustryCode.where(name: "Semiconductor and Other Electronic Component Manufacturing", internal_name: "semiconductor_and_other_electronic_component_manufacturing", industry_type: :industry_group, naics_code: "3344").first_or_create
    IndustryCode.where(name: "Navigational, Measuring, Electromedical, and Control Instruments Manufacturing", internal_name: "navigational_measuring_electromedical_and_control_instruments_manufacturing", industry_type: :industry_group, naics_code: "3345").first_or_create
    IndustryCode.where(name: "Manufacturing and Reproducing Magnetic and Optical Media", internal_name: "manufacturing_and_reproducing_magnetic_and_optical_media", industry_type: :industry_group, naics_code: "3346").first_or_create
    IndustryCode.where(name: "Electric Lighting Equipment Manufacturing", internal_name: "electric_lighting_equipment_manufacturing", industry_type: :industry_group, naics_code: "3351").first_or_create
    IndustryCode.where(name: "Household Appliance Manufacturing", internal_name: "household_appliance_manufacturing", industry_type: :industry_group, naics_code: "3352").first_or_create
    IndustryCode.where(name: "Electrical Equipment Manufacturing", internal_name: "electrical_equipment_manufacturing", industry_type: :industry_group, naics_code: "3353").first_or_create
    IndustryCode.where(name: "Other Electrical Equipment and Component Manufacturing", internal_name: "other_electrical_equipment_and_component_manufacturing", industry_type: :industry_group, naics_code: "3359").first_or_create
    IndustryCode.where(name: "Motor Vehicle Manufacturing", internal_name: "motor_vehicle_manufacturing", industry_type: :industry_group, naics_code: "3361").first_or_create
    IndustryCode.where(name: "Motor Vehicle Body and Trailer Manufacturing", internal_name: "motor_vehicle_body_and_trailer_manufacturing", industry_type: :industry_group, naics_code: "3362").first_or_create
    IndustryCode.where(name: "Motor Vehicle Parts Manufacturing", internal_name: "motor_vehicle_parts_manufacturing", industry_type: :industry_group, naics_code: "3363").first_or_create
    IndustryCode.where(name: "Aerospace Product and Parts Manufacturing", internal_name: "aerospace_product_and_parts_manufacturing", industry_type: :industry_group, naics_code: "3364").first_or_create
    IndustryCode.where(name: "Railroad Rolling Stock Manufacturing", internal_name: "railroad_rolling_stock_manufacturing", industry_type: :industry_group, naics_code: "3365").first_or_create
    IndustryCode.where(name: "Ship and Boat Building", internal_name: "ship_and_boat_building", industry_type: :industry_group, naics_code: "3366").first_or_create
    IndustryCode.where(name: "Other Transportation Equipment Manufacturing", internal_name: "other_transportation_equipment_manufacturing", industry_type: :industry_group, naics_code: "3369").first_or_create
    IndustryCode.where(name: "Household and Institutional Furniture and Kitchen Cabinet Manufacturing", internal_name: "household_and_institutional_furniture_and_kitchen_cabinet_manufacturing", industry_type: :industry_group, naics_code: "3371").first_or_create
    IndustryCode.where(name: "Office Furniture (including Fixtures) Manufacturing", internal_name: "office_furniture_including_fixtures_manufacturing", industry_type: :industry_group, naics_code: "3372").first_or_create
    IndustryCode.where(name: "Other Furniture Related Product Manufacturing", internal_name: "other_furniture_related_product_manufacturing", industry_type: :industry_group, naics_code: "3379").first_or_create
    IndustryCode.where(name: "Medical Equipment and Supplies Manufacturing", internal_name: "medical_equipment_and_supplies_manufacturing", industry_type: :industry_group, naics_code: "3391").first_or_create
    IndustryCode.where(name: "Other Miscellaneous Manufacturing", internal_name: "other_miscellaneous_manufacturing", industry_type: :industry_group, naics_code: "3399").first_or_create
    IndustryCode.where(name: "Motor Vehicle and Motor Vehicle Parts and Supplies Merchant Wholesalers", internal_name: "motor_vehicle_and_motor_vehicle_parts_and_supplies_merchant_wholesalers", industry_type: :industry_group, naics_code: "4231").first_or_create
    IndustryCode.where(name: "Furniture and Home Furnishing Merchant Wholesalers", internal_name: "furniture_and_home_furnishing_merchant_wholesalers", industry_type: :industry_group, naics_code: "4232").first_or_create
    IndustryCode.where(name: "Lumber and Other Construction Materials Merchant Wholesalers", internal_name: "lumber_and_other_construction_materials_merchant_wholesalers", industry_type: :industry_group, naics_code: "4233").first_or_create
    IndustryCode.where(name: "Professional and Commercial Equipment and Supplies Merchant Wholesalers", internal_name: "professional_and_commercial_equipment_and_supplies_merchant_wholesalers", industry_type: :industry_group, naics_code: "4234").first_or_create
    IndustryCode.where(name: "Metal and Mineral (except Petroleum) Merchant Wholesalers", internal_name: "metal_and_mineral_except_petroleum_merchant_wholesalers", industry_type: :industry_group, naics_code: "4235").first_or_create
    IndustryCode.where(name: "Household Appliances and Electrical and Electronic Goods Merchant Wholesalers", internal_name: "household_appliances_and_electrical_and_electronic_goods_merchant_wholesalers", industry_type: :industry_group, naics_code: "4236").first_or_create
    IndustryCode.where(name: "Hardware, and Plumbing and Heating Equipment and Supplies Merchant Wholesalers", internal_name: "hardware_and_plumbing_and_heating_equipment_and_supplies_merchant_wholesalers", industry_type: :industry_group, naics_code: "4237").first_or_create
    IndustryCode.where(name: "Machinery, Equipment, and Supplies Merchant Wholesalers", internal_name: "machinery_equipment_and_supplies_merchant_wholesalers", industry_type: :industry_group, naics_code: "4238").first_or_create
    IndustryCode.where(name: "Miscellaneous Durable Goods Merchant Wholesalers", internal_name: "miscellaneous_durable_goods_merchant_wholesalers", industry_type: :industry_group, naics_code: "4239").first_or_create
    IndustryCode.where(name: "Paper and Paper Product Merchant Wholesalers", internal_name: "paper_and_paper_product_merchant_wholesalers", industry_type: :industry_group, naics_code: "4241").first_or_create
    IndustryCode.where(name: "Drugs and Druggists' Sundries Merchant Wholesalers", internal_name: "drugs_and_druggists'_sundries_merchant_wholesalers", industry_type: :industry_group, naics_code: "4242").first_or_create
    IndustryCode.where(name: "Apparel, Piece Goods, and Notions Merchant Wholesalers", internal_name: "apparel_piece_goods_and_notions_merchant_wholesalers", industry_type: :industry_group, naics_code: "4243").first_or_create
    IndustryCode.where(name: "Grocery and Related Product Merchant Wholesalers", internal_name: "grocery_and_related_product_merchant_wholesalers", industry_type: :industry_group, naics_code: "4244").first_or_create
    IndustryCode.where(name: "Farm Product Raw Material Merchant Wholesalers", internal_name: "farm_product_raw_material_merchant_wholesalers", industry_type: :industry_group, naics_code: "4245").first_or_create
    IndustryCode.where(name: "Chemical and Allied Products Merchant Wholesalers", internal_name: "chemical_and_allied_products_merchant_wholesalers", industry_type: :industry_group, naics_code: "4246").first_or_create
    IndustryCode.where(name: "Petroleum and Petroleum Products Merchant Wholesalers", internal_name: "petroleum_and_petroleum_products_merchant_wholesalers", industry_type: :industry_group, naics_code: "4247").first_or_create
    IndustryCode.where(name: "Beer, Wine, and Distilled Alcoholic Beverage Merchant Wholesalers", internal_name: "beer_wine_and_distilled_alcoholic_beverage_merchant_wholesalers", industry_type: :industry_group, naics_code: "4248").first_or_create
    IndustryCode.where(name: "Miscellaneous Nondurable Goods Merchant Wholesalers", internal_name: "miscellaneous_nondurable_goods_merchant_wholesalers", industry_type: :industry_group, naics_code: "4249").first_or_create
    IndustryCode.where(name: "Wholesale Electronic Markets and Agents and Brokers", internal_name: "wholesale_electronic_markets_and_agents_and_brokers", industry_type: :industry_group, naics_code: "4251").first_or_create
    IndustryCode.where(name: "Automobile Dealers", internal_name: "automobile_dealers", industry_type: :industry_group, naics_code: "4411").first_or_create
    IndustryCode.where(name: "Other Motor Vehicle Dealers", internal_name: "other_motor_vehicle_dealers", industry_type: :industry_group, naics_code: "4412").first_or_create
    IndustryCode.where(name: "Automotive Parts, Accessories, and Tire Stores", internal_name: "automotive_parts_accessories_and_tire_stores", industry_type: :industry_group, naics_code: "4413").first_or_create
    IndustryCode.where(name: "Furniture Stores", internal_name: "furniture_stores", industry_type: :industry_group, naics_code: "4421").first_or_create
    IndustryCode.where(name: "Home Furnishings Stores", internal_name: "home_furnishings_stores", industry_type: :industry_group, naics_code: "4422").first_or_create
    IndustryCode.where(name: "Electronics and Appliance Stores", internal_name: "electronics_and_appliance_stores", industry_type: :industry_group, naics_code: "4431").first_or_create
    IndustryCode.where(name: "Building Material and Supplies Dealers", internal_name: "building_material_and_supplies_dealers", industry_type: :industry_group, naics_code: "4441").first_or_create
    IndustryCode.where(name: "Lawn and Garden Equipment and Supplies Stores", internal_name: "lawn_and_garden_equipment_and_supplies_stores", industry_type: :industry_group, naics_code: "4442").first_or_create
    IndustryCode.where(name: "Grocery Stores", internal_name: "grocery_stores", industry_type: :industry_group, naics_code: "4451").first_or_create
    IndustryCode.where(name: "Specialty Food Stores", internal_name: "specialty_food_stores", industry_type: :industry_group, naics_code: "4452").first_or_create
    IndustryCode.where(name: "Beer, Wine, and Liquor Stores", internal_name: "beer_wine_and_liquor_stores", industry_type: :industry_group, naics_code: "4453").first_or_create
    IndustryCode.where(name: "Health and Personal Care Stores", internal_name: "health_and_personal_care_stores", industry_type: :industry_group, naics_code: "4461").first_or_create
    IndustryCode.where(name: "Gasoline Stations", internal_name: "gasoline_stations", industry_type: :industry_group, naics_code: "4471").first_or_create
    IndustryCode.where(name: "Clothing Stores", internal_name: "clothing_stores", industry_type: :industry_group, naics_code: "4481").first_or_create
    IndustryCode.where(name: "Shoe Stores", internal_name: "shoe_stores", industry_type: :industry_group, naics_code: "4482").first_or_create
    IndustryCode.where(name: "Jewelry, Luggage, and Leather Goods Stores", internal_name: "jewelry_luggage_and_leather_goods_stores", industry_type: :industry_group, naics_code: "4483").first_or_create
    IndustryCode.where(name: "Sporting Goods, Hobby, and Musical Instrument Stores", internal_name: "sporting_goods_hobby_and_musical_instrument_stores", industry_type: :industry_group, naics_code: "4511").first_or_create
    IndustryCode.where(name: "Book Stores and News Dealers", internal_name: "book_stores_and_news_dealers", industry_type: :industry_group, naics_code: "4512").first_or_create
    IndustryCode.where(name: "Department Stores", internal_name: "department_stores", industry_type: :industry_group, naics_code: "4521").first_or_create
    IndustryCode.where(name: "Other General Merchandise Stores", internal_name: "other_general_merchandise_stores", industry_type: :industry_group, naics_code: "4529").first_or_create
    IndustryCode.where(name: "Florists", internal_name: "florists", industry_type: :industry_group, naics_code: "4531").first_or_create
    IndustryCode.where(name: "Office Supplies, Stationery, and Gift Stores", internal_name: "office_supplies_stationery_and_gift_stores", industry_type: :industry_group, naics_code: "4532").first_or_create
    IndustryCode.where(name: "Used Merchandise Stores", internal_name: "used_merchandise_stores", industry_type: :industry_group, naics_code: "4533").first_or_create
    IndustryCode.where(name: "Other Miscellaneous Store Retailers", internal_name: "other_miscellaneous_store_retailers", industry_type: :industry_group, naics_code: "4539").first_or_create
    IndustryCode.where(name: "Electronic Shopping and Mail_Order Houses", internal_name: "electronic_shopping_and_mail_order_houses", industry_type: :industry_group, naics_code: "4541").first_or_create
    IndustryCode.where(name: "Vending Machine Operators", internal_name: "vending_machine_operators", industry_type: :industry_group, naics_code: "4542").first_or_create
    IndustryCode.where(name: "Direct Selling Establishments", internal_name: "direct_selling_establishments", industry_type: :industry_group, naics_code: "4543").first_or_create
    IndustryCode.where(name: "Scheduled Air Transportation", internal_name: "scheduled_air_transportation", industry_type: :industry_group, naics_code: "4811").first_or_create
    IndustryCode.where(name: "Nonscheduled Air Transportation", internal_name: "nonscheduled_air_transportation", industry_type: :industry_group, naics_code: "4812").first_or_create
    IndustryCode.where(name: "Rail Transportation", internal_name: "rail_transportation", industry_type: :industry_group, naics_code: "4821").first_or_create
    IndustryCode.where(name: "Deep Sea, Coastal, and Great Lakes Water Transportation", internal_name: "deep_sea_coastal_and_great_lakes_water_transportation", industry_type: :industry_group, naics_code: "4831").first_or_create
    IndustryCode.where(name: "Inland Water Transportation", internal_name: "inland_water_transportation", industry_type: :industry_group, naics_code: "4832").first_or_create
    IndustryCode.where(name: "General Freight Trucking", internal_name: "general_freight_trucking", industry_type: :industry_group, naics_code: "4841").first_or_create
    IndustryCode.where(name: "Specialized Freight Trucking", internal_name: "specialized_freight_trucking", industry_type: :industry_group, naics_code: "4842").first_or_create
    IndustryCode.where(name: "Urban Transit Systems", internal_name: "urban_transit_systems", industry_type: :industry_group, naics_code: "4851").first_or_create
    IndustryCode.where(name: "Interurban and Rural Bus Transportation", internal_name: "interurban_and_rural_bus_transportation", industry_type: :industry_group, naics_code: "4852").first_or_create
    IndustryCode.where(name: "Taxi and Limousine Service", internal_name: "taxi_and_limousine_service", industry_type: :industry_group, naics_code: "4853").first_or_create
    IndustryCode.where(name: "School and Employee Bus Transportation", internal_name: "school_and_employee_bus_transportation", industry_type: :industry_group, naics_code: "4854").first_or_create
    IndustryCode.where(name: "Charter Bus Industry", internal_name: "charter_bus_industry", industry_type: :industry_group, naics_code: "4855").first_or_create
    IndustryCode.where(name: "Other Transit and Ground Passenger Transportation", internal_name: "other_transit_and_ground_passenger_transportation", industry_type: :industry_group, naics_code: "4859").first_or_create
    IndustryCode.where(name: "Pipeline Transportation of Crude Oil", internal_name: "pipeline_transportation_of_crude_oil", industry_type: :industry_group, naics_code: "4861").first_or_create
    IndustryCode.where(name: "Pipeline Transportation of Natural Gas", internal_name: "pipeline_transportation_of_natural_gas", industry_type: :industry_group, naics_code: "4862").first_or_create
    IndustryCode.where(name: "Other Pipeline Transportation", internal_name: "other_pipeline_transportation", industry_type: :industry_group, naics_code: "4869").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation, Land", internal_name: "scenic_and_sightseeing_transportation_land", industry_type: :industry_group, naics_code: "4871").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation, Water", internal_name: "scenic_and_sightseeing_transportation_water", industry_type: :industry_group, naics_code: "4872").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation, Other", internal_name: "scenic_and_sightseeing_transportation_other", industry_type: :industry_group, naics_code: "4879").first_or_create
    IndustryCode.where(name: "Support Activities for Air Transportation", internal_name: "support_activities_for_air_transportation", industry_type: :industry_group, naics_code: "4881").first_or_create
    IndustryCode.where(name: "Support Activities for Rail Transportation", internal_name: "support_activities_for_rail_transportation", industry_type: :industry_group, naics_code: "4882").first_or_create
    IndustryCode.where(name: "Support Activities for Water Transportation", internal_name: "support_activities_for_water_transportation", industry_type: :industry_group, naics_code: "4883").first_or_create
    IndustryCode.where(name: "Support Activities for Road Transportation", internal_name: "support_activities_for_road_transportation", industry_type: :industry_group, naics_code: "4884").first_or_create
    IndustryCode.where(name: "Freight Transportation Arrangement", internal_name: "freight_transportation_arrangement", industry_type: :industry_group, naics_code: "4885").first_or_create
    IndustryCode.where(name: "Other Support Activities for Transportation", internal_name: "other_support_activities_for_transportation", industry_type: :industry_group, naics_code: "4889").first_or_create
    IndustryCode.where(name: "Postal Service", internal_name: "postal_service", industry_type: :industry_group, naics_code: "4911").first_or_create
    IndustryCode.where(name: "Couriers and Express Delivery Services", internal_name: "couriers_and_express_delivery_services", industry_type: :industry_group, naics_code: "4921").first_or_create
    IndustryCode.where(name: "Local Messengers and Local Delivery", internal_name: "local_messengers_and_local_delivery", industry_type: :industry_group, naics_code: "4922").first_or_create
    IndustryCode.where(name: "Warehousing and Storage", internal_name: "warehousing_and_storage", industry_type: :industry_group, naics_code: "4931").first_or_create
    IndustryCode.where(name: "Newspaper, Periodical, Book, and Directory Publishers", internal_name: "newspaper_periodical_book_and_directory_publishers", industry_type: :industry_group, naics_code: "5111").first_or_create
    IndustryCode.where(name: "Software Publishers", internal_name: "software_publishers", industry_type: :industry_group, naics_code: "5112").first_or_create
    IndustryCode.where(name: "Motion Picture and Video Industries", internal_name: "motion_picture_and_video_industries", industry_type: :industry_group, naics_code: "5121").first_or_create
    IndustryCode.where(name: "Sound Recording Industries", internal_name: "sound_recording_industries", industry_type: :industry_group, naics_code: "5122").first_or_create
    IndustryCode.where(name: "Radio and Television Broadcasting", internal_name: "radio_and_television_broadcasting", industry_type: :industry_group, naics_code: "5151").first_or_create
    IndustryCode.where(name: "Cable and Other Subscription Programming", internal_name: "cable_and_other_subscription_programming", industry_type: :industry_group, naics_code: "5152").first_or_create
    IndustryCode.where(name: "Wired Telecommunications Carriers", internal_name: "wired_telecommunications_carriers", industry_type: :industry_group, naics_code: "5171").first_or_create
    IndustryCode.where(name: "Wireless Telecommunications Carriers (except Satellite)", internal_name: "wireless_telecommunications_carriers_except_satellite", industry_type: :industry_group, naics_code: "5172").first_or_create
    IndustryCode.where(name: "Satellite Telecommunications", internal_name: "satellite_telecommunications", industry_type: :industry_group, naics_code: "5174").first_or_create
    IndustryCode.where(name: "Other Telecommunications", internal_name: "other_telecommunications", industry_type: :industry_group, naics_code: "5179").first_or_create
    IndustryCode.where(name: "Data Processing, Hosting, and Related Services", internal_name: "data_processing_hosting_and_related_services", industry_type: :industry_group, naics_code: "5182").first_or_create
    IndustryCode.where(name: "Other Information Services", internal_name: "other_information_services", industry_type: :industry_group, naics_code: "5191").first_or_create
    IndustryCode.where(name: "Monetary Authorities_Central Bank", internal_name: "monetary_authorities_central_bank", industry_type: :industry_group, naics_code: "5211").first_or_create
    IndustryCode.where(name: "Depository Credit Intermediation", internal_name: "depository_credit_intermediation", industry_type: :industry_group, naics_code: "5221").first_or_create
    IndustryCode.where(name: "Nondepository Credit Intermediation", internal_name: "nondepository_credit_intermediation", industry_type: :industry_group, naics_code: "5222").first_or_create
    IndustryCode.where(name: "Activities Related to Credit Intermediation", internal_name: "activities_related_to_credit_intermediation", industry_type: :industry_group, naics_code: "5223").first_or_create
    IndustryCode.where(name: "Securities and Commodity Contracts Intermediation and Brokerage", internal_name: "securities_and_commodity_contracts_intermediation_and_brokerage", industry_type: :industry_group, naics_code: "5231").first_or_create
    IndustryCode.where(name: "Securities and Commodity Exchanges", internal_name: "securities_and_commodity_exchanges", industry_type: :industry_group, naics_code: "5232").first_or_create
    IndustryCode.where(name: "Other Financial Investment Activities", internal_name: "other_financial_investment_activities", industry_type: :industry_group, naics_code: "5239").first_or_create
    IndustryCode.where(name: "Insurance Carriers", internal_name: "insurance_carriers", industry_type: :industry_group, naics_code: "5241").first_or_create
    IndustryCode.where(name: "Agencies, Brokerages, and Other Insurance Related Activities", internal_name: "agencies_brokerages_and_other_insurance_related_activities", industry_type: :industry_group, naics_code: "5242").first_or_create
    IndustryCode.where(name: "Insurance and Employee Benefit Funds", internal_name: "insurance_and_employee_benefit_funds", industry_type: :industry_group, naics_code: "5251").first_or_create
    IndustryCode.where(name: "Other Investment Pools and Funds", internal_name: "other_investment_pools_and_funds", industry_type: :industry_group, naics_code: "5259").first_or_create
    IndustryCode.where(name: "Lessors of Real Estate", internal_name: "lessors_of_real_estate", industry_type: :industry_group, naics_code: "5311").first_or_create
    IndustryCode.where(name: "Offices of Real Estate Agents and Brokers", internal_name: "offices_of_real_estate_agents_and_brokers", industry_type: :industry_group, naics_code: "5312").first_or_create
    IndustryCode.where(name: "Activities Related to Real Estate", internal_name: "activities_related_to_real_estate", industry_type: :industry_group, naics_code: "5313").first_or_create
    IndustryCode.where(name: "Automotive Equipment Rental and Leasing", internal_name: "automotive_equipment_rental_and_leasing", industry_type: :industry_group, naics_code: "5321").first_or_create
    IndustryCode.where(name: "Consumer Goods Rental", internal_name: "consumer_goods_rental", industry_type: :industry_group, naics_code: "5322").first_or_create
    IndustryCode.where(name: "General Rental Centers", internal_name: "general_rental_centers", industry_type: :industry_group, naics_code: "5323").first_or_create
    IndustryCode.where(name: "Commercial and Industrial Machinery and Equipment Rental and Leasing", internal_name: "commercial_and_industrial_machinery_and_equipment_rental_and_leasing", industry_type: :industry_group, naics_code: "5324").first_or_create
    IndustryCode.where(name: "Lessors of Nonfinancial Intangible Assets (except Copyrighted Works)", internal_name: "lessors_of_nonfinancial_intangible_assets_except_copyrighted_works", industry_type: :industry_group, naics_code: "5331").first_or_create
    IndustryCode.where(name: "Legal Services", internal_name: "legal_services", industry_type: :industry_group, naics_code: "5411").first_or_create
    IndustryCode.where(name: "Accounting, Tax Preparation, Bookkeeping, and Payroll Services", internal_name: "accounting_tax_preparation_bookkeeping_and_payroll_services", industry_type: :industry_group, naics_code: "5412").first_or_create
    IndustryCode.where(name: "Architectural, Engineering, and Related Services", internal_name: "architectural_engineering_and_related_services", industry_type: :industry_group, naics_code: "5413").first_or_create
    IndustryCode.where(name: "Specialized Design Services", internal_name: "specialized_design_services", industry_type: :industry_group, naics_code: "5414").first_or_create
    IndustryCode.where(name: "Computer Systems Design and Related Services", internal_name: "computer_systems_design_and_related_services", industry_type: :industry_group, naics_code: "5415").first_or_create
    IndustryCode.where(name: "Management, Scientific, and Technical Consulting Services", internal_name: "management_scientific_and_technical_consulting_services", industry_type: :industry_group, naics_code: "5416").first_or_create
    IndustryCode.where(name: "Scientific Research and Development Services", internal_name: "scientific_research_and_development_services", industry_type: :industry_group, naics_code: "5417").first_or_create
    IndustryCode.where(name: "Advertising, Public Relations, and Related Services", internal_name: "advertising_public_relations_and_related_services", industry_type: :industry_group, naics_code: "5418").first_or_create
    IndustryCode.where(name: "Other Professional, Scientific, and Technical Services", internal_name: "other_professional_scientific_and_technical_services", industry_type: :industry_group, naics_code: "5419").first_or_create
    IndustryCode.where(name: "Management of Companies and Enterprises", internal_name: "management_of_companies_and_enterprises", industry_type: :industry_group, naics_code: "5511").first_or_create
    IndustryCode.where(name: "Office Administrative Services", internal_name: "office_administrative_services", industry_type: :industry_group, naics_code: "5611").first_or_create
    IndustryCode.where(name: "Facilities Support Services", internal_name: "facilities_support_services", industry_type: :industry_group, naics_code: "5612").first_or_create
    IndustryCode.where(name: "Employment Services", internal_name: "employment_services", industry_type: :industry_group, naics_code: "5613").first_or_create
    IndustryCode.where(name: "Business Support Services", internal_name: "business_support_services", industry_type: :industry_group, naics_code: "5614").first_or_create
    IndustryCode.where(name: "Travel Arrangement and Reservation Services", internal_name: "travel_arrangement_and_reservation_services", industry_type: :industry_group, naics_code: "5615").first_or_create
    IndustryCode.where(name: "Investigation and Security Services", internal_name: "investigation_and_security_services", industry_type: :industry_group, naics_code: "5616").first_or_create
    IndustryCode.where(name: "Services to Buildings and Dwellings", internal_name: "services_to_buildings_and_dwellings", industry_type: :industry_group, naics_code: "5617").first_or_create
    IndustryCode.where(name: "Other Support Services", internal_name: "other_support_services", industry_type: :industry_group, naics_code: "5619").first_or_create
    IndustryCode.where(name: "Waste Collection", internal_name: "waste_collection", industry_type: :industry_group, naics_code: "5621").first_or_create
    IndustryCode.where(name: "Waste Treatment and Disposal", internal_name: "waste_treatment_and_disposal", industry_type: :industry_group, naics_code: "5622").first_or_create
    IndustryCode.where(name: "Remediation and Other Waste Management Services", internal_name: "remediation_and_other_waste_management_services", industry_type: :industry_group, naics_code: "5629").first_or_create
    IndustryCode.where(name: "Elementary and Secondary Schools", internal_name: "elementary_and_secondary_schools", industry_type: :industry_group, naics_code: "6111").first_or_create
    IndustryCode.where(name: "Junior Colleges", internal_name: "junior_colleges", industry_type: :industry_group, naics_code: "6112").first_or_create
    IndustryCode.where(name: "Colleges, Universities, and Professional Schools", internal_name: "colleges_universities_and_professional_schools", industry_type: :industry_group, naics_code: "6113").first_or_create
    IndustryCode.where(name: "Business Schools and Computer and Management Training", internal_name: "business_schools_and_computer_and_management_training", industry_type: :industry_group, naics_code: "6114").first_or_create
    IndustryCode.where(name: "Technical and Trade Schools", internal_name: "technical_and_trade_schools", industry_type: :industry_group, naics_code: "6115").first_or_create
    IndustryCode.where(name: "Other Schools and Instruction", internal_name: "other_schools_and_instruction", industry_type: :industry_group, naics_code: "6116").first_or_create
    IndustryCode.where(name: "Educational Support Services", internal_name: "educational_support_services", industry_type: :industry_group, naics_code: "6117").first_or_create
    IndustryCode.where(name: "Offices of Physicians", internal_name: "offices_of_physicians", industry_type: :industry_group, naics_code: "6211").first_or_create
    IndustryCode.where(name: "Offices of Dentists", internal_name: "offices_of_dentists", industry_type: :industry_group, naics_code: "6212").first_or_create
    IndustryCode.where(name: "Offices of Other Health Practitioners", internal_name: "offices_of_other_health_practitioners", industry_type: :industry_group, naics_code: "6213").first_or_create
    IndustryCode.where(name: "Outpatient Care Centers", internal_name: "outpatient_care_centers", industry_type: :industry_group, naics_code: "6214").first_or_create
    IndustryCode.where(name: "Medical and Diagnostic Laboratories", internal_name: "medical_and_diagnostic_laboratories", industry_type: :industry_group, naics_code: "6215").first_or_create
    IndustryCode.where(name: "Home Health Care Services", internal_name: "home_health_care_services", industry_type: :industry_group, naics_code: "6216").first_or_create
    IndustryCode.where(name: "Other Ambulatory Health Care Services", internal_name: "other_ambulatory_health_care_services", industry_type: :industry_group, naics_code: "6219").first_or_create
    IndustryCode.where(name: "General Medical and Surgical Hospitals", internal_name: "general_medical_and_surgical_hospitals", industry_type: :industry_group, naics_code: "6221").first_or_create
    IndustryCode.where(name: "Psychiatric and Substance Abuse Hospitals", internal_name: "psychiatric_and_substance_abuse_hospitals", industry_type: :industry_group, naics_code: "6222").first_or_create
    IndustryCode.where(name: "Specialty (except Psychiatric and Substance Abuse) Hospitals", internal_name: "specialty_except_psychiatric_and_substance_abuse_hospitals", industry_type: :industry_group, naics_code: "6223").first_or_create
    IndustryCode.where(name: "Nursing Care Facilities (Skilled Nursing Facilities)", internal_name: "nursing_care_facilities_skilled_nursing_facilities", industry_type: :industry_group, naics_code: "6231").first_or_create
    IndustryCode.where(name: "Residential Intellectual and Developmental Disability, Mental Health, and Substance Abuse Facilities", internal_name: "residential_intellectual_and_developmental_disability_mental_health_and_substance_abuse_facilities", industry_type: :industry_group, naics_code: "6232").first_or_create
    IndustryCode.where(name: "Continuing Care Retirement Communities and Assisted Living Facilities for the Elderly", internal_name: "continuing_care_retirement_communities_and_assisted_living_facilities_for_the_elderly", industry_type: :industry_group, naics_code: "6233").first_or_create
    IndustryCode.where(name: "Other Residential Care Facilities", internal_name: "other_residential_care_facilities", industry_type: :industry_group, naics_code: "6239").first_or_create
    IndustryCode.where(name: "Individual and Family Services", internal_name: "individual_and_family_services", industry_type: :industry_group, naics_code: "6241").first_or_create
    IndustryCode.where(name: "Community Food and Housing, and Emergency and Other Relief Services", internal_name: "community_food_and_housing_and_emergency_and_other_relief_services", industry_type: :industry_group, naics_code: "6242").first_or_create
    IndustryCode.where(name: "Vocational Rehabilitation Services", internal_name: "vocational_rehabilitation_services", industry_type: :industry_group, naics_code: "6243").first_or_create
    IndustryCode.where(name: "Child Day Care Services", internal_name: "child_day_care_services", industry_type: :industry_group, naics_code: "6244").first_or_create
    IndustryCode.where(name: "Performing Arts Companies", internal_name: "performing_arts_companies", industry_type: :industry_group, naics_code: "7111").first_or_create
    IndustryCode.where(name: "Spectator Sports", internal_name: "spectator_sports", industry_type: :industry_group, naics_code: "7112").first_or_create
    IndustryCode.where(name: "Promoters of Performing Arts, Sports, and Similar Events", internal_name: "promoters_of_performing_arts_sports_and_similar_events", industry_type: :industry_group, naics_code: "7113").first_or_create
    IndustryCode.where(name: "Agents and Managers for Artists, Athletes, Entertainers, and Other Public Figures", internal_name: "agents_and_managers_for_artists_athletes_entertainers_and_other_public_figures", industry_type: :industry_group, naics_code: "7114").first_or_create
    IndustryCode.where(name: "Independent Artists, Writers, and Performers", internal_name: "independent_artists_writers_and_performers", industry_type: :industry_group, naics_code: "7115").first_or_create
    IndustryCode.where(name: "Museums, Historical Sites, and Similar Institutions", internal_name: "museums_historical_sites_and_similar_institutions", industry_type: :industry_group, naics_code: "7121").first_or_create
    IndustryCode.where(name: "Amusement Parks and Arcades", internal_name: "amusement_parks_and_arcades", industry_type: :industry_group, naics_code: "7131").first_or_create
    IndustryCode.where(name: "Gambling Industries", internal_name: "gambling_industries", industry_type: :industry_group, naics_code: "7132").first_or_create
    IndustryCode.where(name: "Other Amusement and Recreation Industries", internal_name: "other_amusement_and_recreation_industries", industry_type: :industry_group, naics_code: "7139").first_or_create
    IndustryCode.where(name: "Traveler Accommodation", internal_name: "traveler_accommodation", industry_type: :industry_group, naics_code: "7211").first_or_create
    IndustryCode.where(name: "RV (Recreational Vehicle) Parks and Recreational Camps", internal_name: "rv_recreational_vehicle_parks_and_recreational_camps", industry_type: :industry_group, naics_code: "7212").first_or_create
    IndustryCode.where(name: "Rooming and Boarding Houses", internal_name: "rooming_and_boarding_houses", industry_type: :industry_group, naics_code: "7213").first_or_create
    IndustryCode.where(name: "Special Food Services", internal_name: "special_food_services", industry_type: :industry_group, naics_code: "7223").first_or_create
    IndustryCode.where(name: "Drinking Places (Alcoholic Beverages)", internal_name: "drinking_places_alcoholic_beverages", industry_type: :industry_group, naics_code: "7224").first_or_create
    IndustryCode.where(name: "Restaurants and Other Eating Places", internal_name: "restaurants_and_other_eating_places", industry_type: :industry_group, naics_code: "7225").first_or_create
    IndustryCode.where(name: "Automotive Repair and Maintenance", internal_name: "automotive_repair_and_maintenance", industry_type: :industry_group, naics_code: "8111").first_or_create
    IndustryCode.where(name: "Electronic and Precision Equipment Repair and Maintenance", internal_name: "electronic_and_precision_equipment_repair_and_maintenance", industry_type: :industry_group, naics_code: "8112").first_or_create
    IndustryCode.where(name: "Commercial and Industrial Machinery and Equipment (except Automotive and Electronic) Repair and Maintenance", internal_name: "commercial_and_industrial_machinery_and_equipment_except_automotive_and_electronic_repair_and_maintenance", industry_type: :industry_group, naics_code: "8113").first_or_create
    IndustryCode.where(name: "Personal and Household Goods Repair and Maintenance", internal_name: "personal_and_household_goods_repair_and_maintenance", industry_type: :industry_group, naics_code: "8114").first_or_create
    IndustryCode.where(name: "Personal Care Services", internal_name: "personal_care_services", industry_type: :industry_group, naics_code: "8121").first_or_create
    IndustryCode.where(name: "Death Care Services", internal_name: "death_care_services", industry_type: :industry_group, naics_code: "8122").first_or_create
    IndustryCode.where(name: "Drycleaning and Laundry Services", internal_name: "drycleaning_and_laundry_services", industry_type: :industry_group, naics_code: "8123").first_or_create
    IndustryCode.where(name: "Other Personal Services", internal_name: "other_personal_services", industry_type: :industry_group, naics_code: "8129").first_or_create
    IndustryCode.where(name: "Religious Organizations", internal_name: "religious_organizations", industry_type: :industry_group, naics_code: "8131").first_or_create
    IndustryCode.where(name: "Grantmaking and Giving Services", internal_name: "grantmaking_and_giving_services", industry_type: :industry_group, naics_code: "8132").first_or_create
    IndustryCode.where(name: "Social Advocacy Organizations", internal_name: "social_advocacy_organizations", industry_type: :industry_group, naics_code: "8133").first_or_create
    IndustryCode.where(name: "Civic and Social Organizations", internal_name: "civic_and_social_organizations", industry_type: :industry_group, naics_code: "8134").first_or_create
    IndustryCode.where(name: "Business, Professional, Labor, Political, and Similar Organizations", internal_name: "business_professional_labor_political_and_similar_organizations", industry_type: :industry_group, naics_code: "8139").first_or_create
    IndustryCode.where(name: "Private Households", internal_name: "private_households", industry_type: :industry_group, naics_code: "8141").first_or_create
    IndustryCode.where(name: "Executive, Legislative, and Other General Government Support", internal_name: "executive_legislative_and_other_general_government_support", industry_type: :industry_group, naics_code: "9211").first_or_create
    IndustryCode.where(name: "Justice, Public Order, and Safety Activities", internal_name: "justice_public_order_and_safety_activities", industry_type: :industry_group, naics_code: "9221").first_or_create
    IndustryCode.where(name: "Administration of Human Resource Programs", internal_name: "administration_of_human_resource_programs", industry_type: :industry_group, naics_code: "9231").first_or_create
    IndustryCode.where(name: "Administration of Environmental Quality Programs", internal_name: "administration_of_environmental_quality_programs", industry_type: :industry_group, naics_code: "9241").first_or_create
    IndustryCode.where(name: "Administration of Housing Programs, Urban Planning, and Community Development", internal_name: "administration_of_housing_programs_urban_planning_and_community_development", industry_type: :industry_group, naics_code: "9251").first_or_create
    IndustryCode.where(name: "Administration of Economic Program", internal_name: "administration_of_economic_program", industry_type: :industry_group, naics_code: "9261").first_or_create
    IndustryCode.where(name: "Space Research and Technology", internal_name: "space_research_and_technology", industry_type: :industry_group, naics_code: "9271").first_or_create
    IndustryCode.where(name: "National Security and International Affairs", internal_name: "national_security_and_international_affairs", industry_type: :industry_group, naics_code: "9281").first_or_create

    #NAICS industry
    IndustryCode.where(name: "Soybean Farming", internal_name: "soybean_farming", industry_type: :industry, naics_code: "111110").first_or_create
    IndustryCode.where(name: "Oilseed (except Soybean) Farming", internal_name: "oilseed_except_soybean_farming", industry_type: :industry, naics_code: "111120").first_or_create
    IndustryCode.where(name: "Dry Pea and Bean Farming", internal_name: "dry_pea_and_bean_farming", industry_type: :industry, naics_code: "111130").first_or_create
    IndustryCode.where(name: "Wheat Farming", internal_name: "wheat_farming", industry_type: :industry, naics_code: "111140").first_or_create
    IndustryCode.where(name: "Corn Farming", internal_name: "corn_farming", industry_type: :industry, naics_code: "111150").first_or_create
    IndustryCode.where(name: "Rice Farming", internal_name: "rice_farming", industry_type: :industry, naics_code: "111160").first_or_create
    IndustryCode.where(name: "Oilseed and Grain Combination Farming", internal_name: "oilseed_and_grain_combination_farming", industry_type: :industry, naics_code: "111191").first_or_create
    IndustryCode.where(name: "All Other Grain Farming", internal_name: "all_other_grain_farming", industry_type: :industry, naics_code: "111199").first_or_create
    IndustryCode.where(name: "Potato Farming", internal_name: "potato_farming", industry_type: :industry, naics_code: "111211").first_or_create
    IndustryCode.where(name: "Other Vegetable (except Potato) and Melon Farming", internal_name: "other_vegetable_except_potato_and_melon_farming", industry_type: :industry, naics_code: "111219").first_or_create
    IndustryCode.where(name: "Orange Groves", internal_name: "orange_groves", industry_type: :industry, naics_code: "111310").first_or_create
    IndustryCode.where(name: "Citrus (except Orange) Groves", internal_name: "citrus_except_orange_groves", industry_type: :industry, naics_code: "111320").first_or_create
    IndustryCode.where(name: "Apple Orchards", internal_name: "apple_orchards", industry_type: :industry, naics_code: "111331").first_or_create
    IndustryCode.where(name: "Grape Vineyards", internal_name: "grape_vineyards", industry_type: :industry, naics_code: "111332").first_or_create
    IndustryCode.where(name: "Strawberry Farming", internal_name: "strawberry_farming", industry_type: :industry, naics_code: "111333").first_or_create
    IndustryCode.where(name: "Berry (except Strawberry) Farming", internal_name: "berry_except_strawberry_farming", industry_type: :industry, naics_code: "111334").first_or_create
    IndustryCode.where(name: "Tree Nut Farming", internal_name: "tree_nut_farming", industry_type: :industry, naics_code: "111335").first_or_create
    IndustryCode.where(name: "Fruit and Tree Nut Combination Farming", internal_name: "fruit_and_tree_nut_combination_farming", industry_type: :industry, naics_code: "111336").first_or_create
    IndustryCode.where(name: "Other Noncitrus Fruit Farming", internal_name: "other_noncitrus_fruit_farming", industry_type: :industry, naics_code: "111339").first_or_create
    IndustryCode.where(name: "Mushroom Production", internal_name: "mushroom_production", industry_type: :industry, naics_code: "111411").first_or_create
    IndustryCode.where(name: "Other Food Crops Grown Under Cover", internal_name: "other_food_crops_grown_under_cover", industry_type: :industry, naics_code: "111419").first_or_create
    IndustryCode.where(name: "Nursery and Tree Production", internal_name: "nursery_and_tree_production", industry_type: :industry, naics_code: "111421").first_or_create
    IndustryCode.where(name: "Floriculture Production", internal_name: "floriculture_production", industry_type: :industry, naics_code: "111422").first_or_create
    IndustryCode.where(name: "Tobacco Farming", internal_name: "tobacco_farming", industry_type: :industry, naics_code: "111910").first_or_create
    IndustryCode.where(name: "Cotton Farming", internal_name: "cotton_farming", industry_type: :industry, naics_code: "111920").first_or_create
    IndustryCode.where(name: "Sugarcane Farming", internal_name: "sugarcane_farming", industry_type: :industry, naics_code: "111930").first_or_create
    IndustryCode.where(name: "Hay Farming", internal_name: "hay_farming", industry_type: :industry, naics_code: "111940").first_or_create
    IndustryCode.where(name: "Sugar Beet Farming", internal_name: "sugar_beet_farming", industry_type: :industry, naics_code: "111991").first_or_create
    IndustryCode.where(name: "Peanut Farming", internal_name: "peanut_farming", industry_type: :industry, naics_code: "111992").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Crop Farming", internal_name: "all_other_miscellaneous_crop_farming", industry_type: :industry, naics_code: "111998").first_or_create
    IndustryCode.where(name: "Beef Cattle Ranching and Farming", internal_name: "beef_cattle_ranching_and_farming", industry_type: :industry, naics_code: "112111").first_or_create
    IndustryCode.where(name: "Cattle Feedlots", internal_name: "cattle_feedlots", industry_type: :industry, naics_code: "112112").first_or_create
    IndustryCode.where(name: "Dairy Cattle and Milk Production", internal_name: "dairy_cattle_and_milk_production", industry_type: :industry, naics_code: "112120").first_or_create
    IndustryCode.where(name: "Dual_Purpose Cattle Ranching and Farming", internal_name: "dual_purpose_cattle_ranching_and_farming", industry_type: :industry, naics_code: "112130").first_or_create
    IndustryCode.where(name: "Hog and Pig Farming", internal_name: "hog_and_pig_farming", industry_type: :industry, naics_code: "112210").first_or_create
    IndustryCode.where(name: "Chicken Egg Production", internal_name: "chicken_egg_production", industry_type: :industry, naics_code: "112310").first_or_create
    IndustryCode.where(name: "Broilers and Other Meat Type Chicken Production", internal_name: "broilers_and_other_meat_type_chicken_production", industry_type: :industry, naics_code: "112320").first_or_create
    IndustryCode.where(name: "Turkey Production", internal_name: "turkey_production", industry_type: :industry, naics_code: "112330").first_or_create
    IndustryCode.where(name: "Poultry Hatcheries", internal_name: "poultry_hatcheries", industry_type: :industry, naics_code: "112340").first_or_create
    IndustryCode.where(name: "Other Poultry Production", internal_name: "other_poultry_production", industry_type: :industry, naics_code: "112390").first_or_create
    IndustryCode.where(name: "Sheep Farming", internal_name: "sheep_farming", industry_type: :industry, naics_code: "112410").first_or_create
    IndustryCode.where(name: "Goat Farming", internal_name: "goat_farming", industry_type: :industry, naics_code: "112420").first_or_create
    IndustryCode.where(name: "Finfish Farming and Fish Hatcheries", internal_name: "finfish_farming_and_fish_hatcheries", industry_type: :industry, naics_code: "112511").first_or_create
    IndustryCode.where(name: "Shellfish Farming", internal_name: "shellfish_farming", industry_type: :industry, naics_code: "112512").first_or_create
    IndustryCode.where(name: "Other Aquaculture", internal_name: "other_aquaculture", industry_type: :industry, naics_code: "112519").first_or_create
    IndustryCode.where(name: "Apiculture", internal_name: "apiculture", industry_type: :industry, naics_code: "112910").first_or_create
    IndustryCode.where(name: "Horses and Other Equine Production", internal_name: "horses_and_other_equine_production", industry_type: :industry, naics_code: "112920").first_or_create
    IndustryCode.where(name: "Fur_Bearing Animal and Rabbit Production", internal_name: "fur_bearing_animal_and_rabbit_production", industry_type: :industry, naics_code: "112930").first_or_create
    IndustryCode.where(name: "All Other Animal Production", internal_name: "all_other_animal_production", industry_type: :industry, naics_code: "112990").first_or_create
    IndustryCode.where(name: "Timber Tract Operations", internal_name: "timber_tract_operations", industry_type: :industry, naics_code: "113110").first_or_create
    IndustryCode.where(name: "Forest Nurseries and Gathering of Forest Products", internal_name: "forest_nurseries_and_gathering_of_forest_products", industry_type: :industry, naics_code: "113210").first_or_create
    IndustryCode.where(name: "Logging", internal_name: "logging", industry_type: :industry, naics_code: "113310").first_or_create
    IndustryCode.where(name: "Finfish Fishing", internal_name: "finfish_fishing", industry_type: :industry, naics_code: "114111").first_or_create
    IndustryCode.where(name: "Shellfish Fishing", internal_name: "shellfish_fishing", industry_type: :industry, naics_code: "114112").first_or_create
    IndustryCode.where(name: "Other Marine Fishing", internal_name: "other_marine_fishing", industry_type: :industry, naics_code: "114119").first_or_create
    IndustryCode.where(name: "Hunting and Trapping", internal_name: "hunting_and_trapping", industry_type: :industry, naics_code: "114210").first_or_create
    IndustryCode.where(name: "Cotton Ginning", internal_name: "cotton_ginning", industry_type: :industry, naics_code: "115111").first_or_create
    IndustryCode.where(name: "Soil Preparation, Planting, and Cultivating", internal_name: "soil_preparation_planting_and_cultivating", industry_type: :industry, naics_code: "115112").first_or_create
    IndustryCode.where(name: "Crop Harvesting, Primarily by Machine", internal_name: "crop_harvesting_primarily_by_machine", industry_type: :industry, naics_code: "115113").first_or_create
    IndustryCode.where(name: "Postharvest Crop Activities (except Cotton Ginning)", internal_name: "postharvest_crop_activities_except_cotton_ginning", industry_type: :industry, naics_code: "115114").first_or_create
    IndustryCode.where(name: "Farm Labor Contractors and Crew Leaders", internal_name: "farm_labor_contractors_and_crew_leaders", industry_type: :industry, naics_code: "115115").first_or_create
    IndustryCode.where(name: "Farm Management Services", internal_name: "farm_management_services", industry_type: :industry, naics_code: "115116").first_or_create
    IndustryCode.where(name: "Support Activities for Animal Production", internal_name: "support_activities_for_animal_production", industry_type: :industry, naics_code: "115210").first_or_create
    IndustryCode.where(name: "Support Activities for Forestry", internal_name: "support_activities_for_forestry", industry_type: :industry, naics_code: "115310").first_or_create
    IndustryCode.where(name: "Crude Petroleum and Natural Gas Extraction", internal_name: "crude_petroleum_and_natural_gas_extraction", industry_type: :industry, naics_code: "211111").first_or_create
    IndustryCode.where(name: "Natural Gas Liquid Extraction", internal_name: "natural_gas_liquid_extraction", industry_type: :industry, naics_code: "211112").first_or_create
    IndustryCode.where(name: "Bituminous Coal and Lignite Surface Mining", internal_name: "bituminous_coal_and_lignite_surface_mining", industry_type: :industry, naics_code: "212111").first_or_create
    IndustryCode.where(name: "Bituminous Coal Underground Mining", internal_name: "bituminous_coal_underground_mining", industry_type: :industry, naics_code: "212112").first_or_create
    IndustryCode.where(name: "Anthracite Mining", internal_name: "anthracite_mining", industry_type: :industry, naics_code: "212113").first_or_create
    IndustryCode.where(name: "Iron Ore Mining", internal_name: "iron_ore_mining", industry_type: :industry, naics_code: "212210").first_or_create
    IndustryCode.where(name: "Gold Ore Mining", internal_name: "gold_ore_mining", industry_type: :industry, naics_code: "212221").first_or_create
    IndustryCode.where(name: "Silver Ore Mining", internal_name: "silver_ore_mining", industry_type: :industry, naics_code: "212222").first_or_create
    IndustryCode.where(name: "Lead Ore and Zinc Ore Mining", internal_name: "lead_ore_and_zinc_ore_mining", industry_type: :industry, naics_code: "212231").first_or_create
    IndustryCode.where(name: "Copper Ore and Nickel Ore Mining", internal_name: "copper_ore_and_nickel_ore_mining", industry_type: :industry, naics_code: "212234").first_or_create
    IndustryCode.where(name: "Uranium_Radium_Vanadium Ore Mining", internal_name: "uranium_radium_vanadium_ore_mining", industry_type: :industry, naics_code: "212291").first_or_create
    IndustryCode.where(name: "All Other Metal Ore Mining", internal_name: "all_other_metal_ore_mining", industry_type: :industry, naics_code: "212299").first_or_create
    IndustryCode.where(name: "Dimension Stone Mining and Quarrying", internal_name: "dimension_stone_mining_and_quarrying", industry_type: :industry, naics_code: "212311").first_or_create
    IndustryCode.where(name: "Crushed and Broken Limestone Mining and Quarrying", internal_name: "crushed_and_broken_limestone_mining_and_quarrying", industry_type: :industry, naics_code: "212312").first_or_create
    IndustryCode.where(name: "Crushed and Broken Granite Mining and Quarrying", internal_name: "crushed_and_broken_granite_mining_and_quarrying", industry_type: :industry, naics_code: "212313").first_or_create
    IndustryCode.where(name: "Other Crushed and Broken Stone Mining and Quarrying", internal_name: "other_crushed_and_broken_stone_mining_and_quarrying", industry_type: :industry, naics_code: "212319").first_or_create
    IndustryCode.where(name: "Construction Sand and Gravel Mining", internal_name: "construction_sand_and_gravel_mining", industry_type: :industry, naics_code: "212321").first_or_create
    IndustryCode.where(name: "Industrial Sand Mining", internal_name: "industrial_sand_mining", industry_type: :industry, naics_code: "212322").first_or_create
    IndustryCode.where(name: "Kaolin and Ball Clay Mining", internal_name: "kaolin_and_ball_clay_mining", industry_type: :industry, naics_code: "212324").first_or_create
    IndustryCode.where(name: "Clay and Ceramic and Refractory Minerals Mining", internal_name: "clay_and_ceramic_and_refractory_minerals_mining", industry_type: :industry, naics_code: "212325").first_or_create
    IndustryCode.where(name: "Potash, Soda, and Borate Mineral Mining", internal_name: "potash_soda_and_borate_mineral_mining", industry_type: :industry, naics_code: "212391").first_or_create
    IndustryCode.where(name: "Phosphate Rock Mining", internal_name: "phosphate_rock_mining", industry_type: :industry, naics_code: "212392").first_or_create
    IndustryCode.where(name: "Other Chemical and Fertilizer Mineral Mining", internal_name: "other_chemical_and_fertilizer_mineral_mining", industry_type: :industry, naics_code: "212393").first_or_create
    IndustryCode.where(name: "All Other Nonmetallic Mineral Mining", internal_name: "all_other_nonmetallic_mineral_mining", industry_type: :industry, naics_code: "212399").first_or_create
    IndustryCode.where(name: "Drilling Oil and Gas Wells", internal_name: "drilling_oil_and_gas_wells", industry_type: :industry, naics_code: "213111").first_or_create
    IndustryCode.where(name: "Support Activities for Oil and Gas Operations", internal_name: "support_activities_for_oil_and_gas_operations", industry_type: :industry, naics_code: "213112").first_or_create
    IndustryCode.where(name: "Support Activities for Coal Mining", internal_name: "support_activities_for_coal_mining", industry_type: :industry, naics_code: "213113").first_or_create
    IndustryCode.where(name: "Support Activities for Metal Mining", internal_name: "support_activities_for_metal_mining", industry_type: :industry, naics_code: "213114").first_or_create
    IndustryCode.where(name: "Support Activities for Nonmetallic Minerals (except Fuels) Mining", internal_name: "support_activities_for_nonmetallic_minerals_except_fuels_mining", industry_type: :industry, naics_code: "213115").first_or_create
    IndustryCode.where(name: "Hydroelectric Power Generation", internal_name: "hydroelectric_power_generation", industry_type: :industry, naics_code: "221111").first_or_create
    IndustryCode.where(name: "Fossil Fuel Electric Power Generation", internal_name: "fossil_fuel_electric_power_generation", industry_type: :industry, naics_code: "221112").first_or_create
    IndustryCode.where(name: "Nuclear Electric Power Generation", internal_name: "nuclear_electric_power_generation", industry_type: :industry, naics_code: "221113").first_or_create
    IndustryCode.where(name: "Solar Electric Power Generation", internal_name: "solar_electric_power_generation", industry_type: :industry, naics_code: "221114").first_or_create
    IndustryCode.where(name: "Wind Electric Power Generation", internal_name: "wind_electric_power_generation", industry_type: :industry, naics_code: "221115").first_or_create
    IndustryCode.where(name: "Geothermal Electric Power Generation", internal_name: "geothermal_electric_power_generation", industry_type: :industry, naics_code: "221116").first_or_create
    IndustryCode.where(name: "Biomass Electric Power Generation", internal_name: "biomass_electric_power_generation", industry_type: :industry, naics_code: "221117").first_or_create
    IndustryCode.where(name: "Other Electric Power Generation", internal_name: "other_electric_power_generation", industry_type: :industry, naics_code: "221118").first_or_create
    IndustryCode.where(name: "Electric Bulk Power Transmission and Control", internal_name: "electric_bulk_power_transmission_and_control", industry_type: :industry, naics_code: "221121").first_or_create
    IndustryCode.where(name: "Electric Power Distribution", internal_name: "electric_power_distribution", industry_type: :industry, naics_code: "221122").first_or_create
    IndustryCode.where(name: "Natural Gas Distribution", internal_name: "natural_gas_distribution", industry_type: :industry, naics_code: "221210").first_or_create
    IndustryCode.where(name: "Water Supply and Irrigation Systems", internal_name: "water_supply_and_irrigation_systems", industry_type: :industry, naics_code: "221310").first_or_create
    IndustryCode.where(name: "Sewage Treatment Facilities", internal_name: "sewage_treatment_facilities", industry_type: :industry, naics_code: "221320").first_or_create
    IndustryCode.where(name: "Steam and Air_Conditioning Supply", internal_name: "steam_and_air_conditioning_supply", industry_type: :industry, naics_code: "221330").first_or_create
    IndustryCode.where(name: "New Single_Family Housing Construction (except For_Sale Builders)", internal_name: "new_single_family_housing_construction_except_for_sale_builders", industry_type: :industry, naics_code: "236115").first_or_create
    IndustryCode.where(name: "New Multifamily Housing Construction (except For_Sale Builders)", internal_name: "new_multifamily_housing_construction_except_for_sale_builders", industry_type: :industry, naics_code: "236116").first_or_create
    IndustryCode.where(name: "New Housing For_Sale Builders", internal_name: "new_housing_for_sale_builders", industry_type: :industry, naics_code: "236117").first_or_create
    IndustryCode.where(name: "Residential Remodelers", internal_name: "residential_remodelers", industry_type: :industry, naics_code: "236118").first_or_create
    IndustryCode.where(name: "Industrial Building Construction", internal_name: "industrial_building_construction", industry_type: :industry, naics_code: "236210").first_or_create
    IndustryCode.where(name: "Commercial and Institutional Building Construction", internal_name: "commercial_and_institutional_building_construction", industry_type: :industry, naics_code: "236220").first_or_create
    IndustryCode.where(name: "Water and Sewer Line and Related Structures Construction", internal_name: "water_and_sewer_line_and_related_structures_construction", industry_type: :industry, naics_code: "237110").first_or_create
    IndustryCode.where(name: "Oil and Gas Pipeline and Related Structures Construction", internal_name: "oil_and_gas_pipeline_and_related_structures_construction", industry_type: :industry, naics_code: "237120").first_or_create
    IndustryCode.where(name: "Power and Communication Line and Related Structures Construction", internal_name: "power_and_communication_line_and_related_structures_construction", industry_type: :industry, naics_code: "237130").first_or_create
    IndustryCode.where(name: "Land Subdivision", internal_name: "land_subdivision", industry_type: :industry, naics_code: "237210").first_or_create
    IndustryCode.where(name: "Highway, Street, and Bridge Construction", internal_name: "highway_street_and_bridge_construction", industry_type: :industry, naics_code: "237310").first_or_create
    IndustryCode.where(name: "Other Heavy and Civil Engineering Construction", internal_name: "other_heavy_and_civil_engineering_construction", industry_type: :industry, naics_code: "237990").first_or_create
    IndustryCode.where(name: "Poured Concrete Foundation and Structure Contractors", internal_name: "poured_concrete_foundation_and_structure_contractors", industry_type: :industry, naics_code: "238110").first_or_create
    IndustryCode.where(name: "Structural Steel and Precast Concrete Contractors", internal_name: "structural_steel_and_precast_concrete_contractors", industry_type: :industry, naics_code: "238120").first_or_create
    IndustryCode.where(name: "Framing Contractors", internal_name: "framing_contractors", industry_type: :industry, naics_code: "238130").first_or_create
    IndustryCode.where(name: "Masonry Contractors", internal_name: "masonry_contractors", industry_type: :industry, naics_code: "238140").first_or_create
    IndustryCode.where(name: "Glass and Glazing Contractors", internal_name: "glass_and_glazing_contractors", industry_type: :industry, naics_code: "238150").first_or_create
    IndustryCode.where(name: "Roofing Contractors", internal_name: "roofing_contractors", industry_type: :industry, naics_code: "238160").first_or_create
    IndustryCode.where(name: "Siding Contractors", internal_name: "siding_contractors", industry_type: :industry, naics_code: "238170").first_or_create
    IndustryCode.where(name: "Other Foundation, Structure, and Building Exterior Contractors", internal_name: "other_foundation_structure_and_building_exterior_contractors", industry_type: :industry, naics_code: "238190").first_or_create
    IndustryCode.where(name: "Electrical Contractors and Other Wiring Installation Contractors", internal_name: "electrical_contractors_and_other_wiring_installation_contractors", industry_type: :industry, naics_code: "238210").first_or_create
    IndustryCode.where(name: "Plumbing, Heating, and Air_Conditioning Contractors", internal_name: "plumbing_heating_and_air_conditioning_contractors", industry_type: :industry, naics_code: "238220").first_or_create
    IndustryCode.where(name: "Other Building Equipment Contractors", internal_name: "other_building_equipment_contractors", industry_type: :industry, naics_code: "238290").first_or_create
    IndustryCode.where(name: "Drywall and Insulation Contractors", internal_name: "drywall_and_insulation_contractors", industry_type: :industry, naics_code: "238310").first_or_create
    IndustryCode.where(name: "Painting and Wall Covering Contractors", internal_name: "painting_and_wall_covering_contractors", industry_type: :industry, naics_code: "238320").first_or_create
    IndustryCode.where(name: "Flooring Contractors", internal_name: "flooring_contractors", industry_type: :industry, naics_code: "238330").first_or_create
    IndustryCode.where(name: "Tile and Terrazzo Contractors", internal_name: "tile_and_terrazzo_contractors", industry_type: :industry, naics_code: "238340").first_or_create
    IndustryCode.where(name: "Finish Carpentry Contractors", internal_name: "finish_carpentry_contractors", industry_type: :industry, naics_code: "238350").first_or_create
    IndustryCode.where(name: "Other Building Finishing Contractors", internal_name: "other_building_finishing_contractors", industry_type: :industry, naics_code: "238390").first_or_create
    IndustryCode.where(name: "Site Preparation Contractors", internal_name: "site_preparation_contractors", industry_type: :industry, naics_code: "238910").first_or_create
    IndustryCode.where(name: "All Other Specialty Trade Contractors", internal_name: "all_other_specialty_trade_contractors", industry_type: :industry, naics_code: "238990").first_or_create
    IndustryCode.where(name: "Dog and Cat Food Manufacturing", internal_name: "dog_and_cat_food_manufacturing", industry_type: :industry, naics_code: "311111").first_or_create
    IndustryCode.where(name: "Other Animal Food Manufacturing", internal_name: "other_animal_food_manufacturing", industry_type: :industry, naics_code: "311119").first_or_create
    IndustryCode.where(name: "Flour Milling", internal_name: "flour_milling", industry_type: :industry, naics_code: "311211").first_or_create
    IndustryCode.where(name: "Rice Milling", internal_name: "rice_milling", industry_type: :industry, naics_code: "311212").first_or_create
    IndustryCode.where(name: "Malt Manufacturing", internal_name: "malt_manufacturing", industry_type: :industry, naics_code: "311213").first_or_create
    IndustryCode.where(name: "Wet Corn Milling", internal_name: "wet_corn_milling", industry_type: :industry, naics_code: "311221").first_or_create
    IndustryCode.where(name: "Soybean and Other Oilseed Processing", internal_name: "soybean_and_other_oilseed_processing", industry_type: :industry, naics_code: "311224").first_or_create
    IndustryCode.where(name: "Fats and Oils Refining and Blending", internal_name: "fats_and_oils_refining_and_blending", industry_type: :industry, naics_code: "311225").first_or_create
    IndustryCode.where(name: "Breakfast Cereal Manufacturing", internal_name: "breakfast_cereal_manufacturing", industry_type: :industry, naics_code: "311230").first_or_create
    IndustryCode.where(name: "Beet Sugar Manufacturing", internal_name: "beet_sugar_manufacturing", industry_type: :industry, naics_code: "311313").first_or_create
    IndustryCode.where(name: "Cane Sugar Manufacturing", internal_name: "cane_sugar_manufacturing", industry_type: :industry, naics_code: "311314").first_or_create
    IndustryCode.where(name: "Nonchocolate Confectionery Manufacturing", internal_name: "nonchocolate_confectionery_manufacturing", industry_type: :industry, naics_code: "311340").first_or_create
    IndustryCode.where(name: "Chocolate and Confectionery Manufacturing from Cacao Beans", internal_name: "chocolate_and_confectionery_manufacturing_from_cacao_beans", industry_type: :industry, naics_code: "311351").first_or_create
    IndustryCode.where(name: "Confectionery Manufacturing from Purchased Chocolate", internal_name: "confectionery_manufacturing_from_purchased_chocolate", industry_type: :industry, naics_code: "311352").first_or_create
    IndustryCode.where(name: "Frozen Fruit, Juice, and Vegetable Manufacturing", internal_name: "frozen_fruit_juice_and_vegetable_manufacturing", industry_type: :industry, naics_code: "311411").first_or_create
    IndustryCode.where(name: "Frozen Specialty Food Manufacturing", internal_name: "frozen_specialty_food_manufacturing", industry_type: :industry, naics_code: "311412").first_or_create
    IndustryCode.where(name: "Fruit and Vegetable Canning", internal_name: "fruit_and_vegetable_canning", industry_type: :industry, naics_code: "311421").first_or_create
    IndustryCode.where(name: "Specialty Canning", internal_name: "specialty_canning", industry_type: :industry, naics_code: "311422").first_or_create
    IndustryCode.where(name: "Dried and Dehydrated Food Manufacturing", internal_name: "dried_and_dehydrated_food_manufacturing", industry_type: :industry, naics_code: "311423").first_or_create
    IndustryCode.where(name: "Fluid Milk Manufacturing", internal_name: "fluid_milk_manufacturing", industry_type: :industry, naics_code: "311511").first_or_create
    IndustryCode.where(name: "Creamery Butter Manufacturing", internal_name: "creamery_butter_manufacturing", industry_type: :industry, naics_code: "311512").first_or_create
    IndustryCode.where(name: "Cheese Manufacturing", internal_name: "cheese_manufacturing", industry_type: :industry, naics_code: "311513").first_or_create
    IndustryCode.where(name: "Dry, Condensed, and Evaporated Dairy Product Manufacturing", internal_name: "dry_condensed_and_evaporated_dairy_product_manufacturing", industry_type: :industry, naics_code: "311514").first_or_create
    IndustryCode.where(name: "Ice Cream and Frozen Dessert Manufacturing", internal_name: "ice_cream_and_frozen_dessert_manufacturing", industry_type: :industry, naics_code: "311520").first_or_create
    IndustryCode.where(name: "Animal (except Poultry) Slaughtering", internal_name: "animal_except_poultry_slaughtering", industry_type: :industry, naics_code: "311611").first_or_create
    IndustryCode.where(name: "Meat Processed from Carcasses", internal_name: "meat_processed_from_carcasses", industry_type: :industry, naics_code: "311612").first_or_create
    IndustryCode.where(name: "Rendering and Meat Byproduct Processing", internal_name: "rendering_and_meat_byproduct_processing", industry_type: :industry, naics_code: "311613").first_or_create
    IndustryCode.where(name: "Poultry Processing", internal_name: "poultry_processing", industry_type: :industry, naics_code: "311615").first_or_create
    IndustryCode.where(name: "Seafood Product Preparation and Packaging", internal_name: "seafood_product_preparation_and_packaging", industry_type: :industry, naics_code: "311710").first_or_create
    IndustryCode.where(name: "Retail Bakeries", internal_name: "retail_bakeries", industry_type: :industry, naics_code: "311811").first_or_create
    IndustryCode.where(name: "Commercial Bakeries", internal_name: "commercial_bakeries", industry_type: :industry, naics_code: "311812").first_or_create
    IndustryCode.where(name: "Frozen Cakes, Pies, and Other Pastries Manufacturing", internal_name: "frozen_cakes_pies_and_other_pastries_manufacturing", industry_type: :industry, naics_code: "311813").first_or_create
    IndustryCode.where(name: "Cookie and Cracker Manufacturing", internal_name: "cookie_and_cracker_manufacturing", industry_type: :industry, naics_code: "311821").first_or_create
    IndustryCode.where(name: "Dry Pasta, Dough, and Flour Mixes Manufacturing from Purchased Flour", internal_name: "dry_pasta_dough_and_flour_mixes_manufacturing_from_purchased_flour", industry_type: :industry, naics_code: "311824").first_or_create
    IndustryCode.where(name: "Tortilla Manufacturing", internal_name: "tortilla_manufacturing", industry_type: :industry, naics_code: "311830").first_or_create
    IndustryCode.where(name: "Roasted Nuts and Peanut Butter Manufacturing", internal_name: "roasted_nuts_and_peanut_butter_manufacturing", industry_type: :industry, naics_code: "311911").first_or_create
    IndustryCode.where(name: "Other Snack Food Manufacturing", internal_name: "other_snack_food_manufacturing", industry_type: :industry, naics_code: "311919").first_or_create
    IndustryCode.where(name: "Coffee and Tea Manufacturing", internal_name: "coffee_and_tea_manufacturing", industry_type: :industry, naics_code: "311920").first_or_create
    IndustryCode.where(name: "Flavoring Syrup and Concentrate Manufacturing", internal_name: "flavoring_syrup_and_concentrate_manufacturing", industry_type: :industry, naics_code: "311930").first_or_create
    IndustryCode.where(name: "Mayonnaise, Dressing, and Other Prepared Sauce Manufacturing", internal_name: "mayonnaise_dressing_and_other_prepared_sauce_manufacturing", industry_type: :industry, naics_code: "311941").first_or_create
    IndustryCode.where(name: "Spice and Extract Manufacturing", internal_name: "spice_and_extract_manufacturing", industry_type: :industry, naics_code: "311942").first_or_create
    IndustryCode.where(name: "Perishable Prepared Food Manufacturing", internal_name: "perishable_prepared_food_manufacturing", industry_type: :industry, naics_code: "311991").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Food Manufacturing", internal_name: "all_other_miscellaneous_food_manufacturing", industry_type: :industry, naics_code: "311999").first_or_create
    IndustryCode.where(name: "Soft Drink Manufacturing", internal_name: "soft_drink_manufacturing", industry_type: :industry, naics_code: "312111").first_or_create
    IndustryCode.where(name: "Bottled Water Manufacturing", internal_name: "bottled_water_manufacturing", industry_type: :industry, naics_code: "312112").first_or_create
    IndustryCode.where(name: "Ice Manufacturing", internal_name: "ice_manufacturing", industry_type: :industry, naics_code: "312113").first_or_create
    IndustryCode.where(name: "Breweries", internal_name: "breweries", industry_type: :industry, naics_code: "312120").first_or_create
    IndustryCode.where(name: "Wineries", internal_name: "wineries", industry_type: :industry, naics_code: "312130").first_or_create
    IndustryCode.where(name: "Distilleries", internal_name: "distilleries", industry_type: :industry, naics_code: "312140").first_or_create
    IndustryCode.where(name: "Tobacco Manufacturing", internal_name: "tobacco_manufacturing", industry_type: :industry, naics_code: "312230").first_or_create
    IndustryCode.where(name: "Fiber, Yarn, and Thread Mills", internal_name: "fiber_yarn_and_thread_mills", industry_type: :industry, naics_code: "313110").first_or_create
    IndustryCode.where(name: "Broadwoven Fabric Mills", internal_name: "broadwoven_fabric_mills", industry_type: :industry, naics_code: "313210").first_or_create
    IndustryCode.where(name: "Narrow Fabric Mills and Schiffli Machine Embroidery", internal_name: "narrow_fabric_mills_and_schiffli_machine_embroidery", industry_type: :industry, naics_code: "313220").first_or_create
    IndustryCode.where(name: "Nonwoven Fabric Mills", internal_name: "nonwoven_fabric_mills", industry_type: :industry, naics_code: "313230").first_or_create
    IndustryCode.where(name: "Knit Fabric Mills", internal_name: "knit_fabric_mills", industry_type: :industry, naics_code: "313240").first_or_create
    IndustryCode.where(name: "Textile and Fabric Finishing Mills", internal_name: "textile_and_fabric_finishing_mills", industry_type: :industry, naics_code: "313310").first_or_create
    IndustryCode.where(name: "Fabric Coating Mills", internal_name: "fabric_coating_mills", industry_type: :industry, naics_code: "313320").first_or_create
    IndustryCode.where(name: "Carpet and Rug Mills", internal_name: "carpet_and_rug_mills", industry_type: :industry, naics_code: "314110").first_or_create
    IndustryCode.where(name: "Curtain and Linen Mills", internal_name: "curtain_and_linen_mills", industry_type: :industry, naics_code: "314120").first_or_create
    IndustryCode.where(name: "Textile Bag and Canvas Mills", internal_name: "textile_bag_and_canvas_mills", industry_type: :industry, naics_code: "314910").first_or_create
    IndustryCode.where(name: "Rope, Cordage, Twine, Tire Cord, and Tire Fabric Mills", internal_name: "rope_cordage_twine_tire_cord_and_tire_fabric_mills", industry_type: :industry, naics_code: "314994").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Textile Product Mills", internal_name: "all_other_miscellaneous_textile_product_mills", industry_type: :industry, naics_code: "314999").first_or_create
    IndustryCode.where(name: "Hosiery and Sock Mills", internal_name: "hosiery_and_sock_mills", industry_type: :industry, naics_code: "315110").first_or_create
    IndustryCode.where(name: "Other Apparel Knitting Mills", internal_name: "other_apparel_knitting_mills", industry_type: :industry, naics_code: "315190").first_or_create
    IndustryCode.where(name: "Cut and Sew Apparel Contractors", internal_name: "cut_and_sew_apparel_contractors", industry_type: :industry, naics_code: "315210").first_or_create
    IndustryCode.where(name: "Men’s and Boys’ Cut and Sew Apparel Manufacturing", internal_name: "men’s_and_boys’_cut_and_sew_apparel_manufacturing", industry_type: :industry, naics_code: "315220").first_or_create
    IndustryCode.where(name: "Women’s, Girls’, and Infants’ Cut and Sew Apparel Manufacturing", internal_name: "women’s_girls’_and_infants’_cut_and_sew_apparel_manufacturing", industry_type: :industry, naics_code: "315240").first_or_create
    IndustryCode.where(name: "Other Cut and Sew Apparel Manufacturing", internal_name: "other_cut_and_sew_apparel_manufacturing", industry_type: :industry, naics_code: "315280").first_or_create
    IndustryCode.where(name: "Apparel Accessories and Other Apparel Manufacturing", internal_name: "apparel_accessories_and_other_apparel_manufacturing", industry_type: :industry, naics_code: "315990").first_or_create
    IndustryCode.where(name: "Leather and Hide Tanning and Finishing", internal_name: "leather_and_hide_tanning_and_finishing", industry_type: :industry, naics_code: "316110").first_or_create
    IndustryCode.where(name: "Footwear Manufacturing", internal_name: "footwear_manufacturing", industry_type: :industry, naics_code: "316210").first_or_create
    IndustryCode.where(name: "Women's Handbag and Purse Manufacturing", internal_name: "women's_handbag_and_purse_manufacturing", industry_type: :industry, naics_code: "316992").first_or_create
    IndustryCode.where(name: "All Other Leather Good and Allied Product Manufacturing", internal_name: "all_other_leather_good_and_allied_product_manufacturing", industry_type: :industry, naics_code: "316998").first_or_create
    IndustryCode.where(name: "Sawmills", internal_name: "sawmills", industry_type: :industry, naics_code: "321113").first_or_create
    IndustryCode.where(name: "Wood Preservation", internal_name: "wood_preservation", industry_type: :industry, naics_code: "321114").first_or_create
    IndustryCode.where(name: "Hardwood Veneer and Plywood Manufacturing", internal_name: "hardwood_veneer_and_plywood_manufacturing", industry_type: :industry, naics_code: "321211").first_or_create
    IndustryCode.where(name: "Softwood Veneer and Plywood Manufacturing", internal_name: "softwood_veneer_and_plywood_manufacturing", industry_type: :industry, naics_code: "321212").first_or_create
    IndustryCode.where(name: "Engineered Wood Member (except Truss) Manufacturing", internal_name: "engineered_wood_member_except_truss_manufacturing", industry_type: :industry, naics_code: "321213").first_or_create
    IndustryCode.where(name: "Truss Manufacturing", internal_name: "truss_manufacturing", industry_type: :industry, naics_code: "321214").first_or_create
    IndustryCode.where(name: "Reconstituted Wood Product Manufacturing", internal_name: "reconstituted_wood_product_manufacturing", industry_type: :industry, naics_code: "321219").first_or_create
    IndustryCode.where(name: "Wood Window and Door Manufacturing", internal_name: "wood_window_and_door_manufacturing", industry_type: :industry, naics_code: "321911").first_or_create
    IndustryCode.where(name: "Cut Stock, Resawing Lumber, and Planing", internal_name: "cut_stock_resawing_lumber_and_planing", industry_type: :industry, naics_code: "321912").first_or_create
    IndustryCode.where(name: "Other Millwork (including Flooring)", internal_name: "other_millwork_including_flooring", industry_type: :industry, naics_code: "321918").first_or_create
    IndustryCode.where(name: "Wood Container and Pallet Manufacturing", internal_name: "wood_container_and_pallet_manufacturing", industry_type: :industry, naics_code: "321920").first_or_create
    IndustryCode.where(name: "Manufactured Home (Mobile Home) Manufacturing", internal_name: "manufactured_home_mobile_home_manufacturing", industry_type: :industry, naics_code: "321991").first_or_create
    IndustryCode.where(name: "Prefabricated Wood Building Manufacturing", internal_name: "prefabricated_wood_building_manufacturing", industry_type: :industry, naics_code: "321992").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Wood Product Manufacturing", internal_name: "all_other_miscellaneous_wood_product_manufacturing", industry_type: :industry, naics_code: "321999").first_or_create
    IndustryCode.where(name: "Pulp Mills", internal_name: "pulp_mills", industry_type: :industry, naics_code: "322110").first_or_create
    IndustryCode.where(name: "Paper (except Newsprint) Mills", internal_name: "paper_except_newsprint_mills", industry_type: :industry, naics_code: "322121").first_or_create
    IndustryCode.where(name: "Newsprint Mills", internal_name: "newsprint_mills", industry_type: :industry, naics_code: "322122").first_or_create
    IndustryCode.where(name: "Paperboard Mills", internal_name: "paperboard_mills", industry_type: :industry, naics_code: "322130").first_or_create
    IndustryCode.where(name: "Corrugated and Solid Fiber Box Manufacturing", internal_name: "corrugated_and_solid_fiber_box_manufacturing", industry_type: :industry, naics_code: "322211").first_or_create
    IndustryCode.where(name: "Folding Paperboard Box Manufacturing", internal_name: "folding_paperboard_box_manufacturing", industry_type: :industry, naics_code: "322212").first_or_create
    IndustryCode.where(name: "Other Paperboard Container Manufacturing", internal_name: "other_paperboard_container_manufacturing", industry_type: :industry, naics_code: "322219").first_or_create
    IndustryCode.where(name: "Paper Bag and Coated and Treated Paper Manufacturing", internal_name: "paper_bag_and_coated_and_treated_paper_manufacturing", industry_type: :industry, naics_code: "322220").first_or_create
    IndustryCode.where(name: "Stationery Product Manufacturing", internal_name: "stationery_product_manufacturing", industry_type: :industry, naics_code: "322230").first_or_create
    IndustryCode.where(name: "Sanitary Paper Product Manufacturing", internal_name: "sanitary_paper_product_manufacturing", industry_type: :industry, naics_code: "322291").first_or_create
    IndustryCode.where(name: "All Other Converted Paper Product Manufacturing", internal_name: "all_other_converted_paper_product_manufacturing", industry_type: :industry, naics_code: "322299").first_or_create
    IndustryCode.where(name: "Commercial Printing (except Screen and Books)", internal_name: "commercial_printing_except_screen_and_books", industry_type: :industry, naics_code: "323111").first_or_create
    IndustryCode.where(name: "Commercial Screen Printing", internal_name: "commercial_screen_printing", industry_type: :industry, naics_code: "323113").first_or_create
    IndustryCode.where(name: "Books Printing", internal_name: "books_printing", industry_type: :industry, naics_code: "323117").first_or_create
    IndustryCode.where(name: "Support Activities for Printing", internal_name: "support_activities_for_printing", industry_type: :industry, naics_code: "323120").first_or_create
    IndustryCode.where(name: "Petroleum Refineries", internal_name: "petroleum_refineries", industry_type: :industry, naics_code: "324110").first_or_create
    IndustryCode.where(name: "Asphalt Paving Mixture and Block Manufacturing", internal_name: "asphalt_paving_mixture_and_block_manufacturing", industry_type: :industry, naics_code: "324121").first_or_create
    IndustryCode.where(name: "Asphalt Shingle and Coating Materials Manufacturing", internal_name: "asphalt_shingle_and_coating_materials_manufacturing", industry_type: :industry, naics_code: "324122").first_or_create
    IndustryCode.where(name: "Petroleum Lubricating Oil and Grease Manufacturing", internal_name: "petroleum_lubricating_oil_and_grease_manufacturing", industry_type: :industry, naics_code: "324191").first_or_create
    IndustryCode.where(name: "All Other Petroleum and Coal Products Manufacturing", internal_name: "all_other_petroleum_and_coal_products_manufacturing", industry_type: :industry, naics_code: "324199").first_or_create
    IndustryCode.where(name: "Petrochemical Manufacturing", internal_name: "petrochemical_manufacturing", industry_type: :industry, naics_code: "325110").first_or_create
    IndustryCode.where(name: "Industrial Gas Manufacturing", internal_name: "industrial_gas_manufacturing", industry_type: :industry, naics_code: "325120").first_or_create
    IndustryCode.where(name: "Synthetic Dye and Pigment Manufacturing", internal_name: "synthetic_dye_and_pigment_manufacturing", industry_type: :industry, naics_code: "325130").first_or_create
    IndustryCode.where(name: "Other Basic Inorganic Chemical Manufacturing", internal_name: "other_basic_inorganic_chemical_manufacturing", industry_type: :industry, naics_code: "325180").first_or_create
    IndustryCode.where(name: "Ethyl Alcohol Manufacturing", internal_name: "ethyl_alcohol_manufacturing", industry_type: :industry, naics_code: "325193").first_or_create
    IndustryCode.where(name: "Cyclic Crude, Intermediate, and Gum and Wood Chemical Manufacturing", internal_name: "cyclic_crude_intermediate_and_gum_and_wood_chemical_manufacturing", industry_type: :industry, naics_code: "325194").first_or_create
    IndustryCode.where(name: "All Other Basic Organic Chemical Manufacturing", internal_name: "all_other_basic_organic_chemical_manufacturing", industry_type: :industry, naics_code: "325199").first_or_create
    IndustryCode.where(name: "Plastics Material and Resin Manufacturing", internal_name: "plastics_material_and_resin_manufacturing", industry_type: :industry, naics_code: "325211").first_or_create
    IndustryCode.where(name: "Synthetic Rubber Manufacturing", internal_name: "synthetic_rubber_manufacturing", industry_type: :industry, naics_code: "325212").first_or_create
    IndustryCode.where(name: "Artificial and Synthetic Fibers and Filaments Manufacturing", internal_name: "artificial_and_synthetic_fibers_and_filaments_manufacturing", industry_type: :industry, naics_code: "325220").first_or_create
    IndustryCode.where(name: "Nitrogenous Fertilizer Manufacturing", internal_name: "nitrogenous_fertilizer_manufacturing", industry_type: :industry, naics_code: "325311").first_or_create
    IndustryCode.where(name: "Phosphatic Fertilizer Manufacturing", internal_name: "phosphatic_fertilizer_manufacturing", industry_type: :industry, naics_code: "325312").first_or_create
    IndustryCode.where(name: "Fertilizer (Mixing Only) Manufacturing", internal_name: "fertilizer_mixing_only_manufacturing", industry_type: :industry, naics_code: "325314").first_or_create
    IndustryCode.where(name: "Pesticide and Other Agricultural Chemical Manufacturing", internal_name: "pesticide_and_other_agricultural_chemical_manufacturing", industry_type: :industry, naics_code: "325320").first_or_create
    IndustryCode.where(name: "Medicinal and Botanical Manufacturing", internal_name: "medicinal_and_botanical_manufacturing", industry_type: :industry, naics_code: "325411").first_or_create
    IndustryCode.where(name: "Pharmaceutical Preparation Manufacturing", internal_name: "pharmaceutical_preparation_manufacturing", industry_type: :industry, naics_code: "325412").first_or_create
    IndustryCode.where(name: "In_Vitro Diagnostic Substance Manufacturing", internal_name: "in_vitro_diagnostic_substance_manufacturing", industry_type: :industry, naics_code: "325413").first_or_create
    IndustryCode.where(name: "Biological Product (except Diagnostic) Manufacturing", internal_name: "biological_product_except_diagnostic_manufacturing", industry_type: :industry, naics_code: "325414").first_or_create
    IndustryCode.where(name: "Paint and Coating Manufacturing", internal_name: "paint_and_coating_manufacturing", industry_type: :industry, naics_code: "325510").first_or_create
    IndustryCode.where(name: "Adhesive Manufacturing", internal_name: "adhesive_manufacturing", industry_type: :industry, naics_code: "325520").first_or_create
    IndustryCode.where(name: "Soap and Other Detergent Manufacturing", internal_name: "soap_and_other_detergent_manufacturing", industry_type: :industry, naics_code: "325611").first_or_create
    IndustryCode.where(name: "Polish and Other Sanitation Good Manufacturing", internal_name: "polish_and_other_sanitation_good_manufacturing", industry_type: :industry, naics_code: "325612").first_or_create
    IndustryCode.where(name: "Surface Active Agent Manufacturing", internal_name: "surface_active_agent_manufacturing", industry_type: :industry, naics_code: "325613").first_or_create
    IndustryCode.where(name: "Toilet Preparation Manufacturing", internal_name: "toilet_preparation_manufacturing", industry_type: :industry, naics_code: "325620").first_or_create
    IndustryCode.where(name: "Printing Ink Manufacturing", internal_name: "printing_ink_manufacturing", industry_type: :industry, naics_code: "325910").first_or_create
    IndustryCode.where(name: "Explosives Manufacturing", internal_name: "explosives_manufacturing", industry_type: :industry, naics_code: "325920").first_or_create
    IndustryCode.where(name: "Custom Compounding of Purchased Resins", internal_name: "custom_compounding_of_purchased_resins", industry_type: :industry, naics_code: "325991").first_or_create
    IndustryCode.where(name: "Photographic Film, Paper, Plate, and Chemical Manufacturing", internal_name: "photographic_film_paper_plate_and_chemical_manufacturing", industry_type: :industry, naics_code: "325992").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Chemical Product and Preparation Manufacturing", internal_name: "all_other_miscellaneous_chemical_product_and_preparation_manufacturing", industry_type: :industry, naics_code: "325998").first_or_create
    IndustryCode.where(name: "Plastics Bag and Pouch Manufacturing", internal_name: "plastics_bag_and_pouch_manufacturing", industry_type: :industry, naics_code: "326111").first_or_create
    IndustryCode.where(name: "Plastics Packaging Film and Sheet (including Laminated) Manufacturing", internal_name: "plastics_packaging_film_and_sheet_including_laminated_manufacturing", industry_type: :industry, naics_code: "326112").first_or_create
    IndustryCode.where(name: "Unlaminated Plastics Film and Sheet (except Packaging) Manufacturing", internal_name: "unlaminated_plastics_film_and_sheet_except_packaging_manufacturing", industry_type: :industry, naics_code: "326113").first_or_create
    IndustryCode.where(name: "Unlaminated Plastics Profile Shape Manufacturing", internal_name: "unlaminated_plastics_profile_shape_manufacturing", industry_type: :industry, naics_code: "326121").first_or_create
    IndustryCode.where(name: "Plastics Pipe and Pipe Fitting Manufacturing", internal_name: "plastics_pipe_and_pipe_fitting_manufacturing", industry_type: :industry, naics_code: "326122").first_or_create
    IndustryCode.where(name: "Laminated Plastics Plate, Sheet (except Packaging), and Shape Manufacturing", internal_name: "laminated_plastics_plate_sheet_except_packaging_and_shape_manufacturing", industry_type: :industry, naics_code: "326130").first_or_create
    IndustryCode.where(name: "Polystyrene Foam Product Manufacturing", internal_name: "polystyrene_foam_product_manufacturing", industry_type: :industry, naics_code: "326140").first_or_create
    IndustryCode.where(name: "Urethane and Other Foam Product (except Polystyrene) Manufacturing", internal_name: "urethane_and_other_foam_product_except_polystyrene_manufacturing", industry_type: :industry, naics_code: "326150").first_or_create
    IndustryCode.where(name: "Plastics Bottle Manufacturing", internal_name: "plastics_bottle_manufacturing", industry_type: :industry, naics_code: "326160").first_or_create
    IndustryCode.where(name: "Plastics Plumbing Fixture Manufacturing", internal_name: "plastics_plumbing_fixture_manufacturing", industry_type: :industry, naics_code: "326191").first_or_create
    IndustryCode.where(name: "All Other Plastics Product Manufacturing", internal_name: "all_other_plastics_product_manufacturing", industry_type: :industry, naics_code: "326199").first_or_create
    IndustryCode.where(name: "Tire Manufacturing (except Retreading)", internal_name: "tire_manufacturing_except_retreading", industry_type: :industry, naics_code: "326211").first_or_create
    IndustryCode.where(name: "Tire Retreading", internal_name: "tire_retreading", industry_type: :industry, naics_code: "326212").first_or_create
    IndustryCode.where(name: "Rubber and Plastics Hoses and Belting Manufacturing", internal_name: "rubber_and_plastics_hoses_and_belting_manufacturing", industry_type: :industry, naics_code: "326220").first_or_create
    IndustryCode.where(name: "Rubber Product Manufacturing for Mechanical Use", internal_name: "rubber_product_manufacturing_for_mechanical_use", industry_type: :industry, naics_code: "326291").first_or_create
    IndustryCode.where(name: "All Other Rubber Product Manufacturing", internal_name: "all_other_rubber_product_manufacturing", industry_type: :industry, naics_code: "326299").first_or_create
    IndustryCode.where(name: "Pottery, Ceramics, and Plumbing Fixture Manufacturing", internal_name: "pottery_ceramics_and_plumbing_fixture_manufacturing", industry_type: :industry, naics_code: "327110").first_or_create
    IndustryCode.where(name: "Clay Building Material and Refractories Manufacturing", internal_name: "clay_building_material_and_refractories_manufacturing", industry_type: :industry, naics_code: "327120").first_or_create
    IndustryCode.where(name: "Flat Glass Manufacturing", internal_name: "flat_glass_manufacturing", industry_type: :industry, naics_code: "327211").first_or_create
    IndustryCode.where(name: "Other Pressed and Blown Glass and Glassware Manufacturing", internal_name: "other_pressed_and_blown_glass_and_glassware_manufacturing", industry_type: :industry, naics_code: "327212").first_or_create
    IndustryCode.where(name: "Glass Container Manufacturing", internal_name: "glass_container_manufacturing", industry_type: :industry, naics_code: "327213").first_or_create
    IndustryCode.where(name: "Glass Product Manufacturing Made of Purchased Glass", internal_name: "glass_product_manufacturing_made_of_purchased_glass", industry_type: :industry, naics_code: "327215").first_or_create
    IndustryCode.where(name: "Cement Manufacturing", internal_name: "cement_manufacturing", industry_type: :industry, naics_code: "327310").first_or_create
    IndustryCode.where(name: "Ready_Mix Concrete Manufacturing", internal_name: "ready_mix_concrete_manufacturing", industry_type: :industry, naics_code: "327320").first_or_create
    IndustryCode.where(name: "Concrete Block and Brick Manufacturing", internal_name: "concrete_block_and_brick_manufacturing", industry_type: :industry, naics_code: "327331").first_or_create
    IndustryCode.where(name: "Concrete Pipe Manufacturing", internal_name: "concrete_pipe_manufacturing", industry_type: :industry, naics_code: "327332").first_or_create
    IndustryCode.where(name: "Other Concrete Product Manufacturing", internal_name: "other_concrete_product_manufacturing", industry_type: :industry, naics_code: "327390").first_or_create
    IndustryCode.where(name: "Lime Manufacturing", internal_name: "lime_manufacturing", industry_type: :industry, naics_code: "327410").first_or_create
    IndustryCode.where(name: "Gypsum Product Manufacturing", internal_name: "gypsum_product_manufacturing", industry_type: :industry, naics_code: "327420").first_or_create
    IndustryCode.where(name: "Abrasive Product Manufacturing", internal_name: "abrasive_product_manufacturing", industry_type: :industry, naics_code: "327910").first_or_create
    IndustryCode.where(name: "Cut Stone and Stone Product Manufacturing", internal_name: "cut_stone_and_stone_product_manufacturing", industry_type: :industry, naics_code: "327991").first_or_create
    IndustryCode.where(name: "Ground or Treated Mineral and Earth Manufacturing", internal_name: "ground_or_treated_mineral_and_earth_manufacturing", industry_type: :industry, naics_code: "327992").first_or_create
    IndustryCode.where(name: "Mineral Wool Manufacturing", internal_name: "mineral_wool_manufacturing", industry_type: :industry, naics_code: "327993").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Nonmetallic Mineral Product Manufacturing", internal_name: "all_other_miscellaneous_nonmetallic_mineral_product_manufacturing", industry_type: :industry, naics_code: "327999").first_or_create
    IndustryCode.where(name: "Iron and Steel Mills and Ferroalloy Manufacturing", internal_name: "iron_and_steel_mills_and_ferroalloy_manufacturing", industry_type: :industry, naics_code: "331110").first_or_create
    IndustryCode.where(name: "Iron and Steel Pipe and Tube Manufacturing from Purchased Steel", internal_name: "iron_and_steel_pipe_and_tube_manufacturing_from_purchased_steel", industry_type: :industry, naics_code: "331210").first_or_create
    IndustryCode.where(name: "Rolled Steel Shape Manufacturing", internal_name: "rolled_steel_shape_manufacturing", industry_type: :industry, naics_code: "331221").first_or_create
    IndustryCode.where(name: "Steel Wire Drawing", internal_name: "steel_wire_drawing", industry_type: :industry, naics_code: "331222").first_or_create
    IndustryCode.where(name: "Alumina Refining and Primary Aluminum Production", internal_name: "alumina_refining_and_primary_aluminum_production", industry_type: :industry, naics_code: "331313").first_or_create
    IndustryCode.where(name: "Secondary Smelting and Alloying of Aluminum", internal_name: "secondary_smelting_and_alloying_of_aluminum", industry_type: :industry, naics_code: "331314").first_or_create
    IndustryCode.where(name: "Aluminum Sheet, Plate, and Foil Manufacturing", internal_name: "aluminum_sheet_plate_and_foil_manufacturing", industry_type: :industry, naics_code: "331315").first_or_create
    IndustryCode.where(name: "Other Aluminum Rolling, Drawing, and Extruding", internal_name: "other_aluminum_rolling_drawing_and_extruding", industry_type: :industry, naics_code: "331318").first_or_create
    IndustryCode.where(name: "Nonferrous Metal (except Aluminum) Smelting and Refining", internal_name: "nonferrous_metal_except_aluminum_smelting_and_refining", industry_type: :industry, naics_code: "331410").first_or_create
    IndustryCode.where(name: "Copper Rolling, Drawing, Extruding, and Alloying", internal_name: "copper_rolling_drawing_extruding_and_alloying", industry_type: :industry, naics_code: "331420").first_or_create
    IndustryCode.where(name: "Nonferrous Metal (except Copper and Aluminum) Rolling, Drawing, and Extruding", internal_name: "nonferrous_metal_except_copper_and_aluminum_rolling_drawing_and_extruding", industry_type: :industry, naics_code: "331491").first_or_create
    IndustryCode.where(name: "Secondary Smelting, Refining, and Alloying of Nonferrous Metal (except Copper and Aluminum)", internal_name: "secondary_smelting_refining_and_alloying_of_nonferrous_metal_except_copper_and_aluminum", industry_type: :industry, naics_code: "331492").first_or_create
    IndustryCode.where(name: "Iron Foundries", internal_name: "iron_foundries", industry_type: :industry, naics_code: "331511").first_or_create
    IndustryCode.where(name: "Steel Investment Foundries", internal_name: "steel_investment_foundries", industry_type: :industry, naics_code: "331512").first_or_create
    IndustryCode.where(name: "Steel Foundries (except Investment)", internal_name: "steel_foundries_except_investment", industry_type: :industry, naics_code: "331513").first_or_create
    IndustryCode.where(name: "Nonferrous Metal Die_Casting Foundries", internal_name: "nonferrous_metal_die_casting_foundries", industry_type: :industry, naics_code: "331523").first_or_create
    IndustryCode.where(name: "Aluminum Foundries (except Die_Casting)", internal_name: "aluminum_foundries_except_die_casting", industry_type: :industry, naics_code: "331524").first_or_create
    IndustryCode.where(name: "Other Nonferrous Metal Foundries (except Die_Casting)", internal_name: "other_nonferrous_metal_foundries_except_die_casting", industry_type: :industry, naics_code: "331529").first_or_create
    IndustryCode.where(name: "Iron and Steel Forging", internal_name: "iron_and_steel_forging", industry_type: :industry, naics_code: "332111").first_or_create
    IndustryCode.where(name: "Nonferrous Forging", internal_name: "nonferrous_forging", industry_type: :industry, naics_code: "332112").first_or_create
    IndustryCode.where(name: "Custom Roll Forming", internal_name: "custom_roll_forming", industry_type: :industry, naics_code: "332114").first_or_create
    IndustryCode.where(name: "Powder Metallurgy Part Manufacturing", internal_name: "powder_metallurgy_part_manufacturing", industry_type: :industry, naics_code: "332117").first_or_create
    IndustryCode.where(name: "Metal Crown, Closure, and Other Metal Stamping (except Automotive)", internal_name: "metal_crown_closure_and_other_metal_stamping_except_automotive", industry_type: :industry, naics_code: "332119").first_or_create
    IndustryCode.where(name: "Metal Kitchen Cookware, Utensil, Cutlery, and Flatware (except Precious) Manufacturing", internal_name: "metal_kitchen_cookware_utensil_cutlery_and_flatware_except_precious_manufacturing", industry_type: :industry, naics_code: "332215").first_or_create
    IndustryCode.where(name: "Saw Blade and Handtool Manufacturing", internal_name: "saw_blade_and_handtool_manufacturing", industry_type: :industry, naics_code: "332216").first_or_create
    IndustryCode.where(name: "Prefabricated Metal Building and Component Manufacturing", internal_name: "prefabricated_metal_building_and_component_manufacturing", industry_type: :industry, naics_code: "332311").first_or_create
    IndustryCode.where(name: "Fabricated Structural Metal Manufacturing", internal_name: "fabricated_structural_metal_manufacturing", industry_type: :industry, naics_code: "332312").first_or_create
    IndustryCode.where(name: "Plate Work Manufacturing", internal_name: "plate_work_manufacturing", industry_type: :industry, naics_code: "332313").first_or_create
    IndustryCode.where(name: "Metal Window and Door Manufacturing", internal_name: "metal_window_and_door_manufacturing", industry_type: :industry, naics_code: "332321").first_or_create
    IndustryCode.where(name: "Sheet Metal Work Manufacturing", internal_name: "sheet_metal_work_manufacturing", industry_type: :industry, naics_code: "332322").first_or_create
    IndustryCode.where(name: "Ornamental and Architectural Metal Work Manufacturing", internal_name: "ornamental_and_architectural_metal_work_manufacturing", industry_type: :industry, naics_code: "332323").first_or_create
    IndustryCode.where(name: "Power Boiler and Heat Exchanger Manufacturing", internal_name: "power_boiler_and_heat_exchanger_manufacturing", industry_type: :industry, naics_code: "332410").first_or_create
    IndustryCode.where(name: "Metal Tank (Heavy Gauge) Manufacturing", internal_name: "metal_tank_heavy_gauge_manufacturing", industry_type: :industry, naics_code: "332420").first_or_create
    IndustryCode.where(name: "Metal Can Manufacturing", internal_name: "metal_can_manufacturing", industry_type: :industry, naics_code: "332431").first_or_create
    IndustryCode.where(name: "Other Metal Container Manufacturing", internal_name: "other_metal_container_manufacturing", industry_type: :industry, naics_code: "332439").first_or_create
    IndustryCode.where(name: "Hardware Manufacturing", internal_name: "hardware_manufacturing", industry_type: :industry, naics_code: "332510").first_or_create
    IndustryCode.where(name: "Spring Manufacturing", internal_name: "spring_manufacturing", industry_type: :industry, naics_code: "332613").first_or_create
    IndustryCode.where(name: "Other Fabricated Wire Product Manufacturing", internal_name: "other_fabricated_wire_product_manufacturing", industry_type: :industry, naics_code: "332618").first_or_create
    IndustryCode.where(name: "Machine Shops", internal_name: "machine_shops", industry_type: :industry, naics_code: "332710").first_or_create
    IndustryCode.where(name: "Precision Turned Product Manufacturing", internal_name: "precision_turned_product_manufacturing", industry_type: :industry, naics_code: "332721").first_or_create
    IndustryCode.where(name: "Bolt, Nut, Screw, Rivet, and Washer Manufacturing", internal_name: "bolt_nut_screw_rivet_and_washer_manufacturing", industry_type: :industry, naics_code: "332722").first_or_create
    IndustryCode.where(name: "Metal Heat Treating", internal_name: "metal_heat_treating", industry_type: :industry, naics_code: "332811").first_or_create
    IndustryCode.where(name: "Metal Coating, Engraving (except Jewelry and Silverware), and Allied Services to Manufacturers", internal_name: "metal_coating_engraving_except_jewelry_and_silverware_and_allied_services_to_manufacturers", industry_type: :industry, naics_code: "332812").first_or_create
    IndustryCode.where(name: "Electroplating, Plating, Polishing, Anodizing, and Coloring", internal_name: "electroplating_plating_polishing_anodizing_and_coloring", industry_type: :industry, naics_code: "332813").first_or_create
    IndustryCode.where(name: "Industrial Valve Manufacturing", internal_name: "industrial_valve_manufacturing", industry_type: :industry, naics_code: "332911").first_or_create
    IndustryCode.where(name: "Fluid Power Valve and Hose Fitting Manufacturing", internal_name: "fluid_power_valve_and_hose_fitting_manufacturing", industry_type: :industry, naics_code: "332912").first_or_create
    IndustryCode.where(name: "Plumbing Fixture Fitting and Trim Manufacturing", internal_name: "plumbing_fixture_fitting_and_trim_manufacturing", industry_type: :industry, naics_code: "332913").first_or_create
    IndustryCode.where(name: "Other Metal Valve and Pipe Fitting Manufacturing", internal_name: "other_metal_valve_and_pipe_fitting_manufacturing", industry_type: :industry, naics_code: "332919").first_or_create
    IndustryCode.where(name: "Ball and Roller Bearing Manufacturing", internal_name: "ball_and_roller_bearing_manufacturing", industry_type: :industry, naics_code: "332991").first_or_create
    IndustryCode.where(name: "Small Arms Ammunition Manufacturing", internal_name: "small_arms_ammunition_manufacturing", industry_type: :industry, naics_code: "332992").first_or_create
    IndustryCode.where(name: "Ammunition (except Small Arms) Manufacturing", internal_name: "ammunition_except_small_arms_manufacturing", industry_type: :industry, naics_code: "332993").first_or_create
    IndustryCode.where(name: "Small Arms, Ordnance, and Ordnance Accessories Manufacturing", internal_name: "small_arms_ordnance_and_ordnance_accessories_manufacturing", industry_type: :industry, naics_code: "332994").first_or_create
    IndustryCode.where(name: "Fabricated Pipe and Pipe Fitting Manufacturing", internal_name: "fabricated_pipe_and_pipe_fitting_manufacturing", industry_type: :industry, naics_code: "332996").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Fabricated Metal Product Manufacturing", internal_name: "all_other_miscellaneous_fabricated_metal_product_manufacturing", industry_type: :industry, naics_code: "332999").first_or_create
    IndustryCode.where(name: "Farm Machinery and Equipment Manufacturing", internal_name: "farm_machinery_and_equipment_manufacturing", industry_type: :industry, naics_code: "333111").first_or_create
    IndustryCode.where(name: "Lawn and Garden Tractor and Home Lawn and Garden Equipment Manufacturing", internal_name: "lawn_and_garden_tractor_and_home_lawn_and_garden_equipment_manufacturing", industry_type: :industry, naics_code: "333112").first_or_create
    IndustryCode.where(name: "Construction Machinery Manufacturing", internal_name: "construction_machinery_manufacturing", industry_type: :industry, naics_code: "333120").first_or_create
    IndustryCode.where(name: "Mining Machinery and Equipment Manufacturing", internal_name: "mining_machinery_and_equipment_manufacturing", industry_type: :industry, naics_code: "333131").first_or_create
    IndustryCode.where(name: "Oil and Gas Field Machinery and Equipment Manufacturing", internal_name: "oil_and_gas_field_machinery_and_equipment_manufacturing", industry_type: :industry, naics_code: "333132").first_or_create
    IndustryCode.where(name: "Food Product Machinery Manufacturing", internal_name: "food_product_machinery_manufacturing", industry_type: :industry, naics_code: "333241").first_or_create
    IndustryCode.where(name: "Semiconductor Machinery Manufacturing", internal_name: "semiconductor_machinery_manufacturing", industry_type: :industry, naics_code: "333242").first_or_create
    IndustryCode.where(name: "Sawmill, Woodworking, and Paper Machinery Manufacturing", internal_name: "sawmill_woodworking_and_paper_machinery_manufacturing", industry_type: :industry, naics_code: "333243").first_or_create
    IndustryCode.where(name: "Printing Machinery and Equipment Manufacturing", internal_name: "printing_machinery_and_equipment_manufacturing", industry_type: :industry, naics_code: "333244").first_or_create
    IndustryCode.where(name: "Other Industrial Machinery Manufacturing", internal_name: "other_industrial_machinery_manufacturing", industry_type: :industry, naics_code: "333249").first_or_create
    IndustryCode.where(name: "Optical Instrument and Lens Manufacturing", internal_name: "optical_instrument_and_lens_manufacturing", industry_type: :industry, naics_code: "333314").first_or_create
    IndustryCode.where(name: "Photographic and Photocopying Equipment Manufacturing", internal_name: "photographic_and_photocopying_equipment_manufacturing", industry_type: :industry, naics_code: "333316").first_or_create
    IndustryCode.where(name: "Other Commercial and Service Industry Machinery Manufacturing", internal_name: "other_commercial_and_service_industry_machinery_manufacturing", industry_type: :industry, naics_code: "333318").first_or_create
    IndustryCode.where(name: "Industrial and Commercial Fan and Blower and Air Purification Equipment Manufacturing", internal_name: "industrial_and_commercial_fan_and_blower_and_air_purification_equipment_manufacturing", industry_type: :industry, naics_code: "333413").first_or_create
    IndustryCode.where(name: "Heating Equipment (except Warm Air Furnaces) Manufacturing", internal_name: "heating_equipment_except_warm_air_furnaces_manufacturing", industry_type: :industry, naics_code: "333414").first_or_create
    IndustryCode.where(name: "Air_Conditioning and Warm Air Heating Equipment and Commercial and Industrial Refrigeration Equipment Manufacturing", internal_name: "air_conditioning_and_warm_air_heating_equipment_and_commercial_and_industrial_refrigeration_equipment_manufacturing", industry_type: :industry, naics_code: "333415").first_or_create
    IndustryCode.where(name: "Industrial Mold Manufacturing", internal_name: "industrial_mold_manufacturing", industry_type: :industry, naics_code: "333511").first_or_create
    IndustryCode.where(name: "Special Die and Tool, Die Set, Jig, and Fixture Manufacturing", internal_name: "special_die_and_tool_die_set_jig_and_fixture_manufacturing", industry_type: :industry, naics_code: "333514").first_or_create
    IndustryCode.where(name: "Cutting Tool and Machine Tool Accessory Manufacturing", internal_name: "cutting_tool_and_machine_tool_accessory_manufacturing", industry_type: :industry, naics_code: "333515").first_or_create
    IndustryCode.where(name: "Machine Tool Manufacturing", internal_name: "machine_tool_manufacturing", industry_type: :industry, naics_code: "333517").first_or_create
    IndustryCode.where(name: "Rolling Mill and Other Metalworking Machinery Manufacturing", internal_name: "rolling_mill_and_other_metalworking_machinery_manufacturing", industry_type: :industry, naics_code: "333519").first_or_create
    IndustryCode.where(name: "Turbine and Turbine Generator Set Units Manufacturing", internal_name: "turbine_and_turbine_generator_set_units_manufacturing", industry_type: :industry, naics_code: "333611").first_or_create
    IndustryCode.where(name: "Speed Changer, Industrial High_Speed Drive, and Gear Manufacturing", internal_name: "speed_changer_industrial_high_speed_drive_and_gear_manufacturing", industry_type: :industry, naics_code: "333612").first_or_create
    IndustryCode.where(name: "Mechanical Power Transmission Equipment Manufacturing", internal_name: "mechanical_power_transmission_equipment_manufacturing", industry_type: :industry, naics_code: "333613").first_or_create
    IndustryCode.where(name: "Other Engine Equipment Manufacturing", internal_name: "other_engine_equipment_manufacturing", industry_type: :industry, naics_code: "333618").first_or_create
    IndustryCode.where(name: "Pump and Pumping Equipment Manufacturing", internal_name: "pump_and_pumping_equipment_manufacturing", industry_type: :industry, naics_code: "333911").first_or_create
    IndustryCode.where(name: "Air and Gas Compressor Manufacturing", internal_name: "air_and_gas_compressor_manufacturing", industry_type: :industry, naics_code: "333912").first_or_create
    IndustryCode.where(name: "Measuring and Dispensing Pump Manufacturing", internal_name: "measuring_and_dispensing_pump_manufacturing", industry_type: :industry, naics_code: "333913").first_or_create
    IndustryCode.where(name: "Elevator and Moving Stairway Manufacturing", internal_name: "elevator_and_moving_stairway_manufacturing", industry_type: :industry, naics_code: "333921").first_or_create
    IndustryCode.where(name: "Conveyor and Conveying Equipment Manufacturing", internal_name: "conveyor_and_conveying_equipment_manufacturing", industry_type: :industry, naics_code: "333922").first_or_create
    IndustryCode.where(name: "Overhead Traveling Crane, Hoist, and Monorail System Manufacturing", internal_name: "overhead_traveling_crane_hoist_and_monorail_system_manufacturing", industry_type: :industry, naics_code: "333923").first_or_create
    IndustryCode.where(name: "Industrial Truck, Tractor, Trailer, and Stacker Machinery Manufacturing", internal_name: "industrial_truck_tractor_trailer_and_stacker_machinery_manufacturing", industry_type: :industry, naics_code: "333924").first_or_create
    IndustryCode.where(name: "Power_Driven Handtool Manufacturing", internal_name: "power_driven_handtool_manufacturing", industry_type: :industry, naics_code: "333991").first_or_create
    IndustryCode.where(name: "Welding and Soldering Equipment Manufacturing", internal_name: "welding_and_soldering_equipment_manufacturing", industry_type: :industry, naics_code: "333992").first_or_create
    IndustryCode.where(name: "Packaging Machinery Manufacturing", internal_name: "packaging_machinery_manufacturing", industry_type: :industry, naics_code: "333993").first_or_create
    IndustryCode.where(name: "Industrial Process Furnace and Oven Manufacturing", internal_name: "industrial_process_furnace_and_oven_manufacturing", industry_type: :industry, naics_code: "333994").first_or_create
    IndustryCode.where(name: "Fluid Power Cylinder and Actuator Manufacturing", internal_name: "fluid_power_cylinder_and_actuator_manufacturing", industry_type: :industry, naics_code: "333995").first_or_create
    IndustryCode.where(name: "Fluid Power Pump and Motor Manufacturing", internal_name: "fluid_power_pump_and_motor_manufacturing", industry_type: :industry, naics_code: "333996").first_or_create
    IndustryCode.where(name: "Scale and Balance Manufacturing", internal_name: "scale_and_balance_manufacturing", industry_type: :industry, naics_code: "333997").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous General Purpose Machinery Manufacturing", internal_name: "all_other_miscellaneous_general_purpose_machinery_manufacturing", industry_type: :industry, naics_code: "333999").first_or_create
    IndustryCode.where(name: "Electronic Computer Manufacturing", internal_name: "electronic_computer_manufacturing", industry_type: :industry, naics_code: "334111").first_or_create
    IndustryCode.where(name: "Computer Storage Device Manufacturing", internal_name: "computer_storage_device_manufacturing", industry_type: :industry, naics_code: "334112").first_or_create
    IndustryCode.where(name: "Computer Terminal and Other Computer Peripheral Equipment Manufacturing", internal_name: "computer_terminal_and_other_computer_peripheral_equipment_manufacturing", industry_type: :industry, naics_code: "334118").first_or_create
    IndustryCode.where(name: "Telephone Apparatus Manufacturing", internal_name: "telephone_apparatus_manufacturing", industry_type: :industry, naics_code: "334210").first_or_create
    IndustryCode.where(name: "Radio and Television Broadcasting and Wireless Communications Equipment Manufacturing", internal_name: "radio_and_television_broadcasting_and_wireless_communications_equipment_manufacturing", industry_type: :industry, naics_code: "334220").first_or_create
    IndustryCode.where(name: "Other Communications Equipment Manufacturing", internal_name: "other_communications_equipment_manufacturing", industry_type: :industry, naics_code: "334290").first_or_create
    IndustryCode.where(name: "Audio and Video Equipment Manufacturing", internal_name: "audio_and_video_equipment_manufacturing", industry_type: :industry, naics_code: "334310").first_or_create
    IndustryCode.where(name: "Bare Printed Circuit Board Manufacturing", internal_name: "bare_printed_circuit_board_manufacturing", industry_type: :industry, naics_code: "334412").first_or_create
    IndustryCode.where(name: "Semiconductor and Related Device Manufacturing", internal_name: "semiconductor_and_related_device_manufacturing", industry_type: :industry, naics_code: "334413").first_or_create
    IndustryCode.where(name: "Capacitor, Resistor, Coil, Transformer, and Other Inductor Manufacturing", internal_name: "capacitor_resistor_coil_transformer_and_other_inductor_manufacturing", industry_type: :industry, naics_code: "334416").first_or_create
    IndustryCode.where(name: "Electronic Connector Manufacturing", internal_name: "electronic_connector_manufacturing", industry_type: :industry, naics_code: "334417").first_or_create
    IndustryCode.where(name: "Printed Circuit Assembly (Electronic Assembly) Manufacturing", internal_name: "printed_circuit_assembly_electronic_assembly_manufacturing", industry_type: :industry, naics_code: "334418").first_or_create
    IndustryCode.where(name: "Other Electronic Component Manufacturing", internal_name: "other_electronic_component_manufacturing", industry_type: :industry, naics_code: "334419").first_or_create
    IndustryCode.where(name: "Electromedical and Electrotherapeutic Apparatus Manufacturing", internal_name: "electromedical_and_electrotherapeutic_apparatus_manufacturing", industry_type: :industry, naics_code: "334510").first_or_create
    IndustryCode.where(name: "Search, Detection, Navigation, Guidance, Aeronautical, and Nautical System and Instrument Manufacturing", internal_name: "search_detection_navigation_guidance_aeronautical_and_nautical_system_and_instrument_manufacturing", industry_type: :industry, naics_code: "334511").first_or_create
    IndustryCode.where(name: "Automatic Environmental Control Manufacturing for Residential, Commercial, and Appliance Use", internal_name: "automatic_environmental_control_manufacturing_for_residential_commercial_and_appliance_use", industry_type: :industry, naics_code: "334512").first_or_create
    IndustryCode.where(name: "Instruments and Related Products Manufacturing for Measuring, Displaying, and Controlling Industrial Process Variables", internal_name: "instruments_and_related_products_manufacturing_for_measuring_displaying_and_controlling_industrial_process_variables", industry_type: :industry, naics_code: "334513").first_or_create
    IndustryCode.where(name: "Totalizing Fluid Meter and Counting Device Manufacturing", internal_name: "totalizing_fluid_meter_and_counting_device_manufacturing", industry_type: :industry, naics_code: "334514").first_or_create
    IndustryCode.where(name: "Instrument Manufacturing for Measuring and Testing Electricity and Electrical Signals", internal_name: "instrument_manufacturing_for_measuring_and_testing_electricity_and_electrical_signals", industry_type: :industry, naics_code: "334515").first_or_create
    IndustryCode.where(name: "Analytical Laboratory Instrument Manufacturing", internal_name: "analytical_laboratory_instrument_manufacturing", industry_type: :industry, naics_code: "334516").first_or_create
    IndustryCode.where(name: "Irradiation Apparatus Manufacturing", internal_name: "irradiation_apparatus_manufacturing", industry_type: :industry, naics_code: "334517").first_or_create
    IndustryCode.where(name: "Other Measuring and Controlling Device Manufacturing", internal_name: "other_measuring_and_controlling_device_manufacturing", industry_type: :industry, naics_code: "334519").first_or_create
    IndustryCode.where(name: "Blank Magnetic and Optical Recording Media Manufacturing", internal_name: "blank_magnetic_and_optical_recording_media_manufacturing", industry_type: :industry, naics_code: "334613").first_or_create
    IndustryCode.where(name: "Software and Other Prerecorded Compact Disc, Tape, and Record Reproducing", internal_name: "software_and_other_prerecorded_compact_disc_tape_and_record_reproducing", industry_type: :industry, naics_code: "334614").first_or_create
    IndustryCode.where(name: "Electric Lamp Bulb and Part Manufacturing", internal_name: "electric_lamp_bulb_and_part_manufacturing", industry_type: :industry, naics_code: "335110").first_or_create
    IndustryCode.where(name: "Residential Electric Lighting Fixture Manufacturing", internal_name: "residential_electric_lighting_fixture_manufacturing", industry_type: :industry, naics_code: "335121").first_or_create
    IndustryCode.where(name: "Commercial, Industrial, and Institutional Electric Lighting Fixture Manufacturing", internal_name: "commercial_industrial_and_institutional_electric_lighting_fixture_manufacturing", industry_type: :industry, naics_code: "335122").first_or_create
    IndustryCode.where(name: "Other Lighting Equipment Manufacturing", internal_name: "other_lighting_equipment_manufacturing", industry_type: :industry, naics_code: "335129").first_or_create
    IndustryCode.where(name: "Small Electrical Appliance Manufacturing", internal_name: "small_electrical_appliance_manufacturing", industry_type: :industry, naics_code: "335210").first_or_create
    IndustryCode.where(name: "Household Cooking Appliance Manufacturing", internal_name: "household_cooking_appliance_manufacturing", industry_type: :industry, naics_code: "335221").first_or_create
    IndustryCode.where(name: "Household Refrigerator and Home Freezer Manufacturing", internal_name: "household_refrigerator_and_home_freezer_manufacturing", industry_type: :industry, naics_code: "335222").first_or_create
    IndustryCode.where(name: "Household Laundry Equipment Manufacturing", internal_name: "household_laundry_equipment_manufacturing", industry_type: :industry, naics_code: "335224").first_or_create
    IndustryCode.where(name: "Other Major Household Appliance Manufacturing", internal_name: "other_major_household_appliance_manufacturing", industry_type: :industry, naics_code: "335228").first_or_create
    IndustryCode.where(name: "Power, Distribution, and Specialty Transformer Manufacturing", internal_name: "power_distribution_and_specialty_transformer_manufacturing", industry_type: :industry, naics_code: "335311").first_or_create
    IndustryCode.where(name: "Motor and Generator Manufacturing", internal_name: "motor_and_generator_manufacturing", industry_type: :industry, naics_code: "335312").first_or_create
    IndustryCode.where(name: "Switchgear and Switchboard Apparatus Manufacturing", internal_name: "switchgear_and_switchboard_apparatus_manufacturing", industry_type: :industry, naics_code: "335313").first_or_create
    IndustryCode.where(name: "Relay and Industrial Control Manufacturing", internal_name: "relay_and_industrial_control_manufacturing", industry_type: :industry, naics_code: "335314").first_or_create
    IndustryCode.where(name: "Storage Battery Manufacturing", internal_name: "storage_battery_manufacturing", industry_type: :industry, naics_code: "335911").first_or_create
    IndustryCode.where(name: "Primary Battery Manufacturing", internal_name: "primary_battery_manufacturing", industry_type: :industry, naics_code: "335912").first_or_create
    IndustryCode.where(name: "Fiber Optic Cable Manufacturing", internal_name: "fiber_optic_cable_manufacturing", industry_type: :industry, naics_code: "335921").first_or_create
    IndustryCode.where(name: "Other Communication and Energy Wire Manufacturing", internal_name: "other_communication_and_energy_wire_manufacturing", industry_type: :industry, naics_code: "335929").first_or_create
    IndustryCode.where(name: "Current_Carrying Wiring Device Manufacturing", internal_name: "current_carrying_wiring_device_manufacturing", industry_type: :industry, naics_code: "335931").first_or_create
    IndustryCode.where(name: "Noncurrent_Carrying Wiring Device Manufacturing", internal_name: "noncurrent_carrying_wiring_device_manufacturing", industry_type: :industry, naics_code: "335932").first_or_create
    IndustryCode.where(name: "Carbon and Graphite Product Manufacturing", internal_name: "carbon_and_graphite_product_manufacturing", industry_type: :industry, naics_code: "335991").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Electrical Equipment and Component Manufacturing", internal_name: "all_other_miscellaneous_electrical_equipment_and_component_manufacturing", industry_type: :industry, naics_code: "335999").first_or_create
    IndustryCode.where(name: "Automobile Manufacturing", internal_name: "automobile_manufacturing", industry_type: :industry, naics_code: "336111").first_or_create
    IndustryCode.where(name: "Light Truck and Utility Vehicle Manufacturing", internal_name: "light_truck_and_utility_vehicle_manufacturing", industry_type: :industry, naics_code: "336112").first_or_create
    IndustryCode.where(name: "Heavy Duty Truck Manufacturing", internal_name: "heavy_duty_truck_manufacturing", industry_type: :industry, naics_code: "336120").first_or_create
    IndustryCode.where(name: "Motor Vehicle Body Manufacturing", internal_name: "motor_vehicle_body_manufacturing", industry_type: :industry, naics_code: "336211").first_or_create
    IndustryCode.where(name: "Truck Trailer Manufacturing", internal_name: "truck_trailer_manufacturing", industry_type: :industry, naics_code: "336212").first_or_create
    IndustryCode.where(name: "Motor Home Manufacturing", internal_name: "motor_home_manufacturing", industry_type: :industry, naics_code: "336213").first_or_create
    IndustryCode.where(name: "Travel Trailer and Camper Manufacturing", internal_name: "travel_trailer_and_camper_manufacturing", industry_type: :industry, naics_code: "336214").first_or_create
    IndustryCode.where(name: "Motor Vehicle Gasoline Engine and Engine Parts Manufacturing", internal_name: "motor_vehicle_gasoline_engine_and_engine_parts_manufacturing", industry_type: :industry, naics_code: "336310").first_or_create
    IndustryCode.where(name: "Motor Vehicle Electrical and Electronic Equipment Manufacturing", internal_name: "motor_vehicle_electrical_and_electronic_equipment_manufacturing", industry_type: :industry, naics_code: "336320").first_or_create
    IndustryCode.where(name: "Motor Vehicle Steering and Suspension Components (except Spring) Manufacturing", internal_name: "motor_vehicle_steering_and_suspension_components_except_spring_manufacturing", industry_type: :industry, naics_code: "336330").first_or_create
    IndustryCode.where(name: "Motor Vehicle Brake System Manufacturing", internal_name: "motor_vehicle_brake_system_manufacturing", industry_type: :industry, naics_code: "336340").first_or_create
    IndustryCode.where(name: "Motor Vehicle Transmission and Power Train Parts Manufacturing", internal_name: "motor_vehicle_transmission_and_power_train_parts_manufacturing", industry_type: :industry, naics_code: "336350").first_or_create
    IndustryCode.where(name: "Motor Vehicle Seating and Interior Trim Manufacturing", internal_name: "motor_vehicle_seating_and_interior_trim_manufacturing", industry_type: :industry, naics_code: "336360").first_or_create
    IndustryCode.where(name: "Motor Vehicle Metal Stamping", internal_name: "motor_vehicle_metal_stamping", industry_type: :industry, naics_code: "336370").first_or_create
    IndustryCode.where(name: "Other Motor Vehicle Parts Manufacturing", internal_name: "other_motor_vehicle_parts_manufacturing", industry_type: :industry, naics_code: "336390").first_or_create
    IndustryCode.where(name: "Aircraft Manufacturing", internal_name: "aircraft_manufacturing", industry_type: :industry, naics_code: "336411").first_or_create
    IndustryCode.where(name: "Aircraft Engine and Engine Parts Manufacturing", internal_name: "aircraft_engine_and_engine_parts_manufacturing", industry_type: :industry, naics_code: "336412").first_or_create
    IndustryCode.where(name: "Other Aircraft Parts and Auxiliary Equipment Manufacturing", internal_name: "other_aircraft_parts_and_auxiliary_equipment_manufacturing", industry_type: :industry, naics_code: "336413").first_or_create
    IndustryCode.where(name: "Guided Missile and Space Vehicle Manufacturing", internal_name: "guided_missile_and_space_vehicle_manufacturing", industry_type: :industry, naics_code: "336414").first_or_create
    IndustryCode.where(name: "Guided Missile and Space Vehicle Propulsion Unit and Propulsion Unit Parts Manufacturing", internal_name: "guided_missile_and_space_vehicle_propulsion_unit_and_propulsion_unit_parts_manufacturing", industry_type: :industry, naics_code: "336415").first_or_create
    IndustryCode.where(name: "Other Guided Missile and Space Vehicle Parts and Auxiliary Equipment Manufacturing", internal_name: "other_guided_missile_and_space_vehicle_parts_and_auxiliary_equipment_manufacturing", industry_type: :industry, naics_code: "336419").first_or_create
    IndustryCode.where(name: "Railroad Rolling Stock Manufacturing", internal_name: "railroad_rolling_stock_manufacturing", industry_type: :industry, naics_code: "336510").first_or_create
    IndustryCode.where(name: "Ship Building and Repairing", internal_name: "ship_building_and_repairing", industry_type: :industry, naics_code: "336611").first_or_create
    IndustryCode.where(name: "Boat Building", internal_name: "boat_building", industry_type: :industry, naics_code: "336612").first_or_create
    IndustryCode.where(name: "Motorcycle, Bicycle, and Parts Manufacturing", internal_name: "motorcycle_bicycle_and_parts_manufacturing", industry_type: :industry, naics_code: "336991").first_or_create
    IndustryCode.where(name: "Military Armored Vehicle, Tank, and Tank Component Manufacturing", internal_name: "military_armored_vehicle_tank_and_tank_component_manufacturing", industry_type: :industry, naics_code: "336992").first_or_create
    IndustryCode.where(name: "All Other Transportation Equipment Manufacturing", internal_name: "all_other_transportation_equipment_manufacturing", industry_type: :industry, naics_code: "336999").first_or_create
    IndustryCode.where(name: "Wood Kitchen Cabinet and Countertop Manufacturing", internal_name: "wood_kitchen_cabinet_and_countertop_manufacturing", industry_type: :industry, naics_code: "337110").first_or_create
    IndustryCode.where(name: "Upholstered Household Furniture Manufacturing", internal_name: "upholstered_household_furniture_manufacturing", industry_type: :industry, naics_code: "337121").first_or_create
    IndustryCode.where(name: "Nonupholstered Wood Household Furniture Manufacturing", internal_name: "nonupholstered_wood_household_furniture_manufacturing", industry_type: :industry, naics_code: "337122").first_or_create
    IndustryCode.where(name: "Metal Household Furniture Manufacturing", internal_name: "metal_household_furniture_manufacturing", industry_type: :industry, naics_code: "337124").first_or_create
    IndustryCode.where(name: "Household Furniture (except Wood and Metal) Manufacturing", internal_name: "household_furniture_except_wood_and_metal_manufacturing", industry_type: :industry, naics_code: "337125").first_or_create
    IndustryCode.where(name: "Institutional Furniture Manufacturing", internal_name: "institutional_furniture_manufacturing", industry_type: :industry, naics_code: "337127").first_or_create
    IndustryCode.where(name: "Wood Office Furniture Manufacturing", internal_name: "wood_office_furniture_manufacturing", industry_type: :industry, naics_code: "337211").first_or_create
    IndustryCode.where(name: "Custom Architectural Woodwork and Millwork Manufacturing", internal_name: "custom_architectural_woodwork_and_millwork_manufacturing", industry_type: :industry, naics_code: "337212").first_or_create
    IndustryCode.where(name: "Office Furniture (except Wood) Manufacturing", internal_name: "office_furniture_except_wood_manufacturing", industry_type: :industry, naics_code: "337214").first_or_create
    IndustryCode.where(name: "Showcase, Partition, Shelving, and Locker Manufacturing", internal_name: "showcase_partition_shelving_and_locker_manufacturing", industry_type: :industry, naics_code: "337215").first_or_create
    IndustryCode.where(name: "Mattress Manufacturing", internal_name: "mattress_manufacturing", industry_type: :industry, naics_code: "337910").first_or_create
    IndustryCode.where(name: "Blind and Shade Manufacturing", internal_name: "blind_and_shade_manufacturing", industry_type: :industry, naics_code: "337920").first_or_create
    IndustryCode.where(name: "Surgical and Medical Instrument Manufacturing", internal_name: "surgical_and_medical_instrument_manufacturing", industry_type: :industry, naics_code: "339112").first_or_create
    IndustryCode.where(name: "Surgical Appliance and Supplies Manufacturing", internal_name: "surgical_appliance_and_supplies_manufacturing", industry_type: :industry, naics_code: "339113").first_or_create
    IndustryCode.where(name: "Dental Equipment and Supplies Manufacturing", internal_name: "dental_equipment_and_supplies_manufacturing", industry_type: :industry, naics_code: "339114").first_or_create
    IndustryCode.where(name: "Ophthalmic Goods Manufacturing", internal_name: "ophthalmic_goods_manufacturing", industry_type: :industry, naics_code: "339115").first_or_create
    IndustryCode.where(name: "Dental Laboratories", internal_name: "dental_laboratories", industry_type: :industry, naics_code: "339116").first_or_create
    IndustryCode.where(name: "Jewelry and Silverware Manufacturing", internal_name: "jewelry_and_silverware_manufacturing", industry_type: :industry, naics_code: "339910").first_or_create
    IndustryCode.where(name: "Sporting and Athletic Goods Manufacturing", internal_name: "sporting_and_athletic_goods_manufacturing", industry_type: :industry, naics_code: "339920").first_or_create
    IndustryCode.where(name: "Doll, Toy, and Game Manufacturing", internal_name: "doll_toy_and_game_manufacturing", industry_type: :industry, naics_code: "339930").first_or_create
    IndustryCode.where(name: "Office Supplies (except Paper) Manufacturing", internal_name: "office_supplies_except_paper_manufacturing", industry_type: :industry, naics_code: "339940").first_or_create
    IndustryCode.where(name: "Sign Manufacturing", internal_name: "sign_manufacturing", industry_type: :industry, naics_code: "339950").first_or_create
    IndustryCode.where(name: "Gasket, Packing, and Sealing Device Manufacturing", internal_name: "gasket_packing_and_sealing_device_manufacturing", industry_type: :industry, naics_code: "339991").first_or_create
    IndustryCode.where(name: "Musical Instrument Manufacturing", internal_name: "musical_instrument_manufacturing", industry_type: :industry, naics_code: "339992").first_or_create
    IndustryCode.where(name: "Fastener, Button, Needle, and Pin Manufacturing", internal_name: "fastener_button_needle_and_pin_manufacturing", industry_type: :industry, naics_code: "339993").first_or_create
    IndustryCode.where(name: "Broom, Brush, and Mop Manufacturing", internal_name: "broom_brush_and_mop_manufacturing", industry_type: :industry, naics_code: "339994").first_or_create
    IndustryCode.where(name: "Burial Casket Manufacturing", internal_name: "burial_casket_manufacturing", industry_type: :industry, naics_code: "339995").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Manufacturing", internal_name: "all_other_miscellaneous_manufacturing", industry_type: :industry, naics_code: "339999").first_or_create
    IndustryCode.where(name: "Automobile and Other Motor Vehicle Merchant Wholesalers", internal_name: "automobile_and_other_motor_vehicle_merchant_wholesalers", industry_type: :industry, naics_code: "423110").first_or_create
    IndustryCode.where(name: "Motor Vehicle Supplies and New Parts Merchant Wholesalers", internal_name: "motor_vehicle_supplies_and_new_parts_merchant_wholesalers", industry_type: :industry, naics_code: "423120").first_or_create
    IndustryCode.where(name: "Tire and Tube Merchant Wholesalers", internal_name: "tire_and_tube_merchant_wholesalers", industry_type: :industry, naics_code: "423130").first_or_create
    IndustryCode.where(name: "Motor Vehicle Parts (Used) Merchant Wholesalers", internal_name: "motor_vehicle_parts_used_merchant_wholesalers", industry_type: :industry, naics_code: "423140").first_or_create
    IndustryCode.where(name: "Furniture Merchant Wholesalers", internal_name: "furniture_merchant_wholesalers", industry_type: :industry, naics_code: "423210").first_or_create
    IndustryCode.where(name: "Home Furnishing Merchant Wholesalers", internal_name: "home_furnishing_merchant_wholesalers", industry_type: :industry, naics_code: "423220").first_or_create
    IndustryCode.where(name: "Lumber, Plywood, Millwork, and Wood Panel Merchant Wholesalers", internal_name: "lumber_plywood_millwork_and_wood_panel_merchant_wholesalers", industry_type: :industry, naics_code: "423310").first_or_create
    IndustryCode.where(name: "Brick, Stone, and Related Construction Material Merchant Wholesalers", internal_name: "brick_stone_and_related_construction_material_merchant_wholesalers", industry_type: :industry, naics_code: "423320").first_or_create
    IndustryCode.where(name: "Roofing, Siding, and Insulation Material Merchant Wholesalers", internal_name: "roofing_siding_and_insulation_material_merchant_wholesalers", industry_type: :industry, naics_code: "423330").first_or_create
    IndustryCode.where(name: "Other Construction Material Merchant Wholesalers", internal_name: "other_construction_material_merchant_wholesalers", industry_type: :industry, naics_code: "423390").first_or_create
    IndustryCode.where(name: "Photographic Equipment and Supplies Merchant Wholesalers", internal_name: "photographic_equipment_and_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "423410").first_or_create
    IndustryCode.where(name: "Office Equipment Merchant Wholesalers", internal_name: "office_equipment_merchant_wholesalers", industry_type: :industry, naics_code: "423420").first_or_create
    IndustryCode.where(name: "Computer and Computer Peripheral Equipment and Software Merchant Wholesalers", internal_name: "computer_and_computer_peripheral_equipment_and_software_merchant_wholesalers", industry_type: :industry, naics_code: "423430").first_or_create
    IndustryCode.where(name: "Other Commercial Equipment Merchant Wholesalers", internal_name: "other_commercial_equipment_merchant_wholesalers", industry_type: :industry, naics_code: "423440").first_or_create
    IndustryCode.where(name: "Medical, Dental, and Hospital Equipment and Supplies Merchant Wholesalers", internal_name: "medical_dental_and_hospital_equipment_and_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "423450").first_or_create
    IndustryCode.where(name: "Ophthalmic Goods Merchant Wholesalers", internal_name: "ophthalmic_goods_merchant_wholesalers", industry_type: :industry, naics_code: "423460").first_or_create
    IndustryCode.where(name: "Other Professional Equipment and Supplies Merchant Wholesalers", internal_name: "other_professional_equipment_and_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "423490").first_or_create
    IndustryCode.where(name: "Metal Service Centers and Other Metal Merchant Wholesalers", internal_name: "metal_service_centers_and_other_metal_merchant_wholesalers", industry_type: :industry, naics_code: "423510").first_or_create
    IndustryCode.where(name: "Coal and Other Mineral and Ore Merchant Wholesalers", internal_name: "coal_and_other_mineral_and_ore_merchant_wholesalers", industry_type: :industry, naics_code: "423520").first_or_create
    IndustryCode.where(name: "Electrical Apparatus and Equipment, Wiring Supplies, and Related Equipment Merchant Wholesalers", internal_name: "electrical_apparatus_and_equipment_wiring_supplies_and_related_equipment_merchant_wholesalers", industry_type: :industry, naics_code: "423610").first_or_create
    IndustryCode.where(name: "Household Appliances, Electric Housewares, and Consumer Electronics Merchant Wholesalers", internal_name: "household_appliances_electric_housewares_and_consumer_electronics_merchant_wholesalers", industry_type: :industry, naics_code: "423620").first_or_create
    IndustryCode.where(name: "Other Electronic Parts and Equipment Merchant Wholesalers", internal_name: "other_electronic_parts_and_equipment_merchant_wholesalers", industry_type: :industry, naics_code: "423690").first_or_create
    IndustryCode.where(name: "Hardware Merchant Wholesalers", internal_name: "hardware_merchant_wholesalers", industry_type: :industry, naics_code: "423710").first_or_create
    IndustryCode.where(name: "Plumbing and Heating Equipment and Supplies (Hydronics) Merchant Wholesalers", internal_name: "plumbing_and_heating_equipment_and_supplies_hydronics_merchant_wholesalers", industry_type: :industry, naics_code: "423720").first_or_create
    IndustryCode.where(name: "Warm Air Heating and Air_Conditioning Equipment and Supplies Merchant Wholesalers", internal_name: "warm_air_heating_and_air_conditioning_equipment_and_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "423730").first_or_create
    IndustryCode.where(name: "Refrigeration Equipment and Supplies Merchant Wholesalers", internal_name: "refrigeration_equipment_and_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "423740").first_or_create
    IndustryCode.where(name: "Construction and Mining (except Oil Well) Machinery and Equipment Merchant Wholesalers", internal_name: "construction_and_mining_except_oil_well_machinery_and_equipment_merchant_wholesalers", industry_type: :industry, naics_code: "423810").first_or_create
    IndustryCode.where(name: "Farm and Garden Machinery and Equipment Merchant Wholesalers", internal_name: "farm_and_garden_machinery_and_equipment_merchant_wholesalers", industry_type: :industry, naics_code: "423820").first_or_create
    IndustryCode.where(name: "Industrial Machinery and Equipment Merchant Wholesalers", internal_name: "industrial_machinery_and_equipment_merchant_wholesalers", industry_type: :industry, naics_code: "423830").first_or_create
    IndustryCode.where(name: "Industrial Supplies Merchant Wholesalers", internal_name: "industrial_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "423840").first_or_create
    IndustryCode.where(name: "Service Establishment Equipment and Supplies Merchant Wholesalers", internal_name: "service_establishment_equipment_and_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "423850").first_or_create
    IndustryCode.where(name: "Transportation Equipment and Supplies (except Motor Vehicle) Merchant Wholesalers", internal_name: "transportation_equipment_and_supplies_except_motor_vehicle_merchant_wholesalers", industry_type: :industry, naics_code: "423860").first_or_create
    IndustryCode.where(name: "Sporting and Recreational Goods and Supplies Merchant Wholesalers", internal_name: "sporting_and_recreational_goods_and_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "423910").first_or_create
    IndustryCode.where(name: "Toy and Hobby Goods and Supplies Merchant Wholesalers", internal_name: "toy_and_hobby_goods_and_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "423920").first_or_create
    IndustryCode.where(name: "Recyclable Material Merchant Wholesalers", internal_name: "recyclable_material_merchant_wholesalers", industry_type: :industry, naics_code: "423930").first_or_create
    IndustryCode.where(name: "Jewelry, Watch, Precious Stone, and Precious Metal Merchant Wholesalers", internal_name: "jewelry_watch_precious_stone_and_precious_metal_merchant_wholesalers", industry_type: :industry, naics_code: "423940").first_or_create
    IndustryCode.where(name: "Other Miscellaneous Durable Goods Merchant Wholesalers", internal_name: "other_miscellaneous_durable_goods_merchant_wholesalers", industry_type: :industry, naics_code: "423990").first_or_create
    IndustryCode.where(name: "Printing and Writing Paper Merchant Wholesalers", internal_name: "printing_and_writing_paper_merchant_wholesalers", industry_type: :industry, naics_code: "424110").first_or_create
    IndustryCode.where(name: "Stationery and Office Supplies Merchant Wholesalers", internal_name: "stationery_and_office_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "424120").first_or_create
    IndustryCode.where(name: "Industrial and Personal Service Paper Merchant Wholesalers", internal_name: "industrial_and_personal_service_paper_merchant_wholesalers", industry_type: :industry, naics_code: "424130").first_or_create
    IndustryCode.where(name: "Drugs and Druggists' Sundries Merchant Wholesalers", internal_name: "drugs_and_druggists'_sundries_merchant_wholesalers", industry_type: :industry, naics_code: "424210").first_or_create
    IndustryCode.where(name: "Piece Goods, Notions, and Other Dry Goods Merchant Wholesalers", internal_name: "piece_goods_notions_and_other_dry_goods_merchant_wholesalers", industry_type: :industry, naics_code: "424310").first_or_create
    IndustryCode.where(name: "Men's and Boys' Clothing and Furnishings Merchant Wholesalers", internal_name: "men's_and_boys'_clothing_and_furnishings_merchant_wholesalers", industry_type: :industry, naics_code: "424320").first_or_create
    IndustryCode.where(name: "Women's, Children's, and Infants' Clothing and Accessories Merchant Wholesalers", internal_name: "women's_children's_and_infants'_clothing_and_accessories_merchant_wholesalers", industry_type: :industry, naics_code: "424330").first_or_create
    IndustryCode.where(name: "Footwear Merchant Wholesalers", internal_name: "footwear_merchant_wholesalers", industry_type: :industry, naics_code: "424340").first_or_create
    IndustryCode.where(name: "General Line Grocery Merchant Wholesalers", internal_name: "general_line_grocery_merchant_wholesalers", industry_type: :industry, naics_code: "424410").first_or_create
    IndustryCode.where(name: "Packaged Frozen Food Merchant Wholesalers", internal_name: "packaged_frozen_food_merchant_wholesalers", industry_type: :industry, naics_code: "424420").first_or_create
    IndustryCode.where(name: "Dairy Product (except Dried or Canned) Merchant Wholesalers", internal_name: "dairy_product_except_dried_or_canned_merchant_wholesalers", industry_type: :industry, naics_code: "424430").first_or_create
    IndustryCode.where(name: "Poultry and Poultry Product Merchant Wholesalers", internal_name: "poultry_and_poultry_product_merchant_wholesalers", industry_type: :industry, naics_code: "424440").first_or_create
    IndustryCode.where(name: "Confectionery Merchant Wholesalers", internal_name: "confectionery_merchant_wholesalers", industry_type: :industry, naics_code: "424450").first_or_create
    IndustryCode.where(name: "Fish and Seafood Merchant Wholesalers", internal_name: "fish_and_seafood_merchant_wholesalers", industry_type: :industry, naics_code: "424460").first_or_create
    IndustryCode.where(name: "Meat and Meat Product Merchant Wholesalers", internal_name: "meat_and_meat_product_merchant_wholesalers", industry_type: :industry, naics_code: "424470").first_or_create
    IndustryCode.where(name: "Fresh Fruit and Vegetable Merchant Wholesalers", internal_name: "fresh_fruit_and_vegetable_merchant_wholesalers", industry_type: :industry, naics_code: "424480").first_or_create
    IndustryCode.where(name: "Other Grocery and Related Products Merchant Wholesalers", internal_name: "other_grocery_and_related_products_merchant_wholesalers", industry_type: :industry, naics_code: "424490").first_or_create
    IndustryCode.where(name: "Grain and Field Bean Merchant Wholesalers", internal_name: "grain_and_field_bean_merchant_wholesalers", industry_type: :industry, naics_code: "424510").first_or_create
    IndustryCode.where(name: "Livestock Merchant Wholesalers", internal_name: "livestock_merchant_wholesalers", industry_type: :industry, naics_code: "424520").first_or_create
    IndustryCode.where(name: "Other Farm Product Raw Material Merchant Wholesalers", internal_name: "other_farm_product_raw_material_merchant_wholesalers", industry_type: :industry, naics_code: "424590").first_or_create
    IndustryCode.where(name: "Plastics Materials and Basic Forms and Shapes Merchant Wholesalers", internal_name: "plastics_materials_and_basic_forms_and_shapes_merchant_wholesalers", industry_type: :industry, naics_code: "424610").first_or_create
    IndustryCode.where(name: "Other Chemical and Allied Products Merchant Wholesalers", internal_name: "other_chemical_and_allied_products_merchant_wholesalers", industry_type: :industry, naics_code: "424690").first_or_create
    IndustryCode.where(name: "Petroleum Bulk Stations and Terminals", internal_name: "petroleum_bulk_stations_and_terminals", industry_type: :industry, naics_code: "424710").first_or_create
    IndustryCode.where(name: "Petroleum and Petroleum Products Merchant Wholesalers (except Bulk Stations and Terminals)", internal_name: "petroleum_and_petroleum_products_merchant_wholesalers_except_bulk_stations_and_terminals", industry_type: :industry, naics_code: "424720").first_or_create
    IndustryCode.where(name: "Beer and Ale Merchant Wholesalers", internal_name: "beer_and_ale_merchant_wholesalers", industry_type: :industry, naics_code: "424810").first_or_create
    IndustryCode.where(name: "Wine and Distilled Alcoholic Beverage Merchant Wholesalers", internal_name: "wine_and_distilled_alcoholic_beverage_merchant_wholesalers", industry_type: :industry, naics_code: "424820").first_or_create
    IndustryCode.where(name: "Farm Supplies Merchant Wholesalers", internal_name: "farm_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "424910").first_or_create
    IndustryCode.where(name: "Book, Periodical, and Newspaper Merchant Wholesalers", internal_name: "book_periodical_and_newspaper_merchant_wholesalers", industry_type: :industry, naics_code: "424920").first_or_create
    IndustryCode.where(name: "Flower, Nursery Stock, and Florists' Supplies Merchant Wholesalers", internal_name: "flower_nursery_stock_and_florists'_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "424930").first_or_create
    IndustryCode.where(name: "Tobacco and Tobacco Product Merchant Wholesalers", internal_name: "tobacco_and_tobacco_product_merchant_wholesalers", industry_type: :industry, naics_code: "424940").first_or_create
    IndustryCode.where(name: "Paint, Varnish, and Supplies Merchant Wholesalers", internal_name: "paint_varnish_and_supplies_merchant_wholesalers", industry_type: :industry, naics_code: "424950").first_or_create
    IndustryCode.where(name: "Other Miscellaneous Nondurable Goods Merchant Wholesalers", internal_name: "other_miscellaneous_nondurable_goods_merchant_wholesalers", industry_type: :industry, naics_code: "424990").first_or_create
    IndustryCode.where(name: "Business to Business Electronic Markets", internal_name: "business_to_business_electronic_markets", industry_type: :industry, naics_code: "425110").first_or_create
    IndustryCode.where(name: "Wholesale Trade Agents and Brokers", internal_name: "wholesale_trade_agents_and_brokers", industry_type: :industry, naics_code: "425120").first_or_create
    IndustryCode.where(name: "New Car Dealers", internal_name: "new_car_dealers", industry_type: :industry, naics_code: "441110").first_or_create
    IndustryCode.where(name: "Used Car Dealers", internal_name: "used_car_dealers", industry_type: :industry, naics_code: "441120").first_or_create
    IndustryCode.where(name: "Recreational Vehicle Dealers", internal_name: "recreational_vehicle_dealers", industry_type: :industry, naics_code: "441210").first_or_create
    IndustryCode.where(name: "Boat Dealers", internal_name: "boat_dealers", industry_type: :industry, naics_code: "441222").first_or_create
    IndustryCode.where(name: "Motorcycle, ATV, and All Other Motor Vehicle Dealers", internal_name: "motorcycle_atv_and_all_other_motor_vehicle_dealers", industry_type: :industry, naics_code: "441228").first_or_create
    IndustryCode.where(name: "Automotive Parts and Accessories Stores", internal_name: "automotive_parts_and_accessories_stores", industry_type: :industry, naics_code: "441310").first_or_create
    IndustryCode.where(name: "Tire Dealers", internal_name: "tire_dealers", industry_type: :industry, naics_code: "441320").first_or_create
    IndustryCode.where(name: "Furniture Stores", internal_name: "furniture_stores", industry_type: :industry, naics_code: "442110").first_or_create
    IndustryCode.where(name: "Floor Covering Stores", internal_name: "floor_covering_stores", industry_type: :industry, naics_code: "442210").first_or_create
    IndustryCode.where(name: "Window Treatment Stores", internal_name: "window_treatment_stores", industry_type: :industry, naics_code: "442291").first_or_create
    IndustryCode.where(name: "All Other Home Furnishings Stores", internal_name: "all_other_home_furnishings_stores", industry_type: :industry, naics_code: "442299").first_or_create
    IndustryCode.where(name: "Household Appliance Stores", internal_name: "household_appliance_stores", industry_type: :industry, naics_code: "443141").first_or_create
    IndustryCode.where(name: "Electronics Stores", internal_name: "electronics_stores", industry_type: :industry, naics_code: "443142").first_or_create
    IndustryCode.where(name: "Home Centers", internal_name: "home_centers", industry_type: :industry, naics_code: "444110").first_or_create
    IndustryCode.where(name: "Paint and Wallpaper Stores", internal_name: "paint_and_wallpaper_stores", industry_type: :industry, naics_code: "444120").first_or_create
    IndustryCode.where(name: "Hardware Stores", internal_name: "hardware_stores", industry_type: :industry, naics_code: "444130").first_or_create
    IndustryCode.where(name: "Other Building Material Dealers", internal_name: "other_building_material_dealers", industry_type: :industry, naics_code: "444190").first_or_create
    IndustryCode.where(name: "Outdoor Power Equipment Stores", internal_name: "outdoor_power_equipment_stores", industry_type: :industry, naics_code: "444210").first_or_create
    IndustryCode.where(name: "Nursery, Garden Center, and Farm Supply Stores", internal_name: "nursery_garden_center_and_farm_supply_stores", industry_type: :industry, naics_code: "444220").first_or_create
    IndustryCode.where(name: "Supermarkets and Other Grocery (except Convenience) Stores", internal_name: "supermarkets_and_other_grocery_except_convenience_stores", industry_type: :industry, naics_code: "445110").first_or_create
    IndustryCode.where(name: "Convenience Stores", internal_name: "convenience_stores", industry_type: :industry, naics_code: "445120").first_or_create
    IndustryCode.where(name: "Meat Markets", internal_name: "meat_markets", industry_type: :industry, naics_code: "445210").first_or_create
    IndustryCode.where(name: "Fish and Seafood Markets", internal_name: "fish_and_seafood_markets", industry_type: :industry, naics_code: "445220").first_or_create
    IndustryCode.where(name: "Fruit and Vegetable Markets", internal_name: "fruit_and_vegetable_markets", industry_type: :industry, naics_code: "445230").first_or_create
    IndustryCode.where(name: "Baked Goods Stores", internal_name: "baked_goods_stores", industry_type: :industry, naics_code: "445291").first_or_create
    IndustryCode.where(name: "Confectionery and Nut Stores", internal_name: "confectionery_and_nut_stores", industry_type: :industry, naics_code: "445292").first_or_create
    IndustryCode.where(name: "All Other Specialty Food Stores", internal_name: "all_other_specialty_food_stores", industry_type: :industry, naics_code: "445299").first_or_create
    IndustryCode.where(name: "Beer, Wine, and Liquor Stores", internal_name: "beer_wine_and_liquor_stores", industry_type: :industry, naics_code: "445310").first_or_create
    IndustryCode.where(name: "Pharmacies and Drug Stores", internal_name: "pharmacies_and_drug_stores", industry_type: :industry, naics_code: "446110").first_or_create
    IndustryCode.where(name: "Cosmetics, Beauty Supplies, and Perfume Stores", internal_name: "cosmetics_beauty_supplies_and_perfume_stores", industry_type: :industry, naics_code: "446120").first_or_create
    IndustryCode.where(name: "Optical Goods Stores", internal_name: "optical_goods_stores", industry_type: :industry, naics_code: "446130").first_or_create
    IndustryCode.where(name: "Food (Health) Supplement Stores", internal_name: "food_health_supplement_stores", industry_type: :industry, naics_code: "446191").first_or_create
    IndustryCode.where(name: "All Other Health and Personal Care Stores", internal_name: "all_other_health_and_personal_care_stores", industry_type: :industry, naics_code: "446199").first_or_create
    IndustryCode.where(name: "Gasoline Stations with Convenience Stores", internal_name: "gasoline_stations_with_convenience_stores", industry_type: :industry, naics_code: "447110").first_or_create
    IndustryCode.where(name: "Other Gasoline Stations", internal_name: "other_gasoline_stations", industry_type: :industry, naics_code: "447190").first_or_create
    IndustryCode.where(name: "Men's Clothing Stores", internal_name: "men's_clothing_stores", industry_type: :industry, naics_code: "448110").first_or_create
    IndustryCode.where(name: "Women's Clothing Stores", internal_name: "women's_clothing_stores", industry_type: :industry, naics_code: "448120").first_or_create
    IndustryCode.where(name: "Children's and Infants' Clothing Stores", internal_name: "children's_and_infants'_clothing_stores", industry_type: :industry, naics_code: "448130").first_or_create
    IndustryCode.where(name: "Family Clothing Stores", internal_name: "family_clothing_stores", industry_type: :industry, naics_code: "448140").first_or_create
    IndustryCode.where(name: "Clothing Accessories Stores", internal_name: "clothing_accessories_stores", industry_type: :industry, naics_code: "448150").first_or_create
    IndustryCode.where(name: "Other Clothing Stores", internal_name: "other_clothing_stores", industry_type: :industry, naics_code: "448190").first_or_create
    IndustryCode.where(name: "Shoe Stores", internal_name: "shoe_stores", industry_type: :industry, naics_code: "448210").first_or_create
    IndustryCode.where(name: "Jewelry Stores", internal_name: "jewelry_stores", industry_type: :industry, naics_code: "448310").first_or_create
    IndustryCode.where(name: "Luggage and Leather Goods Stores", internal_name: "luggage_and_leather_goods_stores", industry_type: :industry, naics_code: "448320").first_or_create
    IndustryCode.where(name: "Sporting Goods Stores", internal_name: "sporting_goods_stores", industry_type: :industry, naics_code: "451110").first_or_create
    IndustryCode.where(name: "Hobby, Toy, and Game Stores", internal_name: "hobby_toy_and_game_stores", industry_type: :industry, naics_code: "451120").first_or_create
    IndustryCode.where(name: "Sewing, Needlework, and Piece Goods Stores", internal_name: "sewing_needlework_and_piece_goods_stores", industry_type: :industry, naics_code: "451130").first_or_create
    IndustryCode.where(name: "Musical Instrument and Supplies Stores", internal_name: "musical_instrument_and_supplies_stores", industry_type: :industry, naics_code: "451140").first_or_create
    IndustryCode.where(name: "Book Stores", internal_name: "book_stores", industry_type: :industry, naics_code: "451211").first_or_create
    IndustryCode.where(name: "News Dealers and Newsstands", internal_name: "news_dealers_and_newsstands", industry_type: :industry, naics_code: "451212").first_or_create
    IndustryCode.where(name: "Department Stores (except Discount Department Stores)", internal_name: "department_stores_except_discount_department_stores", industry_type: :industry, naics_code: "452111").first_or_create
    IndustryCode.where(name: "Discount Department Stores", internal_name: "discount_department_stores", industry_type: :industry, naics_code: "452112").first_or_create
    IndustryCode.where(name: "Warehouse Clubs and Supercenters", internal_name: "warehouse_clubs_and_supercenters", industry_type: :industry, naics_code: "452910").first_or_create
    IndustryCode.where(name: "All Other General Merchandise Stores", internal_name: "all_other_general_merchandise_stores", industry_type: :industry, naics_code: "452990").first_or_create
    IndustryCode.where(name: "Florists", internal_name: "florists", industry_type: :industry, naics_code: "453110").first_or_create
    IndustryCode.where(name: "Office Supplies and Stationery Stores", internal_name: "office_supplies_and_stationery_stores", industry_type: :industry, naics_code: "453210").first_or_create
    IndustryCode.where(name: "Gift, Novelty, and Souvenir Stores", internal_name: "gift_novelty_and_souvenir_stores", industry_type: :industry, naics_code: "453220").first_or_create
    IndustryCode.where(name: "Used Merchandise Stores", internal_name: "used_merchandise_stores", industry_type: :industry, naics_code: "453310").first_or_create
    IndustryCode.where(name: "Pet and Pet Supplies Stores", internal_name: "pet_and_pet_supplies_stores", industry_type: :industry, naics_code: "453910").first_or_create
    IndustryCode.where(name: "Art Dealers", internal_name: "art_dealers", industry_type: :industry, naics_code: "453920").first_or_create
    IndustryCode.where(name: "Manufactured (Mobile) Home Dealers", internal_name: "manufactured_mobile_home_dealers", industry_type: :industry, naics_code: "453930").first_or_create
    IndustryCode.where(name: "Tobacco Stores", internal_name: "tobacco_stores", industry_type: :industry, naics_code: "453991").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Store Retailers (except Tobacco Stores)", internal_name: "all_other_miscellaneous_store_retailers_except_tobacco_stores", industry_type: :industry, naics_code: "453998").first_or_create
    IndustryCode.where(name: "Electronic Shopping", internal_name: "electronic_shopping", industry_type: :industry, naics_code: "454111").first_or_create
    IndustryCode.where(name: "Electronic Auctions", internal_name: "electronic_auctions", industry_type: :industry, naics_code: "454112").first_or_create
    IndustryCode.where(name: "Mail_Order Houses", internal_name: "mail_order_houses", industry_type: :industry, naics_code: "454113").first_or_create
    IndustryCode.where(name: "Vending Machine Operators", internal_name: "vending_machine_operators", industry_type: :industry, naics_code: "454210").first_or_create
    IndustryCode.where(name: "Fuel Dealers", internal_name: "fuel_dealers", industry_type: :industry, naics_code: "454310").first_or_create
    IndustryCode.where(name: "Other Direct Selling Establishments", internal_name: "other_direct_selling_establishments", industry_type: :industry, naics_code: "454390").first_or_create
    IndustryCode.where(name: "Scheduled Passenger Air Transportation", internal_name: "scheduled_passenger_air_transportation", industry_type: :industry, naics_code: "481111").first_or_create
    IndustryCode.where(name: "Scheduled Freight Air Transportation", internal_name: "scheduled_freight_air_transportation", industry_type: :industry, naics_code: "481112").first_or_create
    IndustryCode.where(name: "Nonscheduled Chartered Passenger Air Transportation", internal_name: "nonscheduled_chartered_passenger_air_transportation", industry_type: :industry, naics_code: "481211").first_or_create
    IndustryCode.where(name: "Nonscheduled Chartered Freight Air Transportation", internal_name: "nonscheduled_chartered_freight_air_transportation", industry_type: :industry, naics_code: "481212").first_or_create
    IndustryCode.where(name: "Other Nonscheduled Air Transportation", internal_name: "other_nonscheduled_air_transportation", industry_type: :industry, naics_code: "481219").first_or_create
    IndustryCode.where(name: "Line_Haul Railroads", internal_name: "line_haul_railroads", industry_type: :industry, naics_code: "482111").first_or_create
    IndustryCode.where(name: "Short Line Railroads", internal_name: "short_line_railroads", industry_type: :industry, naics_code: "482112").first_or_create
    IndustryCode.where(name: "Deep Sea Freight Transportation", internal_name: "deep_sea_freight_transportation", industry_type: :industry, naics_code: "483111").first_or_create
    IndustryCode.where(name: "Deep Sea Passenger Transportation", internal_name: "deep_sea_passenger_transportation", industry_type: :industry, naics_code: "483112").first_or_create
    IndustryCode.where(name: "Coastal and Great Lakes Freight Transportation", internal_name: "coastal_and_great_lakes_freight_transportation", industry_type: :industry, naics_code: "483113").first_or_create
    IndustryCode.where(name: "Coastal and Great Lakes Passenger Transportation", internal_name: "coastal_and_great_lakes_passenger_transportation", industry_type: :industry, naics_code: "483114").first_or_create
    IndustryCode.where(name: "Inland Water Freight Transportation", internal_name: "inland_water_freight_transportation", industry_type: :industry, naics_code: "483211").first_or_create
    IndustryCode.where(name: "Inland Water Passenger Transportation", internal_name: "inland_water_passenger_transportation", industry_type: :industry, naics_code: "483212").first_or_create
    IndustryCode.where(name: "General Freight Trucking, Local", internal_name: "general_freight_trucking_local", industry_type: :industry, naics_code: "484110").first_or_create
    IndustryCode.where(name: "General Freight Trucking, Long_Distance, Truckload", internal_name: "general_freight_trucking_long_distance_truckload", industry_type: :industry, naics_code: "484121").first_or_create
    IndustryCode.where(name: "General Freight Trucking, Long_Distance, Less Than Truckload", internal_name: "general_freight_trucking_long_distance_less_than_truckload", industry_type: :industry, naics_code: "484122").first_or_create
    IndustryCode.where(name: "Used Household and Office Goods Moving", internal_name: "used_household_and_office_goods_moving", industry_type: :industry, naics_code: "484210").first_or_create
    IndustryCode.where(name: "Specialized Freight (except Used Goods) Trucking, Local", internal_name: "specialized_freight_except_used_goods_trucking_local", industry_type: :industry, naics_code: "484220").first_or_create
    IndustryCode.where(name: "Specialized Freight (except Used Goods) Trucking, Long_Distance", internal_name: "specialized_freight_except_used_goods_trucking_long_distance", industry_type: :industry, naics_code: "484230").first_or_create
    IndustryCode.where(name: "Mixed Mode Transit Systems", internal_name: "mixed_mode_transit_systems", industry_type: :industry, naics_code: "485111").first_or_create
    IndustryCode.where(name: "Commuter Rail Systems", internal_name: "commuter_rail_systems", industry_type: :industry, naics_code: "485112").first_or_create
    IndustryCode.where(name: "Bus and Other Motor Vehicle Transit Systems", internal_name: "bus_and_other_motor_vehicle_transit_systems", industry_type: :industry, naics_code: "485113").first_or_create
    IndustryCode.where(name: "Other Urban Transit Systems", internal_name: "other_urban_transit_systems", industry_type: :industry, naics_code: "485119").first_or_create
    IndustryCode.where(name: "Interurban and Rural Bus Transportation", internal_name: "interurban_and_rural_bus_transportation", industry_type: :industry, naics_code: "485210").first_or_create
    IndustryCode.where(name: "Taxi Service", internal_name: "taxi_service", industry_type: :industry, naics_code: "485310").first_or_create
    IndustryCode.where(name: "Limousine Service", internal_name: "limousine_service", industry_type: :industry, naics_code: "485320").first_or_create
    IndustryCode.where(name: "School and Employee Bus Transportation", internal_name: "school_and_employee_bus_transportation", industry_type: :industry, naics_code: "485410").first_or_create
    IndustryCode.where(name: "Charter Bus Industry", internal_name: "charter_bus_industry", industry_type: :industry, naics_code: "485510").first_or_create
    IndustryCode.where(name: "Special Needs Transportation", internal_name: "special_needs_transportation", industry_type: :industry, naics_code: "485991").first_or_create
    IndustryCode.where(name: "All Other Transit and Ground Passenger Transportation", internal_name: "all_other_transit_and_ground_passenger_transportation", industry_type: :industry, naics_code: "485999").first_or_create
    IndustryCode.where(name: "Pipeline Transportation of Crude Oil", internal_name: "pipeline_transportation_of_crude_oil", industry_type: :industry, naics_code: "486110").first_or_create
    IndustryCode.where(name: "Pipeline Transportation of Natural Gas", internal_name: "pipeline_transportation_of_natural_gas", industry_type: :industry, naics_code: "486210").first_or_create
    IndustryCode.where(name: "Pipeline Transportation of Refined Petroleum Products", internal_name: "pipeline_transportation_of_refined_petroleum_products", industry_type: :industry, naics_code: "486910").first_or_create
    IndustryCode.where(name: "All Other Pipeline Transportation", internal_name: "all_other_pipeline_transportation", industry_type: :industry, naics_code: "486990").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation, Land", internal_name: "scenic_and_sightseeing_transportation_land", industry_type: :industry, naics_code: "487110").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation, Water", internal_name: "scenic_and_sightseeing_transportation_water", industry_type: :industry, naics_code: "487210").first_or_create
    IndustryCode.where(name: "Scenic and Sightseeing Transportation, Other", internal_name: "scenic_and_sightseeing_transportation_other", industry_type: :industry, naics_code: "487990").first_or_create
    IndustryCode.where(name: "Air Traffic Control", internal_name: "air_traffic_control", industry_type: :industry, naics_code: "488111").first_or_create
    IndustryCode.where(name: "Other Airport Operations", internal_name: "other_airport_operations", industry_type: :industry, naics_code: "488119").first_or_create
    IndustryCode.where(name: "Other Support Activities for Air Transportation", internal_name: "other_support_activities_for_air_transportation", industry_type: :industry, naics_code: "488190").first_or_create
    IndustryCode.where(name: "Support Activities for Rail Transportation", internal_name: "support_activities_for_rail_transportation", industry_type: :industry, naics_code: "488210").first_or_create
    IndustryCode.where(name: "Port and Harbor Operations", internal_name: "port_and_harbor_operations", industry_type: :industry, naics_code: "488310").first_or_create
    IndustryCode.where(name: "Marine Cargo Handling", internal_name: "marine_cargo_handling", industry_type: :industry, naics_code: "488320").first_or_create
    IndustryCode.where(name: "Navigational Services to Shipping", internal_name: "navigational_services_to_shipping", industry_type: :industry, naics_code: "488330").first_or_create
    IndustryCode.where(name: "Other Support Activities for Water Transportation", internal_name: "other_support_activities_for_water_transportation", industry_type: :industry, naics_code: "488390").first_or_create
    IndustryCode.where(name: "Motor Vehicle Towing", internal_name: "motor_vehicle_towing", industry_type: :industry, naics_code: "488410").first_or_create
    IndustryCode.where(name: "Other Support Activities for Road Transportation", internal_name: "other_support_activities_for_road_transportation", industry_type: :industry, naics_code: "488490").first_or_create
    IndustryCode.where(name: "Freight Transportation Arrangement", internal_name: "freight_transportation_arrangement", industry_type: :industry, naics_code: "488510").first_or_create
    IndustryCode.where(name: "Packing and Crating", internal_name: "packing_and_crating", industry_type: :industry, naics_code: "488991").first_or_create
    IndustryCode.where(name: "All Other Support Activities for Transportation", internal_name: "all_other_support_activities_for_transportation", industry_type: :industry, naics_code: "488999").first_or_create
    IndustryCode.where(name: "Postal Service", internal_name: "postal_service", industry_type: :industry, naics_code: "491110").first_or_create
    IndustryCode.where(name: "Couriers and Express Delivery Services", internal_name: "couriers_and_express_delivery_services", industry_type: :industry, naics_code: "492110").first_or_create
    IndustryCode.where(name: "Local Messengers and Local Delivery", internal_name: "local_messengers_and_local_delivery", industry_type: :industry, naics_code: "492210").first_or_create
    IndustryCode.where(name: "General Warehousing and Storage", internal_name: "general_warehousing_and_storage", industry_type: :industry, naics_code: "493110").first_or_create
    IndustryCode.where(name: "Refrigerated Warehousing and Storage", internal_name: "refrigerated_warehousing_and_storage", industry_type: :industry, naics_code: "493120").first_or_create
    IndustryCode.where(name: "Farm Product Warehousing and Storage", internal_name: "farm_product_warehousing_and_storage", industry_type: :industry, naics_code: "493130").first_or_create
    IndustryCode.where(name: "Other Warehousing and Storage", internal_name: "other_warehousing_and_storage", industry_type: :industry, naics_code: "493190").first_or_create
    IndustryCode.where(name: "Newspaper Publishers", internal_name: "newspaper_publishers", industry_type: :industry, naics_code: "511110").first_or_create
    IndustryCode.where(name: "Periodical Publishers", internal_name: "periodical_publishers", industry_type: :industry, naics_code: "511120").first_or_create
    IndustryCode.where(name: "Book Publishers", internal_name: "book_publishers", industry_type: :industry, naics_code: "511130").first_or_create
    IndustryCode.where(name: "Directory and Mailing List Publishers", internal_name: "directory_and_mailing_list_publishers", industry_type: :industry, naics_code: "511140").first_or_create
    IndustryCode.where(name: "Greeting Card Publishers", internal_name: "greeting_card_publishers", industry_type: :industry, naics_code: "511191").first_or_create
    IndustryCode.where(name: "All Other Publishers", internal_name: "all_other_publishers", industry_type: :industry, naics_code: "511199").first_or_create
    IndustryCode.where(name: "Software Publishers", internal_name: "software_publishers", industry_type: :industry, naics_code: "511210").first_or_create
    IndustryCode.where(name: "Motion Picture and Video Production", internal_name: "motion_picture_and_video_production", industry_type: :industry, naics_code: "512110").first_or_create
    IndustryCode.where(name: "Motion Picture and Video Distribution", internal_name: "motion_picture_and_video_distribution", industry_type: :industry, naics_code: "512120").first_or_create
    IndustryCode.where(name: "Motion Picture Theaters (except Drive_Ins)", internal_name: "motion_picture_theaters_except_drive_ins", industry_type: :industry, naics_code: "512131").first_or_create
    IndustryCode.where(name: "Drive_In Motion Picture Theaters", internal_name: "drive_in_motion_picture_theaters", industry_type: :industry, naics_code: "512132").first_or_create
    IndustryCode.where(name: "Teleproduction and Other Postproduction Services", internal_name: "teleproduction_and_other_postproduction_services", industry_type: :industry, naics_code: "512191").first_or_create
    IndustryCode.where(name: "Other Motion Picture and Video Industries", internal_name: "other_motion_picture_and_video_industries", industry_type: :industry, naics_code: "512199").first_or_create
    IndustryCode.where(name: "Record Production", internal_name: "record_production", industry_type: :industry, naics_code: "512210").first_or_create
    IndustryCode.where(name: "Integrated Record Production/Distribution", internal_name: "integrated_record_production/distribution", industry_type: :industry, naics_code: "512220").first_or_create
    IndustryCode.where(name: "Music Publishers", internal_name: "music_publishers", industry_type: :industry, naics_code: "512230").first_or_create
    IndustryCode.where(name: "Sound Recording Studios", internal_name: "sound_recording_studios", industry_type: :industry, naics_code: "512240").first_or_create
    IndustryCode.where(name: "Other Sound Recording Industries", internal_name: "other_sound_recording_industries", industry_type: :industry, naics_code: "512290").first_or_create
    IndustryCode.where(name: "Radio Networks", internal_name: "radio_networks", industry_type: :industry, naics_code: "515111").first_or_create
    IndustryCode.where(name: "Radio Stations", internal_name: "radio_stations", industry_type: :industry, naics_code: "515112").first_or_create
    IndustryCode.where(name: "Television Broadcasting", internal_name: "television_broadcasting", industry_type: :industry, naics_code: "515120").first_or_create
    IndustryCode.where(name: "Cable and Other Subscription Programming", internal_name: "cable_and_other_subscription_programming", industry_type: :industry, naics_code: "515210").first_or_create
    IndustryCode.where(name: "Wired Telecommunications Carriers", internal_name: "wired_telecommunications_carriers", industry_type: :industry, naics_code: "517110").first_or_create
    IndustryCode.where(name: "Wireless Telecommunications Carriers (except Satellite)", internal_name: "wireless_telecommunications_carriers_except_satellite", industry_type: :industry, naics_code: "517210").first_or_create
    IndustryCode.where(name: "Satellite Telecommunications", internal_name: "satellite_telecommunications", industry_type: :industry, naics_code: "517410").first_or_create
    IndustryCode.where(name: "Telecommunications Resellers", internal_name: "telecommunications_resellers", industry_type: :industry, naics_code: "517911").first_or_create
    IndustryCode.where(name: "All Other Telecommunications", internal_name: "all_other_telecommunications", industry_type: :industry, naics_code: "517919").first_or_create
    IndustryCode.where(name: "Data Processing, Hosting, and Related Services", internal_name: "data_processing_hosting_and_related_services", industry_type: :industry, naics_code: "518210").first_or_create
    IndustryCode.where(name: "News Syndicates", internal_name: "news_syndicates", industry_type: :industry, naics_code: "519110").first_or_create
    IndustryCode.where(name: "Libraries and Archives", internal_name: "libraries_and_archives", industry_type: :industry, naics_code: "519120").first_or_create
    IndustryCode.where(name: "Internet Publishing and Broadcasting and Web Search Portals", internal_name: "internet_publishing_and_broadcasting_and_web_search_portals", industry_type: :industry, naics_code: "519130").first_or_create
    IndustryCode.where(name: "All Other Information Services", internal_name: "all_other_information_services", industry_type: :industry, naics_code: "519190").first_or_create
    IndustryCode.where(name: "Monetary Authorities_Central Bank", internal_name: "monetary_authorities_central_bank", industry_type: :industry, naics_code: "521110").first_or_create
    IndustryCode.where(name: "Commercial Banking", internal_name: "commercial_banking", industry_type: :industry, naics_code: "522110").first_or_create
    IndustryCode.where(name: "Savings Institutions", internal_name: "savings_institutions", industry_type: :industry, naics_code: "522120").first_or_create
    IndustryCode.where(name: "Credit Unions", internal_name: "credit_unions", industry_type: :industry, naics_code: "522130").first_or_create
    IndustryCode.where(name: "Other Depository Credit Intermediation", internal_name: "other_depository_credit_intermediation", industry_type: :industry, naics_code: "522190").first_or_create
    IndustryCode.where(name: "Credit Card Issuing", internal_name: "credit_card_issuing", industry_type: :industry, naics_code: "522210").first_or_create
    IndustryCode.where(name: "Sales Financing", internal_name: "sales_financing", industry_type: :industry, naics_code: "522220").first_or_create
    IndustryCode.where(name: "Consumer Lending", internal_name: "consumer_lending", industry_type: :industry, naics_code: "522291").first_or_create
    IndustryCode.where(name: "Real Estate Credit", internal_name: "real_estate_credit", industry_type: :industry, naics_code: "522292").first_or_create
    IndustryCode.where(name: "International Trade Financing", internal_name: "international_trade_financing", industry_type: :industry, naics_code: "522293").first_or_create
    IndustryCode.where(name: "Secondary Market Financing", internal_name: "secondary_market_financing", industry_type: :industry, naics_code: "522294").first_or_create
    IndustryCode.where(name: "All Other Nondepository Credit Intermediation", internal_name: "all_other_nondepository_credit_intermediation", industry_type: :industry, naics_code: "522298").first_or_create
    IndustryCode.where(name: "Mortgage and Nonmortgage Loan Brokers", internal_name: "mortgage_and_nonmortgage_loan_brokers", industry_type: :industry, naics_code: "522310").first_or_create
    IndustryCode.where(name: "Financial Transactions Processing, Reserve, and Clearinghouse Activities", internal_name: "financial_transactions_processing_reserve_and_clearinghouse_activities", industry_type: :industry, naics_code: "522320").first_or_create
    IndustryCode.where(name: "Other Activities Related to Credit Intermediation", internal_name: "other_activities_related_to_credit_intermediation", industry_type: :industry, naics_code: "522390").first_or_create
    IndustryCode.where(name: "Investment Banking and Securities Dealing", internal_name: "investment_banking_and_securities_dealing", industry_type: :industry, naics_code: "523110").first_or_create
    IndustryCode.where(name: "Securities Brokerage", internal_name: "securities_brokerage", industry_type: :industry, naics_code: "523120").first_or_create
    IndustryCode.where(name: "Commodity Contracts Dealing", internal_name: "commodity_contracts_dealing", industry_type: :industry, naics_code: "523130").first_or_create
    IndustryCode.where(name: "Commodity Contracts Brokerage", internal_name: "commodity_contracts_brokerage", industry_type: :industry, naics_code: "523140").first_or_create
    IndustryCode.where(name: "Securities and Commodity Exchanges", internal_name: "securities_and_commodity_exchanges", industry_type: :industry, naics_code: "523210").first_or_create
    IndustryCode.where(name: "Miscellaneous Intermediation", internal_name: "miscellaneous_intermediation", industry_type: :industry, naics_code: "523910").first_or_create
    IndustryCode.where(name: "Portfolio Management", internal_name: "portfolio_management", industry_type: :industry, naics_code: "523920").first_or_create
    IndustryCode.where(name: "Investment Advice", internal_name: "investment_advice", industry_type: :industry, naics_code: "523930").first_or_create
    IndustryCode.where(name: "Trust, Fiduciary, and Custody Activities", internal_name: "trust_fiduciary_and_custody_activities", industry_type: :industry, naics_code: "523991").first_or_create
    IndustryCode.where(name: "Miscellaneous Financial Investment Activities", internal_name: "miscellaneous_financial_investment_activities", industry_type: :industry, naics_code: "523999").first_or_create
    IndustryCode.where(name: "Direct Life Insurance Carriers", internal_name: "direct_life_insurance_carriers", industry_type: :industry, naics_code: "524113").first_or_create
    IndustryCode.where(name: "Direct Health and Medical Insurance Carriers", internal_name: "direct_health_and_medical_insurance_carriers", industry_type: :industry, naics_code: "524114").first_or_create
    IndustryCode.where(name: "Direct Property and Casualty Insurance Carriers", internal_name: "direct_property_and_casualty_insurance_carriers", industry_type: :industry, naics_code: "524126").first_or_create
    IndustryCode.where(name: "Direct Title Insurance Carriers", internal_name: "direct_title_insurance_carriers", industry_type: :industry, naics_code: "524127").first_or_create
    IndustryCode.where(name: "Other Direct Insurance (except Life, Health, and Medical) Carriers", internal_name: "other_direct_insurance_except_life_health_and_medical_carriers", industry_type: :industry, naics_code: "524128").first_or_create
    IndustryCode.where(name: "Reinsurance Carriers", internal_name: "reinsurance_carriers", industry_type: :industry, naics_code: "524130").first_or_create
    IndustryCode.where(name: "Insurance Agencies and Brokerages", internal_name: "insurance_agencies_and_brokerages", industry_type: :industry, naics_code: "524210").first_or_create
    IndustryCode.where(name: "Claims Adjusting", internal_name: "claims_adjusting", industry_type: :industry, naics_code: "524291").first_or_create
    IndustryCode.where(name: "Third Party Administration of Insurance and Pension Funds", internal_name: "third_party_administration_of_insurance_and_pension_funds", industry_type: :industry, naics_code: "524292").first_or_create
    IndustryCode.where(name: "All Other Insurance Related Activities", internal_name: "all_other_insurance_related_activities", industry_type: :industry, naics_code: "524298").first_or_create
    IndustryCode.where(name: "Pension Funds", internal_name: "pension_funds", industry_type: :industry, naics_code: "525110").first_or_create
    IndustryCode.where(name: "Health and Welfare Funds", internal_name: "health_and_welfare_funds", industry_type: :industry, naics_code: "525120").first_or_create
    IndustryCode.where(name: "Other Insurance Funds", internal_name: "other_insurance_funds", industry_type: :industry, naics_code: "525190").first_or_create
    IndustryCode.where(name: "Open_End Investment Funds", internal_name: "open_end_investment_funds", industry_type: :industry, naics_code: "525910").first_or_create
    IndustryCode.where(name: "Trusts, Estates, and Agency Accounts", internal_name: "trusts_estates_and_agency_accounts", industry_type: :industry, naics_code: "525920").first_or_create
    IndustryCode.where(name: "Other Financial Vehicles", internal_name: "other_financial_vehicles", industry_type: :industry, naics_code: "525990").first_or_create
    IndustryCode.where(name: "Lessors of Residential Buildings and Dwellings", internal_name: "lessors_of_residential_buildings_and_dwellings", industry_type: :industry, naics_code: "531110").first_or_create
    IndustryCode.where(name: "Lessors of Nonresidential Buildings (except Miniwarehouses)", internal_name: "lessors_of_nonresidential_buildings_except_miniwarehouses", industry_type: :industry, naics_code: "531120").first_or_create
    IndustryCode.where(name: "Lessors of Miniwarehouses and Self_Storage Units", internal_name: "lessors_of_miniwarehouses_and_self_storage_units", industry_type: :industry, naics_code: "531130").first_or_create
    IndustryCode.where(name: "Lessors of Other Real Estate Property", internal_name: "lessors_of_other_real_estate_property", industry_type: :industry, naics_code: "531190").first_or_create
    IndustryCode.where(name: "Offices of Real Estate Agents and Brokers", internal_name: "offices_of_real_estate_agents_and_brokers", industry_type: :industry, naics_code: "531210").first_or_create
    IndustryCode.where(name: "Residential Property Managers", internal_name: "residential_property_managers", industry_type: :industry, naics_code: "531311").first_or_create
    IndustryCode.where(name: "Nonresidential Property Managers", internal_name: "nonresidential_property_managers", industry_type: :industry, naics_code: "531312").first_or_create
    IndustryCode.where(name: "Offices of Real Estate Appraisers", internal_name: "offices_of_real_estate_appraisers", industry_type: :industry, naics_code: "531320").first_or_create
    IndustryCode.where(name: "Other Activities Related to Real Estate", internal_name: "other_activities_related_to_real_estate", industry_type: :industry, naics_code: "531390").first_or_create
    IndustryCode.where(name: "Passenger Car Rental", internal_name: "passenger_car_rental", industry_type: :industry, naics_code: "532111").first_or_create
    IndustryCode.where(name: "Passenger Car Leasing", internal_name: "passenger_car_leasing", industry_type: :industry, naics_code: "532112").first_or_create
    IndustryCode.where(name: "Truck, Utility Trailer, and RV (Recreational Vehicle) Rental and Leasing", internal_name: "truck_utility_trailer_and_rv_recreational_vehicle_rental_and_leasing", industry_type: :industry, naics_code: "532120").first_or_create
    IndustryCode.where(name: "Consumer Electronics and Appliances Rental", internal_name: "consumer_electronics_and_appliances_rental", industry_type: :industry, naics_code: "532210").first_or_create
    IndustryCode.where(name: "Formal Wear and Costume Rental", internal_name: "formal_wear_and_costume_rental", industry_type: :industry, naics_code: "532220").first_or_create
    IndustryCode.where(name: "Video Tape and Disc Rental", internal_name: "video_tape_and_disc_rental", industry_type: :industry, naics_code: "532230").first_or_create
    IndustryCode.where(name: "Home Health Equipment Rental", internal_name: "home_health_equipment_rental", industry_type: :industry, naics_code: "532291").first_or_create
    IndustryCode.where(name: "Recreational Goods Rental", internal_name: "recreational_goods_rental", industry_type: :industry, naics_code: "532292").first_or_create
    IndustryCode.where(name: "All Other Consumer Goods Rental", internal_name: "all_other_consumer_goods_rental", industry_type: :industry, naics_code: "532299").first_or_create
    IndustryCode.where(name: "General Rental Centers", internal_name: "general_rental_centers", industry_type: :industry, naics_code: "532310").first_or_create
    IndustryCode.where(name: "Commercial Air, Rail, and Water Transportation Equipment Rental and Leasing", internal_name: "commercial_air_rail_and_water_transportation_equipment_rental_and_leasing", industry_type: :industry, naics_code: "532411").first_or_create
    IndustryCode.where(name: "Construction, Mining, and Forestry Machinery and Equipment Rental and Leasing", internal_name: "construction_mining_and_forestry_machinery_and_equipment_rental_and_leasing", industry_type: :industry, naics_code: "532412").first_or_create
    IndustryCode.where(name: "Office Machinery and Equipment Rental and Leasing", internal_name: "office_machinery_and_equipment_rental_and_leasing", industry_type: :industry, naics_code: "532420").first_or_create
    IndustryCode.where(name: "Other Commercial and Industrial Machinery and Equipment Rental and Leasing", internal_name: "other_commercial_and_industrial_machinery_and_equipment_rental_and_leasing", industry_type: :industry, naics_code: "532490").first_or_create
    IndustryCode.where(name: "Lessors of Nonfinancial Intangible Assets (except Copyrighted Works)", internal_name: "lessors_of_nonfinancial_intangible_assets_except_copyrighted_works", industry_type: :industry, naics_code: "533110").first_or_create
    IndustryCode.where(name: "Offices of Lawyers", internal_name: "offices_of_lawyers", industry_type: :industry, naics_code: "541110").first_or_create
    IndustryCode.where(name: "Offices of Notaries", internal_name: "offices_of_notaries", industry_type: :industry, naics_code: "541120").first_or_create
    IndustryCode.where(name: "Title Abstract and Settlement Offices", internal_name: "title_abstract_and_settlement_offices", industry_type: :industry, naics_code: "541191").first_or_create
    IndustryCode.where(name: "All Other Legal Services", internal_name: "all_other_legal_services", industry_type: :industry, naics_code: "541199").first_or_create
    IndustryCode.where(name: "Offices of Certified Public Accountants", internal_name: "offices_of_certified_public_accountants", industry_type: :industry, naics_code: "541211").first_or_create
    IndustryCode.where(name: "Tax Preparation Services", internal_name: "tax_preparation_services", industry_type: :industry, naics_code: "541213").first_or_create
    IndustryCode.where(name: "Payroll Services", internal_name: "payroll_services", industry_type: :industry, naics_code: "541214").first_or_create
    IndustryCode.where(name: "Other Accounting Services", internal_name: "other_accounting_services", industry_type: :industry, naics_code: "541219").first_or_create
    IndustryCode.where(name: "Architectural Services", internal_name: "architectural_services", industry_type: :industry, naics_code: "541310").first_or_create
    IndustryCode.where(name: "Landscape Architectural Services", internal_name: "landscape_architectural_services", industry_type: :industry, naics_code: "541320").first_or_create
    IndustryCode.where(name: "Engineering Services", internal_name: "engineering_services", industry_type: :industry, naics_code: "541330").first_or_create
    IndustryCode.where(name: "Drafting Services", internal_name: "drafting_services", industry_type: :industry, naics_code: "541340").first_or_create
    IndustryCode.where(name: "Building Inspection Services", internal_name: "building_inspection_services", industry_type: :industry, naics_code: "541350").first_or_create
    IndustryCode.where(name: "Geophysical Surveying and Mapping Services", internal_name: "geophysical_surveying_and_mapping_services", industry_type: :industry, naics_code: "541360").first_or_create
    IndustryCode.where(name: "Surveying and Mapping (except Geophysical) Services", internal_name: "surveying_and_mapping_except_geophysical_services", industry_type: :industry, naics_code: "541370").first_or_create
    IndustryCode.where(name: "Testing Laboratories", internal_name: "testing_laboratories", industry_type: :industry, naics_code: "541380").first_or_create
    IndustryCode.where(name: "Interior Design Services", internal_name: "interior_design_services", industry_type: :industry, naics_code: "541410").first_or_create
    IndustryCode.where(name: "Industrial Design Services", internal_name: "industrial_design_services", industry_type: :industry, naics_code: "541420").first_or_create
    IndustryCode.where(name: "Graphic Design Services", internal_name: "graphic_design_services", industry_type: :industry, naics_code: "541430").first_or_create
    IndustryCode.where(name: "Other Specialized Design Services", internal_name: "other_specialized_design_services", industry_type: :industry, naics_code: "541490").first_or_create
    IndustryCode.where(name: "Custom Computer Programming Services", internal_name: "custom_computer_programming_services", industry_type: :industry, naics_code: "541511").first_or_create
    IndustryCode.where(name: "Computer Systems Design Services", internal_name: "computer_systems_design_services", industry_type: :industry, naics_code: "541512").first_or_create
    IndustryCode.where(name: "Computer Facilities Management Services", internal_name: "computer_facilities_management_services", industry_type: :industry, naics_code: "541513").first_or_create
    IndustryCode.where(name: "Other Computer Related Services", internal_name: "other_computer_related_services", industry_type: :industry, naics_code: "541519").first_or_create
    IndustryCode.where(name: "Administrative Management and General Management Consulting Services", internal_name: "administrative_management_and_general_management_consulting_services", industry_type: :industry, naics_code: "541611").first_or_create
    IndustryCode.where(name: "Human Resources Consulting Services", internal_name: "human_resources_consulting_services", industry_type: :industry, naics_code: "541612").first_or_create
    IndustryCode.where(name: "Marketing Consulting Services", internal_name: "marketing_consulting_services", industry_type: :industry, naics_code: "541613").first_or_create
    IndustryCode.where(name: "Process, Physical Distribution, and Logistics Consulting Services", internal_name: "process_physical_distribution_and_logistics_consulting_services", industry_type: :industry, naics_code: "541614").first_or_create
    IndustryCode.where(name: "Other Management Consulting Services", internal_name: "other_management_consulting_services", industry_type: :industry, naics_code: "541618").first_or_create
    IndustryCode.where(name: "Environmental Consulting Services", internal_name: "environmental_consulting_services", industry_type: :industry, naics_code: "541620").first_or_create
    IndustryCode.where(name: "Other Scientific and Technical Consulting Services", internal_name: "other_scientific_and_technical_consulting_services", industry_type: :industry, naics_code: "541690").first_or_create
    IndustryCode.where(name: "Research and Development in Biotechnology", internal_name: "research_and_development_in_biotechnology", industry_type: :industry, naics_code: "541711").first_or_create
    IndustryCode.where(name: "Research and Development in the Physical, Engineering, and Life Sciences (except Biotechnology)", internal_name: "research_and_development_in_the_physical_engineering_and_life_sciences_except_biotechnology", industry_type: :industry, naics_code: "541712").first_or_create
    IndustryCode.where(name: "Research and Development in the Social Sciences and Humanities", internal_name: "research_and_development_in_the_social_sciences_and_humanities", industry_type: :industry, naics_code: "541720").first_or_create
    IndustryCode.where(name: "Advertising Agencies", internal_name: "advertising_agencies", industry_type: :industry, naics_code: "541810").first_or_create
    IndustryCode.where(name: "Public Relations Agencies", internal_name: "public_relations_agencies", industry_type: :industry, naics_code: "541820").first_or_create
    IndustryCode.where(name: "Media Buying Agencies", internal_name: "media_buying_agencies", industry_type: :industry, naics_code: "541830").first_or_create
    IndustryCode.where(name: "Media Representatives", internal_name: "media_representatives", industry_type: :industry, naics_code: "541840").first_or_create
    IndustryCode.where(name: "Outdoor Advertising", internal_name: "outdoor_advertising", industry_type: :industry, naics_code: "541850").first_or_create
    IndustryCode.where(name: "Direct Mail Advertising", internal_name: "direct_mail_advertising", industry_type: :industry, naics_code: "541860").first_or_create
    IndustryCode.where(name: "Advertising Material Distribution Services", internal_name: "advertising_material_distribution_services", industry_type: :industry, naics_code: "541870").first_or_create
    IndustryCode.where(name: "Other Services Related to Advertising", internal_name: "other_services_related_to_advertising", industry_type: :industry, naics_code: "541890").first_or_create
    IndustryCode.where(name: "Marketing Research and Public Opinion Polling", internal_name: "marketing_research_and_public_opinion_polling", industry_type: :industry, naics_code: "541910").first_or_create
    IndustryCode.where(name: "Photography Studios, Portrait", internal_name: "photography_studios_portrait", industry_type: :industry, naics_code: "541921").first_or_create
    IndustryCode.where(name: "Commercial Photography", internal_name: "commercial_photography", industry_type: :industry, naics_code: "541922").first_or_create
    IndustryCode.where(name: "Translation and Interpretation Services", internal_name: "translation_and_interpretation_services", industry_type: :industry, naics_code: "541930").first_or_create
    IndustryCode.where(name: "Veterinary Services", internal_name: "veterinary_services", industry_type: :industry, naics_code: "541940").first_or_create
    IndustryCode.where(name: "All Other Professional, Scientific, and Technical Services", internal_name: "all_other_professional_scientific_and_technical_services", industry_type: :industry, naics_code: "541990").first_or_create
    IndustryCode.where(name: "Offices of Bank Holding Companies", internal_name: "offices_of_bank_holding_companies", industry_type: :industry, naics_code: "551111").first_or_create
    IndustryCode.where(name: "Offices of Other Holding Companies", internal_name: "offices_of_other_holding_companies", industry_type: :industry, naics_code: "551112").first_or_create
    IndustryCode.where(name: "Corporate, Subsidiary, and Regional Managing Offices", internal_name: "corporate_subsidiary_and_regional_managing_offices", industry_type: :industry, naics_code: "551114").first_or_create
    IndustryCode.where(name: "Office Administrative Services", internal_name: "office_administrative_services", industry_type: :industry, naics_code: "561110").first_or_create
    IndustryCode.where(name: "Facilities Support Services", internal_name: "facilities_support_services", industry_type: :industry, naics_code: "561210").first_or_create
    IndustryCode.where(name: "Employment Placement Agencies", internal_name: "employment_placement_agencies", industry_type: :industry, naics_code: "561311").first_or_create
    IndustryCode.where(name: "Executive Search Services", internal_name: "executive_search_services", industry_type: :industry, naics_code: "561312").first_or_create
    IndustryCode.where(name: "Temporary Help Services", internal_name: "temporary_help_services", industry_type: :industry, naics_code: "561320").first_or_create
    IndustryCode.where(name: "Professional Employer Organizations", internal_name: "professional_employer_organizations", industry_type: :industry, naics_code: "561330").first_or_create
    IndustryCode.where(name: "Document Preparation Services", internal_name: "document_preparation_services", industry_type: :industry, naics_code: "561410").first_or_create
    IndustryCode.where(name: "Telephone Answering Services", internal_name: "telephone_answering_services", industry_type: :industry, naics_code: "561421").first_or_create
    IndustryCode.where(name: "Telemarketing Bureaus and Other Contact Centers", internal_name: "telemarketing_bureaus_and_other_contact_centers", industry_type: :industry, naics_code: "561422").first_or_create
    IndustryCode.where(name: "Private Mail Centers", internal_name: "private_mail_centers", industry_type: :industry, naics_code: "561431").first_or_create
    IndustryCode.where(name: "Other Business Service Centers (including Copy Shops)", internal_name: "other_business_service_centers_including_copy_shops", industry_type: :industry, naics_code: "561439").first_or_create
    IndustryCode.where(name: "Collection Agencies", internal_name: "collection_agencies", industry_type: :industry, naics_code: "561440").first_or_create
    IndustryCode.where(name: "Credit Bureaus", internal_name: "credit_bureaus", industry_type: :industry, naics_code: "561450").first_or_create
    IndustryCode.where(name: "Repossession Services", internal_name: "repossession_services", industry_type: :industry, naics_code: "561491").first_or_create
    IndustryCode.where(name: "Court Reporting and Stenotype Services", internal_name: "court_reporting_and_stenotype_services", industry_type: :industry, naics_code: "561492").first_or_create
    IndustryCode.where(name: "All Other Business Support Services", internal_name: "all_other_business_support_services", industry_type: :industry, naics_code: "561499").first_or_create
    IndustryCode.where(name: "Travel Agencies", internal_name: "travel_agencies", industry_type: :industry, naics_code: "561510").first_or_create
    IndustryCode.where(name: "Tour Operators", internal_name: "tour_operators", industry_type: :industry, naics_code: "561520").first_or_create
    IndustryCode.where(name: "Convention and Visitors Bureaus", internal_name: "convention_and_visitors_bureaus", industry_type: :industry, naics_code: "561591").first_or_create
    IndustryCode.where(name: "All Other Travel Arrangement and Reservation Services", internal_name: "all_other_travel_arrangement_and_reservation_services", industry_type: :industry, naics_code: "561599").first_or_create
    IndustryCode.where(name: "Investigation Services", internal_name: "investigation_services", industry_type: :industry, naics_code: "561611").first_or_create
    IndustryCode.where(name: "Security Guards and Patrol Services", internal_name: "security_guards_and_patrol_services", industry_type: :industry, naics_code: "561612").first_or_create
    IndustryCode.where(name: "Armored Car Services", internal_name: "armored_car_services", industry_type: :industry, naics_code: "561613").first_or_create
    IndustryCode.where(name: "Security Systems Services (except Locksmiths)", internal_name: "security_systems_services_except_locksmiths", industry_type: :industry, naics_code: "561621").first_or_create
    IndustryCode.where(name: "Locksmiths", internal_name: "locksmiths", industry_type: :industry, naics_code: "561622").first_or_create
    IndustryCode.where(name: "Exterminating and Pest Control Services", internal_name: "exterminating_and_pest_control_services", industry_type: :industry, naics_code: "561710").first_or_create
    IndustryCode.where(name: "Janitorial Services", internal_name: "janitorial_services", industry_type: :industry, naics_code: "561720").first_or_create
    IndustryCode.where(name: "Landscaping Services", internal_name: "landscaping_services", industry_type: :industry, naics_code: "561730").first_or_create
    IndustryCode.where(name: "Carpet and Upholstery Cleaning Services", internal_name: "carpet_and_upholstery_cleaning_services", industry_type: :industry, naics_code: "561740").first_or_create
    IndustryCode.where(name: "Other Services to Buildings and Dwellings", internal_name: "other_services_to_buildings_and_dwellings", industry_type: :industry, naics_code: "561790").first_or_create
    IndustryCode.where(name: "Packaging and Labeling Services", internal_name: "packaging_and_labeling_services", industry_type: :industry, naics_code: "561910").first_or_create
    IndustryCode.where(name: "Convention and Trade Show Organizers", internal_name: "convention_and_trade_show_organizers", industry_type: :industry, naics_code: "561920").first_or_create
    IndustryCode.where(name: "All Other Support Services", internal_name: "all_other_support_services", industry_type: :industry, naics_code: "561990").first_or_create
    IndustryCode.where(name: "Solid Waste Collection", internal_name: "solid_waste_collection", industry_type: :industry, naics_code: "562111").first_or_create
    IndustryCode.where(name: "Hazardous Waste Collection", internal_name: "hazardous_waste_collection", industry_type: :industry, naics_code: "562112").first_or_create
    IndustryCode.where(name: "Other Waste Collection", internal_name: "other_waste_collection", industry_type: :industry, naics_code: "562119").first_or_create
    IndustryCode.where(name: "Hazardous Waste Treatment and Disposal", internal_name: "hazardous_waste_treatment_and_disposal", industry_type: :industry, naics_code: "562211").first_or_create
    IndustryCode.where(name: "Solid Waste Landfill", internal_name: "solid_waste_landfill", industry_type: :industry, naics_code: "562212").first_or_create
    IndustryCode.where(name: "Solid Waste Combustors and Incinerators", internal_name: "solid_waste_combustors_and_incinerators", industry_type: :industry, naics_code: "562213").first_or_create
    IndustryCode.where(name: "Other Nonhazardous Waste Treatment and Disposal", internal_name: "other_nonhazardous_waste_treatment_and_disposal", industry_type: :industry, naics_code: "562219").first_or_create
    IndustryCode.where(name: "Remediation Services", internal_name: "remediation_services", industry_type: :industry, naics_code: "562910").first_or_create
    IndustryCode.where(name: "Materials Recovery Facilities", internal_name: "materials_recovery_facilities", industry_type: :industry, naics_code: "562920").first_or_create
    IndustryCode.where(name: "Septic Tank and Related Services", internal_name: "septic_tank_and_related_services", industry_type: :industry, naics_code: "562991").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Waste Management Services", internal_name: "all_other_miscellaneous_waste_management_services", industry_type: :industry, naics_code: "562998").first_or_create
    IndustryCode.where(name: "Elementary and Secondary Schools", internal_name: "elementary_and_secondary_schools", industry_type: :industry, naics_code: "611110").first_or_create
    IndustryCode.where(name: "Junior Colleges", internal_name: "junior_colleges", industry_type: :industry, naics_code: "611210").first_or_create
    IndustryCode.where(name: "Colleges, Universities, and Professional Schools", internal_name: "colleges_universities_and_professional_schools", industry_type: :industry, naics_code: "611310").first_or_create
    IndustryCode.where(name: "Business and Secretarial Schools", internal_name: "business_and_secretarial_schools", industry_type: :industry, naics_code: "611410").first_or_create
    IndustryCode.where(name: "Computer Training", internal_name: "computer_training", industry_type: :industry, naics_code: "611420").first_or_create
    IndustryCode.where(name: "Professional and Management Development Training", internal_name: "professional_and_management_development_training", industry_type: :industry, naics_code: "611430").first_or_create
    IndustryCode.where(name: "Cosmetology and Barber Schools", internal_name: "cosmetology_and_barber_schools", industry_type: :industry, naics_code: "611511").first_or_create
    IndustryCode.where(name: "Flight Training", internal_name: "flight_training", industry_type: :industry, naics_code: "611512").first_or_create
    IndustryCode.where(name: "Apprenticeship Training", internal_name: "apprenticeship_training", industry_type: :industry, naics_code: "611513").first_or_create
    IndustryCode.where(name: "Other Technical and Trade Schools", internal_name: "other_technical_and_trade_schools", industry_type: :industry, naics_code: "611519").first_or_create
    IndustryCode.where(name: "Fine Arts Schools", internal_name: "fine_arts_schools", industry_type: :industry, naics_code: "611610").first_or_create
    IndustryCode.where(name: "Sports and Recreation Instruction", internal_name: "sports_and_recreation_instruction", industry_type: :industry, naics_code: "611620").first_or_create
    IndustryCode.where(name: "Language Schools", internal_name: "language_schools", industry_type: :industry, naics_code: "611630").first_or_create
    IndustryCode.where(name: "Exam Preparation and Tutoring", internal_name: "exam_preparation_and_tutoring", industry_type: :industry, naics_code: "611691").first_or_create
    IndustryCode.where(name: "Automobile Driving Schools", internal_name: "automobile_driving_schools", industry_type: :industry, naics_code: "611692").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Schools and Instruction", internal_name: "all_other_miscellaneous_schools_and_instruction", industry_type: :industry, naics_code: "611699").first_or_create
    IndustryCode.where(name: "Educational Support Services", internal_name: "educational_support_services", industry_type: :industry, naics_code: "611710").first_or_create
    IndustryCode.where(name: "Offices of Physicians (except Mental Health Specialists)", internal_name: "offices_of_physicians_except_mental_health_specialists", industry_type: :industry, naics_code: "621111").first_or_create
    IndustryCode.where(name: "Offices of Physicians, Mental Health Specialists", internal_name: "offices_of_physicians_mental_health_specialists", industry_type: :industry, naics_code: "621112").first_or_create
    IndustryCode.where(name: "Offices of Dentists", internal_name: "offices_of_dentists", industry_type: :industry, naics_code: "621210").first_or_create
    IndustryCode.where(name: "Offices of Chiropractors", internal_name: "offices_of_chiropractors", industry_type: :industry, naics_code: "621310").first_or_create
    IndustryCode.where(name: "Offices of Optometrists", internal_name: "offices_of_optometrists", industry_type: :industry, naics_code: "621320").first_or_create
    IndustryCode.where(name: "Offices of Mental Health Practitioners (except Physicians)", internal_name: "offices_of_mental_health_practitioners_except_physicians", industry_type: :industry, naics_code: "621330").first_or_create
    IndustryCode.where(name: "Offices of Physical, Occupational and Speech Therapists, and Audiologists", internal_name: "offices_of_physical_occupational_and_speech_therapists_and_audiologists", industry_type: :industry, naics_code: "621340").first_or_create
    IndustryCode.where(name: "Offices of Podiatrists", internal_name: "offices_of_podiatrists", industry_type: :industry, naics_code: "621391").first_or_create
    IndustryCode.where(name: "Offices of All Other Miscellaneous Health Practitioners", internal_name: "offices_of_all_other_miscellaneous_health_practitioners", industry_type: :industry, naics_code: "621399").first_or_create
    IndustryCode.where(name: "Family Planning Centers", internal_name: "family_planning_centers", industry_type: :industry, naics_code: "621410").first_or_create
    IndustryCode.where(name: "Outpatient Mental Health and Substance Abuse Centers", internal_name: "outpatient_mental_health_and_substance_abuse_centers", industry_type: :industry, naics_code: "621420").first_or_create
    IndustryCode.where(name: "HMO Medical Centers", internal_name: "hmo_medical_centers", industry_type: :industry, naics_code: "621491").first_or_create
    IndustryCode.where(name: "Kidney Dialysis Centers", internal_name: "kidney_dialysis_centers", industry_type: :industry, naics_code: "621492").first_or_create
    IndustryCode.where(name: "Freestanding Ambulatory Surgical and Emergency Centers", internal_name: "freestanding_ambulatory_surgical_and_emergency_centers", industry_type: :industry, naics_code: "621493").first_or_create
    IndustryCode.where(name: "All Other Outpatient Care Centers", internal_name: "all_other_outpatient_care_centers", industry_type: :industry, naics_code: "621498").first_or_create
    IndustryCode.where(name: "Medical Laboratories", internal_name: "medical_laboratories", industry_type: :industry, naics_code: "621511").first_or_create
    IndustryCode.where(name: "Diagnostic Imaging Centers", internal_name: "diagnostic_imaging_centers", industry_type: :industry, naics_code: "621512").first_or_create
    IndustryCode.where(name: "Home Health Care Services", internal_name: "home_health_care_services", industry_type: :industry, naics_code: "621610").first_or_create
    IndustryCode.where(name: "Ambulance Services", internal_name: "ambulance_services", industry_type: :industry, naics_code: "621910").first_or_create
    IndustryCode.where(name: "Blood and Organ Banks", internal_name: "blood_and_organ_banks", industry_type: :industry, naics_code: "621991").first_or_create
    IndustryCode.where(name: "All Other Miscellaneous Ambulatory Health Care Services", internal_name: "all_other_miscellaneous_ambulatory_health_care_services", industry_type: :industry, naics_code: "621999").first_or_create
    IndustryCode.where(name: "General Medical and Surgical Hospitals", internal_name: "general_medical_and_surgical_hospitals", industry_type: :industry, naics_code: "622110").first_or_create
    IndustryCode.where(name: "Psychiatric and Substance Abuse Hospitals", internal_name: "psychiatric_and_substance_abuse_hospitals", industry_type: :industry, naics_code: "622210").first_or_create
    IndustryCode.where(name: "Specialty (except Psychiatric and Substance Abuse) Hospitals", internal_name: "specialty_except_psychiatric_and_substance_abuse_hospitals", industry_type: :industry, naics_code: "622310").first_or_create
    IndustryCode.where(name: "Nursing Care Facilities (Skilled Nursing Facilities)", internal_name: "nursing_care_facilities_skilled_nursing_facilities", industry_type: :industry, naics_code: "623110").first_or_create
    IndustryCode.where(name: "Residential Intellectual and Developmental Disability Facilities", internal_name: "residential_intellectual_and_developmental_disability_facilities", industry_type: :industry, naics_code: "623210").first_or_create
    IndustryCode.where(name: "Residential Mental Health and Substance Abuse Facilities", internal_name: "residential_mental_health_and_substance_abuse_facilities", industry_type: :industry, naics_code: "623220").first_or_create
    IndustryCode.where(name: "Continuing Care Retirement Communities", internal_name: "continuing_care_retirement_communities", industry_type: :industry, naics_code: "623311").first_or_create
    IndustryCode.where(name: "Assisted Living Facilities for the Elderly", internal_name: "assisted_living_facilities_for_the_elderly", industry_type: :industry, naics_code: "623312").first_or_create
    IndustryCode.where(name: "Other Residential Care Facilities", internal_name: "other_residential_care_facilities", industry_type: :industry, naics_code: "623990").first_or_create
    IndustryCode.where(name: "Child and Youth Services", internal_name: "child_and_youth_services", industry_type: :industry, naics_code: "624110").first_or_create
    IndustryCode.where(name: "Services for the Elderly and Persons with Disabilities", internal_name: "services_for_the_elderly_and_persons_with_disabilities", industry_type: :industry, naics_code: "624120").first_or_create
    IndustryCode.where(name: "Other Individual and Family Services", internal_name: "other_individual_and_family_services", industry_type: :industry, naics_code: "624190").first_or_create
    IndustryCode.where(name: "Community Food Services", internal_name: "community_food_services", industry_type: :industry, naics_code: "624210").first_or_create
    IndustryCode.where(name: "Temporary Shelters", internal_name: "temporary_shelters", industry_type: :industry, naics_code: "624221").first_or_create
    IndustryCode.where(name: "Other Community Housing Services", internal_name: "other_community_housing_services", industry_type: :industry, naics_code: "624229").first_or_create
    IndustryCode.where(name: "Emergency and Other Relief Services", internal_name: "emergency_and_other_relief_services", industry_type: :industry, naics_code: "624230").first_or_create
    IndustryCode.where(name: "Vocational Rehabilitation Services", internal_name: "vocational_rehabilitation_services", industry_type: :industry, naics_code: "624310").first_or_create
    IndustryCode.where(name: "Child Day Care Services", internal_name: "child_day_care_services", industry_type: :industry, naics_code: "624410").first_or_create
    IndustryCode.where(name: "Theater Companies and Dinner Theaters", internal_name: "theater_companies_and_dinner_theaters", industry_type: :industry, naics_code: "711110").first_or_create
    IndustryCode.where(name: "Dance Companies", internal_name: "dance_companies", industry_type: :industry, naics_code: "711120").first_or_create
    IndustryCode.where(name: "Musical Groups and Artists", internal_name: "musical_groups_and_artists", industry_type: :industry, naics_code: "711130").first_or_create
    IndustryCode.where(name: "Other Performing Arts Companies", internal_name: "other_performing_arts_companies", industry_type: :industry, naics_code: "711190").first_or_create
    IndustryCode.where(name: "Sports Teams and Clubs", internal_name: "sports_teams_and_clubs", industry_type: :industry, naics_code: "711211").first_or_create
    IndustryCode.where(name: "Racetracks", internal_name: "racetracks", industry_type: :industry, naics_code: "711212").first_or_create
    IndustryCode.where(name: "Other Spectator Sports", internal_name: "other_spectator_sports", industry_type: :industry, naics_code: "711219").first_or_create
    IndustryCode.where(name: "Promoters of Performing Arts, Sports, and Similar Events with Facilities", internal_name: "promoters_of_performing_arts_sports_and_similar_events_with_facilities", industry_type: :industry, naics_code: "711310").first_or_create
    IndustryCode.where(name: "Promoters of Performing Arts, Sports, and Similar Events without Facilities", internal_name: "promoters_of_performing_arts_sports_and_similar_events_without_facilities", industry_type: :industry, naics_code: "711320").first_or_create
    IndustryCode.where(name: "Agents and Managers for Artists, Athletes, Entertainers, and Other Public Figures", internal_name: "agents_and_managers_for_artists_athletes_entertainers_and_other_public_figures", industry_type: :industry, naics_code: "711410").first_or_create
    IndustryCode.where(name: "Independent Artists, Writers, and Performers", internal_name: "independent_artists_writers_and_performers", industry_type: :industry, naics_code: "711510").first_or_create
    IndustryCode.where(name: "Museums", internal_name: "museums", industry_type: :industry, naics_code: "712110").first_or_create
    IndustryCode.where(name: "Historical Sites", internal_name: "historical_sites", industry_type: :industry, naics_code: "712120").first_or_create
    IndustryCode.where(name: "Zoos and Botanical Gardens", internal_name: "zoos_and_botanical_gardens", industry_type: :industry, naics_code: "712130").first_or_create
    IndustryCode.where(name: "Nature Parks and Other Similar Institutions", internal_name: "nature_parks_and_other_similar_institutions", industry_type: :industry, naics_code: "712190").first_or_create
    IndustryCode.where(name: "Amusement and Theme Parks", internal_name: "amusement_and_theme_parks", industry_type: :industry, naics_code: "713110").first_or_create
    IndustryCode.where(name: "Amusement Arcades", internal_name: "amusement_arcades", industry_type: :industry, naics_code: "713120").first_or_create
    IndustryCode.where(name: "Casinos (except Casino Hotels)", internal_name: "casinos_except_casino_hotels", industry_type: :industry, naics_code: "713210").first_or_create
    IndustryCode.where(name: "Other Gambling Industries", internal_name: "other_gambling_industries", industry_type: :industry, naics_code: "713290").first_or_create
    IndustryCode.where(name: "Golf Courses and Country Clubs", internal_name: "golf_courses_and_country_clubs", industry_type: :industry, naics_code: "713910").first_or_create
    IndustryCode.where(name: "Skiing Facilities", internal_name: "skiing_facilities", industry_type: :industry, naics_code: "713920").first_or_create
    IndustryCode.where(name: "Marinas", internal_name: "marinas", industry_type: :industry, naics_code: "713930").first_or_create
    IndustryCode.where(name: "Fitness and Recreational Sports Centers", internal_name: "fitness_and_recreational_sports_centers", industry_type: :industry, naics_code: "713940").first_or_create
    IndustryCode.where(name: "Bowling Centers", internal_name: "bowling_centers", industry_type: :industry, naics_code: "713950").first_or_create
    IndustryCode.where(name: "All Other Amusement and Recreation Industries", internal_name: "all_other_amusement_and_recreation_industries", industry_type: :industry, naics_code: "713990").first_or_create
    IndustryCode.where(name: "Hotels (except Casino Hotels) and Motels", internal_name: "hotels_except_casino_hotels_and_motels", industry_type: :industry, naics_code: "721110").first_or_create
    IndustryCode.where(name: "Casino Hotels", internal_name: "casino_hotels", industry_type: :industry, naics_code: "721120").first_or_create
    IndustryCode.where(name: "Bed_and_Breakfast Inns", internal_name: "bed_and_breakfast_inns", industry_type: :industry, naics_code: "721191").first_or_create
    IndustryCode.where(name: "All Other Traveler Accommodation", internal_name: "all_other_traveler_accommodation", industry_type: :industry, naics_code: "721199").first_or_create
    IndustryCode.where(name: "RV (Recreational Vehicle) Parks and Campgrounds", internal_name: "rv_recreational_vehicle_parks_and_campgrounds", industry_type: :industry, naics_code: "721211").first_or_create
    IndustryCode.where(name: "Recreational and Vacation Camps (except Campgrounds)", internal_name: "recreational_and_vacation_camps_except_campgrounds", industry_type: :industry, naics_code: "721214").first_or_create
    IndustryCode.where(name: "Rooming and Boarding Houses", internal_name: "rooming_and_boarding_houses", industry_type: :industry, naics_code: "721310").first_or_create
    IndustryCode.where(name: "Food Service Contractors", internal_name: "food_service_contractors", industry_type: :industry, naics_code: "722310").first_or_create
    IndustryCode.where(name: "Caterers", internal_name: "caterers", industry_type: :industry, naics_code: "722320").first_or_create
    IndustryCode.where(name: "Mobile Food Services", internal_name: "mobile_food_services", industry_type: :industry, naics_code: "722330").first_or_create
    IndustryCode.where(name: "Drinking Places (Alcoholic Beverages)", internal_name: "drinking_places_alcoholic_beverages", industry_type: :industry, naics_code: "722410").first_or_create
    IndustryCode.where(name: "Full_Service Restaurants", internal_name: "full_service_restaurants", industry_type: :industry, naics_code: "722511").first_or_create
    IndustryCode.where(name: "Limited_Service Restaurants", internal_name: "limited_service_restaurants", industry_type: :industry, naics_code: "722513").first_or_create
    IndustryCode.where(name: "Cafeterias, Grill Buffets, and Buffets", internal_name: "cafeterias_grill_buffets_and_buffets", industry_type: :industry, naics_code: "722514").first_or_create
    IndustryCode.where(name: "Snack and Nonalcoholic Beverage Bars", internal_name: "snack_and_nonalcoholic_beverage_bars", industry_type: :industry, naics_code: "722515").first_or_create
    IndustryCode.where(name: "General Automotive Repair", internal_name: "general_automotive_repair", industry_type: :industry, naics_code: "811111").first_or_create
    IndustryCode.where(name: "Automotive Exhaust System Repair", internal_name: "automotive_exhaust_system_repair", industry_type: :industry, naics_code: "811112").first_or_create
    IndustryCode.where(name: "Automotive Transmission Repair", internal_name: "automotive_transmission_repair", industry_type: :industry, naics_code: "811113").first_or_create
    IndustryCode.where(name: "Other Automotive Mechanical and Electrical Repair and Maintenance", internal_name: "other_automotive_mechanical_and_electrical_repair_and_maintenance", industry_type: :industry, naics_code: "811118").first_or_create
    IndustryCode.where(name: "Automotive Body, Paint, and Interior Repair and Maintenance", internal_name: "automotive_body_paint_and_interior_repair_and_maintenance", industry_type: :industry, naics_code: "811121").first_or_create
    IndustryCode.where(name: "Automotive Glass Replacement Shops", internal_name: "automotive_glass_replacement_shops", industry_type: :industry, naics_code: "811122").first_or_create
    IndustryCode.where(name: "Automotive Oil Change and Lubrication Shops", internal_name: "automotive_oil_change_and_lubrication_shops", industry_type: :industry, naics_code: "811191").first_or_create
    IndustryCode.where(name: "Car Washes", internal_name: "car_washes", industry_type: :industry, naics_code: "811192").first_or_create
    IndustryCode.where(name: "All Other Automotive Repair and Maintenance", internal_name: "all_other_automotive_repair_and_maintenance", industry_type: :industry, naics_code: "811198").first_or_create
    IndustryCode.where(name: "Consumer Electronics Repair and Maintenance", internal_name: "consumer_electronics_repair_and_maintenance", industry_type: :industry, naics_code: "811211").first_or_create
    IndustryCode.where(name: "Computer and Office Machine Repair and Maintenance", internal_name: "computer_and_office_machine_repair_and_maintenance", industry_type: :industry, naics_code: "811212").first_or_create
    IndustryCode.where(name: "Communication Equipment Repair and Maintenance", internal_name: "communication_equipment_repair_and_maintenance", industry_type: :industry, naics_code: "811213").first_or_create
    IndustryCode.where(name: "Other Electronic and Precision Equipment Repair and Maintenance", internal_name: "other_electronic_and_precision_equipment_repair_and_maintenance", industry_type: :industry, naics_code: "811219").first_or_create
    IndustryCode.where(name: "Commercial and Industrial Machinery and Equipment (except Automotive and Electronic) Repair and Maintenance", internal_name: "commercial_and_industrial_machinery_and_equipment_except_automotive_and_electronic_repair_and_maintenance", industry_type: :industry, naics_code: "811310").first_or_create
    IndustryCode.where(name: "Home and Garden Equipment Repair and Maintenance", internal_name: "home_and_garden_equipment_repair_and_maintenance", industry_type: :industry, naics_code: "811411").first_or_create
    IndustryCode.where(name: "Appliance Repair and Maintenance", internal_name: "appliance_repair_and_maintenance", industry_type: :industry, naics_code: "811412").first_or_create
    IndustryCode.where(name: "Reupholstery and Furniture Repair", internal_name: "reupholstery_and_furniture_repair", industry_type: :industry, naics_code: "811420").first_or_create
    IndustryCode.where(name: "Footwear and Leather Goods Repair", internal_name: "footwear_and_leather_goods_repair", industry_type: :industry, naics_code: "811430").first_or_create
    IndustryCode.where(name: "Other Personal and Household Goods Repair and Maintenance", internal_name: "other_personal_and_household_goods_repair_and_maintenance", industry_type: :industry, naics_code: "811490").first_or_create
    IndustryCode.where(name: "Barber Shops", internal_name: "barber_shops", industry_type: :industry, naics_code: "812111").first_or_create
    IndustryCode.where(name: "Beauty Salons", internal_name: "beauty_salons", industry_type: :industry, naics_code: "812112").first_or_create
    IndustryCode.where(name: "Nail Salons", internal_name: "nail_salons", industry_type: :industry, naics_code: "812113").first_or_create
    IndustryCode.where(name: "Diet and Weight Reducing Centers", internal_name: "diet_and_weight_reducing_centers", industry_type: :industry, naics_code: "812191").first_or_create
    IndustryCode.where(name: "Other Personal Care Services", internal_name: "other_personal_care_services", industry_type: :industry, naics_code: "812199").first_or_create
    IndustryCode.where(name: "Funeral Homes and Funeral Services", internal_name: "funeral_homes_and_funeral_services", industry_type: :industry, naics_code: "812210").first_or_create
    IndustryCode.where(name: "Cemeteries and Crematories", internal_name: "cemeteries_and_crematories", industry_type: :industry, naics_code: "812220").first_or_create
    IndustryCode.where(name: "Coin_Operated Laundries and Drycleaners", internal_name: "coin_operated_laundries_and_drycleaners", industry_type: :industry, naics_code: "812310").first_or_create
    IndustryCode.where(name: "Drycleaning and Laundry Services (except Coin_Operated)", internal_name: "drycleaning_and_laundry_services_except_coin_operated", industry_type: :industry, naics_code: "812320").first_or_create
    IndustryCode.where(name: "Linen Supply", internal_name: "linen_supply", industry_type: :industry, naics_code: "812331").first_or_create
    IndustryCode.where(name: "Industrial Launderers", internal_name: "industrial_launderers", industry_type: :industry, naics_code: "812332").first_or_create
    IndustryCode.where(name: "Pet Care (except Veterinary) Services", internal_name: "pet_care_except_veterinary_services", industry_type: :industry, naics_code: "812910").first_or_create
    IndustryCode.where(name: "Photofinishing Laboratories (except One_Hour)", internal_name: "photofinishing_laboratories_except_one_hour", industry_type: :industry, naics_code: "812921").first_or_create
    IndustryCode.where(name: "One_Hour Photofinishing", internal_name: "one_hour_photofinishing", industry_type: :industry, naics_code: "812922").first_or_create
    IndustryCode.where(name: "Parking Lots and Garages", internal_name: "parking_lots_and_garages", industry_type: :industry, naics_code: "812930").first_or_create
    IndustryCode.where(name: "All Other Personal Services", internal_name: "all_other_personal_services", industry_type: :industry, naics_code: "812990").first_or_create
    IndustryCode.where(name: "Religious Organizations", internal_name: "religious_organizations", industry_type: :industry, naics_code: "813110").first_or_create
    IndustryCode.where(name: "Grantmaking Foundations", internal_name: "grantmaking_foundations", industry_type: :industry, naics_code: "813211").first_or_create
    IndustryCode.where(name: "Voluntary Health Organizations", internal_name: "voluntary_health_organizations", industry_type: :industry, naics_code: "813212").first_or_create
    IndustryCode.where(name: "Other Grantmaking and Giving Services", internal_name: "other_grantmaking_and_giving_services", industry_type: :industry, naics_code: "813219").first_or_create
    IndustryCode.where(name: "Human Rights Organizations", internal_name: "human_rights_organizations", industry_type: :industry, naics_code: "813311").first_or_create
    IndustryCode.where(name: "Environment, Conservation and Wildlife Organizations", internal_name: "environment_conservation_and_wildlife_organizations", industry_type: :industry, naics_code: "813312").first_or_create
    IndustryCode.where(name: "Other Social Advocacy Organizations", internal_name: "other_social_advocacy_organizations", industry_type: :industry, naics_code: "813319").first_or_create
    IndustryCode.where(name: "Civic and Social Organizations", internal_name: "civic_and_social_organizations", industry_type: :industry, naics_code: "813410").first_or_create
    IndustryCode.where(name: "Business Associations", internal_name: "business_associations", industry_type: :industry, naics_code: "813910").first_or_create
    IndustryCode.where(name: "Professional Organizations", internal_name: "professional_organizations", industry_type: :industry, naics_code: "813920").first_or_create
    IndustryCode.where(name: "Labor Unions and Similar Labor Organizations", internal_name: "labor_unions_and_similar_labor_organizations", industry_type: :industry, naics_code: "813930").first_or_create
    IndustryCode.where(name: "Political Organizations", internal_name: "political_organizations", industry_type: :industry, naics_code: "813940").first_or_create
    IndustryCode.where(name: "Other Similar Organizations (except Business, Professional, Labor, and Political Organizations)", internal_name: "other_similar_organizations_except_business_professional_labor_and_political_organizations", industry_type: :industry, naics_code: "813990").first_or_create
    IndustryCode.where(name: "Private Households", internal_name: "private_households", industry_type: :industry, naics_code: "814110").first_or_create
    IndustryCode.where(name: "Executive Offices", internal_name: "executive_offices", industry_type: :industry, naics_code: "921110").first_or_create
    IndustryCode.where(name: "Legislative Bodies", internal_name: "legislative_bodies", industry_type: :industry, naics_code: "921120").first_or_create
    IndustryCode.where(name: "Public Finance Activities", internal_name: "public_finance_activities", industry_type: :industry, naics_code: "921130").first_or_create
    IndustryCode.where(name: "Executive and Legislative Offices, Combined", internal_name: "executive_and_legislative_offices_combined", industry_type: :industry, naics_code: "921140").first_or_create
    IndustryCode.where(name: "American Indian and Alaska Native Tribal Governments", internal_name: "american_indian_and_alaska_native_tribal_governments", industry_type: :industry, naics_code: "921150").first_or_create
    IndustryCode.where(name: "Other General Government Support", internal_name: "other_general_government_support", industry_type: :industry, naics_code: "921190").first_or_create
    IndustryCode.where(name: "Courts", internal_name: "courts", industry_type: :industry, naics_code: "922110").first_or_create
    IndustryCode.where(name: "Police Protection", internal_name: "police_protection", industry_type: :industry, naics_code: "922120").first_or_create
    IndustryCode.where(name: "Legal Counsel and Prosecution", internal_name: "legal_counsel_and_prosecution", industry_type: :industry, naics_code: "922130").first_or_create
    IndustryCode.where(name: "Correctional Institutions", internal_name: "correctional_institutions", industry_type: :industry, naics_code: "922140").first_or_create
    IndustryCode.where(name: "Parole Offices and Probation Offices", internal_name: "parole_offices_and_probation_offices", industry_type: :industry, naics_code: "922150").first_or_create
    IndustryCode.where(name: "Fire Protection", internal_name: "fire_protection", industry_type: :industry, naics_code: "922160").first_or_create
    IndustryCode.where(name: "Other Justice, Public Order, and Safety Activities", internal_name: "other_justice_public_order_and_safety_activities", industry_type: :industry, naics_code: "922190").first_or_create
    IndustryCode.where(name: "Administration of Education Programs", internal_name: "administration_of_education_programs", industry_type: :industry, naics_code: "923110").first_or_create
    IndustryCode.where(name: "Administration of Public Health Programs", internal_name: "administration_of_public_health_programs", industry_type: :industry, naics_code: "923120").first_or_create
    IndustryCode.where(name: "Administration of Human Resource Programs (except Education, Public Health, and Veterans' Affairs Programs)", internal_name: "administration_of_human_resource_programs_except_education_public_health_and_veterans'_affairs_programs", industry_type: :industry, naics_code: "923130").first_or_create
    IndustryCode.where(name: "Administration of Veterans' Affairs", internal_name: "administration_of_veterans'_affairs", industry_type: :industry, naics_code: "923140").first_or_create
    IndustryCode.where(name: "Administration of Air and Water Resource and Solid Waste Management Programs", internal_name: "administration_of_air_and_water_resource_and_solid_waste_management_programs", industry_type: :industry, naics_code: "924110").first_or_create
    IndustryCode.where(name: "Administration of Conservation Programs", internal_name: "administration_of_conservation_programs", industry_type: :industry, naics_code: "924120").first_or_create
    IndustryCode.where(name: "Administration of Housing Programs", internal_name: "administration_of_housing_programs", industry_type: :industry, naics_code: "925110").first_or_create
    IndustryCode.where(name: "Administration of Urban Planning and Community and Rural Development", internal_name: "administration_of_urban_planning_and_community_and_rural_development", industry_type: :industry, naics_code: "925120").first_or_create
    IndustryCode.where(name: "Administration of General Economic Programs", internal_name: "administration_of_general_economic_programs", industry_type: :industry, naics_code: "926110").first_or_create
    IndustryCode.where(name: "Regulation and Administration of Transportation Programs", internal_name: "regulation_and_administration_of_transportation_programs", industry_type: :industry, naics_code: "926120").first_or_create
    IndustryCode.where(name: "Regulation and Administration of Communications, Electric, Gas, and Other Utilities", internal_name: "regulation_and_administration_of_communications_electric_gas_and_other_utilities", industry_type: :industry, naics_code: "926130").first_or_create
    IndustryCode.where(name: "Regulation of Agricultural Marketing and Commodities", internal_name: "regulation_of_agricultural_marketing_and_commodities", industry_type: :industry, naics_code: "926140").first_or_create
    IndustryCode.where(name: "Regulation, Licensing, and Inspection of Miscellaneous Commercial Sectors", internal_name: "regulation_licensing_and_inspection_of_miscellaneous_commercial_sectors", industry_type: :industry, naics_code: "926150").first_or_create
    IndustryCode.where(name: "Space Research and Technology", internal_name: "space_research_and_technology", industry_type: :industry, naics_code: "927110").first_or_create
    IndustryCode.where(name: "National Security", internal_name: "national_security", industry_type: :industry, naics_code: "928110").first_or_create
    IndustryCode.where(name: "International Affairs", internal_name: "international_affairs", industry_type: :industry, naics_code: "928120").first_or_create
  end

  desc "create occupation code records"
  task :occupation_code => :environment do
    OccupationCode.where(name: "Not specified", internal_name: "not_specified", description: "This series does not have occupation as an attribute").first_or_create
    OccupationCode.where(name: "All occupations", internal_name: "all_occupations", description: "Occupation is a series attribute and all values are included").first_or_create
    OccupationCode.where(name: "No answer provided", internal_name: "no_answer_provided", description: "Occupation is a series attribute however no value was recorded").first_or_create

    #This is a stub, we will need to define these more explicitly when we have more examples

  end

  desc "create geo code records"
  task :geo_code => :environment do
    GeoCode::OtherGeo.where(name: "Not specified", internal_name: "not_specified", description: "This series does not have geography as an attribute").first_or_create
    # Does this ever happen? When would we not be able to get a geographic description?
    # Perhaps we use temporarily in dev then remove this and force a geographic definition explicitly
    GeoCode::OtherGeo.where(name: "All geographies", internal_name: "all_geographies", description: "Geography is a series attribute and all values are included").first_or_create
    GeoCode::OtherGeo.where(name: "No answer provided", internal_name: "no_answer_provided", description: "Geography is a series attribute however no value was recorded").first_or_create
    GeoCode::OtherGeo.where(name: "Not elsewhere classified", internal_name: "not_elsewhere_classified", description: "A geographic attribute was classified but it does not map to our system, see the raw value for details").first_or_create

    #Country
    GeoCode::Country.where(name: "United States", short_name: "USA", internal_name: "united_states").first_or_create

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
    GeoCode::State.where(name: 'District of Columbia', fips_code: 11, gnis_code: 1702382, short_name: 'DC', internal_name: :'district_of_columbia').first_or_create
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
    GeoCode::State.where(name: 'New Hampshire', fips_code: 33, gnis_code: 1779794, short_name: 'NH', internal_name: :'new_hampshire').first_or_create
    GeoCode::State.where(name: 'New Jersey', fips_code: 34, gnis_code: 1779795, short_name: 'NJ', internal_name: :'new_jersey').first_or_create
    GeoCode::State.where(name: 'New Mexico', fips_code: 35, gnis_code: 897535, short_name: 'NM', internal_name: :'new_mexico').first_or_create
    GeoCode::State.where(name: 'New York', fips_code: 36, gnis_code: 1779796, short_name: 'NY', internal_name: :'new_york').first_or_create
    GeoCode::State.where(name: 'North Carolina', fips_code: 37, gnis_code: 1027616, short_name: 'NC', internal_name: :'north_carolina').first_or_create
    GeoCode::State.where(name: 'North Dakota', fips_code: 38, gnis_code: 1779797, short_name: 'ND', internal_name: :'north_dakota').first_or_create
    GeoCode::State.where(name: 'Ohio', fips_code: 39, gnis_code: 1085497, short_name: 'OH', internal_name: :'ohio').first_or_create
    GeoCode::State.where(name: 'Oklahoma', fips_code: 40, gnis_code: 1102857, short_name: 'OK', internal_name: :'oklahoma').first_or_create
    GeoCode::State.where(name: 'Oregon', fips_code: 41, gnis_code: 1155107, short_name: 'OR', internal_name: :'oregon').first_or_create
    GeoCode::State.where(name: 'Pennsylvania', fips_code: 42, gnis_code: 1779798, short_name: 'PA', internal_name: :'pennsylvania').first_or_create
    GeoCode::State.where(name: 'Rhode Island', fips_code: 44, gnis_code: 1219835, short_name: 'RI', internal_name: :'rhode_island').first_or_create
    GeoCode::State.where(name: 'South Carolina', fips_code: 45, gnis_code: 1779799, short_name: 'SC', internal_name: :'south_carolina').first_or_create
    GeoCode::State.where(name: 'South Dakota', fips_code: 46, gnis_code: 1785534, short_name: 'SD', internal_name: :'south_dakota').first_or_create
    GeoCode::State.where(name: 'Tennessee', fips_code: 47, gnis_code: 1325873, short_name: 'TN', internal_name: :'tennessee').first_or_create
    GeoCode::State.where(name: 'Texas', fips_code: 48, gnis_code: 1779801, short_name: 'TX', internal_name: :'texas').first_or_create
    GeoCode::State.where(name: 'Utah', fips_code: 49, gnis_code: 1455989, short_name: 'UT', internal_name: :'utah').first_or_create
    GeoCode::State.where(name: 'Vermont', fips_code: 50, gnis_code: 1779802, short_name: 'VT', internal_name: :'vermont').first_or_create
    GeoCode::State.where(name: 'Virginia', fips_code: 51, gnis_code: 1779803, short_name: 'VA', internal_name: :'virginia').first_or_create
    GeoCode::State.where(name: 'Washington', fips_code: 53, gnis_code: 1779804, short_name: 'WA', internal_name: :'washington').first_or_create
    GeoCode::State.where(name: 'West Virginia', fips_code: 54, gnis_code: 1779805, short_name: 'WV', internal_name: :'west_virginia').first_or_create
    GeoCode::State.where(name: 'Wisconsin', fips_code: 55, gnis_code: 1779806, short_name: 'WI', internal_name: :'wisconsin').first_or_create
    GeoCode::State.where(name: 'Wyoming', fips_code: 56, gnis_code: 1779807, short_name: 'WY', internal_name: :'wyoming').first_or_create
    GeoCode::State.where(name: 'American Samoa', fips_code: 60, gnis_code: 1802701, short_name: 'AS', internal_name: :'american_samoa').first_or_create
    GeoCode::State.where(name: 'Guam', fips_code: 66, gnis_code: 1802705, short_name: 'GU', internal_name: :'guam').first_or_create
    GeoCode::State.where(name: 'Northern Mariana Islands', fips_code: 69, gnis_code: 1779809, short_name: 'MP', internal_name: :'northern_mariana_islands').first_or_create
    GeoCode::State.where(name: 'Puerto Rico', fips_code: 72, gnis_code: 1779808, short_name: 'PR', internal_name: :'puerto_rico').first_or_create
    GeoCode::State.where(name: 'U.S. Minor Outlying Islands', fips_code: 74, gnis_code: 1878752, short_name: 'UM', internal_name: :'us_minor_outlying_islands').first_or_create
    GeoCode::State.where(name: 'U.S. Virgin Islands', fips_code: 78, gnis_code: 1802710, short_name: 'VI', internal_name: :'us_virgin_islands').first_or_create

    #Combined Statistical Areas (CSA)
    GeoCode::Csa.where(name: 'Cleveland_Akron_Canton, OH', short_name: 'Cleveland, OH', internal_name: 'cleveland_akron_canton_oh').first_or_create
    GeoCode::Csa.where(name: 'Portland_Vancouver_Salem, OR_WA', short_name: 'Portland, OR', internal_name: 'portland_vancouver_salem_or_wa').first_or_create
    GeoCode::Csa.where(name: 'Albany_Schenectady, NY', short_name: 'Albany, NY', internal_name: 'albany_schenectady_ny').first_or_create
    GeoCode::Csa.where(name: 'Albuquerque_Santa Fe_Las Vegas, NM', short_name: 'Albuquerque, NM', internal_name: 'albuquerque_santa_fe_las_vegas_nm').first_or_create
    GeoCode::Csa.where(name: 'New York_Newark, NY_NJ_CT_PA', short_name: 'New York, NY', internal_name: 'new_york_newark_ny_nj_ct_pa').first_or_create
    GeoCode::Csa.where(name: 'Amarillo_Borger, TX', short_name: 'Amarillo, TX', internal_name: 'amarillo_borger_tx').first_or_create
    GeoCode::Csa.where(name: 'Des Moines_Ames_West Des Moines, IA', short_name: 'Des Moines, IA', internal_name: 'des_moines_ames_west_des_moines_ia').first_or_create
    GeoCode::Csa.where(name: 'Detroit_Warren_Ann Arbor, MI', short_name: 'Detroit, MI', internal_name: 'detroit_warren_ann_arbor_mi').first_or_create
    GeoCode::Csa.where(name: 'Appleton_Oshkosh_Neenah, WI', short_name: 'Appleton, WI', internal_name: 'appleton_oshkosh_neenah_wi').first_or_create
    GeoCode::Csa.where(name: 'San Juan_Carolina, PR', short_name: 'San Juan, PR', internal_name: 'san_juan_carolina_pr').first_or_create
    GeoCode::Csa.where(name: 'Asheville_Brevard, NC', short_name: 'Asheville, NC', internal_name: 'asheville_brevard_nc').first_or_create
    GeoCode::Csa.where(name: 'Atlanta__Athens_Clarke County__Sandy Springs, GA', short_name: 'Atlanta, GA', internal_name: 'atlanta__athens_clarke_county__sandy_springs_ga').first_or_create
    GeoCode::Csa.where(name: 'Philadelphia_Reading_Camden, PA_NJ_DE_MD', short_name: 'Philadelphia, PA', internal_name: 'philadelphia_reading_camden_pa_nj_de_md').first_or_create
    GeoCode::Csa.where(name: 'Columbus_Auburn_Opelika, GA_AL', short_name: 'Columbus, GA', internal_name: 'columbus_auburn_opelika_ga_al').first_or_create
    GeoCode::Csa.where(name: 'Washington_Baltimore_Arlington, DC_MD_VA_WV_PA', short_name: 'Washington, DC', internal_name: 'washington_baltimore_arlington_dc_md_va_wv_pa').first_or_create
    GeoCode::Csa.where(name: 'Boston_Worcester_Providence, MA_RI_NH_CT', short_name: 'Boston, MA', internal_name: 'boston_worcester_providence_ma_ri_nh_ct').first_or_create
    GeoCode::Csa.where(name: 'Kalamazoo_Battle Creek_Portage, MI', short_name: 'Kalamazoo, MI', internal_name: 'kalamazoo_battle_creek_portage_mi').first_or_create
    GeoCode::Csa.where(name: 'Saginaw_Midland_Bay City, MI', short_name: 'Saginaw, MI', internal_name: 'saginaw_midland_bay_city_mi').first_or_create
    GeoCode::Csa.where(name: 'Bend_Redmond_Prineville, OR', short_name: 'Bend, OR', internal_name: 'bend_redmond_prineville_or').first_or_create
    GeoCode::Csa.where(name: 'Birmingham_Hoover_Talladega, AL', short_name: 'Birmingham, AL', internal_name: 'birmingham_hoover_talladega_al').first_or_create
    GeoCode::Csa.where(name: 'Bloomington_Pontiac, IL', short_name: 'Bloomington, IL', internal_name: 'bloomington_pontiac_il').first_or_create
    GeoCode::Csa.where(name: 'Bloomington_Bedford, IN', short_name: 'Bloomington, IN', internal_name: 'bloomington_bedford_in').first_or_create
    GeoCode::Csa.where(name: 'Bloomsburg_Berwick_Sunbury, PA', short_name: 'Bloomsburg, PA', internal_name: 'bloomsburg_berwick_sunbury_pa').first_or_create
    GeoCode::Csa.where(name: 'Boise City_Mountain Home_Ontario, ID_OR', short_name: 'Boise City, ID', internal_name: 'boise_city_mountain_home_ontario_id_or').first_or_create
    GeoCode::Csa.where(name: 'Denver_Aurora, CO', short_name: 'Denver, CO', internal_name: 'denver_aurora_co').first_or_create
    GeoCode::Csa.where(name: 'Bowling Green_Glasgow, KY', short_name: 'Bowling Green, KY', internal_name: 'bowling_green_glasgow_ky').first_or_create
    GeoCode::Csa.where(name: 'Seattle_Tacoma, WA', short_name: 'Seattle, WA', internal_name: 'seattle_tacoma_wa').first_or_create
    GeoCode::Csa.where(name: 'Brownsville_Harlingen_Raymondville, TX', short_name: 'Brownsville, TX', internal_name: 'brownsville_harlingen_raymondville_tx').first_or_create
    GeoCode::Csa.where(name: 'Buffalo_Cheektowaga, NY', short_name: 'Buffalo, NY', internal_name: 'buffalo_cheektowaga_ny').first_or_create
    GeoCode::Csa.where(name: 'Greensboro__Winston_Salem__High Point, NC', short_name: 'Greensboro, NC', internal_name: 'greensboro__winston_salem__high_point_nc').first_or_create
    GeoCode::Csa.where(name: 'Cape Coral_Fort Myers_Naples, FL', short_name: 'Cape Coral, FL', internal_name: 'cape_coral_fort_myers_naples_fl').first_or_create
    GeoCode::Csa.where(name: 'Cape Girardeau_Sikeston, MO_IL', short_name: 'Cape Girardeau, MO', internal_name: 'cape_girardeau_sikeston_mo_il').first_or_create
    GeoCode::Csa.where(name: 'Reno_Carson City_Fernley, NV', short_name: 'Reno, NV', internal_name: 'reno_carson_city_fernley_nv').first_or_create
    GeoCode::Csa.where(name: 'Cedar Rapids_Iowa City, IA', short_name: 'Cedar Rapids, IA', internal_name: 'cedar_rapids_iowa_city_ia').first_or_create
    GeoCode::Csa.where(name: 'Charleston_Huntington_Ashland, WV_OH_KY', short_name: 'Charleston, WV', internal_name: 'charleston_huntington_ashland_wv_oh_ky').first_or_create
    GeoCode::Csa.where(name: 'Charlotte_Concord, NC_SC', short_name: 'Charlotte, NC', internal_name: 'charlotte_concord_nc_sc').first_or_create
    GeoCode::Csa.where(name: 'Chattanooga_Cleveland_Dalton, TN_GA_AL', short_name: 'Chattanooga, TN', internal_name: 'chattanooga_cleveland_dalton_tn_ga_al').first_or_create
    GeoCode::Csa.where(name: 'Chicago_Naperville, IL_IN_WI', short_name: 'Chicago, IL', internal_name: 'chicago_naperville_il_in_wi').first_or_create
    GeoCode::Csa.where(name: 'Cincinnati_Wilmington_Maysville, OH_KY_IN', short_name: 'Cincinnati, OH', internal_name: 'cincinnati_wilmington_maysville_oh_ky_in').first_or_create
    GeoCode::Csa.where(name: 'Spokane_Spokane Valley_Coeur dAlene, WA_ID', short_name: 'Spokane, WA', internal_name: 'spokane_spokane_valley_coeur_dalene_wa_id').first_or_create
    GeoCode::Csa.where(name: 'Columbia_Moberly_Mexico, MO', short_name: 'Columbia, MO', internal_name: 'columbia_moberly_mexico_mo').first_or_create
    GeoCode::Csa.where(name: 'Columbia_Orangeburg_Newberry, SC', short_name: 'Columbia, SC', internal_name: 'columbia_orangeburg_newberry_sc').first_or_create
    GeoCode::Csa.where(name: 'Indianapolis_Carmel_Muncie, IN', short_name: 'Indianapolis, IN', internal_name: 'indianapolis_carmel_muncie_in').first_or_create
    GeoCode::Csa.where(name: 'Columbus_Marion_Zanesville, OH', short_name: 'Columbus, OH', internal_name: 'columbus_marion_zanesville_oh').first_or_create
    GeoCode::Csa.where(name: 'Corpus Christi_Kingsville_Alice, TX', short_name: 'Corpus Christi, TX', internal_name: 'corpus_christi_kingsville_alice_tx').first_or_create
    GeoCode::Csa.where(name: 'Dallas_Fort Worth, TX_OK', short_name: 'Dallas, TX', internal_name: 'dallas_fort_worth_tx_ok').first_or_create
    GeoCode::Csa.where(name: 'Mobile_Daphne_Fairhope, AL', short_name: 'Mobile, AL', internal_name: 'mobile_daphne_fairhope_al').first_or_create
    GeoCode::Csa.where(name: 'Davenport_Moline, IA_IL', short_name: 'Davenport, IA', internal_name: 'davenport_moline_ia_il').first_or_create
    GeoCode::Csa.where(name: 'Dayton_Springfield_Sidney, OH', short_name: 'Dayton, OH', internal_name: 'dayton_springfield_sidney_oh').first_or_create
    GeoCode::Csa.where(name: 'Huntsville_Decatur_Albertville, AL', short_name: 'Huntsville, AL', internal_name: 'huntsville_decatur_albertville_al').first_or_create
    GeoCode::Csa.where(name: 'Orlando_Deltona_Daytona Beach, FL', short_name: 'Orlando, FL', internal_name: 'orlando_deltona_daytona_beach_fl').first_or_create
    GeoCode::Csa.where(name: 'Dothan_Enterprise_Ozark, AL', short_name: 'Dothan, AL', internal_name: 'dothan_enterprise_ozark_al').first_or_create
    GeoCode::Csa.where(name: 'Raleigh_Durham_Chapel Hill, NC', short_name: 'Raleigh, NC', internal_name: 'raleigh_durham_chapel_hill_nc').first_or_create
    GeoCode::Csa.where(name: 'Eau Claire_Menomonie, WI', short_name: 'Eau Claire, WI', internal_name: 'eau_claire_menomonie_wi').first_or_create
    GeoCode::Csa.where(name: 'Louisville_Jefferson County__Elizabethtown__Madison, KY_IN', short_name: 'Louisville, KY', internal_name: 'louisville_jefferson_county__elizabethtown__madison_ky_in').first_or_create
    GeoCode::Csa.where(name: 'South Bend_Elkhart_Mishawaka, IN_MI', short_name: 'South Bend, IN', internal_name: 'south_bend_elkhart_mishawaka_in_mi').first_or_create
    GeoCode::Csa.where(name: 'Elmira_Corning, NY', short_name: 'Elmira, NY', internal_name: 'elmira_corning_ny').first_or_create
    GeoCode::Csa.where(name: 'El Paso_Las Cruces, TX_NM', short_name: 'El Paso, TX', internal_name: 'el_paso_las_cruces_tx_nm').first_or_create
    GeoCode::Csa.where(name: 'Erie_Meadville, PA', short_name: 'Erie, PA', internal_name: 'erie_meadville_pa').first_or_create
    GeoCode::Csa.where(name: 'Fargo_Wahpeton, ND_MN', short_name: 'Fargo, ND', internal_name: 'fargo_wahpeton_nd_mn').first_or_create
    GeoCode::Csa.where(name: 'Fayetteville_Lumberton_Laurinburg, NC', short_name: 'Fayetteville, NC', internal_name: 'fayetteville_lumberton_laurinburg_nc').first_or_create
    GeoCode::Csa.where(name: 'Fort Wayne_Huntington_Auburn, IN', short_name: 'Fort Wayne, IN', internal_name: 'fort_wayne_huntington_auburn_in').first_or_create
    GeoCode::Csa.where(name: 'Fresno_Madera, CA', short_name: 'Fresno, CA', internal_name: 'fresno_madera_ca').first_or_create
    GeoCode::Csa.where(name: 'Gainesville_Lake City, FL', short_name: 'Gainesville, FL', internal_name: 'gainesville_lake_city_fl').first_or_create
    GeoCode::Csa.where(name: 'Harrisburg_York_Lebanon, PA', short_name: 'Harrisburg, PA', internal_name: 'harrisburg_york_lebanon_pa').first_or_create
    GeoCode::Csa.where(name: 'Grand Rapids_Wyoming_Muskegon, MI', short_name: 'Grand Rapids, MI', internal_name: 'grand_rapids_wyoming_muskegon_mi').first_or_create
    GeoCode::Csa.where(name: 'Medford_Grants Pass, OR', short_name: 'Medford, OR', internal_name: 'medford_grants_pass_or').first_or_create
    GeoCode::Csa.where(name: 'Green Bay_Shawano, WI', short_name: 'Green Bay, WI', internal_name: 'green_bay_shawano_wi').first_or_create
    GeoCode::Csa.where(name: 'Greenville_Washington, NC', short_name: 'Greenville, NC', internal_name: 'greenville_washington_nc').first_or_create
    GeoCode::Csa.where(name: 'Greenville_Spartanburg_Anderson, SC', short_name: 'Greenville, SC', internal_name: 'greenville_spartanburg_anderson_sc').first_or_create
    GeoCode::Csa.where(name: 'New Orleans_Metairie_Hammond, LA_MS', short_name: 'New Orleans, LA', internal_name: 'new_orleans_metairie_hammond_la_ms').first_or_create
    GeoCode::Csa.where(name: 'Visalia_Porterville_Hanford, CA', short_name: 'Visalia, CA', internal_name: 'visalia_porterville_hanford_ca').first_or_create
    GeoCode::Csa.where(name: 'Harrisonburg_Staunton_Waynesboro, VA', short_name: 'Harrisonburg, VA', internal_name: 'harrisonburg_staunton_waynesboro_va').first_or_create
    GeoCode::Csa.where(name: 'Hartford_West Hartford, CT', short_name: 'Hartford, CT', internal_name: 'hartford_west_hartford_ct').first_or_create
    GeoCode::Csa.where(name: 'Hickory_Lenoir, NC', short_name: 'Hickory, NC', internal_name: 'hickory_lenoir_nc').first_or_create
    GeoCode::Csa.where(name: 'Savannah_Hinesville_Statesboro, GA', short_name: 'Savannah, GA', internal_name: 'savannah_hinesville_statesboro_ga').first_or_create
    GeoCode::Csa.where(name: 'Hot Springs_Malvern, AR', short_name: 'Hot Springs, AR', internal_name: 'hot_springs_malvern_ar').first_or_create
    GeoCode::Csa.where(name: 'Houston_The Woodlands, TX', short_name: 'Houston, TX', internal_name: 'houston_the_woodlands_tx').first_or_create
    GeoCode::Csa.where(name: 'Idaho Falls_Rexburg_Blackfoot, ID', short_name: 'Idaho Falls, ID', internal_name: 'idaho_falls_rexburg_blackfoot_id').first_or_create
    GeoCode::Csa.where(name: 'Ithaca_Cortland, NY', short_name: 'Ithaca, NY', internal_name: 'ithaca_cortland_ny').first_or_create
    GeoCode::Csa.where(name: 'Jackson_Vicksburg_Brookhaven, MS', short_name: 'Jackson, MS', internal_name: 'jackson_vicksburg_brookhaven_ms').first_or_create
    GeoCode::Csa.where(name: 'Jacksonville_St. Marys_Palatka, FL_GA', short_name: 'Jacksonville, FL', internal_name: 'jacksonville_st_marys_palatka_fl_ga').first_or_create
    GeoCode::Csa.where(name: 'Madison_Janesville_Beloit, WI', short_name: 'Madison, WI', internal_name: 'madison_janesville_beloit_wi').first_or_create
    GeoCode::Csa.where(name: 'Johnson City_Kingsport_Bristol, TN_VA', short_name: 'Johnson City, TN', internal_name: 'johnson_city_kingsport_bristol_tn_va').first_or_create
    GeoCode::Csa.where(name: 'Johnstown_Somerset, PA', short_name: 'Johnstown, PA', internal_name: 'johnstown_somerset_pa').first_or_create
    GeoCode::Csa.where(name: 'Jonesboro_Paragould, AR', short_name: 'Jonesboro, AR', internal_name: 'jonesboro_paragould_ar').first_or_create
    GeoCode::Csa.where(name: 'Joplin_Miami, MO_OK', short_name: 'Joplin, MO', internal_name: 'joplin_miami_mo_ok').first_or_create
    GeoCode::Csa.where(name: 'Kansas City_Overland Park_Kansas City, MO_KS', short_name: 'Kansas City, MO', internal_name: 'kansas_city_overland_park_kansas_city_mo_ks').first_or_create
    GeoCode::Csa.where(name: 'Knoxville_Morristown_Sevierville, TN', short_name: 'Knoxville, TN', internal_name: 'knoxville_morristown_sevierville_tn').first_or_create
    GeoCode::Csa.where(name: 'Kokomo_Peru, IN', short_name: 'Kokomo, IN', internal_name: 'kokomo_peru_in').first_or_create
    GeoCode::Csa.where(name: 'Lafayette_Opelousas_Morgan City, LA', short_name: 'Lafayette, LA', internal_name: 'lafayette_opelousas_morgan_city_la').first_or_create
    GeoCode::Csa.where(name: 'Lafayette_West Lafayette_Frankfort, IN', short_name: 'Lafayette, IN', internal_name: 'lafayette_west_lafayette_frankfort_in').first_or_create
    GeoCode::Csa.where(name: 'Las Vegas_Henderson, NV_AZ', short_name: 'Las Vegas, NV', internal_name: 'las_vegas_henderson_nv_az').first_or_create
    GeoCode::Csa.where(name: 'Lansing_East Lansing_Owosso, MI', short_name: 'Lansing, MI', internal_name: 'lansing_east_lansing_owosso_mi').first_or_create
    GeoCode::Csa.where(name: 'Portland_Lewiston_South Portland, ME', short_name: 'Portland, ME', internal_name: 'portland_lewiston_south_portland_me').first_or_create
    GeoCode::Csa.where(name: 'Lexington_Fayette__Richmond__Frankfort, KY', short_name: 'Lexington, KY', internal_name: 'lexington_fayette__richmond__frankfort_ky').first_or_create
    GeoCode::Csa.where(name: 'Lima_Van Wert_Celina, OH', short_name: 'Lima, OH', internal_name: 'lima_van_wert_celina_oh').first_or_create
    GeoCode::Csa.where(name: 'Lincoln_Beatrice, NE', short_name: 'Lincoln, NE', internal_name: 'lincoln_beatrice_ne').first_or_create
    GeoCode::Csa.where(name: 'Little Rock_North Little Rock, AR', short_name: 'Little Rock, AR', internal_name: 'little_rock_north_little_rock_ar').first_or_create
    GeoCode::Csa.where(name: 'Longview_Marshall, TX', short_name: 'Longview, TX', internal_name: 'longview_marshall_tx').first_or_create
    GeoCode::Csa.where(name: 'Los Angeles_Long Beach, CA', short_name: 'Los Angeles, CA', internal_name: 'los_angeles_long_beach_ca').first_or_create
    GeoCode::Csa.where(name: 'Lubbock_Levelland, TX', short_name: 'Lubbock, TX', internal_name: 'lubbock_levelland_tx').first_or_create
    GeoCode::Csa.where(name: 'Macon_Warner Robins, GA', short_name: 'Macon, GA', internal_name: 'macon_warner_robins_ga').first_or_create
    GeoCode::Csa.where(name: 'Manhattan_Junction City, KS', short_name: 'Manhattan, KS', internal_name: 'manhattan_junction_city_ks').first_or_create
    GeoCode::Csa.where(name: 'Mankato_New Ulm_North Mankato, MN', short_name: 'Mankato, MN', internal_name: 'mankato_new_ulm_north_mankato_mn').first_or_create
    GeoCode::Csa.where(name: 'Mansfield_Ashland_Bucyrus, OH', short_name: 'Mansfield, OH', internal_name: 'mansfield_ashland_bucyrus_oh').first_or_create
    GeoCode::Csa.where(name: 'Mayagüez_San Germán, PR', short_name: 'Mayaguez, PR', internal_name: 'mayaguez_san_german_pr').first_or_create
    GeoCode::Csa.where(name: 'McAllen_Edinburg, TX', short_name: 'McAllen, TX', internal_name: 'mcallen_edinburg_tx').first_or_create
    GeoCode::Csa.where(name: 'Memphis_Forrest City, TN_MS_AR', short_name: 'Memphis, TN', internal_name: 'memphis_forrest_city_tn_ms_ar').first_or_create
    GeoCode::Csa.where(name: 'Modesto_Merced, CA', short_name: 'Modesto, CA', internal_name: 'modesto_merced_ca').first_or_create
    GeoCode::Csa.where(name: 'Miami_Fort Lauderdale_Port St. Lucie, FL', short_name: 'Miami, FL', internal_name: 'miami_fort_lauderdale_port_st_lucie_fl').first_or_create
    GeoCode::Csa.where(name: 'Midland_Odessa, TX', short_name: 'Midland, TX', internal_name: 'midland_odessa_tx').first_or_create
    GeoCode::Csa.where(name: 'Milwaukee_Racine_Waukesha, WI', short_name: 'Milwaukee, WI', internal_name: 'milwaukee_racine_waukesha_wi').first_or_create
    GeoCode::Csa.where(name: 'Minneapolis_St. Paul, MN_WI', short_name: 'Minneapolis, MN', internal_name: 'minneapolis_st_paul_mn_wi').first_or_create
    GeoCode::Csa.where(name: 'Monroe_Ruston_Bastrop, LA', short_name: 'Monroe, LA', internal_name: 'monroe_ruston_bastrop_la').first_or_create
    GeoCode::Csa.where(name: 'Morgantown_Fairmont, WV', short_name: 'Morgantown, WV', internal_name: 'morgantown_fairmont_wv').first_or_create
    GeoCode::Csa.where(name: 'Myrtle Beach_Conway, SC_NC', short_name: 'Myrtle Beach, SC', internal_name: 'myrtle_beach_conway_sc_nc').first_or_create
    GeoCode::Csa.where(name: 'San Jose_San Francisco_Oakland, CA', short_name: 'San Francisco, CA', internal_name: 'san_jose_san_francisco_oakland_ca').first_or_create
    GeoCode::Csa.where(name: 'Nashville_Davidson__Murfreesboro, TN', short_name: 'Nashville, TN', internal_name: 'nashville_davidson__murfreesboro_tn').first_or_create
    GeoCode::Csa.where(name: 'New Bern_Morehead City, NC', short_name: 'New Bern, NC', internal_name: 'new_bern_morehead_city_nc').first_or_create
    GeoCode::Csa.where(name: 'North Port_Sarasota, FL', short_name: 'North Port, FL', internal_name: 'north_port_sarasota_fl').first_or_create
    GeoCode::Csa.where(name: 'Salt Lake City_Provo_Orem, UT', short_name: 'Salt Lake City, UT', internal_name: 'salt_lake_city_provo_orem_ut').first_or_create
    GeoCode::Csa.where(name: 'Oklahoma City_Shawnee, OK', short_name: 'Oklahoma City, OK', internal_name: 'oklahoma_city_shawnee_ok').first_or_create
    GeoCode::Csa.where(name: 'Omaha_Council Bluffs_Fremont, NE_IA', short_name: 'Omaha, NE', internal_name: 'omaha_council_bluffs_fremont_ne_ia').first_or_create
    GeoCode::Csa.where(name: 'Parkersburg_Marietta_Vienna, WV_OH', short_name: 'Parkersburg, WV', internal_name: 'parkersburg_marietta_vienna_wv_oh').first_or_create
    GeoCode::Csa.where(name: 'Peoria_Canton, IL', short_name: 'Peoria, IL', internal_name: 'peoria_canton_il').first_or_create
    GeoCode::Csa.where(name: 'Pittsburgh_New Castle_Weirton, PA_OH_WV', short_name: 'Pittsburgh, PA', internal_name: 'pittsburgh_new_castle_weirton_pa_oh_wv').first_or_create
    GeoCode::Csa.where(name: 'Ponce_Coamo_Santa Isabel, PR', short_name: 'Ponce, PR', internal_name: 'ponce_coamo_santa_isabel_pr').first_or_create
    GeoCode::Csa.where(name: 'Pueblo_Cañon City, CO', short_name: 'Pueblo, CO', internal_name: 'pueblo_canon_city_co').first_or_create
    GeoCode::Csa.where(name: 'Rapid City_Spearfish, SD', short_name: 'Rapid City, SD', internal_name: 'rapid_city_spearfish_sd').first_or_create
    GeoCode::Csa.where(name: 'Redding_Red Bluff, CA', short_name: 'Redding, CA', internal_name: 'redding_red_bluff_ca').first_or_create
    GeoCode::Csa.where(name: 'Rochester_Austin, MN', short_name: 'Rochester, MN', internal_name: 'rochester_austin_mn').first_or_create
    GeoCode::Csa.where(name: 'Rochester_Batavia_Seneca Falls, NY', short_name: 'Rochester, NY', internal_name: 'rochester_batavia_seneca_falls_ny').first_or_create
    GeoCode::Csa.where(name: 'Rockford_Freeport_Rochelle, IL', short_name: 'Rockford, IL', internal_name: 'rockford_freeport_rochelle_il').first_or_create
    GeoCode::Csa.where(name: 'Rocky Mount_Wilson_Roanoke Rapids, NC', short_name: 'Rocky Mount, NC', internal_name: 'rocky_mount_wilson_roanoke_rapids_nc').first_or_create
    GeoCode::Csa.where(name: 'Rome_Summerville, GA', short_name: 'Rome, GA', internal_name: 'rome_summerville_ga').first_or_create
    GeoCode::Csa.where(name: 'Sacramento_Roseville, CA', short_name: 'Sacramento, CA', internal_name: 'sacramento_roseville_ca').first_or_create
    GeoCode::Csa.where(name: 'St. Louis_St. Charles_Farmington, MO_IL', short_name: 'St. Louis, MO', internal_name: 'st_louis_st_charles_farmington_mo_il').first_or_create
    GeoCode::Csa.where(name: 'Sioux City_Vermillion, IA_SD_NE', short_name: 'Sioux City, IA', internal_name: 'sioux_city_vermillion_ia_sd_ne').first_or_create
    GeoCode::Csa.where(name: 'Springfield_Jacksonville_Lincoln, IL', short_name: 'Springfield, IL', internal_name: 'springfield_jacksonville_lincoln_il').first_or_create
    GeoCode::Csa.where(name: 'Springfield_Greenfield Town, MA', short_name: 'Springfield, MA', internal_name: 'springfield_greenfield_town_ma').first_or_create
    GeoCode::Csa.where(name: 'Springfield_Branson, MO', short_name: 'Springfield, MO', internal_name: 'springfield_branson_mo').first_or_create
    GeoCode::Csa.where(name: 'State College_DuBois, PA', short_name: 'State College, PA', internal_name: 'state_college_dubois_pa').first_or_create
    GeoCode::Csa.where(name: 'Syracuse_Auburn, NY', short_name: 'Syracuse, NY', internal_name: 'syracuse_auburn_ny').first_or_create
    GeoCode::Csa.where(name: 'Tallahassee_Bainbridge, FL_GA', short_name: 'Tallahassee, FL', internal_name: 'tallahassee_bainbridge_fl_ga').first_or_create
    GeoCode::Csa.where(name: 'Toledo_Port Clinton, OH', short_name: 'Toledo, OH', internal_name: 'toledo_port_clinton_oh').first_or_create
    GeoCode::Csa.where(name: 'Tucson_Nogales, AZ', short_name: 'Tucson, AZ', internal_name: 'tucson_nogales_az').first_or_create
    GeoCode::Csa.where(name: 'Tulsa_Muskogee_Bartlesville, OK', short_name: 'Tulsa, OK', internal_name: 'tulsa_muskogee_bartlesville_ok').first_or_create
    GeoCode::Csa.where(name: 'Tyler_Jacksonville, TX', short_name: 'Tyler, TX', internal_name: 'tyler_jacksonville_tx').first_or_create
    GeoCode::Csa.where(name: 'Victoria_Port Lavaca, TX', short_name: 'Victoria, TX', internal_name: 'victoria_port_lavaca_tx').first_or_create
    GeoCode::Csa.where(name: 'Virginia Beach_Norfolk, VA_NC', short_name: 'Virginia Beach, VA', internal_name: 'virginia_beach_norfolk_va_nc').first_or_create
    GeoCode::Csa.where(name: 'Wausau_Stevens Point_Wisconsin Rapids, WI', short_name: 'Wausau, WI', internal_name: 'wausau_stevens_point_wisconsin_rapids_wi').first_or_create
    GeoCode::Csa.where(name: 'Wichita_Arkansas City_Winfield, KS', short_name: 'Wichita, KS', internal_name: 'wichita_arkansas_city_winfield_ks').first_or_create
    GeoCode::Csa.where(name: 'Williamsport_Lock Haven, PA', short_name: 'Williamsport, PA', internal_name: 'williamsport_lock_haven_pa').first_or_create
    GeoCode::Csa.where(name: 'Youngstown_Warren, OH_PA', short_name: 'Youngstown, OH', internal_name: 'youngstown_warren_oh_pa').first_or_create
  end

  desc "create geo hierarchy"
  task :geo_hierarchy => :environment do
    parent = GeoCode.find_by(internal_name: 'united_states')
    states_and_region_internal_names = ["northeast","southeast","midwest","westcoast","alabama","alaska","arizona","arkansas","california","colorado","connecticut",
      "delaware","district_of_columbia","florida","georgia","hawaii","idaho","illinois","indiana","iowa","kansas","kentucky",
      "louisiana","maine","maryland","massachusetts","michigan","minnesota","mississippi","missouri","montana","nebraska",
      "nevada","new_hampshire","new_jersey","new_mexico","new_york","north_carolina","north_dakota","ohio","oklahoma","oregon",
      "pennsylvania","rhode_island","south_carolina","south_dakota","tennessee","texas","utah","vermont","virginia",
      "washington","west_virginia","wisconsin","wyoming","american_samoa","guam","northern_mariana_islands","puerto_rico",
      "us_minor_outlying_islands","us_virgin_islands"]
    states_and_region_internal_names.each do |state_and_region_internal_name|
      child = GeoCode.find_by(internal_name: state_and_region_internal_name)
      child.update(parent_id: parent.id)
    end

    csas = GeoCode::Csa.all
    csas.each do |csa|
      csa.update(parent_id: GeoCode::State.find_by(short_name: csa.short_name[-2,2]).id)
    end
  end

  desc "create industry hierarchy"
  task :industry_hierarchy => :environment do
    parent = IndustryCode.find_by(internal_name: 'agriculture_forestry_fishing_and_hunting')
    children = IndustryCode.where(naics_code: 110..120)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'mining_quarrying_and_oil_and_gas_extraction')
    children = IndustryCode.where(naics_code: 210..219)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'utilities')
    children = IndustryCode.where(naics_code: 220..229)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'construction')
    children = IndustryCode.where(naics_code: 230..239)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'manufacturing')
    children = IndustryCode.where(naics_code: 310..339)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'wholesale_trade')
    children = IndustryCode.where(naics_code: 420..429)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'retail_trade')
    children = IndustryCode.where(naics_code: 440..459)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'information')
    children = IndustryCode.where(naics_code: 510..519)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'finance_and_insurance')
    children = IndustryCode.where(naics_code: 520..529)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'real_estate_and_rental_and_leasing')
    children = IndustryCode.where(naics_code: 530..539)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'professional_scientific_and_technical_services')
    children = IndustryCode.where(naics_code: 540..549)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'management_of_companies_and_enterprises')
    children = IndustryCode.where(naics_code: 550..559)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'administrative_and_support_and_waste_management_and_remediation_services')
    children = IndustryCode.where(naics_code: 560..569)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'educational_services')
    children = IndustryCode.where(naics_code: 610..619)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'health_care_and_social_assistance')
    children = IndustryCode.where(naics_code: 620..629)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'arts_entertainment_and_recreation')
    children = IndustryCode.where(naics_code: 710..719)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'accommodation_and_food_services')
    children = IndustryCode.where(naics_code: 720..729)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'other_services_except_public_administration')
    children = IndustryCode.where(naics_code: 810..819)
    children.each do |child| child.update(parent_id: parent.id) end

    parent = IndustryCode.find_by(internal_name: 'public_administration')
    children = IndustryCode.where(naics_code: 920..929)
    children.each do |child| child.update(parent_id: parent.id) end

    IndustryCode.where(industry_type: 'subsector').each do |parent|
      start = parent.naics_code*10
      finish = (parent.naics_code+1)*10 - 1
      children = IndustryCode.where(naics_code: start..finish)
      children.each do |child|
        child.update(parent_id: parent.id)
      end
    end

    IndustryCode.where(industry_type: 'industry_group').each do |parent|
      start = parent.naics_code*10
      finish = (parent.naics_code+1)*10 - 1
      children = IndustryCode.where(naics_code: start..finish)
      children.each do |child|
        child.update(parent_id: parent.id)
      end
    end

  end

end
