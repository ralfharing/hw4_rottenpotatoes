require 'spec_helper'

describe MoviesController do
  def valid_attributes
    {:rating => 'G', :director => 'John Doe'}
  end

  describe "GET index" do
    describe "with RESTful URL" do
      it "assigns all movies as @movies" do
        movie = Movie.create! valid_attributes
        session[:sort] = "title"
        session[:ratings] = {"G" => "1"}
        get :index, :sort => session[:sort], :ratings => session[:ratings]
        assigns(:movies).should eq([movie])
      end
    end

    describe "without RESTful URL" do
      it "is missing the sort parameter" do
        session[:sort] = "title"
        session[:ratings] = {"G" => "1"}
        get :index
        response.should redirect_to(movies_path(:sort => session[:sort], :ratings => session[:ratings]))
      end

      it "is missing the ratings paramenter" do
        session[:sort] = "release_date"
        session[:ratings] = {"G" => "1"}
        get :index, :sort => session[:sort]
        response.should redirect_to(movies_path(:sort => session[:sort], :ratings => session[:ratings]))
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new movie" do
        expect {
          post :create, :movie => valid_attributes
        }.to change(Movie, :count).by(1)
      end

      it "assigns a newly created movie as @movie" do
        post :create, :movie => valid_attributes
        assigns(:movie).should be_a(Movie)
        assigns(:movie).should be_persisted
      end

      it "redirects to the homepage" do
        post :create, :movie => valid_attributes
        response.should redirect_to(movies_path)
      end
    end
  end

  describe 'delete a movie' do
    it 'should find and destroy the movie by calling the model method' do
      fake_result = mock('Movie', :title => "title")
      fake_result.should_receive(:destroy)
      Movie.should_receive(:find).with('5').and_return(fake_result)
      post :destroy, :id => "5"
    end
  end
end
