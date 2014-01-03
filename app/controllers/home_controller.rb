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

    @url = Url.find_by(num_id: Url.num_id_from_short(short))

    if info
      render action: 'info'
    else
      @url.clicked!
      redirect_to @url.original
    end
  end
end
