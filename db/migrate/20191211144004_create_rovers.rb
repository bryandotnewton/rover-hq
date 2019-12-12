class CreateRovers < ActiveRecord::Migration[6.0]
  def change
    create_table :rovers do |t|
      t.integer :command_id, null: false
      t.integer :start_x, null: false
      t.integer :start_y, null: false
      t.string :start_direction, null: false
      t.integer :end_x
      t.integer :end_y
      t.string :end_direction
      t.string :rover_errors
      t.string :commands, null: false
      t.timestamps
    end
  end
end
