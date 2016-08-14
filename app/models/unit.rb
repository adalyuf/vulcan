class Unit < ActiveRecord::Base
  has_many :series

  validates :name, presence: true
  validates :description, presence: true
end