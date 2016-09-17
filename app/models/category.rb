class Category < ActiveRecord::Base
  has_many :indicators
  has_many :datasets

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :internal_name, presence: true
  validates :internal_name, uniqueness: true
end