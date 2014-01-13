class GanttTask < ActiveRecord::Base
  attr_accessible :task_id, :start_date, :text, :progress, :duration, :sortorder, :open, :parent
  
  
end
