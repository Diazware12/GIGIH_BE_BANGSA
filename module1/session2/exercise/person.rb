class Person
    attr_reader :name, :hitpoint, :attack_damage

    def initialize (name, hitpoint, attack_damage)
        @name = name
        @hitpoint = hitpoint
        @attack_damage = attack_damage
    end

    def to_s
        "#{@name} has #{@hitpoint} hitpoint and #{@attack_damage} attack damage"
    end

    def attack(other_person)
        puts "#{@name} attacks #{other_person.name} that has #{other_person.hitpoint} hitpoint and #{other_person.attack_damage} attack damage"
    end

    def take_damage(damage)
        @hitpoint -= damage
    end

    def die?
        if @hitpoint <= 0
            puts "#{@name} dies"
            true
        end
    end    



end

class Heroes < Person

    def initialize (name, hitpoint, attack_damage, evade_ability)
        super(name, hitpoint, attack_damage)
        @evade_ability = evade_ability
    end

    def to_s
        "#{@name} has #{@hitpoint} hitpoint and #{@attack_damage} attack damage"
    end

    def attack(other_person)
        other_person.take_damage(@attack_damage)
        puts "#{@name} attacks #{other_person.name} that has #{other_person.hitpoint} hitpoint and #{other_person.attack_damage} attack damage"
    end

    def evade?
        evade_action = [true, true, true, true, true, true, true, true, false, false].sample
        if evade_action == true
            true
        end
    end    

    def ability_check?
        if @evade_ability == true
            return true
        else
            return false
        end
    end

    def getName
        return @name
    end

end

class Enemy < Person

    attr_reader :name, :hitpoint, :attack_damage

    def initialize (name, hitpoint, attack_damage)
        super(name, hitpoint, attack_damage)
    end

    def attack(other_person)
        if not other_person.ability_check?
            other_person.take_damage(@attack_damage)
            puts "#{@name} attacks #{other_person.name} that has #{other_person.hitpoint} hitpoint and #{other_person.attack_damage} attack damage"
        else
            if not other_person.evade?
                other_person.take_damage(@attack_damage)
                puts "#{@name} attacks #{other_person.name} that has #{other_person.hitpoint} hitpoint and #{other_person.attack_damage} attack damage"
            else
                puts "#{other_person.getName} deflects the attack"
                puts "\n"
            end
        end
    end

end