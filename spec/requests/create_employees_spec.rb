require 'rails_helper'

RSpec.describe "Create Employees", type: :request do
  describe "POST employees" do
    it "with valid request" do
      valid_params = {employee: { first_name: "fname", last_name: "lname" }}
      post "http://localhost:3000/employees", params: valid_params
      response_body = JSON.parse(response.body).deep_symbolize_keys

      expect(response).to have_http_status(201)
      expect(response_body).to include({
        first_name: "fname",
        last_name: "lname",
      })      
    end  
    it "with invalid empty first_name request" do
      invalid_params = {employee: { first_name: nil, last_name: "lname" }}
      post "/employees", params: invalid_params
      expect(response).to have_http_status(422)      
    end  
    it "with invalid empty last_name request" do
      invalid_params = {employee: { first_name: "fname", last_name: nil }}
      post "/employees", params: invalid_params
      expect(response).to have_http_status(422)      
    end        
  end
end
