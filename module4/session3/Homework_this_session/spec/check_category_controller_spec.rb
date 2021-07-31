require_relative '../controller/categorycontroller'
require_relative '../controller/itemcontroller'
require_relative '../db/db_connector'



describe CategoryController do

    before(:each) do
        client = create_db_client
        client.query('truncate item_categories')
        client.query('set FOREIGN_KEY_CHECKS = 0')
        client.query('truncate table items')
        client.query('truncate table categories')
        client.query('set FOREIGN_KEY_CHECKS = 1')
        client.query('insert into categories (name) values ("Soft Drink")')
    end


    describe '#show' do
        it "should show (view only)" do
            controller = CategoryController.new
            response = controller.show
            expected_view = ERB.new(File.read("views/show.erb"))
            expect(response).to eq(expected_view.result)
        end
    end

    describe '#showWithData' do
        it "should show" do
            controller = CategoryController.new
            response = controller.listCategory
        end
    end
end
