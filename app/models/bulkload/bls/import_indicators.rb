#Crawl the BLS folder structure and extract files
require 'open-uri'
require 'fileutils'
require 'csv'

class Bulkload::Bls::ImportIndicators
  include Bulkload::PartitionsExtension

  SOURCE = "BLS"
  SEASONAL = {
    'S' => true,
    'U' => false
  }

  def self.setup_values_partitions
    create_schemas
    create_triggers
    create_value_partitions
  end

  def url
    @url ||= SystemConfig.instance.services.bls.url
  end

  def storage
    @storage ||= SystemConfig.instance.services.bls.storage
  end

  def import_indicators
    ap_indicators
    bd_indicators
    ap_series
    bd_series
    self.class.setup_values_partitions
  end

  def import(obj, dept, filename)
    FileUtils.mkdir_p("#{ storage }/#{ SOURCE }/#{ obj }/#{ dept }")
    path = "#{ storage }/#{ SOURCE }/#{ obj }/#{ dept }/#{ filename }.txt"
    file = File.new(path, "w")
    download = open(url+'/'+dept+'/'+filename)
    IO.copy_stream(download, file)
    file.close
  end

#-----------------------------------------------------------------------------
#--------------------- Method of inserting indicators and series -------------
#-----------------------------------------------------------------------------

  def persist_series(list)
    if list.size > 0
      sql_start = "INSERT INTO series (name, description, multiplier, seasonally_adjusted, unit_id, frequency_id, created_at, updated_at, indicator_id) VALUES "
      sql_end = " ON CONFLICT DO NOTHING"
      now = Time.now
      sql_values = sql_start

      list.in_groups_of(1000, false) do |group|
        group.each do |row|
          row_values = ActiveRecord::Base.send :sanitize_sql_array, ['(?, ?, ?, ?, ?, ?, ?, ?, ?)', row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8] ]
          row_values << ','
          sql_values << row_values
        end
        sql_values = sql_values.chomp(',')
        sql_values << sql_end

        ActiveRecord::Base.connection.execute(sql_values)
        sql_values = sql_start
      end
    end
  end

  def persist_indicators(list)
    if list.size > 0
      sql_start = "INSERT INTO indicators (name, description, created_at, updated_at) VALUES "
      sql_end = " ON CONFLICT DO NOTHING"
      now = Time.now
      sql_values = sql_start

      list.in_groups_of(1000, false) do |group|
        group.each do |row|
          row_values = ActiveRecord::Base.send :sanitize_sql_array, ['(?, ?, ?, ?)', row[0], row[1], now, now]
          row_values << ','
          sql_values << row_values
        end
        sql_values = sql_values.chomp(',')
        sql_values << sql_end

        ActiveRecord::Base.connection.execute(sql_values)
        sql_values = sql_start
      end
    end
  end

#-----------------------------------------------------------------------------
#-------------------- Individual definitions for each department -------------
#-----------------------------------------------------------------------------

  def parse_file(obj, dept, filename)
    import(obj, dept, filename)
    path = "#{ storage }/#{ SOURCE }/#{ obj }/#{ dept }/#{ filename }.txt"
    parsed_file = CSV.read(path, { :col_sep => "\t" })
    parsed_file.shift
    parsed_file
  end

  def ap_indicators
    parsed_file = parse_file("indicators", "ap", "ap.item")

    list = parsed_file.map do |code, description|
      [code.strip, description.strip]
    end
    persist_indicators(list)
  end

  def bd_indicators
    parsed_file = parse_file("indicators", "bd", "bd.series")

    list = parsed_file.map do |series_id, seasonal, msa_code, state_code, county_code,  industry_code,  unitanalysis_code,  dataelement_code, sizeclass_code, dataclass_code, ratelevel_code, periodicity_code, ownership_code, series_title, footnote_codes, begin_year, begin_period, end_year, end_period|
      [series_title.strip, series_title.strip]
    end.uniq
    persist_indicators(list)
  end

  def indicators_by_name
    @indicators_by_name ||= Hash[Indicator.all.map { |i| [i.name, i] }]
  end

  def ap_series
    parsed_file = parse_file("series", "ap", "ap.series")

    now = Time.now
    unit_id = Unit.find_by(name: "Nominal US Dollars").id
    frequency_id = Frequency.find_by(name: "Monthly").id

    list = parsed_file.map do |series_id, area_code, item_code, footnote_codes, begin_year, begin_period, end_year, end_period|
      name = series_id.strip
      description = footnote_codes.strip
      multiplier = 1
      seasonally_adjusted = false

      created_at = now
      updated_at = now
      indicator_id = indicators_by_name[item_code.strip].id

      [name, description, multiplier, seasonally_adjusted, unit_id, frequency_id, created_at, updated_at, indicator_id]
    end
    persist_series(list)
  end

  def bd_series
    parsed_file = parse_file("series", "bd", "bd.series")

    now = Time.now
    jobs_unit_id = Unit.find_by( name: "Jobs").id
    percent_unit_id = Unit.find_by( name: "Percent").id
    establishments_unit_id = Unit.find_by( name: "Establishments").id
    annual_frequency_id = Frequency.find_by(name: "Annual").id
    quarterly_frequency_id = Frequency.find_by(name: "Quarterly").id

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
        multiplier = 1
        seasonally_adjusted = SEASONAL[seasonal.strip]

        created_at = now
        updated_at = now

        [name, description, multiplier, seasonally_adjusted, unit_id, frequency_id, created_at, updated_at, indicator_id]
    end
    persist_series(list)
  end
end