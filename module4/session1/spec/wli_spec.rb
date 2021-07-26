require_relative '../src/wli'

RSpec.describe Wli do

    it 'test no array' do
        #given
        wli = Wli.new
    
        #text
        expect(wli.likes).to eq("no one like this")
    end

    it 'test 1 array' do
        #given
        wli = Wli.new

        #test
        wli.name = ["Roy"]
    
        #text
        expect(wli.likes).to eq("Roy like this")
    end

    it 'test 2 array' do
        #given
        wli = Wli.new

        #test
        wli.name = ["Roy","Kiyoshi"]
    
        #text
        expect(wli.likes).to eq("Roy and Kiyoshi like this")
    end

    it 'test 3 array' do
        #given
        wli = Wli.new

        #test
        wli.name = ["Roy","Kiyoshi","Masako"]
    
        #text
        expect(wli.likes).to eq("Roy, Kiyoshi, and Masako like this")
    end

    it 'test 3 array' do
        #given
        wli = Wli.new

        #test
        wli.name = ["Roy","Kiyoshi","Masako","Megumi"]
    
        #text
        expect(wli.likes).to eq("Roy, Kiyoshi, and 2 others like this")
    end

end