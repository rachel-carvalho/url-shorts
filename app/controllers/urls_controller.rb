class UrlsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  before_action :set_url, only: [:destroy]

  # GET /urls
  # GET /urls.json
  def index
    if user_signed_in?
      @urls = current_user.urls
    else
      @urls = Url.all
    end
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(url_params)

    respond_to do |format|
      @url.user = current_user
      if @url.save
        format.html { redirect_to polymorphic_url([:short], short: "#{@url.short}+"), notice: 'Url was successfully shortened.' }
        format.json { render action: 'show', status: :created, location: @url }
      else
        format.html { render action: 'new' }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    if @url.user.id == current_user.id
      @url.destroy
      respond_to do |format|
        format.html { redirect_to urls_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        err = { error: "Can't to delete a url that doesn't belong to you" }
        format.html { redirect_to urls_url, err }
        format.json { render json: err, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_params
      params.require(:url).permit(:original)
    end
end
