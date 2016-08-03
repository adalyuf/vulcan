class Source < ActiveRecord::Base
  has_many :datasets, inverse_of: :source, dependent: :destroy
  accepts_nested_attributes_for :datasets
end
