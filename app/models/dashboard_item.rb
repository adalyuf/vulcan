class DashboardItem < ApplicationRecord
  belongs_to :user
  belongs_to :dashboard
  belongs_to :indicator
  belongs_to :series

  validates :dashboard_id, presence: true
  validates :user_id, presence: true
  validate :either_indicator_or_series_must_be_specified

  def either_indicator_or_series_must_be_specified
    if indicator_id.blank? && series_id.blank?
      errors.add("Either a series or indicator must be specified.")
    end
  end

  def display_data(user)
    if self.series_id
      [self.series.display_data(user)]
    else
      self.indicator.series.limit(5).map do |series| series.display_data(user) end
    end
  end
end