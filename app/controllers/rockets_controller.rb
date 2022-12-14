class RocketsController < ApplicationController

  def show
    @rocket = Rocket.find(params[:id])
    @book = Book.new()
    @markers =
    [
      {
        lat: @rocket.geocode[0],
        lng: @rocket.geocode[1]
      }
    ]
  end

  def myposts
    @rockets = Rocket.where(user: current_user)
  end

  def new
    @rocket = Rocket.new
  end

  def create
    @rocket = Rocket.new(rocket_params)
    @rocket.user = current_user
    if @rocket.save
      redirect_to myposts_path(@rocket)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    if params[:query].present?
      sql_query = "country ILIKE :query OR town ILIKE :query"
      @rockets = Rocket.where(sql_query, query: "%#{params[:query]}%")
    else
      @rockets = Rocket.all
    end
  end

  def edit
    @rocket = Rocket.find(params[:id])
  end

  def update
    @rocket = Rocket.find(params[:id])
    @rocket.update(rocket_params)
    redirect_to myposts_path(@rocket)
  end

  def destroy
    @rocket = Rocket.find(params[:id])
    @rocket.destroy
    redirect_to myposts_path, status: :see_other
  end

  private

  def rocket_params
    params.require(:rocket).permit(:name, :photo, :capacity, :country, :town, :price)
  end
end
