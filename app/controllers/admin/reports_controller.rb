class Admin::ReportsController < Admin::DashboardController
require 'csv'

	def index
		@projects = Issue.order('name ASC')
	end

	def member_report
		@records = Report.member_report
		@mcsv = CSV.generate do |csv|
      csv << ["Person ID", "First Name", "Last Name", "Email Address", "Organization", "Confirmed?", "Confirmed at", "Sign in Count", "Last Signed In", "Locked at?", "Conversations Sorry", "Contributions Made", "Persuasive Ratings", "Informative Ratings", "Inspiring Ratings", "Votes Created", "Votes Cast", "Petitions Written", "Petitions Signed", "Subcriptions"] 
      @records.each do |record|
      	csv << record
      end
		end
		respond_to do |format|
			format.csv { send_data @mcsv, type: 'text/csv', filename: "Member Report #{DateTime.now.strftime("%F %H:%M")}.csv" }
		end
	end

	def conversation_summary
		@records = Report.conversation_summary
		@cscsv = CSV.generate do |csv|
			csv << ["Conversation ID", "Posted On", "Title", "Visits", "Last Visit", "Staff Pick?", "'#' of Participants", "Contributions", "Votes", "Unique Members Voteing", "Petitions", "Petition Signatures", "Persausive Ratings", "Informative Ratings", "Inspiring Ratings", "Subscriptions"]
			@records.each do |record|
				csv << record
			end
		end
		respond_to do |format|
			format.csv { send_data @cscsv, type: 'text/csv', filename: "Conversation Summary #{DateTime.now.strftime("%F %H:%M")}.csv" }
		end
	end

	def project_overview
		@records = Report.project_overview
		@pcsv = CSV.generate do |csv|
			csv << ["Project", "Conversation", "Conversation Posted", "Votes", "Total Vote Responses", "Petitions", "Petition Signatures", "Contributions", "Suscriptions", "Visits"]
		@records.each do |record|
				csv << record
			end
		end
		respond_to do |format|
			format.csv { send_data @pcsv, type: 'text/csv', filename: "Project Overview #{DateTime.now.strftime("%F %H:%M")}.csv" }
		end
	end

	def individual_project_stats
		unless params[:individual_project_stats][:id].empty?
			@records = Report.individual_project_stats(params[:individual_project_stats][:id])
				@icsv = CSV.generate do |csv|
				csv << ["Conversation ID", "Posted On", "Title", "Votes", "Total Vote Responses", "Petitions", "Petition Signatures", "Contributions", "Subscriptions", "Visits"]
				@records.each do |record|
					csv << record
				end
			end
			respond_to do |format|
				format.csv { send_data @icsv, type: 'text/csv', filename: "#{Issue.find(params[:individual_project_stats][:id]).name} Stats #{DateTime.now.strftime("%F %H:%M")}.csv" }
			end
		else
			redirect_to reports_path, :flash => { :error => "Project cannot be left blank!" }
		end
	end

	def project_conversations
		unless params[:project_conversations][:id].empty?
			@records = Report.project_conversations(params[:project_conversations][:id])
				@pccsv = CSV.generate do |csv|
				csv << ["Conversation ID", "Conersation", "Contribution ID", "Posted", "Contributor", "Contribution Title", "Contribution Content", "Contribution Attachment", "Persuasive Ratings", "Informative Ratings", "Inspiring Ratings", "Sort ID", "Sort Level"]
				@records.each do |record|
					csv << record
				end
			end
			respond_to do |format|
				format.csv { send_data @pccsv, type: 'text/csv', filename: "#{Issue.find(params[:project_conversations][:id]).name} Conversations #{DateTime.now.strftime("%F %H:%M")}.csv" }
			end
		else
			redirect_to reports_path, :flash => { :error => "Project cannot be left blank!" }
		end
	end
end