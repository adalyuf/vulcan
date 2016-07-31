class ExternalTable < ActiveRecord::Base
  belongs_to :dataset, inverse_of: :external_tables
end
