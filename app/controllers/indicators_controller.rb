class IndicatorsController < ApplicationController

  def index
    @greeting = "Hello from indicators"
    @indicators = AgeBracket.all
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
    @indicator = AgeBracket.find(params[:id])
  end

  def delete
  end

end
