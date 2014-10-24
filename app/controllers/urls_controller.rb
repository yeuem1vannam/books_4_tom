class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy]

  # GET /urls
  def index
    @urls = URL.all
  end

  # GET /urls/1
  def show
  end

  # GET /urls/new
  def new
    @url = URL.new
  end

  # GET /urls/1/edit
  def edit
  end

  # POST /urls
  def create
    @url = URL.new(url_params)

    if @url.save
      redirect_to @url, notice: 'URL was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /urls/1
  def update
    if @url.update(url_params)
      redirect_to @url, notice: 'URL was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /urls/1
  def destroy
    @url.destroy
    redirect_to urls_url, notice: 'URL was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = URL.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def url_params
      params.require(:url).permit(:href, :status)
    end
end
