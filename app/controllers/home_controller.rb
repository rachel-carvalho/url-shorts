class HomeController < ApplicationController

  # get /
  def index
    @url = Url.new
  end

  # get /:short[+]
  def go
    short = params[:short]
    show = false

    if short.ends_with? '+'
      show = true
      short.chomp! '+'
    end

    @url = Url.find Url.id_from_short short

    if show
      redirect_to @url
    else
      @url.inc clicks: 1
      redirect_to @url.original
    end
  end
end
