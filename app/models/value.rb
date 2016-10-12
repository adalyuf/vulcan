class Value < ActiveRecord::Base
  belongs_to :series
  belongs_to :indicator

  def self.get_values(indicator_id, series_ids=nil)
    if series_ids
      series_ids = Array.wrap(series_ids).join(',')

      self.find_by_sql("select * from values_partitions.p#{ indicator_id } where series_id in (#{ series_ids })")
    else
      self.find_by_sql("select * from values_partitions.p#{ indicator_id }")
    end
  end

end