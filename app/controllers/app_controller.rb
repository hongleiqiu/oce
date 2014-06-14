# require 'base64'
require 'cgi'
class AppController < ApplicationController
    
    def list
        @apps = App.find_by_sql("select * from apps where uid=#{@user.id}")
    end
    
    def app
    end
    def delapp
        repo = appid = params[:appid]
        
        if !repo || repo == ""
            error("invalid repository name")
            return
        end
        
        # r = system "cd #{$SETTINGS[:repo_root]}\n
        #        git init --bare #{repo}.git"
        
        # p "system call return #{r}"
        # 
        begin
            p "appid=>#{appid}"
            rs = ActiveRecord::Base.connection.execute("delete from apps where appid='#{appid}'")
        rescue Exception=>e
            error("delet app from db failed #{e.inspect}")
            return
        end
        
        begin
            FileUtils.rm(repo_ws_path(appid))
        rescue Exception=>e
            error("delete app files failed #{e.inspect}")
            return
        end       
        success()
    end
    def ld
        p "===>d33e3"
        appid= params[:appid]
=begin        
        rs = App.find_by_sql("select * from apps where appid='#{appid}'")
        if rs == nil || rs.size == 0
            error("No such App")
            return
        end
        app = rs[0]
=end        
        data = http_post($SETTINGS[:appstore_query_app_url], {:appid=>appid})
        p "--->#{data}"
        ret = JSON.parse(data)
        if ret['error']
            error(ret['error'])
            return
        end
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
    
    # /project/extension/untitle1.rb => {
    # :path=>"/project/extension/Untitled1.rb",
    # :cat2=>"Untitled1.rb", 
    # :project=>"project",
    # :cat1=>"extension", 
    # :relative_dir=>"extension", 
    # :relative_path=>"extension/Untitled1.rb", 
    # :fname=>"Untitled1.rb"
    # }
    # save file to ./tmp/workspaces/i027910/rrr/app/extension/Untitled1.rb
    def fileInfoFromPath(path)
        p "===>path #{path}"
        b = path.split('/')
        fname = b[b.size-1]
        if path.start_with?("/")
            b = b[1..b.size-1]
        end
            prj = b[0]
         p "===>prj=#{prj} #{b.size}"
         cat = b[1]
         cat2 = nil
         if (b.size > 2)
             cat2 = b[2]
         end
        r =  {
             :path=>path,
             :project=>prj,
             :fname=>fname,
             :cat1=>cat,
             :cat2=>cat2,
             :relative_path=>b[1..b.size-1].join("/"),
             :relative_dir=>b[1..b.size-2].join("/")

         }
         p r
        return {
            :path=>path,
            :project=>prj,
            :fname=>fname,
            :cat1=>cat,
            :cat2=>cat2,
            :relative_path=>b[1..b.size-1].join("/"),
            :relative_dir=>b[1..b.size-2].join("/")
            
        }
    end
    
    # rename file
    # appid:
    # fname: path,
    # name: new name,
    # type: node.type
    def ren
        appid = params[:appid]
        path = params[:fname]
        type = params[:type] 
        fi= fileInfoFromPath(path)
        new_name = params[:name]
        
        
        dir_path = repo_ws_path(repo)+"/app/#{fi[:relative_dir]}"
        file_path = "#{dir_path}/#{fname}"
        new_file_path = "#{dir_path}/#{new_name}"
        # the path used by git commit
        git_relative_path = "app/#{fi[:relative_path]}"
        git_newfile_rpath = "app/#{fi[:relative_dir]}/#{new_name}"
        
        begin
            if (!FileTest::exists?(file_path) )
                error("File not exists")
                return
            end
            File.rename(file_path, new_file_path)
            
            Git2.add_and_commit(appid, @user.name, git_newfile_rpath)
            
        rescue Expcetion=>e
           # logger.error e
            p e.inspect
            p e.backtrace[1..e.backtrace.size-1].join("\n\r")
        end
    
    end
    
    # save file
    def sf
        appid = params[:appid]
        path = params[:fname]
        type = params[:type]
        content = params[:content]
        isnew = params[:isnew]
        
        fi= fileInfoFromPath(path)
        fname = fi[:fname]
        
        if type == 'code'
            
        elsif type == 'bo'
            
        end
        repo = appid
        begin
            
            dir = repo_ws_path(repo)+"/app/#{fi[:relative_dir]}"
            FileUtils.makedirs(dir)
            # logger.info("===========>#{dir}/#{id}<====")
            p "===>save to file #{dir}/#{fname}"
            
            file_path = "#{dir}/#{fname}"
            if isnew == 'true' && FileTest::exists?(file_path) 
                error("Cannot add file #{fname}, file already exists")
                return 
            end
            
            aFile = File.new("#{dir}/#{fname}","w")
            aFile.puts content
            aFile.close
            p "===>save to file #{dir}/#{fname} ok"
            relative_path = "app/#{fi[:relative_path]}"
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
              r,m = update_to_appinfo(appid, fi, "add")
          else
              r,m = update_to_appinfo(appid, fi)
          end
                 
            if r == false
                error(m)
                return
            end
          
          # save_appinfo(appid)
          
          Git2.push(repo, @user.name)
          success()
    end
    
    # deploy to dev environment
    # appid 
    def deploy
        appid = params[:appid]
        app_root_dir = repo_ws_path(appid)
        ext_root_dir = "#{app_root_dir}/app/#{$FS_EXT_ROOT}"
        
        dest = "#{$FS_RT_EXT_ROOT}/#{appid}"
        begin
            FileUtils.mkdir_p(dest)
            p "copy #{ext_root_dir} to #{dest}"
            FileUtils.copy_entry(ext_root_dir, "#{dest}/")
        rescue Exception => e
            p e.inspect
            p e.backtrace[1..e.backtrace.size-1].join("\n\r")
            error("Deploy failed:<pre>"+ e.message+"</pre>")
            return
        end
        p "deploy ok"
        dev_server_b1_url = @user.dev_server_b1_url
        success("Deploy successfully", {:url=>"#{dev_server_b1_url}"})
    end
    
    # open file
    def of
        appid = params[:appid]
        path = params[:fname]
        type = params[:type]
        repo = appid
        fi= fileInfoFromPath(path)
        fname = fi[:fname]
        
        # dir = repo_ws_path(repo)+"/app/#{fi[:relative_dir]}"
        
        fname = "#{repo_ws_path(repo)}/app/#{fi[:relative_path]}"
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
    
    def updateJSonList(json, list_name, path, op_type ="add")
        p "updateJSonList1(#{list_name}): #{json}"
        bo_list = json[list_name]
        if bo_list == nil
            bo_list =[]
            json[list_name] = bo_list
        end
        if bo_list.include?(path) == false
            bo_list.push(path)
        else 
            if op_type == 'add'
                return [false, "Cannot add file #{path}, file already exists"]
            end
        end
        p "updateJSonList2: #{json}"
        
    end
    
    def update_to_appinfo(appid, fi, op_type="update")
        p "===>update app #{appid}, fname #{fi[:fname]}, cat #{fi[:cat1]}"
        fname = fi[:fname]
        path = fi[:path]
        cat = fi[:cat1]
        cat2 = fi[:cat2]
        json = load_appinfo(appid)
        p "cat=>#{cat}"
        if cat == "bo_root"
            updateJSonList(json, "bo_list", path, op_type)
        elsif cat=='extension'
            updateJSonList(json, "ext_list", path, op_type)
            
            
        elsif cat == "service_root"
            updateJSonList(json, "service_list", path, op_type)
            
        elsif cat == "ui_root" && cat2 != nil
            if cat2 == "ui_root_m"
                updateJSonList(json, "ui_mobile", path, op_type)
            elsif cat2== "ui_root_u"
                updateJSonList(json, "ui_universal", path, op_type)
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
                "ext_list"=>[],
                "sevice_list"=>[],
                "ui_mobile"=>[],
                "ui_universal"=>[]
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
    # tail log
    def tlog
        ln = params[:ln].to_i
        t = Time.now
        logfile = sprintf($SETTINGS[:console_log], t.year, t.month, t.day )
        p "==>logfile:#{logfile}"
        ar = []
         begin
                if FileTest::exists?(logfile)
                    p "grep -Fc \"\" #{logfile}"
                    line_number = `grep -Fc "" #{logfile}`.to_i
                    f=File.open(logfile,"r")  
                    t = nil      
                    
                    line_number = 0 if !line_number
                    
                    start_line = line_number-ln
                    start_line = 0 if start_line < 0
                        
                    f.readlines[start_line..line_number].each do |line| 
                        ar.push("#{line}<br/>")
                    end
                end
        rescue Exception=>e
            p "===>aaa"+e.inspect
            error(e.inspect)
            return
        end
        p "===>ar:#{ar.join('')}"
        # c = Base64.encode64(ar.join("\n"))
        c = CGI.escape(ar.join("\n"))
        success("OK",{
            :start_line =>start_line,
            :c=>c
            
        })
        return
    end
    # retrieve log
    def rlog
        # logfile = params[:logfile]
        startline = params[:sl]
        startline = 0 if startline == nil
        startline = startline.to_i
        startline += 1
        line_num = params[:ln]
        if line_num == nil
            line_num = 100 
        else
            line_num = line_num.to_i
        end
        max_line = 500
        t = Time.now
        p $SETTINGS[:console_log]
        logfile = sprintf($SETTINGS[:console_log], t.year, t.month, t.day )
        p "==>logfile:#{logfile}"
        ar = []
         begin
                if FileTest::exists?(logfile)
                     f=File.open(logfile,"r")  
                        t = nil      
                    p "start line #{startline}, line_num  #{line_num}"
                    if line_num < 0
                        f.readlines[startline+line_num..startline].each do |line| 
                            ar.push("#{line}<br/>")
                        end
                    else
                        f.readlines[startline..startline+line_num].each do |line| 
                            ar.push("#{line}<br/>")
                        end
                    end
                end
        rescue Exception=>e
            p e.inspect
            render :text=>""
            return
        end
        
        # if line_num < 0
            # ar.reverse!
        # end
        p "log:#{ar.join("<br/>")}"
        render :text=>ar.join("\n")
        return
    end

    def submit
        redirect_to "#{$SETTINGS[:submit_url]}?appid=#{params[:appid]}"
    end
end
