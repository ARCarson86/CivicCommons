class Admin::ReportsController < Admin::DashboardController
require 'csv'

	def member_report
		format.csv { send_data @records.member_report }
	end

	def conversation_summary
	end
end