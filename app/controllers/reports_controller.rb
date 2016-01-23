class ReportsController < ApplicationController
	before_action :require_user
	def select
		if current_user.admin?
			@users = User.all.where('role == "employee"').order("Firstname ASC")
      @client = Client.all
		else
		end
		
	end

	def generate

		@mindate = params[:mindate]
		@maxdate = params[:maxdate]			
		if current_user.admin?
			@userselected = User.find(params[:post][:person_id])
      @clientselected = params[:post][:client_id]
			if @userselected.present?
				@logs = Log.where(user: @userselected).where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).order("Signin DESC")
			else
				@logs = Log.where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).order("Signin DESC")
      end
      if @clientselected.present?
        @logs = @logs.joins(:place).where("places.client_id = ?", @clientselected)
      end
		else
			@logs = Log.where(user: current_user).order("Signin DESC")
		end		
	end
end