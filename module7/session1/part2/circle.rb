class Circle
    attr_accessor :radius

    def initialize(radius)
        @radius = radius
    end

    def getArea
        Math::PI * @radius**
    end
end