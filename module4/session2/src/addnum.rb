class AddNum

    attr_accessor :number

    def addNumber
        result = Array.new
        temp = 0
        (@number.length-1).downto(0) do |index|
            num = index == (@number.length-1) ? @number[index] + 1 + temp : @number[index] + temp
            if num > 9
                result << num - 10
                temp = 1
            else
                result << num
                temp = 0
            end
        end
        if temp == 1 
            result << temp
        end
        result.reverse
    end 
end