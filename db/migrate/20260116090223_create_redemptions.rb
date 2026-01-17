class CreateRedemptions < ActiveRecord::Migration[8.1]
  def change
    create_table :redemptions do |t|
      t.string :player_name
      t.string :code
      t.datetime :claimed_at

      t.timestamps
    end
  end
end
