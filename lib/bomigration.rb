class Bomigration < ActiveRecord::Migration
    def version
        if @version == nil
            return -1
        end
        return @version
    end
end   