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
end   