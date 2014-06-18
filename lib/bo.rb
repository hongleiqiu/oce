
class BO

    def create_bo
    end
    
    def drop_bo
    end
    
    # by subclass
    def setup
        {
            :name=>"Abc",
            :type=>"udo"
        }
    end
    
    def create
        create_bo do |t|
        end
    end
    
    
    def drop
      drop_bo 
    end
end