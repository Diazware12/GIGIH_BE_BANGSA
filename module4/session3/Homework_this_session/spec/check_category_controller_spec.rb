require_relative '../controller/categorycontroller'
require_relative '../controller/itemcontroller'
require_relative '../db/db_connector'



describe CategoryController do

    describe "#index" do
        context "given valid parameter" do
            it "should show all category" do
                controller = CategoryController.new

                expect(Category).to receive(:get_all_categories).and_return([])
                expect(Category).to receive(:get_all_categories).and_return([])

                result = controller.listCategory
                categories = Category.get_all_categories
                expected_view = ERB.new(File.read('./views/show_categories.erb')).result(binding)

                expect(result).to eq(expected_view)
            end
        end
    end

    describe "#add" do
        context "new item" do
            it "should return form" do
                stub_client = double
                stub_query = "insert into categories (name) values ('comfort food')"
                category = Category.new({
                    id: 1,
                    name: 'comfort food'
                })
                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                category.save
            end
        end
    end

    describe "#update" do
        context "given valid parameter" do
            it "should return true" do
                stub = double
                
                controller = CategoryController.new
                params = {
                    "id"=> 1,
                    "name"=> "foo"
                }
                stub_query_1 = "UPDATE categories SET name=foo WHERE id = 1"

                category = Category.new({
                    "id": 1,
                    "name": "foo"
                })
                allow(Mysql2::Client).to receive(:new).and_return(stub)
                expect(Category).to receive(:get_categories).with(1).and_return(category)
                expect(stub).to receive(:query).with(stub_query_1)

                result = controller.editCategory(params)
                expect(result).to eq(true)
            end
        end

        context "invalid parameter" do
            it "should return false" do
                params = {
                    "id"=> 1,
                    "name"=> "foo"
                }
                expect(Category).to receive(:get_categories).with(1).and_return(nil)

                controller = CategoryController.new

                result = controller.editCategory(params)

                expect(result).to be(false)
            end
        end
    end

    describe "#delete" do
        context "valid" do
            it "success" do
                stub = double
                params = {
                    "id"=> 1
                }
                category = Category.new({
                    id: 1,
                    name: 'foo'
                })

                stub_query_2 = "delete from categories where id = 1 and name = 'foo'"

                allow(Mysql2::Client).to receive(:new).and_return(stub)
                expect(Category).to receive(:get_categories).with(1).and_return(category)
                expect(stub).to receive(:query).with(stub_query_2)
                expect(Category).to receive(:get_categories).with(1).and_return(nil)

                controller = CategoryController.new

                controller.deleteCategory(params)

                result = Category.get_categories(1)

                expect(result).to be_nil
            end
        end

        context "invalid" do
            it "fail" do
                stub = double
                params = {
                    "id"=> 1
                }

                allow(Mysql2::Client).to receive(:new).and_return(stub)
                expect(Category).to receive(:get_categories).with(1).and_return(nil)

                controller = CategoryController.new

                result = controller.deleteCategory(params)

                expect(result).to eq(false)
            end
        end
    end



end
