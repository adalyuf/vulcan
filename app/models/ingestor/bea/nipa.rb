class Ingestor::Bea::Nipa < Ingestor::Bea

  def fetch
    if has_options?
      @api_response = self.class.get(url, query: query)
      write_to_json
    else
      external_tables.each_with_index do |table, index|
        FREQUENCY.values.each do |frequency|
          self.class.new(dataset, year: query[:year], tableid: table.external_id, frequency: frequency).fetch
        end
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
    { userid: api_key, method: 'getData', datasetname: DATASET_NAME[dataset], frequency: FREQUENCY[:annual], year: ALL_VALUES[:year], resultformat: 'JSON', showmillions: SHOW_MILLIONS[:no] }
  end

  def has_options?
    options[:tableid] && options[:frequency]
  end
end
