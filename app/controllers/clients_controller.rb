class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update]
  before_action :require_admin

  def new
    @client = Client.new
  end

#   :create, :edit, :update, :index, :show
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to clients_path, notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
  end

  def index
    @clients = Client.all.order("Name Asc")
  end

  def show
  end

  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to client_path, notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_client
    if Client.find_by id: params[:id]
      @client = Client.find_by id: params[:id]
    else
      redirect_to clients_path,notice:'Client was not found.'
    end

  end

# Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:client).permit(:name)
  end
end
