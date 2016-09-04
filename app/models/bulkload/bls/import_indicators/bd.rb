class Bulkload::Bls::ImportIndicators::Bd < Bulkload::Bls::ImportIndicators

  def import_indicators
    parsed_file = Bulkload::Bls::FileManager.new("indicators", "bd", "bd.series").parsed_file

    uniq_series = Set.new

    # ensure all series titles are unique
    parsed_file.each do |series_id, seasonal, msa_code, state_code, county_code,  industry_code,  unitanalysis_code,  dataelement_code, sizeclass_code, dataclass_code, ratelevel_code, periodicity_code, ownership_code, series_title, footnote_codes, begin_year, begin_period, end_year, end_period|
      uniq_series << series_title.strip
    end

    source_id = Source.find_by(internal_name: :"bureau-labor-statistics").id
    #These indicators reflect job creation and business establishments. Classifying this as Business
    category_id = Category.find_by(internal_name: :business).id
    dataset_id = Dataset.find_by(internal_name: :"bls-business-employment-dynamics").id

    list = uniq_series.map do |series_title|
      description = series_title.strip
      name = normalize_name(description)
      internal_name = normalize_internal_name(description)
      source_identifier = series_title.strip

      Indicator::Data.new(name: name,
                          internal_name: internal_name,
                          source_identifier: source_identifier,
                          description: description,
                          source_id: source_id,
                          category_id: category_id,
                          dataset_id: dataset_id
                          )
    end

    Indicator.load(list)
  end

  def import_series
    parsed_file = Bulkload::Bls::FileManager.new("series", "bd", "bd.series").parsed_file

    jobs_unit_id = Unit.find_by(internal_name: :jobs).id
    percent_unit_id = Unit.find_by(internal_name: :percent).id
    establishments_unit_id = Unit.find_by(internal_name: :establishments).id
    annual_frequency_id = Frequency.find_by(internal_name: :annual).id
    quarterly_frequency_id = Frequency.find_by(internal_name: :quarterly).id

    gender_id = Gender.find_by(internal_name: "not-specified").id
    race_id = Race.find_by(internal_name: "not-specified").id
    marital_status_id = MaritalStatus.find_by(internal_name: "not-specified").id
    age_bracket_id = AgeBracket.find_by(internal_name: "not-specified").id
    employment_status_id = EmploymentStatus.find_by(internal_name: "not-specified").id
    education_level_id = EducationLevel.find_by(internal_name: "not-specified").id
    child_status_id = ChildStatus.find_by(internal_name: "not-specified").id
    income_level_id = IncomeLevel.find_by(internal_name: "not-specified").id
    industry_code_id = IndustryCode.find_by(internal_name: "not-specified").id #SERIES HAS INDUSTRY, ONLY FOR DEVELOPMENT, FIX ASAP
    occupation_code_id = OccupationCode.find_by(internal_name: "not-specified").id

    list = parsed_file.map do |series_id, seasonal, msa_code, state_code, county_code,  industry_code,  unitanalysis_code,  dataelement_code, sizeclass_code, dataclass_code, ratelevel_code, periodicity_code, ownership_code, series_title, footnote_codes, begin_year, begin_period, end_year, end_period|
      unit_id =
        case ratelevel_code.strip
        when 'R'
          percent_unit_id
        when 'L'
          case dataelement_code.strip.to_i
          when 1
            jobs_unit_id
          when 2
            establishments_unit_id
          end
        end

        frequency_id =
          case periodicity_code.strip
          when 'A'
            annual_frequency_id
          when 'Q'
            quarterly_frequency_id
          end

        name = series_id.strip
        internal_name = name
        source_identifier = name
        geo_code_raw = state_code
        indicator_id = indicators_by_source_identifier[series_title.strip].id
        state_code = state_code.to_i
        if state_code == 0
          geo_code_id = geo_by_internal_name['united-states'].id
        else
          geo_code_id = geo_by_fips_code[state_code].try(:id) || geo_by_internal_name['not-elsewhere-classified'].id
        end

        Series::Data.new(name: name,
                         description: nil,
                         internal_name: internal_name,
                         source_identifier: source_identifier,
                         multiplier: 0,
                         seasonally_adjusted: SEASONAL[seasonal.strip],
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
