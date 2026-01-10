class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_resource_owner, serializer: ProfileSerializer
  end

  def index
    @users = User.where.not(id: current_resource_owner.id)
    render json: @users, each_serializer: ProfileSerializer
  end
end
