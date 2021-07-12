class Game
    def initialize (playable_character)
        @non_playable_characters = {heroes: [], villains: []}
        @playable_character = playable_character
    end

    def add_hero (person)
        @non_playable_characters[:heroes] << person
    end

    def add_villain (person)
        @non_playable_characters[:villains] << person
    end

    def print_characters_stats
        @playable_character.print_stats
        @non_playable_characters.each_value do |ppl|
            ppl.each do |person|
                person.print_stats
            end    
        end
        puts "\n"
    end

    def play_characters_turn
        @playable_character.play_turn(@non_playable_characters[:heroes],@non_playable_characters[:villains])
        
        @non_playable_characters.each do |group, people|
        end
    end

    def start
        until (@playable_character.die? || @non_playable_characters[:villains].empty?) do
            print_characters_stats
            play_characters_turn
        end
    end

end