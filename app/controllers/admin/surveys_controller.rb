class Admin::SurveysController < Admin::DashboardController

  authorize_resource :class => :admin_surveys

  # GET /admin/surveys
  # GET /admin/surveys.xml
  def index
    @surveys = Survey.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @surveys }
    end
  end

  # GET /admin/surveys/1
  # GET /admin/surveys/1.xml
  def show
    @survey = Survey.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @survey }
    end
  end

  # GET /admin/surveys/new
  # GET /admin/surveys/new.xml
  def new
    @survey = Survey.new(:max_selected_options => 3)
    @survey.type = 'Vote'
    5.times do
      @survey.options.build
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @survey }
    end
  end

  # GET /admin/surveys/1/edit
  def edit
    @survey = Survey.find(params[:id])
    @survey = @survey.becomes(Survey) # needed for STI so that the form can use the parent, not the child
    5.times do
      @survey.options.build
    end

    @survey_options = @survey.options
  end

  # POST /admin/surveys
  # POST /admin/surveys.xml
  def create
    @survey = Survey.new(params[:survey])
    @survey.type = params["survey"]["type"]
    @survey = @survey.becomes(Survey) # needed for STI so that the form can use the parent, not the child
    @survey.attributes = params[:survey]
    @survey.person_id = current_person.id

    # External Parties will handle sending email.  We will mark it as sent and assume it's been done.
    if params[:survey][:manual_results]
      @survey.end_notification_email_sent = true
    end

    respond_to do |format|
      if @survey.save
        format.html { redirect_to(admin_survey_url(@survey), :notice => 'Survey was successfully created.') }
        format.xml  { render :xml => @survey, :status => :created, :location => @survey }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/surveys/1
  # PUT /admin/surveys/1.xml
  def update
    @survey = Survey.find(params[:id])
    @survey = @survey.becomes(Survey) # needed for STI so that the form can use the parent, not the child
    @survey.type = params["survey"]["type"] if params['survey'] && params['survey']['type']
    @survey.attributes = params[:survey]
    respond_to do |format|
      if @survey.save
        format.html { redirect_to(admin_survey_url(@survey), :notice => 'Survey was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/surveys/1
  # DELETE /admin/surveys/1.xml
  def destroy
    @survey = Survey.find(params[:id])
    @survey.destroy

    respond_to do |format|
      format.html { redirect_to(admin_surveys_url) }
      format.xml  { head :ok }
    end
  end

  #GET /admin/surveys/1/progress
  def progress
    @survey = Survey.find(params[:id])
    @vote_progress_service = VoteProgressService.new(@survey)
    @responses = @survey.survey_responses.sort_last_created_first
  end
end
