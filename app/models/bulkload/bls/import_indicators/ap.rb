class Bulkload::Bls::ImportIndicators::Ap < Bulkload::Bls::ImportIndicators

BLS_AP = SystemConfig.load_config_file(Rails.root.join('config', 'bls', 'ap.yml'))

AREA_CODE_TO_NAME = BLS_AP['area_code_to_name']
AREA_CODE_TO_CSA_SHORT_NAME = BLS_AP['area_code_to_csa_short_name']

  def region(area_code)
    short_name = AREA_CODE_TO_CSA_SHORT_NAME[area_code]
    if geo_by_short_name[short_name]
      geo_by_short_name[short_name].id
    else
      case area_code
      when "0000"
        geo_by_internal_name['united_states'].id
      when "0100"
        geo_by_internal_name['northeast'].id
      when "0200"
        geo_by_internal_name['midwest'].id
      when "0300"
        geo_by_internal_name['southeast'].id
      when "0400"
        geo_by_internal_name['westcoast'].id
      else
        geo_by_internal_name['not_elsewhere_classified'].id
      end
    end
  end

  def import_indicators
    parsed_file = Bulkload::Bls::FileManager.new("indicators", "ap", "ap.item").parsed_file
    source_id = Source.find_by(internal_name: "bureau_labor_statistics").id
    # These indicators reflect the average price of goods in various cities. Classifying this as Business
    category_id = Category.find_by(internal_name: :business).id
    dataset_id = Dataset.find_by(internal_name: "bls_average_prices").id

    list = parsed_file.map do |code, description|
      description = description.strip
      name = normalize_name(description)
      internal_name = normalize_internal_name(description)
      source_identifier = code.strip

      Indicator::Data.new(name: name,
                          description: description,
                          internal_name: internal_name,
                          source_identifier: source_identifier,
                          source_id: source_id,
                          category_id: category_id,
                          dataset_id: dataset_id
                          )
    end
    Indicator.load(list)
  end

  def import_series
    parsed_file = Bulkload::Bls::FileManager.new("series", "ap", "ap.series").parsed_file

    unit_id = Unit.find_by(internal_name: "nominal_us_dollars").id
    frequency_id = Frequency.find_by(internal_name: :"monthly").id

    gender_id = Gender.not_specified.id
    race_id = Race.not_specified.id
    marital_status_id = MaritalStatus.not_specified.id
    age_bracket_id = AgeBracket.not_specified.id
    employment_status_id = EmploymentStatus.not_specified.id
    education_level_id = EducationLevel.not_specified.id
    child_status_id = ChildStatus.not_specified.id
    income_level_id = IncomeLevel.not_specified.id
    industry_code_id = IndustryCode.not_specified.id
    occupation_code_id = OccupationCode.not_specified.id

    list = parsed_file.map do |series_id, area_code, item_code, footnote_codes, begin_year, begin_period, end_year, end_period|
      footnote_codes = footnote_codes.strip
      description = footnote_codes.length > 0 ? footnote_codes : nil

      name = series_id.strip
      internal_name = name
      source_identifier = name
      indicator_id = indicators_by_source_identifier[item_code.strip].id
      geo_code_id = region(area_code)
      geo_code_raw = AREA_CODE_TO_NAME[area_code]

      Series::Data.new(name: name,
                       description: description,
                       internal_name: internal_name,
                       source_identifier: source_identifier,
                       multiplier: 0,
                       seasonally_adjusted: false,
                       unit_id: unit_id,
                       frequency_id: frequency_id,
                       indicator_id: indicator_id,
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
                       geo_code_raw: geo_code_raw,
                       geo_code_id: geo_code_id
                       )
    end
    Series.load(list)
  end
end
