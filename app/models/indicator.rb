class Indicator < ActiveRecord::Base
  has_many :series
  has_many :values

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
end


