local function get_building_var(faction)
  local supply_form_regions = 0
  local owned_regions = faction:region_list()
  --loop through regions
  for i=0, owned_regions:num_items()-1 do

    local slot_list = owned_regions:item_at(i):slot_list()

    for j=0, slot_list:num_items()-1 do
      if not slot_list:is_empty() then
        if slot_list:item_at(j):has_building() then
          local building = slot_list:item_at(j):building()
          local building_name = building:name()

          if(j == 0) then
            supply_form_regions = supply_form_regions - get_main_building_cost(building, faction)
          end;

          if building_unit_bonus[building_name] then
            supply_form_regions = supply_form_regions + math.min(building_unit_bonus[building_name], max_balance_per_buildings)
          end            
        end
      end
    end
  end

  return supply_form_regions
end