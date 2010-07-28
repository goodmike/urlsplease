class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  before_filter :check_recaptcha_for_devise, :only => :create
  
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

  # From http://wiki.github.com/djtek/devise/recaptcha-with-devise-10
  def check_recaptcha_for_devise
    # mark Devise Controllers to be excluded from verify_recaptcha
    except_devise_controllers = [:sessions, :passwords]

    # check if it's a devise_controller? and if marked for verify_recaptcha
    if devise_controller? && !except_devise_controllers.include?(controller_name.to_sym)

      # build the resource first and then check recaptcha challenge
      build_resource
      unless verify_recaptcha()

        # if it fails add the error and render the form back to the client
        message = 'reCaptcha characters didn\'t match the word verification'
        resource.errors.add_to_base(message)
        render_with_scope :new
      end
    end
  end

  
end

