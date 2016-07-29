class Prototypes::NewestController < ApplicationController

  def index
    @prototypes = Prototype.with_proto.order("created_at DESC").page(params[:page]).per(8)
  end

end
