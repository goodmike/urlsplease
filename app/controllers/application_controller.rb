class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  def render_404
    render(:file => "#{Rails.root}/public/404.html", :layout => false, :status => "404")
    return false
  end
  
  def require_user_by_userid
    return render_404 unless params[:user_id]
    @user = User.where(:nickname => params[:user_id]).first
  end
  
  def require_request_by_requestid
    return render_404 unless params[:request_id]
    @request = Request.find(params[:request_id])
  end
  
  def require_current_user_authorizing
    return render_404 unless current_user == @user
  end

  def get_user_by_userid
    @user = User.where(:nickname => params[:user_id]).first if params[:user_id]
  end
  
end
