class ChangeVotes < ActiveRecord::Migration
  def change
    change_table(:votes) do |t|
      t.rename :answer_id, :votable_id
      t.rename :vote, :value
    end

    add_column :votes, :votable_type, :string
    add_index :votes, [:votable_id, :votable_type]
  end
end
