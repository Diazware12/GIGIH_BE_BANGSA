require_relative '../model/categories'
require_relative '../model/items'
require_relative '../model/item_categories'
require_relative '../db/db_connector'

describe Category do

    before(:each) do
        client = create_db_client
        client.query('set FOREIGN_KEY_CHECKS = 0')
        client.query('truncate item_categories')
        client.query('truncate table items')
        client.query('truncate table categories')
        client.query('set FOREIGN_KEY_CHECKS = 1')
    end

    # =================== valid initialize =====================

    describe '#validInitCategory' do
        context 'init input category' do
            it 'should be true' do
                cat = Category.new({
                    name: "Jamuan"
                })
                expect(cat.valid?).to eq(true)
            end
        end 
    end


    # =================== valid select all =====================

    describe '#validSelectAllCategories' do
        context 'select all categories' do
            it 'should be true' do
                categories = Category.get_all_categories
                expect(categories.nil?).to eq(false)
            end
        end 
    end   
    

    # =================== valid get =====================

    describe '#validSelectItem' do
        context 'select data' do
            it 'there\'s a data' do
                item = Item.get_selected_item(2)
                expect(item.nil?).to eq(true)
            end
        end
    end



    # =================== valid save =====================


    describe '#saveCategory' do
        context 'save category data' do
            it 'input category' do
                category = Category.new(6,"comfort food")
                category.save
            end
        end
    end  
    

    # =================== valid update =====================


    describe '#updateCategory' do
        context 'update category data' do
            it 'input category' do
                category = Category.new(6,"comfort food")
                category.update
            end
        end

        context 'return category' do
            it 'it should return' do
                stub_client = double
                allow(Mysql2::Client).to receive(:new).and_return(stub_client)
                stub_query = "update from categories set name = 'Halal' where id = 2"
                allow(stub_client).to receive(:affected_rows).and_return(2) 
                expect(stub_client).to receive(:query).with(stub_client)

                stub_category = double
                allow(Category).to receive(:get_categories).with(2).and_return(Category.new(2,"Halal"))

                old_cat=Category.get_categories(2)
                old_cat.name = 'Halal'

                affected_row = old_cat.update
                expect(affected_row).to eq(2)
            end
        end
    end  
    


    # =================== valid delete =====================


    describe '#deleteCategory' do
        context 'delete category data' do
            it 'input category' do
                category = Category.new(6,"comfort food")
                category.delete
            end
        end
    end  
    

end
