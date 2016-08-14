class Value < ActiveRecord::Base
  belongs_to :series
  belongs_to :indicator
end