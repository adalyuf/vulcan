class SeriesController < ApplicationController

  def show
    @series = Series.includes(indicator: { dataset: :category }).find(params[:id])
    @indicator = @series.indicator
    @dataset = @indicator.dataset
    @category = @dataset.category

    @series_related_by_geo = Series.where(geo_code_id: @series.geo_code_id ).limit(12)

    @dashboards = Dashboard.where(user_id: current_user.id)
    @dashboard_item = DashboardItem.new(indicator_id: @indicator.id, series_id: @series.id)
  end

end