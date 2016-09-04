class GeoCode < ActiveRecord::Base
  has_many :series

  validates :name, presence: true
end
