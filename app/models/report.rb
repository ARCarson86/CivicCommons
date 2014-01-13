class Report < ActiveRecord::Base

	def member_report(options = {})
    CSV.generate(options) do |csv|
      csv << ["Person ID", "First Name", "Last Name", "Email Address", "Organization", "Confirmed?", "Confirmed at", "Sign in Count", "Last Signed In", "Locked at?", "Conversations Sorry", "Contributions Made", "Persuasive Ratings", "Informative Ratings", "Inspiring Ratings", "Votes Created", "Votes Cast", "Petitions Written", "Petitions Signed", "Subcriptions"] 
    	 sql = "select p.id as 'Person ID',
       ifnull(p.first_name,'') as 'First Name',
       p.last_name as 'Last Name',
       p.email as 'Email Address',
       if(p.type = 'Organization', 'Y', '') as 'Organization?',
       if(p.confirmed_at is null, 'N', 'Y') as 'Confirmed?',
       ifnull(date(p.confirmed_at), '') as 'Confirmed at',
       p.sign_in_count as 'Sign in Count',
       ifnull(date(p.last_sign_in_at),'') as 'Last Signed in',
       ifnull(date(p.locked_at), '') as 'Locked at',
       (select count(*) from conversations where owner = p.id) as 'Conversations Started',
       (select count(*) from contributions where owner = p.id) as 'Contributions Made',
       (select count(*) from rating_groups join ratings on ratings.rating_group_id = rating_groups.id where rating_groups.person_id = p.id and ratings.rating_descriptor_id = 1) as 'Persuasive Ratings',
       (select count(*) from rating_groups join ratings on ratings.rating_group_id = rating_groups.id where rating_groups.person_id = p.id and ratings.rating_descriptor_id = 2) as 'Informative Ratings',
       (select count(*) from rating_groups join ratings on ratings.rating_group_id = rating_groups.id where rating_groups.person_id = p.id and ratings.rating_descriptor_id = 3) as 'Inspiring Ratings',
       (select count(*) from surveys where type = 'Vote' and person_id = p.id) as 'Votes Created',
       (select count(*) from survey_responses where person_id = p.id) as 'Votes Cast',
       (select count(*) from petitions where person_id = p.id) as 'Petitions Written',
       (select count(ps.id) from petition_signatures as ps join petitions as pt on pt.id = ps.petition_id where ps.person_id = p.id and pt.person_id <> p.id) as 'Petitions Signed',
       (select count(*) from subscriptions where person_id = p.id) as 'Subscriptions'
    	 from people as p"
       @records = ActiveRecord::Base.connection.execute(sql)
        csv << @records
	end

	def conversation_summary
    CSV.generate(options) do |csv|
      csv << ["Conversation ID", "Posted On", "Title", "Visits", "Last Visit", "Staff Pick?", "'#' of Participants", "Contributions", "Votes", "Unique Members Voteing", "Petitions", "Petition Signatures", "Persausive Ratings", "Informative Ratings", "Inspiring Ratings", "Subscriptions"]
        sql = "select
        c.id as 'Conversation ID',
        date(c.created_at) as 'Posted On',
        c.title as 'Title',
        c.total_visits as 'Visits',
        date(c.last_visit_date) as 'Last Visit',
        if(c.staff_pick = 1, 'Y', '') as 'Staff Pick?',
        (select count(distinct owner) from contributions where conversation_id = c.id) as '# of Participants',
        (select count(*) from contributions where conversation_id = c.id) as 'Contributions',
        (select count(*) from surveys where type = 'Vote' and surveyable_type = 'Conversation' and surveyable_id = c.id) as 'Votes',
        (select count(distinct sr.person_id) from survey_responses as sr join surveys as s on s.id = sr.survey_id where s.surveyable_type = 'Conversation' and s.type = 'Vote' and s.surveyable_id = c.id) as 'Unique Members Voting',
        (select count(*) from petitions where conversation_id = c.id) as 'Petitions',
        (select count(ps.id) from petition_signatures as ps join petitions as p on p.id = ps.petition_id where p.conversation_id = c.id) as 'Petition Signatures',
        (select count(rating_groups.id) from rating_groups join ratings on ratings.rating_group_id = rating_groups.id where rating_groups.conversation_id = c.id and ratings.rating_descriptor_id = 1) as 'Persuasive Ratings',
        (select count(rating_groups.id) from rating_groups join ratings on ratings.rating_group_id = rating_groups.id where rating_groups.conversation_id = c.id and ratings.rating_descriptor_id = 2) as 'Informative Ratings',
        (select count(rating_groups.id) from rating_groups join ratings on ratings.rating_group_id = rating_groups.id where rating_groups.conversation_id = c.id and ratings.rating_descriptor_id = 3) as 'Inspiring Ratings',
        (select count(*) from subscriptions where subscribable_type = 'Conversation' and subscribable_id = c.id) as 'Subscriptions'
        from conversations as c"
        @records = ActiveRecord::Base.connection.execute(sql)    
          csv << @records
	end

	def individual_project_stats

    @issues = Issue.all 

    #sql = "select @project_id := `id` 
    # from issues 
    #  where
    #  type = 'ManagedIssue' and
    #  name = 'Port of Cleveland';
    #  select c.id,
    #  date(c.created_at) as 'Posted',
    #  c.title,
    #  (select count(*) from surveys where surveyable_type = 'Conversation' and surveyable_id = c.id and type = 'Vote') as 'Votes',
    #  (select count(sso.id) from selected_survey_options as sso join survey_options as so on sso.survey_option_id = so.id join surveys as s on s.id = so.survey_id where s.surveyable_type = 'Conversation' and s.surveyable_id = c.id) as 'Total Vote Responses',
    #  (select count(*) from petitions where conversation_id = c.id) as 'Petitions',
    #  (select count(*) from reflections where conversation_id = c.id) as 'Reflections',
    #  (select count(rc.id) from reflection_comments as rc join reflections as r on r.id = rc.reflection_id where r.conversation_id = c.id) as 'Reflection Comments',
    #  (select count(*) from petitions where conversation_id = c.id) as 'Petitions',
    #  (select count(*) from petition_signatures as ps join petitions as p on p.id = ps.petition_id where p.conversation_id = c.id) as 'Petition Signatures',
    #  (select count(*) from contributions where conversation_id = c.id) as 'Contributions',
    #  (select count(*) from subscriptions where subscribable_type = 'Conversation' and subscribable_id = c.id) as 'Subscriptions',    
    #  (select count(*) from visits where visitable_type = 'Conversation' and visitable_id = c.id) as 'Visits'
    #  from conversations as c
    #  join conversations_issues as ci on ci.conversation_id = c.id and ci.issue_id = @project_id"
    # @records = ActiveRecord::Base.connection.execute(sql)
	end

	def project_conversations
    @issues = Issue.all 
    #sql = "select @project_id := `id` 
    #  from issues 
    #  where type = 'ManagedIssue' and name = 'Port of Cleveland';
    #  select convo.id as 'Conversation ID',
    #  convo.title as 'Conversation',
    #  contrib.id as 'Contribution ID',
    #  date(contrib.created_at) as 'Posted',
    #  concat_ws(' ', p.first_name, p.last_name) as 'Contributor',
    #  contrib.title as 'Contribution Title',
    #  contrib.content as 'Contribution Content',
    #  contrib.attachment_file_name as 'Contribution Attachment',
    #  (select count(*) from rating_groups join ratings on ratings.rating_group_id = rating_groups.id where rating_groups.contribution_id = contrib.id and ratings.rating_descriptor_id = 1) as 'Persuasive Ratings',
    #  (select count(*) from rating_groups join ratings on ratings.rating_group_id = rating_groups.id where rating_groups.contribution_id = contrib.id and ratings.rating_descriptor_id = 2) as 'Informative Ratings',
    #  (select count(*) from rating_groups join ratings on ratings.rating_group_id = rating_groups.id where rating_groups.contribution_id = contrib.id and ratings.rating_descriptor_id = 3) as 'Inspiring Ratings',
    #  ifnull(contrib.parent_id, contrib.id) as 'Sort ID',
    #  if(contrib.parent_id is NULL, 0, 1) as 'Sort Level'
    #  from conversations as convo
    #  join conversations_issues as ci on ci.conversation_id = convo.id and ci.issue_id = @project_id
    #  left outer join contributions as contrib on contrib.conversation_id = convo.id
    #  left outer join people as p on p.id = contrib.owner"
    #@records = ActiveRecord::Base.connection.execute(sql)
	end

	def project_overview
    CSV.generate(options) do |csv|
      csv << ["Project", "Conversation", "Votes", "Conversation Posted", "Votes", "Total Vote Responses", "Petitions", "Petition Signatures", "Contributions", "Suscriptions", "Visits", "Managed Issue"]
      sql = "select i.name as 'Project',
        c.title as 'Conversation',
        date(c.created_at) as 'Conversation Posted',
        (select count(*) from surveys where surveyable_type = 'Conversation' and surveyable_id = c.id and type = 'Vote') as 'Votes',
        (select count(sso.id) from selected_survey_options as sso join survey_options as so on sso.survey_option_id = so.id join surveys as s on s.id = so.survey_id where s.surveyable_type = 'Conversation' and s.surveyable_id = c.id) as 'Total Vote Responses',
        (select count(*) from petitions where conversation_id = c.id) as 'Petitions',
        (select count(*) from petition_signatures as ps join petitions as p on p.id = ps.petition_id where p.conversation_id = c.id) as 'Petition Signatures',
        (select count(*) from contributions where conversation_id = c.id) as 'Contributions',
        (select count(*) from subscriptions where subscribable_type = 'Conversation' and subscribable_id = c.id) as 'Subscriptions',    
        (select count(*) from visits where visitable_type = 'Conversation' and visitable_id = c.id) as 'Visits'
        from conversations as c
        join conversations_issues as ci on ci.conversation_id = c.id
        join issues as i on i.id = ci.issue_id and i.type = 'ManagedIssue'"
        @records = ActiveRecord::Base.connection.execute(sql)    
          csv << @records   
	end
end