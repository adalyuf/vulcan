class Category < ActiveRecord::Base
  has_many :indicators

  validates :name, presence: true
  validates :name, uniqueness: true
end