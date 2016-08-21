class Indicator < ActiveRecord::Base
  has_many :series
  has_many :values

  validates :name, presence: true
  validates :description, presence: true

  class Data < HashModel
    attr_accessor :name,
                  :description
  end

  def self.load(data)
    if data.size > 0
      sql_start = "INSERT INTO indicators (name, description, created_at, updated_at) VALUES "
      sql_end = " ON CONFLICT DO NOTHING"
      now = Time.now
      sql_values = sql_start

      data.in_groups_of(1000, false) do |group|
        group.each do |row|
          row_values = ActiveRecord::Base.send :sanitize_sql_array, ['(?, ?, ?, ?)', row.name, row.description, now, now]
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


