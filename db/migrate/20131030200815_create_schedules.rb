class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :builder
      t.timestamps
    end
  end
end
