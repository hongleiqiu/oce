require "settings.rb"

class Git2

    def self.clone( repo, username)
        p "===>#{username}@#{g_SETTINGS[:git_server]}:#{g_SETTINGS[:repo_root]}/#{repo}"  
        
          command = "mkdir -p #{g_SETTINGS[:workspace_root]}/#{username}\n
                    cd #{g_SETTINGS[:workspace_root]}/#{username}\n 
                    git clone #{username}@#{g_SETTINGS[:git_server]}:#{g_SETTINGS[:repo_root]}/#{repo}"
            p "command=>#{command}"
            r = system(command)
            # success('OK', {:ret=>r})
            p "==>r=#{r}"
            return r
    end
    
    def self.pull(repo, username)
        p "===>#{username}@#{g_SETTINGS[:git_server]}:#{g_SETTINGS[:repo_root]}/#{repo}"  
        
              command = "cd #{g_SETTINGS[:workspace_root]}/#{username}/#{repo}\n 
                        git pull"
                p "command=>#{command}"
                r = system(command)
                # success('OK', {:ret=>r})
                p "==>r=#{r}"
                return r
        
    end
    def self.push(repo, username)
        p "===>#{username}@#{g_SETTINGS[:git_server]}:#{g_SETTINGS[:repo_root]}/#{repo}"  
        
              command = "cd #{g_SETTINGS[:workspace_root]}/#{username}/#{repo}\n 
                        git push origin master"
                p "command=>#{command}"
                r = system(command)
                # success('OK', {:ret=>r})
                p "==>r=#{r}"
                return r
        
    end  
     
    def self.add_and_commit(repo, username, filepath, msg="c")
         p "===>#{username}@#{g_SETTINGS[:git_server]}:#{g_SETTINGS[:repo_root]}/#{repo}"  

         command = "cd #{g_SETTINGS[:workspace_root]}/#{username}/#{repo}\n 
                git add \"#{filepath}\" "
        p "command=>#{command}"
        r = system(command)
        # success('OK', {:ret=>r})
        p "==>r=#{r}"
        self.commit(repo, username, filepath, msg)
    end
    def self.commit(repo, username, filepath, msg="c")
        p "===>#{username}@#{g_SETTINGS[:git_server]}:#{g_SETTINGS[:repo_root]}/#{repo}"  
        
              command = "cd #{g_SETTINGS[:workspace_root]}/#{username}/#{repo}\n 
                        git commit \"#{filepath}\" -m \"#{msg}\""
                p "command=>#{command}"
                r = system(command)
                # success('OK', {:ret=>r})
                p "==>r=#{r}"
                return r
        
    end
end