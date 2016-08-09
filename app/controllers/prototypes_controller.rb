class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :edit, :delete]
  before_action :prototype, only: [:edit, :update, :destroy]

  def index
    @prototypes = Prototype.including_user_images.order("likes_count DESC").page(params[:page]).per(8)
  end

  def new
    @prototype = Prototype.new
    @prototype.capture_images.build
  end

  def create
    @prototype = Prototype.new(proto_params)
    binding.pry
    if @prototype.save
      redirect_to root_path, notice: 'prototype has been created successfully'
    else
      redirect_to new_prototype_path, alert: 'error'
    end
  end

  def show
    @prototype = Prototype.includes(:user, :capture_images, :comments).find(params[:id])
    @sub_images = @prototype.capture_images.sub
    @comment = Comment.new
    @comments = @prototype.comments
    @like = @prototype.likes.find_by(user_id: current_user.id)
  end

  def edit
    @prototype.capture_images.build
  end

  def update
    if current_user.id == @prototype.user_id && @prototype.update(proto_params)
      redirect_to root_path, notice: 'prototype has been edited successfully'
    else
      redirect_to edit_prototype_path(@prototype), alert: 'error has occured'
    end
  end

  def destroy
    if user_signed_in? && current_user.id == @prototype.user_id
      @prototype.destroy
      redirect_to root_path, notice: 'prototype has been deleted successfully'
    else
      redirect_to root_path, alert: 'error has occured'
    end
  end

  private

  def proto_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, capture_images_attributes: [:type, :content, :id]).merge(user_id: current_user.id, tag_list: params[:prototype][:tag])
  end

  def prototype
    @prototype = Prototype.find(params[:id])
  end
end
