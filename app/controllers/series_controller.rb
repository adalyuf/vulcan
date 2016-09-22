class SeriesController < ApplicationController

  def show
    @series = Series.includes(indicator: { dataset: :category }).find(params[:id])
    @indicator = @series.indicator
    @dataset = @indicator.dataset
    @category = @dataset.category

    if current_user
      @dashboards = Dashboard.where(user_id: current_user.id)
      @dashboard_item = DashboardItem.new(indicator_id: @indicator.id, series_id: @series.id)
      @series_related_by_geo = Series.where(geo_code_id: @series.geo_code_id ).limit(12)
    else
      @series_related_by_geo = Series.where(geo_code_id: @series.geo_code_id ).where('min_date < ?','1/1/2000').limit(4)
    end
  end

end