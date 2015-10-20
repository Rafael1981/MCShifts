class ReportsController < ApplicationController

	def select
		if current_user.admin?
			@users = User.all.order("Firstname ASC")
		else
		end
		
	end

	def generate

		@mindate = params[:mindate]
		@maxdate = params[:maxdate]			
		@userselected = params[:post][:person_id]
		if current_user.admin?
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