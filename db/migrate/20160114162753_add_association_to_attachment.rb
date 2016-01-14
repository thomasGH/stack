class AddAssociationToAttachment < ActiveRecord::Migration
  def change
    add_belongs_to :attachment, :question, index: true
  end
end
