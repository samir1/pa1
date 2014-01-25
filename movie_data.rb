# Author: Samir Undavia

class MovieData

    def initialize
        @popularityMovieToRatings = Hash.new
        @userRatings = Hash.new
    end

    def load_data
        File.foreach("u.data") do |line|
            lineArray = line.split("\t").map(&:to_i)
            hashCheckAndAddSum @popularityMovieToRatings, lineArray[1], lineArray[2]
            hashCheckandAddValueWithTwoKeys @userRatings, lineArray[0], lineArray[1], lineArray[2]
        end
    end

    # popularity is the sum of all scores for each movie because if a movie had low scores, but a lot of people rated it, it is sill a popular movie
    def popularity(movie_id)
        return @popularityMovieToRatings[movie_id]
    end

    def popularity_list
        h = @popularityMovieToRatings.sort_by {|k,v| v}.reverse
        list = Array.new
        for x in h
            list.push(x[0])
        end
        return list
    end

    # similarity sees is user1 has any movies rated in common with user2. If there is a common movie rated, 5-(the distance away from the ratings) is added to similarity, so ratings that are closer to each other have a higher similarity
    def similarity(user1,user2)
        arr1 = @userRatings[user1]
        arr2 = @userRatings[user2]
        similar = 0
        for x in arr1.keys
            if arr2.has_key?(x)
                similar += 5-((arr1[x]-arr2[x]).abs)
            end
        end
        return similar
    end

    def most_similar(u)
        sim = 0
        simArray = Array.new
        for x in @userRatings.keys
            if x != u
                currentSim = similarity(u,x)
                if currentSim > sim
                    sim = currentSim
                    simArray = Array.new
                    simArray.push x
                elsif currentSim == sim
                    simArray.push x
                end
            end
        end
        return simArray
    end

    def hashCheckAndAddSum hash, key, value
        if !hash.has_key?(key)
            hash[key] = 0
        end
        hash[key] += value
    end

    def hashCheckandAddValueWithTwoKeys hash, key1, key2, value
        if !hash.has_key?(key1)
            hash[key1] = Hash.new
        end
        hash[key1][key2] = value
    end

end

movie = MovieData.new
movie.load_data
popList = movie.popularity_list
puts "first and last ten elements of popularity list"
puts popList[0...10]
puts "..."
puts popList[popList.length-10..popList.length]
puts
puts
puts "most_similar(1)"
puts movie.most_similar(1)