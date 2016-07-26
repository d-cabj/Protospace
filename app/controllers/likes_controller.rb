class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    binding.pry
    @like =Like.create(user_id: current_user.id, prototype_id: params[:prototype_id])
    @likes = Like.where(prototype_id: params[:prototype_id])
    @prototype = Prototype.find(params[:id])
  end

  def destroy
    Like.find_by(user_id: current_user.id).destroy
    @likes = Like.where(prototype_id: params[:prototype_id])
    @prototype = Prototype.find(params[:prototype_id])
  end
end
