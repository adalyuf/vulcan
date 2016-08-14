class Ingestor::Bea::Nipa < Ingestor::Bea

  REQUIRED_OPTIONS = [
    :year,
    :tableid,
    :frequency
  ]

  self.dataset = :nipa

  def fetch
    if can_fetch?
      fetch_api_data
    else
      raise InvalidQueryError, "query options must include: #{ REQUIRED_OPTIONS }" unless fetch_all?
      external_tables.each_with_index do |table, index|
        FREQUENCY.values.each do |frequency|
          self.class.new(year: query[:year], tableid: table.external_id.to_i, frequency: frequency).fetch
        end
      end
    end
  end

  def defaults
    { userid: api_key, method: 'getData', datasetname: DATASET_NAME[dataset], frequency: FREQUENCY[:annual], year: ALL_VALUES[:year], showmillions: SHOW_MILLIONS[:no], resultformat: 'JSON' }
  end

  def can_fetch?
    !! options[:tableid] && !! options[:frequency]
  end
end
