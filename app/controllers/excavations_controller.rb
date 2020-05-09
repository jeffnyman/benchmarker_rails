class ExcavationsController < ApplicationController
  def new
    @excavation = Excavation.new
  end

  def create
    @workflow = CreatesExcavation.new(
      name: params[:excavation][:name],
      activity_string: params[:excavation][:activities]
    )

    @workflow.create
    redirect_to excavations_path
  end

  def index
    @excavations = Excavation.all
  end
end
