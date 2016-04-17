class UsersController < ApplicationController
	before_action :require_admin, only: [:new, :create, :edit, :update, :index, :show]
	before_action :set_user, only: [:edit, :update, :show, :password]
  before_action :require_user
  # GET /users/1
  def show
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.where("role = 'employee'")
    @users = @users.paginate(:page => params[:page], :per_page => 5)
  end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		respond_to do |format|
		if (User.where("email = :email" , { email: user_params[:email]}).count <= 0) && @user.save
      # Tell the UserMailer to send a welcome email after save
			format.html { redirect_to users_path , notice: 'User was successfully created.' }
			# UserMailer.welcome_email(@user).deliver
		else
			format.html { redirect_to users_path, :flash => { :error => "This email is already in use." }  }
			format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
	end

	def password
	end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

	private
	def set_user
		if User.find_by id: params[:id]
			@user = User.find_by id: params[:id]
		else
			redirect_to users_path,notice:'User was not found.'
		end
	end

	def user_params
		params.require(:user).permit(:firstname, :middlename, :lastname, :email, :password, :mobile, :active)
	end
end
