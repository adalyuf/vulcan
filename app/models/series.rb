class Series < ActiveRecord::Base
  belongs_to :indicator
  belongs_to :frequency
  belongs_to :unit
  has_many :values

  validates :name, presence: true
  validates :multiplier, presence: true
  validates :indicator, presence: true
  validates :frequency, presence: true
  validates :unit, presence: true

  class Data < HashModel
    attr_accessor :name,
                  :description,
                  :multiplier,
                  :seasonally_adjusted,
                  :unit_id,
                  :frequency_id,
                  :created_at,
                  :updated_at,
                  :indicator_id,
                  :gender_raw,
                  :gender_id,
                  :race_raw,
                  :race_id
  end

  def self.load(data)
    if data.size > 0
      sql_start = "INSERT INTO series (name, description, multiplier, seasonally_adjusted, unit_id, frequency_id, created_at, updated_at, indicator_id, gender_raw, gender_id, race_raw, race_id) VALUES "
      sql_end = " ON CONFLICT DO NOTHING"
      now = Time.now
      sql_values = sql_start

      data.in_groups_of(1000, false) do |group|
        group.each do |row|
          row_values =
            ActiveRecord::Base.send :sanitize_sql_array, ['(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', row.name, row.description, row.multiplier, row.seasonally_adjusted, row.unit_id, row.frequency_id, now, now, row.indicator_id, row.gender_raw, row.gender_id, row.race_raw, row.race_id]
          row_values << ','
          sql_values << row_values
        end
        sql_values = sql_values.chomp(',')
        sql_values << sql_end

        ActiveRecord::Base.connection.execute(sql_values)
        sql_values = sql_start
      end
    end
  end
end
