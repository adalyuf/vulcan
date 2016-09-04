class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(internal_name: params[:internal_name])
    @datasets = Dataset.where( category_id: @category.id )
  end

end