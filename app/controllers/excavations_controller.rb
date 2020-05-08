class ExcavationsController < ApplicationController
  def new
    @excavation = Excavation.new
  end
end
