class Dashboard < ApplicationRecord
  belongs_to :user
  has_many :dashboard_items
end