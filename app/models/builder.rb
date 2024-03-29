class Builder < ActiveRecord::Base
  #Relations
  has_many :clients
  has_many :projects
  has_many :estimates
  has_many :users
  has_many :items
  has_many :categories
  has_many :templates
  has_many :accounts
  has_many :tasklists
  has_many :vendors
  has_many :contacts
  has_many :prospects

  attr_accessible :company_name, :year_founded, :office_phone, :website, :address, :city, :state, :zipcode, :tax_id, :logo, :slogan
  mount_uploader :logo, BuilderLogoUploader

end
