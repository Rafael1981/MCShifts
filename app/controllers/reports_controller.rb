class ReportsController < ApplicationController
	before_action :require_user
	def select
		if current_user.admin?
			@users = User.all.where('role == "employee"').order("Firstname ASC")
		else
		end
		
	end

	def generate

		@mindate = params[:mindate]
		@maxdate = params[:maxdate]			
		if current_user.admin?
			@userselected = params[:post][:person_id]
			if @userselected.present?
				@logs = Log.where(user: @userselected).where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).order("Signin DESC")
			else
				@logs = Log.where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).order("Signin DESC")
			end
		else
			@logs = Log.where(user: current_user).order("Signin DESC")
		end		
	end
end