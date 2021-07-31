require_relative '../model/categories'
require_relative '../model/items'
require_relative '../model/item_categories'
require_relative '../db/db_connector'

describe Category do


    # =================== valid initialize =====================

    describe '#validInitCategory' do
        context 'init input category' do
            it 'should be true' do
                cat = Category.new({
                    id: 1,
                    name: "Jamuan"
                })
                expect(cat.valid?).to eq(true)
            end
        end 

        context 'init input category' do
            it 'should be false' do
                cat = Category.new({
                    id: 1
                })
                expect(cat.valid?).to eq(false)
            end
        end 
    end


    # =================== valid select all =====================

    describe '#validSelectAllCategories' do
        context 'select all categories' do
            it 'should be true' do

                stub_client = double
                stub_query = "SELECT * from categories"
                categories = [{"id": 1, "name": "a"}]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return(categories)

                categories = Category.get_all_categories
                expect(categories.nil?).to eq(false)
            end
        end 
    end   
    

    # =================== valid get =====================

    describe '#validSelectItem' do
        context 'select data' do
            it 'there\'s a data' do

                stub_client = double
                stub_query = "select * from categories where id = 1"
                categories = [{"id": 1, "name": "a"}]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return(categories)
                

                category = Category.get_categories(1)
                expect(category).not_to be_nil
            end
        end

        context 'select data' do
            it 'there\'s no data' do

                stub_client = double
                stub_query = "select * from categories where id = 1"
                categories = [{"id": 1, "name": "a"}]

                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query).and_return([])
                

                category = Category.get_categories(1)
                expect(category).to eq(nil)
            end
        end
    end



    # =================== valid save =====================


    describe '#saveCategory' do
        context 'save category data' do
            it 'input category' do
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
    

    # =================== valid update =====================


    describe '#updateCategory' do
        context 'update category data' do
            it 'update' do
                stub_client = double
                stub_query_1 ="update categories set name = 'qux' where id = 1 "
                category = Category.new({
                    id: 1, 
                    name: 'qux'
                })
                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query_1)
                category.update
            end
        end
    end  
    


    # =================== valid delete =====================


    describe '#deleteCategory' do
        context 'delete category data' do
            it 'input category' do
                stub_client = double
                stub_query = "delete from categories where id = 1 and name = 'comfort food'"
                category = Category.new({
                    id: 1, 
                    name: 'comfort food'
                })
                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                expect(stub_client).to receive(:query).with(stub_query)
                category.delete
            end
        end
    end  
    

end
