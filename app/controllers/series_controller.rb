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
      @series_related_by_geo = Series.where(geo_code_id: @series.geo_code_id ).limit(4)
      # Below code not implemented due to performance issues. Some users will see empty graphs for recommendations.
      # Alternative is for them to wait 20s for the page and slow down the database server.
      # val = Value.where(indicator_id: @series_related_by_geo.map do |g| g.indicator_id end, series_id: @series_related_by_geo.ids)
      # valid_series = val.group(:series_id).having('min(date) < ?', '1/1/2000').minimum(:date).keys
      # # We should preprocess the min date and max date values for each series
      # @series_related_by_geo = @series_related_by_geo.where(id: valid_series).limit(4)
    end
  end

end