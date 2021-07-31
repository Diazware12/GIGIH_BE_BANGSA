require_relative '../controller/categorycontroller'
require_relative '../controller/itemcontroller'
require_relative '../db/db_connector'



describe ItemController do
    describe '#show' do
        it "should show (view only)" do
            controller = ItemController.new
            response = controller.show
            expected_view = ERB.new(File.read("views/show.erb"))
            expect(response).to eq(expected_view.result)
        end
    end

    describe '#showWithData' do
        it "should show" do
            controller = ItemController.new
            response = controller.listItems
        end
    end
end
