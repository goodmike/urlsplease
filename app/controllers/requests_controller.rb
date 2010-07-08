class RequestsController < ApplicationController
  
  verify :method => :delete, :only => [ :destroy ], 
       :render => {:text => '405 HTTP DELETE required', :status => 405}, 
       :add_headers => {'Allow' => 'DELETE'}
  
  before_filter :authenticate_user!
  
  # GET /requests
  # GET /requests.xml
  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @requests = @user.requests
    else
      @requests = Request.all
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @requests }
    end
  end

  # GET /requests/1
  # GET /requests/1.xml
  def show
    return render_404 unless params[:user_id]
    @user = User.find(params[:user_id])
    @request = @user.requests.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @request }
    end
  end

  # GET /requests/new
  # GET /requests/new.xml
  def new
    return render_404 unless params[:user_id]
    @user = User.find(params[:user_id])
    return render_404 unless current_user == @user
    @request = @user.requests.build()

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @request }
    end
  end

  # GET /requests/1/edit
  def edit
    return render_404 unless params[:user_id]
    @user = User.find(params[:user_id])
    return render_404 unless current_user == @user
    @request = @user.requests.find(params[:id])
  end

  # POST /requests
  # POST /requests.xml
  def create
    return render_404 unless params[:user_id]
    @user = User.find(params[:user_id])
    return render_404 unless current_user == @user
    @request = @user.requests.build(params[:request])

    respond_to do |format|
      if @request.save
        format.html { redirect_to(@request, :notice => 'Request was successfully created.') }
        format.xml  { render :xml => @request, :status => :created, :location => @request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /requests/1
  # PUT /requests/1.xml
  def update
    return render_404 unless params[:user_id]
    @user = User.find(params[:user_id])
    return render_404 unless current_user == @user
    @request = @user.requests.find(params[:id])

    respond_to do |format|
      if @request.update_attributes(params[:request])
        format.html { redirect_to(@request, :notice => 'Request was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.xml
  def destroy
    return render_404 unless params[:user_id]
    @user = User.find(params[:user_id])
    return render_404 unless current_user == @user
    @request = @user.requests.find(params[:id])
    render(:status => "501")
  end
  
  private 
  
  def render_404
    render(:file => "#{Rails.root}/public/404.html", :layout => false, :status => "404")
    return false
  end
end
