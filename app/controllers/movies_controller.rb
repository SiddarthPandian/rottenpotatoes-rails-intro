class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
    #Rails.logger.info("PARAMS: #{params.inspect}")
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    
    
    if params[:ratings].nil? && !session[:ratings].nil?
      @filters = @all_ratings
      params[:ratings] = session[:ratings]
    elsif params[:ratings].nil?
      @filters = @all_ratings
    else
      @filters = params[:ratings]
    end
      
    
    @filters = params[:ratings].nil? ? @all_ratings : params[:ratings]
    
    
    
    
    if (params[:ratings])
      # Save the ratings from the params to the session
      session[:ratings] = params[:ratings]
      @filters = params[:ratings]
      
    elsif (session[:ratings])
      # if the ratings doesn't exist in the params 
      # but it does in the session, then use the ratings from the session
      if params[:sort].nil?
        redirect_to movies_path({:ratings => params[:ratings]})
      else
        redirect_to movies_path({:sort => params[:sort], :ratings => session[:ratings]})
      end
    end
    
    if (params[:sort])
      # Save the sort settings from the params to the session
      @renderTitle = params[:sort] == "title" ? true : false
      @renderDate = params[:sort] == "release_date" ? true : false
      session[:sort] = params[:sort]
      @movies = Movie.movies(params[:ratings], params[:sort])
    elsif (session[:sort])
      # if the sort settings doesn't exist in the params 
      # but it does in the session, then use the settings from the session
      redirect_to movies_path({:sort => session[:sort], :ratings => session[:ratings]}) and return
    else
      @movies = Movie.movies(params[:ratings], params[:sort]) #hopefully it still sorts if sort is nil
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
    redirect_to movies_path({:sort => session[:sort], :ratings => session[:ratings]})
  end

end
