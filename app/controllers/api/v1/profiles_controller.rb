class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    render json: current_resource_owner
  end

  def index
    user_email_list = []
    curent_user_id = current_resource_owner.id

    User.all.each do |user|
      next if user.id == curent_user_id
      user_email_list << user.email
    end

    render json: user_email_list
  end
end
