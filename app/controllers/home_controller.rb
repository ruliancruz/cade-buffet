class HomeController < ApplicationController
  before_action :validate_buffet_creation, only: [:index]

  def index; end
end