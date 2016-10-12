class EmploymentStatus < ActiveRecord::Base
  has_many :series

  validates :name, presence: true
  validates :internal_name, presence: true
  validates :internal_name, uniqueness: true

  def display_name
    internal_name == "not-specified" ? nil : name
  end

  def self.not_specified
    @not_specified ||= find_by(internal_name: 'not-specified')
  end
end