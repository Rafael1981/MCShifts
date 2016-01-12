class LogsController < ApplicationController
  before_action :set_log, only: [:show, :edit, :update, :destroy]
  before_action :require_user

  # GET /logs
  def index
    unless current_user.admin?
      # cnt = Log.where(user: current_user).count
      # if cnt >= 7
      #  @logs = Log.where(user: current_user).limit(7).order("created_at DESC")
      # else
      #  @logs = Log.where(user: current_user).order("created_at DESC")
      # end
      @logs = Log.where(user: current_user).order("created_at DESC")
    else
      cnt = Log.where("user_id>0").count
      if cnt >= 7
        @logs = Log.where("user_id>0").limit(7).order("created_at DESC")
      else
        @logs = Log.where("user_id>0").order("created_at DESC")
      end

    end
    @logs = @logs.paginate(:page => params[:page], :per_page => 5)

  end


  # GET /root

  def root
    if current_user.admin?
      redirect_to '/logs'
    else
      cnt = Log.where(user: current_user).where("logs.Signin = logs.Signout").count
      if cnt == 0
        redirect_to '/signin'
      else
        redirect_to '/signout'
      end
    end
  end

  # GET /signin
  def signin
    @log = Log.new
    @places = Place.all
  end


  # GET /signout
  def signout
    @log = Log.where(user: current_user).where("signin = signout").order("id DESC").first
  end

###########################3
  # POST /signin
  def create_signin
    @log = Log.new(log_params)
    @log.signout = @log.signin
    @log.user_id = current_user.id
    @log.place_id = params[:post][:place_id]

    respond_to do |format|
      if @log.save
        format.html { redirect_to '/signout', notice: 'Sign In Successfull.' }
        format.json { render :create_signout, status: :created, location: @log }
        UserMailer.log_email(@log, current_user).deliver
      else
        format.html { render :signin }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end
################################

  # POST /signout
  def create_signout
    @log = set_log
    respond_to do |format|
      if @log.update(log_params)
        format.html { redirect_to @log, notice: 'Sign Out successfull.' }
        format.json { render :show, status: :ok, location: @log }
        UserMailer.log_email(@log, current_user).deliver

      else
        format.html { render :edit }
        format.json { render json: @log.errors, status: :unprocessable_entity }
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
    @log.signin = DateTime.now.change(:offset => "+0000")
    @log.signout = DateTime.now.change(:offset => "+0000")
    @places = Place.all
  end

  # GET /logs/1/edit
  def edit
    @log = set_log
    unless (@log.signin != @log.signout)
      redirect_to '/logs'
    end
  end

  # POST /logs
  # POST /logs.json
  def create
    @log = Log.new(log_params)
    @log.user_id = current_user.id
    @log.place_id = params[:post][:place_id]


    respond_to do |format|
      if @log.save
        format.html { redirect_to @log, notice: 'Record was successfully created.' }
        format.json { render :show, status: :created, location: @log }        
        # UserMailer.log_email(@log, '1', current_user).deliver
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
        format.html { redirect_to @log, notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @log }     
        UserMailer.log_email(@log, current_user).deliver

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
      params.require(:log).permit(:signin, :signout)
    end

end
