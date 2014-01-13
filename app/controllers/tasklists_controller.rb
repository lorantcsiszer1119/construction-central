class TasklistsController < ApplicationController

  before_filter :authenticate_user!

  def list
    @tasklists = Tasklist.where("builder_id = ?", session[:builder_id])
  end
  
  def schedule      
    
    @data = []    
    g_tasks = GanttTask.all
    
    g_tasks.each do |task|
      element = {id: task.task_id, text: task.text, start_date: task.start_date.strftime('%d-%m-%Y'), duration: task.duration, progress: task.progress, open: true, parent: task.parent}
      @data << element
    end
    
    @links = []
    g_links = GanttLink.all
    g_links.each do |link|
      element = {id: link.link_id, source: link.source, target: link.target, type: link.link_type}
      @links << element
    end
    
    @tasks = { data: @data, links: @links}
    @project = GanttTask.find_by_parent('0')
    
  end
  
  def update_schedule
  
    data = params[:data]
    links = params[:links]
    
    g_tasks = GanttTask.all
    task_ids = []
    g_tasks.each do |gt|
      task_ids << gt.task_id
    end
    
    g_links = GanttLink.all
    link_ids = []
    g_links.each do |gl|
      link_ids << gl.link_id
    end
    
    g_task_ids = []    
    data.each do |e|      
      g_task = e.last
      
      task = GanttTask.find_by_task_id(g_task["id"])
      if task
        g_task_ids << g_task["id"]
        task.update_attributes(task_id:g_task["id"], start_date:g_task["start_date"], 
                               text:g_task["text"], progress:g_task["progress"], duration:g_task["duration"],
                               sortorder:g_task["sortorder"], open:g_task["open"], parent:g_task["parent"])
                               
      else
        GanttTask.create(task_id:g_task["id"], start_date:g_task["start_date"], 
                               text:g_task["text"], progress:g_task["progress"], duration:g_task["duration"],
                               sortorder:g_task["sortorder"], open:g_task["open"], parent:g_task["parent"])
      end
    end
    
    g_link_ids = []
    links.each do |e|
      g_link = e.last
      
      link = GanttLink.find_by_link_id(g_link["id"])
      if link
        g_link_ids << g_link["id"]
        link.update_attributes(link_id:g_link["id"], source:g_link["source"], target:g_link["target"], link_type:g_link["type"])
      else
        GanttLink.create(link_id:g_link["id"], source:g_link["source"], target:g_link["target"], link_type:g_link["type"])
      end
    end
    
    rest_link_ids = link_ids - g_link_ids
    rest_task_ids = task_ids - g_task_ids
    
    
    redirect_to :back
  end
  
  def show
    @tasklist = Tasklist.find(params[:id])
  end
  
  def new
    @tasklist = Tasklist.new
    @tasklist.tasks.build
  end
  
  def create
    @builder = Builder.find(session[:builder_id])
    @tasklist = Tasklist.new(params[:tasklist])
    #saves creation of Estimate
    if @tasklist.save
      @builder.tasklists << @tasklist
      #if save succeeds, redirect to list action
      redirect_to(:action => 'list')
    else
      #if save fails, redisplay form to user can fix problems
      render('new')
    end
  end
  
  def edit
    @tasklist = Tasklist.find(params[:id])
  end
  
  def update
    #Find object using form parameters
    @tasklist = Tasklist.find(params[:id])
    #Update subject
    if @tasklist.update_attributes(params[:tasklist])
      #if save succeeds, redirect to list action
      redirect_to(:action => 'list')
    else
      #if save fails, redisplay form to user can fix problems
      render('edit')
    end
  end

  def delete
    @tasklist = Tasklist.find(params[:id])
  end

  def destroy
    Tasklist.find(params[:id]).destroy
    redirect_to(:action => 'list')
  end
end
