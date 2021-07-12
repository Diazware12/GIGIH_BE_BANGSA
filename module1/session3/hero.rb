require_relative 'person'


class Hero < Person
    def initialize (name, hitpoint, attack_damage)
        super(name, hitpoint, attack_damage)
        @deflect_percentage = 0.8
        @healing_point = 50
    end

    def heal(ally)
        ally.take_healing(@healing_point)
    end 

    def take_damage(damage)
        if rand < @deflect_percentage
            deflect
        else
            super(damage)
        end
    end

    def deflect
        puts "#{@name} deflect the attack"
    end
end

# class Ally < Person
#     def initialize (name, hitpoint, attack_damage)
#         super(name, hitpoint, attack_damage)
#     end

#     def receive_heal (healing_point)
#         @hitpoint += healing_point
#     end
# end