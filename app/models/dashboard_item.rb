class DashboardItem < ApplicationRecord
  belongs_to :user
  belongs_to :dashboard
  belongs_to :indicator
  belongs_to :series

  def display_data
    if self.series_id
      self.series.display_data
    else
      self.indicator.display_data
    end
  end
end