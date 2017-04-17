class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new( category_params )
    if @category.save
      redirect_to category_path( @category )
    else
      render :new
    end
  end

  def update
    if @category.update( category_params )
      redirect_to category_path( @category )
    else
      render :edit
    end
  end

  def index
    @categories = Category.all
  end

  private

  def set_category
    @category = Category.find( params[:id] )
  end

  def category_params
    params.require( :category ).permit( :name )
  end
end
