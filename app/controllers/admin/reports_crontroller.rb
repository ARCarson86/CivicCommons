class Admin::ReportsController < Admin::DashboardController
require 'csv'

	def member_report
		format.csv { send_data Report.member_report }
	end

	def conversation_summary
		format.csv { send_data Report.conversation_summary }
	end

	def project_overview
		format.csv { send_data Report.project_overview }
	end
end