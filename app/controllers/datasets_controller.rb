class DatasetsController < ApplicationController

  def show
    @dataset = Dataset.find_by(internal_name: params[:internal_name])
    @indicators = Indicator.where( dataset_id: @dataset.id )
    if current_user
      @indicators = @indicators.order(:name).page(params[:page])
    else
      @indicators = @indicators.select { |indicator| indicator.series.minimum(:min_date) < SystemConfig.settings_paywall_date } unless current_user
      @indicators = Kaminari.paginate_array(@indicators).page(params[:page])
    end
    @category = Category.find(@dataset.category_id)
  end

end