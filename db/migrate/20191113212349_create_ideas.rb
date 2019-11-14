class CreateIdeas < ActiveRecord::Migration[6.0]
  def change
    create_table :ideas do |t|
      t.string :content, limit: 255
      t.integer :impact
      t.integer :ease
      t.integer :confidence
      t.decimal :average_score
      t.timestamps
    end
  end
end
