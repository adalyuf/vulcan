class Bulkload::Bls::ImportIndicators::Bd < Bulkload::Bls::ImportIndicators

INDUSTRY =
{
'100010' => '11',
'100020' => '23',
'100030' => '31',
'200010' => '42',
'200020' => '44',
'200030' => '48',
'200040' => '22',
'200050' => '51',
'200060' => '52',
'200070' => '54',
'200080' => '61',
'200090' => '71',
'200100' => '81',
'300111' => '111',
'300112' => '112',
'300113' => '113',
'300114' => '114',
'300115' => '115',
'300211' => '211',
'300212' => '212',
'300213' => '213',
'300236' => '236',
'300237' => '237',
'300238' => '238',
'300311' => '311',
'300312' => '312',
'300313' => '313',
'300314' => '314',
'300315' => '315',
'300316' => '316',
'300321' => '321',
'300322' => '322',
'300323' => '323',
'300324' => '324',
'300325' => '325',
'300326' => '326',
'300327' => '327',
'300331' => '331',
'300332' => '332',
'300333' => '333',
'300334' => '334',
'300335' => '335',
'300336' => '336',
'300337' => '337',
'300339' => '339',
'300423' => '423',
'300424' => '424',
'300425' => '425',
'300441' => '441',
'300442' => '442',
'300443' => '443',
'300444' => '444',
'300445' => '445',
'300446' => '446',
'300447' => '447',
'300448' => '448',
'300451' => '451',
'300452' => '452',
'300453' => '453',
'300454' => '454',
'300481' => '481',
'300483' => '483',
'300484' => '484',
'300485' => '485',
'300486' => '486',
'300487' => '487',
'300488' => '488',
'300492' => '492',
'300493' => '493',
'300511' => '511',
'300512' => '512',
'300515' => '515',
'300517' => '517',
'300518' => '518',
'300519' => '519',
'300522' => '522',
'300523' => '523',
'300524' => '524',
'300525' => '525',
'300531' => '531',
'300532' => '532',
'300533' => '533',
'300541' => '541',
'300551' => '551',
'300561' => '561',
'300562' => '562',
'300611' => '611',
'300621' => '621',
'300622' => '622',
'300623' => '623',
'300624' => '624',
'300711' => '711',
'300712' => '712',
'300713' => '713',
'300721' => '721',
'300722' => '722',
'300811' => '811',
'300812' => '812',
'300813' => '813'
}

  def import_indicators
    parsed_file = Bulkload::Bls::FileManager.new("indicators", "bd", "bd.series").parsed_file

    uniq_series = Set.new

    # ensure all series titles are unique
    parsed_file.each do |series_id, seasonal, msa_code, state_code, county_code,  industry_code,  unitanalysis_code,  dataelement_code, sizeclass_code, dataclass_code, ratelevel_code, periodicity_code, ownership_code, series_title, footnote_codes, begin_year, begin_period, end_year, end_period|
      uniq_series << series_title.strip
    end

    source_id = Source.find_by(internal_name: "bureau-labor-statistics").id
    #These indicators reflect job creation and business establishments. Classifying this as Business
    category_id = Category.find_by(internal_name: :business).id
    dataset_id = Dataset.find_by(internal_name: "bls-business-employment-dynamics").id

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

        industry_code_raw  = industry_code.strip

        industry_code_id =
        case industry_code_raw
        when '0'
          IndustryCode.find_by(internal_name: "all-private-industry").id
        when '100000'
          IndustryCode.find_by(internal_name: "all-goods-producers").id
        when '200000'
          IndustryCode.find_by(internal_name: "all-service-providers").id
        else
          industry = IndustryCode.find_by(naics_code: INDUSTRY[industry_code_raw])
          industry ? industry.id : IndustryCode.find_by(internal_name: "not-elsewhere-classified").id
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
                         industry_code_raw: industry_code_raw,
                         industry_code_id: industry_code_id,
                         occupation_code_id: occupation_code_id,
                         geo_code_raw: geo_code_raw,
                         geo_code_id: geo_code_id
                         )
    end
    Series.load(list)
  end

end
