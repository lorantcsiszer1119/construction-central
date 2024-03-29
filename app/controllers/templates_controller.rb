class TemplatesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_template, only: [:edit, :update, :delete, :destroy]

  def list
     @templates = Template.where("builder_id = ? AND estimate_id IS NULL", session[:builder_id])
  end

  def new
    @template = Template.new
    @template.categories.build
    # Category.all.each { |category| category.update_attribute(:template_id, nil) if category.template.nil? }
    @categories = Category.where("template_id IS NULL AND builder_id = ?", session[:builder_id])
    @items = Item.where("builder_id = ?", session[:builder_id])
  end

  def create
    categories = params[:template][:categories_templates_attributes]
    params[:template].delete(:categories_templates_attributes)
    @template = @builder.templates.new(params[:template])

    if @template.save!
      # @template.categories_templates.create(categories)
      unless categories.blank?
        categories.map do |key, val|
          unless val[:category_id].blank?
            categories_template = @template.categories_templates.create(category_id: val[:category_id])
            if val[:items_attributes]
              item_ids = val[:items_attributes].map { |k, v| v[:id] }
              item_ids.reject! { |c| c.empty? }
              unless item_ids.empty?
                @items = Item.find(item_ids)
                categories_template.items = @items
              end
            end
          end
        end
      end

      redirect_to action: 'list'
    else
      @categories = Category.where("template_id IS NULL")
      @template.categories.build
      flash.now[:alert] = "please enter the data correctly."
      render action: :new
    end
  end

  def edit
    @categories = Category.where("template_id IS NULL AND builder_id = ?", session[:builder_id])
    @items = Item.where("builder_id = ?", session[:builder_id])
    @t_categories = @template.categories.pluck(:id)
    @t_items = Item.all
  end

  def update
    categories = params[:template][:categories_templates_attributes]
    params[:template].delete(:categories_templates_attributes)
    @template = Template.find(params[:id])
    @template.name = params[:template][:name]

    if @template.update_attributes(params[:template])
      #if save succeeds, redirect to list action
      unless categories.blank?
        categories.map do |key, val|
          cat_temp_ids = @template.categories_templates.pluck(:id)
          act_ids = @template.categories_templates.pluck(:category_id)
          if val["_destroy"].eql? "1"
            categories_template = @template.categories_templates.find(val[:id]).delete
          elsif cat_temp_ids.include? val[:id].to_i
            categories_template = @template.categories_templates.find(val[:id])
            categories_template.update_attribute(:category_id, val[:category_id])
            if val[:items_attributes]
              categories_template.items.destroy_all
              val[:items_attributes].map do |item_key, item_val|
                unless (item_val["_destroy"].eql? "1")  || item_val[:id].blank?
                  @item = Item.find(item_val[:id])
                  categories_template.items << @item
                end
              end
            end
          elsif val[:category_id].present?
            categories_template = @template.categories_templates.create(category_id: val[:category_id])
            if val[:items_attributes]
              item_ids = val[:items_attributes].map { |k, v| v[:id] }
              item_ids.reject! { |c| c.empty? }
              unless item_ids.empty?
                @items = Item.find(item_ids)
                categories_template.items = @items
              end
            end
          end
        end
      end

      redirect_to action: 'list'
    else
      #if save fails, redisplay form to user can fix problems
      render('edit')
    end
  end

  def delete
    # find template with ID is already call in find_template with before filter
  end

  def destroy
    @template.destroy
    redirect_to(action: 'list')
  end

  private

  def find_template
    @template = Template.find(params[:id])
  end
end
