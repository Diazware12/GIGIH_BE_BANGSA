require_relative 'person' 

jin = Heroes.new("Jin Sakai",100,50,true)
puts jin
puts "\n"

khotun = Enemy.new("Khotun Khan",500,50)
puts khotun
puts "\n"

loop do
    jin.attack(khotun)
    puts khotun
    puts "\n"
    break if khotun.die?

    khotun.attack(jin)
    puts jin
    puts "\n"
    break if jin.die?    
end