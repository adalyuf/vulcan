class Bulkload::Bls::ImportIndicators::Ap < Bulkload::Bls::ImportIndicators

  def import_indicators
    parsed_file = Bulkload::Bls::FileManager.new("indicators", "ap", "ap.item").parsed_file

    list = parsed_file.map do |code, description|
      Indicator::Data.new(name: code.strip,
                          description: description.strip
                          )
    end
    Indicator.load(list)
  end

  def import_series
    parsed_file = Bulkload::Bls::FileManager.new("series", "ap", "ap.series").parsed_file

    unit_id = Unit.find_by(name: "Nominal US Dollars").id
    frequency_id = Frequency.find_by(name: "Monthly").id
    gender_raw = "No gender specified for this series"
    gender_id = Gender.find_by(name: "Not specified").id

    list = parsed_file.map do |series_id, area_code, item_code, footnote_codes, begin_year, begin_period, end_year, end_period|
      Series::Data.new(name: series_id.strip,
                       description: footnote_codes.strip,
                       multiplier: 0,
                       seasonally_adjusted: false,
                       unit_id: unit_id,
                       frequency_id: frequency_id,
                       indicator_id: indicators_by_name[item_code.strip].id,
                       gender_raw: gender_raw,
                       gender_id: gender_id
                       )
    end
    Series.load(list)
  end
end
