require 'rubygems'
require 'settings.rb'
require 'git'
class RepoController < ApplicationController
    
    def createapp
        appid=params[:appid]
        name=params[:name]
        desc=params[:desc]
        
        p "appid=>#{appid}"
        App.new({
            :appid=>appid,
            :name=>name,
            :desc=>desc,
            :uid=>@user.id
        }).save!
        
        _create_repo(appid)
        
        success()
        
    end
    
    # create repo for one app
    def create_repo
        repo = params[:repo]
        
        if !repo || repo == ""
            error("invalid repository name")
            return
        end
        
        r = system "cd #{g_SETTINGS[:repo_root]}\n
               git init --bare #{repo}.git"
        
        p "system call return #{r}"
        
        success('OK', {:ret=>r})
    end
    
    # prepare work space for one for one user
    def prep_app()
        repo = params[:repo]
        init(repo+".git")
        success('OK')
    end
    
    # clone repo for user
    def init(repo)       
        p "===>#{@user.name}@#{g_SETTINGS[:git_server]}:#{g_SETTINGS[:repo_root]}/#{repo}"  
        # = Git.clone("#{@user.name}@#{g_SETTINGS[:git_server]}:#{g_SETTINGS[:repo_root]}/#{repo}",
        # repo, :path => './tmp/checkout')
         # g = Git.clone("#{@user.name}@#{g_SETTINGS[:git_server]}:#{g_SETTINGS[:repo_root]}/#{repo}", repo)
        # g.config('user.name', @user.name)
        # g.config('user.email', @user.email)
        
        command = "mkdir -p #{g_SETTINGS[:workspace_root]}/#{@user.id}\n
                cd #{g_SETTINGS[:workspace_root]}/#{@user.id}\n 
                git clone #{@user.name}@#{g_SETTINGS[:git_server]}:#{g_SETTINGS[:repo_root]}/#{repo}"
        p "command=>#{command}"
        r = system(command)
        # success('OK', {:ret=>r})
        p "==>r=#{r}"
                
    end
    
    def _create_repo(repo)
        r = system "cd #{g_SETTINGS[:repo_root]}\n
                git init --bare #{repo}.git"

        p "system call return #{r}"
         
    end
    
    
end
