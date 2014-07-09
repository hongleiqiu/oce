class HanaRecord < ActiveRecord::Base
    #def initialize(hash)
     #   p "set table name #{self.class.to_s}"
#        set_table_name self.class.to_s.upcase
     #   super
    #end
    def self.schema
        ActiveRecord::Base.connection.schema
    end
    def self.max_id
        sql = "select max(ID) from \"#{schema}\".\"#{table_name}\""
        res = ActiveRecord::Base.connection.execute(sql)
        id = res[0][0]+1
    end
end
