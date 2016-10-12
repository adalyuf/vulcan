class Bulkload::Bls::ImportIndicators::Ce < Bulkload::Bls::ImportIndicators

BLS_CE = SystemConfig.load_config_file(Rails.root.join('config', 'bls', 'ce.yml'))

INDUSTRY_CODE_TO_INTERNAL_NAME = BLS_CE['industry_code_to_internal_name']
INDUSTRY_CODE_TO_NAICS = BLS_CE['industry_code_to_naics']
INDUSTRY_CODE_TO_NAME = BLS_CE['industry_code_to_name']
DATATYPE_TO_INTERNAL_NAME = BLS_CE['datatype_to_internal_name']

  def unit(datatype)
    internal_name = DATATYPE_TO_INTERNAL_NAME[datatype]
    unit_by_internal_name[internal_name].id
  end

  def industry_id(industrycode)
    internal_name = INDUSTRY_CODE_TO_INTERNAL_NAME[industrycode]

    if industry_by_internal_name[internal_name]
      industry_by_internal_name[internal_name].id
    else
      naics = INDUSTRY_CODE_TO_NAICS[industrycode]
      if naics
        industry_by_naics_code[naics.to_i] ? industry_by_naics_code[naics.to_i].id : industry_by_internal_name['not-elsewhere-classified'].id
      else
        industry_by_internal_name['not-elsewhere-classified'].id
      end
    end
  end


  def import_indicators
    parsed_file = Bulkload::Bls::FileManager.new("indicators", "ce", "ce.series").parsed_file

    uniq_series = Set.new

    # ensure all series titles are unique
    parsed_file.each do |series_id,  supersector_code,  industry_code, data_type_code,  seasonal,  series_title,  footnote_codes,  begin_year,  begin_period,  end_year,  end_period|
      series_title = series_title.strip
      comma = series_title.index(",")
      uniq_series << series_title[0..comma-1]
    end

    source_id = Source.find_by(internal_name: "bureau-labor-statistics").id
    # These indicators reflect Current Employment Statistics and covers employment, hours, and earnings. Classifying as business.
    category_id = Category.find_by(internal_name: :business).id
    dataset_id = Dataset.where(name: "Current Employment Statistics", category_id: Category.find_by(name: "Business").id, internal_name: "bls-current-employment-statistics", source_id: Source.find_by(internal_name: "bureau-labor-statistics").id , description: "The Current Employment Statistics Program provides
employment, paid hours, and earnings information").first_or_create.id


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
    parsed_file = Bulkload::Bls::FileManager.new("series", "ce", "ce.series").parsed_file

    frequency_id = Frequency.find_by(internal_name: 'monthly').id

    gender_id = Gender.not_specified.id
    race_id = Race.not_specified.id
    marital_status_id = MaritalStatus.not_specified.id
    age_bracket_id = AgeBracket.not_specified.id
    employment_status_id = EmploymentStatus.not_specified.id
    education_level_id = EducationLevel.not_specified.id
    child_status_id = ChildStatus.not_specified.id
    income_level_id = IncomeLevel.not_specified.id
    occupation_code_id = OccupationCode.not_specified.id
    geo_code_id = GeoCode::Country.find_by(internal_name: 'united-states').id


    list = parsed_file.map do |series_id,  supersector_code,  industry_code, data_type_code,  seasonal,  series_title,  footnote_codes,  begin_year,  begin_period,  end_year,  end_period|
      description = series_title
      unit_id = unit(data_type_code.strip)
      name = series_id.strip
      internal_name = name
      source_identifier = name
      comma = series_title.index(",")
      indicator_name = series_title[0..comma-1]
      indicator_id = indicators_by_name[indicator_name].id
      seasonally_adjusted = SEASONAL[seasonal]
      industry_code_id = industry_id(industry_code)
      industry_code_raw = INDUSTRY_CODE_TO_NAME[industry_code]

      Series::Data.new(name: name,
                       description: description,
                       internal_name: internal_name,
                       source_identifier: source_identifier,
                       multiplier: 0,
                       seasonally_adjusted: seasonally_adjusted,
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
                       industry_code_raw: industry_code_raw,
                       occupation_code_id: occupation_code_id,
                       geo_code_id: geo_code_id
                       )
    end
    Series.load(list)
  end

  def update_industry
    parsed_file = Bulkload::Bls::FileManager.new("series", "ce", "ce.series").parsed_file

    parsed_file.each do |series_id,  supersector_code,  industry_code, data_type_code,  seasonal,  series_title,  footnote_codes,  begin_year,  begin_period,  end_year,  end_period|
      serie = Series.find_by(source_identifier: series_id.strip)
      if serie
        serie.industry_code_id = industry_id(industry_code)
        serie.industry_code_raw = INDUSTRY_CODE_TO_NAME[industry_code].to_s
        serie.save
      else
        puts "No match found for #{series_id}"
      end
    end

  end

end