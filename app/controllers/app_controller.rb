class AppController < ApplicationController
    
    def list
        @apps = App.find_by_sql("select * from apps where uid=#{@user.id}")
    end
    
    def app
    end
    
    def ld
        p "===>d33e3"
        appid= params[:appid]
        rs = App.find_by_sql("select * from apps where appid='#{appid}'")
        if rs == nil || rs.size == 0
            error("No such App")
            return
        end
        app = rs[0]
        
        repo = appid
        repo_url = repo_url(appid)
        # clone if not yet
        if File.exists?(repo_ws_path(appid)+"/.git/config") == false
            Git2.clone(repo, @user.name)
        end
            
        # pull if not yet
        # Git2.pull(repo, @user.name)
        
        json = load_appinfo(repo)
        
        ret = {
            :data_root=>json
        }
        p ret.to_json
        render :text=>ret.to_json
        
    end
    
    def sf
        appid = params[:appid]
        fname = params[:fname]
        type = params[:type]
        if type == 'extension'
            
        elsif type == 'bo'
            
        end
        repo = appid
        begin
            dir = repo_ws_path(repo)+"/app/#{type}"
            FileUtils.makedirs(dir)
            # logger.info("===========>#{dir}/#{id}<====")
            aFile = File.new("#{dir}/#{fname}","w")
            aFile.puts content
            aFile.close
          rescue Exception=>e
            # logger.error e
            p e.inspect
          end
          
          update_to_appinfo(app, fname, type)
          save_appinfo
          success()
    end
    
    def update_to_appinfo(appid, fname, type)
        json = load_appinfo(appid)
        if type == "bo"
            bo_list = json.bo_list
            if bo_list.include?(fname) == false
                bo_list.push(fname)
            end
        elsif type=='extension'
            if ext_list.include?(fname) == false
                ext_list.push(fname)
            end
        end
        save_appinfo(appid)
    end
    def load_appinfo(appid)
        fname = repo_ws_path(appid)+"/.appinfo"
        json = nil
        begin
            if FileTest::exists?(fname) 
                    data= nil  
                    open(fname, "r+") {|f|
                           data = f.read
                       
                             if data
                                 json = JSON.parse(data)
                                 # yield f, json if block_given?
                                 # p "data=#{data.inspect}"
                       
                             end 
                       }
                  
                   
            end
        rescue Exception=>e
             p e.inspect
        end
        
        if json == nil
            json ={
                "bo_list"=>[],
                "ext_list"=>[]
            }
        end
        return json
        
    end
    
    def save_appinfo(appid)
         begin
                dir = repo_ws_path(repo)
                FileUtils.makedirs(dir)
                # logger.info("===========>#{dir}/#{id}<====")
                aFile = File.new("#{dir}/#{".appinfo"}","w")
                aFile.puts content
                aFile.close
              rescue Exception=>e
                # logger.error e
                p e.inspect
              end
    end
end
