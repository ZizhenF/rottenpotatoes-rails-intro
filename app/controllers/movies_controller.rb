class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session[:sort] = params[:sort] if params[:sort]
    session[:ratings] = params[:ratings] if params[:ratings]

    if !params[:sort]
      if session[:sort]
        params[:sort] = session[:sort]
        redirect_to movies_path params and return
      end
    end
    if !params[:ratings]
      if session[:ratings]
        params[:ratings] = session[:ratings]
        redirect_to movies_path params and return
      end
    end

    session.keys.each {|key| puts key}
    @ratingsdict = session[:ratings]
    @flag = session[:sort]
    @pr = @flag.class
    @ratings_flag = session[:ratings]
    @all_ratings = Movie.uniq.pluck(:rating)
    @movies =  Movie.all
    if session[:ratings]!=nil
      @movies = @movies.where({rating: session[:ratings].keys})
    end
    if session[:sort]!=nil
      @movies = @movies.order session[:sort]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
