class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    render json: @attachment
  end
end
