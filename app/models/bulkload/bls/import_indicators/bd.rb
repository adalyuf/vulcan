class Bulkload::Bls::ImportIndicators::Bd < Bulkload::Bls::ImportIndicators

BLS_BD = SystemConfig.load_config_file(Rails.root.join('config', 'bls', 'bd.yml'))

INDUSTRY_CODE_TO_NAICS = BLS_BD['industry_code_to_naics']
SIZE_CLASS_ID_TO_DESCRIPTION = BLS_BD['size_class_id_to_description']
DESCRIPTIONS = BLS_BD['descriptions']

  def import_indicators
    source_id = Source.find_by(internal_name: "bureau_labor_statistics").id
    #These indicators reflect job creation and business establishments. Classifying this as Business
    category_id = Category.find_by(internal_name: :business).id
    dataset_id = Dataset.find_by(internal_name: "bls_business_employment_dynamics").id

    Indicator.where(name: "Gross job gains", internal_name: 'gross_job_gains', description: "Gross job gains rounded to nearest thousand.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] ,source_identifier: '11L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of gross job gains", internal_name: 'percent_of_gross_job_gains', description: "Percentage of jobs gained as a percent of total employment in the sector.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '11R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Employment gained from expansions", internal_name: 'employment_gained_from_expansions', description: "Employment gained from expanding businesses rounded to nearest thousand.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '12L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of employment gained from expansions", internal_name: 'percent_of_employment_gained_from_expansions', description: "Percentage of employment gained from expanding businesses as a percentage of total employment in the sector", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '12R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Employment gained from openings", internal_name: 'employment_gained_from_openings', description: "Employment gained from new businesses rounded to nearest thousand. Openings include temporarily shut businesses that add staff.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '13L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of employment gained from openings", internal_name: 'percent_of_employment_gained_from_openings', description: "Percentage of employment gained from new businesses as a percentage of total employment in the sector. Openings include temporarily shut businesses that add staff.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '13R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Gross job losses", internal_name: 'gross_job_losses', description: "Gross job losses rounded to nearest thousand.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '14L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of gross job losses", internal_name: 'percent_of_gross_job_losses', description: "Percentage of jobs lost as a percent of total employment in the sector.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '14R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Employment lost from contractions", internal_name: 'employment_lost_from_contractions', description: "Employment lost from contracting businesses rounded to nearest thousand.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '15L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of employment lost from contractions", internal_name: 'percent_of_employment_lost_from_contractions', description: "Percent of employment lost from contracting businesses as a percentage of total employment in the sector", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '15R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Employment lost from closings", internal_name: 'employment_lost_from_closings', description: "Employment lost from closing businesses rounded to nearest thousand. Closings include temporarily shut businesses that report zero staff.", source_identifier: '16L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of employment lost from closings", internal_name: 'percent_of_employment_lost_from_closings', description: "Percent of employment lost from closing businesses as a percentage of total employment in the sector. Closings include temporarily shut businesses that report zero staff.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '16R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Employment gained by establishment births", internal_name: 'employment_gained_by_establishment_births', description: "Employment gained by establishment births rounded to nearest thousand. Births exclude temporarily shut businesses that add staff.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '17L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of employment gained by establishment births", internal_name: 'percent_of_employment_gained_by_establishment_births', description: "Percentage of employment gained by establishment births as a percentage of total employment in the sector. Births exclude temporarily shut businesses that add staff.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '17R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Employment lost by establishment deaths", internal_name: 'employment_lost_by_establishment_deaths', description: "Employment lost by establishment deaths rounded to nearest thousand. Deaths exclude temporarily shut businesses that continue to report but have zero staff.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '18L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of employment lost by establishment deaths", internal_name: 'percent_of_employment_lost_by_establishment_deaths', description: "Percentage of employment lost by establishment deaths as a percentage of total employment in the sector. Deaths exclude temporarily shut businesses that continue to report but have zero staff.", description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'], source_identifier: '18R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create

    Indicator.where(name: "Establishments with gross job gains", internal_name: 'establishments_with_gross_job_gains', description: "Number of establishments with gross job gains rounded to nearest thousand.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '21L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of establishments with gross job gains", internal_name: 'percent_of_establishments_with_gross_job_gains', description: "Percent of establishments with gross job gains in the sector.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '21R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Establishments with employment gained from expansions", internal_name: 'establishments_with_employment_gained_from_expansions', description: "Number of establishments with employment gained from expansions rounded to nearest thousand.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '22L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of establishments with employment gained from expansions", internal_name: 'percent_of_establishments_with_employment_gained_from_expansions', description: "Percent of establishments with employment gained from expansions in the sector",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '22R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Establishments with employment gained from openings", internal_name: 'establishments_with_employment_gained_from_openings', description: "Number of establishments with employment gained from openings rounded to nearest thousand. Openings include temporarily shut businesses that add staff.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '23L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of establishments with employment gained from openings", internal_name: 'percent_of_establishments_with_employment_gained_from_openings', description: "Percent of establishments with employment gained from openings as a percentage of total employment in the sector. Openings include temporarily shut businesses that add staff.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '23R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Establishments with gross job losses", internal_name: 'establishments_with_gross_job_losses', description: "Number of establishments with gross job losses rounded to nearest thousand.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '24L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of establishments with gross job losses", internal_name: 'percent_of_establishments_with_gross_job_losses', description: "Percent of establishments with gross job losses in the sector",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '24R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Establishments with employment lost from contractions", internal_name: 'establishments_with_employment_lost_from_contractions', description: "Number of establishments with employment lost from contractions rounded to nearest thousand.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '25L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of establishments with employment lost from contractions", internal_name: 'percent_of_establishments_with_employment_lost_from_contractions', description: "Percent of establishments with employment lost from contracting businesses as a percentage of the sector",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '25R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Establishments with employment lost from closings", internal_name: 'establishments_with_employment_lost_from_closings', description: "Number of establishments with employment lost from closing businesses rounded to nearest thousand. Closings include temporarily shut businesses that report zero staff.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '26L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of establishments with employment lost from closings", internal_name: 'percent_of_establishments_with_employment_lost_from_closings', description: "Percent of establishments with employment lost from closing businesses as a percentage of the sector. Closings include temporarily shut businesses that report zero staff.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '26R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Establishment births", internal_name: 'establishment_births', description: "Number of establishment births. Births exclude temporarily shut businesses that add staff.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '27L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of establishment births", internal_name: 'percent_of_establishment_births', description: "Percentage of establishment births as a percentage of the sector. Births exclude temporarily shut businesses that add staff.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '27R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Establishment deaths", internal_name: 'establishment_deaths', description: "Number of establishment deaths. Deaths exclude temporarily shut businesses that continue to report but have zero staff.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '28L', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
    Indicator.where(name: "Percent of establishment deaths", internal_name: 'percent_of_establishment_deaths', description: "Percentage of establishment deaths as a percentage of the sector. Deaths exclude temporarily shut businesses that continue to report but have zero staff.",description_long: DESCRIPTIONS['employment'] + DESCRIPTIONS['openings_short'] + DESCRIPTIONS['openings_long'] + DESCRIPTIONS['establishments_long'], source_identifier: '28R', source_id: source_id, category_id: category_id, dataset_id: dataset_id).first_or_create
  end

  def import_series
    parsed_file = Bulkload::Bls::FileManager.new("series", "bd", "bd.series").parsed_file

    jobs_unit_id = Unit.find_by(internal_name: :jobs_or_employees).id
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
        case unit_raw_id
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

        multiplier =
          case unit_raw_id
          when 'R'
            0
          when 'L'
            dataelement_code == 2 ? 0 : 3
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
        indicator_raw_id = dataelement_code.to_i.to_s + dataclass_code.to_i.to_s + ratelevel_code
        indicator_id = indicators_by_source_identifier[indicator_raw_id].id
        description = SIZE_CLASS_ID_TO_DESCRIPTION[sizeclass_code.strip]
        state_code = state_code.to_i
        geo_code_raw_id = state_code
        if state_code == 0
          geo_code_id = geo_by_internal_name['united_states'].id
        else
          geo_code_id = geo_by_fips_code[state_code].try(:id) || geo_by_internal_name['not_elsewhere_classified'].id
        end

        Series::Data.new(name: name,
                         description: description,
                         internal_name: internal_name,
                         source_identifier: source_identifier,
                         multiplier: multiplier,
                         seasonally_adjusted: SEASONAL[seasonal.strip],
                         unit_id: unit_id,
                         frequency_id: frequency_id,
                         indicator_id: indicator_id,
                         indicator_raw_id: indicator_raw_id,
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
