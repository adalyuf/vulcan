class Bulkload::Bls::ImportIndicators::Ap < Bulkload::Bls::ImportIndicators

  def import_indicators
    parsed_file = Bulkload::Bls::FileManager.new("indicators", "ap", "ap.item").parsed_file

    list = parsed_file.map do |code, description|
      [code.strip, description.strip]
    end
    persist_indicators(list)
  end

  def import_series
    parsed_file = Bulkload::Bls::FileManager.new("series", "ap", "ap.series").parsed_file

    now = Time.now
    unit_id = Unit.find_by(name: "Nominal US Dollars").id
    frequency_id = Frequency.find_by(name: "Monthly").id

    list = parsed_file.map do |series_id, area_code, item_code, footnote_codes, begin_year, begin_period, end_year, end_period|
      name = series_id.strip
      description = footnote_codes.strip
      multiplier = 0
      seasonally_adjusted = false

      created_at = now
      updated_at = now
      indicator_id = indicators_by_name[item_code.strip].id

      [name, description, multiplier, seasonally_adjusted, unit_id, frequency_id, created_at, updated_at, indicator_id]
    end
    persist_series(list)
  end

end