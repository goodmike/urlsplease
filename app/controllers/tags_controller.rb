class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.where(:contents => params[:id]).first
    @requests = @tag.taggings.find_requests
  end

end
