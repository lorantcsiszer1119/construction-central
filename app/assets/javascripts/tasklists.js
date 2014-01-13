
$(function() {   
	
    $("#gantt_save").on("click", function(event){
      event.preventDefault();
      console.log("clicked save button");
      var json1 = gantt.serialize();
      console.log(json1);
      
      var ss = "ok";
      
      $.ajax({
      url: '/tasklists/update_schedule/',
      method: 'POST',
      dataType: "json",
      data: json1,
      async: false,
      success : function(data){
         console.log("start");
         console.log(data);
         console.log("end");
        }
      }); 
        
    })
    
    $(".grid_checkbox1 input[type='checkbox']").on("click", function(event){
    	console.log('checked');
      if(($(this).checked) != 'undifined' ){
      	$(this).attr('checked');
      	console.log('true');
      }
      else{
      	$(this).attr('checked', 'false');
      	console.log('false');
      }
      	// $(this).attr('checked', 'false');

    })
        
    

    /*
    $(".gantt_task_row").on("click", function(event){
          console.log("sdfsdf");
          event.preventDefault();
                      var project;
          gantt.eachTask(function(task){
            if (task.parent == 0)
            { 
              project = task 
            }
          })
                      var current_id = $(this).attr("task_id");
          var current_task = gantt.getTask(current_id);
                      var current_parent = gantt.getTask(current_task.parent);
                      var parent;
          var startDate;
          var text;
          if (current_parent == project) //current task is task list
            {
              parent = current_task;
              text = "new task"
            }
          else if (current_parent == null) //current task is project
            {
              parent = current_task;
              text = "new task list"    			
            }
          else //current task is task
            {
              parent = current_parent;
              text = "new task"
            }
                                  startDate = parent.start_date;
          parent.$open = true;
          // var item = { text:gantt.locale.labels.new_task, start_date:this.templates.xml_format(startDate), duration: 1, progress: 0, parent: id };
          var item = { text:text, start_date:gantt.templates.xml_format(startDate), duration: 1, progress: 0, parent: parent.id };
         
         gantt.callEvent("onTaskCreated", [item]);
         gantt.addTask(item);
         gantt.showTask(item.id);
         if (gantt.config.details_on_create)
             gantt.showLightbox(item.id);
             
        })
        */
    
    
});