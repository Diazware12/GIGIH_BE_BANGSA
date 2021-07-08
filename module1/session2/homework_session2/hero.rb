require_relative 'person'


class Hero < Person
    def initialize (name, hitpoint, attack_damage)
        super(name, hitpoint, attack_damage)
        @deflect_percentage = 0.8
    end

    def heal (ally)
        restore = 20
        ally.receive_heal(restore)
        puts "#{@name} heals #{ally.name} the attack, restoring #{restore} hitpoint"
    end 

    def take_damage(damage)
        if rand < @deflect_percentage
            puts "#{@name} deflect the attack"
        else
            @hitpoint -= damage
        end
    end
end

class Ally < Person
    def initialize (name, hitpoint, attack_damage)
        super(name, hitpoint, attack_damage)
    end

    def receive_heal (healing_point)
        @hitpoint += healing_point
    end
end