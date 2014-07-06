require 'anwschema.rb'
class Bomigration < ActiveRecord::Migration
    @@version =-1
    # attr_accessor :version
    def self.version
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
    
    
    def self.create_udo(name, hash={}, &block)
        ActiveRecord::AnwSchema.define(:version => self.version) do

          create_table name, :force => false do |t|

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
    # ============
    # = override =
    # ============
=begin
    def initialize(appid, direction, migrations_path, target_version = nil )
      #raise StandardError.new("This database does not yet support migrations") unless Base.connection.supports_migrations?
      #Base.connection.initialize_schema_migrations_table
      #@direction, @migrations_path, @target_version = direction, migrations_path, target_version
      super(direction, migrations_path, target_version)
      @appid = appid
      # @udo_name = udo_name  
    end
=end
    def get_all_versions
      Base.connection.select_values("SELECT \"version\" FROM #{schema_migrations_table_name}").map(&:to_i).sort
    end
    def migrations
        
        # if !@udo_name || @udo_name==""
           exp_pattern = "[_a-z0-9]" 
           file_pattern = ""
         #  else
         #      exp_pattern = @udo_name
         # 
         #   file_pattern = @udo_name
         # end
         begin
             # dir = "#{repo_ws_path(@appid)}/app/migrate"
             dir  = @migrations_path
             if FileTest::exists?(dir) 
                 
                 files = Dir["#{dir}/*#{file_pattern}.rb"] 
                 _migrations = files.inject([]) do |klasses, file|
                     reg = Regexp.new("([0-9]+)_(#{exp_pattern}).rb")
                     p "([0-9]+)_(#{exp_pattern}).rb" 
                     version, name = file.scan(reg).first
                     p "#{name} #{version}"
                     raise Exception.new("IllegalMigrationNameError #{file}") unless version
                     version = version.to_i

                     # if klasses.detect { |m| m[:version] == version }
                     #     raise Exception.new("DuplicateMigrationVersionError #{version}")
                     # end

                     # if klasses.detect { |m| m[:name] == name.camelize }
                     #     raise Exception.new("DuplicateMigrationNameError #{name.camelize}")
                     # end
                     if klasses.detect { |m| m[:version] == version &&  m[:name] == name.camelize}
                         raise Exception.new("DuplicateMigrationVersionError #{version}")
                     end
                     klasses.push({
                         :name=>name.camelize,
                         #:cls =>name,
                         :version=>version,
                         :filename=>file
                     })

                 end
                 _migrations = _migrations.sort_by{|h| h[:version]}.reverse

             
             end # if FileTest::exists?(dir) 
             p "deploy udo success"

         rescue Exception => e
             p e.inspect
             p e.backtrace[1..e.backtrace.size-1].join("\n\r")
             # error("Deploy failed:<pre>"+ e.message+"</pre>")
             return
         end
         return _migrations
    end
      def record_version_state_after_migrating(version)
        sm_table = self.class.schema_migrations_table_name

        @migrated_versions ||= []
        if down?
          @migrated_versions.delete(version.to_i)
          Base.connection.update("DELETE FROM #{Base.connection.schema}.#{sm_table} WHERE version = '#{version}'")
        else
          @migrated_versions.push(version.to_i).sort!
          Base.connection.insert("INSERT INTO #{Base.connection.schema}.#{sm_table} (version) VALUES ('#{version}')")
        end
      end
end   
