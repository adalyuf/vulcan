require 'open-uri'
require 'fileutils'
require 'csv'

class Bulkload::Bls::ImportValues
# I'm on update_series branch

  SOURCE = "BLS"
  QUARTER_TO_MONTH = {
    1 => 1,
    2 => 4,
    3 => 7,
    4 => 10,
    5 => nil
  }

  def storage
    @storage ||= SystemConfig.instance.services.bls.storage
  end

  def import_values(dept)
    Dir["#{ storage }/#{ SOURCE }/values/#{ dept }/*"].each_with_index do |file, index| #For example: /Users/alexdaly/Documents/file_downloads/BLS/values/ap/*
      parsed_file = CSV.read(file, { :col_sep => "\t" })
      parsed_file.shift
      list = prepare_values(parsed_file)
      persist_values(list)
    end
  end

  def prepare_values(parsed_file)
    now = Time.now
    #Syntax: Map the columns from parsed_file to the columns in values using the formula given.
    parsed_file.map do |series_id, year, period, value,  footnote_codes|
      created_at = now
      updated_at = now

      raw_name = series_id.strip
      raw_year = year.strip.to_i
      raw_period = period.strip
      raw_value = value.strip

      date = parse_bls_date(raw_year, raw_period)

      series = series_by_name[raw_name]
      value = value.strip.to_f * (10**series.multiplier)
      series_id = series.id
      indicator_id = series.indicator_id

      [raw_name, raw_year, raw_period, raw_value, date, value, created_at, updated_at, series_id, indicator_id]
    end
  end

  def parse_bls_date(year, period)
    period_type = period[0]
    period_value = period[1..2].to_i

    month =
      case period_type
      when 'A'
        1
      when 'Q'
        QUARTER_TO_MONTH[period_value]
      when 'M'
        period_value > 12 ? nil : period_value
      end

    # What to do when quarter is 5, aka an annual average?
    # What to do when month is 13, aka an annual average?
    month ? Date.new(year, month, 1) : nil
  end

  def persist_values(list)
    if list.size > 0
      list.in_groups_of(10_000, false) do |sublist|
        sublist_by_indicator = sublist.group_by(&:last)
        sublist_by_indicator.each_pair do |indicator_id, data|
          sql_start = "INSERT INTO values_partitions.p#{indicator_id}
            (raw_name, raw_year, raw_period, raw_value, date, value, created_at, updated_at, series_id, indicator_id) VALUES "
          sql_end = " ON CONFLICT DO NOTHING"
          now = Time.now
          sql_values = sql_start

          # data.in_groups_of(1000, false) do |group|
          data.each do |row|
            row_values = ActiveRecord::Base.send :sanitize_sql_array, ['(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9] ]
            row_values << ','
            sql_values << row_values
          end

          sql_values = sql_values.chomp(',')
          sql_values << sql_end

          ActiveRecord::Base.connection.execute(sql_values)
          # sql_values = sql_start
          # end
        end
      end
    end
  end

  def series_by_name
    @series_by_name ||= Hash[Series.all.map { |s| [s.name, s] }]
  end
end