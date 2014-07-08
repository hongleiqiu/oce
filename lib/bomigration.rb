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
        schema = ActiveRecord::Base.connection.schema
        # get next id for NSUDOMETA
        # in hdbsql
        # select "I027910_MASTER"."schema_migrations_seq".currval from dummy

        #ret = ActiveRecord::Base.connection.run("select #{schema}.NSUDOMETA_SEQ.nextval from dummy")
        ret = ActiveRecord::Base.connection.select_one("select #{schema}.NSUDOMETA_SEQ.nextval from dummy", "")
#p ret.fetch_all[0].to_i
        p ret.class
        p ret.size
    p ret.inspect
        id = ret.values[0]
        p "id=#{id}"
        
        # get impltable
       # sql = "select max(id) from '#{schema}'.'NSUDOTABLEALLOCINFO'"
        sql = "select max(id) from \"#{schema}\".\"NSUDOTABLEALLOCINFO\""
        res = ActiveRecord::Base.connection.execute(sql)
        impltable = res[0][0]+1
        p "impltable=#{impltable}"
        
        # insert record into table NSUDOMETA
#         sql=<<ENDD  
#         insert into '#{schema}'.'NSUDOMETA' ("ID", "NAME", "NAMESPACE", "LABEL", "PLURALLABEL", "BOSETNAME", "IMPLTABLE", "DISPLAYONMENU", "VERSION", "OWNERCODE", "CREATEDATE", "USERSIGN", "UPDATEDATE", "USERSIGN2", "INSTANCE") values (#{id}, "#{name}", "#{Migrator.appid}", "#{hash['label']}", "#{hash['PLURALLABEL']}", "#{hash['BOSETNAME']"}, "#{impltable}", #{hash['DISPLAYONMENU']}, 0, "#{hash['OWNERCODE']}", "", "", "", "", "", "", "")
# ENDD
#         p "sql=#{sql}"
#         res = Base.connection.execute(sql)
        um = UdoMeta.new({
            :id=>id,
            :name=>name,
            :namespace=>ActiveRecord::Migrator.appid,
            :label=>name, # TODO
            :impltable=>impltable,
            :bosetname=>name
        })
        um.id = id
        um.save!
        
        # get columns used by udo

        #sql = "select TABLENAME, STRCOLUMNS, TXTCOLUMNS from '#{schema}'.'NSUDOTABLEALLOCINFO' where tablename='#{name}'"
        sql = "select TABLENAME, STRCOLUMNS, TXTCOLUMNS from \"#{schema}\".\"NSUDOTABLEALLOCINFO\" where TABLENAME='#{name}'"

        p "sql=#{sql}"
        res = ActiveRecord::Base.connection.execute(sql)
        used_str_column = res[0][0]
        used_txt_colun = res[0][1]
   
        # sql = "select ID,NAMESPACE,NAME,TYPE,SIZE,DESCRIPTION,DEFAULTVALUE,LABEL,TOOLTIP,COLUMNNAME,MANDATORY,ENABLED,READONLY,ISUNIQUE,VALIDATIONRULE,BONAMESPACE,\
        # BONAME,BONODETYPENAME,OBSFIELDID,OBSTABLENAME,PACKAGENAME,ACTIVATE,LINKEDBONAME,LINKEDBONAMESPACE,CUSTOMERRORMESSAGE,FREETEXTALLOWED,SEARCHRE\
        # SULTIDENTIFIER,VERSION,OWNERCODE,CREATEDATE,USERSIGN,UPDATEDATE,USERSIGN2,INSTANCE"
   
        u = UdoDef.new
        yield(u)
    end
    
    class UdoDef
        def types
            [
                "Boolean",
                "Date",
                "Time",
                "DateTime",
                "Integer",
                "Long",
                "Double",
                "Decimal",
                "Rate",
                "Price",
                "Sum",
                "Quantity",
                "Percent",
                "Measure",
                "Tax",
                "String",
                "Text",
                "Link",
                "Address",
                "Phone",
                "Binary",
                "Memo",
                "Email",
                "Fax",
                "ZipCode"
            ]
[                "boolean",
                "date",
                "time",
                "datetime",
                "integer",
                "long",
                "double",
                "decimal",
                "rate",
                "price",
                "sum",
                "quantity",
                "percent",
                "measure",
                "tax",
                "string",
                "text",
                "link",
                "address",
                "phone",
                "binary",
                "memo",
                "email",
                "fax",
                "zipcode"
]
        end
        def method_missing(name, *args, &block) # :nodoc:
            p "name=>#{name}, args:#{args.inspect}"
p types.inspect
            if !types.include?(name.to_s)
                return super.send(name, *args, &block)
            end
            fname = args[0]
            hash = args[1]
            up = UserProperty.new({
                :ID=>nil,
                :NAMESPACE=>ActiveRecord::Migrator.appid,
                :NAME=>fname,
                :TYPE=>name
            }).save
        end
    end

=begin    

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
=end
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
      ActiveRecord::Base.connection.select_values("SELECT \"VERSION\" FROM #{schema_migrations_table_name}").map(&:to_i).sort
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
          ActiveRecord::Base.connection.update("DELETE FROM #{ActiveRecord::Base.connection.schema}.#{sm_table} WHERE version = '#{version}'")
        else
          @migrated_versions.push(version.to_i).sort!
          ActiveRecord::Base.connection.insert("INSERT INTO #{ActiveRecord::Base.connection.schema}.#{sm_table} (version) VALUES ('#{version}')")
        end
      end
end   
