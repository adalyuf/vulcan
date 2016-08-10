class ExternalTable < ActiveRecord::Base
  belongs_to :dataset, inverse_of: :external_tables

  def self.batch_update(dataset_scope, data)
    transaction do
      scope = dataset_scope.external_tables
      active_table_ids = []

      data.each do |row|
        scope.where(external_id: row[:external_id]).first_or_initialize.tap do |external_table|
          active_table_ids << external_table.id

          external_table.external_name = row[:external_name]
          external_table.active = true
          external_table.save
        end
      end

      scope.where.not(id: active_table_ids).each do |external_table|
        external_table.active = false
        external_table.save
      end
    end
  end

  def self.active
    where(active: true)
  end
end
