local function get_building_var(faction)
  local supply_form_regions = 0
  local regions_list = faction:region_list()

  for i=0, regions_list:num_items()-1 do

    local slot_list = regions_list:item_at(i):slot_list()

    for j=0, slot_list:num_items()-1 do
      if not slot_list:is_empty() then
        if slot_list:item_at(j):has_building() then
          local building = slot_list:item_at(j):building()
          local building_name = building:name()
          --main building hasspecial formula
          if j == 0 then
            supply_form_regions = supply_form_regions - get_main_building_cost(building, faction)
          elseif building_unit_bonus[building_name] then
            supply_form_regions = supply_form_regions + math.min(building_unit_bonus[building_name], max_balance_per_buildings)
          end;         
        end -- of has_building check
      end -- of is_emty check
    end -- of slot loop
  end -- of region loop

  return supply_form_regions
end