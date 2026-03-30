class Admin::StampsController < ApplicationController
  layout "admin"

  def create
    @stamp = Stamp.new(stamp_params)
    if @stamp.save
      redirect_to admin_stamps_path
    else
      render :index
    end
  end

  def edit
    @stamp = Stamp.find(params[:id])
  end

  def index
    @stamps = Stamp.all
    @stamp = Stamp.new
  end

  def update
    @stamp = Stamp.find(params[:id])
    if @stamp.update(stamp_params)
      redirect_to admin_stamps_path
    else
      render :edit
    end
  end

  def activate
    stamp = Stamp.find(params[:id])
    if stamp.is_active?
      stamp.update(is_active: false)
    else
      stamp.update(is_active: true)
    end
      redirect_to admin_stamps_path
  end

  def stamp_params
    params.require(:stamp).permit(:stamp_name, :stamp_image, :is_active)
  end

end
