class Wli

    attr_accessor :name

    def likes
        if @name == nil || @name.size == 0 
            "no one like this"
        elsif @name.size == 1 
            "#{@name[0]} like this"
        elsif @name.size == 2 
            "#{@name[0]} and #{@name[1]} like this"
        elsif @name.size == 3 
            "#{@name[0]}, #{@name[1]}, and #{@name[2]} like this"
        else
            "#{@name[0]}, #{@name[1]}, and #{@name.size - 2} others like this"
        end
    end 
end