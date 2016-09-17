class SeriesController < ApplicationController

  def show
    @series = Series.includes(indicator: { dataset: :category }).find(params[:id])
    @indicator = @series.indicator
    @dataset = @indicator.dataset
    @category = @dataset.category

    @series_related_by_geo = Series.where(geo_code_id: @series.geo_code_id ).limit(12)
  end

end