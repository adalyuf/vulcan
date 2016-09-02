class IndicatorsController < ApplicationController

  def index
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
    @dataset = Dataset.find_by(internal_name: params[:dataset_internal_name])
    @indicator = Indicator.find_by(dataset_id: @dataset.id, internal_name: params[:internal_name])
    @series = Series.where( indicator_id: @indicator.id )
  end

  def delete
  end

end