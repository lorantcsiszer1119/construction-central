class CreateGanttLinks < ActiveRecord::Migration
  def change
    create_table :gantt_links do |t|
      t.string :link_id
      t.string :source
      t.string :target
      t.string :link_type
      t.timestamps
    end
  end
end
