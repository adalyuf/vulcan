class Indicator < ActiveRecord::Base
  has_many :series
  has_many :values

  validates :name, presence: true
  validates :description, presence: true
end


