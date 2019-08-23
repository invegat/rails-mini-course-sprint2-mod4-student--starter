require 'rails_helper'

Tfname = "tfname"
Tlname = "tlname"

def make_employee(first_name = Tfname, last_name = Tlname, rewards_balance = nil)
  Employee.new({first_name: first_name, last_name: last_name, rewards_balance: rewards_balance})
end

RSpec.describe Employee, type: :model do
  context "validations" do 
    it "is valid" do
      employee = make_employee

      result = employee.valid?
      errors = employee.errors.full_messages

      expect(result).to be(true)
      expect(errors).to be_empty
    end
    it "is invalid without a first name" do 
      employee = make_employee nil

      result = employee.valid?
      errors = employee.errors.full_messages

      expect(result).to be(false)
      expect(errors).to include("First name can't be blank")
    end
    it "is invalid without a last name" do
      employee = make_employee Tfname, nil

      result = employee.valid?
      errors = employee.errors.full_messages

      expect(result).to be(false)
      expect(errors).to include("Last name can't be blank")      
    end
  end
  context "attributes" do 
    it "has expected attributes" do
      employee = make_employee

      result = employee.attribute_names.map(&:to_sym)

      expect(result).to contain_exactly(
        :id,
        :first_name,
        :last_name,
        :rewards_balance,
        :created_at,
        :updated_at
      )
    end  
  end
  context "scopes" do 
    describe ".zero_balance" do
      before do
        Employee.create!([
          {first_name: :neg1, last_name: Tlname, rewards_balance: -1 },
          {first_name: :zero, last_name: Tlname, rewards_balance: 0 },
          {first_name: :one, last_name: Tlname, rewards_balance: 1 }          
        ]).sort_by(&:rewards_balance)
      end
      it "returns a list of zero or less balance" do
        result = Employee.zero_balance

        expect(result.count).to eq 2
        expect(result.first.first_name).to eq("neg1")
        expect(result.last.first_name).to eq("zero")
        expect(result.any? {|employee| employee.first_name == "one" }).to be(false)
      end
    end
  end 
  context "instance methods" do 
    let(:employee) { make_employee }      
    describe "#full_name" do 
      it "concatinates the first and last name" do
        expect(employee.full_name).to eq "#{Tfname} #{Tlname}"
      end
    end
    describe "#can_afford?" do 
      before do
        employee.rewards_balance = 100
      end
      it "returns true if the rewards_balance is greater than or equal to the arg" do
        expect(employee.can_afford? 50).to eq(true)
      end
      it "returns false if the rewards_balance is less than the arg" do
        expect(employee.can_afford? 500).to eq(false)
      end      
    end

  end 
end
