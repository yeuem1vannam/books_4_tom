class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  def index
    @books = Book.page(params[:page]).per(10)
  end

  # GET /books/1
  def show
  end

  # GET /books/1/edit
  def edit
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Book was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def book_params
      params[:book]
    end
end
