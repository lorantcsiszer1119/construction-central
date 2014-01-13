class CreateGanttTasks < ActiveRecord::Migration
  def change
    create_table :gantt_tasks do |t|
      t.datetime :start_date
      t.string :task_id
      t.string :text
      t.float :progress
      t.integer :duration
      t.integer :sortorder
      t.boolean :open
      t.string :parent      
      t.timestamps
    end
  end
end
