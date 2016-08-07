class Ingestor::Bea::RegionalData < Ingestor::Bea
  ALL_VALUES = {
    year: 'ALL',
    geofips: 'STATE'
  }

  GEOFIPS = {
    state: 'STATE',
    county: 'COUNTY',
    msa: 'MSA'
  }

  REQUIRED_OPTIONS = [
    :year,
    :keycode,
    :geofips
  ]

  self.dataset = :regional_data

  def fetch
    if can_fetch?
      fetch_api_data
    else
      raise InvalidQueryError, "query options must include: #{ REQUIRED_OPTIONS }" unless fetch_all?
      external_tables.each_with_index do |table, index|
        GEOFIPS.values.each do |geo|
          puts "keycode: #{table.external_id}, geofips: #{geo}"
          self.class.new(year: query[:year], keycode: table.external_id, geofips: geo).fetch
        end
      end
    end
  end

  def defaults
    { userid: api_key, method: 'getData', datasetname: DATASET_NAME[dataset], year: ALL_VALUES[:year], keycode: 'keycode', geofips: ALL_VALUES[:geofips], resultformat: 'JSON' }
  end

  def can_fetch?
    !! options[:keycode] && !! options[:geofips]
  end

  def series_dir
    "#{ BEA_DIR }/#{ dataset }/#{ options[:keycode] }/#{ options[:year] }"
  end
end
