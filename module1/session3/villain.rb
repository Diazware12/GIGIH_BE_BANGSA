require_relative 'person'


class Villain < Person
    def initialize (name, hitpoint, attack_damage)
        super(name, hitpoint, attack_damage)
        @flee_percentage = 0.5
        @fled = false
    end

    def take_damage(damage)
        super(damage)
        if @hitpoint <= 50 and !die?
            flee if rand < @flee_percentage
        end
    end

    def flee 
        puts "#{@name} has fled the battlefield with #{@hitpoint} hitpoint left"
        @fled = true
    end

    def flee?
        @fled
    end

    def removed?
        die? || flee?
    end

end