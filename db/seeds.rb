# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Category.destroy_all
Category.create ([{name: "Planning & Design"}, {name: "Permits & Inspections"}, {name: "Job Site Facilities"}, {name: "Demolition"},
                  {name:"Site Work"}, {name:"Foundation"}, {name:"Framing"}, {name:"Doors & Windows"}, {name:"Roofing"},
                  {name:"Exterior Veneers"}, {name:"Plumbing"}, {name:"HVAC"}, {name:"Electrical"}, {name:"Insulation"},
                  {name:"Drywall & Paint"}, {name:"Cabinetry & Counters"}, {name:"Finish Carpentry"}, {name:"Flooring & Tile"},
                  {name:"Appliances"}, {name:"Hardware"}, {name:"Specialty"}, {name:"Landscaping"}, {name:"Cleaning & Hauling"}])

Item.destroy_all
Item.create ([{name: "Custom Shower Pan", description: "Labor & Materials: Build custom shower pan.", unit: "each", estimated_cost: 450, margin: 75},
              {name: "Frisae Carpet", description: "Labor & Materials: Install frisae style carpet.", unit: "sf", estimated_cost: 1.85, margin: 0.50},
              {name: "Vanity Sink", description: "Allowance: Brushed nickel vanity sink.", unit: "each", estimated_cost: 70, margin: 0},
              {name: "Under-mount Sink", description: "Allowance: Stainless steel under-mount kitchen sink.", unit: "each", estimated_cost: 275, margin: 0},
              {name: "2x4x9 Stud", description: "Materials: 9ft-2x4 studs", unit: "each", estimated_cost: 2.53, margin: 0.20},
              {name: "1/2 OSB Subflooring", description: "Materials: 4x8 sheets of 1/2in T&G OSB Subflooring", unit: "each", estimated_cost: 13.78, margin: 0.50},
              {name: "Ceiling Fan", description: "Allowance: Builder grade ceiling fan.", unit: "each", estimated_cost: 150, margin: 0},
              {name: "Labor", description: "Labor: Build new service panel.", unit: "each", estimated_cost: 1850, margin: 400},
              {name: "Labor", description: "Labor: Install all wiring and electrical fixtures.", unit: "sf", estimated_cost: 4.15, margin: 2}])
              
GanttTask.destroy_all
GanttTask.create([{task_id:1, text:"Project #1",start_date:"01-04-2013", duration:11, progress: 0.6, parent:0},
                  {task_id:2, text:"Task #1",   start_date:"03-04-2013", duration:5, progress: 1, parent:1},
                  {task_id:3, text:"Task #2",   start_date:"02-04-2013", duration:7, progress: 0.5, parent:1},
                  {task_id:4, text:"Task #2.1", start_date:"03-04-2013", duration:2, progress: 1, parent:3},
                  {task_id:5, text:"Task #2.2", start_date:"04-04-2013", duration:3, progress: 0.8, parent:3},
                  {task_id:6, text:"Task #2.3", start_date:"05-04-2013", duration:4, progress: 0.2, parent:3}
                ])
                
GanttLink.destroy_all
GanttLink.create([
                  {link_id:1, source:1, target:2, link_type:"1"},
                  {link_id:2, source:1, target:3, link_type:"1"},
                  {link_id:3, source:3, target:4, link_type:"1"},
                  {link_id:4, source:4, target:5, link_type:"0"},
                  {link_id:5, source:5, target:6, link_type:"0"}  
                ])
