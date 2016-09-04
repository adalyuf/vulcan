class Series < ActiveRecord::Base
  has_many :values

  belongs_to :indicator
  belongs_to :frequency
  belongs_to :unit
  belongs_to :gender
  belongs_to :race
  belongs_to :marital_status #marital_status
  belongs_to :age_bracket #age_bracket
  belongs_to :employment_status #employment_status
  belongs_to :education_level
  belongs_to :child_status
  belongs_to :income_level
  belongs_to :industry_code
  belongs_to :occupation_code #occupation_code
  belongs_to :geo_code

  validates :name, presence: true

  validates :indicator, presence: true
  validates :multiplier, presence: true
  validates :frequency, presence: true
  validates :unit, presence: true
  validates :gender, presence: true
  validates :race, presence: true
  validates :marital_status, presence: true
  validates :age_bracket, presence: true
  validates :employment_status, presence: true
  validates :education_level, presence: true
  validates :child_status, presence: true
  validates :income_level, presence: true
  validates :industry_code, presence: true
  validates :occupation_code, presence: true
  validates :geo_code, presence: true

  class Data < HashModel
    attr_accessor :name,
                  :description,
                  :internal_name,
                  :source_identifier,
                  :multiplier,
                  :seasonally_adjusted,
                  :unit_id,
                  :frequency_id,
                  :indicator_id,
                  :gender_raw,
                  :gender_id,
                  :race_raw,
                  :race_id,
                  :marital_status_raw,
                  :marital_status_id,
                  :age_bracket_raw,
                  :age_bracket_id,
                  :employment_status_raw,
                  :employment_status_id,
                  :education_level_raw,
                  :education_level_id,
                  :child_status_raw,
                  :child_status_id,
                  :income_level_raw,
                  :income_level_id,
                  :industry_code_raw,
                  :industry_code_id,
                  :occupation_code_raw,
                  :occupation_code_id,
                  :geo_code_raw,
                  :geo_code_id

  end

  def self.load(data)
    if data.size > 0
      sql_start = "INSERT INTO series (name, description, multiplier, seasonally_adjusted, unit_id, frequency_id, created_at, updated_at, indicator_id, gender_raw, gender_id, race_raw, race_id, marital_status_raw, marital_status_id, age_bracket_raw, age_bracket_id, employment_status_raw, employment_status_id, education_level_raw, education_level_id, child_status_raw, child_status_id, income_level_raw, income_level_id, industry_code_raw, industry_code_id, occupation_code_raw, occupation_code_id, geo_code_raw, geo_code_id, internal_name, source_identifier) VALUES "
      sql_end = " ON CONFLICT DO NOTHING"
      now = Time.now
      sql_values = sql_start

      data.in_groups_of(1000, false) do |group|
        group.each do |row|
          row_values =
            ActiveRecord::Base.send :sanitize_sql_array, ['(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
             row.name, row.description, row.multiplier, row.seasonally_adjusted, row.unit_id, row.frequency_id, now, now, row.indicator_id, row.gender_raw, row.gender_id, row.race_raw, row.race_id, row.marital_status_raw, row.marital_status_id, row.age_bracket_raw, row.age_bracket_id, row.employment_status_raw, row.employment_status_id, row.education_level_raw, row.education_level_id, row.child_status_raw, row.child_status_id, row.income_level_raw, row.income_level_id, row.industry_code_raw, row.industry_code_id, row.occupation_code_raw, row.occupation_code_id, row.geo_code_raw, row.geo_code_id, row.internal_name, row.source_identifier]
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
