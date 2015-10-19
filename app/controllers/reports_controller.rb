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
			@logs = Log.where(user: @userselected).order("Signin DESC")
		else
			@logs = Log.where(user: current_user).order("Signin DESC")
		end
		
	end

end
