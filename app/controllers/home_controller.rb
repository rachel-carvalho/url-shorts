class HomeController < ApplicationController

  # get /
  def index
    @url = Url.new
  end

  # get /:short[+]
  def go
    short = params[:short]
    info = false

    if short.ends_with? '+'
      info = true
      short.chomp! '+'
    end

    @url = Url.find Url.id_from_short short

    if info
      render action: 'info'
    else
      @url.inc clicks: 1
      redirect_to @url.original
    end
  end
end
