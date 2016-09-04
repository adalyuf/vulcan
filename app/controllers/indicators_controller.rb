class IndicatorsController < ApplicationController

  def show
    @dataset = Dataset.find_by(internal_name: params[:dataset_internal_name])
    @indicator = Indicator.find_by(dataset_id: @dataset.id, internal_name: params[:internal_name])
    @category = Category.find(@dataset.category_id)
    @series = Series.where(indicator_id: @indicator.id)
    @values = Value.where(indicator_id: @indicator.id)

    grouped_values = @values.group_by(&:series_id)

    @data = @series.map do |serie|
      {
        :name => serie.name,
        :data => Hash[grouped_values[serie.id].map{ |value| [value.date, value.value] }]
      }
    end
  end

end