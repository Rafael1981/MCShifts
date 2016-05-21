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
		if current_user.admin? #reports for admins only
			@typerep = params[:post][:typerep]
			@clientselected = params[:post][:client_id]
			if params[:post][:person_id].present? # report for an especific employee, which is always detailed
				@userselected = User.find(params[:post][:person_id])
				@logs = Log.where(user: @userselected).where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).order("Signin DESC")
			else
				if @typerep == "Detailed"  # report detailed, with all employees
					@logs = Log.where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).order("Signin DESC")
				else # summarised report, all employees
					@logs =  Log.joins(:user).where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).select("firstname||' '||lastname as name, sum(signout - signin) as wrkhrs, sum(bonus) as additional, sum(signout-signin + bonus) as total").group("firstname ||' '|| lastname").order("firstname ||' '|| lastname")
						# calculating total hours for summarised report
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
			if @clientselected.present? && (@typerep == "Detailed" || @userselected.present? ) # detailed report for selected user and selected client
				@clientname = Client.find(@clientselected).name
				@logs = @logs.joins(:place).where("places.client_id = ?", @clientselected).order("Signin DESC")
			else
				if @clientselected.present? # summarised report for selected client
          @clientname = Client.find(@clientselected).name
					@logs =  Log.joins(:place).where("places.client_id = ?", @clientselected).joins(:user).where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).select("firstname||' '||lastname as name, places.client_id as client_id, sum(signout - signin) as wrkhrs, sum(bonus) as additional, sum(signout-signin + bonus) as total").group("firstname ||' '|| lastname, places.client_id").order("firstname ||' '|| lastname")
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
		else #report for users/employees
			@logs = Log.where(user: current_user).where("Signin  BETWEEN :start_date AND :end_date",  {start_date: Time.parse(@mindate), end_date: Time.parse(@maxdate)}).order("Signin DESC")
		end
	end

  private
	def report_params
		params.require(:report).permit(:mindate, :maxdate)
	end
end