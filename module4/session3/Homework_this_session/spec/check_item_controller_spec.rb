require_relative '../controller/categorycontroller'
require_relative '../controller/itemcontroller'
require_relative '../model/items'
require_relative '../model/categories'
require_relative '../db/db_connector'

describe ItemController do
    describe "#index" do
        context "valid param" do
            it "show item" do
                controller = ItemController.new
                result = controller.listItems
                items = Item.get_all_items
                categories = Category.get_all_categories

                allow(Item).to receive(:get_all_items).and_return([])
                expected_view = ERB.new(File.read('./views/index.erb')).result(binding)
                expect(result).to eq(expected_view)
            end
        end
    end


    describe "#create" do
        context "valid" do
            it "make a new item" do
                stub = double
                
                controller = ItemController.new
                cat = Category.new({
                    id:1,
                    name:"Italia"
                })  
                cat.save
                params = {
                    "id"=> 1,
                    "name"=> 'Pizza',
                    "price"=> 2000,
                    "category"=>cat
                }
    
                expect(Item).to receive(:new).with(params).and_return(stub)
                expect(stub).to receive(:valid?).and_return(true)
                expect(stub).to receive(:save)
    
                controller.createItems(params)

                expect(Item).to receive(:get_selected_item).with(1).and_return(stub)
                result_item = Item.get_selected_item(1)
                expect(result_item).not_to be_nil
            end
        end

        context "invalid" do
            it "make a new item" do
                stub = double
                
                controller = ItemController.new
                cat = Category.new({
                    id:1,
                    name:"Italia"
                })  
                cat.save
                params = {
                    "id"=> 1,
                    "name"=> 'Pizza',
                    "price"=> 2000,
                    "category"=>cat
                }
    
                expect(Item).to receive(:new).with(params).and_return(stub)
                expect(stub).to receive(:valid?).and_return(nil)
    
                result = controller.createItems(params)

                expect(result).to eq(false)
            end
        end



    end


    describe "#update" do
        context "given valid parameter" do
            it "should return true" do
                stub = double
                
                controller = ItemController.new
                cat = Category.new({
                    id:1,
                    name:"italian"
                })
                params = {
                    "id"=> 1,
                    "name"=> "pizza",
                    "price"=> 1000,
                    "category"=>cat
                }
                stub_query_1 = 'UPDATE item_categories SET category_id=1 WHERE item_id = 1'
                stub_query_2 = 'UPDATE items SET name="pizza", price=1000 WHERE id = 1'

                item = Item.new({
                    id: 1,
                    name: 'pizza',
                    price: 1000,
                    category: cat
                  })
                allow(Mysql2::Client).to receive(:new).and_return(stub)
                expect(Item).to receive(:get_selected_item).with(1).and_return(item)
                expect(stub).to receive(:query).with(stub_query_1)
                expect(stub).to receive(:query).with(stub_query_2)

                result = controller.editItems(params)
                expect(result).to eq(true)
            end
        end

        context "given item id not found" do
            it "should return false" do
                cat = Category.new({
                    id:1,
                    name:"italian"
                })
                params = {
                    "id"=> 1,
                    "name"=> "pizza",
                    "price"=> 1000,
                    "category"=>cat
                }
                expect(Item).to receive(:find_by_id).with(1).and_return(nil)

                controller = ItemController.new

                result = controller.update(params)

                expect(result).to be(false)
            end
        end
    end


    describe "#delete" do
        context "valid" do
            it "success" do
                cat = Category.new({
                    id:1,
                    name:"italian"
                })

                stub = double
                params = {
                    "id"=> 1
                }
                item = Item.new({
                    id: 1,
                    name: '',
                    price: 1000,
                    category: cat
                  })

                stub_query_3 = 'DELETE FROM items WHERE id = 1'

                allow(Mysql2::Client).to receive(:new).and_return(stub)
                expect(Item).to receive(:get_selected_item).with(1).and_return(item)
                expect(stub).to receive(:query).with(stub_query_3)
                expect(Item).to receive(:get_selected_item).with(1).and_return(nil)

                controller = ItemController.new

                controller.deleteItems(params)

                result = Item.get_selected_item(1)

                expect(result).to be_nil

            end
        end

        context "invalid" do
            it "failed" do
                stub = double
                params = {
                    "id"=> 1
                }
                cat = Category.new({
                    id:1,
                    name:"italian"
                })
                item = Item.new({
                    id: 1,
                    name: 'Pizza',
                    price: 1000,
                    category: cat
                  })

                allow(Mysql2::Client).to receive(:new).and_return(stub)
                expect(Item).to receive(:get_selected_item).with(1).and_return(nil)

                controller = ItemController.new

                result = controller.deleteItems(params)

                expect(result).to eq(false)
            end
        end
    end
    
    describe "#add" do
        context "new item" do
            it "should show form for adding item" do
                stub_client = double
                stub_query = "INSERT INTO items (name, price) VALUES (a, 1000)"

                cat = Category.new({
                    id:1,
                    name:"Jamuan"
                })
                cat.save
                item = Item.new({
                    id: 1, 
                    name: "a", 
                    price: 1000, 
                    category: cat
                })
                saveItemCategory = ItemCategories.new(1, cat.id)
                saveItemCategory.save
                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                item.save
            end
        end
    end
end
