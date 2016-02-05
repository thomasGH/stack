class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @attachment = Attachment.find(params[:id])
    @object = @attachment.attachable
    @attachment.destroy

    render json: { answer: @object, email: @object.user.email, attachment: [] }
  end
end
