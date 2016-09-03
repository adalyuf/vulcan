class DatasetsController < ApplicationController

  def index
    @headline = "Datasets"
    @datasets = Dataset.find_by(category_id: params[:id])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
    @dataset = Dataset.find_by(internal_name: params[:internal_name])
    @indicators = Indicator.where( dataset_id: @dataset.id )
    @category = Category.find(@dataset.category_id)
  end

  def delete
  end

end