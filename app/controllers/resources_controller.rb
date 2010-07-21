class ResourcesController < ApplicationController

  before_filter :get_user_by_userid,           :only   => [:index]
  before_filter :require_user_by_userid,       :except => [:index]
  before_filter :require_request_by_requestid, :only => [:new, :edit, :create]

  def index
    if @user
      @resources = @user.resources
    else
      @resources = Resource.all
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resources }
    end
  end


  def show
    @resource = @user.resources.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resource }
    end
  end


  def new
    return render_404 unless current_user == @user
    @resource = @request.resources.build
    @resource.user = @user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resource }
    end
  end


  def edit
    return render_404 unless current_user == @user
    @resource = @request.resources.find(params[:id])
  end


  def create
    return render_404 unless current_user == @user
    @resource = @request.resources.build(params[:resource])
    @resource.user = @user

    respond_to do |format|
      if @resource.save
        format.html { redirect_to(user_request_path(@request.user, @request), 
                                  :notice => 'Resource was successfully created.') }
        format.xml  { render :xml => @resource, :status => :created, :location => @resource }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    render(:status => "501") # No updates permitted.
  end


  def destroy
    return render_404 unless current_user == @user
    return render_404 unless params[:request_id]
    @request = @user.requests.find(params[:request_id])
    
    @resource = @request.resources.find(params[:id])
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to(user_request_path(@user, @request), 
                                :notice => 'Resource was deleted.') }
      format.xml  { head :ok }
    end
  end
end