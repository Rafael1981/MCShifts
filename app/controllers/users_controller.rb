class UsersController < ApplicationController
	before_action :require_admin, only: [:new, :create, :edit, :update, :index, :show]
  before_action :require_user
  # GET /users/1
  def show
  	 @user = User.find(params[:id])
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
      # Tell the UserMailer to send a welcome email after save
      UserMailer.welcome_email(@user).deliver
			redirect_to '/users'
		else
			format.html { render :new }
			format.json { render json: @log.errors, status: :unprocessable_entity }
			# redirect_to '/signup'
		end
	end

	def edit
  	 @user = User.find(params[:id])
	end

	def password
  	 @user = User.find(params[:id])
	end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
  	@user = User.find(params[:id])
  	
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

	private
	def user_params
		params.require(:user).permit(:firstname, :middlename, :lastname, :email, :password)
	end
end
