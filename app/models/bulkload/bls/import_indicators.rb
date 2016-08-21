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
  IMPORTERS = [
    Bulkload::Bls::ImportIndicators::Ap,
    Bulkload::Bls::ImportIndicators::Bd
  ]

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

  def import_all
    IMPORTERS.each do |klass|
      importer = klass.new
      importer.import_indicators
      importer.import_series
    end

    self.class.setup_values_partitions
  end

  def indicators_by_name
    @indicators_by_name ||= Hash[Indicator.all.map { |i| [i.name, i] }]
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

end