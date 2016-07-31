class Dataset < ActiveRecord::Base
  belongs_to :source, inverse_of: :datasets
  has_many :external_tables, inverse_of: :dataset, dependent: :destroy

  accepts_nested_attributes_for :external_tables
end
