class SeriesController < ApplicationController

  def show
    @series = Series.find( params[:id] )
    @indicator = Indicator.find(@series.indicator_id)
    @dataset = Dataset.find(@indicator.dataset_id)
    @category = Category.find(@dataset.category_id)
    @values = Value.where(indicator_id: @indicator.id, series_id: @series.id)
    grouped_values = @values.group_by(&:series_id)
    @data =
      [{
        :name => @series.display_name,
        :data => Hash[grouped_values[@series.id].map{ |value| [value.date, value.value] }]
      }]
  end

end