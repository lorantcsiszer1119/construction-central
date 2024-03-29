class Bid < ActiveRecord::Base
  belongs_to :project
  belongs_to :vendor
  belongs_to :categories_template

  has_one :bill

  validates_presence_of :categories_template

  attr_accessible :amount, :notes, :chosen, :categories_template_id, :vendor_id, :due_date

  serialize :amount

  before_save :unset_committed_costs, :set_committed_costs, :update_bill

  before_destroy :raise_readonly, :unset_committed_costs, :destroy_bill

  def readonly?
    bill.try(:readonly?)
  end

  def total_amount
    t=0
    amount.each do |i|
      t+= i[:'uncommitted_cost'].to_f
    end
    t
  end

  def item_amount(item_id)
    self.amount.each do |i|
      if item_id.to_s == i[:id]
        return i[:uncommitted_cost]
      end
    end
    return nil
  end

  private
  def set_committed_costs
    if self.chosen
      self.amount.each do |i|
        item = Item.find(i[:id])
        if item.present?
          updated_cost = item.committed_cost.to_f + i[:uncommitted_cost].to_f
          item.update_attribute(:committed_cost, updated_cost == 0 ? nil : updated_cost)
        end
      end
    end
  end

  def unset_committed_costs
    if self.chosen_was
      self.amount_was.try(:each) do |i|
        item = Item.find(i[:id])
        if item.present?
          updated_cost = item.committed_cost.to_f - i[:uncommitted_cost].to_f
          item.update_attribute(:committed_cost, updated_cost == 0 ? nil : updated_cost)
        end
      end
    end
  end

  def update_bill
    if chosen
      create_bill(builder_id: self.project.builder_id, vendor_id: vendor_id ) unless bill.present?
    elsif bill.present?
      raise_readonly
      bill.destroy
    end
  end

  def destroy_bill
    if chosen && bill.present?
      raise_readonly
      bill.destroy
    end
  end

  def raise_readonly
    raise ActiveRecord::ReadOnlyRecord if readonly?
  end
end
