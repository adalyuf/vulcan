class Ingestor::Bea
  include HTTParty

  class InvalidQueryError < Error; end

  attr_accessor :options, :api_response

  class_attribute :data_logger, :dataset

  self.data_logger = DataLog.new('bea.log')

  LOG_COLUMNS = [
    :options,
    :api_response_code,
    :api_error
  ]

  BEA_DIR = Rails.root.join('app', 'data', 'bea')

  ALL_VALUES = {
    year: 'X'
  }

  DATASET_NAME = {
    fixed_assets: 'FixedAssets',
    nipa: 'NIPA',
    regional_data: 'RegionalData'
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

  def initialize(opts={})
    @options = opts
  end

  def dataset
    self.class.dataset
  end

  def parameters
    self.class.get(url, { query: { userid: api_key, method: 'GetParameterList', datasetname: DATASET_NAME[dataset] } })
  end

  def query
    unless defined?(@query)
      @query = defaults.merge(options)
    end
    @query
  end

  def fetch_all?
    !! options[:all]
  end

  def fetch_api_data
    @api_response = self.class.get(url, query: query)
    write_to_json
  end

  def write_to_json
    FileUtils.mkdir_p(series_dir) unless File.exists?(series_dir)
    File.open("#{ series_dir }/#{ SimpleUUID::UUID.new.to_guid }.json", 'wb+') { |f| f.write api_response.body }
    data_logger.log(*log_columns)
  end

  def series_dir
    "#{ BEA_DIR }/#{ dataset }/#{ options[:tableid] }/#{ options[:year] }"
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

  def log_columns
    LOG_COLUMNS.map { |c| send(c) }
  end

  def api_response_code
    api_response.code
  end

  def api_error
    api_response["BEAAPI"]["Error"]
  end
end
