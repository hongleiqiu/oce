# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'settings.rb'
require 'git.rb'
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :before_action
  
  def before_action
      @user = User.new
  end
  def error(msg, data=nil)
       ret = {
          "error"=>msg
      }
      ret = ret.merge(data) if data
      render :text=>ret.to_json
      # render :text=>"{\"error\":\"#{msg}\"}"
  end
  def success(msg="OK", data=nil)
      ret = {
          "OK"=>msg
      }
      ret = ret.merge(data) if data
      render :text=>ret.to_json
      
  end
  
  def repo_url(repo)
      "#{@user.name}@#{g_SETTINGS[:git_server]}:#{g_SETTINGS[:repo_root]}/#{repo}"
  end
  
  def workspace_path
      "#{g_SETTINGS[:workspace_root]}/#{@user.name}"
  end
  
  def repo_ws_path(repo)
      "#{g_SETTINGS[:workspace_root]}/#{@user.name}/#{repo}"
      
  end
end
