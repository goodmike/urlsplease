class TagSubscriptionsController < ApplicationController
  
  before_filter :authenticate_user!
  
  before_filter :require_user_by_userid
  before_filter :require_current_user_authorizing
  
  def index
    @tags = @user.tag_subscriptions
  end

  def new
  end

  def create
    @user.subscribe(params[:new_tags])
    redirect_to(user_tag_subscriptions_path(@user), :notice => "Tags added.")
  end

  def destroy
    tag = Tag.where(:contents => params[:id]).first
    @user.unsubscribe_tag(tag)
    redirect_to(user_tag_subscriptions_path(@user), :notice => "Tag '#{tag.contents}' removed.")
  end

  def show
  end

end
