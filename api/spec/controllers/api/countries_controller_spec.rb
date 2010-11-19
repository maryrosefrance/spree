require 'spec_helper.rb'

describe Api::CountriesController do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  before(:each) do
    @user = create_user
    @user.ensure_authentication_token!
  end


  context "when valid api token" do
    describe "#show" do
      it "should return JSON for the specified order" do
        get uri_for("/countries/214.json"), nil, user_request(@user.authentication_token)
        response.should be_success
      end
    end

    describe "#index" do

      context "when no search params" do
        it "should return JSON for all of the orders" do
          get  uri_for("/countries.json"), nil, user_request(@user.authentication_token)
          response.should be_success
        end
      end
    end

  end

  context "when no api token" do
    describe "#show" do
      before { controller.stub :object => mock_model(Country) }

      it "should return unauthorized" do
        get uri_for("/countries/214.json"), nil, user_request("")
        last_response.status.should == 418
      end
    end

    describe "#index" do

      context "when no search params" do
        it "should return unauthorized" do
          get  uri_for("/countries.json"), nil, user_request("")
          last_response.status.should == 418
        end
      end
    end

  end

  context "when bad api token" do
    describe "#show" do
      it "should return unauthorized" do
        get uri_for("/countries/214.json"), nil, user_request(@user.authentication_token.reverse)
        last_response.status.should == 418
      end
    end

    describe "#index" do

      context "when no search params" do
        it "should return unauthorized" do
          get  uri_for("/countries.json"), nil, user_request(@user.authentication_token.reverse)
          last_response.status.should == 418
        end
      end
    end

  end

end

