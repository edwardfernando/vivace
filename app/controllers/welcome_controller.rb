class WelcomeController < ApplicationController

  def index
    @pages = @consumer.request("/pages", :get, {})
  end

end
