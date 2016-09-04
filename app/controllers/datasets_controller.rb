class DatasetsController < ApplicationController

  def show
    @dataset = Dataset.find_by(internal_name: params[:internal_name])
    @indicators = Indicator.where( dataset_id: @dataset.id )
    @category = Category.find(@dataset.category_id)
  end

end