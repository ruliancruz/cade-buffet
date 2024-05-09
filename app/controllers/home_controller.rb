class HomeController < ApplicationController
  before_action :validate_buffet_creation, only: [:index]

  def index
    @buffets = Buffet.order created_at: :desc
  end
end