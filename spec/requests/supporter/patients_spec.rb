require 'rails_helper'

RSpec.describe "Supporter::Patients", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/supporter/patients/show"
      expect(response).to have_http_status(:success)
    end
  end

end
