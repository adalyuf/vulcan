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

  def normalize_name(name)
    name = name.gsub(/\s*\(.+\)/, '')
    name = name.strip
  end

  def normalize_internal_name(internal_name)
    internal_name = internal_name.gsub(/\s*\(.+\)/, '')
    internal_name = internal_name.strip
    internal_name = internal_name.gsub(" ", "-")
    internal_name = internal_name.gsub(/[^a-zA-Z\d-]/,'')
    internal_name = internal_name.downcase
  end

  def indicators_by_name
    @indicators_by_name ||= Hash[Indicator.all.map { |i| [i.name, i] }]
  end

  def indicators_by_source_identifier
    @indicators_by_source_identifier ||= Hash[Indicator.all.map { |i| [i.source_identifier, i] }]
  end

  def industry_by_internal_name
    @industry_by_internal_name ||= Hash[IndustryCode.all.map{ |i| [i.internal_name, i] } ]
  end

  def industry_by_naics_code
    @industry_by_naics_code ||= Hash[IndustryCode.all.map{ |i| [i.naics_code, i] } ]
  end

  def geo_by_internal_name
    @geo_by_internal_name ||= Hash[ GeoCode.all.map { |g| [g.internal_name, g] } ]
  end

  def unit_by_internal_name
    @unit_by_internal_name ||= Hash[ Unit.all.map { |u| [u.internal_name, u] } ]
  end

  def csa_by_short_name
    @csa_by_short_name ||= Hash[ GeoCode::Csa.all.map { |g| [g.short_name, g] } ]
  end

  def geo_by_fips_code
    @geo_by_fips_code ||= Hash[ GeoCode.all.map { |g| [g.fips_code, g] } ]
  end

  def series_by_source_identifier
    @series_by_source_identifier ||= Hash[ Series.all.map { |s| [s.source_identifier, s] } ]
  end

end
