class Rectangle
    attr_accessor :length, :width

    def initialize(length, width)
        @length = length
        @width = width
    end

    def getArea
        @width * @length
    end
end