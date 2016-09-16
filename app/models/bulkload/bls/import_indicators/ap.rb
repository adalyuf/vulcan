class Bulkload::Bls::ImportIndicators::Ap < Bulkload::Bls::ImportIndicators

  REGION_RAW = {
    '0000' => 'U.S. city average',
    '0100' => 'Northeast urban',
    '0200' => 'Midwest urban',
    '0300' => 'South urban',
    '0400' => 'West urban',
    'A000' => 'City size A',
    'A100' => 'Northeast Size A',
    'A101' => 'New York-Northern New Jersey-Long Island, NY-NJ-CT-PA',
    'A102' => 'Philadelphia-Wilmington-Atlantic City, PA-NJ-DE-MD',
    'A103' => 'Boston-Brockton-Nashua, MA-NH-ME-CT',
    'A104' => 'Pittsburgh, PA',
    'A105' => 'Buffalo-Niagara Falls, NY',
    'A106' => 'Scranton, PA',
    'A200' => 'Midwest Size A',
    'A207' => 'Chicago-Gary-Kenosha, IL-IN-WI',
    'A208' => 'Detroit-Ann Arbor-Flint, MI',
    'A209' => 'St. Louis, MO-IL',
    'A210' => 'Cleveland-Akron, OH',
    'A211' => 'Minneapolis-St. Paul, MN-WI',
    'A212' => 'Milwaukee-Racine, WI',
    'A213' => 'Cincinnati-Hamilton, OH-KY-IN',
    'A214' => 'Kansas City, MO-KS',
    'A300' => 'South Size A',
    'A311' => 'Washington-Baltimore, DC-MD-VA-WV',
    'A315' => 'Washington, DC-MD-VA',
    'A316' => 'Dallas-Fort Worth, TX',
    'A317' => 'Baltimore, MD',
    'A318' => 'Houston-Galveston-Brazoria, TX',
    'A319' => 'Atlanta, GA',
    'A320' => 'Miami-Fort Lauderdale, FL',
    'A400' => 'West Size A',
    'A421' => 'Los Angeles-Riverside-Orange County, CA',
    'A422' => 'San Francisco-Oakland-San Jose, CA',
    'A423' => 'Seattle-Tacoma-Bremerton, WA',
    'A424' => 'San Diego, CA',
    'A425' => 'Portland-Salem, OR-WA',
    'A426' => 'Honolulu, HI',
    'A427' => 'Anchorage, AK',
    'A433' => 'Denver-Boulder-Greeley, CO',
    'B000' => 'City size B',
    'B100' => 'Northeast size B',
    'B200' => 'North Central size B',
    'B300' => 'South size B',
    'B400' => 'West size B',
    'C000' => 'City size C',
    'C100' => 'Northeast size C',
    'C200' => 'North Central size C',
    'C300' => 'South size C',
    'C400' => 'West size C',
    'D000' => 'City size D',
    'D100' => 'Northeast size D',
    'D200' => 'Midwest Size D',
    'D300' => 'South Size D',
    'D400' => 'West size D',
    'X000' => 'City size B/C',
    'X100' => 'Northeast Size B/C',
    'X200' => 'Midwest Size B/C',
    'X300' => 'South Size B/C',
    'X400' => 'West Size B/C'
  }

  def region(area_code)
    case area_code

    when "0000"
      geo_by_internal_name['united-states'].id

    when "0100"
      geo_by_internal_name['northeast'].id
    when "0200"
      geo_by_internal_name['midwest'].id
    when "0300"
      geo_by_internal_name['southeast'].id
    when "0400"
      geo_by_internal_name['westcoast'].id
    when 'A101'
      csa_by_short_name['New York, NY'].id
    when 'A102'
      csa_by_short_name['Philadelphia, PA'].id
    when 'A103'
      csa_by_short_name['Boston, MA'].id
    when 'A104'
      csa_by_short_name['Pittsburgh, PA'].id
    when 'A105'
      csa_by_short_name['Buffalo, NY'].id
    when 'A207'
      csa_by_short_name['Chicago, IL'].id
    when 'A208'
      csa_by_short_name['Detroit, MI'].id
    when 'A209'
      csa_by_short_name['St. Louis, MO'].id
    when 'A210'
      csa_by_short_name['Cleveland, OH'].id
    when 'A211'
      csa_by_short_name['Minneapolis, MN'].id
    when 'A212'
      csa_by_short_name['Milwaukee, WI'].id
    when 'A213'
      csa_by_short_name['Cincinnati, OH'].id
    when 'A214'
      csa_by_short_name['Kansas City, MO'].id
    when 'A311'
      csa_by_short_name['Washington, DC'].id
    when 'A315'
      csa_by_short_name['Washington, DC'].id
    when 'A316'
      csa_by_short_name['Dallas, TX'].id
    when 'A317'
      csa_by_short_name['Washington, DC'].id
    when 'A318'
      csa_by_short_name['Houston, TX'].id
    when 'A319'
      csa_by_short_name['Atlanta, GA'].id
    when 'A320'
      csa_by_short_name['Miami, FL'].id
    when 'A421'
      csa_by_short_name['Los Angeles, CA'].id
    when 'A422'
      csa_by_short_name['San Francisco, CA'].id
    when 'A423'
      csa_by_short_name['Seattle, WA'].id
    when 'A425'
      csa_by_short_name['Portland, OR'].id
    when 'A433'
      csa_by_short_name['Denver, CO'].id

    else
      geo_by_internal_name['not-elsewhere-classified'].id
    end
  end

  def import_indicators
    parsed_file = Bulkload::Bls::FileManager.new("indicators", "ap", "ap.item").parsed_file
    source_id = Source.find_by(internal_name: "bureau-labor-statistics").id
    # These indicators reflect the average price of goods in various cities. Classifying this as Business
    category_id = Category.find_by(internal_name: :business).id
    dataset_id = Dataset.find_by(internal_name: "bls-average-prices").id

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

    unit_id = Unit.find_by(internal_name: "nominal-us-dollars").id
    frequency_id = Frequency.find_by(internal_name: :"monthly").id

    gender_id = Gender.find_by(internal_name: "not-specified").id
    race_id = Race.find_by(internal_name: "not-specified").id
    marital_status_id = MaritalStatus.find_by(internal_name: "not-specified").id
    age_bracket_id = AgeBracket.find_by(internal_name: "not-specified").id
    employment_status_id = EmploymentStatus.find_by(internal_name: "not-specified").id
    education_level_id = EducationLevel.find_by(internal_name: "not-specified").id
    child_status_id = ChildStatus.find_by(internal_name: "not-specified").id
    income_level_id = IncomeLevel.find_by(internal_name: "not-specified").id
    industry_code_id = IndustryCode.find_by(internal_name: "not-specified").id
    occupation_code_id = OccupationCode.find_by(internal_name: "not-specified").id

    list = parsed_file.map do |series_id, area_code, item_code, footnote_codes, begin_year, begin_period, end_year, end_period|
      footnote_codes = footnote_codes.strip
      description = footnote_codes.length > 0 ? footnote_codes : nil

      name = series_id.strip
      internal_name = name
      source_identifier = name
      indicator_id = indicators_by_source_identifier[item_code.strip].id
      geo_code_id = region(area_code)
      geo_code_raw = REGION_RAW[area_code]

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
