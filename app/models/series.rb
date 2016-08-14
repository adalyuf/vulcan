class Series < ActiveRecord::Base
  belongs_to :indicator
  belongs_to :frequency
  belongs_to :unit
  has_many :values

  validates :name, presence: true
  validates :description, presence: true
  validates :multiplier, presence: true
  validates :indicator, presence: true
  validates :frequency, presence: true
  validates :unit, presence: true
end