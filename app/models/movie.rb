class Movie < ActiveRecord::Base
    def self.movies(ratings ,sortBy)
        if ratings.nil?
            self.order(sortBy)
        else
            self.where({:rating => ratings.keys}).order(sortBy)
        end
    end
    
    def self.ratings
        self.pluck(:rating).uniq
    end
end
