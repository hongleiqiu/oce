class AppController < ApplicationController
    
    def list
        @apps = App.find_by_sql("select * from apps where uid=#{@user.id}")
    end
    
    def app
    end
end
