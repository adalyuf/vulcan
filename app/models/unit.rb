class Unit < ActiveRecord::Base
  has_many :series

  validates :name, presence: true
  validates :internal_name, presence: true
  validates :internal_name, uniqueness: true
end