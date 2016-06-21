class LogsController < ApplicationController
  before_action :set_log, only: [:show, :edit, :update, :destroy]
  before_action :require_user
######################
   require 'net/https'
   require 'open-uri'
  #################

  # GET /logs
  def index
    unless current_user.admin?
      # cnt = Log.where(user: current_user).count
      # if cnt >= 7
      #  @logs = Log.where(user: current_user).limit(7).order("created_at DESC")
      # else
      #  @logs = Log.where(user: current_user).order("created_at DESC")
      # end
      @logs = Log.where(user: current_user).order("signin DESC")
    else
      cnt = Log.where("user_id>0").count
      if cnt >= 7
        @logs = Log.where("user_id>0").limit(7).order("signin DESC")
      else
        @logs = Log.where("user_id>0").order("signin DESC")
      end

    end
    @logs = @logs.paginate(:page => params[:page], :per_page => 5)


  end


  # GET /root

  def root
    if current_user.admin?
      redirect_to logs_path
    else
      cnt = Log.where(user: current_user).where("logs.Signin = logs.Signout").count
      if cnt == 0
        redirect_to signin_path
      else
        redirect_to signout_path
      end
    end
  end

  # GET /signin
  def signin
    if current_user.admin?
      redirect_to logs_path
    else
      cnt = Log.where(user: current_user).where("signin = signout").count
      if cnt == 0
        if shifts_today <=  3
          @log = Log.new
          @places = Place.all
        else
          redirect_to logs_path
        end
      else
        redirect_to signout_path
      end
    end
  end


  # GET /signout
  def signout
    if current_user.admin?
      redirect_to logs_path
    else
      cnt = Log.where(user: current_user).where("signin = signout").count
      if cnt > 0
        @log = Log.where(user: current_user).where("signin = signout").order("id DESC").first
      else
        redirect_to signin_path
      end
    end
  end

###########################3
  # POST /signin
  def create_signin
    @log = Log.new(log_params)
    @log.signout = @log.signin
    @log.user_id = current_user.id
    @log.place_id = params[:post][:place_id]
    @log.bonus = Time.parse("00:00")

    respond_to do |format|
      cnt = Log.where(user: current_user).where("signin = signout").count
      if cnt == 0
        if shifts_today <= 3
          if @log.save
            format.html { redirect_to signout_path, notice: 'Sign In Successfull.' }
            format.json { render :create_signout, status: :created, location: @log }
            sms(current_user,@log,0)
            UserMailer.log_email(@log, current_user).deliver
          else
            format.html { render :signin }
            format.json { render json: @log.errors, status: :unprocessable_entity }
          end
        else
          format.html {redirect_to logs_path, :flash => {error: 'No more than 2 shifts allowed in a day.'} }
          format.json { render json: @log.errors, status: :unprocessable_entity }
        end
      else
        format.html {redirect_to logs_path, :flash => {error: 'Sign out of it before Singing in again.'} }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end
################################

  # POST /signout
  def create_signout
    @log = set_log
      respond_to do |format|
        if @log.signin == @log.signout
          if @log.update(log_params)
            format.html { redirect_to logs_path, notice: 'Sign Out successfull.' }
            format.json { render :show, status: :ok, location: @log }
            sms(current_user,@log,2)
            UserMailer.log_email(@log, current_user).deliver

          else
            format.html { render :edit }
            format.json { render json: @log.errors, status: :unprocessable_entity }
          end
        else
          format.html {redirect_to logs_path, :flash => { :error => "This shift is already closed." } }
          format.json { render json: @log.errors, status: :unprocessable_entity }
        end
    end
  end
  # GET /logs/1
  def show
    redirect_to logs_path
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
    ##only admins are allowed to update sign in/out times
  def edit
    @log = set_log
    unless current_user.admin?
      redirect_to logs_path
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
        format.html { redirect_to logs_path, notice: 'Shift was successfully created.' }
        format.json { render :index, status: :created, location: @log }
        # UserMailer.log_email(@log, '1', current_user).deliver
      else
        format.html { render :new }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logs/1
  # PATCH/PUT /logs/1.json
  def update  ##only admins are allowed to update sign in/out times
    if (current_user.admin?) ##|| (@log.signin.strftime("%Y-%m-%d") == DateTime.now.strftime("%Y-%m-%d"))
      respond_to do |format|
        @log.place_id = params[:post][:place_id]
        if @log.update(log_params)
          format.html { redirect_to logs_path, notice: 'Shift was successfully updated.' }
          format.json { render :index, status: :ok, location: @log }
     #     UserMailer.log_email(@log, current_user).deliver

        else
          format.html { render :edit }
          format.json { render json: @log.errors, status: :unprocessable_entity }
        end
      end
    else
    end

  end

  # DELETE /logs/1
  # DELETE /logs/1.json
  def destroy
    @log.destroy
    respond_to do |format|
      format.html { redirect_to logs_url, notice: 'Shift was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log

      if Log.find_by id: params[:id]
        @log = Log.find_by id: params[:id]
      else
        redirect_to logs_path,notice:'Shift was not found.'
      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_params
      params.require(:log).permit(:signin, :signout, :bonus)
    end

    def shifts_today
      cnt2 = Log.where(user: current_user).where("signin <> signout and  DATE(signin) = DATE(:today)",  {today: DateTime.now.strftime("%Y-%m-%d")}).count
      return cnt2
    end

end
