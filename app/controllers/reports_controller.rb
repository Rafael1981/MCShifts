class ReportsController < ApplicationController
	before_action :require_user
	def select
		if current_user.admin?
			@users = User.all.where("role = 'employee'").order("Firstname ASC")
      @client = Client.all
		else
		end
		
	end

	def generate

		@mindate = params[:mindate]
		@mindate = (Time.parse(@mindate)).strftime('%d/%m/%Y')
		@maxdate = params[:maxdate]
		@maxdate = (Time.parse(@maxdate)+1.day).strftime('%d/%m/%Y')
		if current_user.admin?
			@typerep = params[:post][:typerep]
			@clientselected = params[:post][:client_id]
			if params[:post][:person_id].present?
				@userselected = User.find(params[:post][:person_id])
				@logs = Log.where(user: @userselected).where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).order("Signin DESC")
			else
				if @typerep == "Detailed"
					@logs = Log.where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).order("Signin DESC")
				else
					@logs =  Log.joins(:user).where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).select("firstname||' '||lastname as name, sum(signout - signin) as wrkhrs, sum(bonus) as additional, sum(signout-signin + bonus) as total").group("firstname ||' '|| lastname")

						@totalall = nil
						@logs.each do |l1|
						if @totalall.nil?
							@totalall = l1.total
						else
							@totalall +=  l1.total
					 end
					end

				end

			end
			if @clientselected.present? && (@typerep == "Detailed" || @userselected.present? )
				@clientname = Client.find(@clientselected).name
				@logs = @logs.joins(:place).where("places.client_id = ?", @clientselected)
			else
				if @clientselected.present?
          @clientname = Client.find(@clientselected).name
					@logs =  Log.joins(:place).where("places.client_id = ?", @clientselected).joins(:user).where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).select("firstname||' '||lastname as name, places.client_id as client_id, sum(signout - signin) as wrkhrs, sum(bonus) as additional, sum(signout-signin + bonus) as total").group("firstname ||' '|| lastname, places.client_id")
						@totalall = nil
					@logs.each do |l1|
						if @totalall.nil?
							@totalall = l1.total
						else
							@totalall +=  l1.total
						end
					end
				end
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