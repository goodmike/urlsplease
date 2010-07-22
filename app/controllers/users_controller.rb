class UsersController < ApplicationController
  
  def show
    @user = User.where(:nickname => params[:id]).first
    @tags = @user.tags
    @requests = @user.requests
    @resources = @user.resources
  end
  
end