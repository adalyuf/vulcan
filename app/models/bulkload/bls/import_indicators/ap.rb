class Bulkload::Bls::ImportIndicators::Ap < Bulkload::Bls::ImportIndicators

  def import_indicators
    parsed_file = Bulkload::Bls::FileManager.new("indicators", "ap", "ap.item").parsed_file
    source_id = Source.find_by(internal_name: "bls").id
    # These indicators reflect the average price of goods in various cities. Classifying this as Business
    category_id = Category.find_by(name: "Business").id
    dataset_id = Dataset.find_by(internal_name: "bls_ap").id

    list = parsed_file.map do |code, description|
      Indicator::Data.new(name: code.strip,
                          description: description.strip,
                          source_id: source_id,
                          category_id: category_id,
                          dataset_id: dataset_id
                          )
    end
    Indicator.load(list)
  end

  def import_series
    parsed_file = Bulkload::Bls::FileManager.new("series", "ap", "ap.series").parsed_file

    unit_id = Unit.find_by(name: "Nominal US Dollars").id
    frequency_id = Frequency.find_by(name: "Monthly").id

    gender_id = Gender.find_by(name: "Not specified").id
    race_id = Race.find_by(name: "Not specified").id
    marital_status_id = MaritalStatus.find_by(name: "Not specified").id
    age_bracket_id = AgeBracket.find_by(name: "Not specified").id
    employment_status_id = EmploymentStatus.find_by(name: "Not specified").id
    education_level_id = EducationLevel.find_by(name: "Not specified").id
    child_status_id = ChildStatus.find_by(name: "Not specified").id
    income_level_id = IncomeLevel.find_by(name: "Not specified").id
    industry_code_id = IndustryCode.find_by(name: "Not specified").id
    occupation_code_id = OccupationCode.find_by(name: "Not specified").id
    geo_code_id = GeoCode.find_by(name: "Not specified").id #FOR DEVELOPMENT ONLY, SERIES HAS GEOGRAPHIC ATTRIBUTES, FIX ASAP


    list = parsed_file.map do |series_id, area_code, item_code, footnote_codes, begin_year, begin_period, end_year, end_period|
      Series::Data.new(name: series_id.strip,
                       description: footnote_codes.strip.length > 0 ? footnote_codes.strip : nil,
                       multiplier: 0,
                       seasonally_adjusted: false,
                       unit_id: unit_id,
                       frequency_id: frequency_id,
                       indicator_id: indicators_by_name[item_code.strip].id,
                       gender_id: gender_id,
                       race_id: race_id,
                       marital_status_id: marital_status_id,
                       age_bracket_id: age_bracket_id,
                       employment_status_id: employment_status_id,
                       education_level_id: education_level_id,
                       child_status_id: child_status_id,
                       income_level_id: income_level_id,
                       industry_code_id: industry_code_id,
                       occupation_code_id: occupation_code_id,
                       geo_code_id: geo_code_id
                       )
    end
    Series.load(list)
  end
end
