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
    
    # save file
    def sf
        appid = params[:appid]
        fname = params[:fname]
        type = params[:type]
        content = params[:content]
        isnew = params[:isnew]
        
        if type == 'code'
            
        elsif type == 'bo'
            
        end
        repo = appid
        begin
            
            dir = repo_ws_path(repo)+"/app/#{type}"
            FileUtils.makedirs(dir)
            # logger.info("===========>#{dir}/#{id}<====")
            p "===>save to file #{dir}/#{fname}"
            
            aFile = File.new("#{dir}/#{fname}","w")
            aFile.puts content
            aFile.close
            p "===>save to file #{dir}/#{fname} ok"
            relative_path = "app/#{type}/#{fname}"
            if isnew == 'true'
                Git2.add_and_commit(repo, @user.name, relative_path)
            else
                Git2.commit(repo, @user.name, relative_path)
            end
          rescue Exception=>e
            # logger.error e
            p e.inspect
            p e.backtrace[1..e.backtrace.size-1].join("\n\r")
          end
          
          if isnew == 'true'
              r,m = update_to_appinfo(appid, fname, type, "add")
          else
              r,m = update_to_appinfo(appid, fname, type)
          end
                 
            if r == false
                error(m)
                return
            end
          
          # save_appinfo(appid)
          
          Git2.push(repo, @user.name)
          success()
    end
    
    # open file
    def of
        appid = params[:appid]
        fname = params[:fname]
        type = params[:type]
        repo = appid
        dir = repo_ws_path(repo)+"/app/#{type}"
        
        fname = "#{dir}/#{fname}"
        data = ""
        begin
            if FileTest::exists?(fname) 
                    open(fname, "r+") {|f|
                           data = f.read
                           
                       p "===>data(#{fname}):#{data}"
                            data = "" if data == nil
                                
                       }
                  
                   
            end
        rescue Exception=>e
             p e.inspect
             p e.backtrace[1..e.backtrace.size-1].join("\n\r")
             
        end
        
   
        success("ok", {:data=>data})
        return 
        
    end
    def update_to_appinfo(appid, fname, type, op_type="update")
        p "===>update app #{appid}"
        json = load_appinfo(appid)
        if type == "bo"
            bo_list = json['bo_list']
            if bo_list.include?(fname) == false
                bo_list.push(fname)
            else 
                if op_type == 'add'
                    return [false, "Cannot add file #{fname}, file already exists"]
                end
            end
        elsif type=='code'
            ext_list = json['ext_list']
            if ext_list.include?(fname) == false
                ext_list.push(fname)
            else 
                if op_type == 'add'
                    return [false, "Cannot add file #{fname}, file already exists"]
                end    
            end
        end
        save_appinfo(appid, json.to_json)
        return [true, "ok"]
    end
    def load_appinfo(appid)
        fname = repo_ws_path(appid)+"/.appinfo"
        json = nil
        begin
            if FileTest::exists?(fname) 
                    data= nil  
                    open(fname, "r+") {|f|
                           data = f.read
                           
                       p "===>data(#{fname}):#{data}"
                             if data
                                 json = JSON.parse(data)
                                 # yield f, json if block_given?
                                 # p "data=#{data.inspect}"
                       
                             end 
                       }
                  
                   
            end
        rescue Exception=>e
             p e.inspect
             p e.backtrace[1..e.backtrace.size-1].join("\n\r")
             
        end
        
        if json == nil
            json ={
                "bo_list"=>[],
                "ext_list"=>[]
            }
        end
        return json
        
    end
    
    def save_appinfo(appid, content)
         begin
                dir = repo_ws_path(appid)
                FileUtils.makedirs(dir)
                # logger.info("===========>#{dir}/#{id}<====")
                p "===>save to file #{dir}/.appinfo"
                p "===>content #{content}"
                aFile = File.new("#{dir}/.appinfo","w")
                aFile.puts content
                aFile.close
                relative_path = ".appinfo"
                
                Git2.add_and_commit(appid, @user.name, relative_path, "user change")
              rescue Exception=>e
                # logger.error e
                p e.inspect
              end
    end
end
