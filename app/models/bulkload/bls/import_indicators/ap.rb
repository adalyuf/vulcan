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

    gender_id = Gender.find_by(name: "Not specified").id
    race_id = Race.find_by(name: "Not specified").id
    marital_id = Marital.find_by(name: "Not specified").id
    age_id = Age.find_by(name: "Not specified").id
    employment_id = Employment.find_by(name: "Not specified").id
    education_level_id = EducationLevel.find_by(name: "Not specified").id


    list = parsed_file.map do |series_id, area_code, item_code, footnote_codes, begin_year, begin_period, end_year, end_period|
      Series::Data.new(name: series_id.strip,
                       description: footnote_codes.strip.length > 0 ? footnote_codes.strip : nil,
                       multiplier: 0,
                       seasonally_adjusted: false,
                       unit_id: unit_id,
                       frequency_id: frequency_id,
                       indicator_id: indicators_by_name[item_code.strip].id,
                       gender_id: gender_id,
                       race_id: race_id,
                       marital_id: marital_id,
                       age_id: age_id,
                       employment_id: employment_id,
                       education_level_id: education_level_id
                       )
    end
    Series.load(list)
  end
end
