class Ingestor::Bea
  include HTTParty

  attr_accessor :dataset, :options, :api_response

  BEA_DIR = Rails.root.join('app', 'data', 'bea')
  ALL_VALUES = {
    year: 'X'
  }

  DATASET_NAME = {
    fixed_assets: 'FixedAssets',
    nipa: 'NIPA'
  }

  FREQUENCY = {
    annual: 'A',
    quarterly: 'Q',
    monthly: 'M'
  }

  SHOW_MILLIONS = {
    no: 'N',
    yes: 'Y'
  }

  def initialize(dataset, opts={})
    @dataset = dataset
    @options =
      case dataset
      when :fixed_assets
        { query: { userid: api_key, method: 'getData', datasetname: DATASET_NAME[dataset], year: ALL_VALUES[:year], resultformat: 'JSON' } }
      when :nipa
        { query: { userid: api_key, method: 'getData', datasetname: DATASET_NAME[dataset], fequency: FREQUENCY[:annual], year: ALL_VALUES[:year], resultformat: 'JSON', showmillions: SHOW_MILLIONS[:no] } }
      end
    @options[:query].merge!(opts)
  end

  def parameters
    self.class.get(url, { query: { userid: api_key, method: 'GetParameterList', datasetname: DATASET_NAME[dataset] } })
  end

  def fetch
    if options[:query][:tableid]
      @api_response = self.class.get(url, options)
      write_to_json
    else
      external_tables.each_with_index do |table, index|
        puts "#{ index }: id: #{ table.id }, external_id: #{ table.external_id }"
        self.class.new(dataset, year: options[:query][:year], tableid: table.external_id).fetch
      end
    end
  end

  def write_to_json
    FileUtils.mkdir_p(series_dir) unless File.exists?(series_dir)
    File.open("#{ series_dir }/#{ SimpleUUID::UUID.new.to_guid }.json", 'wb+') { |f| f.write api_response.to_json }
  end

  def series_dir
    "#{ BEA_DIR }/#{ dataset }/#{ options[:query][:tableid] }/#{ options[:query][:year] }"
  end

  def url
    @url ||= SystemConfig.instance.services.bea.url
  end

  def api_key
    @api_key ||= SystemConfig.instance.services.bea.api_key
  end

  def external_tables
    @external_tables ||= Source.where(internal_name: :bea).first.datasets.where(internal_name: dataset).first.external_tables
  end
end
