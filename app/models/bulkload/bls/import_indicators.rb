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

  def indicators_by_source_identifier
    @indicators_by_source_identifier ||= Hash[Indicator.all.map { |i| [i.source_identifier, i] }]
  end

end
