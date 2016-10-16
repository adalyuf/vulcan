class SeriesController < ApplicationController

  def show
    @series = Series.includes(indicator: { dataset: :category }).find(params[:id])
    @indicator = @series.indicator
    @dataset = @indicator.dataset
    @category = @dataset.category
    @start_date = start_date || 'Start Date'
    @end_date = end_date || 'End Date'

    if current_user
      @dashboards = Dashboard.where(user_id: current_user.id)
      @dashboard_item = DashboardItem.new(indicator_id: @indicator.id, series_id: @series.id)
      @series_related_by_geo = Series.where(geo_code_id: @series.geo_code_id ).limit(12)
    else
      @series_related_by_geo = Series.where(geo_code_id: @series.geo_code_id ).where('min_date < ?',SystemConfig.trial_scope_end_date).limit(4)
    end

    @data = [@series.display_data(current_user, start_date, end_date)]
  end

private
  def dates
    params.fetch(:dates, {}).permit(:start_date, :end_date)
  end

  def start_date
    dates['start_date'] ? dates['start_date'].to_date : nil
  end

  def end_date
    dates['end_date'] ? dates['end_date'].to_date : nil
  end

end