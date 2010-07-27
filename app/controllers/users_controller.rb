class UsersController < ApplicationController
  
  before_filter :authenticate_user!
  
  def show
    @user = User.where(:nickname => params[:id]).first
    @tags = @user.tags
    @requests = @user.requests
    @resources = @user.resources
  end
  
end