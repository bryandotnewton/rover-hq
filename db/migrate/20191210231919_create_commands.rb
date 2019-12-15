# frozen_string_literal: true

class CreateCommands < ActiveRecord::Migration[6.0]
  def change
    create_table :commands do |t|
      t.string :size
      t.string :command_list
      t.timestamps
    end
  end
end
