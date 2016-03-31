class ReportsController < ApplicationController
	before_action :require_user
	def select
		if current_user.admin?
			@users = User.all.where("role == 'employee'").order("Firstname ASC")
      @client = Client.all
		else
		end
		
	end

	def generate

		@mindate = params[:mindate]
		@maxdate = params[:maxdate]
		if current_user.admin?
			if params[:post][:person_id].present?
				@userselected = User.find(params[:post][:person_id])
				@logs = Log.where(user: @userselected).where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).order("Signin DESC")
			else
				@logs = Log.where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).order("Signin DESC")
      end
      if params[:post][:client_id].present?
				@clientname = Client.find(params[:post][:client_id]).name
				@clientselected = params[:post][:client_id]
				@logs = @logs.joins(:place).where("places.client_id = ?", @clientselected)
      end
		else
			@logs = Log.where(user: current_user).where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).order("Signin DESC")
		end		
	end

  private
	def report_params
		params.require(:report).permit(:mindate, :maxdate)
	end
end