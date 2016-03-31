class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update]
  before_action :require_admin
  # GET /places
  # GET /places.json
  def index
    @places = Place.all.order("Name ASC")
  end

  # GET /places/1
  # GET /places/1.json
  def show
  end

  # GET /places/new
  def new
    @place = Place.new
    @clients = Client.all
  end

  # GET /places/1/edit
  def edit
    @clients = Client.all
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params)

    respond_to do |format|
      if @place.save
        format.html { redirect_to places_path, notice: 'Place was successfully created.' }
        format.json { render :index, status: :created, location: @place }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    @place.client_id = params[:place][:client_id]
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to places_path, notice: 'Place was successfully updated.' }
        format.json { render :index, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      if Place.find_by id: params[:id]
        @place = Place.find_by id: params[:id]
      else
        redirect_to places_path,notice:'Place was not found.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit(:name, :client_id)
    end
end
