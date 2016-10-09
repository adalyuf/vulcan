class DatasetsController < ApplicationController

  def show
    @dataset = Dataset.find_by(internal_name: params[:internal_name])
    @indicators = Indicator.where( dataset_id: @dataset.id )
    @indicators = @indicators.to_a.delete_if { |indicator| indicator.series.minimum(:min_date) > '1/1/2000'.to_date } unless current_user

    @category = Category.find(@dataset.category_id)
  end

end