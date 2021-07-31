require_relative '../model/categories'
require_relative '../model/items'
require_relative '../model/item_categories'
require_relative '../db/db_connector'
require 'mysql2'

describe Item do

    # =================== valid initialize =====================

    describe '#validInitItem' do
        context 'init input item' do
            it 'should be true' do
                cat = Category.new({
                    id:1,
                    name:"Jamuan"
                })
                item = Item.new({
                    id: 1, 
                    name: "a", 
                    price: 1000, 
                    category: cat
                })
                expect(item.valid?).to eq(true)
            end
        end 

        context 'init input item' do
            it 'should be false' do
                cat = Category.new({
                    id:1,
                    name:"Jamuan"
                })
                item = Item.new({
                    id: 1, 
                    name: "a", 
                    category: cat
                })
                expect(item.valid?).to eq(false)
            end
        end 


    end

    # =================== valid select all =====================


    describe '#validSelectAllItems' do
        context 'select all items' do
            it 'should be true' do

                stub_client = double
                stub_query = "SELECT items.id as id, items.name as name, items.price as price, categories.name as category_name, categories.id as category_id FROM items JOIN item_categories JOIN categories WHERE items.id = item_categories.item_id and categories.id = item_categories.category_id"
                items = [{"id": 1, "name": "a", "price": 1000, "category_id": 1, "category_name": "b"}]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return(items)

                item = Item.get_all_items
                expect(item).not_to be_nil
            end
        end 
    end  


    # =================== valid get =====================

    describe '#validSelectItem' do
        context 'select data' do
            it 'there\'s a data' do
                stub_client = double
                stub_query = "select * from (select * from items where id = 1) item inner join item_categories on item_id = item.id"
                items = [{"id": 1, "name": "a", "price": 1000, "category_id": 1, "category_name": "b"}]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return(items)

                item = Item.get_selected_item(1)
                expect(item).not_to be_nil
            end
        end

        context 'select data' do
            it 'there\'s a data' do
                stub_client = double
                stub_query = "select * from (select * from items where id = 1) item inner join item_categories on item_id = item.id"
                
                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return([])
                
                item = Item.get_selected_item(1)
                expect(item).to eq(nil)
            end
        end

    end

    # =================== valid save =====================

    describe 'save' do
        context 'when executed' do
            it 'should save data' do
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
    # =================== valid update =====================

    describe 'update' do
        context 'when executed' do
            it 'should change data' do
                stub_client = double
                stub_query_1 ="UPDATE item_categories SET category_id=1 WHERE item_id = 1"
                stub_query_2 ="UPDATE items SET name=a, price=1000 WHERE id = 1"
                cat = Category.new({
                    id:1,
                    name:"Jamuan"
                })
                item = Item.new({
                    id: 1, 
                    name: "a", 
                    price: 1000, 
                    category: cat
                })
                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1)
                expect(stub_client).to receive(:query).with(stub_query_2)
                item.update
            end
        end
    end

    # =================== valid delete =====================

    describe 'delete' do
        context 'when executed' do
            it 'should delete data' do
                stub_client = double
                stub_query = "DELETE FROM items WHERE id = 1"

                cat = Category.new({
                    id:1,
                    name:"Jamuan"
                })
                item = Item.new({
                    id: 1, 
                    name: "a", 
                    price: 1000, 
                    category: cat
                })
                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                item.delete()
            end
        end
    end



end
