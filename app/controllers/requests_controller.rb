class RequestsController < ApplicationController
  
  verify :method => :delete, :only => [ :destroy ], 
       :render => {:text => '405 HTTP DELETE required', :status => 405}, 
       :add_headers => {'Allow' => 'DELETE'}
  
  before_filter :authenticate_user!
  before_filter :get_user_by_userid,     :only   => [:index]
  before_filter :require_user_by_userid, :except => [:index]
  

  def index
    if @user
      @requests = @user.requests.sort {|a,b| b.resources.size <=> a.resources.size }
    else
      @requests = Request.all.sort {|a,b| b.resources.size <=> a.resources.size }
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @requests }
    end
  end


  def show
    @request   = @user.requests.find(params[:id])
    @resources = @request.resources
    @resource  = @resources.build() # For quick-response form
    @tags      = @request.tags

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @request }
    end
  end


  def new
    return render_404 unless current_user == @user
    @request = @user.requests.build()

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @request }
    end
  end


  def edit
    return render_404 unless current_user == @user
    @request = @user.requests.find(params[:id])
  end


  def create
    return render_404 unless current_user == @user
    @request = @user.requests.build(params[:request])

    respond_to do |format|
      if @request.save
        format.html { redirect_to(user_request_path(@user,@request), :notice => 'Request was successfully created.') }
        format.xml  { render :xml => @request, :status => :created, :location => @request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @request.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    return render_404 unless current_user == @user
    @request = @user.requests.find(params[:id])

    respond_to do |format|
      if @request.update_attributes(params[:request])
        format.html { redirect_to(user_request_path(@user,@request), :notice => 'Request was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @request.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    render(:status => "501") # destroy not permitted
  end
  
end
