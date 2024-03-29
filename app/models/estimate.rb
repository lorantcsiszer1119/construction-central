class Estimate < ActiveRecord::Base
  # mount_uploader :data, DataUploader
  belongs_to :builder
  belongs_to :project
  has_many :items
  has_many :measurements , :dependent => :destroy
  has_one :template

  accepts_nested_attributes_for :measurements

  attr_accessible :progress, :status, :data,
  :deadline, :revenue, :profit, :margin, :notes, :project_id, :measurements_attributes

  def self.import(file)
    CSV.for
  end

end
