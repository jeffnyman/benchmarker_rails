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

    if @workflow.success?
      redirect_to excavations_path
    else
      @excavation = @workflow.excavation
      render :new
    end
  end

  def index
    @excavations = Excavation.all
  end
end
