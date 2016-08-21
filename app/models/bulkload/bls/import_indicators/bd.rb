class Bulkload::Bls::ImportIndicators::Bd < Bulkload::Bls::ImportIndicators

  def import_indicators
    parsed_file = Bulkload::Bls::FileManager.new("indicators", "bd", "bd.series").parsed_file

    list = parsed_file.map do |series_id, seasonal, msa_code, state_code, county_code,  industry_code,  unitanalysis_code,  dataelement_code, sizeclass_code, dataclass_code, ratelevel_code, periodicity_code, ownership_code, series_title, footnote_codes, begin_year, begin_period, end_year, end_period|
      [series_title.strip, series_title.strip]
    end.uniq
    persist_indicators(list)
  end

  def import_series
    parsed_file = Bulkload::Bls::FileManager.new("series", "bd", "bd.series").parsed_file

    now = Time.now
    jobs_unit_id = Unit.find_by( name: "Jobs").id
    percent_unit_id = Unit.find_by( name: "Percent").id
    establishments_unit_id = Unit.find_by( name: "Establishments").id
    annual_frequency_id = Frequency.find_by(name: "Annual").id
    quarterly_frequency_id = Frequency.find_by(name: "Quarterly").id

    gender_raw = nil
    gender_id = Gender.find_by(name: "Not specified").id
    race_raw = nil
    race_id = Race.find_by(name: "Not specified").id

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

        indicator_id = indicators_by_name[series_title.strip].id
        name = series_id.strip
        description = nil
        multiplier = 0
        seasonally_adjusted = SEASONAL[seasonal.strip]

        created_at = now
        updated_at = now

        [name, description, multiplier, seasonally_adjusted, unit_id, frequency_id, created_at, updated_at, indicator_id, gender_raw, gender_id, race_raw, race_id]
    end
    persist_series(list)
  end

end