class PicturesController < ApplicationController
  #changed this to skip before action because I'm adding a ton of new routes and don't want to have to type them out
  before_action :set_picture, except: [:new, :create, :index]
  before_action :set_categories, only: [:new, :edit]
  before_action :restrict_to_users, except: [:index, :show]

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new( picture_params )

    @picture.user = current_user
    if @picture.save
      @picture.tagorize_improved
      redirect_to picture_path( @picture )
    else
      redirect_to :new, notice: @picture.errors.full_messages
    end
  end

  def index
    @pictures = Picture.all
  end

  def update
    if @picture.update( picture_params )
      @picture.tagorize
      redirect_to picture_path( @picture )
    else
      redirect_to :edit, notice: @picture.errors.full_messages
    end
  end

  def destroy
    @picture.destroy
    redirect_to user_path( current_user ), notice: ["Successfully deleted #{@picture.name}"]
  end

  def black_and_white
    @picture = Picture.find(params[:id])
    @picture.grey_scale_improved
    @picture.save
    redirect_to "/pictures/#{params[:id]}/edit"
  end

  def edge
    @picture.edge
    @picture.save
    redirect_to "/pictures/#{params[:id]}/edit"
  end

  def sepia
    @picture.sepia
    @picture.save
    redirect_to "/pictures/#{params[:id]}/edit"
  end
  def charcoal
    @picture.charcoal
    @picture.save
    redirect_to "/pictures/#{params[:id]}/edit"
  end

  def sketch
    @picture.sketch
    @picture.save
    redirect_to "/pictures/#{params[:id]}/edit"
  end

  def vignette
    @picture.vignette
    @picture.save
    redirect_to "/pictures/#{params[:id]}/edit"
  end
  def polaroid
    @picture.polaroid
    @picture.save
    redirect_to "/pictures/#{params[:id]}/edit"
  end
  def make_bigger
    @picture.make_bigger
    @picture.save
    redirect_to "/pictures/#{params[:id]}/edit"
  end
  def make_smaller
    @picture.make_smaller
    @picture.save
    redirect_to "/pictures/#{params[:id]}/edit"
  end

  def make_thumbnail
    @picture.make_thumbnail
    @picture.save
    redirect_to "/pictures/#{params[:id]}/edit"
  end

  def flip_vertical
    @picture.flip_vertical
    @picture.save
    redirect_to "/pictures/#{params[:id]}/edit"
  end

  def flip_horizontal
    @picture.flip_horizontal
    @picture.save
    redirect_to "/pictures/#{params[:id]}/edit"
  end



  private

  def set_picture
    @picture = Picture.find( params[:id] )
  end

  def set_categories
    @categories = Category.all
  end

  def picture_params
    params_hash = params.require( :picture ).permit( :image, :name )
    params_hash[:category_ids] = params.require( :picture ).require( :category_ids )
    params_hash
  end
end
