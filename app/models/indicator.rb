class Indicator < ActiveRecord::Base
  include PgSearch

  pg_search_scope(
    :search,
    against: %i(
      name
      description
    ),
    using: {
      tsearch: {
        tsvector_column: "tsv",
        dictionary: "english"
      },
      trigram: {
        threshold: 0.1
      }
    }
  )

  has_many :series
  has_many :values
  has_many :dashboard_items

  belongs_to :source
  validates :source, presence: true

  belongs_to :category
  validates :category, presence: true

  belongs_to :dataset
  validates :dataset, presence: true

  validates :name, presence: true
  validates :internal_name, presence: true
  validates :internal_name, uniqueness: true

  class Data < HashModel
    attr_accessor :name,
                  :description,
                  :internal_name,
                  :source_identifier,
                  :source_id,
                  :category_id,
                  :dataset_id
  end

  def self.load(data)
    if data.size > 0
      sql_start = "INSERT INTO indicators (name, description, created_at, updated_at, source_id, category_id, dataset_id, internal_name, source_identifier) VALUES "
      sql_end = " ON CONFLICT DO NOTHING"
      now = Time.now
      sql_values = sql_start

      data.in_groups_of(1000, false) do |group|
        group.each do |row|
          row_values = ActiveRecord::Base.send :sanitize_sql_array, ['(?, ?, ?, ?, ?, ?, ?, ?, ?)', row.name, row.description, now, now, row.source_id, row.category_id, row.dataset_id, row.internal_name, row.source_identifier]
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

  def display_data
    values = Value.where(indicator_id: self.id)
    series = Series.where(indicator_id: self.id)

    grouped_values = values.group_by(&:series_id)
    data = series.map do |serie|
      {
        :name => serie.display_name,
        :data => Hash[grouped_values[serie.id].map{ |value| [value.date, value.value] }]
      }
    end
  end

end


