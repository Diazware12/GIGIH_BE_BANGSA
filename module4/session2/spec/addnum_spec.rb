require_relative '../src/addnum'

RSpec.describe AddNum do
    
    it '567 + 1 = 568' do
        #given
        checkAja = AddNum.new

        #test
        checkAja.number = [5,6,7]

        foo = checkAja.addNumber

        #text
        expect(foo).to eq([5,6,8])
    end

    it '99 + 1 = 100' do
        #given
        checkAja = AddNum.new

        #test
        checkAja.number = [9,9]

        foo = checkAja.addNumber

        #text
        expect(foo).to eq([1,0,0])
    end

    it '56 + 1 = 57' do
        #given
        checkAja = AddNum.new

        #test
        checkAja.number = [5,6]

        foo = checkAja.addNumber

        #text
        expect(foo).to eq([5,7])
    end

end