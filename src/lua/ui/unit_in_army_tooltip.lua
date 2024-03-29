local function set_unit_in_army_tooltip(component)
  if not SRW_selected_character then return end;
  if not SRW_selected_character:faction():is_human() then return end;
  if not SRW_selected_character:has_military_force() then return end;
  
  local component_name = component:Id()
  local force = SRW_selected_character:military_force()
  local unit_list = force:unit_list()
  local unit_number = component_name:match("(%d+)")

  if unit_number == "0" then return end;
  
  local index = tonumber(unit_number) + helpers.get_num_of_agents(unit_list)
  if (index >= unit_list:num_items()) then return end;

  local unit = unit_list:item_at(index);
  if not unit then return end;

  local unit_name = unit:unit_key();
  local unit_cost, is_basic_cost = helpers.get_supply_params(unit_name)
  
  if not unit_cost then
    unit_cost = helpers.calculate_unit_supply(unit)
  end;

  local supply_text = set_supply_text(unit_cost, is_basic_cost, true)

  helpers.finalize_unit_tooltip(component, supply_text, "||")

end;