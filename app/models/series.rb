class Series < ActiveRecord::Base
  has_many :values

  belongs_to :indicator
  belongs_to :frequency
  belongs_to :unit
  belongs_to :gender
  belongs_to :race
  belongs_to :marital
  belongs_to :age
  belongs_to :employment
  belongs_to :education_level

  validates :name, presence: true

  validates :indicator, presence: true
  validates :multiplier, presence: true
  validates :frequency, presence: true
  validates :unit, presence: true
  validates :gender, presence: true
  validates :race, presence: true
  validates :marital, presence: true
  validates :age, presence: true
  validates :employment, presence: true
  validates :education_level, presence: true

  class Data < HashModel
    attr_accessor :name,
                  :description,
                  :multiplier,
                  :seasonally_adjusted,
                  :unit_id,
                  :frequency_id,
                  :indicator_id,
                  :gender_raw,
                  :gender_id,
                  :race_raw,
                  :race_id,
                  :marital_raw,
                  :marital_id,
                  :age_raw,
                  :age_id,
                  :employment_raw,
                  :employment_id,
                  :education_level_raw,
                  :education_level_id
  end

  def self.load(data)
    if data.size > 0
      sql_start = "INSERT INTO series (name, description, multiplier, seasonally_adjusted, unit_id, frequency_id, created_at, updated_at, indicator_id, gender_raw, gender_id, race_raw, race_id, marital_raw, marital_id, age_raw, age_id, employment_raw, employment_id, education_level_raw, education_level_id) VALUES "
      sql_end = " ON CONFLICT DO NOTHING"
      now = Time.now
      sql_values = sql_start

      data.in_groups_of(1000, false) do |group|
        group.each do |row|
          row_values =
            ActiveRecord::Base.send :sanitize_sql_array, ['(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
             row.name, row.description, row.multiplier, row.seasonally_adjusted, row.unit_id, row.frequency_id, now, now, row.indicator_id, row.gender_raw, row.gender_id, row.race_raw, row.race_id, row.marital_raw, row.marital_id, row.age_raw, row.age_id, row.employment_raw, row.employment_id, row.education_level_raw, row.education_level_id]
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
