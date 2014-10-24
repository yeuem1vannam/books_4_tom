class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  def index
    if params[:confirmed]
      @books = Book.where(confirmed: true).page(params[:page]).per(10)
    else
      @books = Book.page(params[:page]).per(10)
    end
    respond_to do |format|
      format.html
      format.json {
        if params[:confirmed]
          json_data = Book.where(confirmed: true).to_json
        else
          json_data = Book.all.to_json
        end
        send_data json_data, filename: "books#{Time.now.to_i}.json", type: "text/plain; charset=utf-8", status: 200
      }
    end
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
      respond_to do |format|
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.js
      end
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
      params.require(:book).permit(:name, :confirmed)
    end
end
