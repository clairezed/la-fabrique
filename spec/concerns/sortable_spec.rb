require "rails_helper"

RSpec.describe Sortable do
  before(:all) do
    Temping.create :sortable_model do 
      
      with_columns do |t|
        t.string :my_string
        t.integer :my_integer
      end

      include Sortable
    end
  end

  before(:each) do
    object1 = SortableModel.create(my_string: "aa1", my_integer: 1)
    object2 = SortableModel.create(my_string: "Aa2", my_integer: 2)
    object3 = SortableModel.create(my_string: "aA3", my_integer: 3)
  end

  it "tri ascendant de string avec gestion de la casse" do
    a = SortableModel.sort_by_my_string("asc").pluck(:my_string)
    expect(a[0]).to eq("aa1")
    expect(a[1]).to eq("Aa2")
    expect(a[2]).to eq("aA3")
  end


  it "tri descendant de string avec gestion de la casse" do
    a = SortableModel.sort_by_my_string("desc").pluck(:my_string)
    expect(a[0]).to eq("aA3")
    expect(a[1]).to eq("Aa2")
    expect(a[2]).to eq("aa1")
  end

  it "tri ascendant d'entiers avec gestion de la casse" do
    a = SortableModel.sort_by_my_integer("asc").pluck(:my_integer)
    expect(a[0]).to eq(1)
    expect(a[1]).to eq(2)
    expect(a[2]).to eq(3)
  end


  it "tri descendant d'entiers avec gestion de la casse" do
    a = SortableModel.sort_by_my_integer("desc").pluck(:my_integer)
    expect(a[0]).to eq(3)
    expect(a[1]).to eq(2)
    expect(a[2]).to eq(1)
  end
end