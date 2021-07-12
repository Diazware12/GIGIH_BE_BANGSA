require_relative 'hero'

class PlayableCharacter < Hero
    def initialize(name, hitpoint, attack_damage)
        super(name, hitpoint, attack_damage)
        @actions = ["heal","attack"]
    end

    def play_turn(heroes, villains)
        action = selected_action
        if action == "heal"
            target = selected_target(action,heroes)
            heal(target)
        elsif action == "attack"
            target = selected_target(action,villains)
            attack(target)
            villains.delete(target) if (target.die? || target.flee?)
        end
    end

    
    def selected_action
        puts "Which action do you want to do?"        
        puts "[1] heal an ally"        
        puts "[2] attack an enemy"

        selected_action_index = gets.chomp.to_i - 1
        puts "\n"

        @actions[selected_action_index]
    end


    def selected_target(action,targets)
        puts "which character do you want to #{action}?"
        targets.each_with_index do |target, index|
            puts "[#{index + 1}] #{target}"
        end
        selected_target_index = gets.chomp.to_i - 1
        puts "\n"

        selected_target = targets[selected_target_index]
    end
end