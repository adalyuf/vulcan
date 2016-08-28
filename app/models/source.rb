class Source < ActiveRecord::Base
  has_many :datasets, inverse_of: :source, dependent: :destroy
  accepts_nested_attributes_for :datasets

  has_many :indicators

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :internal_name, presence: true
  validates :internal_name, uniqueness: true

end
