class CategoriesController < ApplicationController

  def index
    @categories = Category.all
    @series_count = Series.all.count
    @series_count = (@series_count/1000).floor*1000
  end

  def show
    @category = Category.find_by(internal_name: params[:internal_name])
    @datasets = Dataset.where( category_id: @category.id )
  end

end