class Admin::EmailRestrictionsController < Admin::DashboardController

  authorize_resource :class => :admin_restrictions

  # GET /admin/email_restrictions
  # GET /admin/email_restrictions.xml
  def index
    @email_restrictions = EmailRestriction.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @email_restrictions }
    end
  end

  # GET /admin/email_restrictions/1
  # GET /admin/email_restrictions/1.xml
  def show
    @email_restriction = EmailRestriction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @email_restriction }
    end
  end

  # GET /admin/email_restrictions/new
  # GET /admin/email_restrictions/new.xml
  def new
    @email_restriction = EmailRestriction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @email_restriction }
    end
  end

  # GET /admin/email_restrictions/1/edit
  def edit
    @email_restriction = EmailRestriction.find(params[:id])
  end

  # POST /admin/email_restrictions
  # POST /admin/email_restrictions.xml
  def create
    @email_restriction = EmailRestriction.new(params[:email_restriction])

    respond_to do |format|
      if @email_restriction.save
        format.html { redirect_to([:admin,@email_restriction], :notice => 'EmailRestriction was successfully created.') }
        format.xml  { render :xml => @email_restriction, :status => :created, :location => @email_restriction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @email_restriction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/email_restrictions/1
  # PUT /admin/email_restrictions/1.xml
  def update
    @email_restriction = EmailRestriction.find(params[:id])

    respond_to do |format|
      if @email_restriction.update_attributes(params[:email_restriction])
        format.html { redirect_to([:admin,@email_restriction], :notice => 'EmailRestriction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @email_restriction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/email_restrictions/1
  # DELETE /admin/email_restrictions/1.xml
  def destroy
    @email_restriction = EmailRestriction.find(params[:id])
    @email_restriction.destroy

    respond_to do |format|
      format.html { redirect_to(admin_email_restrictions_url) }
      format.xml  { head :ok }
    end
  end
end
