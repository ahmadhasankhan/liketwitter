class PageController < ApplicationController
  def routing_error
    p "routing error path: #{params[:path]}"
    redirect_to :error_404
  end

  def error_404
  end

  def about_us
  end

  def contact_us
  end

  def career
  end

  def term_conditions
  end
end