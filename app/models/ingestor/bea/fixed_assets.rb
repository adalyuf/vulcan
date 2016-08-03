class Ingestor::Bea::FixedAssets < Ingestor::Bea

  def fetch
    if has_options?
      @api_response = self.class.get(url, query: query)
      write_to_json
    else
      external_tables.each_with_index do |table, index|
        self.class.new(dataset, year: query[:year], tableid: table.external_id).fetch
      end
    end
  end

  def query
    unless defined?(@query)
      @query = defaults.merge(options)
    end
    @query
  end

  def defaults
    { userid: api_key, method: 'getData', datasetname: DATASET_NAME[dataset], year: ALL_VALUES[:year], resultformat: 'JSON' }
  end

  def has_options?
    options[:tableid]
  end
end
