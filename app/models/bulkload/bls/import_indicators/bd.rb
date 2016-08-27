class Bulkload::Bls::ImportIndicators::Bd < Bulkload::Bls::ImportIndicators

  def import_indicators
    parsed_file = Bulkload::Bls::FileManager.new("indicators", "bd", "bd.series").parsed_file

    uniq_series = Set.new

    # ensure all series titles are unique
    parsed_file.each do |series_id, seasonal, msa_code, state_code, county_code,  industry_code,  unitanalysis_code,  dataelement_code, sizeclass_code, dataclass_code, ratelevel_code, periodicity_code, ownership_code, series_title, footnote_codes, begin_year, begin_period, end_year, end_period|
      uniq_series << series_title.strip
    end

    list = uniq_series.map do |series_title|
      Indicator::Data.new(name: series_title,
                          description: series_title
                          )
    end

    Indicator.load(list)
  end

  def import_series
    parsed_file = Bulkload::Bls::FileManager.new("series", "bd", "bd.series").parsed_file

    jobs_unit_id = Unit.find_by( name: "Jobs").id
    percent_unit_id = Unit.find_by( name: "Percent").id
    establishments_unit_id = Unit.find_by( name: "Establishments").id
    annual_frequency_id = Frequency.find_by(name: "Annual").id
    quarterly_frequency_id = Frequency.find_by(name: "Quarterly").id

    gender_id = Gender.find_by(name: "Not specified").id
    race_id = Race.find_by(name: "Not specified").id
    marital_id = Marital.find_by(name: "Not specified").id
    age_id = Age.find_by(name: "Not specified").id
    employment_id = Employment.find_by(name: "Not specified").id
    education_level_id = EducationLevel.find_by(name: "Not specified").id
    child_status_id = ChildStatus.find_by(name: "Not specified").id
    income_level_id = IncomeLevel.find_by(name: "Not specified").id


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

        Series::Data.new(name: series_id.strip,
                         description: nil,
                         multiplier: 0,
                         seasonally_adjusted: SEASONAL[seasonal.strip],
                         unit_id: unit_id,
                         frequency_id: frequency_id,
                         indicator_id: indicators_by_name[series_title.strip].id,
                         gender_id: gender_id,
                         race_id: race_id,
                         marital_id: marital_id,
                         age_id: age_id,
                         employment_id: employment_id,
                         education_level_id: education_level_id,
                         child_status_id: child_status_id,
                         income_level_id: income_level_id
                         )
    end
    Series.load(list)
  end

end
