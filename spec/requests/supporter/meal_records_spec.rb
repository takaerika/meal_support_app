require 'rails_helper'

RSpec.describe "Supporter::MealRecords", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/supporter/meal_records/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/supporter/meal_records/show"
      expect(response).to have_http_status(:success)
    end
  end

end
