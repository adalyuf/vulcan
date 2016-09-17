class Dataset < ActiveRecord::Base
  belongs_to :source, inverse_of: :datasets
  belongs_to :category, inverse_of: :datasets

  has_many :external_tables, inverse_of: :dataset, dependent: :destroy
  has_many :indicators

  accepts_nested_attributes_for :external_tables
  validates :internal_name, presence: true
  validates :internal_name, uniqueness: true
end
