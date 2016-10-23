class GeoCode < ActiveRecord::Base
  has_many :series

  validates :name, presence: true
  validates :internal_name, presence: true
  validates :internal_name, uniqueness: true

  def display_name
    if internal_name == "not_specified"
      nil
    elsif short_name
      short_name
    else
      name
    end
  end

  def self.not_specified
    @not_specified ||= find_by(internal_name: 'not_specified')
  end
end
