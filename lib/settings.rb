if ENV['RAILS_ENV'] == "development"
$SETTINGS=
     {
        :git_server=>"localhost",
        :repo_root=>"/var/mygithub",
        :workspace_root=>"./tmp/workspaces",
        :appstore_query_app_url=>"http://127.0.0.1:3001/app/query_app",
        # :console_log=>"/home/jackie/jetty-distribution-9.1.4.v20140401/logs/%04d_%02d_%02d.stderrout.log"
        :console_log=>"/Users/i027910/Desktop/SAP/src/oce/log/development.log",
        :submit_url=>"http://127.0.0.1:3001/app/presubmit",
        :ui_root_dir=>"/opt/share/sfaattachment/%s/rtspace"
        
    }


else
    $SETTINGS=
         {
            :git_server=>"localhost",
            :repo_root=>"/var/mygithub",
            :workspace_root=>"./tmp/workspaces",
            :appstore_query_app_url=>"http://127.0.0.1:3001/app/query_app",
            :console_log=>"/home/jackie/jetty-distribution-9.1.4.v20140401/logs/%04d_%02d_%02d.stderrout.log",
            :submit_url=>"http://10.58.113.181:3001/app/presubmit",
            # ui full path:
            # /opt/share/sfaattachment/T1/rtspace/com.cid.oms/src/resources/UI-INF
            #/opt/share/sfaattachment is configed in sld
            # T1 is tenant id (not tenant name)
            # com.cid.oms is app bundle id (appid)
            # content under src is ui content
            :ui_root_dir=>"/opt/share/sfaattachment/%s/rtspace"
        }
end


$FS_RT_ROOT = "/var/sa"
$FS_EXT_ROOT = "extension"
$FS_RT_EXT_ROOT = "#{$FS_RT_ROOT}/script/extroot"

    
