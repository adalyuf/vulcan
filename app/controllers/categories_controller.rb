class CategoriesController < ApplicationController

  def index
    @headline = "Browse by Category"
    @categories = Category.all
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
    @category = Category.find_by(internal_name: params[:internal_name])
    @datasets = Dataset.where( category_id: @category.id )
  end

  def delete
  end

end