require 'anwschema.rb'
class Bomigration < ActiveRecord::Migration
    @@version =-1
    # attr_accessor :version
    def version
        if @@version == nil
            return -1
        end
        return @@version
    end
    
    # def udo_raw
    #     if self.@@udo_json == nil
    #         return nil
    #     end
    #     
    #     return JSON.parse(@@udo_json)
    #     
    # end
    
    
    def create_udo_def(hash, &block)
        ActiveRecord::AnwSchema.define(:version => self.version) do

          create_table hash[:name], :force => false do |t|
              yield(t)
              # hash[:fields].each{|f|
              #                   switch 
              #               }
              #             t.string   "appid"
              #             t.string   "name"
              #             t.string   "desc"
              #             t.integer  "uid"
              #             t.datetime "created_at"
              #             t.datetime "updated_at"
          end

          #add_index "apps3", ["appid"], :name => "index_apps3_on_appid", :unique => true
          #add_index "apps3", ["name"], :name => "index_apps3_on_name", :unique => true

        end
    end
    def add_column(do_name, column_name, column_type)
    end
    
    def drop_udo(name)
#p self
#p self.class.superclass.superclass.connection
        ActiveRecord::Migration.connection.drop_table(name)
    end
        
end   
