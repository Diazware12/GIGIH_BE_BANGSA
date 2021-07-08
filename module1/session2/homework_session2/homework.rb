require_relative 'hero'
require_relative 'army'
require_relative 'person'
require_relative 'villain'

jin = Hero.new("Jin Sakai", 100, 50)
yuna = Ally.new("Yuna", 90, 45)
sensei = Ally.new("Sensei", 80, 60)
mongol_archer = MongolArcher.new("Mongol Archer", 80, 40)
mongol_spearman = MongolSpearman.new("Mongol Spearman", 120, 60)
mongol_swordsman = MongolSwordsman.new("Mongol Swordsman", 100, 50)

allies = [yuna, sensei]
villains = [mongol_archer, mongol_spearman, mongol_swordsman]

def enemyCheck(vilainArray)
    vilainArray.each do |villain|
        vilainArray.delete(villain) if villain.die? || villain.flee?
    end
end 

def allyAttack(tempVil,tempAll,villains)
    while (tempVil.size > 0 && tempAll.size > 0) do
        ally = rand(tempAll.size)
        vill = rand(tempVil.size)
        
        getTempVil = tempVil[vill]
        getTempAlly = tempAll[ally]

        getTempAlly.attack(villains[vill])
        enemyCheck(villains)

        tempVil.delete(getTempVil)
        tempAll.delete(getTempAlly)
    end
end

i = 1
until (jin.die? || villains.empty?) do
    puts "=================== Turn #{i} ============================="
    puts "\n"

    puts jin
    allies.each do |ally|
        puts ally
    end
    puts "\n"

    villains.each do |villain|
        puts villain
    end
    puts "\n"

    puts "as #{jin.name}, what do u want to do this turn"
    puts "1) attack an enemy"
    puts "2) heal an ally"

    opt1 = gets.chomp.to_i

    if opt1 < 1 || opt1 > 2
        puts "input error"
        break
    elsif opt1 == 1
        puts "which enemy do u want to attack"
        villains.each_with_index do |villain,index|
            puts "#{index+1}) #{villain.name}"
        end

        opt2 = gets.chomp.to_i

        if opt2 < 1 || opt2 > villains.size
            puts "input error"
            break
        else
            tempVil = villains.map(&:clone)
            tempAll = allies.map(&:clone)
            
            jin.attack(villains[(opt2-1)])
            enemyCheck(villains)

            getTempVil = tempVil[(opt2-1)]       
            tempVil.delete(getTempVil)

            allyAttack(tempVil,tempAll,villains)
        end    
    else
        puts "which friend do u want to heal"
        allies.each_with_index do |ally,index|
            puts "#{index+1}) #{ally.name}"
        end
        opt2 = gets.chomp.to_i

        if opt2 < 1 || opt2 > allies.size
            puts "input error"
            break
        else
            jin.heal(allies[(opt2-1)])

            tempVil = villains.map(&:clone)
            tempAll = allies.map(&:clone)

            allyAttack(tempVil,tempAll,villains)
        end

    end
    puts "\n"

    target = [jin, allies].sample
    villains.each do |villain|
        if target == jin
            villain.attack(jin)    
        elsif target == allies && allies.size != 0
            villain.attack(allies[rand(allies.size)])
            allies.each do |ally|
                allies.delete(ally) if ally.die?
            end
        else 
            villain.attack(jin)   
        end
    end
    puts "\n"
    i += 1
end