class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.integer :status, default: 1

      t.timestamps null: false
    end
  end
end
