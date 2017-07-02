class PhysicalBooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :show] # check if :edit, :update, are needed
  before_filter :require_permission, only: :destroy

  def index
    @physical_books = PhysicalBook.text_search(params[:query])
  end

  def new
    @new_physical_book = PhysicalBook.new
    if params[:title]
      @new_physical_book.title = params[:title]
      @new_physical_book.author = params[:authors]
      @new_physical_book.description = params[:description]
      @new_physical_book.cover_pic_url = params[:cover_pic_url]
      @new_physical_book.isbn = params[:isbn]
    end
  end

  def retrieve_from_ggb
    require 'googlebooks' # unless you're using Bundler
    @searched_books = GoogleBooks.search("#{params[:title_query]}", {:api_key => ENV['BOOKS_API_SERVER_KEY']})
  end

def create
  @new_physical_book = PhysicalBook.new(physical_book_params)
  @new_physical_book.user = current_user
  if @new_physical_book.save
    redirect_to user_path(current_user)
  else
    render :new
  end
end

def show
  @genre = @book.genre
  @hash = Gmaps4rails.build_markers(@book.user) do |user, marker|
    marker.lat user.latitude
    marker.lng user.longitude
    marker.infowindow render_to_string(partial: "static_pages/user_map_box", locals: { user: user})
  end
end

def list

end


def update
  if @book.update(physical_book_params)
    redirect_to root_path
  else
    render :edit
  end
end

def destroy
  @book.destroy
  redirect_to user_path(current_user)
end

private

def physical_book_params
  params.require(:physical_book).permit(:title, :author, :description, :status, :cover_pic_url, :price, :picture_url, :picture_url_cache, :genre_id)
end

def set_book
  @book = PhysicalBook.find(params[:id])
end


def require_permission
  if current_user != PhysicalBook.find(params[:id]).user
    redirect_to root_path
      #Or do something else here
    end
  end

end
