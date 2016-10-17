class Bulkload::Bls::ImportIndicators::Bd < Bulkload::Bls::ImportIndicators

BLS_BD = SystemConfig.load_config_file(Rails.root.join('config', 'bls', 'bd.yml'))

INDUSTRY_CODE_TO_NAICS = BLS_BD['industry_code_to_naics']

  def import_indicators
    parsed_file = Bulkload::Bls::FileManager.new("indicators", "bd", "bd.series").parsed_file

    uniq_series = Set.new

    # ensure all series titles are unique
    parsed_file.each do |series_id, seasonal, msa_code, state_code, county_code,  industry_code,  unitanalysis_code,  dataelement_code, sizeclass_code, dataclass_code, ratelevel_code, periodicity_code, ownership_code, series_title, footnote_codes, begin_year, begin_period, end_year, end_period|
      uniq_series << series_title.strip
    end

    source_id = Source.find_by(internal_name: "bureau_labor_statistics").id
    #These indicators reflect job creation and business establishments. Classifying this as Business
    category_id = Category.find_by(internal_name: :business).id
    dataset_id = Dataset.find_by(internal_name: "bls_business_employment_dynamics").id

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

    gender_id = Gender.not_specified.id
    race_id = Race.not_specified.id
    marital_status_id = MaritalStatus.not_specified.id
    age_bracket_id = AgeBracket.not_specified.id
    employment_status_id = EmploymentStatus.not_specified.id
    education_level_id = EducationLevel.not_specified.id
    child_status_id = ChildStatus.not_specified.id
    income_level_id = IncomeLevel.not_specified.id
    occupation_code_id = OccupationCode.not_specified.id

    list = parsed_file.map do |series_id, seasonal, msa_code, state_code, county_code,  industry_code,  unitanalysis_code,  dataelement_code, sizeclass_code, dataclass_code, ratelevel_code, periodicity_code, ownership_code, series_title, footnote_codes, begin_year, begin_period, end_year, end_period|
      unit_raw_id = ratelevel_code.strip
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

        industry_code_raw_id = industry_code.strip
        industry_code_raw  = industry_code.strip

        industry_code_id =
        case industry_code_raw
        when '0'
          IndustryCode.find_by(internal_name: "all_private_industry").id
        when '100000'
          IndustryCode.find_by(internal_name: "all_goods_producers").id
        when '200000'
          IndustryCode.find_by(internal_name: "all_service_providers").id
        else
          industry = IndustryCode.find_by(naics_code: INDUSTRY_CODE_TO_NAICS[industry_code_raw])
          industry ? industry.id : IndustryCode.find_by(internal_name: "not_elsewhere_classified").id
        end

        name = series_id.strip
        internal_name = name
        source_identifier = name
        geo_code_raw = state_code
        indicator_id = indicators_by_source_identifier[series_title.strip].id
        state_code = state_code.to_i
        geo_code_raw_id = state_code
        if state_code == 0
          geo_code_id = geo_by_internal_name['united_states'].id
        else
          geo_code_id = geo_by_fips_code[state_code].try(:id) || geo_by_internal_name['not_elsewhere_classified'].id
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
                         industry_code_raw: industry_code_raw,
                         industry_code_id: industry_code_id,
                         occupation_code_id: occupation_code_id,
                         geo_code_raw: geo_code_raw,
                         geo_code_id: geo_code_id,
                         unit_raw_id: unit_raw_id,
                         industry_code_raw_id: industry_code_raw_id,
                         geo_code_raw_id: geo_code_raw_id

                         )
    end
    Series.load(list)
  end

  def update_series_raw_ids
    parsed_file = Bulkload::Bls::FileManager.new("series", "bd", "bd.series").parsed_file
    parsed_file.each do |series_id, seasonal, msa_code, state_code, county_code,  industry_code,  unitanalysis_code,  dataelement_code, sizeclass_code, dataclass_code, ratelevel_code, periodicity_code, ownership_code, series_title, footnote_codes, begin_year, begin_period, end_year, end_period|
      serie = series_by_source_identifier[series_id.strip]
      serie.unit_raw_id = ratelevel_code.strip
      serie.industry_code_raw_id = industry_code.strip
      serie.geo_code_raw_id = state_code.strip
      serie.save
    end
  end


end
