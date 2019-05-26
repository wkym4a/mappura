class DrawingPinsController < ApplicationController
  def test
  end

  def index
  end

  def new
    @drawing_pin = DrawingPin.new
  end
end
