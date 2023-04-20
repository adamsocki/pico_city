pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- initialize variables
map_width = 10
map_height = 10
cursor_x = 0
cursor_y = 0
simulation_running = false
simulation_results = ""

simulate_btn = {
  x = 80,
  y = 10,
  width = 30,
  height = 10,
  color = 7
}

-- define the city grid with some example data
city_grid = {
  {"empty", "road", "empty", "empty", "transit", "empty", "empty", "empty", "empty", "road"},
  {"empty", "road", "empty", "transit", "transit", "empty", "empty", "empty", "empty", "road"},
  {"road", "road", "road", "road", "empty", "empty", "empty", "empty", "empty", "road"},
  {"empty", "empty", "empty", "road", "empty", "empty", "empty", "empty", "empty", "road"},
  {"transit", "transit", "empty", "road", "empty", "empty", "empty", "empty", "empty", "road"},
  {"empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "road"},
  {"empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "road"},
  {"empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "road"},
  {"empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "road"},
  {"empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty", "road"},
}

grid_width = 10
grid_height = 10

-- get the infrastructure type at the specified grid cell
function get_infrastructure_type(x, y)
  if x >= 0 and x < #city_grid[1] and y >= 0 and y < #city_grid then
    return city_grid[y + 1][x + 1] -- lua uses 1-based indexing
  else
    return "empty" -- return "empty" for out-of-bounds cells
  end
end

-- add a new variable to track the current infrastructure type
current_infrastructure_type_index = 1
infrastructure_types = {"empty", "road", "transit"}

-- game loop
function _update()
  local prev_x, prev_y = cursor_x, cursor_y

  if btnp(2) then
    cursor_y -= 1
  end
  if btnp(3) then
    cursor_y += 1
  end
  if btnp(0) then
    cursor_x -= 1
  end
  if btnp(1) then
    cursor_x += 1
  end

  -- limit cursor movement within the grid and the simulate button
  cursor_x = mid(0, cursor_x, grid_width - 1)
  cursor_y = mid(0, cursor_y, grid_height)

  -- check if the cursor is on the "simulate" button
  cursor_on_simulate = cursor_y == grid_height
  
  -- if the cursor is on the "simulate" button and z key is pressed, simulate the network
  if cursor_on_simulate and btnp(4) then
    simulate_network()
   -- check if the spacebar is pressed
  if btnp(5) then
    -- cycle through the infrastructure types
    current_infrastructure_type_index = (current_infrastructure_type_index % #infrastructure_types) + 1
    -- place the infrastructure at the cursor position
    place_infrastructure(cursor_x, cursor_y, infrastructure_types[current_infrastructure_type_index])
  end
 end

  if cursor_x ~= prev_x or cursor_y ~= prev_y then
    draw_map()
  end
  
  -- check if the spacebar is pressed
   if btnp(5) then
    -- cycle through the infrastructure types
    current_infrastructure_type_index = (current_infrastructure_type_index % #infrastructure_types) + 1
    -- place the infrastructure at the cursor position
    place_infrastructure(cursor_x, cursor_y, infrastructure_types[current_infrastructure_type_index])
  end
end

-- Add a new function to draw the guide at the bottom
function draw_infrastructure_guide()
  local colors = {
    empty = 1,
    road = 6,
    transit = 12
  }

  local guide_x = 0
  local guide_y = map_height * 8 + 8
  local cell_size = 8

  for i, infrastructure_type in ipairs(infrastructure_types) do
    local color = colors[infrastructure_type] or colors.empty
    rectfill(guide_x, guide_y, guide_x + cell_size - 1, guide_y + cell_size - 1, color)
    print(infrastructure_type, guide_x + cell_size, guide_y, 7)
    guide_x = guide_x + cell_size * 2 + 16
  end
end

-- render function
function _draw()
  cls()
  draw_map()
  draw_infrastructure_guide()

  if not cursor_on_simulate then
    rectfill(simulate_btn.x, simulate_btn.y, simulate_btn.x + simulate_btn.width, simulate_btn.y + simulate_btn.height, simulate_btn.color)
    print("simulate", simulate_btn.x + 4, simulate_btn.y + 2, 1)
  end
end

-- draw the "simulate network" button
function draw_simulate_button()
  rectfill(simulate_btn.x, simulate_btn.y, simulate_btn.x + simulate_btn.width, simulate_btn.y + simulate_btn.height, 12)
  print("simulate", simulate_btn.x + 8, simulate_btn.y + 1, 0)
end

-- simulate the network and display results
function simulate_network()
  simulation_running = true
  
  -- run the travel demand model simulation
  -- this is where you would add your model-specific code to simulate the network and calculate the travel times, congestion levels, etc.
  local example_travel_time = 42
  local example_congestion_level = 0.75
  
  -- format the results
  simulation_results = "travel time: " .. example_travel_time .. "\ncongestion level: " .. flr(example_congestion_level * 100) .. "%"
end

-- place infrastructure at cursor location
function place_infrastructure(x, y, infrastructure_type)
  city_grid[y + 1][x + 1] = infrastructure_type
end

-- draw a map of the infrastructure
function draw_map()
  -- define colors for different infrastructure types
  local colors = {
    empty = 1,  -- dark gray
    road = 6,   -- light gray
    transit = 12 -- blue
  }

  -- cell size in pixels
  local cell_size = 8

  -- iterate through all grid cells
  for x = 0, map_width - 1 do
    for y = 0, map_height - 1 do
      local infrastructure_type = get_infrastructure_type(x, y)
      local color = colors[infrastructure_type] or colors.empty

      -- draw a rectangle for the current cell
      rectfill(x * cell_size, y * cell_size, (x + 1) * cell_size - 1, (y + 1) * cell_size - 1, color)
    end
  end
  -- draw the cursor
  if not cursor_on_simulate then
    rect(cursor_x * cell_size, cursor_y * cell_size, (cursor_x + 1) * cell_size - 1, (cursor_y + 1) * cell_size - 1, 7)
  else
    rectfill(simulate_btn.x, simulate_btn.y, simulate_btn.x + simulate_btn.width, simulate_btn.y + simulate_btn.height, 6)
    print("simulate", simulate_btn.x + 4, simulate_btn.y + 2, 1)
  end
end
  


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
