class DatasetsController < ApplicationController

  def show
    @dataset = Dataset.find_by(internal_name: params[:internal_name])
    @indicators = Indicator.where( dataset_id: @dataset.id )
    @indicators = @indicators.select { |indicator| indicator.series.minimum(:min_date) < SystemConfig.trial_scope_end_date } unless current_user

    @category = Category.find(@dataset.category_id)
  end

end