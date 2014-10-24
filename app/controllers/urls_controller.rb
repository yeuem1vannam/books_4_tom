class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy]

  # GET /urls
  def index
    @urls = Url.where(_type: params[:type]).page(params[:page]).per(10)
  end

  # GET /urls/1
  def show
  end

  # GET /urls/new
  def new
    @url = Url.new
  end

  # GET /urls/1/edit
  def edit
  end

  # POST /urls
  def create
    @url = Url.new(url_params)

    if @url.save
      redirect_to @url, notice: 'Url was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /urls/1
  def update
    if @url.update(url_params)
      redirect_to @url, notice: 'Url was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /urls/1
  def destroy
    @url.destroy
    redirect_to urls_url, notice: 'Url was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def url_params
      params[:url]
    end
end
