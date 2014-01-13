class GanttLink < ActiveRecord::Base
  attr_accessible :link_id, :source, :target, :link_type
end
