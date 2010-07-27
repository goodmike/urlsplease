class ProfilesController < ApplicationController
  
  before_filter :authenticate_user!
  
  before_filter :get_user_by_nickname_from_id
  
  def show
    @tags = @user.tags
    @recommended_requests = Request.find_by_tags(@tags)
    @responses = @user.responses
  end

  def edit
  end

  def update
  end


  private
  
  def get_user_by_nickname_from_id
    @user = User.where(:nickname => params[:id]).first
  end
end
