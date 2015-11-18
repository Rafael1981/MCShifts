class LogsController < ApplicationController
  before_action :set_log, only: [:show, :edit, :update, :destroy]
  before_action :require_user

  # GET /logs
  def index
    unless current_user.admin?
      cnt = Log.where(user: current_user).count
      if cnt >= 7
        @logs = Log.where(user: current_user).limit(7).order("created_at DESC")
      else
        @logs = Log.where(user: current_user).order("created_at DESC")
      end
    else
      cnt = Log.where("user_id>0").count
      if cnt >= 7
        @logs = Log.where("user_id>0").limit(7).order("created_at DESC")
      else
        @logs = Log.where("user_id>0").order("created_at DESC")
      end  
    end


  end

  # GET /logs/1
  def show
  end

  # GET /logs/new
  #todo: find a better solution for the timezone distortion in the browser
  def new
    @log = Log.new
    @log.Signin = DateTime.now.change(:offset => "+0000")
    @log.Signout = DateTime.now.change(:offset => "+0000")
    @places = Place.all
  end

  # GET /logs/1/edit
  def edit
  end

  # POST /logs
  # POST /logs.json
  def create
    @log = Log.new(log_params)
    @log.user_id = current_user.id
    @log.place_id = params[:post][:place_id]

    respond_to do |format|
      if @log.save
        format.html { redirect_to @log, notice: 'Log was successfully created.' }
        format.json { render :show, status: :created, location: @log }        
        UserMailer.log_email(@log, '1', current_user).deliver
      else
        format.html { render :new }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logs/1
  # PATCH/PUT /logs/1.json
  def update
    respond_to do |format|
      if @log.update(log_params)
        format.html { redirect_to @log, notice: 'Log was successfully updated.' }
        format.json { render :show, status: :ok, location: @log }     
        UserMailer.log_email(@log, '2', current_user).deliver

      else
        format.html { render :edit }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logs/1
  # DELETE /logs/1.json
  def destroy
    @log.destroy
    respond_to do |format|
      format.html { redirect_to logs_url, notice: 'Log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = Log.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_params
      params.require(:log).permit(:Signin, :Signout)
    end
end
