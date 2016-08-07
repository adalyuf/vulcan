class Ingestor::Bea::FixedAssets < Ingestor::Bea

  REQUIRED_OPTIONS = [
    :year,
    :tableid
  ]

  self.dataset = :fixed_assets

  def fetch
    if can_fetch?
      fetch_api_data
    else
      raise InvalidQueryError, "query options must include: #{ REQUIRED_OPTIONS }" unless fetch_all?
      external_tables.each_with_index do |table, index|
        self.class.new(year: query[:year], tableid: table.external_id.to_i).fetch
      end
    end
  end

  def defaults
    { userid: api_key, method: 'getData', datasetname: DATASET_NAME[dataset], year: ALL_VALUES[:year], resultformat: 'JSON' }
  end

  def can_fetch?
    !! options[:tableid]
  end
end
