class AddLockVersionToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :lock_version, :integer, default: 0
  end
end
