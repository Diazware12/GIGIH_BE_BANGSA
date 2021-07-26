require_relative '../src/martabak'

RSpec.describe Martabak do
    it 'is delicious' do
        #given
        martabak = Martabak.new("coklat")

        #test
        taste = martabak.taste

        #text
        expect(taste).to eq("Martabak coklat is delicious")
    end
end