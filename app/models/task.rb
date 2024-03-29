class Task < ActiveRecord::Base

  belongs_to :tasklist
  default_scope { order("position ASC") }

  attr_accessible :name, :tasklist_id, :completed, :time_to_complete, :department, :position

end
